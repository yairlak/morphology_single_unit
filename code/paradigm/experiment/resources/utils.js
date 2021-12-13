// Neat function from https://stackoverflow.com/questions/6131051/is-it-possible-to-find-out-what-is-the-monitor-frame-rate-in-javascript
function calcFPS(a){function b(){if(f--)c(b);else{var e=3*Math.round(1E3*d/3/(performance.now()-g));"function"===typeof a.callback&&a.callback(e);}}var c=window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame;if(!c)return!0;a||(a={});var d=a.count||60,f=d,g=performance.now();b()}

var round_fps = function(fps) {
  if (fps < 45) {
    return 30
  }
  else if (fps < 90) {
    return 60
  }
  else if (fps < 180) {
    return 120
  }
  else {
    return 240
  }
}

var FPS = 16.66666666;
