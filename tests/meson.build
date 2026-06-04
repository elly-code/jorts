#
#   TESTS
#

#========================
# Linter and Appstream stuff

vala_linter = find_program('io.elementary.vala-lint', required: false)
if vala_linter.found()
    test('Run Vala linter on project source code',
        vala_linter,
        args: meson.project_source_root / 'src')
endif

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
    test('Validate schema file',
        compile_schemas,
        args: ['--config ..', '--dry-run', meson.project_source_root() / 'data'])
endif

# Windows cares not for Appstream
if not windows
    desktop_utils = find_program('desktop-file-validate', required: false)
    if desktop_utils.found()
        test('Validate desktop file',
            desktop_utils,
            args: [desktop_file])
    endif

    appstreamcli = find_program('appstreamcli', required: false)
    if appstreamcli.found()
        test('Validate appstream file',
            appstreamcli,
            args: ['validate', '--pedantic', '--no-net', '--explain', appstream_file])
    endif
endif


#========================
# Services


# Storage: Load and save

### Services

# Build some services and enums. Do random manipulations and compare


#========================
#  Widgets
# build specific widgets:

# Textview
# Add initial text. Activate lists on a sentence. Compare with reference. Change lists. Compare with reference

# preferences dialog
# show the window. No binds.

# notes
# show window. No storage.