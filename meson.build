project(
    'jorts',
    ['c', 'vala'],
    version: '4.2.1',
    license: 'GPL-3.0-or-later',
    meson_version: '>= 0.59.0'      # update_desktop_database arg in gnome.post_install
)

app_name = meson.project_name()
app_version = meson.project_version()

correct_app_id = 'io.github.elly_code.' + app_name
correct_app_path = '/io/github/elly_code/' + app_name

legacy_app_id = 'io.github.ellie_commons.' +  app_name
legacy_app_path = '/io/github/ellie_commons/' + app_name

vala_flags = []
development = get_option('development')
legacy_rdnn = get_option('legacy-rdnn')
windows = get_option('windows')

if legacy_rdnn
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

if development
  app_id +=  '.devel'
  vala_flags += ['--define', 'DEVEL']
  vala_flags += ['--define', 'LATTE']
endif

#================================
# Cool icon variants
icon_variant = get_option('icon-variant')

if icon_variant == 'halloween'
    vala_flags += ['--define', 'HALLOWEEN']
else
    vala_flags += ['--define', 'DEFAULT']
endif

#================================
gnome = import('gnome')
i18n = import('i18n')
android = false

# Windows needs icons, special arguments, and skip libportal
windows = get_option('windows')
if build_machine.system() == 'windows'
    windows = true
endif

if windows
    vala_flags += ['--define', 'WINDOWS']
elif host_machine.system() == 'android'
    android = true
    vala_flags += ['--define', 'ANDROID']

    #add_project_arguments(['--vapidir=' + meson.project_source_root() / 'vapi'], language: 'vala')
    add_project_arguments([
	  '--pkg=gtk4',
	  ## '--pkg=granite-9',
	  '--pkg=json-glib-1.0',
	  ## '--pkg=gee-0.8', # libgee has vapi
	  '--pkg=glib-2.0'
	], language: 'vala')
endif

# TODO: upstream -w outside this PR
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (app_name), '-w', language:'c')

# has to be done after global args
if android
    subproject('granite-stylesheet')
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

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: not android,
  update_desktop_database: true
  )

if development
message('''

----------------------------------------
You now have a development version installed.
Here be dragons.
Tread carefully.
----------------------------------------

''')
endif
