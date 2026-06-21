local COLDNESS          = TUNING.KYNO_SPICE_COLDBUFF_COLDNESS
local COLDNESS_DAMAGE   = TUNING.KYNO_SPICE_COLDBUFF_DAMAGE_MULT
local COLDNESS_DURATION = TUNING.KYNO_SPICE_COLDBUFF_COLDNESS_DURATION
local SPICE_DURATION    = TUNING.KYNO_SPICE_COLDBUFF_DURATION

local function GetColdDamageMult(inst, target)
	if target ~= nil and target.components.freezable ~= nil
	and target.components.freezable.coldness > 0 or target.components.freezable:IsFrozen() then
		return COLDNESS_DAMAGE
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FREEZEBUFF_START"))
	end

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetColdDamageMult)
	end

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.freezable ~= nil then
					data.target.components.freezable:AddColdness(COLDNESS, COLDNESS_DURATION)
					data.target.components.freezable:SpawnShatterFX()
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
		target.components.damagetypebonus:RemoveBonusCallback(GetColdDamageMult)
	end

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FREEZEBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_spice_coldbuff")
	inst.components.timer:StartTimer("kyno_spice_coldbuff", SPICE_DURATION)

	if target ~= nil and target.components.damagetypebonus ~= nil then
		target.components.damagetypebonus:AddBonusCallback(GetColdDamageMult)
	end

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.freezable ~= nil then
					data.target.components.freezable:AddColdness(COLDNESS, COLDNESS_DURATION)
					data.target.components.freezable:SpawnShatterFX()
				end
			end
		end

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_spice_coldbuff" then
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
	inst.components.timer:StartTimer("kyno_spice_coldbuff", SPICE_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_spice_coldbuff", fn)