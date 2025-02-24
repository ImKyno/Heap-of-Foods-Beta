local function AddDappernessResistance(owner, equippable)
	if equippable.is_magic_dapperness then
		return 0
	end
end

local function RemoveDappernessResistance(owner, equippable)
	local dapperness = equippable:GetDapperness(owner, owner.components.sanity.no_moisture_penalty)
	
	if equippable.is_magic_dapperness and owner:HasTag("pinetreepioneer") then
		return dapperness or 0
		
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

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
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
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_fearbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
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
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_fearbuff")
    inst.components.timer:StartTimer("kyno_fearbuff", TUNING.KYNO_FEARBUFF_DURATION)
	
	if not target:HasTag("pinetreepioneer") then
		if target.components.sanity ~= nil then 
			target.components.sanity:SetNegativeAuraImmunity(true)
			target.components.sanity:SetPlayerGhostImmunity(true)
			target.components.sanity:SetLightDrainImmune(true)
			target.components.sanity:SetFullAuraImmunity(true)
		end
	end
	
	if target.components.sanity ~= nil then 
		target.components.sanity:SetFullAuraImmunity(false)
		target.components.sanity.get_equippable_dappernessfn = AddDappernessResistance
	end
end

local function fn()
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
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_fearbuff", TUNING.KYNO_FEARBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_fearbuff", fn)