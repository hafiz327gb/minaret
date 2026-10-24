# Minaret – web version

Prayer times, Qibla direction and Hijri calendar, running entirely in the browser (no server, works offline once opened).
It is a port of the Windows program **Minaret** by Kamal Abdali; the astronomy follows the original Visual Basic 6 source in
[`../minaret-master/vb6-src`](../minaret-master/vb6-src) (`Sun.bas`, `Moon.bas`), which is kept unchanged in spirit and also
carries the same additions.

## New in this version
* **Ishraq** – when, after sunrise, the sun's centre is **1.4°** above the horizon.
* **Asr Makruh** – when, before sunset, the sun's centre is still **2.3°** above the horizon (lasts till Maghrib).

Both appear in the Prayer tables (day, month, year, perpetual and Hijri-month) and can be tuned in *Options*.
* **Several Fajr / Isha angles** – in *Options* enter e.g. `15, 18`; every table then gets its own columns (Fajr15, Fajr18, Isha15, Isha18).

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

## Calculation methods, Asr and Location

- **Options → Calculation method**: MWL, ISNA, Egypt, Makkah (Umm al-Qura), Karachi (UIS), JTR KHI, Tehran, Jafari, France, Russia, Singapore, or **Custom** (all fields: Fajr/Isha angles or Isha interval, Maghrib sun angle, Ishraq/Asr Makruh altitudes). Several angles separated by commas give one column each (Fajr15, Fajr18…).
- **Asr** is always shown twice: 1× (Shafi‘i, Maliki, Hanbali) and 2× (Hanafi).
- **Location**: search and pick a city from the list; its coordinates, time zone and DST rule fill the form at the right, where they can be edited and saved as your own place. A geolocation button is also provided.
- **Options → Adjust times**: add or subtract whole minutes (−120…+120) for any time. With several Fajr/Isha angles (or a method with one) every angle gets its own row; adjusted columns show e.g. "· −5m" in their header. Display only; saved with the settings.
- **Midday / Zuhr / Chasht**: *Midday* (نصف النہار) is solar noon; *Zuhr* is Midday + 5 minutes; *Chasht* (چاشت) is a quarter of the way from sunrise to midday.
- **Prayer → Specific dates**: choose a start and end date; every day in between is shown, one table per month (up to three years), with CSV/Print/Copy like the other modes.
- **Prayer → Ramazan 1448H**: Sehri/Iftar timetable for 2027 (starting 8 or 9 Feb, ending 9 Mar 2027): Sehri end = Fajr 18° − 2 min, Fajr azan = Fajr 15°, Iftar = sunset + 2 min; with the Urdu precaution note and CSV.
