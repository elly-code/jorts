# Name our project
project('io.github.elly_code.jorts', ['vala', 'c'],
    version: '4.0.1'
)

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')
windows_build = build_machine.system() == 'windows'


#================================
# Set flags for icon variants, and target in the case of windows builds

vala_flags = []
variant = get_option('variant')[0]

if variant == 'pride'
    vala_flags = ['--define', 'PRIDE']
elif variant == 'halloween'
    vala_flags = ['--define', 'HALLOWEEN']
elif variant == 'classic'
    vala_flags = ['--define', 'CLASSIC']
else
    vala_flags = ['--define', 'DEFAULT']
endif

if windows_build
    vala_flags += ['--define', 'WINDOWS']
endif

add_project_arguments(vala_flags, language: 'vala')

#================================
# Import the stylesheet

## Set de config data
config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

# Le stylesheet
gresource = gnome.compile_resources(
    'gresource',
    'data' / 'jorts.gresource.xml',
    source_dir: 'data'
)

#================================
# dependencies

dependencies = [
        dependency('granite-7'),
        dependency('gobject-2.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk4'),
    ]

# We need to compile an icon into the exe to avoid "missing icon" icon at every turn
# Libportal is not available in MSYS2, built the file only on linuxes
if windows_build
    dependencies += dependency('gio-windows-2.0')
    ico_src = import('windows').compile_resources('windows/icons/ico.rc')

else
    dependencies += dependency('gio-unix-2.0')
    dependencies += dependency('libportal')
endif


#================================
# Add subfolders for Meson to look
subdir('data')
subdir('po')
subdir('src')


gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )
