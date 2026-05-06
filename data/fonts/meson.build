#
#   FONTS
#

# CAREFUL HERE: In the flatpak, the apps cant find it 
target_font_dir = get_option('datadir') / 'fonts'

install_data(
    'RedactedScript-Regular.ttf',
    install_dir: target_font_dir
)

# Regen font cache, only in cases it is relevant
fontconfig = find_program('fc-cache', required: true)

meson.add_install_script(
    fontconfig,
    target_font_dir,
    skip_if_destdir: true
)

