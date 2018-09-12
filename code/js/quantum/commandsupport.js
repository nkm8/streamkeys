;(function() {
  "use strict";

  // Unfortunately, the original extension used very outdated build chain, so it does not even support ES2015.
  //TODO: Change the whole build chain, move from grunt and browserify to webpack

  var commands = ["playPause", "playNext", "playPrev", "stop", "mute", "like", "dislike"];

  var getCommands = function() {
    return commands;
  };

  var port = null;

  var connectToGCS = function() {
    if(!port)
      port = browser.runtime.connectNative("skqgcs");
  };

  var listenForCommands = function(callback) {
    connectToGCS();
    port.onMessage.addListener(function(response) {
      console.log("Received Command: " + response);
      if(~commands.indexOf(response)) {
        callback(response);
      }
    });
  };

  module.exports = {
    getCommands: getCommands, listenForCommands: listenForCommands
  };

})();
