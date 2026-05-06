#
#   FONTS
#

# CAREFUL HERE: In the flatpak, the apps cant find it 
target_font_dir = get_option('datadir') / 'fonts'

install_data(
    'RedactedScript-Regular.ttf',
    install_dir: target_font_dir,
)

# You want to call fc-cache on install unless DESTDIR is set;
# distro packages (and flatpak) rebuild the fontconfig cache themselves in bulk, and they set DESTDIR when running meson install
#fontconfig = find_program('fc-cache', required: true)
#meson.add_install_script(fontconfig, target_font_dir)

