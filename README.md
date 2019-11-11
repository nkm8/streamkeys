## Streamkeys Quantum Beta

Firefox extension to send "global" (ie. across the browser) hotkeys to various online media players.

This extension is the fork of [Streamkeys](https://github.com/berrberr/streamkeys) Chrome extension.
It's the first Firefox Quantum extension with the ability to capture Play/Pause/Next/Prev button events globally (so you can control your music even if the browser is minimized).

**Attention!** At the time this extension works only on Windows OS (XP to 10). It requires an installation of additioal software *SKQGlobalCommandSupport*.
It's 100% opensource and contains no viruses nor spyware. It is as small as 850 kilobytes and consumes only 2 Mb of RAM.

**First beta version does not support key configuration.**
Default config is mapped to media keys on yor keyboard. If you have no such, please wait for the next version with remapping support or consider buying more modern keyboard.
Even $5-$10 keyboards from your local store have such keys in 2018.

## SKQGlobalCommandSupport application compiling

Use "AutoIt3Wrapper GUI to Compile AutoIt3 Script" application to compile .au3 file into .exe

Copy signed .xpi file with proper filename to folder /win32au3/extension. 
Then Use InnoSetup with provided config to make an installer, (you may need to adjust file paths in .iss file).

## Streamkeys Javascript webextension compiling

### Installation

#### Requirements

- Node.js

#### Install

Clone the repo and then

```bash
$ npm install
```

to install dependencies. Then to build the extension run

```bash
$ grunt dev
```

## Grunt Tasks

- `grunt dev`: Lints `code/*`, runs browserify and copies built code to `build/unpacked-dev/` and `test/streamkeys-ext/`

- `grunt rel`: Lints `code/*`, runs browserify and uglify and copies built code to `build/unpacked-prod/` and `test/streamkeys-ext/`

- `grunt watch`: Watches for changes to JS files in `code/*`, lints `code/*`, runs browserify and copies built code to `build/unpacked-dev/`

- `grunt lint`: Lints `code/*`

## Info

This extension works by sending click events to the elements that control the music player. Each music site has an associated controller which contains the css selectors for the play/pause/next/previous/mute buttons (where available). In addition there is a BaseController module which contains common functions that are shared across all controllers.

The background script routes hotkey presses from the user to the correct tab (ie., the media player(s) tab) if the media player site is enabled.

## Adding Sites

Adding a new site to the extension is straight forward. There are 3 steps:

#### 1. Add site controller

Figure out the css selectors for a site's media player buttons and create a new controller in `code/js/controllers/`. Naming scheme is `{Sitename}Controller.js`. You should copy code from an exisiting controller as a template. Here is an example controller for Fooplayer:

```javascript
Filename: FooplayerController.js

;(function() {
  "use strict";

  var BaseController = require("BaseController");

  new BaseController({
    playPause: "#play_btn",
    playNext: "#next_btn",
    playPrev: "#prev_btn",
    mute: "#mute_btn",

    playState: "#play_btn.playing",
    song: "#song",
    artist: "#artist"
  });
})();
```

##### Special controller properties:

- `buttonSwitch` - Used to determine playing state. Set to `true` if a site only shows the pause button when it's playing and only shows the play button when it's paused.
- `playState` - Used to determine playing state. Set to the selector that will return `true` if the player is playing. Example: `playState: "#play_btn.playing"`
- `iframe` - Used when the player is nested inside an iframe. Set to the selector of the iframe containing the player. Example: `iframe: "#player-frame"`

**Note**: One of `buttonSwitch` or `playState` should (almost) always be set. If `buttonSwitch` is true then your controller **must** define both `play` and `pause` selectors. If a `playState` is defined, then you controller might have either a single `playPause` selector or both `play` and `pause` selectors.

#### 2. Add site to sitelist

Next, add the site to the Sitelist object in `code/js/modules/Sitelist.js`.

```javascript
"fooplay": { name: "Fooplay", url: "http://www.fooplayer.com" }
```

The object key name is very important. It serves two purposes: constructs the site's controller name as well as builds the regular expression which will be used to check URLs to inject the controller into. It is important that the url is correct, and that the object's key name is contained in the URL.

If it is not possible for the object's key name to be part of the sites URL then you can add the optional `alias` array field to the object which will add the array's contents into the regular expression to match URLs. For example, for lastFM:

```javascript
"last": { name: "LastFm", url: "http://www.last.fm", controller: "LastfmController.js", alias: ["lastfm"] }
```

the alias here will match URLs: last.* AND lastfm.*

The logic to construct the controller name is: Capitalized object key + "Controller". So, using the above example we should name our LastFM controller: "LastController" based on that key name.

If it is not possible for the controller file to be named according to that scheme then add the optional `controller` property to the site object and put the FULL controller name there, for example: "SonyMusicUnlimitedController.js"

## Tests

There is a Karma test suite that simulates core extension functionality. The automated Travis-CI will trigger on every pull request/push.

To run the tests locally, simply

```bash
$ grunt test
```


### License: GPLv3
(c) 2018 Egor Aristov

### Original work:
License: MIT (c) 2014 Alex Gabriel
