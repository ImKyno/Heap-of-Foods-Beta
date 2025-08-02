local assets =
{
	Asset("ANIM", "anim/kyno_turnip.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_turnip",
	"kyno_turnip_cooked",
	"kyno_turnip_seeds",
	"spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    local s = 1.5
	inst.AnimState:SetScale(s, s, s)

    inst.AnimState:SetBank("kyno_turnip")
    inst.AnimState:SetBuild("kyno_turnip")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)
	
	inst:SetPrefabNameOverride("kyno_turnip_ground")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_TURNIP_GROUND"

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_turnip")
    inst.components.pickable.remove_when_picked = true
    inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    AddToRegrowthManager(inst)

    return inst
end

return Prefab("kyno_turnip_ground", fn, assets, prefabs),
Prefab("kyno_turnip_cave", fn, assets, prefabs)