// Verbindung zur Datenbank (Supabase).
// Beide Werte stehen in Supabase unter Project Settings → API.
// Der "anon"/"publishable" Schlüssel darf öffentlich sein: Die Tabelle ist per
// Row Level Security so geschützt, dass jedes Konto nur seine eigenen Daten sieht.
window.QUEST_CONFIG = {
  supabaseUrl: 'https://vazmbgsfquwipidjkpta.supabase.co',
  supabaseKey: 'sb_publishable_V_HElacJj6Vc1DPMAT4rKA_vbRw7p5h'
};
