local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

local assets_weeds = {
    Asset("ANIM", "anim/kyno_weed_seeds.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function can_plant_seed(inst, pt, mouseover, deployer)
    local x, z = pt.x, pt.z
    return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
end

local function OnDeploy(inst, pt, deployer)
    local plant = SpawnPrefab(inst.components.farmplantable.plant)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
    TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
    inst:Remove()
end

local function Seed_GetDisplayName(inst)
    local registry_key = inst.weed_def.product

    local plantregistryinfo = inst.weed_def.plantregistryinfo
    return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)) and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)]
            or nil
end

local function seeds_common(name)
    local function fn_seeds(weed_def)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		
		inst.AnimState:SetScale(1.2, 1.2, 1.2)

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("kyno_weed_seeds")
        inst.AnimState:SetBuild("kyno_weed_seeds")
        inst.AnimState:PlayAnimation("kyno_" .. name .. "_seeds", false)
        inst.AnimState:SetRayTestOnBB(true)

        inst:AddTag("cookable")
        inst:AddTag("deployedplant")
        inst:AddTag("deployedfarmplant")

        inst.overridedeployplacername = "seeds_placer"

        inst.weed_def = weed_def
        inst.displaynamefn = Seed_GetDisplayName

        inst._custom_candeploy_fn = can_plant_seed

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst.components.edible.healthvalue = TUNING.HEALING_TINY / 2
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        inst:AddComponent("bait")

        inst:AddComponent("farmplantable")
		if name == "firenettles" then
			inst.components.farmplantable.plant = "weed_firenettle"
		else
			inst.components.farmplantable.plant = "weed_" .. name
		end

        inst:AddComponent("plantable")
        inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
        inst.components.plantable.product = name

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
        inst.components.deployable.restrictedtag = "plantkin"
        inst.components.deployable.ondeploy = OnDeploy

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end
	return fn_seeds
end

local function MakeWeedSeed(name)   
    return Prefab(name .. "_seeds", seeds_common(name), assets_weeds, prefabs)  
end

return MakeWeedSeed("forgetmelots"),
MakeWeedSeed("firenettles"),
MakeWeedSeed("tillweed")
-- MakeWeedSeed("ivy") -- Not sure...