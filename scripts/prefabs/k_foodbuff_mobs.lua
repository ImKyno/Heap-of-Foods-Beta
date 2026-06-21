---------------------------------------------------------------------------
-- Pirate Buff
---------------------------------------------------------------------------
local function GetPirateBonusDamage(inst, target)
	return (target:HasTag("pirate") and TUNING.KYNO_PIRATEBUFF_EXTRADAMAGE) or 0
end

local function OnAttachedPirate(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetPirateBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDonePirate(inst, data)
	if data.name == "kyno_piratebuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetachedPirate(inst, target)
	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:RemoveBonusCallback(GetPirateBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_END"))
	end

	inst:Remove()
end

local function OnExtendedPirate(inst, target)
	inst.components.timer:StopTimer("kyno_piratebuff")
	inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetPirateBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_START"))
	end
end

local function piratefn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedPirate)
	inst.components.debuff:SetDetachedFn(OnDetachedPirate)
	inst.components.debuff:SetExtendedFn(OnExtendedPirate)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDonePirate)

	return inst
end
---------------------------------------------------------------------------
-- Worm Buff
---------------------------------------------------------------------------
local function GetWormBonusDamage(inst, target)
	local WORM_TAGS = {"worm", "worm_boss_piece"}

	return (target:HasOneOfTags(WORM_TAGS) and TUNING.KYNO_WORMBUFF_EXTRADAMAGE) or 0
end

local function OnAttachedWorm(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetWormBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WORMBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDoneWorm(inst, data)
	if data.name == "kyno_wormbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetachedWorm(inst, target)
	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:RemoveBonusCallback(GetWormBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WORMBUFF_END"))
	end

	inst:Remove()
end

local function OnExtendedWorm(inst, target)
	inst.components.timer:StopTimer("kyno_wormbuff")
	inst.components.timer:StartTimer("kyno_wormbuff", TUNING.KYNO_WORMBUFF_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetWormBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WORMBUFF_START"))
	end
end

local function wormfn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedWorm)
	inst.components.debuff:SetDetachedFn(OnDetachedWorm)
	inst.components.debuff:SetExtendedFn(OnExtendedWorm)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_wormbuff", TUNING.KYNO_WORMBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDoneWorm)

	return inst
end
---------------------------------------------------------------------------
-- Crab Buff
---------------------------------------------------------------------------
local function GetCrabBonusDamage(inst, target)
	local CRAB_TAGS = {"crabking", "crabking_ally", "crab_mob"}

	return (target:HasOneOfTags(CRAB_TAGS) and TUNING.KYNO_CRABBUFF_EXTRADAMAGE) or 0
end

local function OnAttachedCrab(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetCrabBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRABBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDoneCrab(inst, data)
	if data.name == "kyno_crabbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetachedCrab(inst, target)
	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:RemoveBonusCallback(GetCrabBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRABBUFF_END"))
	end

	inst:Remove()
end

local function OnExtendedCrab(inst, target)
	inst.components.timer:StopTimer("kyno_crabbuff")
	inst.components.timer:StartTimer("kyno_crabbuff", TUNING.KYNO_CRABBUFF_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetCrabBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRABBUFF_START"))
	end
end

local function crabfn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedCrab)
	inst.components.debuff:SetDetachedFn(OnDetachedCrab)
	inst.components.debuff:SetExtendedFn(OnExtendedCrab)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_crabbuff", TUNING.KYNO_CRABBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDoneCrab)

	return inst
end
---------------------------------------------------------------------------
-- Amphibian Buff
---------------------------------------------------------------------------
local function GetAmphibianBonusDamage(inst, target)
	local AMPHIBIAN_TAGS = {"merm", "frog", "toadstool"}

	return (target:HasOneOfTags(AMPHIBIAN_TAGS) and TUNING.KYNO_AMPHIBIANBUFF_EXTRADAMAGE) or 0
end

local function OnAttachedAmphibian(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetAmphibianBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_AMPHIBIANBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDoneAmphibian(inst, data)
	if data.name == "kyno_amphibianbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetachedAmphibian(inst, target)
	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:RemoveBonusCallback(GetAmphibianBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_AMPHIBIANBUFF_END"))
	end

	inst:Remove()
end

local function OnExtendedAmphibian(inst, target)
	inst.components.timer:StopTimer("kyno_amphibianbuff")
	inst.components.timer:StartTimer("kyno_amphibianbuff", TUNING.KYNO_AMPHIBIANBUFF_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetAmphibianBonusDamage)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_AMPHIBIANBUFF_START"))
	end
end

local function amphibianfn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedAmphibian)
	inst.components.debuff:SetDetachedFn(OnDetachedAmphibian)
	inst.components.debuff:SetExtendedFn(OnExtendedAmphibian)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_amphibianbuff", TUNING.KYNO_AMPHIBIANBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDoneAmphibian)

	return inst
end

return Prefab("kyno_piratebuff", piratefn),
Prefab("kyno_wormbuff", wormfn),
Prefab("kyno_crabbuff", crabfn),
Prefab("kyno_amphibianbuff", amphibianfn)