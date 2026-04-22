
#======== VALA CONSTANTS ========

config_data_quoted = configuration_data()
config_data_quoted.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data_quoted.set_quoted('GETTEXT_PACKAGE', gettext_name)
config_data_quoted.set_quoted('APP_NAME', app_name)
config_data_quoted.set_quoted('APP_ID', app_id)
config_data_quoted.set_quoted('APP_PATH', app_path)
config_data_quoted.set_quoted('APP_VERSION', app_version)
config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data_quoted
)


#======== DEPENDENCIES ========

dependencies = [
        dependency('granite-7', version: '>=7.7.0'),
        dependency('gobject-2.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk4', version: '>=4.23')
    ]

# We need to compile an icon into the exe to avoid "missing icon" icon at every turn
# Libportal is not available in MSYS2, built the file only on linuxes
if windows_build
    dependencies += dependency('gio-windows-2.0')

else
    dependencies += dependency('gio-unix-2.0')
    dependencies += dependency('libportal')
endif


#======== FILES ========

sources = files (
    'Objects' / 'ZoomType.vala',
    'Objects' / 'Zoom.vala',
    'Objects' / 'Themes.vala',
    'Objects' / 'NoteData.vala',

    'Utils' / 'Random.vala',

    'Services' / 'Storage.vala',
    'Services' / 'NoteManager.vala',
    'Services' / 'ZoomController.vala',
    'Services' / 'ScribblyController.vala',
    'Services' / 'ColorController.vala',

    'Widgets' / 'EditableLabel.vala',
    'Widgets' / 'TextView.vala',
    'Widgets' / 'ActionBar.vala',

    'Widgets' / 'PopoverWidgets' / 'ColorPill.vala',
    'Widgets' / 'PopoverWidgets' / 'ColorBox.vala',
    'Widgets' / 'PopoverWidgets' / 'MonospaceBox.vala',
    'Widgets' / 'PopoverWidgets' / 'ZoomBox.vala',
    'Widgets' / 'PreferencesWidgets' / 'SettingsSwitch.vala',
    'Widgets' / 'Popover.vala',

    'Views' / 'PreferencesView.vala',
    'Views' / 'NoteView.vala',

    'Windows' / 'PreferenceWindow.vala',
    'Windows' / 'StickyNoteWindow.vala',

    'Constants.vala',
    'Application.vala',
)

if windows_build
    ico_src = import('windows').compile_resources('../windows/icons/ico.rc')
    sources += ico_src
else
    sources += files('Utils' / 'Libportal.vala')
endif

#======== EXECUTABLE ========
# win_subsystem doesnt seem to bother standard builds

executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    win_subsystem: 'windows',
    install : true
)
