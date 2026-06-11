local _G      = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS

require("behaviours/runaway")

-- Flee from players who have recently used Slaughter Tools.
local AVOID_BUTCHER_DIST = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_DIST
local AVOID_BUTCHER_STOP = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_STOP

local function DeerBrainPostInit(self)
	local inst = self.inst

	local runaway = RunAway(inst, "recent_butcher", AVOID_BUTCHER_DIST, AVOID_BUTCHER_STOP)
	local conditional = WhileNode(function() return inst:HasTag("butcher_fearable") and not inst:HasTag("domesticated") end, "Fear Butcher", runaway)

	conditional.parent = self.bt.root
	table.insert(self.bt.root.children, 1, conditional)
end

AddBrainPostInit("deerbrain", DeerBrainPostInit)