local assets =
{
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"spoiled_food"
}

----------------------------------------------------------------------------------------------------------
-- Funcions for some special brews.
local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local function GetFertilizerKey(inst)
	return inst.prefab
end

local function fertilizerresearchfn(inst)
	return inst:GetFertilizerKey()
end

local BEAT_SOUNDNAME = "BEAT_SOUND"

local function NightVision_PlayBeatingSound(inst)
	inst.SoundEmitter:KillSound(BEAT_SOUNDNAME)
	inst.SoundEmitter:PlaySound("meta4/ancienttree/nightvision/fruit_pulse", BEAT_SOUNDNAME)
end

local function NightVision_OnEntityWake(inst)
	if inst._beatsoundtask ~= nil or inst:IsInLimbo() or inst:IsAsleep() then
		return
	end

	if inst._beatsoundtask ~= nil then
		inst._beatsoundtask:Cancel()
		inst._beatsoundtask = nil
	end

	local fulltime = inst.AnimState:GetCurrentAnimationLength()
	local currenttime = inst.AnimState:GetCurrentAnimationTime()

	inst:PlayBeatingSound()

	inst._beatsoundtask = inst:DoPeriodicTask(fulltime, inst.PlayBeatingSound, fulltime - currenttime)
end

local function NightVision_OnEntitySleep(inst)
	inst.SoundEmitter:KillSound(BEAT_SOUNDNAME)

	if inst._beatsoundtask ~= nil then
		inst._beatsoundtask:Cancel()
		inst._beatsoundtask = nil
	end
end
----------------------------------------------------------------------------------------------------------
local function MakePreparedBrew(data)
	local foodname = data.basename or data.name
	local foodassets = assets
	
	table.insert(foodassets, Asset("ANIM", "anim/"..foodname..".zip"))
	
	local spicename = data.spice ~= nil and string.lower(data.spice) or nil
	if spicename ~= nil then
		foodassets = shallowcopy(assets)
		table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
		table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
		table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
	end

	local function DisplayNameFn(inst)
		return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		
		if data.isfertilizer ~= nil then
			MakeDeployableFertilizerPristine(inst)

			inst:AddTag("fertilizerresearchable")
	
			inst.GetFertilizerKey = GetFertilizerKey
		end
		
		if data.pickupsound ~= nil then
			inst.pickupsound = data.pickupsound
		end
		
		if data.scale ~= nil then
			inst.AnimState:SetScale(data.scale, data.scale, data.scale)
		end

		local food_symbol_build = nil
		
		if spicename ~= nil then
			inst.AnimState:SetBuild("plate_food")
			inst.AnimState:SetBank("plate_food")
			inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

			inst:AddTag("spicedfood")

			inst.drawnameoverride = STRINGS.NAMES[string.upper(data.basename)]
			inst.inv_image_bg = { atlas = "images/inventoryimages/hof_inventoryimages.xml", image = foodname..".tex" }
		else
			inst.AnimState:SetBank(data.name)
			inst.AnimState:SetBuild(data.name)
		end

		inst.AnimState:PlayAnimation("idle", false)
		inst.AnimState:OverrideSymbol("swap_food", foodname, foodname)

		inst:AddTag("preparedfood")
		inst:AddTag("preparedbrew")
		
		if data.fireproof ~= nil then
			inst:AddTag("fireprooffood")
		end

		if data.tags ~= nil then
			for i,v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.basename ~= nil then
			inst:SetPrefabNameOverride(data.basename)
			if data.spice ~= nil then
				inst.displaynamefn = DisplayNameFn
			end
		end

		MakeInventoryFloatable(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.food_symbol_build = food_symbol_build or data.overridebuild
		inst.food_basename = data.basename
		
		inst:AddComponent("bait")
		
		inst:AddComponent("inspectable")
		if data.nameoverride ~= nil then
			inst.components.inspectable.nameoverride = data.nameoverride
		end
		
		inst.wet_prefix = data.wet_prefix

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health
		inst.components.edible.hungervalue = data.hunger
		inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible.nochill = data.nochill or nil
		inst.components.edible.spice = data.spice
		inst.components.edible:SetOnEatenFn(data.oneatenfn)

		inst:AddComponent("inventoryitem")
		if spicename ~= nil then
			inst.components.inventoryitem:ChangeImageName(spicename.."_over")
		elseif data.basename ~= nil then
			inst.components.inventoryitem:ChangeImageName(data.basename)
		else
			inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
			inst.components.inventoryitem.imagename = data.name
		end

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		if data.perishtime ~= nil and data.perishtime > 0 then
			inst:AddComponent("perishable")
			inst.components.perishable:SetPerishTime(data.perishtime)
			inst.components.perishable:StartPerishing()
			
			if data.perishproduct ~= nil then 
				inst.components.perishable.onperishreplacement = data.perishproduct
			else
				inst.components.perishable.onperishreplacement = "spoiled_food"
			end
		end
		
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 8
		
		if data.isfertilizer ~= nil then
			inst:AddComponent("fertilizerresearchable")
			inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

			inst:AddComponent("fertilizer")
			inst.components.fertilizer.fertilizervalue = TUNING.ROTTENEGG_FERTILIZE
			inst.components.fertilizer.soil_cycles = TUNING.ROTTENEGG_SOILCYCLES
			inst.components.fertilizer.withered_cycles = TUNING.ROTTENEGG_WITHEREDCYCLES
			inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.wetgoop2.nutrients)
		end
		
		if data.isfuel ~= nil then
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.MED_FUEL
			inst.components.fuel:SetOnTakenFn(FuelTaken)
		end
		
		if data.nightvision ~= nil then
			inst.PlayBeatingSound = NightVision_PlayBeatingSound
	
			inst.OnEntityWake = NightVision_OnEntityWake
			inst.OnEntitySleep = NightVision_OnEntitySleep
			inst:ListenForEvent("exitlimbo", inst.OnEntityWake)
			inst:ListenForEvent("enterlimbo", inst.OnEntitySleep)
		end

		if data.fireproof ~= nil then
			-- WHAT WE DO?
		else
			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
		end

		if data.isfertilizer ~= nil then
			MakeDeployableFertilizer(inst)
		end
		
		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	return Prefab(data.name, fn, foodassets, prefabs)
end

local prefs = {}

for k, v in pairs(require("hof_brewrecipes_keg")) do
	table.insert(prefs, MakePreparedBrew(v))
end

for k, v in pairs(require("hof_brewrecipes_jar")) do
	table.insert(prefs, MakePreparedBrew(v))
end

--[[
for k, v in pairs(require("hof_brewrecipes_warly")) do
	table.insert(prefs, MakePreparedBrew(v))
end
]]--

return unpack(prefs)