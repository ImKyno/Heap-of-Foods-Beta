local assets =
{
	Asset("ANIM", "anim/kyno_crop_seeds.zip"),
	Asset("ANIM", "anim/kyno_aspargos.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"asparagus",
	"asparagus_cooked",
	"spoiled_food",
}

local s = 1.1

local function onpicked(inst)
    -- TheWorld:PushEvent("beginregrowth", inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

    inst.AnimState:SetBank("kyno_aspargos")
    inst.AnimState:SetBuild("kyno_aspargos")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)
	
	inst:SetPrefabNameOverride("asparagus")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ASPARAGUS"

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("asparagus", 10)
    inst.components.pickable.onpickedfn = onpicked
    inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("kyno_aspargos_ground", fn, assets, prefabs),
Prefab("kyno_aspargos_cave", fn, assets, prefabs)