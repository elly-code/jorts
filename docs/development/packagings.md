
# Other packaging formats and OSes

## Snap

Idk how to do that, havent looked into it and not sure if worth it.


## Appimage

AppImages are built by the sqgipkg release path below.


## sqgipkg release path

Jorts has a `sqgipkg.json` manifest and a GitHub release workflow that builds:

- `dist-linux-x86_64/Jorts.AppImage`
- `dist-linux-aarch64/Jorts.AppImage`
- `dist-windows-x86_64/Jorts-Setup.exe`

This is release plumbing, not a replacement for Meson.

Meson should still own as much of the app build as possible:

- project version, app id, app path, and generated `Config.vala`
- gresource, gschema, desktop, metainfo, and translations
- the Windows executable resources
- the manual Windows `deploy.sh` and NSIS template in `windows/`
- compiling the app itself

sqgipkg plugs into that by calling Meson, then staging the runtime bits that a
portable bundle needs. In other words: if another packaging method appears
later, it should still be able to start from the Meson build without needing to
copy sqgipkg-specific logic.

The manifest currently does this:

- Builds Linux AppImages for x86_64 and aarch64 from Ubuntu noble package data.
- Builds GTK and Granite from pinned upstream tags for the Linux AppImage path,
  so the AppImages do not depend on whatever Granite/GTK version the CI host has.
- Builds the Windows executable with Meson and MinGW, then stages MSYS2 runtime
  packages into a Windows directory and wraps that directory in an NSIS installer
  using the `nsis_options` in `sqgipkg.json`.
- Stages GTK settings, schemas, themes, icon themes, pixbuf SVG loading support,
  fonts, app icons, and the app metadata needed by the bundles.

Important icon/theme detail: the app sets the GTK icon theme to `elementary`.
The bundles therefore need the elementary icon theme as runtime data, not just
the elementary GTK stylesheet. If icons disappear while the theme still works,
check `sqgipkg.json` first:

- Linux package lists should include `elementary-icon-theme`.
- Windows package lists should include `mingw-w64-x86_64-elementary-icon-theme`.
- Both bundles also need SVG icon loading support (`librsvg`/gdk-pixbuf loader
  data), because many symbolic icons are SVG files. On Windows, keep
  `mingw-w64-x86_64-gdk-pixbuf2` explicit so the bundle includes
  `gdk-pixbuf-query-loaders.exe` for the runtime loader cache.

### Local build commands

The release workflow checks out sqgi at `v0.1.0-alpha.1`. For local testing,
use the same checkout or pass the same source directory that CI uses:

```bash
git clone --branch v0.1.0-alpha.1 https://github.com/supercamel/sqgi.git ../sqgi
cmake -S ../sqgi -B ../sqgi/build -G Ninja -DCMAKE_BUILD_TYPE=Release -DSQ_ENABLE_JIT=ON
cmake --build ../sqgi/build
sudo cmake --install ../sqgi/build --prefix /usr/local
sudo ldconfig
```

Then from the Jorts source tree:

```bash
sqgipkg --target appimage --appimage-arch x86_64 --sqgi-source-dir ../sqgi
sqgipkg --target appimage --appimage-arch aarch64 --sqgi-source-dir ../sqgi
sqgipkg --target win-nsis --sqgi-source-dir ../sqgi
```

For quicker Windows debugging, build only the staged directory:

```bash
sqgipkg --target win-dir --sqgi-source-dir ../sqgi
```

That writes `dist-windows-x86_64/Jorts`, which is easier to inspect than the
installer. For example, if Windows icons are broken, check that
`dist-windows-x86_64/Jorts/share/icons/elementary` exists and that
`dist-windows-x86_64/Jorts/etc/gtk-4.0/settings.ini` says
`gtk-icon-theme-name=elementary`.

### GitHub release workflow

The release workflow lives at `.github/workflows/release.yml`.

It runs on plain version tags like `4.2.1`. Jorts release tags are `x.y.z`,
not `vX.Y.Z`.

The workflow:

1. Checks out Jorts.
2. Checks out sqgi at `v0.1.0-alpha.1`.
3. Builds and installs sqgi/sqgipkg.
4. Runs sqgipkg for both Linux AppImages and the Windows NSIS installer.
5. Uploads the artifacts.
6. Creates or updates the GitHub release for the tag.

To trigger a release build, push a plain version tag:

```bash
git tag -a 4.2.1 -m "4.2.1"
git push origin 4.2.1
```

For test runs, prefer a temporary branch or workflow dispatch when possible.
If a real version tag is reused for testing, remember that force-moving tags can
confuse anyone watching releases.


## DEB/RPM/etc

Is there demand? I dont wanna bother with that...
For packagers: A tweak would be to have Jorts create a data directory instead of using its root.

Jorts just checks whether DATA_DIR exists since in a fresh sandbox it isnt a given, then just dump into it with no regards (since it is expected it does not share the space with other apps) 

Windows has a check in place, you can just remove the "#if WINDOWS"-"#endif" plumbing, and ensure Jorts create a folder with rdnn instead of just "Jorts" (there is no way to rebase between app-id on windows and other apps dont use rdnn anyway)


## Mac OS

[An attempt has been made](https://github.com/elly-code/jorts/pull/115)

The big hurdles are:
- DBus isnt a thing on MacOS
- Just like Windows, no LibPortal
- CSS theming seems broken?
- It apparently is crashy
