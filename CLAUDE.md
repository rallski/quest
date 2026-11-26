# Quest – Projektnotizen für Claude

Persönlicher Task-Manager nach dem Quest-Prinzip (Tage statt Zeitblöcke, Fokus-Timer, Quest-Stunden, Wochen-Review).
Der Nutzer spricht Deutsch, ist kein Entwickler und möchte eine schlichte, gut bedienbare Oberfläche.

## Kommunikation
- Immer auf Deutsch antworten, kurz und in einfachen Worten (keine Fachbegriffe ohne Erklärung).
- Der Nutzer achtet auf Kontextverbrauch: knappe Antworten, wenige Bilder.
- Dieses Repository ist öffentlich: keine persönlichen Daten, Passwörter, E-Mail-Adressen oder privaten Links in Dateien schreiben.

## Wo was liegt
- **App:** `docs/index.html` (eine Datei, HTML/CSS/JS ohne Build). Online unter https://rallski.github.io/quest/ (GitHub Pages aus `main` / `docs`).
- **Server:** Supabase-Projekt `vazmbgsfquwipidjkpta`, Tabelle `public.quest_state` (eine Zeile pro Konto, `state` jsonb, `updated_at` ms; neuerer Stand gewinnt). Zugangsdaten für die App in `docs/config.js` (öffentlicher Schlüssel, Schutz über RLS). Schema in `supabase.sql`. Sicherung des alten Stands in `public.quest_backup`. Speichergrenze pro Konto per Trigger (Standard 2 MB, eigenes Konto 20 MB in `public.quest_limits`), höchstens 100 Konten (Trigger auf `auth.users`). Die App zeigt die Nutzung in den Einstellungen und warnt ab 75 %. Zugriff für Claude über den Supabase-Connector (`execute_sql`).
- **Notion:** Seite „Quest-Zentrale“ mit Datenbank „Material“ für Notizen, Transkripte, Links. Die Quest-App plant, Notion enthält die Arbeit. Dazu die private Seite „Mein Assistent – Zielbild“ (Plan für einen persönlichen Assistenten mit Notion als Wissensbasis); vor Arbeit an diesem Thema zuerst lesen.

## Datenmodell (state)
quests (id, title, desc, target, color, icon, notes, tracking, archived), tasks (id, title, questId, day, order, seconds, doneAt, notes, recurId, exercises), sessions (id, q, t, s, e), recurring (Regeln mit freq/interval/days/pin/start/end/made/exercises), logs (Fortschritt: type reps|hold|count, unit, vals), milestones, reviews, settings (weeklyTarget, vision, theme).

## Arbeitsweise
- Echte Nutzerdaten nur lesen; ändern nur auf ausdrücklichen Wunsch und dann `updated_at` und `state.updatedAt` hochsetzen. Tests nie mit dem Konto des Nutzers, sondern lokal ohne Anmeldung.
- Vor jedem Veröffentlichen `APP_VERSION` in `docs/index.html` um 0.01 erhöhen (1.01, 1.02, …; kein Datum, keine Uhrzeit). Sie wird unten links unter „Synchronisiert“ angezeigt, damit der Nutzer sieht, ob die neue Version da ist.
- GitHub Pages hat ein weiches Limit von etwa 10 Veröffentlichungen pro Stunde: viele kleine Korrekturen bündeln.
- Veröffentlichen: committen und nach `main` pushen. Nach 1–2 Minuten online; nach dem Push fertig, nicht auf das Online-Gehen warten.
- Dateien mit Python/Bash bearbeiten, nicht mit PowerShell `Set-Content` (fügt ein BOM-Zeichen ein).

## Testen
- Lokal: `python -m http.server 8766 --bind 127.0.0.1` im Projektordner, dann `http://127.0.0.1:8766/docs/index.html?v=N` (Query gegen Cache). Testdaten und localStorage danach wieder entfernen.
- Abläufe (Speichern, Timer, Tracking, Daten): ohne Screenshots, nur per JavaScript prüfen (Texte, Maße, Scrollwerte, Konsolenfehler).
- Aussehen: höchstens ein kleines, verkleinertes Bild pro Ansicht.
- Immer in der Bildschirmbreite des Nutzers testen (ca. 1900 × 850 px), zusätzlich Handy (375 px), wenn das Handy betroffen ist. Im Bericht kurz sagen, in welchen Breiten getestet wurde.
- In der Cloud (ohne eingebauten Browser): soweit möglich per Skript prüfen (z. B. Headless-Browser) und dem Nutzer sagen, was er selbst anschauen sollte.

## Stand und Vorlieben
- Alte Desktop-App (`desktop/`) und claude.ai-Version (`artifact/`) wurden am 25.11.2026 entfernt; der Nutzer arbeitet nur im Browser (PC und Handy).
- Layout: Die Seite scrollt am PC nie als Ganzes, nur einzelne Bereiche (`.vbody`, `.vsplit`, `.plansplit`). Am Handy (≤ 860 px) scrollt die ganze Seite, außer im Wochenkalender. Plan am Handy startet mit „3 Tage“ ab heute.
- Fortschritt-Tracking erscheint nur bei Quests mit `tracking: true`; Schalter „Fortschritt tracken“ im Dialog „Quest bearbeiten“. Im Fokus kann man Tracker klein hinzufügen und entfernen.
- Fokus-Musik (YouTube-Player) wurde ausprobiert und auf Wunsch wieder entfernt.
- UI-Wünsche: keine unnötigen Eingaben (keine Namen, wo nicht nötig), keine grauen Beispiel-Platzhalter, Dinge nach dem Eintragen zuklappen, nichts darf beim Klicken nach oben springen, Timer nur im Fokus und groß, alles drumherum klein.

## Offene Ideen (noch nicht entschieden)
- Liegengebliebene Aufgaben: wiederkehrende Aufgaben sammeln sich unter „Offen von früher“ an; Vorschlag: verpasste wiederkehrende einfach verschwinden lassen.
- „Tagesstart“ in Heute: beim ersten Öffnen am Tag Liegengebliebenes sortieren (heute / später / verwerfen) und 1–3 wichtigste Aufgaben wählen.
- Erledigte Aufgaben in Heute einklappen.
