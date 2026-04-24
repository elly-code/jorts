

# Override only default 
if get_option('development') and variant == 'default'
    variant = 'devel'
endif

#========================
# Install our icons in all the required sizes
# "variant" variable has been declared earlier in the base meson
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        variant / 'hicolor' / i + '.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: app_id + '.png'
    )

    install_data(
        variant / 'hicolor@2' / i + '@2.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: app_id + '.png'
    )

endforeach

install_data(
    variant / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'scalable' / 'apps',
    rename: app_id + '.svg'
)



