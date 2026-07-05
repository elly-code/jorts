#
#   METADATA
#

#========================
# GRESOURCE

gresource_file = configure_file(
    input: app_name + '.gresource.xml.in',
    output: app_id + '.gresource.xml',
    configuration: config_data,
)

glib_compile_resources = find_program('glib-compile-resources')

gresource = gnome.compile_resources(
    'gresource',
    gresource_file,
    source_dir: '.'
)


#========================
# GSCHEMA

gschema_file = configure_file(
    input: app_name + '.gschema.xml.in',
    output: app_id + '.gschema.xml',
    configuration: config_data,
)

install_data(
    gschema_file,
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)


#========================
# metainfo confuses windows, icons are handled differently there, 
# So we finish early
if windows
    subdir_done()
endif

#========================
# ICONS
subdir('icons')


#========================
# FONTS
subdir('fonts')


#========================
# DESKTOP
# Inject some variables into the desktop file before merging in the translations

desktop_file_in = configure_file(
    input: app_name + '.desktop.in.in',
    output: app_id + '.desktop.in',
    configuration: config_data,
)

desktop_file = i18n.merge_file(
    input: desktop_file_in,
    output: app_id + '.desktop',
    po_dir: meson.project_source_root() / 'po' / 'extra',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications',
)




#========================
# METAINFO
# Inject some variables into the metainfo file before merging in the translations

appstream_file_in = configure_file(
    input: app_name + '.metainfo.xml.in.in',
    output: app_id + '.metainfo.xml.in',
    configuration: config_data,
)

appstream_file = i18n.merge_file(
    input: appstream_file_in,
    output: app_id + '.metainfo.xml',
    po_dir: meson.project_source_root() / 'po' / 'extra',
    type: 'xml',
    install: true,
    install_dir: get_option('datadir') / 'metainfo',
)

