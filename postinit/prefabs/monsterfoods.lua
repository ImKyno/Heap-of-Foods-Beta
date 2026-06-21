local _G = GLOBAL

local MONSTER_FOODS =
{
	shroombait     = { health = 20, sanity = 15 },
	monsterlasagna = { health = 20, sanity = 20 },
	monstertartare = { health = 20, sanity = 20 },
}

-- Monkey patch, too lazy to properly find a definitive fix for it.
local function MonsterFoodPostInit(inst, data)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.edible ~= nil then
		local _oneaten = inst.components.edible.oneaten

		inst.components.edible:SetOnEatenFn(function(inst, eater)
			if _oneaten ~= nil then
				_oneaten(inst, eater)
			end

			if eater ~= nil and eater:HasTag("playermonster")
			and not (eater.components.health ~= nil and eater.components.health:IsDead())
			and not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(data.health)
				eater.components.sanity:DoDelta(data.sanity)
			end
		end)
	end
end

for food, data in pairs(MONSTER_FOODS) do
	for _, spice in pairs(TUNING.HOF_SPICES) do
		AddPrefabPostInit(food.."_spice_"..spice, function(inst)
			MonsterFoodPostInit(inst, data)
		end)
	end
end