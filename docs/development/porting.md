# Porting for other OSES

## To make it easy

### Buildsystem plumbing

#### meson_options

The project has a combo option (target_os) with a list of valid choices
The idea is to allow people to set a profile to build for

You can add your OS to the list


#### root meson file

there is a block of code whose purpose is to define the profile for the target OS to build for

The idea is to set a bool once, so throughout meson subdirs one can exclude or include instruction

The bool should also be toggled on or off depending on the build_machine so we "detect" profile automatically

There is also an if/elif/else block to define vala flags according to said bools


### Dependencies

Make sure you build Granite and elementary OS stylesheets (which may not be a hard dependency?)



## To keep out

Autostart relies on Libportal. Mostly a linux thing.
You may want to skip it.
