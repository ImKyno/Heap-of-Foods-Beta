local FIRE_DAMAGE    = TUNING.KYNO_SPICE_FIREBUFF_DAMAGE_MULT
local SPICE_DURATION = TUNING.KYNO_SPICE_FIREBUFF_DURATION

local function GetFireDamageMult(inst, target)
	if target ~= nil then
		if target.components.burnable ~= nil then
			if target.components.burnable:IsBurning() then
				return FIRE_DAMAGE
			end
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_START"))
	end

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetFireDamageMult)
	end

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.burnable ~= nil then
					data.target.components.burnable:Ignite(nil, attacker, inst)
				end
			end
		end

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:RemoveBonusCallback(GetFireDamageMult)
	end

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_spice_firebuff")
	inst.components.timer:StartTimer("kyno_spice_firebuff", SPICE_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetFireDamageMult)
	end

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.burnable ~= nil then
					data.target.components.burnable:Ignite(nil, attacker, inst)
				end
			end
		end

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_spice_firebuff" then
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
	inst:AddTag("kyno_controlled_burner") -- For burnable component.

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_spice_firebuff", SPICE_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_spice_firebuff", fn)