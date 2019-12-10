# GrafX2-Aseprite Shim
A shim between the GrafX2 and Aseprite APIs, allowing use of GrafX2 scripts with Aseprite.

## What is it
This is a script designed to allow Aseprite users to utilize GrafX2 scripts. Currently, it is very limited in capabilities, and **many** scripts **will not work**. The only script known to work is the palette analysis function of [DB-Toolbox](http://pixeljoint.com/forum/forum_posts.asp?TID=12854), which is what started this project.

## Contributions
Contributions are welcome. By contributing, you agree to release your contribution under [the current license](https://github.com/PureAsbestos/grafx2-aseprite-shim/blob/master/LICENSE).

## How to use it
To use this script, place it, along with the GrafX2 script of your choice, in your Aseprite scripts folder. (This folder can be found from within Aseprite by clicking `File > Scripts > Open Scripts Folder`) Then, create a simple script to load the GrafX2 script with contents as follows:
```
dofile(".grafx2-aseprite-shim.lua")
dofile("PATH_TO_GRAFX2_SCRIPT")
```
This is the script that you will load in Aseprite by clicking `File > Scripts > NAME_OF_YOUR_SCRIPT`
