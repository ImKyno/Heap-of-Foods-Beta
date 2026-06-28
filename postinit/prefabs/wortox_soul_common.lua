local _G               = GLOBAL
local require          = _G.require
local WortoxSoulCommon = require("prefabs/wortox_soul_common")
local _GetNumSouls     = WortoxSoulCommon.GetNumSouls

WortoxSoulCommon.GetNumSouls = function(victim)
	local num = _GetNumSouls(victim)
	local source = victim ~= nil and victim._soulsource or nil

	if source ~= nil
		and source.prefab == "wortox"
		and source:HasTag("soulharvester") then
		num = num + 1
	end

	return num
end