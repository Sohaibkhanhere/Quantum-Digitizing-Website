# Quantum Digitizing — Setup Guide

## Files in This Package
- `index.html` — Main landing page (same stunning aesthetic as Patch Vision)
- `supabase-config.js` — Database config (update with your credentials)
- `supabase-setup.sql` — Run this in your new Supabase project

---

## Step 1 — Update Your Info

Search and replace these placeholders in `index.html` and `supabase-config.js`:

| Placeholder | Replace With |
|---|---|
| `923001234567` | Your actual WhatsApp number (with country code, no +) |
| `quantumdigitizing@gmail.com` | Your actual email address |
| `https://instagram.com/quantumdigitizing` | Your Instagram URL |
| `https://facebook.com/quantumdigitizing` | Your Facebook URL |

---

## Step 2 — Create New Supabase Project

1. Go to https://supabase.com/dashboard
2. Click **New Project**
3. Name it: `quantum-digitizing`
4. Copy your **Project URL** and **anon public key**
5. Paste them into `supabase-config.js`

---

## Step 3 — Run the SQL

1. In your Supabase dashboard → **SQL Editor**
2. Click **New Query**
3. Paste the contents of `supabase-setup.sql`
4. Click **Run**

---

## Step 4 — Copy Auth, Orders, Admin Pages

When you're ready, I can also create for Quantum Digitizing:
- `auth.html` — Login/Signup page
- `orders.html` — Customer dashboard  
- `admin.html` — Admin panel
- `checkout.html` — Order & payment flow

Just ask and we'll build each page!

---

## What's Different from Patch Vision

| Patch Vision | Quantum Digitizing |
|---|---|
| `PATCH VISION` branding | `QUANTUM DIGITIZING` branding |
| `patchvision@gmail.com` | Your QD email |
| Patch Vision social links | QD social links |
| Patch Vision Supabase DB | NEW separate QD Supabase DB |
| Patch Vision WhatsApp | QD WhatsApp |

The design DNA, animations, and structure are the same — just fully rebranded.
