#
#   WINDOWS
#

#========================
# NSIS Installer script

config_installer_script = configure_file(
    input: 'installer.nsi.in',
    output: 'installer.nsi',
    configuration: config_data
)

#========================
# DEPLOY

config_deploy_script = configure_file(
    input: 'deploy.sh.in',
    output: 'deploy.sh',
    configuration: config_data
)

install_ico = configure_file (
    input: 'icons' / 'install.ico',
    output: 'install.ico',
    copy: true
)

uninstall_ico = configure_file (
    input: 'icons' / 'install.ico',
    output: 'uninstall.ico',
    copy: true
)