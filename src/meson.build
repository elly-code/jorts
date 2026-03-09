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
    sources += ico_src
elif macos_build
    # noop
else
    sources += files('Utils' / 'Libportal.vala')
endif

#================================
# Let's define our executable
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
