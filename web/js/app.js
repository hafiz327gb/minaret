/* Minaret web app: user interface on top of minaret-core.js */
(function () {
  'use strict';
  var M = window.Minaret;
  var GAZ = window.MINARET_GAZETTEER;
  var $ = function (id) { return document.getElementById(id); };
  var pad2 = M.pad2;

  // ------------------------------------------------------------- storage
  function load(key, def) {
    try { var v = localStorage.getItem('minaret.' + key); return v ? JSON.parse(v) : def; } catch (e) { return def; }
  }
  function save(key, val) {
    try { localStorage.setItem('minaret.' + key, JSON.stringify(val)); } catch (e) { /* private mode */ }
  }

  // --------------------------------------------------------------- state
  var customPlaces = load('custom', []);
  var places = [];                      // gazetteer + custom, sorted by name
  var settings = Object.assign(M.defaultSettings(), {
    asrHanafi: GAZ.defaults.asrHanafi,
    fajrByDepr: GAZ.defaults.fajrByDepr, fajrDepr: GAZ.defaults.fajrDepr, fajrInterval: GAZ.defaults.fajrInterval,
    ishaByDepr: GAZ.defaults.ishaByDepr, ishaDepr: GAZ.defaults.ishaDepr, ishaInterval: GAZ.defaults.ishaInterval,
    use24: 0
  }, load('settings', {}));
  var loc;
  var now = new Date();
  var today = { y: now.getFullYear(), m: now.getMonth() + 1, d: now.getDate() };

  function rebuildPlaces() {
    var all = GAZ.places.slice();
    if (!all.some(function (p) { return p.name === GAZ.current.name; })) all.push(GAZ.current);
    places = all.concat(customPlaces).sort(function (a, b) { return a.name.localeCompare(b.name); });
  }
  function setLocation(p, persist) {
    loc = M.makeLocation(p);
    $('locLabel').textContent = loc.name + ' · ' + fmtLat(loc) + ' ' + fmtLon(loc) + ' · GMT' + fmtZone(loc);
    if (persist !== false) save('place', p);
    renderCurrent();
  }
  function fmtLat(l) { return l.latD + '°' + pad2(l.latM) + '′ ' + (l.latS ? 'S' : 'N'); }
  function fmtLon(l) { return l.lonD + '°' + pad2(l.lonM) + '′ ' + (l.lonW ? 'W' : 'E'); }
  function fmtZone(l) { return (l.zoneNeg ? '−' : '+') + l.zoneH + (l.zoneM ? ':' + pad2(l.zoneM) : '') + (l.dst ? ' (DST)' : ''); }

  // ------------------------------------------------------------ helpers
  function T(t) { return settings.use24 ? M.formatTime24(t) : M.formatTime(t, false); }
  function T12(t) { return M.formatTime(t, true); }
  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  function iso(y, m, d) { return y + '-' + pad2(m) + '-' + pad2(d); }
  function parseDate(v) {
    var m = /^(\d{1,6})-(\d\d)-(\d\d)$/.exec(v || '');
    return m ? { y: +m[1], m: +m[2], d: +m[3] } : null;
  }
  function fillMonths(sel, names, selected) {
    sel.innerHTML = names.map(function (n, i) { return '<option value="' + (i + 1) + '">' + esc(n) + '</option>'; }).join('');
    sel.value = selected;
  }
  function dayName(dow) { return M.WEEKDAY[dow - 1]; }
  function msg(el, text, isErr) { el.innerHTML = isErr ? '<span class="err">' + esc(text) + '</span>' : text; }
  function validGregorian(y, m, d) {
    if (m < 1 || m > 12 || d < 1 || d > M.monthLength(m, M.isLeap(y))) return false;
    if (y === 1582 && m === 10 && d > 4 && d < 15) return false;
    return true;
  }
  function locMeta(l) {
    var q = M.qiblaAngle(l);
    return esc(l.name) + ' — Latitude ' + fmtLat(l) + ', Longitude ' + fmtLon(l) + ', GMT' + fmtZone(l) +
      ', Qibla ' + q.deg + '°' + pad2(q.min) + '′ ' + (q.east ? 'E' : 'W') + ' of north';
  }

  // ------------------------------------------------------------- tabs
  var tabs = document.querySelectorAll('#tabs button');
  function showTab(name) {
    tabs.forEach(function (b) { var on = b.dataset.tab === name; b.classList.toggle('on', on); b.setAttribute('aria-selected', on); });
    document.querySelectorAll('.panel').forEach(function (p) { p.classList.toggle('on', p.id === 'tab-' + name); });
    save('tab', name);
    if (location.hash !== '#' + name) history.replaceState(null, '', '#' + name);
  }
  tabs.forEach(function (b) { b.addEventListener('click', function () { showTab(b.dataset.tab); }); });

  // ====================================================== PRAYER TAB
  var pMode = 'day';
  var COLS = [
    ['fajr', 'Fajr', 'فجر'], ['shuruq', 'Shuruq', 'طلوع'], ['ishraq', 'Ishraq', 'اشراق'], ['zuhr', 'Zuhr', 'ظہر'],
    ['asr', 'Asr', 'عصر'], ['asrMakruh', 'Asr Makruh', 'عصر مکروہ'], ['maghrib', 'Maghrib', 'مغرب'], ['isha', 'Isha', 'عشاء']
  ];
  var EXTRA = { ishraq: 1, asrMakruh: 1 };
  var SUB = { fajr: 'Dawn', shuruq: 'Sunrise', zuhr: 'Noon', asr: 'Afternoon', asrMakruh: '', maghrib: 'Sunset', isha: 'Night' };

  function colHead(c) {
    var sub = SUB[c[0]];
    if (c[0] === 'ishraq') sub = '+' + settings.ishraqAlt + '°';
    if (c[0] === 'asrMakruh') sub = '+' + settings.asrMakruhAlt + '°';
    return '<th class="' + (EXTRA[c[0]] ? 'xt' : '') + '">' + c[1] + '<small><bdi>' + c[2] + '</bdi>' + (sub ? ' · <bdi>' + sub + '</bdi>' : '') + '</small></th>';
  }

  function scheduleTable(rows, o) {
    var h = '<div class="tblwrap' + (o.pageBreak ? ' month-break' : '') + '"><table class="sch"><caption>' + esc(o.caption) + '</caption><thead><tr>';
    h += '<th>' + (o.firstHead || 'Date') + '</th>';
    if (o.second) h += '<th>' + o.second + '</th>';
    COLS.forEach(function (c) { h += colHead(c); });
    if (o.qibla) h += '<th>Shadow<small>to Qibla</small></th>';
    h += '</tr></thead><tbody>';
    rows.forEach(function (r) {
      var cls = [];
      if (o.isToday && o.isToday(r)) cls.push('today');
      if (r.dow === 6) cls.push('fri');
      h += '<tr' + (cls.length ? ' class="' + cls.join(' ') + '"' : '') + '>';
      h += '<td>' + r.day + (r.dow ? ' <span class="dn">' + dayName(r.dow).slice(0, 3) + '</span>' : '') + '</td>';
      if (o.second) h += '<td>' + (o.hijri ? (r.hijri || '') : (r.greg || '')) + '</td>';
      COLS.forEach(function (c) { h += '<td class="' + (EXTRA[c[0]] ? 'xt' : '') + '">' + T(r[c[0]]) + '</td>'; });
      if (o.qibla) h += '<td>' + (r.qibla === undefined ? '' : (settings.use24 ? M.formatTime24(r.qibla) : T12(r.qibla))) + '</td>';
      h += '</tr>';
    });
    return h + '</tbody></table></div>';
  }

  function validYear(v, lo, hi, allowZero) {
    var y = Math.round(+v);
    if (allowZero && y === 0) return 0;
    return (isFinite(y) && y >= lo && y <= hi) ? y : -1;
  }

  function renderPrayer() {
    var out = $('prayerOut'), html = '', st = settings;
    if (pMode === 'day') {
      var d = parseDate($('pDate').value);
      if (!d || d.y < 1901 || d.y > 2200 || !validGregorian(d.y, d.m, d.d)) return msg(out, 'Please choose a valid date between 1901 and 2200 A.D.', true);
      var r = M.daySchedule(d.d, d.m, d.y, loc, st), h = M.X2H(d.y, d.m, d.d, loc.tz);
      html = '<div class="head"><h2>' + dayName(r.dow) + ', ' + d.d + ' ' + M.MONTH[d.m - 1] + ' ' + d.y +
        ' · ' + h.day + ' ' + M.HIJRI_MONTH[h.month - 1] + ' ' + h.year + ' H</h2><p class="meta">' + locMeta(loc) + '</p></div><div class="daycards">';
      COLS.forEach(function (c) {
        var note = { ishraq: 'sun ' + st.ishraqAlt + '° above horizon', asrMakruh: 'sun ' + st.asrMakruhAlt + '° above horizon · till Maghrib' }[c[0]] || SUB[c[0]];
        html += '<div class="dc' + (EXTRA[c[0]] ? ' xt' : '') + '"><div class="n"><span>' + c[1] + '</span><span class="ur">' + c[2] + '</span></div>' +
          '<div class="t">' + (settings.use24 ? M.formatTime24(r.times[c[0]]) : T12(r.times[c[0]])) + '</div><div class="d">' + note + '</div></div>';
      });
      html += '</div>';
      if (loc.dst) html += '<p class="note">Daylight saving time is applied for dates inside the DST period of this location.</p>';
    } else if (pMode === 'month') {
      var y = validYear($('pYear').value, 1901, 2200, false), m = +$('pMonth').value;
      if (y < 0) return msg(out, 'Year must be between 1901 and 2200.', true);
      var ms = M.monthSchedule(m, y, loc, st);
      html = '<div class="head"><h2>' + M.MONTH[m - 1] + ' ' + y + ' — Prayer schedule</h2><p class="meta">' + locMeta(loc) + '</p></div>' +
        scheduleTable(ms.rows, {
          caption: M.MONTH[m - 1] + ' ' + y + ' A.D.', second: st.addHijriDate ? 'Hijri<small>M/D</small>' : '', hijri: true,
          qibla: st.addQiblaTime, isToday: function (r) { return y === today.y && m === today.m && r.day === today.d; }
        });
    } else if (pMode === 'year') {
      var yy = validYear($('pYear').value, 1901, 2200, true);
      if (yy < 0) return msg(out, 'Year must be 0 (perpetual) or between 1901 and 2200.', true);
      var months = M.yearSchedule(yy, loc, st);
      var perp = yy === 0;
      html = '<div class="head"><h2>' + (perp ? 'Perpetual prayer schedule' : yy + ' A.D. — Prayer schedule') + '</h2><p class="meta">' + locMeta(loc) + '</p>' +
        (perp ? '<p class="note">Perpetual schedule: average of a four-year cycle, valid for any year. ' +
          (loc.dst ? 'Daylight saving time is applied April–October; adjust by an hour if your region differs.' : '') + '</p>' : '') + '</div>';
      months.forEach(function (mo, i) {
        html += scheduleTable(mo.rows, {
          caption: M.MONTH[i] + (perp ? '' : ' ' + yy), second: (!perp && st.addHijriDate) ? 'Hijri<small>M/D</small>' : '', hijri: true,
          qibla: st.addQiblaTime, pageBreak: true, isToday: function (r) { return yy === today.y && i + 1 === today.m && r.day === today.d; }
        });
      });
    } else {
      var hy = validYear($('pHYear').value, 1, 4000, false), hm = +$('pHMonth').value;
      if (hy < 0) return msg(out, 'Hijri year must be between 1 and 4000.', true);
      var hs = M.hijriMonthSchedule(hm, hy, loc, st);
      html = '<div class="head"><h2>' + M.HIJRI_MONTH[hm - 1] + ' ' + hy + ' H — Prayer schedule</h2><p class="meta">' + locMeta(loc) + '</p></div>' +
        scheduleTable(hs.rows, {
          caption: M.HIJRI_MONTH[hm - 1] + ' ' + hy + ' H', firstHead: 'Hijri day', second: 'Gregorian<small>M/D</small>',
          isToday: function (r) { return r.greg === pad2(today.m) + '/' + pad2(today.d) && r.gregYear === today.y; }
        });
    }
    out.innerHTML = html;
  }

  function setPrayerMode(m) {
    pMode = m;
    document.querySelectorAll('#prayerModes button').forEach(function (b) { b.classList.toggle('on', b.dataset.mode === m); });
    document.querySelectorAll('#prayerForm label').forEach(function (l) {
      l.classList.toggle('off', l.dataset.for.split(' ').indexOf(m) < 0);
    });
    $('yearHint').textContent = m === 'year' ? '(0 = perpetual)' : '(1901–2200)';
    if (m === 'month' && +$('pYear').value === 0) $('pYear').value = today.y;   // 0 is only valid for year schedules
    renderPrayer();
  }
  document.querySelectorAll('#prayerModes button').forEach(function (b) { b.addEventListener('click', function () { setPrayerMode(b.dataset.mode); }); });
  $('prayerForm').addEventListener('submit', function (e) { e.preventDefault(); renderPrayer(); });
  ['pDate', 'pMonth', 'pYear', 'pHMonth', 'pHYear'].forEach(function (id) { $(id).addEventListener('change', renderPrayer); });

  function tableText(sep) {
    var lines = [];
    document.querySelectorAll('#prayerOut table').forEach(function (t) {
      lines.push(t.querySelector('caption').textContent);
      t.querySelectorAll('tr').forEach(function (tr) {
        var cells = [];
        tr.querySelectorAll('th,td').forEach(function (c) {
          var s = c.cloneNode(true); s.querySelectorAll('small').forEach(function (x) { x.remove(); });
          var v = s.textContent.replace(/\s+/g, ' ').trim();
          cells.push(sep === ',' ? '"' + v.replace(/"/g, '""') + '"' : v);
        });
        lines.push(cells.join(sep));
      });
      lines.push('');
    });
    if (!lines.length) { var o = $('prayerOut'); return o.innerText; }
    return lines.join('\n');
  }
  function download(name, text, type) {
    var a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob(['﻿' + text], { type: type }));
    a.download = name; document.body.appendChild(a); a.click();
    setTimeout(function () { URL.revokeObjectURL(a.href); a.remove(); }, 500);
  }
  $('pPrint').addEventListener('click', function () { window.print(); });
  $('pCsv').addEventListener('click', function () {
    var t = tableText(',');
    download('minaret-prayer-times.csv', t || $('prayerOut').innerText, 'text/csv;charset=utf-8');
  });
  $('pCopy').addEventListener('click', function () {
    var t = tableText('\t'), b = $('pCopy');
    function done() { var o = b.textContent; b.textContent = 'Copied'; setTimeout(function () { b.textContent = o; }, 1200); }
    if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(t).then(done, function () { });
  });

  // ======================================================== QIBLA TAB
  var qMode = 'angle';
  var ANG = ['0°', '45°', '90°', '135°', '180°', '225°', '270°', '315°'];

  function compassSvg(l) {
    var q = l.qibla, cx = 110, cy = 110, r = 90;
    var x = cx + (r - 8) * Math.sin(q), y = cy - (r - 8) * Math.cos(q);
    var s = '<svg viewBox="0 0 220 220" role="img" aria-label="Qibla direction"><circle class="circ" cx="110" cy="110" r="95"/>';
    ['N', 'E', 'S', 'W'].forEach(function (t, i) {
      var a = i * Math.PI / 2;
      s += '<text class="lbl" x="' + (cx + 103 * Math.sin(a)) + '" y="' + (cy - 103 * Math.cos(a) + 4) + '" text-anchor="middle">' + t + '</text>';
    });
    for (var k = 0; k < 36; k++) {
      var a2 = k * Math.PI / 18, len = k % 9 === 0 ? 10 : (k % 3 === 0 ? 6 : 3);
      s += '<line class="tick" stroke="currentColor" opacity=".35" x1="' + (cx + 95 * Math.sin(a2)) + '" y1="' + (cy - 95 * Math.cos(a2)) + '" x2="' + (cx + (95 - len) * Math.sin(a2)) + '" y2="' + (cy - (95 - len) * Math.cos(a2)) + '"/>';
    }
    s += '<line class="needle" x1="' + cx + '" y1="' + cy + '" x2="' + x + '" y2="' + y + '"/><circle cx="110" cy="110" r="4" fill="currentColor"/>' +
      '<rect class="kaaba" x="' + (x - 7) + '" y="' + (y - 7) + '" width="14" height="14" rx="2"/></svg>';
    return s;
  }

  function shadowTable(rows, o) {
    var h = '<div class="tblwrap' + (o.pageBreak ? ' month-break' : '') + '"><table class="sch"><caption>' + esc(o.caption) + '</caption><thead><tr><th>Day</th>';
    ANG.forEach(function (a) { h += '<th>' + a + '</th>'; });
    h += '</tr></thead><tbody>';
    rows.forEach(function (r, i) {
      h += '<tr><td>' + (i + 1) + '</td>';
      r.forEach(function (t) { h += '<td>' + (t < 0 || t >= 24 ? '*' : M.formatTime24(t)) + '</td>'; });
      h += '</tr>';
    });
    return h + '</tbody></table></div>';
  }

  function renderQibla() {
    var out = $('qiblaOut'), html = '';
    if (qMode === 'angle') {
      var q = M.qiblaAngle(loc);
      html = '<div class="compass">' + compassSvg(loc) + '<div><div class="big">' + q.deg + '° ' + pad2(q.min) + '′ ' + (q.east ? 'east' : 'west') +
        '</div><p>Angle of the Qibla from true north at <b>' + esc(loc.name) + '</b>, measured towards ' + (q.east ? 'east' : 'west') +
        '. (Bearing ' + (((loc.qibla * M.DPR) + 360) % 360).toFixed(1) + '° clockwise from north.)</p>' +
        '<p class="hint">Square = direction of the Ka‘ba. Align a compass to true north (not magnetic) before using.</p></div></div>';
    } else if (qMode === 'day') {
      var d = parseDate($('qDate').value);
      if (!d || d.y < 1901 || d.y > 2200 || !validGregorian(d.y, d.m, d.d)) return msg(out, 'Please choose a valid date between 1901 and 2200 A.D.', true);
      var r = M.qiblaDay(d.d, d.m, d.y, loc);
      html = '<div class="head"><h2>Qibla shadow diagram — ' + dayName(r.dow) + ', ' + d.d + ' ' + M.MONTH[d.m - 1] + ' ' + d.y + '</h2><p class="meta">' + locMeta(loc) + '</p></div>' +
        '<p class="note">Times when the Qibla makes the given angle (clockwise from the shadow of a vertical object). * = no such time that day. 0° means the shadow points to the Qibla.</p>' +
        shadowTable([r.times], { caption: 'Time at which the shadow is at the angle' });
    } else if (qMode === 'month') {
      var y = validYear($('qYear').value, 1901, 2200, false), m = +$('qMonth').value;
      if (y < 0) return msg(out, 'Year must be between 1901 and 2200.', true);
      var mo = M.qiblaMonth(m, y, loc);
      html = '<div class="head"><h2>' + M.MONTH[m - 1] + ' ' + y + ' — Qibla indicator</h2><p class="meta">' + locMeta(loc) + '</p></div>' +
        '<p class="note">Angle (degrees) clockwise from shadow to Qibla. * = no such time.</p>' + shadowTable(mo.rows, { caption: M.MONTH[m - 1] + ' ' + y });
    } else {
      var yy = validYear($('qYear').value, 1901, 2200, false);
      if (yy < 0) return msg(out, 'Year must be between 1901 and 2200.', true);
      html = '<div class="head"><h2>' + yy + ' — Qibla indicator</h2><p class="meta">' + locMeta(loc) + '</p></div>';
      M.qiblaYear(yy, loc).forEach(function (mo, i) { html += shadowTable(mo.rows, { caption: M.MONTH[i] + ' ' + yy, pageBreak: true }); });
    }
    out.innerHTML = html;
  }
  function setQiblaMode(m) {
    qMode = m;
    document.querySelectorAll('#qiblaModes button').forEach(function (b) { b.classList.toggle('on', b.dataset.mode === m); });
    document.querySelectorAll('#qiblaForm label').forEach(function (l) {
      l.classList.toggle('off', m === 'angle' || l.dataset.for.split(' ').indexOf(m) < 0);
    });
    renderQibla();
  }
  document.querySelectorAll('#qiblaModes button').forEach(function (b) { b.addEventListener('click', function () { setQiblaMode(b.dataset.mode); }); });
  $('qiblaForm').addEventListener('submit', function (e) { e.preventDefault(); renderQibla(); });
  ['qDate', 'qMonth', 'qYear'].forEach(function (id) { $(id).addEventListener('change', renderQibla); });
  $('qPrint').addEventListener('click', function () { window.print(); });

  // ===================================================== CALENDAR TAB
  $('cvA2H').addEventListener('click', function () {
    var d = parseDate($('cvDate').value), o = $('cvOut');
    if (!d || d.y < 622 || d.y > 4503 || !validGregorian(d.y, d.m, d.d)) return msg(o, 'Enter a valid date between 622 and 4503 A.D. (the Gregorian calendar has no 5–14 October 1582).', true);
    var h = M.X2H(d.y, d.m, d.d, loc.tz);
    o.innerHTML = dayName(h.dow) + ', ' + d.d + ' ' + M.MONTH[d.m - 1] + ' ' + d.y + ' A.D. = <b>' + h.day + ' ' + M.HIJRI_MONTH[h.month - 1] + ' ' + h.year + ' A.H.</b>';
    $('cvHMonth').value = h.month; $('cvHDay').value = h.day; $('cvHYear').value = h.year;
  });
  $('cvH2A').addEventListener('click', function () {
    var hy = Math.round(+$('cvHYear').value), hd = Math.round(+$('cvHDay').value), hm = +$('cvHMonth').value, o = $('cvOut');
    if (!(hy >= 1 && hy <= 4000) || !(hd >= 1 && hd <= 30)) return msg(o, 'Enter a Hijri year (1–4000) and day (1–30).', true);
    var g = M.H2X(hy, hm, hd, loc.tz);
    o.innerHTML = hd + ' ' + M.HIJRI_MONTH[hm - 1] + ' ' + hy + ' A.H. = <b>' + dayName(g.dow) + ', ' + g.day + ' ' + M.MONTH[g.month - 1] + ' ' + g.year + ' A.D.</b>';
    $('cvDate').value = iso(g.year, g.month, g.day);
  });
  $('nmGo').addEventListener('click', function () {
    var hy = Math.round(+$('nmYear').value), hm = +$('nmMonth').value, o = $('nmOut');
    if (!(hy >= 1 && hy <= 4000)) return msg(o, 'Enter a Hijri year between 1 and 4000.', true);
    var g = M.startNewMoon(hy, hm, 1, loc), l = M.startNewMoon(hy, hm, 0, loc);
    o.innerHTML = 'New moon before ' + M.HIJRI_MONTH[hm - 1] + ' ' + hy + ' H:<br><b>' + M.MONTH[g.month - 1] + ' ' + g.day + ', ' + g.year + ', ' + pad2(g.hour) + ':' + pad2(g.minute) + ' GMT</b><br>' +
      M.MONTH[l.month - 1] + ' ' + l.day + ', ' + l.year + ', ' + M.formatTime(l.hour + l.minute / 60, true) + ' zone time';
  });
  $('maGo').addEventListener('click', function () {
    var d = parseDate($('maDate').value), tm = /^(\d\d):(\d\d)/.exec($('maTime').value || ''), o = $('maOut');
    if (!d || !tm || d.y < 640 || d.y > 4503 || !validGregorian(d.y, d.m, d.d)) return msg(o, 'Enter a valid date (640–4503 A.D.) and time.', true);
    var r = M.moonAge(d.y, d.m, d.d, +tm[1], +tm[2], loc), days = Math.trunc(r.age), hrs = (r.age - days) * 24;
    o.innerHTML = dayName(r.dow) + ' — the moon is <b>' + days + ' days ' + hrs.toFixed(1) + ' hours</b> old (' + r.age.toFixed(2) + ' days since the new moon).';
  });

  // ===================================================== LOCATION TAB
  function renderPlaceList() {
    var q = $('locSearch').value.trim().toLowerCase(), sel = $('locList');
    var list = places.filter(function (p) { return !q || p.name.toLowerCase().indexOf(q) >= 0; });
    sel.innerHTML = list.slice(0, 800).map(function (p) {
      return '<option value="' + places.indexOf(p) + '"' + (loc && p.name === loc.name ? ' selected' : '') + '>' + esc(p.name) + '</option>';
    }).join('');
    $('locCount').textContent = list.length + (q ? ' matching of ' + places.length : '');
  }
  $('locSearch').addEventListener('input', renderPlaceList);
  $('locList').addEventListener('change', function () {
    var p = places[+$('locList').value]; if (p) setLocation(p);
  });

  var NUMS = ['last', '1st', '2nd', '3rd', '4th'], DOWS = ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  function opts(sel, arr, start, val) {
    sel.innerHTML = arr.map(function (n, i) { return '<option value="' + (i + start) + '">' + n + '</option>'; }).join('');
    sel.value = val;
  }
  $('cDst').addEventListener('change', function () { $('cDstBox').hidden = !$('cDst').checked; });
  $('locForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var p = {
      name: $('cName').value.trim().slice(0, 29), latD: +$('cLatD').value, latM: +$('cLatM').value, latS: +$('cLatS').value,
      lonD: +$('cLonD').value, lonM: +$('cLonM').value, lonW: +$('cLonW').value,
      zoneH: +$('cZoneH').value, zoneM: +$('cZoneM').value, zoneNeg: +$('cZoneNeg').value, dst: $('cDst').checked ? 1 : 0,
      dstStart: { month: +$('cDsMon').value, date: 0, num: +$('cDsNum').value, dow: +$('cDsDow').value },
      dstEnd: { month: +$('cDeMon').value, date: 0, num: +$('cDeNum').value, dow: +$('cDeDow').value }
    };
    if (!p.name || p.latD > 90 || p.lonD > 180) return;
    customPlaces = customPlaces.filter(function (c) { return c.name !== p.name; }).concat([p]);
    save('custom', customPlaces); rebuildPlaces(); setLocation(p); renderPlaceList();
  });
  $('geoBtn').addEventListener('click', function () {
    var o = $('geoOut');
    if (!navigator.geolocation) return msg(o, 'This browser cannot provide your position.', true);
    msg(o, 'Locating…');
    navigator.geolocation.getCurrentPosition(function (pos) {
      var la = pos.coords.latitude, lo = pos.coords.longitude;
      function dm(v) { v = Math.abs(v); var d = Math.floor(v), m = Math.round((v - d) * 60); if (m === 60) { d++; m = 0; } return [d, m]; }
      var a = dm(la), b = dm(lo);
      var jan = new Date(now.getFullYear(), 0, 1).getTimezoneOffset(), jul = new Date(now.getFullYear(), 6, 1).getTimezoneOffset();
      var std = -Math.max(jan, jul) / 60;                  // standard (non-DST) offset in hours
      $('cName').value = 'My location'; $('cLatD').value = a[0]; $('cLatM').value = a[1]; $('cLatS').value = la < 0 ? 1 : 0;
      $('cLonD').value = b[0]; $('cLonM').value = b[1]; $('cLonW').value = lo < 0 ? 1 : 0;
      $('cZoneNeg').value = std < 0 ? 1 : 0; $('cZoneH').value = Math.floor(Math.abs(std)); $('cZoneM').value = Math.round((Math.abs(std) % 1) * 60);
      $('cDst').checked = jan !== jul; $('cDstBox').hidden = jan === jul;
      msg(o, 'Position filled in the form: ' + la.toFixed(4) + ', ' + lo.toFixed(4) + '. Check the time zone, then press “Use this location”.' +
        (jan !== jul ? ' Your device observes daylight saving; set its start and end rule.' : ''));
    }, function (err) { msg(o, 'Could not get your position (' + err.message + ').', true); }, { enableHighAccuracy: false, timeout: 15000 });
  });

  // ======================================================= OPTIONS TAB
  function fillOptions() {
    var s = settings;
    document.querySelector('input[name=fajrBy][value="' + (s.fajrByDepr ? 1 : 0) + '"]').checked = true;
    document.querySelector('input[name=ishaBy][value="' + (s.ishaByDepr ? 1 : 0) + '"]').checked = true;
    document.querySelector('input[name=asrBy][value="' + (s.asrHanafi ? 1 : 0) + '"]').checked = true;
    $('oFajrDepr').value = s.fajrDepr; $('oFajrInt').value = s.fajrInterval;
    $('oIshaDepr').value = s.ishaDepr; $('oIshaInt').value = s.ishaInterval;
    $('oIshraq').value = s.ishraqAlt; $('oMakruh').value = s.asrMakruhAlt;
    $('oHijri').checked = !!s.addHijriDate; $('oQibla').checked = !!s.addQiblaTime; $('o24').checked = !!s.use24;
  }
  function num(id, lo, hi, def) { var v = +$(id).value; return (isFinite(v) && v >= lo && v <= hi) ? v : def; }
  $('optForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var s = settings;
    s.fajrByDepr = +document.querySelector('input[name=fajrBy]:checked').value;
    s.ishaByDepr = +document.querySelector('input[name=ishaBy]:checked').value;
    s.asrHanafi = +document.querySelector('input[name=asrBy]:checked').value;
    s.fajrDepr = Math.round(num('oFajrDepr', 6, 24, s.fajrDepr)); s.fajrInterval = Math.round(num('oFajrInt', 20, 120, s.fajrInterval));
    s.ishaDepr = Math.round(num('oIshaDepr', 6, 24, s.ishaDepr)); s.ishaInterval = Math.round(num('oIshaInt', 20, 120, s.ishaInterval));
    s.ishraqAlt = num('oIshraq', 0.1, 10, 1.4); s.asrMakruhAlt = num('oMakruh', 0.1, 10, 2.3);
    s.addHijriDate = $('oHijri').checked ? 1 : 0; s.addQiblaTime = $('oQibla').checked ? 1 : 0; s.use24 = $('o24').checked ? 1 : 0;
    save('settings', s); fillOptions(); renderCurrent(); showTab('prayer');
  });
  $('oReset').addEventListener('click', function () {
    settings = Object.assign(M.defaultSettings(), { use24: 0 }); save('settings', settings); fillOptions(); renderCurrent();
  });

  // ============================================================== init
  function renderCurrent() { if (!loc) return; renderPrayer(); renderQibla(); }

  function init() {
    rebuildPlaces();
    var months = M.MONTH;
    ['pMonth', 'qMonth'].forEach(function (id) { fillMonths($(id), months, today.m); });
    ['pHMonth', 'cvHMonth', 'nmMonth'].forEach(function (id) { fillMonths($(id), M.HIJRI_MONTH, 1); });
    $('pYear').value = today.y; $('qYear').value = today.y;
    $('pDate').value = iso(today.y, today.m, today.d); $('qDate').value = iso(today.y, today.m, today.d);
    $('cvDate').value = iso(today.y, today.m, today.d);
    $('maDate').value = iso(today.y, today.m, today.d); $('maTime').value = pad2(now.getHours()) + ':' + pad2(now.getMinutes());
    opts($('cDsNum'), NUMS, 0, 2); opts($('cDsDow'), DOWS, 0, 2); opts($('cDsMon'), months, 1, 3);
    opts($('cDeNum'), NUMS, 0, 1); opts($('cDeDow'), DOWS, 0, 2); opts($('cDeMon'), months, 1, 11);

    var saved = load('place', null) || GAZ.current;
    loc = M.makeLocation(saved);
    var h = M.X2H(today.y, today.m, today.d, loc.tz);
    $('cvHMonth').value = h.month; $('cvHDay').value = h.day; $('cvHYear').value = h.year;
    $('pHMonth').value = h.month; $('pHYear').value = h.year; $('nmMonth').value = h.month; $('nmYear').value = h.year;
    fillOptions(); renderPlaceList();
    setLocation(saved, false);
    setPrayerMode('day'); setQiblaMode('angle');
    var start = (location.hash || '').slice(1) || load('tab', 'prayer');
    showTab(document.getElementById('tab-' + start) ? start : 'prayer');
  }
  init();
})();
