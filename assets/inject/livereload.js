(function() {
  var ws = null, ra = 0, mr = 10;
  function co() {
    ws = new WebSocket('ws://localhost:__LR_PORT__');
    ws.onopen = function() { ra = 0; };
    ws.onclose = function() { if (ra < mr) { ra++; setTimeout(co, Math.min(1000 * ra, 5000)); } };
    ws.onmessage = function(e) {
      try { var d = JSON.parse(e.data); if (d.type === 'reload') window.location.reload(); } catch(e) {}
    };
  }
  co();
})();
