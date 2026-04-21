# Other packaging formats and OSes

## On Windows

1. First go on a Windows box, 

2. [and install MSYS2, which is some kind of linux subsystem thingie](https://www.msys2.org/)

3. Then from the MSYS2 shell navigate to whatever folder you put the sources in, and cd into said folder

4. run the "./windows/prep.sh" script. It will install all needed dependencies with Pacman

5. Then run "./windows/deploy.sh". It will:
* build the app. Meson includes the extra cruft for windows stuff
* then compile it like grandma does when she cooks
* then move it along with needed dependencies in the deploy
* then create an NSIS script for an installer with everything
* then create the installer

6. The resulting exe has everything bundled up in it, including uninstaller.
It is built so as to not need admin rights. You can distribute as is.

## Without packaging

Please make sure you have these dependencies first before building Jorts.

`libgranite-7-dev`
`gtk+-4.0`
`libjson-glib-dev`
`libgee-0.8-dev`
`libjson-glib`
`meson`
`libvala`

As of the current date (18Feb2025), here are the package names to install:

```bash
sudo apt install libgranite-7-common libjson-glib-1.0-0 libgee-0.8-2 meson libvala-0.56-0
```

It's recommended to create a clean build environment. Run `meson` to configure the build environment and then `ninja` to build
"cd" into the source folder, then
```bash
meson builddir --prefix=/usr
```
```bash
cd builddir
```
```bash
ninja
```

To install, use `ninja install`, then execute with `io.github.elly_code.jorts`

```bash
ninja install
```
```bash
io.github.elly_code.jorts
```

you can also just run the binary in builddir

## Snap?

Idk how to do that, havent looked into it and not sure if worth it.



## Appimage?

Idk how to do that, havent looked into it and not sure if worth it.


## DEB/RPM/idkstuff

Is there demand? I dont wanna bother with that...
For packagers: A tweak would be to have Jorts create a data directory instead of using its root.

Jorts just checks whether DATA_DIR exists since in a fresh sandbox it isnt a given, then just dump into it with no regards (since it is expected it does not share the space with other apps) 

Windows has a check in place, you can just remove the "#if WINDOWS"-"#endif" plumbing, and ensure Jorts create a folder with rdnn instead of just "Jorts" (there is no way to rebase between app-id on windows and other apps dont use rdnn anyway)


## Mac OS?
[An attempt has been made](https://github.com/elly-code/jorts/pull/115)

The big hurdles are:
- DBus isnt a thing on MacOS
- Just like Windows, no LibPortal
- CSS theming seems broken?
- It apparently is crashy
