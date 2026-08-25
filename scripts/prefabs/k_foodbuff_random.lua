local function PickRandomBuff()
	local buff = TUNING.KYNO_RANDOMBUFF_BUFFS[math.random(#TUNING.KYNO_RANDOMBUFF_BUFFS)]

	if type(buff) == "table" then
		return buff[1], buff[2]
	end

	return buff, buff
end

-- Parallel events to PickRandomBuff(), can add more funny stuff to happen in here...
local function ApplyRandomEffect(inst, target)
	if target ~= nil and not target.tagvar_gambling_addicted
	and TryLuckRoll(target, TUNING.KYNO_RANDOMBUFF_DEATH_CHANCE, HofLuckFormulas.RandomBuffDeath) then
		inst:DoTaskInTime(0, function()
			if target ~= nil and target:IsValid() and target.components.health ~= nil then
				local currenthealth = target.components.health.currenthealth
				target.components.health:DoDelta(-currenthealth, nil, "opalpreciouslollipop_curse", true, nil, true)
			end
		end)
	end

	return PickRandomBuff()
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	inst:DoTaskInTime(0, function()
		if target == nil or not target:IsValid() then
			return
		end

		local buff, prefab = ApplyRandomEffect(inst, target)

		if buff ~= nil then
			inst._currentrandombuff = buff
			target:AddDebuff(buff, prefab)
		end
	end)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if inst._currentrandombuff ~= nil and target ~= nil then
		target:RemoveDebuff(inst._currentrandombuff)
	end

	inst._currentrandombuff = nil

	inst:Remove()
end

local function OnExtended(inst, target)
	if inst._currentrandombuff ~= nil and target ~= nil then
		target:RemoveDebuff(inst._currentrandombuff)
		inst._currentrandombuff = nil
	end

	inst:DoTaskInTime(0, function()
		if target == nil or not target:IsValid() then
			return
		end

		local buff, prefab = ApplyRandomEffect(inst, target)

		if buff ~= nil then
			inst._currentrandombuff = buff
			target:AddDebuff(buff, prefab)
		end
	end)
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		return
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

	return inst
end

return Prefab("kyno_randombuff", fn)