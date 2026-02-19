local assets =
{
	Asset("ANIM", "anim/kyno_chicken_eggs.zip"),
	Asset("ANIM", "anim/kyno_chicken_eggs_large.zip"),
	
	Asset("ANIM", "anim/swap_chicken_eggs_large.zip"),
}

local projectile_assets =
{
	Asset("ANIM", "anim/swap_chicken_eggs_large.zip"),
}

local prefabs =
{
	"splash_sink",
	"reticule",
	"reticuleaoe",
	"reticuleaoeping",
	
	"kyno_chicken2",
	"kyno_chicken_egg_fx",
}

local projectile_prefabs =
{
	"splash_sink",
	"kyno_chicken_egg_fx",
}

local PROJECTILE_LAUNCH_OFFSET = Vector3(1.0, 8.0, 0)

local EGG_MUSTHAVE_TAGS  = { "_combat" }
local NO_TAGS_PLAYER     = { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion", "player" }
local NO_TAGS_PVP        = { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }
local NO_TAGS_CHICKENEGG = { "chicken", "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }

local function RefreshEggs(inst)
	local stacksize = inst.components.stackable ~= nil and inst.components.stackable:StackSize() or 1
	
	if stacksize >= 30 then
		inst.components.inventoryitem:ChangeImageName("kyno_chicken_egg_stack3")
	elseif stacksize >= 20 then
		inst.components.inventoryitem:ChangeImageName("kyno_chicken_egg_stack2")
	elseif stacksize >= 10 then
		inst.components.inventoryitem:ChangeImageName("kyno_chicken_egg_stack1")
	else
		inst.components.inventoryitem:ChangeImageName("kyno_chicken_egg")
	end

	inst.AnimState:ClearOverrideSymbol("egg1")

	if stacksize >= 30 then
		inst.AnimState:PlayAnimation("stack3", true)
		inst._eggstyle = nil
		return
	elseif stacksize >= 20 then
		inst.AnimState:PlayAnimation("stack2", true)
		inst._eggstyle = nil
		return
	elseif stacksize >= 10 then
		inst.AnimState:PlayAnimation("stack1", true)
		inst._eggstyle = nil
		return
	end

	inst.AnimState:PlayAnimation("idle", true)

	if inst._eggstyle == nil then
		inst._eggstyle = math.random(1, 5)
	end

	inst.AnimState:OverrideSymbol("egg1", "kyno_chicken_eggs", "egg"..inst._eggstyle)
end

local function GetLargeEggImage(style)
	return style == 1 and "kyno_chicken_egg_large" or "kyno_chicken_egg_large"..style
end

local function RefreshLargeEggs(inst)
	inst.AnimState:ClearOverrideSymbol("egg1")

	if inst._eggstyle == nil then
		inst._eggstyle = math.random(1, 5)
	end
	
	inst.AnimState:OverrideSymbol("egg1", "kyno_chicken_eggs_large", "egg"..inst._eggstyle)
	inst.components.inventoryitem:ChangeImageName(GetLargeEggImage(inst._eggstyle))
end

local function ShouldNotAggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker ~= nil and attacker:IsValid()
	and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
	and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function SetDebuffs(target, fx, numstacks)
	local speed = TUNING.KYNO_CHICKEN_EGG_GIANT_SLOW ^ numstacks
	local damage = TUNING.KYNO_CHICKEN_EGG_GIANT_DAMAGEMOD ^ numstacks
	
	if target.components.locomotor then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_chickeneggbuff", speed)
	end
	
	if target.components.combat then
		target.components.combat.externaldamagemultipliers:SetModifier(target, damage, "kyno_chickeneggbuff")
	end
	
	fx:SetFXLevel(numstacks)
end

local function DoRefresh(target, data)
	table.remove(data.tasks, 1)
	
	if #data.tasks > 0 then
		SetDebuffs(target, data.fx, #data.tasks)
	else
		data.fx:KillFX()
		
		if target.components.locomotor then
			target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_chickeneggbuff")
		end
		
		if target.components.combat then
			target.components.combat.externaldamagemultipliers:RemoveModifier(target, "kyno_chickeneggbuff")
		end
		
		target._slow = nil
	end
end

local function DoExplode(inst, thrower, target, no_hit_tags, damage, ismaintarget)
	local bx, by, bz = inst.Transform:GetWorldPosition()

	-- Find anything nearby that we might want to interact with.
	local entities = TheSim:FindEntities(bx, by, bz, TUNING.KYNO_CHICKEN_EGG_GIANT_ATTACK_AOE * 1.5, EGG_MUSTHAVE_TAGS, no_hit_tags)

	-- If we have a thrower with a combat component, we need to do some manipulation to become a proper combat target.
	if thrower ~= nil and thrower.components.combat ~= nil and thrower:IsValid() then
		thrower.components.combat.ignorehitrange = true
	else
		thrower = nil
	end

	local hit_a_target = false
	
	for i, v in ipairs(entities) do
		if v:IsValid() and v.entity:IsVisible() and inst.components.combat:CanTarget(v) then
			hit_a_target = true

			if thrower ~= nil and v.components.combat.target == nil then
				v.components.combat:GetAttacked(thrower, damage, inst)
			else
				inst.components.combat:DoAttack(v)
			end

			if not v.components.health:IsDead() and v:HasTag("stunnedbybomb") then
				v:PushEvent("stunbomb")
			end
			
			if v.components.locomotor then
				local data = v._slow
				local shouldrefresh
		
				if data == nil then
					data = { tasks = {}, fx = SpawnPrefab("kyno_chicken_egg_slow_fx") }
					data.fx.entity:SetParent(v.entity)
					data.fx:StartFX(v, not ismaintarget and math.random() * 0.3 or nil)
			
					v._slow = data
			
					shouldrefresh = true
				elseif #data.tasks < TUNING.KYNO_CHICKEN_EGG_GIANT_STACK then
					shouldrefresh = true
				else
					table.remove(data.tasks, 1):Cancel()
				end

				table.insert(data.tasks, v:DoTaskInTime(TUNING.KYNO_CHICKEN_EGG_GIANT_DURATION, DoRefresh, data))

				if shouldrefresh then
					SetDebuffs(v, data.fx, #data.tasks)
				end

				if not (ismaintarget or ShouldNotAggro(attacker, v)) and v.components.combat and v.components.combat:CanBeAttacked() then
					v:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
				end
			end
		end
	end

	if thrower ~= nil then
		thrower.components.combat.ignorehitrange = false
	end
end

local function OnEquip(inst, owner)
	local style = inst._eggstyle or 1
	local symbol = "swap_chicken_eggs_large"..style

	owner.AnimState:OverrideSymbol("swap_object", "swap_chicken_eggs_large", symbol)
    
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function SetThrownPhysics(inst)
	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:SetCollisionMask(COLLISION.GROUND, COLLISION.OBSTACLES, COLLISION.ITEMS)
	inst.Physics:SetCapsule(0.2, 0.2)
end

local function SpawnEggCrackEffects(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local fx1 = SpawnPrefab("kyno_chicken_egg_fx")
	fx1.Transform:SetPosition(x, y, z)
	fx1.SoundEmitter:PlaySound("dangerous_sea/creatures/water_plant/burr_burst")
	
	local fx2 = SpawnPrefab("kyno_swordfish_damage_fx")
	fx2.Transform:SetPosition(x, y, z)
end

local function OnInventoryThrown(inst)
	inst:AddTag("NOCLICK")
	inst.persists = false

	inst.AnimState:PlayAnimation("spin_loop", true)
	
	if inst._eggstyle == nil then
		inst._eggstyle = math.random(1, 5)
	end

	inst.AnimState:OverrideSymbol("egg1", "kyno_chicken_eggs_large", "egg"..inst._eggstyle)

	SetThrownPhysics(inst)
end

local function OnInventoryHit(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()

	if not TheWorld.Map:IsPassableAtPoint(x, y, z) then
		SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
	end

	SpawnEggCrackEffects(inst)

	if TheNet:GetPVPEnabled() then
		DoExplode(inst, attacker, target, NO_TAGS_PVP, TUNING.KYNO_CHICKEN_EGG_GIANT_DAMAGE, true)
	else
		DoExplode(inst, attacker, target, NO_TAGS_PLAYER, TUNING.KYNO_CHICKEN_EGG_GIANT_DAMAGE, true)
	end

	inst:Remove()
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

local function KeepTargetFn(inst)
	return false
end

local function OnThrown(inst)
	inst.AnimState:PlayAnimation("spin_loop", true)
end

local function OnHit(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()

	if not TheWorld.Map:IsPassableAtPoint(x, y, z) then
		SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
	end

	SpawnEggCrackEffects(inst)

	DoExplode(inst, attacker, target, NO_TAGS_CHICKENEGG, TUNING.KYNO_CHICKEN_EGG_GIANT_DAMAGE, true)

	inst:Remove()
end

-- Hatching Chickens 101 by Ms. Wickerbottom.
local function OnPutInInventory(inst)
	if inst.components.hatchableegg ~= nil then
		inst.components.hatchableegg:StopUpdating()
	end
end

local function OnDropped(inst)
	if inst.components.hatchableegg ~= nil then
		inst.components.hatchableegg:StartUpdating()
	end
end

local function OnCrack(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
	inst:Remove()
end

local function OnHatch(inst)
	local fx = SpawnPrefab("kyno_chicken_egg_fx")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local chicken = SpawnPrefab("kyno_chicken2")
    chicken.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
	if chicken.components.sleeper ~= nil then
		chicken.components.sleeper:GoToSleep()
	end
	
	chicken.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
	
	inst:Remove()
end

local function OnCheckHatch(inst)
    if not inst:IsAsleep()
	and inst.components.hatchableegg ~= nil
	and inst.components.inventoryitem ~= nil
	and not inst.components.inventoryitem:IsHeld() then
		local x, _, z = inst.Transform:GetWorldPosition()
		
		if TheWorld.Map:IsVisualGroundAtPoint(x, 0, z) then
			OnHatch(inst)
		end
	end
end

local function OnEaten(inst, eater)
	if eater.components.talker ~= nil then
		eater.components.talker:Say(GetString(eater, "EAT_FOOD", "TALLBIRDEGG_CRACKED"))
	end
end

local function GetStatus(inst, viewer)
	local egg = inst.components.hatchableegg
	local timeleft = egg and egg:GetHatchTimeLeft()

	return timeleft and (timeleft <= 240 and "HATCHING"
	or timeleft >= 480 and "GENERIC")
	or nil
end

local function OnSave(inst, data)
	data.eggstyle = inst._eggstyle
end

local function OnLoad(inst, data)
	if data ~= nil and data.eggstyle then
		inst._eggstyle = data.eggstyle
	end
	
	inst:DoTaskInTime(0, RefreshEggs)
end

local function OnLoadLarge(inst, data)
	if data ~= nil and data.eggstyle then
		inst._eggstyle = data.eggstyle
	end
	
	inst:DoTaskInTime(0, RefreshLargeEggs)
end

local function OnLoadPostPass(inst)
	if inst.components.inventoryitem ~= nil and inst.components.inventoryitem:IsHeld() then
		OnPutInInventory(inst)
	end
end

local function chicken_eggfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_chicken_eggs")
	inst.AnimState:SetBuild("kyno_chicken_eggs")
	
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("saltbox_valid")
	inst:AddTag("catfood")
	inst:AddTag("chicken_egg")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._eggstyle = nil
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "rottenegg"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_chicken_egg_cooked"
	
	inst:DoTaskInTime(0, RefreshEggs)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("ondropped", RefreshEggs)
	inst:ListenForEvent("stacksizechange", RefreshEggs)
	
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function chicken_egg_giantfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_chicken_eggs_large")
	inst.AnimState:SetBuild("kyno_chicken_eggs_large")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("catfood")
	inst:AddTag("chicken_egg")
	inst:AddTag("weapon")
	inst:AddTag("noattack")
	inst:AddTag("projectile")
	inst:AddTag("complexprojectile")
	
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
	
	inst._eggstyle = nil
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_chicken_egg_cooked"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_GIANT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_GIANT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_GIANT_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg_large"
	
	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(15)
	inst.components.complexprojectile:SetGravity(-35)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
	inst.components.complexprojectile:SetOnLaunch(OnInventoryThrown)
	inst.components.complexprojectile:SetOnHit(OnInventoryHit)

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.WATERPLANT.ITEM_DAMAGE)
	inst.components.weapon:SetRange(8, 10)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.WATERPLANT.ITEM_DAMAGE)
	inst.components.combat:SetRange(TUNING.WATERPLANT.ATTACK_AOE)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("hatchableegg")
	inst.components.hatchableegg:SetHeatTypes(true, false)
	inst.components.hatchableegg:StartCrackMode("kyno_chicken_egg_large_cracked", TUNING.KYNO_CHICKEN_EGG_GIANT_CRACKTIME)
	inst.components.hatchableegg:SetOnCrackFn(OnCrack)
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:DoTaskInTime(0, RefreshLargeEggs)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoadLarge
	inst.OnLoadPostPass = OnLoadPostPass
	
	inst:ListenForEvent("ondropped", RefreshLargeEggs)
	inst:ListenForEvent("onputininventory", RefreshLargeEggs)
	
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function chicken_egg_crackedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_chicken_eggs_large")
	inst.AnimState:SetBuild("kyno_chicken_eggs_large")
	inst.AnimState:PlayAnimation("idle_happy", true)
	inst.AnimState:OverrideSymbol("egg1", "kyno_chicken_eggs_large", "egg_cracked")
	
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("catfood")
	inst:AddTag("chicken_egg")
	inst:AddTag("donotautopick")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_chicken_egg_cooked"

	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnEaten)
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_GIANT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_GIANT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_GIANT_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg_large_cracked"
	
	inst:AddComponent("hatchableegg")
	inst.components.hatchableegg:SetAllowedPhases(true, true, true)
	inst.components.hatchableegg:StartIncubateMode(TUNING.KYNO_CHICKEN_EGG_GIANT_HATCHTIME)
	inst.components.hatchableegg:SetOnHatchFn(OnCheckHatch)
	
	inst.OnLoadPostPass = OnLoadPostPass
	
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function chicken_egg_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_chicken_eggs")
	inst.AnimState:SetBuild("kyno_chicken_eggs")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")
	inst:AddTag("chicken_egg")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_COOKED_HUNGER 
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "rottenegg"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function projectilefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

    SetThrownPhysics(inst)
	inst.Physics:SetDontRemoveOnSleep(true)

    inst.AnimState:SetBank("kyno_chicken_eggs_large")
    inst.AnimState:SetBuild("kyno_chicken_eggs_large")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")
	inst:AddTag("noattack")
	inst:AddTag("projectile")
	inst:AddTag("complexprojectile")

	inst:SetPrefabNameOverride("KYNO_CHICKEN_EGG_LARGE")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst._eggstyle = nil

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(25)
	inst.components.complexprojectile:SetGravity(-90)
	inst.components.complexprojectile:SetLaunchOffset(PROJECTILE_LAUNCH_OFFSET)
	inst.components.complexprojectile:SetOnLaunch(OnThrown)
	inst.components.complexprojectile:SetOnHit(OnHit)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.WATERPLANT.DAMAGE)
	inst.components.combat:SetRange(TUNING.WATERPLANT.ATTACK_AOE)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

	return inst
end

return Prefab("kyno_chicken_egg", chicken_eggfn, assets, prefabs),
Prefab("kyno_chicken_egg_large", chicken_egg_giantfn, assets, prefabs),
Prefab("kyno_chicken_egg_large_cracked", chicken_egg_crackedfn, assets, prefabs),
Prefab("kyno_chicken_egg_cooked", chicken_egg_cookedfn, assets, prefabs),
Prefab("kyno_chicken_egg_large_projectile", projectilefn, projectile_assets, projectile_prefabs)