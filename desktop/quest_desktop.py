"""Quest als Desktop-App: öffnet docs/index.html in einem eigenen Fenster.

Starten:  pythonw desktop\\quest_desktop.py   (oder über die Verknüpfung "Quest")
Benötigt: pip install pywebview
"""
import os
import webview

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
INDEX = os.path.join(ROOT, "docs", "index.html")
ICON = os.path.join(HERE, "quest.ico")
# Fester Ort für Anmeldung und lokalen Zwischenspeicher, damit beides Neustarts übersteht.
STORAGE = os.path.join(os.environ.get("LOCALAPPDATA", HERE), "QuestApp")
# Fester Port, damit der Browser-Speicher der App immer derselbe bleibt.
PORT = 47811


def port_in_use():
    import socket
    with socket.socket() as s:
        return s.connect_ex(("127.0.0.1", PORT)) == 0


def main():
    if port_in_use():
        import ctypes
        ctypes.windll.user32.MessageBoxW(None, "Quest läuft schon. Schau in der Taskleiste nach dem offenen Fenster.", "Quest", 0x40)
        return
    os.makedirs(STORAGE, exist_ok=True)
    webview.create_window(
        "Quest",
        url=INDEX,
        width=1280,
        height=820,
        min_size=(420, 560),
        background_color="#0f1012",
        text_select=True,
    )
    webview.start(
        http_server=True,
        http_port=PORT,
        private_mode=False,
        storage_path=STORAGE,
        icon=ICON if os.path.exists(ICON) else None,
    )


if __name__ == "__main__":
    main()
