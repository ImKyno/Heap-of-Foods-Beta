local prefabs =
{
	"spoiled_food",
}

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

local function CreateCore()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst:AddTag("FX")
	inst.persists = false
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("horrorfuel")
	inst.AnimState:SetBuild("horrorfuel")
	inst.AnimState:PlayAnimation("scrapbook", true)
	inst.AnimState:HideSymbol("blobs")
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)
	inst.AnimState:UsePointFiltering(true)
	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
	inst.AnimState:SetFinalOffset(-2)

	return inst
end

local function MakePreparedBrew(data)
	local foodassets =
	{
		Asset("ANIM", "anim/horrorfuel.zip"),
		Asset("ANIM", "anim/cook_pot_food.zip"),
	
		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}
	
	if data.overridebuild then
		table.insert(foodassets, Asset("ANIM", "anim/"..data.overridebuild..".zip"))
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)
		
		if data.scale ~= nil then
			inst.AnimState:SetScale(data.scale, data.scale, data.scale)
		else
			inst.AnimState:SetScale(1, 1, 1)
		end

		local food_symbol_build = nil
		
		inst.AnimState:SetBank(data.bank or "kyno_foodrecipes")
		inst.AnimState:SetBuild(data.overridebuild or "cook_pot_food")
		inst.AnimState:PlayAnimation(data.anim or data.name, data.loopanim or false)

		inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or "cook_pot_food", data.basename or data.name)
		
		if data.bloom ~= nil then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			inst.AnimState:SetLightOverride(.1)
			inst.lightcolour = data.bloomlight
		end

		inst:AddTag("preparedfood")
		inst:AddTag("preparedbrew")
		inst:AddTag("nospice")
		
		if data.fireproof ~= nil then
			inst:AddTag("fireprooffood")
		end

		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.basename ~= nil then
			inst:SetPrefabNameOverride(data.basename)
		end
		
		if data.pickupsound ~= nil then
			inst.pickupsound = data.pickupsound
		end
		
		if data.isfertilizer ~= nil then
			MakeDeployableFertilizerPristine(inst)

			inst:AddTag("fertilizerresearchable")
	
			inst.GetFertilizerKey = GetFertilizerKey
		end
		
		if not TheNet:IsDedicated() then
			if data.horrorfx then
				local horrorfx = SpawnPrefab("tophat_shadow_fx")
				horrorfx.entity:SetParent(inst.entity)
				-- horrorfx.Transform:SetPosition(inst.Transform:GetWorldPosition())

				inst:ListenForEvent("onremove", function()
					if horrorfx and horrorfx:IsValid() then
						horrorfx:Remove()
					end
				end)
			end
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.food_symbol_build = food_symbol_build or data.overridebuild
		inst.food_basename = data.basename
		inst.wet_prefix = data.wet_prefix
		
		inst:AddComponent("bait")
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("inspectable")
		if data.nameoverride ~= nil then
			inst.components.inspectable.nameoverride = data.nameoverride
		end
		
		inst:AddComponent("tradable")
		if data.goldvalue ~= nil then
			inst.components.tradable.goldvalue = data.goldvalue
		end
		
		if data.isfuel ~= nil then
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.MED_FUEL
			inst.components.fuel:SetOnTakenFn(FuelTaken)
		end
		
		inst:AddComponent("inventoryitem")
		if data.basename ~= nil then
			inst.components.inventoryitem:ChangeImageName(data.basename)
		else
			inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
			inst.components.inventoryitem.imagename = data.name
		end
		
		if data.isfertilizer ~= nil then
			inst:AddComponent("fertilizerresearchable")
			inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

			inst:AddComponent("fertilizer")
			inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE
			inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES
			inst.components.fertilizer.withered_cycles = TUNING.SPOILEDFOOD_WITHEREDCYCLES
			inst.components.fertilizer:SetNutrients(data.nutrients)
		end
		
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

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health
		inst.components.edible.hungervalue = data.hunger
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
		inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible.nochill = data.nochill or nil
		inst.components.edible:SetOnEatenFn(data.oneatenfn)
		inst.components.edible.degrades_with_spoilage = data.degrades_with_spoilage == nil or data.degrades_with_spoilage
		
		if data.nightvision ~= nil then
			inst.PlayBeatingSound = NightVision_PlayBeatingSound
			inst.OnEntityWake = NightVision_OnEntityWake
			inst.OnEntitySleep = NightVision_OnEntitySleep
			
			inst:ListenForEvent("exitlimbo", inst.OnEntityWake)
			inst:ListenForEvent("enterlimbo", inst.OnEntitySleep)
		end

		if data.fireproof ~= nil then
		
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