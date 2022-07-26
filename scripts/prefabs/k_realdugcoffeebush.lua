require "prefabutil"

local function ondeploy(inst, pt, deployer)
	local plant = SpawnPrefab("kyno_coffeebush")
	if plant ~= nil then
		plant.Transform:SetPosition(pt:Get())
		inst.components.stackable:Get():Remove()
	if plant.components.pickable ~= nil then
		plant.components.pickable:OnTransplant()
	end
	if deployer ~= nil and deployer.SoundEmitter ~= nil then
		deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
		end
	end
end

local function make_plantable(data)
    local assets =
    {
		Asset("ANIM", "anim/"..data.bank..".zip"),

		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
    }

    if data.build ~= nil then
        table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("coffeebush")
        inst.AnimState:SetBuild("coffeebush")
        inst.AnimState:PlayAnimation("dropped")

		inst:AddTag("coffeebush")
		inst:AddTag("coffeeplant")
        inst:AddTag("deployedplant")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = "kyno_dug_coffeebush"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        return inst
    end

    return Prefab("dug_"..data.name, fn, assets)
end

local plantables =
{
	{name="kyno_coffeebush", bank = "coffeebush", build = "coffeebush", mediumspacing = true},
}

local prefabs = {}
for i, v in ipairs(plantables) do
    table.insert(prefabs, make_plantable(v))
    table.insert(prefabs, MakePlacer("dug_"..v.name.."_placer", v.bank or v.name, v.build or v.name, v.anim or "idle"))
end

return unpack(prefabs)