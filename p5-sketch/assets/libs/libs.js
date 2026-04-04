// Auto-generated - reads libraries from p5.json at runtime
(function() {
  function loadLibs() {
    // Fetch p5.json to get list of libraries
    fetch('p5.json')
      .then(function(response) { return response.json(); })
      .then(function(config) {
        var libsObj = config.libs || {};
        // Convert object {name: version} to array of names
        var libs = Object.keys(libsObj);
        return loadLibsSequential(libs, 0);
      })
      .catch(function(err) {
        console.warn('Could not load p5.json:', err);
      });
  }

  function loadLibsSequential(libs, index) {
    if (index >= libs.length) return Promise.resolve();

    var lib = libs[index];
    // Skip core libs (p5 and p5.sound are bundled)
    if (lib === 'p5' || lib === 'p5.sound') {
      return loadLibsSequential(libs, index + 1);
    }

    return new Promise(function(resolve) {
      var script = document.createElement('script');
      script.src = 'assets/libs/' + lib + '.js';
      script.onload = function() { 
        console.log('Loaded: ' + lib);
        resolve(); 
      };
      script.onerror = function() { 
        console.warn('Failed to load: ' + lib); 
        resolve(); 
      };
      document.head.appendChild(script);
    }).then(function() {
      return loadLibsSequential(libs, index + 1);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadLibs);
  } else {
    loadLibs();
  }
})();

