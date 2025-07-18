require("prefabutil")

local WAXED_PLANTS = require("prefabs/waxed_plant_common")

local function MakePlantable(data)
	local assets = 
	{
		Asset("ANIM", "anim/"..(data.build or data.name)..".zip"),
	}
	
	local function OnDeploy(inst, pt, deployer)
		local plant = SpawnPrefab(data.name)
		
		if plant ~= nil then
			plant.Transform:SetPosition(pt:Get())
			inst.components.stackable:Get():Remove()
			
			if plant.components.pickable ~= nil then
				plant.components.pickable:OnTransplant()
			end
	
			if deployer ~= nil and deployer.SoundEmitter ~= nil then
				deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
			end
			
			if TheWorld.components.lunarthrall_plantspawner and plant:HasTag("lunarplant_target") then
				TheWorld.components.lunarthrall_plantspawner:setHerdsOnPlantable(plant)
			end
		end	
	end

	local function fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
	
		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation("dropped")
	
		inst:AddTag("deployedplant")
	
		if data.firerpoof ~= nil then
			inst:AddTag("firerpoof_plant")
		end
	
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
	
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = data.nameoverride or "dug_"..data.name
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM or data.stacksize
	
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.inventoryimage
	
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = OnDeploy
		inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
		if data.mediumspacing ~= nil then
			inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
		end
	
		if data.fireproof ~= nil then
			MakeHauntableLaunch(inst)
		else
			MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
			MakeSmallPropagator(inst)
			MakeHauntableLaunchAndIgnite(inst)
		end
	
		return inst
	end
	
	return Prefab("dug_"..data.name, fn, assets)
end

local plantables =
{
	-- Coffee Bush
	{
		name           = "kyno_coffeebush",
		bank           = "coffeebush",
		build          = "coffeebush",
		tags           = {"coffeebush", "coffeeplant"},
		inventoryimage = "dug_kyno_coffeebush",
		fireproof      = true,
		mediumspacing  = true,
		waxable        = true,
	},
	
	-- Spotty Shrub
	{
		name           = "kyno_spotbush",
		bank           = "kyno_spotbush",
		build          = "kyno_spotbush",
		scale          = 1.4,
		tags           = {"spotbush"},
		inventoryimage = "dug_kyno_spotbush",
		mediumspacing  = true,
		waxable        = true,
	},
	
	-- Wild Wheat
	{
		name           = "kyno_wildwheat",
		bank           = "kyno_wheat",
		build          = "kyno_wheat",
		tags           = {"wildwheat"},
		inventoryimage = "dug_kyno_wildwheat",
		nameoverride   = "DUG_GRASS",
		mediumspacing  = true,
		waxable        = true,
	},
	
	--[[
	-- Pineapple Bush (Unused)
	{
		name           = "kyno_pineapplebush2",
		bank           = "kyno_pineapplebush",
		build          = "kyno_pineapplebush",
		tags           = {"pineapplebush"},
		inventoryimage = "dug_kyno_pineapplebush",
		mediumspacing  = true,
		waxable        = true,
	},
	]]--
}

local prefabs = {}
for i, v in ipairs(plantables) do
	table.insert(prefabs, MakePlantable(v))
	table.insert(prefabs, MakePlacer("dug_"..v.name.."_placer", v.bank or v.name, v.build or v.name, v.anim or "idle"))
	
	if v.waxable then
		table.insert(prefabs, WAXED_PLANTS.CreateDugWaxedPlant(v))
	end
end

return unpack(prefabs)