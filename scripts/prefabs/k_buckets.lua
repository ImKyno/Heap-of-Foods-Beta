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
	"fertilizer",
}

local function OnFill(inst, from_object)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local waterbucket = SpawnPrefab("kyno_bucket_water")
	
	if from_object ~= nil and from_object.components.watersource ~= nil and from_object.components.watersource.override_fill_uses ~= nil then
		return false -- Will not fill from objects.
	end
		
	if waterbucket ~= nil then
		if owner ~= nil and owner.components.inventory ~= nil then
			owner.components.inventory:GiveItem(waterbucket, nil, owner:GetPosition())
		else
			inst.components.inventory:DropItem(waterbucket)
		end
	end
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
	
	inst:Remove()
	
	return true
end

local function OnFillWithRain(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local filled = SpawnPrefab("kyno_bucket_water")
	local fillfx = SpawnPrefab("splash")

	if filled ~= nil then
		filled.Transform:SetPosition(x, y, z)
		fillfx.Transform:SetPosition(x, y, z)
	end

	inst:Remove()
end

local function OnRainTick(inst)
	if not TheWorld.state.israining or inst.components.inventoryitem:IsHeld() then
		return
	end

	inst._rainfilltime = inst._rainfilltime + 1

	if inst._rainfilltime >= TUNING.KYNO_BUCKET_WATER_RAIN_TIMER then
		OnFillWithRain(inst)
	end
end

local function OnStartRainFill(inst)
	if inst._rainfilltask == nil then
		inst._rainfilltask = inst:DoPeriodicTask(1, OnRainTick)
	end
end

local function OnStopRainFill(inst, reset)
	if inst._rainfilltask ~= nil then
		inst._rainfilltask:Cancel()
		inst._rainfilltask = nil
	end

	if reset then
		inst._rainfilltime = 0
	end
end

local function OnIsRaining(inst, israining)
	if israining and not inst.components.inventoryitem:IsHeld() then
		OnStartRainFill(inst)
	else
		OnStopRainFill(inst, false) -- This pauses the timer. Not actually a reset.
	end
end

local function OnDropped(inst)
	if TheWorld.state.israining then
		OnStartRainFill(inst)
	end
end

local function OnPutInInventory(inst)
	OnStopRainFill(inst, true) -- This resets the timer!
end

local function emptyfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(.9, .9, .9)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_empty")

	inst:AddTag("bucket")
	inst:AddTag("bucket_empty")
	
	inst.pickupsound = "wood"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("milker")
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_empty"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function metalfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_metal")

	inst:AddTag("bucket")
	inst:AddTag("bucket_metal")
	
	inst.pickupsound = "metal"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._rainfilltime = 0
	inst._rainfilltask = nil
	
	inst:AddComponent("inspectable")
	inst:AddComponent("milker")
	
	inst:AddComponent("fillable")
	inst.components.fillable.overrideonfillfn = OnFill
	inst.components.fillable.showoceanaction = true
	inst.components.fillable.acceptsoceanwater = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_metal"
	
	inst:WatchWorldState("israining", OnIsRaining)
	
	inst:DoTaskInTime(0, function()
		if TheWorld.state.israining and not inst.components.inventoryitem:IsHeld() then
			OnStartRainFill(inst)
		end
	end)

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
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_water")

	inst:AddTag("bucket")
	inst:AddTag("bucket_water")
	
	inst.pickupsound = "metal"
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_water"

	return inst
end

return Prefab("kyno_bucket_empty", emptyfn, assets, prefabs),
Prefab("kyno_bucket_metal", metalfn, assets, prefabs),
Prefab("kyno_bucket_water", waterfn, assets, prefabs)