
#================================
# Config.vala allows us to set variables in Meson, for the Vala app to use later

config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

#================================
dependencies = [
        dependency('gtk4'),
        dependency('granite-7', version: '>=7.6.0'),
        dependency('gee-0.8'),
        dependency('gobject-2.0'),
        dependency('json-glib-1.0'),
    ]

#================================
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


#================================
# Windows specific stuff
# theres a gio-windows and a gio-unix. We need to add depending on case 
# We need to compile an icon and add to the sources to avoid "missing icon" icon at every turn
# So AFAIK ico.rc just point to an ico file in the same folder it is, so this is like gresource
# No libportal on windows

if windows_build
    dependencies += dependency('gio-windows-2.0')
    ico_src = import('windows').compile_resources('../windows/icons/ico.rc')
    sources += ico_src

else
    dependencies += dependency('gio-unix-2.0')
    dependencies += dependency('libportal')
    sources += files('Utils' / 'Libportal.vala')

endif

#================================
# win_subsystem doesnt seem to bother standard builds

executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    vala_args: vala_flags,
    win_subsystem: 'windows',
    install : true
)
