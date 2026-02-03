
<div align="center">
  <img alt="An icon representing a stack of little squared blue sticky notes. The first one, and the second one hinted below, have scribbles over them" src="data/icons/default/hicolor/128.png" />
  <h1>Jorts</h1>
  <h3>Neither jeans nor shorts, just like jorts. A sticky notes app for elementary OS</h3>

  <a href="https://elementary.io">
    <img src="https://elly-code.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>
  
<span align="center"> <img class="center" src="https://github.com/elly-code/jorts/blob/main/data/screenshots/spread.png" alt="Several colourful sticky notes in a spread. Most are covered in scribbles. One in forefront is blue and has the text 'Lovely little colourful squares for all of your notes! 🥰'"></span>
</div>

<br/>

## 🦺 Installation

You can download and install Jorts from various sources:

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.elly_code.jorts) 

[<img src="https://flathub.org/assets/badges/flathub-badge-en.svg" width="160" alt="Download on Flathub">](https://flathub.org/apps/io.github.elly_code.jorts)


On Windows:
Grab the Exe installer in Release


## ❓ Questions, building, etc

[Check the wiki, lol](https://github.com/elly-code/jorts/wiki/%F0%9F%8F%A1Home)



## 🛣️ Roadmap

Jorts is a cute simple and lightweight little notes app, and i wanna keep it this way
Top priority is to have the clearest, simplest, most efficient code ever



## 💝 Donations

On the right you can donate to various contributors:
 - teamcons, the main devs and maintainers behind jorts
 - wpkelso, the author of the modern icon and its Pride variant
 - lains, the initial creator of the app (It was Notejot, now something very different)


## 💾 Notes Storage


Notes are stored in `~/.var/app/io.github.elly_code.jorts/data`

You can get it all by entering in a terminal:

```bash
cp ~/.var/app/io.github.elly_code.jorts/data ~/
```

"saved_state.json" contains all notes in JSON format. The structure is quite simple, if not pretty.

The app reads from it only during startup (rest of the time it writes in) so you could quite easily swap it up to swap between sets of notes.



ON WINDOWS: It's in:

YourUserFolder \AppData\Local\io.github.elly_code.jorts

AppData is a hidden folder. Either you paste the above path in the path bar, from your user folder
Or you do a "Show hidden files"
