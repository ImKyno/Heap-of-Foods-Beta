require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_musselstick.zip"),	
	Asset("ANIM", "anim/kyno_musselstick_item.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
    "kyno_mussel",
	"kyno_musselstick_item",
}

local DAMAGE_SCALE = 0.5

local function onpickedfn(inst)
    inst.AnimState:PlayAnimation("idle_empty")
    inst.AnimState:PushAnimation("idle_empty", true)
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
	inst:RemoveTag("stick_full")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("empty_to_small")
    inst.AnimState:PlayAnimation("small_to_full")
	inst.AnimState:PushAnimation("idle_full", true)
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
	inst:AddTag("stick_full")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle_empty")
    inst.AnimState:PushAnimation("idle_empty", true)
	inst:RemoveTag("stick_full")
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle_empty")
    inst.AnimState:PushAnimation("idle_empty", true)
	inst.components.pickable:MakeEmpty()
end

local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
	
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
	
	if inst:HasTag("stick_full") then
		data.stickfull = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
	
	if data and data.stickfull then
		inst.AnimState:PlayAnimation("idle_full", true)
		inst:AddTag("stick_full")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_musselstick.tex")
	
	MakeInventoryPhysics(inst, nil, 0.7)
	
    inst.AnimState:SetBank("kyno_musselstick")
    inst.AnimState:SetBuild("kyno_musselstick")
    inst.AnimState:PlayAnimation("idle_empty", true)

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("silviculture") 
	inst:AddTag("musselfarm")
	
	inst:SetPrefabNameOverride("kyno_musselstick_item")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	inst.components.pickable:SetUp("kyno_mussel", TUNING.KYNO_MUSSELSTICK_GROWTIME, 3)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_MUSSELSTICK_WORKLEFT)
	
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("on_collide", OnCollide)
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function ondeploy(inst, pt, deployer)
    local stick = SpawnPrefab("kyno_musselstick")
	
	if stick ~= nil then
		stick.components.pickable:MakeEmpty()
		stick.Transform:SetPosition(pt:Get())
	end
	
	if deployer ~= nil and deployer.SoundEmitter ~= nil then
		deployer.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant") 
	end
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.25, 0.83)

    inst.AnimState:SetBank("kyno_musselstick_item")
    inst.AnimState:SetBuild("kyno_musselstick_item")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("kyno_musselstick", fn, assets, prefabs),
Prefab("kyno_musselstick_item", itemfn, assets, prefabs),
MakePlacer("kyno_musselstick_item_placer", "kyno_musselstick", "kyno_musselstick", "idle_empty")