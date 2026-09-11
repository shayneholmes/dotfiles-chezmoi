-- This lives in a non-default location to conform with the XDG Base Directory
-- Spec. To use this, either move this whole "hammerspoon" directory to
-- "~/.hammerspoon", or run the following command:
--
--   defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

local start = os.clock()

require("hs.ipc") -- to use 'hs' command-line tool
require("reload") -- must come before actions to hook reload
require("alert") -- must come before actions to hook alert.show
require("timer")
require("abbreviations")

actions = require("actions")

local fin = os.clock()
print(("Finished loading all of init in %f seconds"):format(fin-start))

hs.alert.show("Config loaded")
