# Quest

Persönlicher Task-Manager nach dem Quest-Prinzip: Tage statt Zeitblöcke, eine Aufgabe zur Zeit, Zeit messen, Done-Liste, wöchentliches Review und Quest-Stunden als Input-Ziel.

Online unter https://rallski.github.io/quest/

## Aufbau

| Datei | Inhalt |
|---|---|
| `docs/index.html` | Die App selbst. Wird über GitHub Pages ausgeliefert. |
| `docs/config.js` | Verbindung zum Supabase-Server. |
| `docs/` (Rest) | Symbole für Browser-Tab und Homescreen. |
| `supabase.sql` | Legt die Datenbank-Tabelle an. Einmal im Supabase SQL Editor ausführen. |

## Wo die Daten liegen

- **Mit Konto (Supabase):** in der Tabelle `quest_state`, eine Zeile pro Konto. Browser und Handy zeigen denselben Stand. Jedes Gerät behält zusätzlich eine Kopie, damit die App auch offline läuft. Bei Änderungen auf zwei Geräten gleichzeitig gewinnt der neuere Stand.
- **Ohne Konto:** nur im Speicher des jeweiligen Browsers.
- **Sichern:** Einstellungen → „Alle Daten kopieren“. Wiederherstellen: Daten einfügen → „Importieren“.

## Server einrichten (einmalig)

1. Auf supabase.com ein kostenloses Projekt anlegen.
2. Im SQL Editor den Inhalt von `supabase.sql` ausführen.
3. Unter Project Settings → API die Project URL und den anon/publishable Key in `docs/config.js` eintragen.
4. App öffnen, „Konto anlegen“.
