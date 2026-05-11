// ============================================================
//  QUANTUM DIGITIZING — SHARED CONFIGURATION
// ============================================================

const CONFIG = {
  SUPABASE_URL: 'https://simzxwhnnpradsvpknkr.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpbXp4d2hubnByYWRzdnBrbmtyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyNTk4NTIsImV4cCI6MjA5MzgzNTg1Mn0.wPN8OghT3vzuWXNd5v_pyIyGBrh5nxGydYavn2Y73AA',
  WHATSAPP: '923352335961',
  EMAIL: 'sales@quantumdigitizing.com'
};

// Initialize Supabase Client
let supabase = null;
if (window.supabase) {
  const { createClient } = window.supabase;
  supabase = createClient(CONFIG.SUPABASE_URL, CONFIG.SUPABASE_ANON_KEY);
} else {
  console.error('Supabase library not loaded. Check CDN or internet connection.');
}

// Utility: Check Session
async function checkAuth(redirectOnFail = false) {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session && redirectOnFail) {
    window.location.href = `auth.html?redirect=${encodeURIComponent(window.location.pathname)}`;
  }
  return session;
}

// Utility: Get User Profile
async function getProfile(uid) {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', uid)
    .single();
  return { data, error };
}

// Utility: Show Toast
function showToast(msg, type = 'success') {
  let toast = document.getElementById('toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'toast';
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.textContent = msg;
  toast.className = `toast show ${type}`;
  setTimeout(() => toast.classList.remove('show'), 4000);
}

// Global Exports
window.QD = {
  config: CONFIG,
  supabase,
  checkAuth,
  getProfile,
  showToast
};
