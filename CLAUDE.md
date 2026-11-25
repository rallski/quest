# Quest – Projektnotizen für Claude

Persönlicher Task-Manager nach dem Quest-Prinzip (Tage statt Zeitblöcke, Fokus-Timer, Quest-Stunden, Wochen-Review).
Der Nutzer spricht Deutsch, ist kein Entwickler und möchte eine schlichte, gut bedienbare Oberfläche.

## Wo was liegt
- **App:** `docs/index.html` (eine Datei, HTML/CSS/JS ohne Build). Online unter https://rallski.github.io/quest/ (GitHub Pages aus `main` / `docs`).
- **Server:** Supabase-Projekt `vazmbgsfquwipidjkpta`, Tabelle `public.quest_state` (eine Zeile pro Konto, `state` jsonb, `updated_at` ms; neuerer Stand gewinnt). Zugangsdaten für die App in `docs/config.js`. Schema in `supabase.sql`. Sicherung des alten Stands in `public.quest_backup`.
- **Notion:** Seite „Quest-Zentrale“ mit Datenbank „Material“ für Notizen, Transkripte, Links. Die Quest-App plant, Notion enthält die Arbeit.
- **Desktop-Start** (`desktop/`) wird nicht mehr genutzt; der Nutzer arbeitet im Browser.
- `artifact/quest.html` ist die alte Online-Version auf claude.ai (nicht weiterentwickeln).

## Datenmodell (state)
quests (id, title, desc, target, color, icon, notes, tracking, archived), tasks (id, title, questId, day, order, seconds, doneAt, notes, recurId, exercises), sessions (id, q, t, s, e), recurring (Regeln mit freq/interval/days/pin/start/end/made/exercises), logs (Fortschritt: type reps|hold|count, unit, vals), milestones, reviews, settings (weeklyTarget, vision, theme).

## Arbeitsweise
- Änderungen lokal testen: `python -m http.server 8766 --bind 127.0.0.1` im Projektordner, dann im Browser `http://127.0.0.1:8766/docs/index.html?v=N` (Query gegen Cache). Testdaten danach wieder entfernen.
- Veröffentlichen: committen und `git push` (SSH-Schlüssel ist eingerichtet, `GIT_SSH_COMMAND='ssh -o BatchMode=yes'`). Nach 1–2 Minuten online.
- Echte Nutzerdaten nur lesen; ändern nur auf ausdrücklichen Wunsch und dann `updated_at` und `state.updatedAt` hochsetzen.
- Fortschritt-Tracking erscheint nur bei Quests mit `tracking: true` (aktuell „Hobby & Freizeit“).
- UI-Wünsche des Nutzers bisher: keine unnötigen Eingaben (keine Namen, wo nicht nötig), Dinge nach dem Eintragen zuklappen, nichts darf beim Klicken nach oben springen, Timer nur im Fokus.
