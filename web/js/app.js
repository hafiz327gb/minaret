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
  var DEFAULT_METHOD = 'Default';      // Fajr 18° + 15°, Isha 15° + 18°
  var saved = load('settings', null);
  var settings = Object.assign(M.defaultSettings(), { use24: 0 }, saved || {});
  function ensureAngles(s) {
    ['fajr', 'isha'].forEach(function (w) {
      var a = s[w + 'Angles'];
      if (!Array.isArray(a) || !a.length || a.some(function (v) { return !(v >= 6 && v <= 24); })) a = [s[w + 'Depr']];
      s[w + 'Angles'] = a; s[w + 'Depr'] = a[0];
    });
  }
  ensureAngles(settings);
  if (!saved) { M.applyMethod(settings, DEFAULT_METHOD); settings.method = DEFAULT_METHOD; }
  else settings.method = M.detectMethod(settings, settings.method || DEFAULT_METHOD);   // settings saved by older versions
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
  function methodLabel() {
    var m = M.methodById(settings.method);
    return m ? m.abbr : 'Custom';
  }
  function locMeta(l) {
    var q = M.qiblaAngle(l);
    return esc(l.name) + ' — Latitude ' + fmtLat(l) + ', Longitude ' + fmtLon(l) + ', GMT' + fmtZone(l) +
      ', Qibla ' + q.deg + '°' + pad2(q.min) + '′ ' + (q.east ? 'E' : 'W') + ' of north · Method: ' + esc(methodLabel());
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
  /** The table columns for the current settings (several Fajr/Isha angles -> several columns). */
  function columns() {
    var st = settings, cols = [], offs = st.offsets || {};
    function withOff(v, m) { return (m && isFinite(v) && v >= 0 && v < 24) ? v + m / 60 : v; }
    function offTag(m) { return m ? ' · ' + (m > 0 ? '+' : '−') + Math.abs(m) + 'm' : ''; }
    function angleCols(which, en, ur, sub) {
      var list = st[which + 'ByDepr'] ? M.angleList(st, which) : [null], multi = list.length > 1;
      list.forEach(function (a, i) {
        var m = +offs[multi ? which + ':' + a : which] || 0;
        cols.push({
          id: which + i, en: en + (multi ? a : ''), ur: ur, sub: sub + (multi ? ' · ' + a + '°' : '') + offTag(m),
          get: function (r) { return withOff(r[which === 'fajr' ? 'fajrs' : 'ishas'][i], m); }
        });
      });
    }
    function one(key, en, ur, sub, extra) {
      var m = +offs[key] || 0;
      cols.push({ id: key, en: en, ur: ur, sub: sub + offTag(m), extra: extra, get: function (r) { return withOff(r[key], m); } });
    }
    angleCols('fajr', 'Fajr', 'فجر', 'Dawn');
    one('shuruq', 'Shuruq', 'طلوع', 'Sunrise');
    one('ishraq', 'Ishraq', 'اشراق', '+' + st.ishraqAlt + '°', 1);
    one('chasht', 'Chasht', 'چاشت', '¼ sunrise → midday', 1);
    one('midday', 'Midday', 'نصف النہار', 'Solar noon');
    one('zuhr', 'Zuhr', 'ظہر', 'Midday + 5 min');
    one('asr', 'Asr 1×', 'عصر (مثلِ اول)', 'Shafi‘i');
    one('asr2', 'Asr 2×', 'عصر (مثلِ ثانی)', 'Hanafi');
    one('asrMakruh', 'Asr Makruh', 'عصر مکروہ', '+' + st.asrMakruhAlt + '°', 1);
    one('maghrib', 'Maghrib', 'مغرب', st.maghribDepr > 0 ? 'sun −' + st.maghribDepr + '°' : 'Sunset');
    angleCols('isha', 'Isha', 'عشاء', 'Night');
    return cols;
  }

  function colHead(c) {
    return '<th class="' + (c.extra ? 'xt' : '') + '">' + c.en + '<small><bdi>' + c.ur + '</bdi> · <bdi>' + c.sub + '</bdi></small></th>';
  }

  function scheduleTable(rows, o) {
    var h = '<div class="tblwrap' + (o.pageBreak ? ' month-break' : '') + '"><table class="sch"><caption>' + esc(o.caption) + '</caption><thead><tr>';
    h += '<th>' + (o.firstHead || 'Date') + '</th>';
    if (o.second) h += '<th>' + o.second + '</th>';
    var cols = columns();
    cols.forEach(function (c) { h += colHead(c); });
    if (o.qibla) h += '<th>Shadow<small>to Qibla</small></th>';
    h += '</tr></thead><tbody>';
    rows.forEach(function (r) {
      var cls = [];
      if (o.isToday && o.isToday(r)) cls.push('today');
      if (r.dow === 6) cls.push('fri');
      h += '<tr' + (cls.length ? ' class="' + cls.join(' ') + '"' : '') + '>';
      h += '<td>' + r.day + (r.dow ? ' <span class="dn">' + dayName(r.dow).slice(0, 3) + '</span>' : '') + '</td>';
      if (o.second) h += '<td>' + (o.hijri ? (r.hijri || '') : (r.greg || '')) + '</td>';
      cols.forEach(function (c) { h += '<td class="' + (c.extra ? 'xt' : '') + '">' + T(c.get(r)) + '</td>'; });
      if (o.qibla) h += '<td>' + (r.qibla === undefined ? '' : (settings.use24 ? M.formatTime24(r.qibla) : T12(r.qibla))) + '</td>';
      h += '</tr>';
    });
    return h + '</tbody></table></div>';
  }

  var RAM_NOTE = 'احتیاط اس میں ہے کہ انتہائے سحرکے وقت کھانا پینا بند کر دیا جائے اور نماز اذانِ فجرکے وقت کے بعد پڑھیں۔ نیز انتہائے سحر اور وقتِ افطار میں احتیاطی وقت کو ملحوظ رکھا گیا ہے۔';
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
      columns().forEach(function (c) {
        var note = c.id === 'ishraq' ? 'sun ' + st.ishraqAlt + '° above horizon'
          : c.id === 'asrMakruh' ? 'sun ' + st.asrMakruhAlt + '° above horizon · till Maghrib'
          : c.id === 'asr' ? 'shadow 1× · Shafi‘i, Maliki, Hanbali' : c.id === 'asr2' ? 'shadow 2× · Hanafi' : c.sub;
        var v = c.get(r.times);
        html += '<div class="dc' + (c.extra ? ' xt' : '') + '"><div class="n"><span>' + c.en + '</span><span class="ur">' + c.ur + '</span></div>' +
          '<div class="t">' + (settings.use24 ? M.formatTime24(v) : T12(v)) + '</div><div class="d">' + note + '</div></div>';
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
    } else if (pMode === 'ramazan') {
      var rs = +document.querySelector('input[name=ramOpt]:checked').value, rn = rs === 8 ? 30 : 29;   // both end on 9 March 2026
      // Sehri end = Fajr 18° − 2 min, Fajr azan = Fajr 15°, Iftar = sunset + 2 min (fixed, whatever the options say)
      var rst = Object.assign({}, st, { fajrByDepr: 1, fajrAngles: [18, 15], fajrDepr: 18, maghribDepr: 0, addHijriDate: 0, addQiblaTime: 0 });
      var rmo = { 2: M.monthSchedule(2, 2026, loc, rst).rows, 3: M.monthSchedule(3, 2026, loc, rst).rows };
      html = '<div class="head"><h2>Ramazan 1447 H — Sehri &amp; Iftar timetable <span class="ur">سحر و افطار</span></h2><p class="meta">' + locMeta(loc) + '</p></div>' +
        '<div class="tblwrap"><table class="sch"><caption>Ramazan 1447 H · ' + rs + ' Feb – 9 Mar 2026</caption><thead><tr><th>Date<small>Feb–Mar 2026</small></th><th>Ramazan<small>1447 H</small></th>' +
        '<th>انتہائے سحر<small>Fajr18 − 2 min</small></th><th>اذانِ فجر<small>Fajr15</small></th><th>وقتِ افطار<small>Sunset + 2 min</small></th></tr></thead><tbody>';
      for (var ri = 0; ri < rn; ri++) {
        var gd = rs + ri, gm = gd > 28 ? 3 : 2; if (gm === 3) gd -= 28;
        var rr = rmo[gm][gd - 1];
        html += '<tr' + (rr.dow === 6 ? ' class="fri"' : '') + '><td>' + gd + ' ' + M.MONTH[gm - 1].slice(0, 3) + ' <span class="dn">' + dayName(rr.dow).slice(0, 3) + '</span></td><td>' + (ri + 1) + '</td>' +
          '<td>' + T(rr.fajrs[0] - 2 / 60) + '</td><td>' + T(rr.fajrs[1]) + '</td><td>' + T(rr.maghrib + 2 / 60) + '</td></tr>';
      }
      html += '</tbody></table></div><p class="ur ramnote" dir="rtl">' + RAM_NOTE + '</p>';
    } else if (pMode === 'range') {
      var a = parseDate($('pFrom').value), b = parseDate($('pTo').value);
      function bad(x) { return !x || x.y < 1901 || x.y > 2200 || !validGregorian(x.y, x.m, x.d); }
      if (bad(a) || bad(b)) return msg(out, 'Please choose two valid dates between 1901 and 2200 A.D.', true);
      function key(x) { return x.y * 10000 + x.m * 100 + x.d; }
      if (key(a) > key(b)) { var sw = a; a = b; b = sw; }                      // either order works
      var days = Math.round((Date.UTC(b.y, b.m - 1, b.d) - Date.UTC(a.y, a.m - 1, a.d)) / 86400000) + 1;
      if (days > 1100) return msg(out, 'Please choose a period of at most three years (' + days + ' days chosen).', true);
      html = '<div class="head"><h2>' + a.d + ' ' + M.MONTH[a.m - 1] + ' ' + a.y + ' to ' + b.d + ' ' + M.MONTH[b.m - 1] + ' ' + b.y +
        ' — Prayer schedule</h2><p class="meta">' + locMeta(loc) + ' · ' + days + (days === 1 ? ' day' : ' days') + '</p></div>';
      for (var ry = a.y, rm = a.m; ry * 100 + rm <= b.y * 100 + b.m; rm === 12 ? (ry++, rm = 1) : rm++) {
        (function (cy, cm) {
          var lo = (cy === a.y && cm === a.m) ? a.d : 1, hi = (cy === b.y && cm === b.m) ? b.d : 31;
          var rows = M.monthSchedule(cm, cy, loc, st).rows.filter(function (r) { return r.day >= lo && r.day <= hi; });
          html += scheduleTable(rows, {
            caption: M.MONTH[cm - 1] + ' ' + cy + ' A.D.' + ((lo > 1 || hi < 31) ? ' (' + rows[0].day + '–' + rows[rows.length - 1].day + ')' : ''),
            second: st.addHijriDate ? 'Hijri<small>M/D</small>' : '', hijri: true, qibla: st.addQiblaTime, pageBreak: true,
            isToday: function (r) { return cy === today.y && cm === today.m && r.day === today.d; }
          });
        })(ry, rm);
      }
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
  document.querySelectorAll('input[name=ramOpt]').forEach(function (r) { r.addEventListener('change', renderPrayer); });
  ['pDate', 'pMonth', 'pYear', 'pHMonth', 'pHYear', 'pFrom', 'pTo'].forEach(function (id) { $(id).addEventListener('change', renderPrayer); });

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
    function q(v) { return '"' + String(v).replace(/"/g, '""') + '"'; }
    // location block once at the top; the placeholder name of the geolocation button is not written
    var head = [['Latitude', fmtLat(loc)], ['Longitude', fmtLon(loc)], ['Time zone', 'GMT' + fmtZone(loc)]];
    if (loc.name && loc.name !== 'My location') head.unshift(['Location', loc.name]);
    else t = t.split('My location — ').join('');      // the table captions repeat the name too
    var hdr = head.map(function (r) { return q(r[0]) + ',' + q(r[1]); }).join('\n') + '\n\n';
    if (pMode === 'ramazan') t += '\n' + q(RAM_NOTE) + '\n';
    download('minaret-prayer-times.csv', hdr + (t || $('prayerOut').innerText), 'text/csv;charset=utf-8');
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
  var NUMS = [['0', 'last'], ['1', '1st'], ['2', '2nd'], ['3', '3rd'], ['4', '4th'], ['D', 'on date']];
  var DOWS = [['0', 'Fri'], ['1', 'Sat'], ['2', 'Sun'], ['3', 'Mon'], ['4', 'Tue'], ['5', 'Wed'], ['6', 'Thu']];

  function setOptions(sel, items, val) {
    sel.innerHTML = items.map(function (it) { return '<option value="' + it[0] + '">' + it[1] + '</option>'; }).join('');
    sel.value = String(val);
  }
  function isCustom(p) { return customPlaces.some(function (c) { return c.name === p.name; }); }
  function samePlace(a, b) { return JSON.stringify(a) === JSON.stringify(b); }

  function renderPlaceList() {
    var q = $('locSearch').value.trim().toLowerCase(), sel = $('locList'), n = 0, h = '';
    places.forEach(function (p, i) {
      if (q && p.name.toLowerCase().indexOf(q) < 0) return;
      n++;
      h += '<option value="' + i + '"' + (loc && p.name === loc.name ? ' selected' : '') + '>' + esc(p.name) + '</option>';
    });
    sel.innerHTML = h;
    $('locCount').textContent = n + (q ? ' matching of ' + places.length : '');
    var chosen = sel.querySelector('option:checked');
    if (chosen && chosen.scrollIntoView && !q) chosen.scrollIntoView({ block: 'nearest' });
  }

  function dstRuleUi(pre) {
    var byDate = $('c' + pre + 'Num').value === 'D';
    $('c' + pre + 'Dow').hidden = byDate; $('c' + pre + 'Date').hidden = !byDate;
  }
  function fillRule(pre, r) {
    var byDate = r.date > 0;
    $('c' + pre + 'Num').value = byDate ? 'D' : String(r.num);
    $('c' + pre + 'Dow').value = String(r.dow);
    $('c' + pre + 'Date').value = byDate ? r.date : 1;
    $('c' + pre + 'Mon').value = String(r.month);
    dstRuleUi(pre);
  }
  function readRule(pre) {
    var n = $('c' + pre + 'Num').value, month = +$('c' + pre + 'Mon').value;
    if (n === 'D') return { month: month, date: Math.max(1, Math.min(31, Math.round(+$('c' + pre + 'Date').value || 1))), num: 0, dow: 0 };
    return { month: month, date: 0, num: +n, dow: +$('c' + pre + 'Dow').value };
  }

  /** Show a place's details in the manual-coordinates form. */
  function fillLocForm(p) {
    $('cName').value = p.name;
    $('cLatD').value = p.latD; $('cLatM').value = p.latM; $('cLatS').value = p.latS ? 1 : 0;
    $('cLonD').value = p.lonD; $('cLonM').value = p.lonM; $('cLonW').value = p.lonW ? 1 : 0;
    $('cZoneNeg').value = p.zoneNeg ? 1 : 0; $('cZoneH').value = p.zoneH; $('cZoneM').value = p.zoneM;
    $('cDst').checked = !!p.dst; $('cDstBox').hidden = !p.dst;
    fillRule('Ds', p.dstStart || { month: 3, date: 0, num: 2, dow: 2 });
    fillRule('De', p.dstEnd || { month: 11, date: 0, num: 1, dow: 2 });
    $('locErr').textContent = '';
    $('locDel').hidden = !isCustom(p);
  }

  /** Read and validate the form; returns a place or null (and shows why). */
  function readLocForm() {
    var err = $('locErr');
    function n(id, lo, hi) { var v = Number($(id).value); return (isFinite(v) && $(id).value !== '' && v >= lo && v <= hi && v === Math.round(v)) ? v : null; }
    var name = $('cName').value.trim().slice(0, 60);
    var latD = n('cLatD', 0, 89), latM = n('cLatM', 0, 59), lonD = n('cLonD', 0, 180), lonM = n('cLonM', 0, 59);
    var zH = n('cZoneH', 0, 14), zM = n('cZoneM', 0, 59);
    if (!name) { err.textContent = 'Please give the place a name.'; return null; }
    if (latD === null || latM === null) { err.textContent = 'Latitude must be 0–89° and 0–59′.'; return null; }
    if (lonD === null || lonM === null || (lonD === 180 && lonM > 0)) { err.textContent = 'Longitude must be 0–180° and 0–59′.'; return null; }
    if (zH === null || zM === null) { err.textContent = 'Time zone: hours 0–14, minutes 0–59.'; return null; }
    err.textContent = '';
    return {
      name: name, latD: latD, latM: latM, latS: +$('cLatS').value, lonD: lonD, lonM: lonM, lonW: +$('cLonW').value,
      zoneH: zH, zoneM: zM, zoneNeg: +$('cZoneNeg').value, dst: $('cDst').checked ? 1 : 0,
      dstStart: readRule('Ds'), dstEnd: readRule('De')
    };
  }
  function stripDerived(p) {
    return { name: p.name, latD: p.latD, latM: p.latM, latS: p.latS ? 1 : 0, lonD: p.lonD, lonM: p.lonM, lonW: p.lonW ? 1 : 0,
      zoneH: p.zoneH, zoneM: p.zoneM, zoneNeg: p.zoneNeg ? 1 : 0, dst: p.dst ? 1 : 0, dstStart: p.dstStart, dstEnd: p.dstEnd };
  }

  /** Use a place that came from the form: gazetteer places stay as they are, edited ones are kept as "mine". */
  function useFormPlace(p) {
    var gz = places.filter(function (x) { return x.name === p.name && !isCustom(x); })[0];
    if (gz && samePlace(stripDerived(gz), p)) { setLocation(gz); fillLocForm(gz); renderPlaceList(); return; }
    if (gz) p.name = (p.name.slice(0, 52) + ' (mine)').slice(0, 60);        // do not shadow a gazetteer name
    customPlaces = customPlaces.filter(function (c) { return c.name !== p.name; }).concat([p]);
    save('custom', customPlaces); rebuildPlaces(); setLocation(p); fillLocForm(p); renderPlaceList();
  }

  $('locSearch').addEventListener('input', renderPlaceList);
  $('locList').addEventListener('change', function () {
    var p = places[+$('locList').value];
    if (p) { setLocation(p); fillLocForm(p); }
  });
  $('cDst').addEventListener('change', function () { $('cDstBox').hidden = !$('cDst').checked; });
  ['Ds', 'De'].forEach(function (pre) { $('c' + pre + 'Num').addEventListener('change', function () { dstRuleUi(pre); }); });
  $('locForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var p = readLocForm(); if (p) useFormPlace(p);
  });
  $('locDel').addEventListener('click', function () {
    customPlaces = customPlaces.filter(function (c) { return c.name !== loc.name; });
    save('custom', customPlaces); rebuildPlaces();
    setLocation(GAZ.current); fillLocForm(GAZ.current); renderPlaceList();
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
      var dstSeen = jan !== jul;
      var p = {
        name: 'My location', latD: Math.min(a[0], 89), latM: a[1], latS: la < 0 ? 1 : 0, lonD: Math.min(b[0], 180), lonM: b[1], lonW: lo < 0 ? 1 : 0,
        zoneH: Math.floor(Math.abs(std)), zoneM: Math.round((Math.abs(std) % 1) * 60), zoneNeg: std < 0 ? 1 : 0, dst: 0,
        dstStart: { month: 3, date: 0, num: 2, dow: 2 }, dstEnd: { month: 11, date: 0, num: 1, dow: 2 }
      };
      fillLocForm(p);
      if (dstSeen) {
        $('cDst').checked = true; $('cDstBox').hidden = false;
        msg(o, 'Position filled in at right (' + la.toFixed(4) + ', ' + lo.toFixed(4) + '). Your device observes daylight saving time – set its start and end rule, then press “Use this location”.');
      } else {
        useFormPlace(p);
        msg(o, 'Using your position: ' + la.toFixed(4) + ', ' + lo.toFixed(4) + '.');
      }
    }, function (err) { msg(o, 'Could not get your position (' + err.message + ').', true); }, { enableHighAccuracy: false, timeout: 15000 });
  });

  // ======================================================= OPTIONS TAB
  function methodsHtml() {
    return M.METHODS.map(function (m) { return '<option value="' + m.id + '">' + esc(m.en) + (m.en === m.abbr ? '' : ' (' + esc(m.abbr) + ')') + '</option>'; }).join('') +
      '<option value="custom">Custom — set every angle yourself / اپنی مرضی کا</option>';
  }
  function fmtDeg(v) { return v + '°'; }
  function methodSummary(st, id) {
    var m = M.methodById(id), rows = [];
    function kv(k, ku, v) { rows.push('<dt>' + k + ' <span class="ur">' + ku + '</span></dt><dd>' + v + '</dd>'); }
    if (m) { kv('Method', 'طریقہ', esc(m.en) + (m.ur ? ' <span class="ur">' + m.ur + '</span>' : '')); kv('Region', 'علاقہ', esc(m.region) + ' <span class="ur">' + m.regionUr + '</span>'); }
    kv('Fajr', 'فجر', st.fajrByDepr ? st.fajrAngles.map(fmtDeg).join(', ') + ' below horizon' : st.fajrInterval + ' min before sunrise');
    kv('Maghrib', 'مغرب', st.maghribDepr > 0 ? 'sun ' + fmtDeg(st.maghribDepr) + ' below horizon' : 'at sunset');
    kv('Isha', 'عشاء', st.ishaByDepr ? st.ishaAngles.map(fmtDeg).join(', ') + ' below horizon'
      : st.ishaInterval + ' min after Maghrib' + (st.ishaRamadanInterval > 0 ? ' (' + st.ishaRamadanInterval + ' min in Ramadan)' : ''));
    $('methodInfo').innerHTML = rows.join('');
  }
  function fillCustom(s) {
    document.querySelector('input[name=fajrBy][value="' + (s.fajrByDepr ? 1 : 0) + '"]').checked = true;
    document.querySelector('input[name=ishaBy][value="' + (s.ishaByDepr ? 1 : 0) + '"]').checked = true;
    document.querySelector('input[name=magBy][value="' + (s.maghribDepr > 0 ? 1 : 0) + '"]').checked = true;
    $('oFajrDepr').value = s.fajrAngles.join(', '); $('oFajrInt').value = s.fajrInterval;
    $('oIshaDepr').value = s.ishaAngles.join(', '); $('oIshaInt').value = s.ishaInterval;
    $('oIshaRam').value = s.ishaRamadanInterval || 0;
    $('oMagDepr').value = s.maghribDepr > 0 ? s.maghribDepr : 4;
  }
  // ---- minutes added to / subtracted from each prayer (shown for every Fajr / Isha angle too)
  var offDraft = {};
  var OFF_FIXED = [['shuruq', 'Shuruq', 'طلوع'], ['ishraq', 'Ishraq', 'اشراق'], ['chasht', 'Chasht', 'چاشت'], ['midday', 'Midday', 'نصف النہار'], ['zuhr', 'Zuhr', 'ظہر'], ['asr', 'Asr 1×', 'عصر مثلِ اول'],
    ['asr2', 'Asr 2×', 'عصر مثلِ ثانی'], ['asrMakruh', 'Asr Makruh', 'عصر مکروہ'], ['maghrib', 'Maghrib', 'مغرب']];
  /** The settings the form currently describes (selected method, or the custom fields as typed so far). */
  function formSettings() {
    var id = $('oMethod').value, t = Object.assign({}, settings);
    if (id !== 'custom') { M.applyMethod(t, id); return t; }
    var fa = parseAngles($('oFajrDepr').value), ia = parseAngles($('oIshaDepr').value);
    t.fajrByDepr = document.querySelector('input[name=fajrBy]:checked').value === '1' ? 1 : 0;
    t.ishaByDepr = document.querySelector('input[name=ishaBy]:checked').value === '1' ? 1 : 0;
    if (fa) t.fajrAngles = fa; if (ia) t.ishaAngles = ia;
    return t;
  }
  function offRows(t) {
    var rows = [];
    function ang(which, en, ur) {
      var list = t[which + 'ByDepr'] ? M.angleList(t, which) : [null], multi = list.length > 1;
      list.forEach(function (a) { rows.push([multi ? which + ':' + a : which, en + (multi ? ' ' + a + '°' : ''), ur]); });
    }
    ang('fajr', 'Fajr', 'فجر');
    OFF_FIXED.forEach(function (r) { rows.push(r); });
    ang('isha', 'Isha', 'عشاء');
    return rows;
  }
  var offSig = '';
  function buildOffsets(force) {
    var h = '', rows = offRows(formSettings()), sig = rows.map(function (r) { return r[0]; }).join('|');
    if (sig === offSig && force !== true) return;        // keep the DOM (and focus) while the rows stay the same
    offSig = sig;
    rows.forEach(function (r) {
      h += '<div class="offrow"><span>' + r[1] + ' <span class="ur">' + r[2] + '</span></span>' +
        '<button type="button" data-k="' + r[0] + '" data-d="-1" aria-label="Subtract a minute from ' + r[1] + '">−</button>' +
        '<input type="number" min="-120" max="120" step="1" data-k="' + r[0] + '" value="' + (offDraft[r[0]] || 0) + '" aria-label="Minutes to add to ' + r[1] + '">' +
        '<button type="button" data-k="' + r[0] + '" data-d="1" aria-label="Add a minute to ' + r[1] + '">+</button></div>';
    });
    $('offList').innerHTML = h;
  }
  $('offList').addEventListener('input', function (e) {
    var k = e.target.dataset.k; if (!k) return;
    var v = e.target.value.trim() === '' ? 0 : Number(e.target.value); offDraft[k] = isFinite(v) ? v : 0;
  });
  $('offList').addEventListener('click', function (e) {
    var b = e.target.closest('button[data-k]'); if (!b) return;
    var inp = $('offList').querySelector('input[data-k="' + b.dataset.k + '"]');
    var v = Math.max(-120, Math.min(120, Math.round(Number(inp.value) || 0) + Number(b.dataset.d)));
    inp.value = v; offDraft[b.dataset.k] = v;
  });
  $('customBox').addEventListener('input', function () { buildOffsets(); });
  $('customBox').addEventListener('change', function () { buildOffsets(); });

  function fillOptions() {
    var s = settings;
    offDraft = Object.assign({}, s.offsets || {});
    $('oMethod').value = s.method;
    fillCustom(s); showMethod(s.method, s);
    $('oIshraq').value = s.ishraqAlt; $('oMakruh').value = s.asrMakruhAlt;
    $('oHijri').checked = !!s.addHijriDate; $('oQibla').checked = !!s.addQiblaTime; $('o24').checked = !!s.use24;
    $('optErr').textContent = '';
    buildOffsets(true);
  }
  /** Show the summary (presets) or the editable fields (custom). */
  function showMethod(id, st) {
    $('customBox').hidden = id !== 'custom';
    $('methodInfo').hidden = id === 'custom';
    if (id !== 'custom') methodSummary(st, id);
  }
  $('oMethod').addEventListener('change', function () {
    var id = $('oMethod').value, tmp = Object.assign({}, settings);
    if (id !== 'custom') { M.applyMethod(tmp, id); fillCustom(tmp); }      // so “Custom” starts from this method
    showMethod(id, tmp);
    buildOffsets(true);
  });

  /** "15, 18" -> [15, 18]; null if empty, malformed, out of 6..24, or more than 4 values. */
  function parseAngles(text) {
    var parts = String(text).replace(/[،;]/g, ',').split(/[,\s]+/).filter(Boolean), out = [];
    if (!parts.length || parts.length > 4) return null;
    for (var i = 0; i < parts.length; i++) {
      var v = Number(parts[i]);
      if (!isFinite(v) || v < 6 || v > 24) return null;
      v = Math.round(v * 100) / 100;
      if (out.indexOf(v) < 0) out.push(v);
    }
    return out;
  }
  function numIn(id, lo, hi) { var t = $(id).value.trim(), v = Number(t); return (t !== '' && isFinite(v) && v >= lo && v <= hi) ? v : null; }
  function optFail(msgText, focusId) { $('optErr').textContent = msgText; if (focusId) $(focusId).focus(); }

  $('optForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var s = Object.assign({}, settings), id = $('oMethod').value;
    var ish = numIn('oIshraq', 0.1, 10), mak = numIn('oMakruh', 0.1, 10);
    if (ish === null) return optFail('Ishraq altitude must be between 0.1° and 10°.', 'oIshraq');
    if (mak === null) return optFail('Asr Makruh altitude must be between 0.1° and 10°.', 'oMakruh');
    if (id !== 'custom') {
      M.applyMethod(s, id);
    } else {
      var byF = document.querySelector('input[name=fajrBy]:checked').value === '1';
      var byI = document.querySelector('input[name=ishaBy]:checked').value === '1';
      var byM = document.querySelector('input[name=magBy]:checked').value === '1';
      if (byF) { var fa = parseAngles($('oFajrDepr').value); if (!fa) return optFail('Fajr angles must be numbers between 6 and 24, separated by commas (at most 4), e.g. 15, 18.', 'oFajrDepr'); s.fajrAngles = fa; }
      else { var fi = numIn('oFajrInt', 20, 120); if (fi === null) return optFail('Fajr interval must be between 20 and 120 minutes.', 'oFajrInt'); s.fajrInterval = Math.round(fi); }
      if (byI) { var ia = parseAngles($('oIshaDepr').value); if (!ia) return optFail('Isha angles must be numbers between 6 and 24, separated by commas (at most 4), e.g. 15, 18.', 'oIshaDepr'); s.ishaAngles = ia; s.ishaRamadanInterval = 0; }
      else {
        var ii = numIn('oIshaInt', 20, 120), ir = numIn('oIshaRam', 0, 180);
        if (ii === null) return optFail('Isha interval must be between 20 and 120 minutes.', 'oIshaInt');
        if (ir === null || (ir > 0 && ir < 20)) return optFail('Ramadan interval must be 0 (same) or between 20 and 180 minutes.', 'oIshaRam');
        s.ishaInterval = Math.round(ii); s.ishaRamadanInterval = Math.round(ir);
      }
      var md = 0;
      if (byM) { md = numIn('oMagDepr', 0.1, 8); if (md === null) return optFail('Maghrib angle must be between 0.1° and 8°.', 'oMagDepr'); }
      s.fajrByDepr = byF ? 1 : 0; s.ishaByDepr = byI ? 1 : 0; s.maghribDepr = md;
      ensureAngles(s);
    }
    s.ishraqAlt = ish; s.asrMakruhAlt = mak;
    var no = {}, bad = null;
    offRows(s).forEach(function (r) {
      var v = Number(offDraft[r[0]] || 0);
      if (!isFinite(v) || v !== Math.round(v) || v < -120 || v > 120) bad = bad || r[1];
      else if (v) no[r[0]] = v;
    });
    if (bad) return optFail('Minutes for ' + bad + ' must be a whole number between −120 and +120.');
    s.offsets = no;
    s.addHijriDate = $('oHijri').checked ? 1 : 0; s.addQiblaTime = $('oQibla').checked ? 1 : 0; s.use24 = $('o24').checked ? 1 : 0;
    s.method = id;
    settings = s; save('settings', settings); fillOptions(); renderCurrent(); showTab('prayer');
  });
  $('oReset').addEventListener('click', function () {
    settings = Object.assign(M.defaultSettings(), { use24: 0, offsets: {} }); ensureAngles(settings);
    M.applyMethod(settings, DEFAULT_METHOD); settings.method = DEFAULT_METHOD;
    save('settings', settings); fillOptions(); renderCurrent();
  });

  // ============================================================== init
  function renderCurrent() { if (!loc) return; renderPrayer(); renderQibla(); }

  function init() {
    rebuildPlaces();
    var months = M.MONTH;
    ['pMonth', 'qMonth'].forEach(function (id) { fillMonths($(id), months, today.m); });
    ['pHMonth', 'cvHMonth', 'nmMonth'].forEach(function (id) { fillMonths($(id), M.HIJRI_MONTH, 1); });
    $('pYear').value = today.y; $('qYear').value = today.y;
    var wk = new Date(today.y, today.m - 1, today.d + 6);
    $('pFrom').value = iso(today.y, today.m, today.d); $('pTo').value = iso(wk.getFullYear(), wk.getMonth() + 1, wk.getDate());
    $('pDate').value = iso(today.y, today.m, today.d); $('qDate').value = iso(today.y, today.m, today.d);
    $('cvDate').value = iso(today.y, today.m, today.d);
    $('maDate').value = iso(today.y, today.m, today.d); $('maTime').value = pad2(now.getHours()) + ':' + pad2(now.getMinutes());
    ['Ds', 'De'].forEach(function (pre) {
      setOptions($('c' + pre + 'Num'), NUMS, pre === 'Ds' ? 2 : 1);
      setOptions($('c' + pre + 'Dow'), DOWS, 2);
      setOptions($('c' + pre + 'Mon'), months.map(function (n, i) { return [String(i + 1), n]; }), pre === 'Ds' ? 3 : 11);
    });
    $('oMethod').innerHTML = methodsHtml();

    var savedPlace = load('place', null) || GAZ.current;
    loc = M.makeLocation(savedPlace);
    var h = M.X2H(today.y, today.m, today.d, loc.tz);
    $('cvHMonth').value = h.month; $('cvHDay').value = h.day; $('cvHYear').value = h.year;
    $('pHMonth').value = h.month; $('pHYear').value = h.year; $('nmMonth').value = h.month; $('nmYear').value = h.year;
    fillOptions(); fillLocForm(savedPlace); renderPlaceList();
    setLocation(savedPlace, false);
    setPrayerMode('day'); setQiblaMode('angle');
    var start = (location.hash || '').slice(1) || load('tab', 'prayer');
    showTab(document.getElementById('tab-' + start) ? start : 'prayer');
  }
  init();
})();
