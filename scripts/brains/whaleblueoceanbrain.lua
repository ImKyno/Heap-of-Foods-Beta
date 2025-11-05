require("behaviours/wander")
require("behaviours/faceentity")
require("behaviours/chaseandattack")
require("behaviours/panic")
require("behaviours/runaway")
require("behaviours/leash")

local BrainCommon = require("brains/braincommon")

local RUN_AWAY_DIST = 10
local STOP_RUN_AWAY_DIST = 15
local START_FACE_DIST = 15
local KEEP_FACE_DIST = 20
local LEASH_RETURN_DIST = 5
local LEASH_MAX_DIST = 10
local CHASE_TIME = TUNING.KYNO_WHALE_BLUE_FOLLOW_TIME
local CHASE_DIST = TUNING.KYNO_WHALE_BLUE_TARGET_DIST

local WhaleBlueOceanBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local wander_times =
{
	minwalktime = 4,
	minwaittime = 4,
	
	randwalktime = 4,
	randwaittime = 3,
}

local function GetFaceTargetFn(inst)
	local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
	
	return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
	return inst:IsNear(target, KEEP_FACE_DIST) and not target:HasTag("notarget")
end

function WhaleBlueOceanBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),

		SequenceNode{
			ParallelNodeAny{
				WaitNode(15 + math.random() * 2),
				Leash(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, LEASH_MAX_DIST, LEASH_RETURN_DIST),
            },
        },

		ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
		
		SequenceNode{
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn, 0.5),
			RunAway(self.inst, "character", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)
		},
		
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		Wander(self.inst, nil, nil, wander_times)
	}, .25)

	self.bt = BT(self.inst, root)
end

function WhaleBlueOceanBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return WhaleBlueOceanBrain