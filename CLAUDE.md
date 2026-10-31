# Bullet Journal (webapp)

Digitale bullet journal voor Bert, bruikbaar op het werk zonder installatie: alleen een browser.

## Opzet
- App: `index.html` (HTML + CSS + JS, geen build). Taal van de UI: Nederlands.
- PWA: `manifest.webmanifest`, `sw.js` (service worker, `VERSION` ophogen bij wijzigingen aan de app-schil), `icons/`.
- `vendor/supabase.js` = lokale kopie van supabase-js (UMD, v2.118.0), zodat er geen CDN nodig is (werknetwerk). Updaten: `npm i @supabase/supabase-js` en `dist/umd/supabase.js` kopiëren.
- Backend: Supabase-project **Huishouden** (`vlhjikyslkkekxtapzqj`, regio eu-west-3), tabel `public.bujo_entries`.
- Publishable key staat in `index.html` (hoort publiek te zijn; beveiliging zit in RLS).
- Service worker cachet alleen same-origin bestanden; data van Supabase wordt nooit gecachet (zonder netwerk laadt de schil wel, maar de data niet).
- Hosting: GitHub Pages, zoals de andere apps (alles staat in de root van de repo, paden zijn relatief).

## Beveiliging
- Inloggen met e-mail + wachtwoord (Supabase Auth). RLS-policy `bujo eigen entries`: alleen `authenticated`, alleen eigen rijen (`user_id = auth.uid()`).
- Let op: dit wijkt bewust af van de andere Huishouden-tabellen (die staan open voor `public`).

## Datamodel `bujo_entries`
`log` (daily | monthly | future), `log_date` (dag, of 1e van de maand), `kind` (task | event | note),
`status` (open | done | migrated | scheduled | cancelled), `priority`, `content`, `migrated_from`, `created_at`, `updated_at`.

## Bullets
`•` taak, `✕` gedaan, `>` doorgeschoven, `<` ingepland in Toekomst, `○` afspraak, `–` notitie, `*` prioriteit.
Invoer-syntax: `. taak`, `o afspraak`, `- notitie`, `* ` ervoor = prioriteit.

## Schermen
Dag (met banner voor open taken van eerdere dagen), Maand (met items uit Toekomst), Toekomst (6 maanden), Opruimen (migratie-review).

## Werkafspraken
- Geen achtergrondprocessen starten; alleen doen wat besproken is.
- Schema-wijzigingen via Supabase-migraties, niet met losse SQL.
