
# Other packaging formats and OSes

## Snap

Idk how to do that, havent looked into it and not sure if worth it.


## Appimage

Idk how to do that, havent looked into it and not sure if worth it.


## DEB/RPM/etc

Is there demand? I dont wanna bother with that...
For packagers: A tweak would be to have Jorts create a data directory instead of using its root.

Jorts just checks whether DATA_DIR exists since in a fresh sandbox it isnt a given, then just dump into it with no regards (since it is expected it does not share the space with other apps) 

Windows has a check in place, you can just remove the "#if WINDOWS"-"#endif" plumbing, and ensure Jorts create a folder with rdnn instead of just "Jorts" (there is no way to rebase between app-id on windows and other apps dont use rdnn anyway)


## Mac OS

[An attempt has been made](https://github.com/elly-code/jorts/pull/115)

The big hurdles are:
- DBus isnt a thing on MacOS
- Just like Windows, no LibPortal
- CSS theming seems broken?
- It apparently is crashy
