local assets =
{
	Asset("ANIM", "anim/kyno_crop_seeds.zip"),
	Asset("ANIM", "anim/kyno_cucumber.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_cucumber",
	"kyno_cucumber_seeds",
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
	
	inst.AnimState:SetScale(.7, .7, .7)

    inst.AnimState:SetBank("kyno_cucumber")
    inst.AnimState:SetBuild("kyno_cucumber")
    inst.AnimState:PlayAnimation("idle_water", true)
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    -- inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_cucumber", 10)
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

return Prefab("kyno_cucumber_ground", fn, assets, prefabs)