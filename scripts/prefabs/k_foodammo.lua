-- Don't ask me how this works :P It's a junction of walter's ammo + regular proj for other characters.
local SpDamageUtil = require("components/spdamageutil")

local assets =
{
	Asset("ANIM", "anim/kyno_foodammo.zip"),
	Asset("ANIM", "anim/swap_foodammo.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local AOE_TARGET_MUST_TAGS     = { "_combat", "_health" }
local AOE_TARGET_CANT_TAGS     = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost", "companion", "player", "wall" }
local AOE_TARGET_CANT_TAGS_PVP = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }
local AOE_RADIUS_PADDING       = 3

local function OnMiss(inst, owner, target)
	inst:Remove()
end

local function DoAOECallback(inst, x, z, radius, cb, attacker, target)
	local combat = attacker and attacker.components.combat or nil

	if combat == nil then
		return
	end

	for i, v in ipairs(TheSim:FindEntities(x, 0, z, radius + AOE_RADIUS_PADDING, AOE_TARGET_MUST_TAGS, TheNet:GetPVPEnabled()
	and AOE_TARGET_CANT_TAGS_PVP or AOE_TARGET_CANT_TAGS)) do
		if v ~= target and combat:CanTarget(v) and v.components.combat:CanBeAttacked(attacker) and not combat:IsAlly(v) then
			local range = radius + v:GetPhysicsRadius(0)

			if v:GetDistanceSqToPoint(x, 0, z) < range * range then
				cb(inst, attacker, v)
			end
		end
	end
end

local function ShouldAggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker ~= nil
	and attacker:IsValid() and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
	and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function ImpactFx(inst, attacker, target)
	if not inst.noimpactfx and target ~= nil and target:IsValid() then
		local impactfx = SpawnPrefab("impact")
		impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
	end
end

local function OnAttack(inst, attacker, target)
	if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
		if inst.food_def ~= nil and inst.food_def.onhit ~= nil then
			inst.food_def.onhit(inst, attacker, target)
		end

		ImpactFx(inst, attacker, target)
	end
end

local function OnPreHit(inst, attacker, target)
	if inst.food_def ~= nil and inst.food_def.onprehit ~= nil then
		inst.food_def.onprehit(inst, attacker, target)
	end

	if target ~= nil and target:IsValid() and target.components.combat ~= nil and ShouldAggro(attacker, target) then
		target.components.combat:SetShouldAvoidAggro(attacker)
	end
end

local function OnHit(inst, attacker, target)
	if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		target.components.combat:RemoveShouldAvoidAggro(attacker)
	end

	inst:Remove()
end

local function NoHoles(pt)
	return not TheWorld.Map:IsPointNearHole(pt)
end

local MAX_TOMATO_VARIATION = 7
local MAX_PICK_INDEX = 3
local TOMATO_VAR_POOl = { 1 }

for i = 2, MAX_TOMATO_VARIATION do
	table.insert(TOMATO_VAR_POOl, math.random(i), i)
end

local function PickTomato()
	local rand = table.remove(TOMATO_VAR_POOl, math.random(MAX_PICK_INDEX))
	table.insert(TOMATO_VAR_POOl, rand)

	return rand
end

local function TrySpawnTomato(target, min_scale, max_scale, duration)
	local x, y, z = target.Transform:GetWorldPosition()

	if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
		local fx = SpawnPrefab("kyno_tomato_trail")
		fx.Transform:SetPosition(x, 0, z)
		fx:SetVariation(PickTomato(), GetRandomMinMax(min_scale, max_scale), duration + math.random() * .5)
	elseif TheWorld.has_ocean then
		SpawnPrefab("ocean_splash_ripple"..tostring(math.random(2))).Transform:SetPosition(x, 0, z)
	end
end

local function OnUpdateSauce(target, t0)
	local elapsed = GetTime() - t0

	if elapsed < TUNING.KYNO_TOMATO_TRAIL_DURATION then
		local k = 1 - elapsed / TUNING.KYNO_TOMATO_TRAIL_DURATION
		k = k * k * 0.6 + 0.3

		TrySpawnTomato(target, k, k + 0.2, 2)
	else
		target._tomatotrailtask:Cancel()
		target._tomatotrailtask = nil

		target:RemoveTag("kyno_tomato_afflicted")

		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_tomato_afflicted")
		end

		target:PushEvent("kyno_tomato_afflicted")
	end
end

local function OnHitTomato(inst, attacker, target)
	if target and target:IsValid() then
		local pushstartevent

		if target._tomatotrailtask then
			target._tomatotrailtask:Cancel()
		else
			target:AddTag("kyno_tomato_afflicted")

			if target.components.locomotor ~= nil and not target:HasAnyTag("flying", "playerghost") then
				target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_tomato_afflicted", TUNING.KYNO_TOMATO_TRAIL_SPEED)
			end

			pushstartevent = true
		end

		target._tomatotrailtask = target:DoPeriodicTask(1, OnUpdateSauce, 0.43, GetTime())

		if not ShouldAggro(attacker, target) and target.components.combat ~= nil then
			target:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
		end

		if pushstartevent then
			target:PushEvent("kyno_tomato_afflicted")
		end
	end
end

local function DoAOEDamage(inst, attacker, target, damage, radius)
	local combat = attacker ~= nil and attacker.components.combat or nil

	if combat == nil or not target:IsValid() then
		return
	end

	local x, y, z = target.Transform:GetWorldPosition()

	local _ignorehitrange = combat.ignorehitrange

	combat.ignorehitrange = true

	for i, v in ipairs(TheSim:FindEntities(x, y, z, radius + AOE_RADIUS_PADDING, AOE_TARGET_MUST_TAGS, TheNet:GetPVPEnabled()
	and AOE_TARGET_CANT_TAGS_PVP or AOE_TARGET_CANT_TAGS)) do
		if v ~= target and combat:CanTarget(v) and v.components.combat:CanBeAttacked(attacker) and not combat:IsAlly(v)  then
			local range = radius + v:GetPhysicsRadius(0)

			if v:GetDistanceSqToPoint(x, y, z) < range * range then
				local spdmg = SpDamageUtil.CollectSpDamage(inst)

				v.components.combat:GetAttacked(attacker, damage, inst, inst.components.projectile.stimuli, spdmg)
			end
		end
	end

	combat.ignorehitrange = _ignorehitrange
end

local function OnUpdateSkillshot(inst)
	if not (inst.components.projectile.owner and inst:IsValid()) then
		return
	end

	local attacker = inst._attacker

	if not (attacker ~= nil and attacker.components.combat ~= nil and attacker:IsValid()) then
		return
	end

	local x, y, z = inst.Transform:GetWorldPosition()

	for i, v in ipairs(TheSim:FindEntities(x, 0, z, 4, AOE_TARGET_MUST_TAGS, TheNet:GetPVPEnabled()
	and AOE_TARGET_CANT_TAGS_PVP or AOE_TARGET_CANT_TAGS)) do
		local range = v:GetPhysicsRadius(.5) + inst.components.projectile.hitdist

		if v:GetDistanceSqToPoint(x, y, z) < range * range and attacker.components.combat:CanTarget(v)
		and v.components.combat:CanBeAttacked(attacker) and not attacker.components.combat:IsAlly(v) then
			inst.components.projectile:Hit(v)
			break
		end
	end
end

local function OnThrown(inst, owner, target, attacker)
	if inst.food_def ~= nil and inst.food_def.onlaunch ~= nil then
		inst.food_def.onlaunch(inst, owner, target, attacker)
	end

	if not target:HasTag("CLASSIFIED") then
		return
	end

	inst._attacker = attacker
	inst.components.projectile:SetHitDist(.7)
	inst.components.updatelooper:AddOnWallUpdateFn(OnUpdateSkillshot)
end

local function SetHighProjectile(inst)
	inst.AnimState:PlayAnimation(inst.food_def.spinloopmounted or "spin_loop_mount")
	inst.AnimState:PushAnimation(inst.food_def.spinloop or "spin_loop")
end

local function KeepTargetFn(inst)
	return false
end

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_foodammo", inst.food_def.symbolproj)
	
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function ReticuleTargetFn()
	local ground = TheWorld.Map
	local pos = Vector3()

	-- Attack range is 8, leave room for error.
	-- Min range was chosen to not hit yourself. (2 is the hit range).
	for r = 6.5, 3.5, -.25 do
		pos.x, pos.y, pos.z = ThePlayer.entity:LocalToWorldSpace(r, 0, 0)
		
		if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
			return pos
		end
	end
	
	return pos
end

local function OnThrownProj(inst, data)
	inst.AnimState:PlayAnimation("spin_loop", true)

	inst.components.inventoryitem.pushlandedevents = false
end

local function OnHitProj(inst, attacker, target)
	OnHitTomato(inst, attacker, target)

	local impactfx = SpawnPrefab("impact")

	if impactfx ~= nil and target.components.combat ~= nil then
		local follower = impactfx.entity:AddFollower()
		follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)

		if attacker ~= nil and attacker:IsValid() then
			impactfx:FacePoint(attacker.Transform:GetWorldPosition())
		end
	end

	inst.AnimState:PlayAnimation("used", false)
	inst:ListenForEvent("animover", inst.Remove)
end

local function projectilefn(food_def)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	MakeProjectilePhysics(inst)

	inst.AnimState:SetBank("kyno_foodammo")
	inst.AnimState:SetBuild("kyno_foodammo")
	if food_def.spinloop then
		inst.AnimState:PlayAnimation(food_def.spinloop, true)
	else
		inst.AnimState:PlayAnimation("spin_loop", true)

		if food_def.symbol then
			inst.AnimState:OverrideSymbol("rock", "kyno_foodammo", food_def.symbol)
		end
	end

	inst:AddTag("projectile")

	if food_def.tags then
		for _, tag in pairs(food_def.tags) do
			inst:AddTag(tag)
		end
	end

	if food_def.proj_common_postinit then
		food_def.proj_common_postinit(inst)
	end

	inst:AddComponent("updatelooper")

	inst.food_def = food_def

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.SetHighProjectile = SetHighProjectile

	inst.persists = false

	if food_def.damagetypebonus then
		inst:AddComponent("damagetypebonus")
		for k, v in pairs(food_def.damagetypebonus) do
			inst.components.damagetypebonus:AddBonus(k, inst, v)
		end
	end

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(food_def.damage)
	inst.components.weapon:SetOnAttack(OnAttack)

	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(25)
	inst.components.projectile:SetHoming(food_def.homing)
	inst.components.projectile:SetHitDist(1.5)
	inst.components.projectile:SetOnPreHitFn(OnPreHit)
	inst.components.projectile:SetOnHitFn(OnHit)
	inst.components.projectile:SetOnMissFn(OnMiss)
	inst.components.projectile:SetOnThrownFn(OnThrown)
	inst.components.projectile.range = 30
	inst.components.projectile.has_damage_set = true

	if food_def.proj_master_postinit then
		food_def.proj_master_postinit(inst)
	end

	return inst
end

local function fn(food_def)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetScale(.9, .9, .9)

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_foodammo")
	inst.AnimState:SetBuild("kyno_foodammo")
	if food_def.idleanim then
		inst.AnimState:PlayAnimation(food_def.idleanim, food_def.idlelooping)
	else
		inst.AnimState:PlayAnimation("idle")

		if food_def.symbol then
			inst.AnimState:OverrideSymbol("rock", "kyno_foodammo", food_def.symbol)
		end
	end

	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("weapon")
	inst:AddTag("noattack")
	inst:AddTag("projectile")
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")

	inst:AddComponent("reticule")
	inst.components.reticule.targetfn = ReticuleTargetFn
	inst.components.reticule.twinstickcheckscheme = true
	inst.components.reticule.twinstickmode = 1
	inst.components.reticule.twinstickrange = 8
	inst.components.reticule.ease = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.food_def = food_def

	if food_def.idlelooping then
		inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("reloaditem")
	inst:AddComponent("tradable")

	if food_def.elemental then
		inst:AddComponent("bait")
	end

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = food_def.stacksize or TUNING.STACK_SIZE_PELLET

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(food_def.sinks)

	if food_def.throwable ~= nil then
		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(food_def.throwabledamage)
		inst.components.weapon:SetRange(8, 10)

		inst:AddComponent("combat")
		inst.components.combat:SetDefaultDamage(food_def.throwabledamage)
		inst.components.combat:SetRange(food_def.throwableaoe)
		inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(OnEquip)
		inst.components.equippable:SetOnUnequip(OnUnequip)
		inst.components.equippable.equipstack = true

		inst:AddComponent("projectile")
		inst.components.projectile:SetOnThrownFn(OnThrownProj)
		inst.components.projectile:SetSpeed(20)
		inst.components.projectile:SetRange(30)
		inst.components.projectile:SetHoming(food_def.homing)
		inst.components.projectile:SetOnHitFn(food_def.onhit2)
		inst.components.projectile:SetOnMissFn(inst.Remove)
		inst.components.projectile:SetHitDist(1.5)
	end

	if food_def.fuelvalue ~= nil then
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = food_def.fuelvalue
	end

	if food_def.edible ~= nil then
		inst:AddComponent("edible")
		inst.components.edible.foodtype = food_def.foodtype or FOODTYPE.GENERIC
		inst.components.edible.healthvalue = food_def.healthvalue or 0
		inst.components.edible.hungervalue = food_def.hungervalue or 0
		inst.components.edible.sanityvalue = food_def.sanityvalue or 0
	end

	if food_def.onloadammo ~= nil and food_def.onunloadammo ~= nil then
		inst:ListenForEvent("ammoloaded", food_def.onloadammo)
		inst:ListenForEvent("ammounloaded", food_def.onunloadammo)
		inst:ListenForEvent("onremove", food_def.onunloadammo)
	end

	if food_def.inv_master_postinit ~= nil then
		food_def.inv_master_postinit(inst, food_def)
	end

	MakeHauntableLaunch(inst)

	return inst
end

local foodammo =
{
	{
		name            = "kyno_foodammo_tomato",
		symbol          = "tomato",
		symbolproj      = "swap_tomato",
		onhit           = OnHitTomato,
		onhit2          = OnHitProj,
		damage          = nil,
		homing          = true,
		throwable       = true,
		throwabledamage = 5,
		throwableaoe    = 1.8,
	},
}

local ammo_prefabs = {}

local function AddFoodAmmoPrefabs(name, data, fn, prefabs)
	table.insert(ammo_prefabs, Prefab(name, function() return fn(data) end, assets, prefabs))
end

for _, data in ipairs(foodammo) do
	if not data.no_inv_item then
		AddFoodAmmoPrefabs(data.name, data, fn, { data.name.."_proj" })
	end

	local prefabs = {}

	if data.prefabs then
		ConcatArrays(prefabs, data.prefabs)
	end

	AddFoodAmmoPrefabs(data.name.."_proj", data, projectilefn, prefabs)
end

return unpack(ammo_prefabs)