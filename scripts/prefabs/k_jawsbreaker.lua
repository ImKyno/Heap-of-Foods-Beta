local assets =
{
	Asset("ANIM", "anim/jawsbreaker.zip"),
	Asset("ANIM", "anim/swap_jawsbreaker.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"reticule",
	"reticuleaoe",
	"reticuleaoeping",
	"splash_green",
}

local PROJECTILE_COLLISION_MASK = COLLISION.GROUND

local function OnHit(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()

	if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
		SpawnPrefab("jawsbreaker").Transform:SetPosition(x, y, z)
	else
		SpawnPrefab("splash_green").Transform:SetPosition(x, y, z)
		SpawnPrefab("jawsbreaker").Transform:SetPosition(x, y, z)
	end
	
	inst:Remove()
end

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_jawsbreaker", "swap_jawsbreaker")
	
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function OnThrown(inst)
	inst:AddTag("NOCLICK")
	inst.persists = false

	inst.AnimState:PlayAnimation("spin_loop")

	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:SetCollisionMask(PROJECTILE_COLLISION_MASK)
	inst.Physics:SetCapsule(.2, .2)
end

local function ReticuleTargetFn()
	local pos = Vector3()
	
	for r = 6.5, 3.5, -.25 do
		pos.x, pos.y, pos.z = ThePlayer.entity:LocalToWorldSpace(r, 0, 0)
		if TheWorld.Map:IsOceanAtPoint(pos.x, pos.y, pos.z, false) then
			return pos
		end
	end
	
	return pos
end

local function OnAddProjectile(inst)
	inst.components.complexprojectile:SetHorizontalSpeed(15)
	inst.components.complexprojectile:SetGravity(-35)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
	inst.components.complexprojectile:SetOnLaunch(OnThrown)
	inst.components.complexprojectile:SetOnHit(OnHit)
end

local function OnPutInInventory(inst, owner)
    if owner ~= nil and owner:IsValid() then
        owner:PushEvent("learncookbookstats", inst.prefab)
    end
end

local function OnEaten(inst, eater)
	local JAWSBREAKER_TAGS = TUNING.JAWSBREAKER_TAGS

	-- See hof_stategraphs.lua for more info, shark works differently. 
	if eater:HasOneOfTags(JAWSBREAKER_TAGS) then
		if eater.components.health ~= nil and not eater.components.health:IsDead() then
			eater.components.health:Kill()
		end
	end
end

local function OnLanded(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
		inst.AnimState:PlayAnimation("idle_water")
	else
		inst.AnimState:PlayAnimation("idle")
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetTwoFaced()
	
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("jawsbreaker")
	inst.AnimState:SetBuild("jawsbreaker")
	inst.AnimState:PlayAnimation("idle_water")
	inst.AnimState:SetDeltaTimeMultiplier(.75)

	inst:AddComponent("reticule")
	inst.components.reticule.targetfn = ReticuleTargetFn
	inst.components.reticule.ease = true

	inst:AddTag("allow_action_on_impassable")
	inst:AddTag("itemshowcaser_valid")
	inst:AddTag("jawsbreaker")
	inst:AddTag("honeyed")
	inst:AddTag("nospice")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("locomotor")
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("oceanthrowable")
	inst.components.oceanthrowable:SetOnAddProjectileFn(OnAddProjectile)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "jawsbreaker"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.equipstack = true
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.UNARMED_DAMAGE)

	inst:AddComponent("forcecompostable")
	inst.components.forcecompostable.green = true
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -30
	inst.components.edible.hungervalue = 12.5
	inst.components.edible.sanityvalue = 33
	inst.components.edible.foodtype = FOODTYPE.RAW
	inst.components.edible.secondaryfoodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(OnEaten)
	
	inst:ListenForEvent("on_landed", OnLanded)
	inst:ListenForEvent("onputininventory", OnPutInInventory)
	
	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("jawsbreaker", fn, assets, prefabs)
