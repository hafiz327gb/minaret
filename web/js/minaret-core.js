/*
 * Minaret core - prayer times, qibla and Hijri calendar computations.
 *
 * A JavaScript port of the astronomical routines of "Minaret" (Visual Basic 6,
 * Copyright 1987-1998 Kamal Abdali) found in ../minaret-master/vb6-src
 * (Sun.bas, Moon.bas, Global.bas).  Function names follow the VB6 source so the
 * two can be compared side by side.
 *
 * Additions over the original program:
 *   - Ishraq:      after sunrise, when the sun's centre is `ishraqAlt` (default
 *                  1.4 deg) above the horizon.
 *   - Asr Makruh:  before sunset, from the moment the sun's centre is
 *                  `asrMakruhAlt` (default 2.3 deg) above the horizon.
 *
 * Conventions: angles in radians unless stated; times in decimal hours of the
 * location's zone time; 1e7 means "no such time" (shown as "*").
 * Works in browsers (global `Minaret`) and in Node (module.exports).
 */
(function (root) {
  'use strict';

  var PI = Math.PI, HALF_PI = PI / 2, TWO_PI = 2 * PI, PI4 = PI / 4;
  var DPR = 180 / PI, RPD = PI / 180, HPR = 12 / PI;
  var CRIT_AGE = 1.08;        // crescent assumed visible 0.25 + moon's age (days)
  var YEARPERP = 2022;        // constants year used for perpetual schedules
  var NONE = 1e7;             // "no such time"
  var DEFAULT_ISHRAQ_ALT = 1.4;
  var DEFAULT_ASRMAKRUH_ALT = 2.3;

  var NDMNTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  var NDMNTHCUM = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

  var WEEKDAY = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  var MONTH = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'];
  var HIJRI_MONTH = ['Muharram', 'Safar', 'Rabi I', 'Rabi II', 'Jumada I', 'Jumada II',
    'Rajab', "Sha`ban", 'Ramadan', 'Shawwal', "Zul Qi`da", 'Zul Hijja'];

  // ---------------------------------------------------------------- helpers
  function fix(x) { return Math.trunc(x); }                 // VB Fix()
  function idiv(a, b) { return Math.trunc(a / b); }          // VB "\"
  function fmod(a, b) { return a - fix(a / b) * b; }         // as in Moon.bas
  function deg2rad(d) { return d * RPD; }
  function dm2deg(d, m) { return d + m / 60; }
  function dms2deg(d, m, s) { return d + m / 60 + s / 3600; }
  function hms2h(h, m, s) { return h + m / 60 + s / 3600; }
  function isLeap(y) { return (y % 4 === 0 && (y % 100 !== 0 || y % 400 === 0)) ? 1 : 0; }
  function atan2(y, x) { return (x === 0 && y === 0) ? 0 : Math.atan2(y, x); }

  // -------------------------------------------------------- location object
  /**
   * Build a location from gazetteer-style fields (see tools/make_gazetteer.py).
   * Adds derived radians/hours: lat, lon (east positive), tz (hours east of GMT).
   */
  function makeLocation(p) {
    var lat = deg2rad(dm2deg(p.latD, p.latM)) * (p.latS ? -1 : 1);
    var lon = deg2rad(dm2deg(p.lonD, p.lonM)) * (p.lonW ? -1 : 1);
    var tz = (p.zoneH + p.zoneM / 60) * (p.zoneNeg ? -1 : 1);
    var loc = {
      name: p.name,
      latD: p.latD, latM: p.latM, latS: p.latS ? 1 : 0,
      lonD: p.lonD, lonM: p.lonM, lonW: p.lonW ? 1 : 0,
      zoneH: p.zoneH, zoneM: p.zoneM, zoneNeg: p.zoneNeg ? 1 : 0,
      dst: p.dst ? 1 : 0,
      dstStart: p.dstStart || { month: 3, date: 0, num: 2, dow: 2 },
      dstEnd: p.dstEnd || { month: 11, date: 0, num: 1, dow: 2 },
      lat: lat, lon: lon, tz: tz
    };
    loc.qibla = qibla(loc);
    return loc;
  }

  /** Default prayer-calculation settings (Fajr/Isha 15 deg, standard Asr). */
  function defaultSettings() {
    return {
      asrHanafi: 0,
      fajrByDepr: 1, fajrDepr: 15, fajrInterval: 90,
      ishaByDepr: 1, ishaDepr: 15, ishaInterval: 90,
      ishraqAlt: DEFAULT_ISHRAQ_ALT,
      asrMakruhAlt: DEFAULT_ASRMAKRUH_ALT,
      addHijriDate: 0, addQiblaTime: 0
    };
  }

  // ------------------------------------------------------------------ sun
  function computeConstants(yr) {
    var t = (idiv(yr - 1, 400) - idiv(yr - 1, 100) + idiv(yr - 1, 4) + 365 * yr - 730485.5) / 36525;
    var obl = deg2rad(dms2deg(23, 26, 21.448) - dms2deg(0, 0, 46.815) * t);
    var eccy = 0.016708617 - 0.000042037 * t - 0.0000001236 * t * t;
    return {
      cosobl: Math.cos(obl), sinobl: Math.sin(obl),
      dmlong: deg2rad(36000.7698231 / 36525),
      mlong0: deg2rad(fmod(280.466449 - 0.00030368 * t * t + fmod(36000.7698231 * t, 360), 360)),
      dperigee: deg2rad(1.7195269 / 36525),
      perigee0: deg2rad(fmod(282.937348 + 1.7195269 * t + 0.00045962 * t * t, 360)),
      delsid: hms2h(2400, 3, 4.812866) / 36525,
      sidtm0: fmod(hms2h(6, 41, 50.54841) + fmod(hms2h(2400, 3, 4.812866) * t, 24), 24),
      c1: eccy * (2 - eccy * eccy / 4),
      c2: 5 * eccy * eccy / 4
    };
  }

  /** Zone time of local noon on day `nday` of the year, and sun coaltitude info. */
  function noontime(C, loc, nday) {
    var longh = loc.lon * HPR;
    var days = nday + (12 - longh) / 24;
    var mlong = C.mlong0 + C.dmlong * days;
    var perigee = C.perigee0 + C.dperigee * days;
    var anomaly = mlong - perigee;
    var slong = mlong + C.c1 * Math.sin(anomaly) + C.c2 * Math.sin(anomaly * 2);
    var sinslong = Math.sin(slong);
    var ra = atan2(C.cosobl * sinslong, Math.cos(slong)) * HPR;
    if (ra < 0) ra += 24;
    var decl = Math.asin(C.sinobl * sinslong);
    var locmt = ra - C.delsid * days - C.sidtm0;
    var rslt = locmt - longh + loc.tz;
    if (rslt < 0) rslt += 24; else if (rslt > 24) rslt -= 24;
    return { time: rslt, coaltn: Math.abs(loc.lat - decl) };
  }

  /**
   * Time on day `nday` when the sun's coaltitude is `coalt`; NONE if never.
   * time0 = approximate time; am = true for before-noon phenomena.
   */
  function tempus(C, loc, nday, coalt, time0, am) {
    var longh = loc.lon * HPR;
    var days = nday + (time0 - longh) / 24;
    var mlong = C.mlong0 + C.dmlong * days;
    var perigee = C.perigee0 + C.dperigee * days;
    var anomaly = mlong - perigee;
    var slong = mlong + C.c1 * Math.sin(anomaly) + C.c2 * Math.sin(anomaly * 2);
    var sinslong = Math.sin(slong);
    var ra = atan2(C.cosobl * sinslong, Math.cos(slong)) * HPR;
    if (ra < 0) ra += 24;
    var sindcl = C.sinobl * sinslong;
    var cosha = (Math.cos(coalt) - sindcl * Math.sin(loc.lat)) /
      (Math.sqrt(1 - sindcl * sindcl) * Math.cos(loc.lat));
    if (Math.abs(cosha) > 1) return NONE;
    var ha = Math.acos(cosha) * HPR;
    if (am) ha = 24 - ha;
    var locmt = ha + ra - C.delsid * days - C.sidtm0;
    var rslt = locmt - longh + loc.tz;
    if (rslt < 0) rslt += 24; else if (rslt > 24) rslt -= 24;
    return rslt;
  }

  // ---------------------------------------------------- daylight saving time
  /** Day of year of a "named" day, e.g. 2nd Sunday of March (dow: fri=0, sat=1, sun=2...). */
  function namedDay(aYear, aMonth, aDate, dow, num) {
    var leap = isLeap(aYear);
    var m1 = aYear % 100, m4 = aYear % 400;
    var k;
    if (aDate > 0) {
      k = NDMNTHCUM[aMonth - 1] + aDate;
      if (aMonth > 2) k += leap;
      return k;
    }
    var ndm = (aMonth === 2) ? 28 + leap : NDMNTH[aMonth - 1];
    var refDay = (num > 0) ? NDMNTHCUM[aMonth - 1] + 1 : NDMNTHCUM[aMonth - 1] + ndm;
    if (aMonth > 2) refDay += leap;
    var dowRef = (refDay + idiv(m4, 100) * 124 + 1 + m1 + idiv(m1, 4) - leap) % 7;
    k = refDay - dowRef + dow;
    if (num > 0) {
      if (k < refDay) k += 7;
      k += (num - 1) * 7;
    } else if (k > refDay) {
      k -= 7;
    }
    return k;
  }

  /**
   * Leap-year flag and daylight saving period(s) as 1-based day-of-year ranges.
   * aYear = 0 means a perpetual schedule (April 1 - Oct 31 when DST applies).
   */
  function daylit(aYear, loc) {
    var m4 = aYear % 400, m1 = aYear % 100;
    var r = { leap: (aYear % 4 !== 0 || (m1 === 0 && m4 !== 0)) ? 0 : 1, b1: 367, e1: 0, b2: 367, e2: 0 };
    if (!loc.dst) return r;
    if (aYear === 0) { r.b1 = 92; r.e1 = 92 + 213; return r; }
    r.b1 = namedDay(aYear, loc.dstStart.month, loc.dstStart.date, loc.dstStart.dow, loc.dstStart.num);
    r.e1 = -1 + namedDay(aYear, loc.dstEnd.month, loc.dstEnd.date, loc.dstEnd.dow, loc.dstEnd.num);
    if (r.b1 > r.e1) { r.b2 = r.b1; r.b1 = 1; r.e2 = 365 + r.leap; }
    return r;
  }

  function applyDST(rows, d, keys) {
    function add(b, e) {
      for (var i = b - 1; i <= e - 1; i++) {
        if (!rows[i]) continue;
        for (var j = 0; j < keys.length; j++) rows[i][keys[j]] += 1;
      }
    }
    if (d.e1 !== 0) add(d.b1, d.e1);
    if (d.e2 !== 0) add(d.b2, d.e2);
  }

  // ------------------------------------------------------------ prayer times
  var TIME_KEYS = ['fajr', 'shuruq', 'ishraq', 'zuhr', 'asr', 'asrMakruh', 'maghrib', 'isha'];

  /**
   * Compute the times for days first..last-1 (0-based day numbers of the year).
   * Returns an array indexed by day number of objects with the keys in TIME_KEYS.
   * Daylight saving time is applied from `dstInfo` (as returned by daylit()).
   */
  function compute(aYear, first, last, loc, st, dstInfo) {
    var y = aYear === 0 ? YEARPERP : aYear;
    var C = computeConstants(y);
    var am = true, pm = false, t, l, k;
    var t0 = { fajr: 4, shuruq: 6, asr: 15, maghrib: 18, isha: 20, ishraq: 6.5, makruh: 17.5 };
    var coalt = {
      fajr: deg2rad(90 + st.fajrDepr),
      shuruq: deg2rad(90.83),
      maghrib: deg2rad(90.83),
      isha: deg2rad(90 + st.ishaDepr),
      ishraq: deg2rad(90 - st.ishraqAlt),
      makruh: deg2rad(90 - st.asrMakruhAlt)
    };
    var n = noontime(C, loc, first);
    coalt.asr = Math.atan(1 + st.asrHanafi + Math.tan(n.coaltn));

    function keep(v, def) { return v < 24 ? v : def; }

    // approximate times for the first day; later each day seeds the next
    t0.shuruq = keep(tempus(C, loc, first, coalt.shuruq, t0.shuruq, am), 5);
    t0.asr = keep(tempus(C, loc, first, coalt.asr, t0.asr, pm), 15);
    t0.maghrib = keep(tempus(C, loc, first, coalt.maghrib, t0.maghrib, pm), 21);
    t0.ishraq = keep(tempus(C, loc, first, coalt.ishraq, t0.ishraq, am), 6.5);
    t0.makruh = keep(tempus(C, loc, first, coalt.makruh, t0.makruh, pm), 17.5);
    if (st.fajrByDepr) t0.fajr = keep(tempus(C, loc, first, coalt.fajr, t0.fajr, am), 1);
    else t0.fajr = t0.shuruq - st.fajrInterval / 60;
    if (st.ishaByDepr) t0.isha = keep(tempus(C, loc, first, coalt.isha, t0.isha, pm), 23);
    else t0.isha = t0.maghrib + st.ishaInterval / 60;

    var out = [];
    for (l = first; l < last; l++) {
      k = (l > 59 && aYear === 0) ? l - 1 : l;     // Feb 29 and Mar 1 share times
      var row = {};
      n = noontime(C, loc, k + 1);
      row.zuhr = n.time;
      coalt.asr = Math.atan(1 + st.asrHanafi + Math.tan(n.coaltn));

      t = tempus(C, loc, k + 1, coalt.shuruq, t0.shuruq, am);
      row.shuruq = t; t0.shuruq = keep(t, 5);
      t = tempus(C, loc, k + 1, coalt.asr, t0.asr, pm);
      row.asr = t; t0.asr = keep(t, 15);
      t = tempus(C, loc, k + 1, coalt.maghrib, t0.maghrib, pm);
      row.maghrib = t; t0.maghrib = keep(t, 21);
      t = tempus(C, loc, k + 1, coalt.ishraq, t0.ishraq, am);
      row.ishraq = t; t0.ishraq = keep(t, 6.5);
      t = tempus(C, loc, k + 1, coalt.makruh, t0.makruh, pm);
      row.asrMakruh = t; t0.asrMakruh = t0.makruh = keep(t, 17.5);

      if (st.fajrByDepr) {
        t = tempus(C, loc, k + 1, coalt.fajr, t0.fajr, am);
        row.fajr = t; t0.fajr = keep(t, 1);
      } else {
        t0.fajr = t0.shuruq - st.fajrInterval / 60;
        row.fajr = t0.fajr;
      }
      if (st.ishaByDepr) {
        t = tempus(C, loc, k + 1, coalt.isha, t0.isha, pm);
        row.isha = t; t0.isha = keep(t, 23);
      } else {
        t0.isha = t0.maghrib + st.ishaInterval / 60;
        row.isha = t0.isha;
      }
      out[l] = row;
    }
    applyDST(out, dstInfo, TIME_KEYS);
    return out;
  }

  /** Day of week (1 = Sunday) for the 0-based day `start` of year aYear. */
  function dowOfYearDay(aYear, start, leap) {
    return ((idiv(aYear % 400, 100)) * 124 + aYear % 100 + idiv(aYear % 100, 4) - leap + start + 7) % 7 + 1;
  }

  function monthStart(aMonth, leap) {
    return NDMNTHCUM[aMonth - 1] + (aMonth > 2 ? leap : 0);
  }
  function monthLength(aMonth, leap) {
    return aMonth === 2 ? 28 + leap : NDMNTH[aMonth - 1];
  }

  /** Prayer hours for one day. Returns {times, dow, start}. */
  function daySchedule(aDay, aMonth, aYear, loc, st) {
    var d = daylit(aYear, loc);
    var start = aDay - 1 + NDMNTHCUM[aMonth - 1] + (aMonth > 2 ? d.leap : 0);
    var rows = compute(aYear, start, start + 1, loc, st, d);
    return { times: rows[start], dow: dowOfYearDay(aYear, start, d.leap), start: start };
  }

  /** Optional extra columns for schedules: Hijri date and qibla-shadow time. */
  function decorate(aYear, first, last, rows, loc, st, qibRows) {
    var out = [], ajD;
    if (st.addHijriDate) ajD = augJulDay(aYear, 1, first, 0, 0);
    for (var l = first; l < last; l++) {
      var r = rows[l];
      r.day = null;
      if (st.addHijriDate) {
        ajD += 1;
        var h = augJD2H(ajD, loc.tz);
        r.hijri = pad2(h.month) + '/' + pad2(h.day);
        r.hijriYear = h.year;
      }
      if (st.addQiblaTime && qibRows) {
        var q = qibRows[l];
        r.qibla = (q.a < 0 || q.a > 24) ? q.b : q.a;
      }
      out.push(r);
    }
    return out;
  }

  /**
   * Prayer schedule for a month (aYear = 1901..2200) -> {rows, leap, ...}.
   * Each row: day, dow, plus TIME_KEYS (+ hijri, qibla if requested).
   */
  function monthSchedule(aMonth, aYear, loc, st) {
    var d = daylit(aYear, loc);
    var start = monthStart(aMonth, d.leap), finish = start + monthLength(aMonth, d.leap);
    var rows = compute(aYear, start, finish, loc, st, d);
    var qib = st.addQiblaTime ? computeq1(aYear, start, finish, loc, d) : null;
    var out = decorate(aYear, start, finish, rows, loc, st, qib);
    out.forEach(function (r, i) {
      r.day = i + 1;
      r.dow = aYear === 0 ? 0 : dowOfYearDay(aYear, start + i, d.leap);
    });
    return { year: aYear, month: aMonth, rows: out, leap: d.leap };
  }

  /** Schedule for the 12 months of aYear (0 = perpetual). */
  function yearSchedule(aYear, loc, st) {
    var s = Object.assign({}, st);
    if (aYear === 0) s.addHijriDate = 0;
    var d = daylit(aYear, loc);
    var rows = compute(aYear, 0, 365 + d.leap, loc, s, d);
    var qib = s.addQiblaTime ? computeq1(aYear, 0, 365 + d.leap, loc, d) : null;
    var months = [], start = 0;
    for (var m = 1; m <= 12; m++) {
      var len = monthLength(m, d.leap);
      var out = decorate(aYear, start, start + len, rows, loc, s, qib);
      out.forEach(function (r, i) {
        r.day = i + 1;
        r.dow = aYear === 0 ? 0 : dowOfYearDay(aYear, start + i, d.leap);
      });
      months.push({ year: aYear, month: m, rows: out, leap: d.leap });
      start += len;
    }
    return months;
  }

  /** Schedule for a Hijri month (aYear in AH). */
  function hijriMonthSchedule(aMonth, aYear, loc, st) {
    var first = H2X(aYear, aMonth, 1, loc.tz);
    var nDays = daysInHijriMonth(aYear, aMonth, loc.tz);
    var rows = [], i;
    var cur = { y: first.year, m: first.month, d: first.day };
    // walk day by day through the Gregorian calendar
    var jd = augJulDay(cur.y, cur.m, cur.d, 0, 0);
    var cache = {};
    for (i = 0; i < nDays; i++) {
      var g = caldat(jd + i);
      var key = g.year;
      if (!cache[key]) {
        var dd = daylit(key, loc);
        cache[key] = { d: dd, rows: compute(key, 0, 365 + dd.leap, loc, st, dd) };
      }
      var c = cache[key];
      var doy = NDMNTHCUM[g.month - 1] + g.day - 1 + (g.month > 2 ? c.d.leap : 0);
      var r = Object.assign({}, c.rows[doy]);
      r.day = i + 1;
      r.greg = pad2(g.month) + '/' + pad2(g.day);
      r.gregYear = g.year;
      r.dow = g.dow;
      rows.push(r);
    }
    return { year: aYear, month: aMonth, rows: rows, gregYear: first.year };
  }

  // ---------------------------------------------------------------- qibla
  /** Direction of the qibla in radians, east of north positive. */
  function qibla(loc) {
    var lat0 = 0.3738932, long0 = 0.6950968;      // Makkah
    var dflong = long0 - loc.lon;
    return atan2(Math.sin(dflong), Math.cos(loc.lat) * Math.tan(lat0) - Math.sin(loc.lat) * Math.cos(dflong));
  }

  /** Qibla angle as {deg, min, east}. */
  function qiblaAngle(loc) {
    var a = Math.abs(loc.qibla * DPR), d = fix(a), m = Math.round(60 * (a - d));
    if (m >= 60) { m -= 60; d += 1; }
    return { deg: d, min: m, east: loc.qibla > 0 };
  }

  /**
   * Time on day `nday` (1-based day number of year) when the shadow of a vertical
   * object has bearing `bearing` (clockwise from north); 1000 if there is none.
   */
  function tshad(C, loc, nday, bearing) {
    var maxcoalt = 80 * RPD;
    var azimuth = fmod(bearing + TWO_PI + PI, TWO_PI);
    var time0 = 8;
    if (azimuth >= PI) { azimuth = TWO_PI - azimuth; time0 = 16; }
    var longh = loc.lon * HPR;
    var days = nday + (time0 - longh) / 24;
    var mlong = C.mlong0 + C.dmlong * days;
    var perigee = C.perigee0 + C.dperigee * days;
    var anomaly = mlong - perigee;
    var slong = mlong + C.c1 * Math.sin(anomaly) + C.c2 * Math.sin(anomaly * 2);
    var sinslong = Math.sin(slong);
    var ra = atan2(C.cosobl * sinslong, Math.cos(slong)) * HPR;
    if (ra < 0) ra += 24;
    var sindcl = C.sinobl * sinslong;
    var cosdcl = Math.sqrt(1 - sindcl * sindcl);
    var sinlat = Math.sin(loc.lat);
    var coslat = Math.sqrt(1 - sinlat * sinlat);
    var decl = Math.asin(sindcl);
    var sinaz = Math.sin(azimuth), cosaz = Math.cos(azimuth);
    var sinq = sinaz * coslat / cosdcl;
    if (sinq > 1) return 1000;
    var q1 = Math.asin(sinq), q2 = PI - q1, cosq = Math.cos(q1);
    var denom = 1 - coslat * coslat * sinaz * sinaz;
    var coalt1, coalt2, coalt;
    if ((decl > loc.lat && q1 <= azimuth) || (decl === loc.lat && q1 !== azimuth) || (decl < loc.lat && q1 >= azimuth)) coalt1 = 1000;
    else coalt1 = acosSafe((sindcl * sinlat - cosdcl * coslat * cosaz * cosq) / denom);
    if ((decl > loc.lat && q2 <= azimuth) || (decl === loc.lat && q2 !== azimuth) || (decl < loc.lat && q2 >= azimuth)) coalt2 = 1000;
    else coalt2 = acosSafe((sindcl * sinlat + cosdcl * coslat * cosaz * cosq) / denom);
    if (coalt1 > maxcoalt && coalt2 > maxcoalt) return 1000;
    if (coalt2 > maxcoalt) coalt = coalt1;
    else if (coalt1 > maxcoalt) coalt = coalt2;
    else if (coalt1 > coalt2) coalt = coalt1;
    else coalt = coalt2;
    var cosha = (Math.cos(coalt) - sindcl * sinlat) / (cosdcl * coslat);
    if (Math.abs(cosha) > 1) return 1000;
    var ha = Math.acos(cosha) * HPR;
    if (time0 < 12) ha = 24 - ha;
    var locmt = ha + ra - C.delsid * days - C.sidtm0;
    var rslt = locmt - longh + loc.tz;
    if (rslt < 0) rslt += 24; else if (rslt > 24) rslt -= 24;
    return rslt;
  }
  function acosSafe(x) { return Math.abs(x) > 1 ? NaN : Math.acos(x); }

  /** Shadow times for 8 directions (qibla - 45 deg * j) for days first..last-1. */
  function computeq(aYear, first, last, loc, dstInfo) {
    var C = computeConstants(aYear === 0 ? YEARPERP : aYear), out = [];
    for (var l = first; l < last; l++) {
      var k = (l > 59 && aYear === 0) ? l - 1 : l, row = [];
      for (var j = 0; j < 8; j++) row.push(tshad(C, loc, k + 1, loc.qibla - PI4 * j));
      out[l] = row;
    }
    applyDST(out, dstInfo, [0, 1, 2, 3, 4, 5, 6, 7]);
    return out;
  }

  /** Times when the shadow lies along the qibla (a) / opposite (b). */
  function computeq1(aYear, first, last, loc, dstInfo) {
    var C = computeConstants(aYear === 0 ? YEARPERP : aYear), out = [];
    for (var l = first; l < last; l++) {
      var k = (l > 59 && aYear === 0) ? l - 1 : l;
      out[l] = { a: tshad(C, loc, k + 1, loc.qibla), b: tshad(C, loc, k + 1, loc.qibla - PI) };
    }
    applyDST(out, dstInfo, ['a', 'b']);
    return out;
  }

  /** Qibla shadow diagram data for one day. */
  function qiblaDay(aDay, aMonth, aYear, loc) {
    var d = daylit(aYear, loc);
    var start = aDay - 1 + NDMNTHCUM[aMonth - 1] + (aMonth > 2 ? d.leap : 0);
    var rows = computeq(aYear, start, start + 1, loc, d);
    return { times: rows[start], dow: dowOfYearDay(aYear, start, d.leap) };
  }

  /** Qibla shadow chart for a month: array of 8-element rows. */
  function qiblaMonth(aMonth, aYear, loc) {
    var d = daylit(aYear, loc);
    var start = monthStart(aMonth, d.leap), finish = start + monthLength(aMonth, d.leap);
    var rows = computeq(aYear, start, finish, loc, d);
    return { year: aYear, month: aMonth, rows: rows.slice(start, finish) };
  }

  function qiblaYear(aYear, loc) {
    var d = daylit(aYear, loc), rows = computeq(aYear, 0, 365 + d.leap, loc, d), out = [], start = 0;
    for (var m = 1; m <= 12; m++) {
      var len = monthLength(m, d.leap);
      out.push({ year: aYear, month: m, rows: rows.slice(start, start + len) });
      start += len;
    }
    return out;
  }

  // ----------------------------------------------------------- Hijri / moon
  function augJulDay(aYear, aMonth, aDay, aHour, aMinute) {
    var y, m;
    if (aMonth > 2) { y = aYear; m = aMonth + 1; } else { y = aYear - 1; m = aMonth + 13; }
    var jd = (365 * y + idiv(y, 4) + 30 * m + idiv(3 * m, 5) + aDay) +
      (aHour * 60 + aMinute) / 1440 + 1720995;
    if (y > 1583 || (y === 1582 && (m > 11 || (m === 11 && aDay >= 15)))) {
      var a = idiv(y, 100);
      jd += 2 - a + idiv(a, 4);
    }
    return jd;
  }

  function caldat(augJD) {
    var intJD = fix(augJD), frac = augJD - intJD;
    var dow = (1 + intJD) % 7 + 1;
    var hour = fix(frac * 24), minute = fix((frac * 24 - hour) * 60 + 0.5);
    if (minute >= 60) { minute -= 60; hour += 1; }
    var a;
    if (intJD >= 2299161) {
      var alpha = fix(((intJD - 1867216) - 0.25) / 36524.25);
      a = intJD + 1 + alpha - idiv(alpha, 4);
    } else a = intJD;
    var b = a + 1524;
    var c = fix(6680 + (b - 2439870 - 122.1) / 365.25);
    var d = 365 * c + idiv(c, 4);
    var e = fix((b - d) / 30.6001);
    var day = fix(-30.6001 * e) + b - d;
    var month = e - 1;
    if (month > 12) month -= 12;
    var year = c - 4715;
    if (month > 2) year -= 1;
    if (year <= 0) year -= 1;
    return { year: year, month: month, day: day, hour: hour, minute: minute, dow: dow };
  }

  /** Augmented Julian date of the new moon at Greenwich (lunation from 2000-01-01 12h). */
  function newmoon(lunation) {
    var t = lunation / 1236.85, t2 = t * t;
    var eccy = 1 - 0.002516 * t - 0.0000074 * t2;
    var anomSun = RPD * fmod(2.5534 + 29.10535669 * lunation - (0.0000218 + 0.00000011 * t) * t2, 360);
    var aS2 = anomSun + anomSun;
    var anomMoon = RPD * fmod(201.5643 + 385.81693528 * lunation + (0.0107438 + 0.00001239 * t - 0.000000058 * t2) * t2, 360);
    var aM2 = anomMoon + anomMoon, aM3 = aM2 + anomMoon;
    var latMoon = RPD * fmod(160.7108 + 390.67050274 * lunation - (0.0016341 + 0.00000227 * t - 0.000000011 * t2) * t2, 360);
    var lM2 = latMoon + latMoon;
    var longNode = RPD * fmod(124.7746 - 1.5637558 * lunation + (0.0020691 + 0.00000215 * t) * t2, 360);
    var jd = 2451550.59765 + 29.530588853 * lunation + (0.00011337 - 0.00000015 * t + 0.00000000073 * t2) * t2;
    var S = Math.sin;
    jd = jd - 0.4072 * S(anomMoon) + 0.17241 * eccy * S(anomSun) + 0.01608 * S(aM2) + 0.01039 * S(lM2) +
      (0.00739 * S(anomMoon - anomSun) - 0.00514 * S(anomMoon + anomSun)) * eccy +
      0.00208 * eccy * eccy * S(aS2) - 0.00111 * S(anomMoon - lM2) - 0.00057 * S(anomMoon + lM2) +
      (0.00056 * S(aM2 + anomSun) + 0.00042 * S(anomSun + lM2) + 0.00038 * S(anomSun - lM2) - 0.00024 * S(aM2 - anomSun)) * eccy -
      0.00042 * S(aM3) - 0.00017 * S(longNode);
    jd = jd + 0.000325 * S(RPD * fmod(299.77 + 0.107408 * lunation - 0.009173 * t2, 360)) +
      0.000165 * S(RPD * fmod(251.88 + 0.0163218 * lunation, 360)) +
      0.000164 * S(RPD * fmod(251.83 + 26.651886 * lunation, 360)) +
      0.000126 * S(RPD * fmod(349.42 + 36.412478 * lunation, 360)) +
      0.00011 * S(RPD * fmod(84.66 + 18.206239 * lunation, 360)) +
      0.000062 * S(RPD * fmod(141.74 + 53.303771 * lunation, 360)) +
      0.00006 * S(RPD * fmod(207.14 + 2.453732 * lunation, 360)) +
      0.000056 * S(RPD * fmod(154.84 + 7.30686 * lunation, 360));
    return jd;
  }

  /** Augmented JD (at local midnight, zone tz) -> Hijri {year, month, day}. */
  function augJD2H(ajD, tz) {
    var augJD = ajD - tz / 24;
    var lunation = fix((augJD - 2451545.5) * 0.033863107);
    var jd0 = newmoon(lunation);
    while (augJD - jd0 - CRIT_AGE < 0) { lunation -= 1; jd0 = newmoon(lunation); }
    var day = fix(augJD - jd0 - CRIT_AGE + 0.99);
    var n = 17049 + lunation;
    return { year: idiv(n, 12), month: n % 12 + 1, day: day };
  }

  /** Gregorian -> Hijri. Returns {year, month, day, dow}. */
  function X2H(yx, mx, dx, tz) {
    var jd = augJulDay(yx, mx, dx, 0, 0);
    var dow = (1 + fix(jd)) % 7 + 1;
    var h = augJD2H(jd, tz);
    h.dow = dow;
    return h;
  }

  /** Hijri -> Gregorian. Returns {year, month, day, dow}. */
  function H2X(yh, mh, dh, tz) {
    var lunation = yh * 12 + mh - 17050;
    var jd = newmoon(lunation);
    var g = caldat(jd + dh + CRIT_AGE + tz / 24);
    return { year: g.year, month: g.month, day: g.day, dow: g.dow };
  }

  function daysInHijriMonth(yh, mh, tz) {
    var a = H2X(yh, mh, 1, tz);
    var jd0 = augJulDay(a.year, a.month, a.day, 0, 0);
    var y2 = yh, m2 = mh + 1;
    if (m2 > 12) { m2 = 1; y2 += 1; }
    var b = H2X(y2, m2, 1, tz);
    return Math.round(augJulDay(b.year, b.month, b.day, 0, 0) - jd0);
  }

  /** Start of a Hijri month (new moon) as a Gregorian date/time, Greenwich or zone time. */
  function startNewMoon(yearH, monthH, greenwich, loc) {
    var lunation = yearH * 12 + monthH - 17050;
    var jd = newmoon(lunation);
    if (greenwich) return caldat(jd);
    var g = caldat(jd + loc.tz / 24);
    var d = daylit(g.year, loc);
    var n0 = idiv(275 * g.month, 9) + g.day - 30 - idiv(g.month + 9, 12) * (2 - d.leap);
    if ((d.b1 <= n0 && n0 <= d.e1) || (d.b2 <= n0 && n0 <= d.e2)) g = caldat(jd + (loc.tz + 1) / 24);
    return g;
  }

  /** Moon's age in days at the given local date/time (24-hour clock). */
  function moonAge(aYear, aMonth, aDay, aHour, aMinute, loc) {
    var d = daylit(aYear, loc);
    var n0 = idiv(275 * aMonth, 9) + aDay - 30 - idiv(aMonth + 9, 12) * (2 - d.leap);
    if ((d.b1 <= n0 && n0 <= d.e1) || (d.b2 <= n0 && n0 <= d.e2)) aHour -= 1;
    var jd = augJulDay(aYear, aMonth, aDay, aHour, aMinute);
    var dow = (1 + fix(jd)) % 7 + 1;
    jd -= loc.tz / 24;
    var lunation = fix((jd - 2451545.5) * 0.033863107);
    var jd0 = newmoon(lunation);
    while (jd - jd0 <= -1) { lunation -= 1; jd0 = newmoon(lunation); }
    return { age: jd - jd0, dow: dow };
  }

  // -------------------------------------------------------------- formatting
  function pad2(n) { return (n < 10 ? '0' : '') + n; }

  /** "h:mm" or "h:mm AM", "*" if the time does not exist. */
  function formatTime(t, withAmPm) {
    if (t === undefined || t === null || isNaN(t) || t < 0 || t > 360) return '*';
    var h = fix(t), m = fix((t - h) * 60 + 0.5);
    if (m >= 60) { m = 0; h += 1; }
    h %= 24;
    var pm = h >= 12, h12 = h % 12 === 0 ? 12 : h % 12;
    var s = h12 + ':' + pad2(m);
    return withAmPm ? s + (pm ? ' PM' : ' AM') : s;
  }

  function formatTime24(t) {
    if (t === undefined || t === null || isNaN(t) || t < 0 || t >= 24) return '*';
    var h = fix(t), m = fix((t - h) * 60 + 0.5);
    if (m >= 60) { m = 0; h += 1; }
    return pad2(h % 24) + ':' + pad2(m);
  }

  var api = {
    NONE: NONE, PI: PI, DPR: DPR, RPD: RPD,
    TIME_KEYS: TIME_KEYS, WEEKDAY: WEEKDAY, MONTH: MONTH, HIJRI_MONTH: HIJRI_MONTH,
    DEFAULT_ISHRAQ_ALT: DEFAULT_ISHRAQ_ALT, DEFAULT_ASRMAKRUH_ALT: DEFAULT_ASRMAKRUH_ALT,
    makeLocation: makeLocation, defaultSettings: defaultSettings,
    isLeap: isLeap, monthLength: monthLength,
    computeConstants: computeConstants, tempus: tempus, noontime: noontime,
    daylit: daylit, namedDay: namedDay,
    compute: compute, daySchedule: daySchedule, monthSchedule: monthSchedule,
    yearSchedule: yearSchedule, hijriMonthSchedule: hijriMonthSchedule,
    qibla: qibla, qiblaAngle: qiblaAngle, qiblaDay: qiblaDay,
    qiblaMonth: qiblaMonth, qiblaYear: qiblaYear,
    augJulDay: augJulDay, caldat: caldat, newmoon: newmoon,
    X2H: X2H, H2X: H2X, daysInHijriMonth: daysInHijriMonth,
    startNewMoon: startNewMoon, moonAge: moonAge,
    formatTime: formatTime, formatTime24: formatTime24, pad2: pad2
  };

  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.Minaret = api;
})(typeof self !== 'undefined' ? self : this);
