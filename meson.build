project(
    'jorts',
    ['c', 'vala'],
    version: '4.3.0',               # Versioning: first should follow Gtk version, second and third depending how proud you are of the update
    license: 'GPL-3.0-or-later',
    meson_version: '>= 0.59.0'      # update_desktop_database arg in gnome.post_install
)

app_name = meson.project_name()
app_version = meson.project_version()

correct_app_id = 'io.github.elly_code.' + app_name
correct_app_path = '/io/github/elly_code/' + app_name

legacy_app_id = 'io.github.ellie_commons.' +  app_name
legacy_app_path = '/io/github/ellie_commons/' + app_name

legacy_rdnn = get_option('legacy_rdnn')
if legacy_rdnn
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = legacy_app_path

    #TODO: Remove once appcenter has latte (platform 8.3 lands)
    add_project_arguments('--define=LATTE', language: 'vala')

else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = correct_app_path
endif

development = get_option('development')
if development
  app_id +=  '.devel'
  add_project_arguments('--define=DEVEL', '--define=LATTE', language: 'vala')

endif

gnome = import('gnome')
i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (app_name), language:'c')

#================================
# Cool icon variants
icon_variant = get_option('icon_variant')

if icon_variant == 'halloween'
    add_project_arguments('--define=HALLOWEEN', language: 'vala')

else
    add_project_arguments('--define=DEFAULT', language: 'vala')

endif

#================================
# OS and Ports related

linux = get_option('profile') == 'linux'
windows = get_option('profile') == 'windows'

libportal = true

# Here is to autodetect and adjust
# Remember however that people may do cross compiling, so do not assume by default it is for linux
# So avoid else conditions adding linux stuff
build_machine_system = build_machine.system()
if build_machine_system == 'windows'
    windows = true

endif

# Here is to adjust the project accordingly to stuff
# Porting efforts: add your OS here

if windows
    add_project_arguments('--define=WINDOWS', language: 'vala')
    libportal = false

elif linux
    add_project_arguments('--define=LINUX', language: 'vala')

endif


#================================
# Play nice with clang

# https://gitlab.gnome.org/GNOME/vala/-/issues/1413#note_1707480
if meson.get_compiler ('c').get_id () == 'clang'
    add_project_arguments('-Wno-incompatible-function-pointer-types', language: 'c')
endif


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

if windows
    subdir('windows')
endif

subdir('tests')

if not windows
    gnome.post_install(
      glib_compile_schemas: true,
      gtk_update_icon_cache: true,
      update_desktop_database: true
    )
endif

if development
message('''

----------------------------------------
You now have a development version installed.
Here be dragons.
Tread carefully.
----------------------------------------

''')
endif
