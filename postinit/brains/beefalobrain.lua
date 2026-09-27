local _G      = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS

require("behaviours/doaction")
require("behaviours/runaway")

local SEE_FEEDER_DIST = 15
local BEEFALO_FEED_INTERVAL = TUNING.KYNO_ANIMALFEEDER_BEEFALO_COOLDOWN

local function IsBeefaloWithBell(inst)
	local follower = inst.components.follower
	local leader = follower ~= nil and follower.leader or nil

	return leader ~= nil and leader:HasTag("bell")
end

local function FindFeeder(inst)
	return _G.FindEntity(inst, SEE_FEEDER_DIST, function(ent)
		return ent:HasTag("animalfeeder") and ent.components.fueled ~= nil and ent.components.fueled:GetPercent() > 0
		and not ent.components.fueled:IsEmpty() and not ent:HasTag("burnt")
	end)
end

local function CanEatFromFeeder(inst)
	if not IsBeefaloWithBell(inst) then
		return false
	end

	if inst._animalfeeder_cooldown then
		return false
	end

	return FindFeeder(inst) ~= nil
end

local function EatFromFeederAction(inst)
	if not IsBeefaloWithBell(inst) then
		return false
	end

	if inst._animalfeeder_cooldown then
		return
	end

	local feeder = FindFeeder(inst)

	if feeder ~= nil then
		return _G.BufferedAction(inst, feeder, _G.ACTIONS.EATFROM)
	end
end

-- Flee from players who have recently used Slaughter Tools.
local AVOID_BUTCHER_DIST = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_DIST
local AVOID_BUTCHER_STOP = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_STOP

local RUN_AWAY_PARAMS =
{
	fn = function(guy)
		return guy.tagvar_recent_butcher == true
	end,
}

local function BeefaloBrainPostInit(self)
	local inst = self.inst

	local runaway = RunAway(inst, RUN_AWAY_PARAMS, AVOID_BUTCHER_DIST, AVOID_BUTCHER_STOP)
	local conditional = WhileNode(function() return inst:HasTag("butcher_fearable") and not inst:HasTag("domesticated") end, "Fear Butcher", runaway)

	conditional.parent = self.bt.root
	table.insert(self.bt.root.children, 1, conditional)

	local feedaction = DoAction(inst, EatFromFeederAction, "Eat From Feeding Trough", true)

	feedaction.parent = self.bt.root
	table.insert(self.bt.root.children, 14, feedaction) -- Right before anchor to salt lick.
end

AddBrainPostInit("beefalobrain", BeefaloBrainPostInit)