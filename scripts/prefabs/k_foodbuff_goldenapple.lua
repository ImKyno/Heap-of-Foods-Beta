-- Multiple buffs combined into one.
-- Speed, Sleep, Defense, Strength, Fear, Fire Immunity, Fishing, Frog, Haste, Eater
-- Work, Pirate, Worm, Crab, Amphibian, Planar Defense, Super Jellybeans, Moisture
local function AddDappernessResistance(owner, equippable)
	if equippable.is_magic_dapperness then
		return 0
	end
end

local function RemoveDappernessResistance(owner, equippable)
	local dapperness = equippable:GetDapperness(owner, owner.components.sanity.no_moisture_penalty)
	
	if owner:HasTag("pinetreepioneer") then
		if equippable.is_magic_dapperness then
			return dapperness
		end
		
		return 0
		
	elseif equippable.is_magic_dapperness and owner:HasTag("shadowmagic") then
		return equippable.inst:HasTag("shadow_item") and dapperness * TUNING.WAXWELL_SHADOW_ITEM_RESISTANCE or dapperness
		
	elseif equippable.is_magic_dapperness and owner:HasTag("clockmaker") then
		if equippable.inst:HasTag("shadow_item") then
			if owner.age_state == "old" then
				return dapperness * TUNING.WANDA_SHADOW_RESISTANCE_OLD
			elseif owner.age_state == "normal" then
				return dapperness * TUNING.WANDA_SHADOW_RESISTANCE_NORMAL
			end
			
			return dapperness * TUNING.WANDA_SHADOW_RESISTANCE_YOUNG
		end 
		
		return dapperness
		
	elseif equippable.is_magic_dapperness then
		return nil -- 1
	end
end

local function ApplyPirateBonusDamage(inst, target, damage, weapon)
	return (target:HasTag("pirate") and TUNING.KYNO_PIRATEBUFF_EXTRADAMAGE) or 0
end

local function ApplyWormBonusDamage(inst, target, damage, weapon)
	local WORM_TAGS = {"worm", "worm_boss_piece"}

	return (target:HasOneOfTags(WORM_TAGS) and TUNING.KYNO_WORMBUFF_EXTRADAMAGE) or 0
end

local function ApplyCrabBonusDamage(inst, target, damage, weapon)
	local CRAB_TAGS = {"crabking", "crabking_ally", "crab_mob"}

	return (target:HasOneOfTags(CRAB_TAGS) and TUNING.KYNO_CRABBUFF_EXTRADAMAGE) or 0
end

local function ApplyAmphibianBonusDamage(inst, target, damage, weapon)
	local AMPHIBIAN_TAGS = {"merm", "frog", "toadstool"}

	return (target:HasOneOfTags(AMPHIBIAN_TAGS) and TUNING.KYNO_AMPHIBIANBUFF_EXTRADAMAGE) or 0
end

local function OnTick(inst, target)
	if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
		target.components.hunger:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "jellybean")
		target.components.health:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "jellybean")
		target.components.sanity:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "jellybean")
	else
		inst.components.debuff:Stop()
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)
	
	target:PushEvent("powerup")
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GOLDENAPPLEBUFF_START"))
	end
	
	-- Speed, Sleep
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddImmunitySource(target)
	end
	
	-- Defense
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.BUFF_PLAYERABSORPTION_MODIFIER, "kyno_goldenapplebuff")
	end
	
	-- Strength
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL, "kyno_goldenapplebuff")
	end
	
	-- Hunger Rate
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER, "kyno_goldenapplebuff")
	end
	
	-- Fear
	if not target:HasTag("pinetreepioneer") then
		if target.components.sanity ~= nil then 
			target.components.sanity:SetNegativeAuraImmunity(true)
			target.components.sanity:SetPlayerGhostImmunity(true)
			target.components.sanity:SetLightDrainImmune(true)
		end
	end
	
	if target.components.sanity ~= nil then 
		target.components.sanity:SetFullAuraImmunity(true)
		target.components.sanity.get_equippable_dappernessfn = AddDappernessResistance
	end
	
	-- Fire Immunity
	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 0
		end
	end
	
	-- Fishing
	if not target:HasTag("skilledfisherman") then
		target:AddTag("skilledfisherman")
	end
	
	-- Frog
	if not target:HasTag("frogimmunity") then 
		target:AddTag("frogimmunity")
	end
	
	-- Haste
	if not target:HasTag("fasthands") then
		target:AddTag("fasthands")
	end
	
	-- Eater
	if not target:HasTag("fasteater") then
		target:AddTag("fasteater")
	end
	
	-- Work
	if target.components.workmultiplier == nil then
		target:AddComponent("workmultiplier")
	end
	
	if target.components.workmultiplier ~= nil then
		target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
		target.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
		target.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
	end
	
	-- Pirate, Worm, Crab, Amphibian
	if target.components.combat ~= nil and target:HasTag("player") then	
		target.components.combat.bonusdamagefn = ApplyPirateBonusDamage
		target.components.combat.bonusdamagefn = ApplyWormBonusDamage
		target.components.combat.bonusdamagefn = ApplyCrabBonusDamage
		target.components.combat.bonusdamagefn = ApplyAmphibianBonusDamage
	end
	
	-- Planar Defense
	if target.components.planardefense ~= nil then 
		target.components.planardefense:AddBonus(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_goldenapplebuff")
	end
	
	-- Super Jellybeans
	if inst.task ~= nil then
		inst.task:Cancel()
	end
	
	inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
	
	-- Moisture
	if target:HasTag("wet") then
		return
	elseif target.components.moistureimmunity == nil then
		target:AddComponent("moistureimmunity")
	end
	
	target.components.moistureimmunity:AddSource(target)
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	-- Speed, Sleep
	if target.components.grogginess ~= nil then
		target.components.grogginess:RemoveImmunitySource(target, "kyno_goldenapplebuff")
	end
	
	-- Defense
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:RemoveModifier(target)
	end
	
	-- Strength
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:RemoveModifier(target, "kyno_goldenapplebuff")
	end
	
	-- Hunger Rate
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:RemoveModifier(target, "kyno_goldenapplebuff")
	end
	
	-- Fear
	if not target:HasTag("pinetreepioneer") then
		if target.components.sanity ~= nil then 
			target.components.sanity:SetNegativeAuraImmunity(false)
			target.components.sanity:SetPlayerGhostImmunity(false)
			target.components.sanity:SetLightDrainImmune(false)
		end
	end
	
	if target.components.sanity ~= nil then
		target.components.sanity:SetFullAuraImmunity(false)
		target.components.sanity.get_equippable_dappernessfn = RemoveDappernessResistance
	end
	
	-- Fire Immunity
	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 1
		end
	end
	
	-- Fishing
	if target:HasTag("skilledfisherman") then
		target:RemoveTag("skilledfisherman")
	end
	
	-- Frog
	if target:HasTag("frogimmunity") then 
		target:RemoveTag("frogimmunity")
	end
	
	-- Haste
	if target:HasTag("fasthands") then
		target:RemoveTag("fasthands")
	end
	
	-- Eater
	if target:HasTag("fasteater") then
		target:RemoveTag("fasteater")
	end
	
	-- Work
	if target.components.workmultiplier ~= nil then
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   target)
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   target)
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, target)
    end
	
	-- Pirate, Worm, Crab, Amphibian
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = nil
	end
	
	-- Planar Defense
	if target.components.planardefense ~= nil then
		target.components.planardefense:RemoveBonus(target, "kyno_goldenapplebuff")
	end
	
	-- Moisture
	if target.components.moistureimmunity ~= nil then
		target.components.moistureimmunity:RemoveSource(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GOLDENAPPLEBUFF_END"))
	end
	
	-- Slow down for a bit after using it.
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_goldenapplebuff", TUNING.KYNO_ALCOHOL_SPEED)
	end
	
	-- Pay with your life suckass!
	target:DoTaskInTime(5, function(target)
		if target.components.locomotor ~= nil and target:HasTag("player") then
			target:RemoveTag("groggy")
			target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_goldenapplebuff")
		end

		if target.components.health ~= nil then
			target.components.health:SetPercent(.2)
		end
	
		if target.components.hunger ~= nil then
			target.components.hunger:SetPercent(.1)
		end
	
		if target.components.sanity ~= nil then
			target.components.sanity:SetPercent(.1)
		end
	
		if target.components.grogginess ~= nil then
			target.components.grogginess:AddGrogginess(10, TUNING.KYNO_GOLDENAPPLEBUFF_SLEEPDURATION)
		end

		target:PushEvent("stopgoldenapple")
	end)
	
	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_goldenapplebuff")
	inst.components.timer:StartTimer("kyno_goldenapplebuff", TUNING.KYNO_GOLDENAPPLEBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GOLDENAPPLEBUFF_START"))
	end
	
	target.sg:GoToState("powerup")
	
	if target.SoundEmitter ~= nil then
		target.SoundEmitter:PlaySound("wolfgang2/characters/wolfgang/mighty")
	end

	-- Speed, Sleep
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddImmunitySource(target)
	end
	
	-- Defense
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.BUFF_PLAYERABSORPTION_MODIFIER, "kyno_goldenapplebuff")
	end
	
	-- Strength
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL, "kyno_goldenapplebuff")
	end
	
	-- Hunger Rate
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER, "kyno_goldenapplebuff")
	end
	
	-- Fear
	if not target:HasTag("pinetreepioneer") then
		if target.components.sanity ~= nil then 
			target.components.sanity:SetNegativeAuraImmunity(true)
			target.components.sanity:SetPlayerGhostImmunity(true)
			target.components.sanity:SetLightDrainImmune(true)
		end
	end
	
	if target.components.sanity ~= nil then 
		target.components.sanity:SetFullAuraImmunity(true)
		target.components.sanity.get_equippable_dappernessfn = AddDappernessResistance
	end
	
	-- Fire Immunity
	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 0
		end
	end
	
	-- Fishing
	if target:HasTag("skilledfisherman") then
		target:RemoveTag("skilledfisherman")
		target:AddTag("skilledfisherman")
	else
		target:AddTag("skilledfisherman")
	end
	
	-- Frog
	if target:HasTag("frogimmunity") then
		target:RemoveTag("frogimmunity")
		target:AddTag("frogimmunity")
	else
		target:AddTag("frogimmunity")
	end
	
	-- Haste
	if target:HasTag("fasthands") then
		target:RemoveTag("fasthands")
		target:AddTag("fasthands")
	else
		target:AddTag("fasthands")
	end
	
	-- Eater
	if target:HasTag("fasteater") then
		target:RemoveTag("fasteater")
		target:AddTag("fasteater")
	else
		target:AddTag("fasteater")
	end
	
	-- Work
	if target.components.workmultiplier == nil then
		target:AddComponent("workmultiplier")
	end
	
	if target.components.workmultiplier ~= nil then
		target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
		target.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
		target.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, target)
	end
	
	-- Pirate, Worm, Crab, Amphibian
	if target.components.combat ~= nil and target:HasTag("player") then	
		target.components.combat.bonusdamagefn = ApplyPirateBonusDamage
		target.components.combat.bonusdamagefn = ApplyWormBonusDamage
		target.components.combat.bonusdamagefn = ApplyCrabBonusDamage
		target.components.combat.bonusdamagefn = ApplyAmphibianBonusDamage
	end
	
	-- Planar Defense
	if target.components.planardefense ~= nil then 
		target.components.planardefense:AddBonus(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_goldenapplebuff")
	end
	
	-- Super Jellybeans
	if inst.task ~= nil then
		inst.task:Cancel()
	end

	inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
	
	-- Moisture
	if target:HasTag("wet") then
		return
	elseif target.components.moistureimmunity == nil then
		target:AddComponent("moistureimmunity")
	end
	
	target.components.moistureimmunity:AddSource(target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_goldenapplebuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	if not TheWorld.ismastersim then 
		return 
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_goldenapplebuff", TUNING.KYNO_GOLDENAPPLEBUFF_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_goldenapplebuff", fn)