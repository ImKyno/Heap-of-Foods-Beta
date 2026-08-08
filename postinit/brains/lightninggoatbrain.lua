local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local UpvalueHacker = require("tools/hof_upvaluehacker")

require("behaviours/runaway")

-- Flee from players who have recently used Slaughter Tools.
local AVOID_BUTCHER_DIST = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_DIST
local AVOID_BUTCHER_STOP = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_STOP

local RUN_AWAY_PARAMS =
{
	fn = function(guy)
		return guy.tagvar_recent_butcher == true
	end,
}

local function LightningGoatBrainPostInit(self)
	local inst = self.inst
	
	local HUNTER_PARAMS = UpvalueHacker.GetUpvalue(self.OnStart, "HUNTER_PARAMS")

	if HUNTER_PARAMS == nil then
		return
	end

	HUNTER_PARAMS.fn = function(guy)
		return guy.tagvar_goatfriendly ~= true
	end

	local runaway = RunAway(inst, RUN_AWAY_PARAMS, AVOID_BUTCHER_DIST, AVOID_BUTCHER_STOP)
	local conditional = WhileNode(function() return inst:HasTag("butcher_fearable") end, "Fear Butcher", runaway)

	conditional.parent = self.bt.root
	table.insert(self.bt.root.children, 1, conditional)
end

AddBrainPostInit("lightninggoatbrain", LightningGoatBrainPostInit)