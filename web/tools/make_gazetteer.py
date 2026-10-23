#!/usr/bin/env python3
"""Convert Minaret's binary gazette.dta into data/gazetteer.json.

File layout (little endian), as read by GetGztData in Global.bas:
  48 bytes   "current location" record
   7 bytes   options: asrHanafi, fajrByDepr, ishaByDepr, fajrInterval,
             fajrDepr, ishaInterval, ishaDepr
   2 bytes   locCnt  (number of places - 1)
  39 bytes   padding (0xFF)
  48 bytes * (locCnt + 1)  place records
Each 48-byte record: name[29] (space padded), namelen, latD, latM, latIsS,
  lonD, lonM, lonIsW, zoneH, zoneM, zoneIsMinus, hasDST,
  dstStartMonth, dstStartDate, dstStartNum, dstStartDOW,
  dstEndMonth,   dstEndDate,   dstEndNum,   dstEndDOW
"""
import json, struct, sys

def rec(r):
    return {
        "name": r[:29].decode("latin-1").rstrip(" \x00"),
        "latD": r[30], "latM": r[31], "latS": r[32],
        "lonD": r[33], "lonM": r[34], "lonW": r[35],
        "zoneH": r[36], "zoneM": r[37], "zoneNeg": r[38],
        "dst": r[39],
        "dstStart": {"month": r[40], "date": r[41], "num": r[42], "dow": r[43]},
        "dstEnd":   {"month": r[44], "date": r[45], "num": r[46], "dow": r[47]},
    }

def main(src, dst):
    d = open(src, "rb").read()
    opts = d[48:55]
    n = struct.unpack("<h", d[55:57])[0] + 1
    places = [rec(d[96 + 48 * i: 96 + 48 * (i + 1)]) for i in range(n)]
    out = {
        "current": rec(d[:48]),
        "defaults": {
            "asrHanafi": opts[0], "fajrByDepr": opts[1], "ishaByDepr": opts[2],
            "fajrInterval": opts[3], "fajrDepr": opts[4],
            "ishaInterval": opts[5], "ishaDepr": opts[6],
        },
        "places": places,
    }
    text = json.dumps(out, ensure_ascii=False, separators=(",", ":"))
    with open(dst, "w", encoding="utf-8") as f:
        f.write(text)
    # same data as a script, so index.html also works when opened from disk (file://)
    js = dst[:-5] + ".js" if dst.endswith(".json") else dst + ".js"
    with open(js, "w", encoding="utf-8") as f:
        f.write("window.MINARET_GAZETTEER=" + text + ";\n")
    print(f"{n} places -> {dst}, {js}")

if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "../minaret-master/gazette.dta",
         sys.argv[2] if len(sys.argv) > 2 else "data/gazetteer.json")
