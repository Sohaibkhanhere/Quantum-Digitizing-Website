-- ============================================================
--  QUANTUM DIGITIZING — FULL DATABASE SCHEMA
-- ============================================================

-- 1. PROFILES (Extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  full_name TEXT,
  email TEXT,
  role TEXT DEFAULT 'client' CHECK (role IN ('client', 'admin')),
  whatsapp TEXT,
  avatar_url TEXT,
  wallet_balance NUMERIC DEFAULT 0
);

-- 2. CATEGORIES
CREATE TABLE IF NOT EXISTS categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  image_url TEXT,
  parent_id UUID REFERENCES categories(id) ON DELETE CASCADE
);

-- 3. PRODUCTS (Shop Items)
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  price NUMERIC NOT NULL,
  image_url TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  in_stock BOOLEAN DEFAULT TRUE,
  metadata JSONB DEFAULT '{}'
);

-- 4. ORDERS (Combined Services & Products)
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  
  -- Customer Info
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_whatsapp TEXT,
  
  -- Order Details
  order_type TEXT NOT NULL CHECK (order_type IN ('service', 'product')),
  service_type TEXT CHECK (service_type IN ('digitizing', 'vector', 'patch', 'apparel')),
  
  -- Service Specifics
  garment_type TEXT,
  dimensions TEXT, -- e.g. "4x3"
  color_count INTEGER,
  rush BOOLEAN DEFAULT FALSE,
  
  -- Product Specifics (JSON array of items)
  items JSONB DEFAULT '[]',
  
  -- Shared
  notes TEXT,
  total_price NUMERIC NOT NULL,
  status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled', 'Revision')),
  payment_status TEXT DEFAULT 'Unpaid' CHECK (payment_status IN ('Unpaid', 'Paid', 'Refunded')),
  
  -- Files
  input_file_url TEXT,
  output_file_url TEXT
);

-- 5. PORTFOLIO
CREATE TABLE IF NOT EXISTS portfolio (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  title TEXT NOT NULL,
  category TEXT NOT NULL, -- e.g. 'Digitizing', 'Vector'
  image_url TEXT,
  description TEXT
);

-- 6. PROMO CONFIG (CMS)
CREATE TABLE IF NOT EXISTS promo_config (
  id INTEGER PRIMARY KEY DEFAULT 1,
  config JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
--  ROW LEVEL SECURITY (RLS)
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio ENABLE ROW LEVEL SECURITY;
ALTER TABLE promo_config ENABLE ROW LEVEL SECURITY;

-- Profiles: Users see their own
CREATE POLICY "Users can see own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Categories & Products: Public read
CREATE POLICY "Public read categories" ON categories FOR SELECT USING (TRUE);
CREATE POLICY "Public read products" ON products FOR SELECT USING (TRUE);

-- Orders: Users see their own
CREATE POLICY "Users can see own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id OR auth.uid() IS NULL);

-- Admin Access (Example using role column)
CREATE POLICY "Admins have full access" ON orders FOR ALL 
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- ============================================================
--  FUNCTIONS & TRIGGERS
-- ============================================================

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
