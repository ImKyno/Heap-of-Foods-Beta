require("behaviours/wander")
require("behaviours/faceentity")
require("behaviours/leash")
require("behaviours/doaction")

local BrainCommon = require("brains/braincommon")

local MAX_WANDER_DIST = 15
local NO_REPEAT_COOLDOWN_TIME = 10
local FACE_DIST = TUNING.RESEARCH_MACHINE_DIST

local MeadowIslandTraderBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    return FindClosestPlayerToInst(inst, FACE_DIST, true)
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, FACE_DIST)
end

local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home and home:IsValid() and BufferedAction(inst, home, ACTIONS.GOHOME)
end

local function ShouldGoHome(inst)
	local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
	return TheWorld.state.isday
	and home ~= nil
	and (home.components.childspawner == nil
	or home.components.childspawner:CountChildrenOutside() >= 1)
end

function MeadowIslandTraderBrain:OnStart()
    local root = PriorityNode({
		WhileNode(function() return self.inst.sg.mem.trading or self.inst:HasStock() end, "Trading",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),

		IfNode(function() return not self.inst:HasStock() and self.inst:CanChatter() end, "NoStock",
            SequenceNode({
                ActionNode(function()
                    self.inst:DoChatter("MEADOWISLANDTRADER_OUTOFSTOCK", math.random(#STRINGS.MEADOWISLANDTRADER_OUTOFSTOCK), 15)
                end),
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn, 2),
            })
        ),
		
		WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome", 
			DoAction(self.inst, GoHomeAction, "GoHome", true)),

		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)
    self.bt = BT(self.inst, root)
end

return MeadowIslandTraderBrain
