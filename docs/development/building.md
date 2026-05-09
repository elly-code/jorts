

# Building

1. [Prerequisite](#prerequisite)
2. [Setup Meson](#setup-meson)
3. [Installing](#installing)
4. [Tools](#tools)


## 1. Prerequisite

Please make sure you have these dependencies first before building Jorts.

* libgranite-7-dev
* gtk+-4.0
* libjson-glib-dev
* libgee-0.8-dev
* libjson-glib
* libportal-gtk4-dev
* meson
* valac

As of the current date (4th May 2026), here is the command to install on...

elementary OS

```bash
sudo apt install elementary-sdk
```

Ubuntu

```bash
sudo apt install libgranite-7-common libjson-glib-1.0-0 libgee-0.8-2 meson libvala-0.56-0 libportal-gtk4-dev
```

Fedora

```bash
sudo dnf install granite-7-devel json-glib-devel libgee-devel meson libvala libportal-devel
```


## Setup Meson

### configure

It is recommended to create a clean build environment. Run `meson` to configure the build environment and then `ninja` to build
"cd" into the source folder, then

```bash
meson setup builddir --prefix=/usr
```

Once the building is done you can

```bash
cd builddir
```

then compile

```bash
ninja
```

Update translations

```bash
ninja jorts-pot ; ninja jorts-update-po
ninja extra-pot ; ninja extra-update-po
```



## Installing

Note that Jorts assume it is in a sandbox by default

To install, use `ninja install`, then execute with `io.github.elly_code.jorts`

```bash
ninja install
```

```bash
io.github.elly_code.jorts
```

you can also just run the binary in builddir if you do not wish to install

To uninstall, navigate to the same folder, then 

```bash
ninja uninstall
```



## Tools

You can check out [the elementary OS developer tools](https://docs.elementary.io/contributor-guide/development/developer-tools)