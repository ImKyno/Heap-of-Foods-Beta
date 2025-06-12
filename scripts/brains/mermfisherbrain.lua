require("behaviours/wander")
require("behaviours/runaway")
require("behaviours/doaction")
require("behaviours/panic")
require("behaviours/chattynode")

local BrainCommon = require("brains/braincommon")

local SEE_HOME_DIST = 18
local MAX_WANDER_DIST = 15
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local TRADE_DIST = 20
local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local RUN_TIME_OUT = 7

local MermFisherBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return not inst.components.combat.target
	and home
	and home:IsValid()
	and not (home.components.burnable ~= nil
	and home.components.burnable:IsBurning())
	and not home:HasTag("burnt")
	and BufferedAction(inst, home, ACTIONS.GOHOME)
end

local function ShouldGoHome(inst)
	local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
	return TheWorld.state.isday
	and home ~= nil
	and (home.components.childspawner == nil
	or home.components.childspawner:CountChildrenOutside() > 1)
end

local FISHABLE_TAGS = {"fishable"}
local FISHABLE_NO_TAGS = {"fishinhole"}

local function Fish(inst)
    local pond = FindEntity(inst, 20, function(inst) return inst.components.fishable.fishleft > 0 end, FISHABLE_TAGS, FISHABLE_NO_TAGS)
    return pond
	and not inst.sg:HasStateTag("fishing")
	and inst.CanFish
	and BufferedAction(inst, pond, ACTIONS.FISH)
end

local function IsHomeOnFire(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home
	and home.components.burnable
	and home.components.burnable:IsBurning()
	and home:IsNear(inst, SEE_HOME_DIST)
end

local function GetTraderFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, TRADE_DIST, true)
    for _, v in ipairs(players) do
        if inst.components.trader:IsTryingToTradeWithMe(v) and not inst.sg:HasStateTag("fishing") then
            return v
        end  
    end     
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetFaceTargetFn(inst)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end
	
    local shouldface = inst.components.follower.leader or FindClosestPlayerToInst(inst, SEE_PLAYER_DIST, true)
    if shouldface and not inst.components.timer:TimerExists("facetime") then
        inst.components.timer:StartTimer("facetime", FACETIME_BASE + math.random()*FACETIME_RAND)
    end
	
    return shouldface
end

local function KeepFaceTargetFn(inst, target)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end
	
    local keepface = (inst.components.follower.leader and inst.components.follower.leader == target) or (target:IsValid() and inst:IsNear(target, SEE_PLAYER_DIST))
    if not keepface then
        inst.components.timer:StopTimer("facetime")
    end
	
    return keepface
end

local EATFOOD_MUST_TAGS = {"edible_VEGGIE", "edible_SEEDS"}
local EATFOOD_CANT_TAGS = {"INLIMBO", "outofreach"}
local SCARY_TAGS = {"pig", "scarytoprey"}

local function EatFoodAction(inst)
    if inst.sg:HasStateTag("waking") or inst.sg:HasStateTag("fishing") then
        return
    end

    local target = nil

    if inst.components.inventory ~= nil and inst.components.eater ~= nil then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end

    if target == nil then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item)
            return inst.components.eater ~= nil and inst.components.eater:CanEat(item)
        end, EATFOOD_MUST_TAGS, EATFOOD_CANT_TAGS)
   
        if target ~= nil and (GetClosestInstWithTag(SCARY_TAGS, target, SEE_PLAYER_DIST) ~= nil or not target:IsOnValidGround()) then
            target = nil
        end
    end
	
    if target ~= nil then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return target.components.inventoryitem == nil or target.components.inventoryitem.owner == nil or target.components.inventoryitem.owner == inst end
        return act
    end
end

function MermFisherBrain:OnStart()
    local root = PriorityNode(
    {
        -- WhileNode(function() return self.inst.components.combat.target ~= nil and not self.inst.sg:HasStateTag("fishing") end, "Is Threatened",
			-- ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
				-- Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST))),

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
            DoAction(self.inst, EatFoodAction, "Eat Food")),

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
        FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),

        WhileNode(function() return IsHomeOnFire(self.inst) end, "HomeOnFire", 
            ChattyNode(self.inst, "MERM_TALK_PANICBOSS",
			Panic(self.inst))),

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome", 
				DoAction(self.inst, GoHomeAction, "Go Home", true))),

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
            DoAction(self.inst, Fish, "Fish Action")),
			
		WhileNode(function() return GetTime() - self.inst.components.combat:GetLastAttackedTime() <= RUN_TIME_OUT end, "Attacked",
			RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_AWAY_DIST)),

        WhileNode(function() return not self.inst.sg:HasStateTag("fishing") end, "Is Idle",
			Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)),
    }, 0.25)
    
    self.bt = BT(self.inst, root)
end

return MermFisherBrain