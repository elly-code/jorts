project(
    'jorts',
    'vala', 'c',
    version: '4.2.0',
    license: 'GPL-3.0-or-later'
)

app_name = meson.project_name()
app_version = meson.project_version()

correct_app_id = 'io.github.elly_code.' + app_name
correct_app_path = '/io/github/elly_code/' + app_name

legacy_app_id = 'io.github.ellie_commons.' +  app_name
legacy_app_path = '/io/github/ellie_commons/' + app_name


vala_flags = []

if get_option('legacy-rdnn')
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = legacy_app_path

    #TODO: Remove once appcenter has latte
    vala_flags += ['--define', 'LATTE']
else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = correct_app_path
endif

development_build = get_option('development')
if development_build
  app_id +=  '.devel'
  vala_flags += ['--define', 'DEVEL']
  vala_flags += ['--define', 'LATTE']
endif

#================================
# Cool icon variants
variant = get_option('variant')

if variant == 'pride'
    vala_flags += ['--define', 'PRIDE']
elif variant == 'halloween'
    vala_flags += ['--define', 'HALLOWEEN']
else
    vala_flags += ['--define', 'DEFAULT']
endif

#================================
gnome = import('gnome')
i18n = import('i18n')

# Windows needs icons, special arguments, and skip libportal
windows_build = get_option('windows_build')
if build_machine.system() == 'windows'
    windows_build = true
endif

if windows_build
    vala_flags += ['--define', 'WINDOWS']
endif

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (app_name), language:'c')



#================================
# Add subfolders for Meson to look

config_data = configuration_data(
    {
        'APP_NAME': app_name,
        'APP_ID': app_id,
        'APP_PATH': app_path,
        'APP_VERSION': app_version,
        'ALTERNATE_APP_ID': alternate_app_id,
        'LOCALEDIR': get_option('prefix') / get_option('localedir')
    }
)

subdir('po')
subdir('data')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )

if development_build
message('''
    
You now have a development version installed.
Here be dragons.

''')
endif