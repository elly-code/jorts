#
#   TESTS
#

#========================
# Linter and Appstream stuff

vala_linter = find_program('io.elementary.vala-lint', required: false)
if vala_linter.found()
    test('lint',
        vala_linter,
        args: [meson.project_source_root() / 'src'],
        is_parallel: true)
endif

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
    test('schema',
        compile_schemas,
        args: ['--strict', '--dry-run', meson.project_source_root() / 'data'],
        is_parallel: true)
endif

# Windows cares not for Appstream
if not windows
    desktop_utils = find_program('desktop-file-validate', required: false)
    if desktop_utils.found()
        test('desktop',
            desktop_utils,
            args: [desktop_file],
            is_parallel: true)
    endif

    appstreamcli = find_program('appstreamcli', required: false)
    if appstreamcli.found()
        test('metainfo',
            appstreamcli,
            args: ['validate', '--pedantic', '--no-net', '--explain', appstream_file],
            is_parallel: true)
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