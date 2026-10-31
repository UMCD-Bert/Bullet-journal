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

## GitHub
- Repo `Bullet-journal` onder account `UMCD-Bert` → live op https://umcd-bert.github.io/Bullet-journal/ (aangemaakt en Pages aangezet op 31-10-2026, branch `main`, root).
- Een nieuwe openbare repo aanmaken blokkeert de auto-modus van Claude; dat commando voert Bert zelf uit (Run-knop). Pushen naar een bestaande repo mag Claude gewoon.
- GitHub Pages vereist de letterlijke bestandsnaam `index.html`.

## Werkafspraken — ALTIJD aanhouden (zelfde als de andere apps)
1. Wacht op expliciete GO voordat je gaat coderen, ook bij kleine instructies. Wensen die één voor één binnenkomen alleen loggen tot "ga bouwen".
2. SQL-wijzigingen eerst als los, copy-pastebaar blok tonen en om goedkeuring vragen; na akkoord uitvoeren via de Supabase MCP-connector. Leg elke wijziging ook vast in `supabase/`.
3. Na elke niet-triviale JS-wijziging een korte smoke-test; testregels direct weer opruimen.
4. Geen achtergrondprocessen starten; alleen doen wat besproken is.
5. Bij wijzigingen aan de app-schil (`index.html`, `vendor/`, iconen, manifest): `VERSION` in `sw.js` ophogen, anders zien geïnstalleerde apps de wijziging niet.

## Status
- v1: Dag, Maand, Toekomst, Opruimen; inloggen met e-mail + wachtwoord; PWA. Tabel `bujo_entries` is aangemaakt in Huishouden (zie `supabase/`).
- Repo op GitHub + Pages: gedaan (31-10-2026).
- Nog te doen: account aanmaken in de app, live testen (ook op het werknetwerk en iPhone).
