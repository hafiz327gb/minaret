# Minaret – web version

Prayer times, Qibla direction and Hijri calendar, running entirely in the browser (no server, works offline once opened).
It is a port of the Windows program **Minaret** by Kamal Abdali; the astronomy follows the original Visual Basic 6 source in
[`../minaret-master/vb6-src`](../minaret-master/vb6-src) (`Sun.bas`, `Moon.bas`), which is kept unchanged in spirit and also
carries the same additions.

## New in this version
* **Ishraq** – when, after sunrise, the sun's centre is **1.4°** above the horizon.
* **Asr Makruh** – when, before sunset, the sun's centre is still **2.3°** above the horizon (lasts till Maghrib).

Both appear in the Prayer tables (day, month, year, perpetual and Hijri-month) and can be tuned in *Options*.

## Run it
Open `index.html` in a browser, or serve the folder:

    cd web && python3 -m http.server 8000     # then open http://localhost:8000

Installable as an app on phones (PWA: *Add to Home screen*). The `.github/workflows/pages.yml` workflow tests the code and
publishes this folder to GitHub Pages (enable *Settings → Pages → Source: GitHub Actions* once).

## Layout
| Path | What |
|---|---|
| `js/minaret-core.js` | Calculations (prayer times, qibla, Hijri/moon). Works in browsers and Node. |
| `js/app.js`, `css/style.css`, `index.html` | The interface |
| `data/gazetteer.json`, `data/gazetteer.js` | 713 places, converted from `minaret-master/gazette.dta` by `tools/make_gazetteer.py` |
| `tests/test_core.js` | `node web/tests/test_core.js` – checks every time against an independent solar-position algorithm |

## Accuracy
Prayer times are checked at the sun's altitude (Fajr/Isha angle, ±0.83° sunrise/sunset, Ishraq, Asr Makruh, Asr shadow ratio)
using the NOAA solar-position algorithm for 7 cities and 6 dates (±0.12°, i.e. well under a minute at these latitudes). The Hijri
date uses the original program's rule (crescent assumed visible 1.08 days after the astronomical new moon), so it can differ by a day
from local moon-sighting announcements.
