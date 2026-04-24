
# Building for Windows

Ugh.

## Warning
Windows builds are a bit different

 - Everything needed for windows shit should be in /windows
 - This use MSYS2 which is basically have-your-linux-on-windows
 - deploy.sh is a script basically dumping the app + everything linux it needs in /windows/deploy, then bundle it all in a NSIS windows installer bundle thingie
 - Test the exe. If anything is missing or broken, it is because it isnt in the deploy
 - I do this to myself because i want our windows-only friends to enjoy what we do. You have to find a reason to keep on, even in hard days where you stand in the rain and your socks are wet.


## Set up your IDE

## Step by step

1. First go on a Windows box, 

2. [and install MSYS2, which is some kind of linux subsystem thingie](https://www.msys2.org/)

3. Then from the MSYS2 shell navigate to whatever folder you put the sources in, and cd into said folder

4. run the "./windows/prep.sh" script. It will install all needed dependencies with Pacman

5. Then run "./windows/deploy.sh". It will:
* build the app. Meson includes the extra cruft for windows stuff
* then compile it like grandma does when she cooks
* then move it along with needed dependencies in the deploy
* then create an NSIS script for an installer with everything
* then create the installer

6. The resulting exe has everything bundled up in it, including uninstaller.
It is built so as to not need admin rights. You can distribute as is.



## Known issues deploying

 - Sometimes schema files arent properly compiled. You have to glib-compile-schema them yourself

 - There is no libportal, so the dependency, sources files, and code blocks related to it are skipped. Theres a vala flag for this.


## Windows-specific bugs and papercuts

Jorts is primarily a Linux app. It is built using linux toolkits, and bundles a lot of it in the installer.

The Windows Build has a few differences with the True OG:
 - There is no seasonal icons, such as Halloween or Pride app icons.
 We use separately made .ico files and thats a hassle to maintain as is.
 Theres no update system so we can switch it up.
 It is compiled in (for the exe), so we cant even change it depending on date.
 It will always have the Blueberry, standard icon.

 - There is no inbuilt update method.
 You will have to uninstall Jorts, then reinstall it with a new version to update.
Note about this one: Notes are not deleted on uninstall. Do not worry you wont lose them.

 - There is no setting to enable/disable Jorts starting with Windows.
The Installer sets it once, then it is between you and God.

 - Some icons dont render.
 As i write this, the looking glass in the search field of the emoji chooser does not show up. I dont fucking know why.

 - Slow to start.
 Windows has to load a lot of libraries Linux kinda has loaded already by default.

 - XDG_DATA_DIRS points to the root of where apps dump their configurations. It isnt sandboxed.
 There is a vala flag to create a folder to put data in