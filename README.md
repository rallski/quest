# Quest

Persönlicher Task-Manager nach dem Quest-Prinzip: Tage statt Zeitblöcke, eine Aufgabe zur Zeit, Zeit messen, Done-Liste, wöchentliches Review und Quest-Stunden als Input-Ziel.

## Aufbau

| Ordner | Inhalt |
|---|---|
| `docs/` | Die App selbst (`index.html`) und die Server-Verbindung (`config.js`). Wird auch als Webseite über GitHub Pages ausgeliefert. |
| `desktop/` | Startet die App in einem eigenen Fenster (`quest_desktop.py`), Symbol und Skript für die Verknüpfungen. |
| `supabase.sql` | Legt die Datenbank-Tabelle an. Einmal im Supabase SQL Editor ausführen. |
| `artifact/` | Quelle der Online-Version auf claude.ai. |

## Wo die Daten liegen

- **Mit Konto (Supabase):** in der Tabelle `quest_state`, eine Zeile pro Konto. Desktop-App, Browser und Handy zeigen denselben Stand. Jedes Gerät behält zusätzlich eine Kopie, damit die App auch offline läuft. Bei Änderungen auf zwei Geräten gleichzeitig gewinnt der neuere Stand.
- **Ohne Konto:** nur im Speicher des jeweiligen Fensters bzw. Browsers. Die Desktop-App speichert unter `%LOCALAPPDATA%\QuestApp`.
- **Sichern:** Einstellungen → „Alle Daten kopieren“. Wiederherstellen: Daten einfügen → „Importieren“.

## Desktop-App

Benötigt Python 3 und `pip install pywebview`.

```powershell
python desktop\quest_desktop.py
```

Verknüpfung auf Desktop und im Startmenü anlegen:

```powershell
powershell -ExecutionPolicy Bypass -File desktop\install_shortcut.ps1
```

## Server einrichten (einmalig)

1. Auf supabase.com ein kostenloses Projekt anlegen.
2. Im SQL Editor den Inhalt von `supabase.sql` ausführen.
3. Unter Project Settings → API die Project URL und den anon/publishable Key in `docs/config.js` eintragen.
4. App öffnen, „Konto anlegen“.
