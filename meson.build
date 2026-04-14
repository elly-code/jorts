
project(
    'jorts',
    'vala', 'c',
    version: '4.0.2'
)

app_name = 'Jorts'
correct_app_id = 'io.github.elly_code.' + meson.project_name()
correct_app_path = '/io/github/elly_code/' + meson.project_name() + '/'

legacy_app_id = 'io.github.ellie_commons.' +  meson.project_name()
legacy_app_path = '/io/github/ellie_commons/' + meson.project_name() + '/'


if get_option('legacy-rdnn')
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = legacy_app_path
else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = correct_app_path
endif

app_version = meson.project_version()
gettext_name = meson.project_name()

vala_flags = []
if get_option('development')
  app_id +=  '.devel'
  name_prefix = '(devel) '
  vcs_tag = run_command('git', 'rev-parse', '--short', 'HEAD').stdout().strip()
  version_suffix = '-@0@'.format (vcs_tag)
  vala_flags += ['--define', 'DEVEL']

else
  name_prefix = ''
  version_suffix = ''
endif


gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (gettext_name), language:'c')
windows_build = build_machine.system() == 'windows'


#================================
# Cool icon variants
variant = get_option('variant')

if variant == 'pride'
    vala_flags = ['--define', 'PRIDE']
elif variant == 'halloween'
    vala_flags = ['--define', 'HALLOWEEN']
elif variant == 'classic'
    vala_flags = ['--define', 'CLASSIC']
else
    vala_flags = ['--define', 'DEFAULT']
endif

# Windows needs icons, special arguments, and skip libportal
if windows_build
    vala_flags += ['--define', 'WINDOWS']
endif

add_project_arguments(vala_flags, language: 'vala')


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
