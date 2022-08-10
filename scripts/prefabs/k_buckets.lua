local assets =
{
    Asset("ANIM", "anim/kyno_buckets.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_bucket_empty",
	"kyno_bucket_milk",
	"kyno_bucket_water",
	"fertilizer",
}

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item.prefab == "guano" or item.prefab == "poop" then
		return true -- Accept the Item.
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item.prefab == "guano" or item.prefab == "poop" then
		if giver ~= nil and giver.SoundEmitter ~= nil then
			giver.SoundEmitter:PlaySound("dontstarve/common/fertilize")
		else
			inst.SoundEmitter:PlaySound("dontstarve/common/fertilize")
		end
	
		local bucket = SpawnPrefab("fertilizer")
		if giver.components.inventory and giver:HasTag("player") and not giver.components.health:IsDead() 
		and not giver:HasTag("playerghost") then 
			giver.components.inventory:GiveItem(bucket) 
		else
			bucket.Transform:SetPosition(pos:Get())
			bucket.components.inventoryitem:OnDropped(false, .5)
		end
	end
	
	inst:Remove()
end

local function OnUse(inst)
	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:Use()
	end
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
end

local function OnFill(inst, pos, owner, from_object)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner ~= nil and owner.SoundEmitter ~= nil then
		owner.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
	else
		inst.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
	end

	local bucket = SpawnPrefab("kyno_bucket_water")
	if owner.components.inventory and owner:HasTag("player") and not owner.components.health:IsDead() 
	and not owner:HasTag("playerghost") then 
		owner.components.inventory:GiveItem(bucket) 
	else
		bucket.Transform:SetPosition(pos:Get())
		bucket.components.inventoryitem:OnDropped(false, .5)
	end

	inst:Remove()
	return true
end

local function OnFinishedWater(inst, pos, owner)
	local bucket = SpawnPrefab("kyno_bucket_empty")
	if owner.components.inventory and owner:HasTag("player") and not owner.components.health:IsDead() 
	and not owner:HasTag("playerghost") then 
		owner.components.inventory:GiveItem(bucket) 
	else
		bucket.Transform:SetPosition(pos:Get())
		bucket.components.inventoryitem:OnDropped(false, .5)
	end
	
	inst:Remove()
end

local function emptyfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_empty")

	inst:AddTag("bucket")
	inst:AddTag("bucket_empty")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	inst:AddComponent("milker")
	
	-- inst:AddComponent("trader")
	-- inst.components.trader:SetAcceptTest(TestItem)
    -- inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("fillable")
	inst.components.fillable.overrideonfillfn = OnFill
	inst.components.fillable.showoceanaction = true
	inst.components.fillable.acceptsoceanwater = true

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_empty"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function milkfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_milk")

	inst:AddTag("bucket")
	inst:AddTag("bucket_milk")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_milk"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function waterfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_water")

	inst:AddTag("bucket")
	inst:AddTag("bucket_water")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("wateryprotection")
	inst.components.wateryprotection.extinguishheatpercent = TUNING.WATERINGCAN_EXTINGUISH_HEAT_PERCENT
	inst.components.wateryprotection.temperaturereduction = TUNING.WATERINGCAN_TEMP_REDUCTION
	inst.components.wateryprotection.witherprotectiontime = TUNING.WATERINGCAN_PROTECTION_TIME
	inst.components.wateryprotection.addwetness = TUNING.WATERINGCAN_WATER_AMOUNT
	inst.components.wateryprotection.protection_dist = TUNING.WATERINGCAN_PROTECTION_DIST
	inst.components.wateryprotection:AddIgnoreTag("player")
	inst.components.wateryprotection.onspreadprotectionfn = OnUse

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_BUCKET_WATER_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_BUCKET_WATER_USES)
	inst.components.finiteuses:SetOnFinished(OnFinishedWater)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_water"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_bucket_empty", emptyfn, assets, prefabs),
Prefab("kyno_bucket_milk", milkfn, assets, prefabs),
Prefab("kyno_bucket_water", waterfn, assets, prefabs)