
target_font_dir = get_option('datadir') / 'fonts' / 'truetype' / 'redacted-elementary'

install_data(
    'RedactedScript-Regular.ttf',
    install_dir: target_font_dir,
)

# We need to regen the font cache or else the font will not be usable
fontconfig = find_program('fc-cache', required: true)


#out = run_command(fontconfig, target_font_dir, check: true)
#message(out.stdout().strip())

meson.add_dist_script('fontconfig.sh')

