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

	if inst.SoundEmitter ~= nil and inst:HasTag("farm_plant") then
		inst.SoundEmitter:PlaySound("farming/common/farm/grow_full")
	end
end

local function ClearBoosterEffects(inst)
	inst._bonus_yield = false
	inst._lunarthrall_protected = false

	if inst.components.pickable ~= nil then
		inst.components.pickable.transplanted = inst._original_transplanted or false
	end
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
		replacement.components.pickable:Regen()
	end

	replacement.Transform:SetPosition(x, y, z)
	replacement.Transform:SetRotation(rotation)

	replacement._bonus_yield = inst._bonus_yield
	replacement._lunarthrall_protected = inst._lunarthrall_protected
	replacement._original_transplanted = inst._original_transplanted

	inst:Remove()

	return replacement
end

local function GrowFarmPlant(inst, data)
	if inst:IsAsleep() then
		return false
	end

	local growable = inst.components.growable

	if growable == nil then
		return false
	end

	if inst:HasTag("weed") then
		local loops = data.supergrowth and 999 or 2

		for i = 1, loops do
			growable:DoGrowth()
		end

		SpawnGrowFX(inst)

		return true
	end

	if growable:GetStage() >= 5 or inst.is_oversized then
		return false
	end

	local max_stage = #growable.stages

	local growth_steps = 1

	if data.supergrowth then
		growth_steps = 999
	else
		growth_steps = 1
	end

	local grew = false

	for i = 1, growth_steps do
		if growable.stage >= max_stage then
			break
		end

		local next_stage = growable.stage + 1
		local next_stage_data = growable.stages[next_stage]

		if next_stage_data == nil or next_stage_data.name == "rotten" then
			break
		end

		growable:DoGrowth()
		grew = true
	end

	if data.supergrowth then
		if math.random() < TUNING.KYNO_PLANTBOOSTER_SUPERGROWTH_OVERSIZED_CHANCE then
			inst.is_oversized = true
		end
	end

	ClearBoosterEffects(inst)

	inst._last_booster = GetBoosterName(data)

	-- Yield Booster does not apply to oversized farm plants.
	if data.bonus_yield and not inst.is_oversized then
		inst._bonus_yield = true
	end

	if grew then
		SpawnGrowFX(inst)

		local anim = inst.is_oversized and "oversized" or "full"

		if inst.AnimState ~= nil then
			inst.AnimState:PlayAnimation("grow_"..anim, false)
			inst.AnimState:PushAnimation("crop_"..anim, true)
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

	if inst._original_transplanted == nil then
		inst._original_transplanted = inst.components.pickable.transplanted
	end

	ClearBoosterEffects(inst)

	-- Not saving this because it's only used for debug purposes.
	inst._last_booster = GetBoosterName(data)

	-- Vitality Booster replaces transplanted plants with fresh natural versions. And protects it against Brightshades.
	if data.preserve and inst.components.pickable ~= nil then
		if inst.components.pickable.transplanted then
			inst = ReplacePlant(inst)

			if inst == nil then
				return false
			end
		end

		inst.components.pickable.transplanted = false
		inst._lunarthrall_protected = true
	end

	if inst.components.growable ~= nil then
		local loops = 1

		if data.supergrowth then
			loops = 999
		end

		local success = false

		for i = 1, loops do
			local result = inst.components.growable:DoGrowth()

			if result then
				success = true
			else
				break
			end
		end

		if success then
			if data.bonus_yield then
				inst._bonus_yield = true
			end

			SpawnGrowFX(inst)
		end

		return success
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

		-- Yield Booster makes the plant produce +1 of its product when picked. But consumes 2 Cycles instead.
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
			end

			SpawnGrowFX(inst)
		end

		return success
	end

	if inst.components.crop ~= nil then
		if inst.components.crop:IsReadyForHarvest() then
			return false
		end

		local amount = 1

		if data.supergrowth then
			amount = 9999
		end

		inst.components.crop:DoGrow(amount)

		SpawnGrowFX(inst)

		return true
	end

	if inst.components.harvestable ~= nil
	and inst.components.harvestable:CanBeHarvested()
	and inst:HasTag("mushroom_farm") then

		local success = false

		if inst.components.harvestable:IsMagicGrowable() then
			success = inst.components.harvestable:DoMagicGrowth()
		else
			local loops = 1

			if data.supergrowth then
				loops = 999
			end

			for i = 1, loops do
				if inst.components.harvestable:Grow() then
					success = true
				end
			end
		end

		if success then
			if data.bonus_yield then
				inst._bonus_yield = true
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

		GrowFarmPlant(self.inst, data)

		return true
	end

	if self.inst.components.crop ~= nil
	or self.inst.components.pickable ~= nil
	or self.inst.components.growable ~= nil
	or self.inst.components.harvestable ~= nil then
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