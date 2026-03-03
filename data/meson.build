
gschema_conf = configuration_data()
gschema_conf.set('APP_ID', app_id)
gschema_file = configure_file(
    input: 'jorts.gschema.xml.in',
    output: '@0@.gschema.xml'.format(app_id),
    configuration: gschema_conf,
)

install_data(
    gschema_file,
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

compile_schemas = find_program('glib-compile-schemas', required: false, disabler: true)
test('Validate schema file',
compile_schemas,
args: ['--strict', '--dry-run', meson.current_source_dir()],
)



# metainfo confuses windows, and icons are 
if not windows_build


    # Install the standard icons in standard build
    if not get_option('development')


        #======== ICONS ========
        # Install our icons in all the required sizes
        # "variant" variable has been declared earlier in the base meson
        icon_sizes = ['16', '24', '32', '48', '64', '128']

        foreach i : icon_sizes
            install_data(
                'icons' / variant / 'hicolor' / i + '.png',
                install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
                rename: app_id + '.png'
            )
            install_data(
                'icons' / variant / 'hicolor@2' / i + '@2.png',
                install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
                rename: app_id + '.png'
            )
        endforeach

        install_data(
            'icons' / variant / 'scalable.svg',
            install_dir: get_option('datadir') / 'icons' / 'scalable' / 'apps',
            rename: app_id + '.svg'
        )

    # Install the dev icon in development builds
    else
        install_data(
            'icons' / 'default' / 'dev.svg',
            install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
            rename: app_id + '.svg'
        )
    endif

    # Inject some variables into the desktop file before merging in the translations
    desktop_conf = configuration_data()
    desktop_conf.set('APP_NAME', app_name)
    desktop_conf.set('APP_ID', app_id)
    desktop_file_in = configure_file(
    input: 'jorts.desktop.in.in',
    output: '@0@.desktop.in'.format(app_id),
    configuration: desktop_conf,
    )

    desktop_file = i18n.merge_file(
    input: desktop_file_in,
    output: '@0@.desktop'.format(app_id),
    po_dir: meson.project_source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications',
    )


    # Inject some variables into the metainfo file before merging in the translations
    appstream_conf = configuration_data()
    appstream_conf.set('APP_NAME', app_name)
    appstream_conf.set('APP_ID', app_id)
    appstream_conf.set('GETTEXT_PACKAGE', app_id)
    appstream_conf.set('ALTERNATE_APP_ID', alternate_app_id)
    appstream_file_in = configure_file(
        input: 'jorts.metainfo.xml.in.in',
        output: '@0@.metainfo.xml.in'.format(app_id),
        configuration: appstream_conf,
    )

    appstream_file = i18n.merge_file(
        input: appstream_file_in,
        output: '@0@.metainfo.xml'.format(app_id),
        po_dir: meson.project_source_root() / 'po',
        install: true,
        install_dir: get_option('datadir') / 'metainfo',
    )



    # Test definitions
    desktop_utils = find_program('desktop-file-validate', required: false)
    if desktop_utils.found()
        test('Validate desktop file', desktop_utils, args: [desktop_file])
    endif

    appstreamcli = find_program('appstreamcli', required: false, disabler: true)
        test('Validate appstream file',
    appstreamcli,
    args: ['validate', '--no-net', '--explain', appstream_file],
    )
endif