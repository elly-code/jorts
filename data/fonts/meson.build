#
#   FONTS
#

# Unpackaged: /usr/share/fonts
# Flatpak: /app/share/fonts
# Windows: fonts subdir is currently skipped on win builds
target_font_dir = datadir / 'fonts'

install_data(
    'RedactedScript-Regular.ttf',
    install_dir: target_font_dir
)


# You want to call fc-cache on install unless DESTDIR is set;
# distro packages (and flatpak) rebuild the fontconfig cache themselves in bulk, and they set DESTDIR when running meson install
# Windows doesnt need because it is bundled in an installer, and this subdir is skipped

fontconfig = find_program('fc-cache', required: true)

meson.add_install_script(
    fontconfig,
    target_font_dir,
    skip_if_destdir: true
)

