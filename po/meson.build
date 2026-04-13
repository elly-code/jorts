i18n.gettext(meson.project_name(),
    args: '--directory=' + meson.project_source_root(),
    preset: 'glib'
)

if not windows_build
    subdir ('extra')
endif
