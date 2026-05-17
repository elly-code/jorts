
<div align="center">
  <img alt="An icon representing a stack of little squared blue sticky notes. The first one, and the second one hinted below, have scribbles over them" src="data/icons/default/hicolor/128.png" />
  <h1>Jorts</h1>
  <h3>Neither jeans nor shorts, just like jorts. A sticky notes app for elementary OS</h3>

  <a href="https://elementary.io">
    <img src="https://ellie-commons.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>
  
<span align="center"> <img class="center" src="https://github.com/elly-code/jorts/blob/main/data/screenshots/spread.png" alt="Several colourful sticky notes in a spread. Most are covered in scribbles. One in forefront is blue and has the text 'Lovely little colourful squares for all of your notes! 🥰'"></span>
</div>

<br/>



## 🦺 Installation

You can download and install Jorts from various sources:

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.elly_code.jorts) 
[<img src="https://flathub.org/assets/badges/flathub-badge-en.svg" width="160" alt="Download on Flathub">](https://flathub.org/apps/io.github.ellie_commons.jorts)


On Windows: Grab the Exe installer in Release
Not all releases have an exe, because bundling for Windows and testing it works is a HASSLE.




## ❓ Questions, building, etc


You may want to check the [documentation](https://github.com/elly-code/jorts/tree/main/docs)

Issues are all filed [here in the Issues tab](https://github.com/elly-code/jorts/issues)

You can also [come over in matrix](https://matrix.to/#/#elly-code:matrix.org) to talk to me directly




## 🛣️ The Future

The app is destined to stay simple. If anything there is already too much in the UI for my comfort, so do not expect /more/

Roadmap:
 - Document stuff
 - Fix an annoying memory leak where deleted notes linger in memory
 - Use Gtk 4.24 save-state new thing if it ever lands
 - More icon variants
 - Better list/bullets
 - Co-maintainers would be nice
 - More translations would be nice



## 💝 Donations

On the right you can donate to various contributors:
 - teamcons, the main devs and maintainers behind jorts
 - wpkelso, the author of the modern icon and its Pride variant
 - lains, the initial creator of the app (It was Notejot, now something very different)




## 💾 Notes Storage

"saved_state.json" contains all notes in JSON format. The structure is quite simple, it is an array of objects, each representing the data of a sticky note

The app reads from it only during startup (rest of the time it writes in) so you could quite easily swap it up to swap between sets of notes.

The app writes to it everytime there is a sticky note change



### If installed from flathub (if you are not on elementary OS)

You can get it all by entering in the search bar of your file explorer:

~/.var/app/io.github.ellie_commons.jorts/data/io.github.ellie_commons.jorts/

Or typing the below in a terminal, to move it to your Home folder:

```bash
cp ~/.var/app/io.github.ellie_commons.jorts/data/io.github.ellie_commons.jorts/saved_data.json ~/
```


### If installed from elementary OS appcenter

The app id is slightly different

Enter the path:

~/.var/app/io.github.elly_code.jorts/data/io.github.elly_code.jorts/

Or the command:

```bash
cp ~/.var/app/io.github.elly_code.jorts/data/io.github.elly_code.jorts/saved_data.json ~/
```


### WINDOWS

Paste in the explorer window:

%localappdata%\io.github.elly_code.jorts\


### UNSUPPORTED PACKAGINGS

Check out in ~/.local/share

It likely is there
