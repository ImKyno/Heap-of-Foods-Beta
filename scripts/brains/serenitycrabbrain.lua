require("behaviours/wander")
require("behaviours/doaction")
require("behaviours/panic")

local STOP_RUN_DIST     = 10
local SEE_PLAYER_DIST   = 5
local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_STOP = 6
local SEE_BAIT_DIST     = 10
local MAX_WANDER_DIST    = 15

local THREAT_MUST_HAVE_TAGS = {"_combat"}
local THREAT_NO_TAGS        = {"INLIMBO", "playerghost"}
local THREAT_TAGS           = {"scarytoprey", "hostile"}

local SerenityCrabBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetThreats(inst)
	if not inst.sg:HasStateTag("hiding") then
		local threat = FindEntity(inst, SEE_PLAYER_DIST, nil, THREAT_MUST_HAVE_TAGS, THREAT_NO_TAGS, THREAT_TAGS)
		if threat ~= nil then
			return threat and threat:HasTag("scarytoprey")
		end
	end	
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
		inst.components.homeseeker.home and 
		inst.components.homeseeker.home:IsValid() and
		inst.sg:HasStateTag("trapped") == false then
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function TestAction(inst)
    if not inst.sg:HasStateTag("hiding") then
        return inst.sg:GoToState("exit")
    end
end

local function EatFoodAction(inst)
    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

function SerenityCrabBrain:OnStart()
    local root = PriorityNode(
    {
        EventNode(self.inst, "GoHome", 
            DoAction(self.inst, GoHomeAction, "GoHome", true )),
        DoAction(self.inst, EatFoodAction),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return SerenityCrabBrain
