require("behaviours/wander")
require("behaviours/faceentity")
require("behaviours/leash")
require("behaviours/doaction")

local BrainCommon = require("brains/braincommon")

local MAX_WANDER_DIST = 15
local NO_REPEAT_COOLDOWN_TIME = 10
local FACE_DIST = TUNING.RESEARCH_MACHINE_DIST

local DeciduousForestTraderBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
	return FindClosestPlayerToInst(inst, FACE_DIST, true)
end

local function KeepFaceTargetFn(inst, target)
	return inst:IsNear(target, FACE_DIST)
end

local function GetDanceTargetFn(inst)
	return FindClosestPlayerToInst(inst, FACE_DIST, true)
end

local function KeepDanceTargetFn(inst, target)
	return inst:IsNear(target, FACE_DIST)
end

local function HasValidHome(inst)
	local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil

	return home ~= nil
	and home:IsValid()
	and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
	and not home:HasTag("burnt")
end

local function GoHomeAction(inst)
	if inst:CanChatter() then -- Let me go home!
		inst:DoChatter("DECIDUOUSFORESTTRADER_GOHOME", math.random(#STRINGS.DECIDUOUSFORESTTRADER_GOHOME), 1)
	end

	if HasValidHome(inst) and not inst:AllNightTest() then
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
	end
end

local function GetHomePos(inst)
	return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function Dance(inst)
	inst:PushEvent("dance")
end

local function ShouldDance(inst)
	local dancer = GetDanceTargetFn(inst)

	if dancer ~= nil and dancer.sg:HasStateTag("dancing") then
		inst.sg.mem.dancing = true
		return true
	end

	if inst.sg.mem.dancing then
		inst.sg.mem.dancing = nil
	end

	return false
end

function DeciduousForestTraderBrain:OnStart()
	local DanceNode = WhileNode(function() return ShouldDance(self.inst) end, "Dance",
		PriorityNode({
			ActionNode(function() Dance(self.inst) end),
		}, .25))
	local root = PriorityNode({
		DanceNode, -- DANCE BABY!

		WhileNode(function() return not TheWorld.state.isday and not self.inst:AllNightTest() end, "ShouldGoHome",
			DoAction(self.inst, GoHomeAction, "GoHome", true)), -- Priortize going home over trading.

		WhileNode(function() return self.inst.sg.mem.trading or self.inst:CanTrade() end, "Trading",
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),

		IfNode(function() return self.inst:IsNearMerm() and self.inst:CanChatter() and GetFaceTargetFn(self.inst) ~= nil end, "MermPlayer",
			SequenceNode({
				ActionNode(function()
					self.inst:DoChatter("DECIDUOUSFORESTTRADER_REFUSE_MERM", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE_MERM), 10)
				end),
				-- FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn, 2),
			})
		),

		IfNode(function() return not self.inst:IsHomeRepaired() and not self.inst:IsNearMerm()
		and self.inst:CanChatter() and GetFaceTargetFn(self.inst) ~= nil end, "HouseBroken",
			SequenceNode({
				ActionNode(function()
					self.inst:DoChatter("DECIDUOUSFORESTTRADER_REFUSE_RUNDOWN", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE_RUNDOWN), 5)
				end),
				-- FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn, 2),
			})
		),

		IfNode(function() return self.inst:IsHomeRepaired() and not self.inst:HasStock() and self.inst:CanChatter() end, "NoStock",
			SequenceNode({
				ActionNode(function()
					self.inst:DoChatter("DECIDUOUSFORESTTRADER_OUTOFSTOCK", math.random(#STRINGS.DECIDUOUSFORESTTRADER_OUTOFSTOCK), 15)
				end),
				FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn, 2),
			})
		),

		Wander(self.inst, GetHomePos, MAX_WANDER_DIST),
	}, .25)
	self.bt = BT(self.inst, root)
end

return DeciduousForestTraderBrain