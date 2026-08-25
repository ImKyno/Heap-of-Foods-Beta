local assets =
{
	Asset("ANIM", "anim/fx_dock_crackleandpop.zip"),
	Asset("ANIM", "anim/lavaarena_beetletaur_fx.zip"),
}

local function SpawnCritDamageFX(target)
	if target ~= nil then
		local fx = SpawnPrefab("kyno_critdamagebuff_fx")

		target._critdamage_fx = fx

		fx.entity:SetParent(target.entity)
		fx.Transform:SetPosition(0, 0, 0)

		local size

		if target:HasTag("largecreature") then
			size = 1.1
		elseif target:HasTag("smallcreature") then
			size = 0.5
		else
			size = 1
		end

		fx.Transform:SetScale(size, size, size)
		fx.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/poop")
	end
end

local function SpawnCritDamagePlayerFX(player)
	if player ~= nil then
		local fx = SpawnPrefab("kyno_critdamagebuff_player_fx")

		player._critdamage_player_fx = fx

		fx.entity:SetParent(player.entity)
		fx.Transform:SetPosition(0, 0, 0)
	end
end

local function ApplyCritDamageMult(inst, target, weapon, multiplier, mount)
	local mult = 1

	if inst._customdamagemultfn ~= nil then
		mult = inst._customdamagemultfn(inst, target, weapon, multiplier, mount) or 1
	end

	if TryLuckRoll(inst, TUNING.KYNO_CRITDAMAGEBUFF_CHANCE, HofLuckFormulas.CriticalDamage) then
		if target ~= nil and target.entity:IsVisible() then
			SpawnCritDamageFX(target)
		end

		if inst ~= nil and inst.entity:IsVisible() then
			SpawnCritDamagePlayerFX(inst)
		end

		return mult * (1 + TUNING.KYNO_CRITDAMAGEBUFF_MULT / 100)
	end

	return mult
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRITDAMAGEBUFF_START"))
	end

	if target.components.combat ~= nil then
		if target.components.combat.customdamagemultfn ~= ApplyCritDamageMult then
			inst._customdamagemultfn = target.components.combat.customdamagemultfn
			target.components.combat.customdamagemultfn = ApplyCritDamageMult
		end
	end

	if target ~= nil and target.entity:IsVisible() then
		SpawnCritDamagePlayerFX(target)
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRITDAMAGEBUFF_END"))
	end

	if target.components.combat ~= nil then
		if target.components.combat.customdamagemultfn == ApplyCritDamageMult then
			target.components.combat.customdamagemultfn = inst._customdamagemultfn
		end
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_critdamagebuff")
	inst.components.timer:StartTimer("kyno_critdamagebuff", TUNING.KYNO_BERSERKERBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRITDAMAGEBUFF_START"))
	end

	if target ~= nil and target.entity:IsVisible() then
		SpawnCritDamagePlayerFX(target)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_critdamagebuff" then
		inst.components.debuff:Stop()
	end
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

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_critdamagebuff", TUNING.KYNO_CRITDAMAGEBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("fx_dock_crackleandpop")
	inst.AnimState:SetBuild("fx_dock_crackleandpop")
	inst.AnimState:PlayAnimation("pop")
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:ListenForEvent("animover", function()
		local target = inst.entity:GetParent()

		if target ~= nil and target._critdamage_fx == inst then
			target._critdamage_fx = nil
		end

		inst:Remove()
	end)
	
	return inst
end

local function playerfxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetScale(.7, .7, .7)
	
	inst.AnimState:SetBank("lavaarena_beetletaur_fx")
	inst.AnimState:SetBuild("lavaarena_beetletaur_fx")
	inst.AnimState:PlayAnimation("defend_fx_pre")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:ListenForEvent("animover", function()
		local player = inst.entity:GetParent()

		if player ~= nil and player._critdamage_player_fx == inst then
			player._critdamage_player_fx = nil
		end

		inst:Remove()
	end)
	
	return inst
end

return Prefab("kyno_critdamagebuff", fn),
Prefab("kyno_critdamagebuff_fx", fxfn, assets),
Prefab("kyno_critdamagebuff_player_fx", playerfxfn, assets)