local assets =
{
	Asset("ANIM", "anim/kyno_aloe.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_aloe",
	"kyno_aloe_cooked",
	"kyno_aloe_seeds",
	"spoiled_food",
}

local function onpicked(inst)
    TheWorld:PushEvent("beginregrowth", inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("kyno_aloe")
    inst.AnimState:SetBuild("kyno_aloe")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_aloe", 10)
    inst.components.pickable.onpickedfn = onpicked
    inst.components.pickable.quickpick = true
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("kyno_aloe_ground", fn, assets, prefabs)