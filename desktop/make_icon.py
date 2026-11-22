"""Erzeugt desktop/quest.ico (Ring-Logo) ohne Zusatzpakete."""
import math
import os
import struct
import zlib

BG = (15, 16, 18)
RING = (242, 184, 75)
DOT = (236, 236, 238)


def png(size):
    c = size / 2
    r_out, r_in, r_dot = size * 0.40, size * 0.29, size * 0.12
    corner = size * 0.22
    rows = []
    for y in range(size):
        row = bytearray([0])
        for x in range(size):
            px, py = x + 0.5, y + 0.5
            # abgerundetes Quadrat als Hintergrund
            dx = max(abs(px - c) - (c - corner), 0)
            dy = max(abs(py - c) - (c - corner), 0)
            inside = dx * dx + dy * dy <= corner * corner
            d = math.hypot(px - c, py - c)
            ang = (math.degrees(math.atan2(py - c, px - c)) + 90) % 360
            if not inside:
                row += bytes((0, 0, 0, 0))
            elif r_in <= d <= r_out and ang < 290:
                row += bytes((*RING, 255))
            elif d <= r_dot:
                row += bytes((*DOT, 255))
            else:
                row += bytes((*BG, 255))
        rows.append(bytes(row))
    raw = zlib.compress(b"".join(rows), 9)

    def chunk(tag, data):
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", raw) + chunk(b"IEND", b"")


def main():
    sizes = [16, 32, 48, 256]
    images = [png(s) for s in sizes]
    header = struct.pack("<HHH", 0, 1, len(sizes))
    offset = 6 + 16 * len(sizes)
    entries = b""
    for s, img in zip(sizes, images):
        entries += struct.pack("<BBBBHHII", s % 256, s % 256, 0, 0, 1, 32, len(img), offset)
        offset += len(img)
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quest.ico")
    with open(out, "wb") as f:
        f.write(header + entries + b"".join(images))
    print("geschrieben:", out)


if __name__ == "__main__":
    main()
