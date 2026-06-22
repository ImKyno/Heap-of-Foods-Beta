local PLANT_DEFS          = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS           = require("prefabs/weed_defs").WEED_DEFS
local WEIGHTED_SEED_TABLE = require("prefabs/weed_defs").weighted_seed_table

-- For detailed information about boosters please check prefabs/k_plantbooster.lua
local BOOSTER_DATA  =
{
	GROWTH          =
	{
		can_farm    = false, -- Can be used on farm plants.
		preserve    = false, -- Can un-transplant regular plants.
		bonus_yield = false, -- Can have bonus yield when harvesting/picking.
		supergrowth = false, -- Can skip all farm plant stages and make oversize crops.
	},

	VITALITY        =
	{
		can_farm    = true,
		preserve    = true,
		bonus_yield = false,
		supergrowth = false,
	},

	YIELD           =
	{
		can_farm    = true,
		preserve    = false,
		bonus_yield = true,
		supergrowth = false,
	},

	SUPERGROWTH     =
	{
		can_farm    = true,
		preserve    = false,
		bonus_yield = false,
		supergrowth = true,
	},
}

local BOOSTER_NAMES            =
{
	[BOOSTER_DATA.GROWTH]      = "GROWTH",
	[BOOSTER_DATA.VITALITY]    = "VITALITY",
	[BOOSTER_DATA.YIELD]       = "YIELD",
	[BOOSTER_DATA.SUPERGROWTH] = "SUPERGROWTH",
}

local function GetBoosterName(data)
	return BOOSTER_NAMES[data] or "UNKNOWN"
end

local function GetBoosterData(booster)
	if booster:HasTag("supergrowthbooster") then
		return BOOSTER_DATA.SUPERGROWTH
	elseif booster:HasTag("yieldbooster") then
		return BOOSTER_DATA.YIELD
	elseif booster:HasTag("vitalitybooster") then
		return BOOSTER_DATA.VITALITY
	end

	return BOOSTER_DATA.GROWTH
end

local function SpawnGrowFX(inst)
	local fx = SpawnPrefab("farm_plant_happy")

	if fx ~= nil then
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function CanBeTransplanted(inst)
	return inst.components.pickable ~= nil and inst.components.pickable.ontransplantfn ~= nil
end

local function ClearBoosterEffects(inst)
	if inst._bonus_yield then
		inst:RemoveTag("plantboosted_yield")
	end

	inst._bonus_yield = false
	
	if inst.SetLunarThrallProtection ~= nil then
		inst:SetLunarThrallProtection(false)
	else
		inst._lunarthrall_protected = false
	end

	if inst._vitality_active then
		inst:RemoveTag("plantboosted_vitality")

		if inst.components.pickable ~= nil and inst._supports_transplanting then
			inst.components.pickable.transplanted = inst._original_transplanted or false
		end
	end

	inst._vitality_active = false
end

local function ReplacePlant(inst)
	local prefab = inst.prefab

	if prefab == nil then
		return inst
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local rotation = inst.Transform:GetRotation()
	local replacement = SpawnPrefab(prefab)

	if replacement == nil then
		return inst
	end

	if replacement.components.pickable ~= nil then
		if replacement.prefab == "rock_avocado_bush" then
			if replacement.components.growable ~= nil then
				replacement.components.growable:SetStage(3)
			end

			replacement.components.pickable:Regen()
		else
			replacement.components.pickable:Regen()
		end
	end

	replacement.Transform:SetPosition(x, y, z)
	replacement.Transform:SetRotation(rotation)

	replacement._bonus_yield = inst._bonus_yield
	replacement._lunarthrall_protected = inst._lunarthrall_protected
	replacement._original_transplanted = inst._original_transplanted

	inst:Remove()

	return replacement
end

local function PickFarmPlant()
	if math.random() < TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE then
		return weighted_random_choice(WEIGHTED_SEED_TABLE)
	else
		local season = TheWorld.state.season
		local weights = {}
		local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD

		for k, v in pairs(VEGGIES) do
			weights[k] = v.seed_weight * ((PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[season]) and season_mod or 1)
		end

		return "farm_plant_"..weighted_random_choice(weights)
	end
	
	return "weed_forgetmelots"
end

local function ReplaceWithPlant(inst)
	local plant_prefab = inst._identified_plant_type or PickFarmPlant()
	local plant = SpawnPrefab(plant_prefab)
	
	plant.Transform:SetPosition(inst.Transform:GetWorldPosition())

	if plant.plant_def ~= nil then
		plant.long_life = inst.long_life
		plant.components.farmsoildrinker:CopyFrom(inst.components.farmsoildrinker)
		plant.components.farmplantstress:CopyFrom(inst.components.farmplantstress)
		plant.components.growable:DoGrowth()
		plant.AnimState:OverrideSymbol("veggie_seed", "farm_soil", "seed")
	end

	inst.grew_into = plant
	inst:Remove()
end

local function GrowFarmPlant(inst, data)
	if not inst:IsValid() or inst:IsInLimbo() then
		return false
	end

	local growable = inst.components.growable

	if growable == nil then
		return false
	end

	local grew = false
	local start_stage = growable.stage

	local plant_def = inst.plant_def or (inst.prefab and PLANT_DEFS[inst.prefab])
	local is_randomseed = plant_def and plant_def.is_randomseed

	if is_randomseed then
		ReplaceWithPlant(inst)

		inst = inst.grew_into
		growable = inst.components.growable
		growable.stage = 1

		plant_def = inst.plant_def or (inst.prefab and PLANT_DEFS[inst.prefab])
	end

	if inst:HasTag("weed") then
		local current_stage = growable:GetStage()

		if data.supergrowth then
			if current_stage < 3 then
				growable:SetStage(3)
				grew = true
			end
		else
			if current_stage < 3 then
				growable:DoGrowth()

				if growable:GetStage() > 3 then
					growable:SetStage(3)
				end

				grew = true
			end
		end

		if grew then
			SpawnGrowFX(inst)
		end

		return grew
	end

	if not inst:HasTag("weed") then
		if data.supergrowth then
			local safe_max = growable.stage

			for i = 1, #growable.stages do
				local st = growable.stages[i]

				if st ~= nil and st.name ~= "rotten" then
					safe_max = i
				else
					break
				end
			end

			while growable.stage < safe_max do
				growable:DoGrowth()
				grew = true
			end
		else
			local steps = 1

			while steps > 0 do
				local next_stage = growable.stage + 1
				local next_data = growable.stages[next_stage]

				if not next_data or next_data.name == "rotten" then
					break
				end

				growable:DoGrowth()
				grew = true

				steps = steps - 1
			end
		end
	end

	if data.supergrowth and not inst:HasTag("weed") then
		if math.random() < TUNING.KYNO_PLANTBOOSTER_SUPERGROWTH_OVERSIZED_CHANCE then
			inst.is_oversized = true
			PushOversizedGrownEvent(inst)
		end
	end

	ClearBoosterEffects(inst)

	inst._last_booster = GetBoosterName(data)

	if data.preserve then
		if inst.SetLunarThrallProtection ~= nil then
			inst:SetLunarThrallProtection(true)
		else
			inst._lunarthrall_protected = true
		end
	end

	if data.bonus_yield and not inst.is_oversized then
		inst._bonus_yield = true
		inst:AddTag("plantboosted_yield")
	end

	if grew then
		SpawnGrowFX(inst)

		local end_stage = growable.stage
		local anim = inst.is_oversized and "oversized" or "full"

		if inst.is_oversized then
			inst.AnimState:PlayAnimation("grow_"..anim, false)
			inst.AnimState:PushAnimation("crop_"..anim, true)
		end

		if plant_def and plant_def.sounds and plant_def.sounds["grow_"..anim] then
			if inst.SoundEmitter ~= nil then
				inst.SoundEmitter:PlaySound(plant_def.sounds["grow_"..anim])
			end
		end
	end

	return grew
end

local function GrowGeneric(inst, data)
	if not inst:IsValid() or inst:IsInLimbo() then
		return false
	end

	if inst:HasTag("farm_plant") then
		return GrowFarmPlant(inst, data)
	end

	if inst._supports_transplanting == nil then
		inst._supports_transplanting = CanBeTransplanted(inst)
	end

	if inst._original_transplanted == nil and inst._supports_transplanting then
		inst._original_transplanted = inst.components.pickable.transplanted
	end

	if inst._original_lunarplant_target == nil then
		inst._original_lunarplant_target = inst:HasTag("lunarplant_target")
	end

	ClearBoosterEffects(inst)

	-- Not saving this because it's only used for debug purposes.
	inst._last_booster = GetBoosterName(data)

	if data.preserve and inst.components.pickable ~= nil then
		if inst._supports_transplanting and inst.components.pickable.transplanted then
			inst = ReplacePlant(inst)

			if inst == nil then
				return false
			end
		end

		if inst.SetLunarThrallProtection ~= nil then
			inst:SetLunarThrallProtection(true)
		else
			inst._lunarthrall_protected = true
		end
		
		inst._vitality_active = true
		inst:AddTag("plantboosted_vitality")

		if inst._supports_transplanting then
			inst.components.pickable.transplanted = false
		end
	end

	if inst.components.pickable ~= nil then
		local success = false

		if inst.components.pickable:CanBeFertilized() then
			local fertilizer = SpawnPrefab("poop")

			inst.components.pickable:Fertilize(fertilizer)
			fertilizer:Remove()
		end

		if not inst.components.pickable:CanBePicked() then
			inst.components.pickable:Regen()
		end

		if inst.components.pickable:CanBePicked() then
			success = true
		else
			local loops = 2

			for i = 1, loops do
				if inst.components.pickable:FinishGrowing() then
					inst.components.pickable:ConsumeCycles(1)
					success = true
				end
			end
		end

		if success then
			if data.bonus_yield then
				inst._bonus_yield = true
				inst:AddTag("plantboosted_yield")
			end

			SpawnGrowFX(inst)
		end

		return success
	end

	return false
end

local PlantBoostable = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("plantboostable")
end)

function PlantBoostable:ApplyBooster(booster, doer)
	local data = GetBoosterData(booster)

	if self.inst:HasTag("farm_plant") then
		if not data.can_farm then
			return false
		end

		if self.inst.components.pickable ~= nil and self.inst.components.pickable:CanBePicked() then
			return false
		end

		GrowFarmPlant(self.inst, data)

		return true
	end

	if self.inst.components.pickable ~= nil then
		GrowGeneric(self.inst, data)

		return true
	end

	return false
end

function PlantBoostable:GetDebugString()
	local inst = self.inst

	local info =
	{
		"Last Booster: "..tostring(inst._last_booster or "NONE"),
		"Bonus Yield: "..tostring(inst._bonus_yield or false),
		"Lunar Protected: "..tostring(inst._lunarthrall_protected or false),
	}

	if inst.components.pickable ~= nil then
		table.insert(info, "Transplanted: "..tostring(inst.components.pickable.transplanted))
		table.insert(info, "Original Transplanted: "..tostring(inst._original_transplanted))

		if inst.components.pickable:IsBarren() then
			table.insert(info, "State: BARREN")
		elseif inst.components.pickable:CanBePicked() then
			table.insert(info, "State: READY")
		else
			table.insert(info, "State: GROWING")
		end
	end

	if inst.components.growable ~= nil then
		table.insert(info, "Growth Stage: "..tostring(inst.components.growable:GetStage()))
	end

	if inst:HasTag("farm_plant") then
		table.insert(info, "Farm Plant: true")
		table.insert(info, "Oversized: "..tostring(inst.is_oversized or false))
	end

	return table.concat(info, "\n")
end

return PlantBoostable