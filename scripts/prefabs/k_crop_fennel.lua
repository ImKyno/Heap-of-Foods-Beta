local assets =
{
	Asset("ANIM", "anim/kyno_fennel.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_fennel",
	"kyno_fennel_cooked",
	"kyno_fennel_seeds",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    local s = .6
	inst.AnimState:SetScale(s, s, s)

    inst.AnimState:SetBank("kyno_fennel")
    inst.AnimState:SetBuild("kyno_fennel")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_fennel")
    inst.components.pickable.remove_when_picked = true
    inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    AddToRegrowthManager(inst)

    return inst
end

return Prefab("kyno_fennel_ground", fn, assets, prefabs)