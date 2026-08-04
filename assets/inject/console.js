(function() {
  var oc = { log: console.log, error: console.error, warn: console.warn, info: console.info };
  var oe = window.onerror;
  var hooked = false;
  function st(l, a) {
    var m = a.map(function(a) { return typeof a === 'object' ? JSON.stringify(a) : String(a) }).join(' ');
    fetch('/api/console/log', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ type: 'console', level: l, message: m, source: 'browser', timestamp: new Date().toISOString() }) }).catch(function() {});
  }
  function hook() {
    if (hooked) return;
    hooked = true;
    console.log = function() { oc.log.apply(console, arguments); st('log', arguments); };
    console.error = function() { oc.error.apply(console, arguments); st('error', arguments); };
    console.warn = function() { oc.warn.apply(console, arguments); st('warn', arguments); };
    console.info = function() { oc.info.apply(console, arguments); st('info', arguments); };
    window.onerror = function(m, s, l, c) { st('error', [m + ' at ' + s + ':' + l + ':' + c]); return false; };
  }
  function unhook() {
    if (!hooked) return;
    hooked = false;
    console.log = oc.log;
    console.error = oc.error;
    console.warn = oc.warn;
    console.info = oc.info;
    window.onerror = oe;
  }
  function check() {
    fetch('/api/cdp/status')
      .then(function(r) { return r.json(); })
      .then(function(j) {
        if (j && j.connected) unhook(); else hook();
      })
      .catch(function() { hook(); });
  }
  if (window.__P5_CDP_ACTIVE) unhook(); else hook();
  setInterval(check, 3000);
})();
