# Balaji Automobiles CRM V2 — Shared Cloud Version

This version uses Supabase so enquiries can be shared between the showroom PC and phones.

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase.sql`.
3. Create your first account in the app after putting the Supabase URL/key in `config.js`.
4. In Supabase Table Editor -> profiles, change that first user's role from `staff` to `admin`.
5. Put the values in `config.js`:
   - SUPABASE_URL
   - SUPABASE_ANON_KEY
6. Upload all files to the GitHub repository root.
7. GitHub Pages will publish the app.

## Files
- index.html
- app.js
- style.css
- config.js
- supabase.sql

## Important
The anon key is intended for browser use; security comes from Supabase Row Level Security policies. Never put a Supabase service-role/secret key in this project.
