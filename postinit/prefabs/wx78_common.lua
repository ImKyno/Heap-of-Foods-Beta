local _G         = GLOBAL
local require    = _G.require
local WX78Common = require("prefabs/wx78_common")

WX78Common.WX78_UPGRADE_MODULE_ACTIONS[ACTIONS.OPENWXBREWER] =
{
	validfn = function(inst)
		return not inst:HasAnyTag("wx_brewing", "busy", "inspectingupgrademodules", "using_drone_remote")
	end,
}