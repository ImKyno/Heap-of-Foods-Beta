require("hof_constants")
require("hof_behaviours")
require("hof_brewing")
require("hof_debugcommands")
require("hof_fishregistrydefs")
require("hof_rpc")
require("hof_util")

global("TheFishRegistry")
TheFishRegistry = nil

TheFishRegistry = require("hof_fishregistrydata")()
TheFishRegistry:Load()
TheFishRegistry.save_enabled = true