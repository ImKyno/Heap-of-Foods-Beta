local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Shiy Loot Mod support for our rare items. (Requires scrapbook to be enabled).
if TUNING.HOF_SCRAPBOOK then
	local SCRAPBOOKDATA = _G.deepcopy(require("screens/redux/scrapbookdata"))

	for entry, data in pairs(SCRAPBOOKDATA) do
		data.deps = data.deps or {}

		for _, dep in ipairs(data.deps) do
			local depdata = SCRAPBOOKDATA[dep]

			if depdata ~= nil then
				depdata.deps = depdata.deps or {}

				if not table.contains(depdata.deps, entry) then
					table.insert(depdata.deps, entry)
				end
			end
		end
	end

	local function CreatureTest(loot, entity)
		local deps = SCRAPBOOKDATA[loot.prefab] ~= nil and SCRAPBOOKDATA[loot.prefab].deps or nil

		if deps == nil then
			return false
		end

		return table.contains(deps, entity.prefab) and entity.replica.health ~= nil and entity.replica.health:IsDead()
	end

	TUNING.SHINY_LOOT_MOD_DEFS = TUNING.SHINY_LOOT_MOD_DEFS or {}
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_garden_sprinkler_blueprint"] = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_antchest_blueprint"]         = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["dug_kyno_coffeebush"]             = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_crabkingmeat"]               = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_poison_froglegs"]            = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_foodsack_blueprint"]         = CreatureTest
	TUNING.SHINY_LOOT_MOD_DEFS["kyno_fishfarmplot_kit_blueprint"] = CreatureTest
end

-- Apparels Overload support.
if TUNING.HOF_IS_TCP_ENABLED then
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["gorge_fishball_skewers"] = "piratehat"
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["gorge_fishburger"]       = "captainhat"
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["wobstermonster"]         = "armorlifejacket"
end

-- Not Enough Turfs so bird can land on their turfs too.
if TUNING.HOF_IS_NET_ENABLED then
	AddClassPostConstruct("components/birdspawner", function(self)
		local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

		BIRD_TYPES[WORLD_TILES.BEACH]          = { "toucan", "toucan_chubby" }
		BIRD_TYPES[WORLD_TILES.TIDALMARSH]     = { "toucan", "toucan_chubby" }
		BIRD_TYPES[WORLD_TILES.FIELDS]         = { "kingfisher" }
	end)
end

-- This is stupid as fuck. Unfortunately Dehydrated Mod is not updated regularly
-- and their patches for HoF are not compatible anymore, I guess...
-- They are overriding some of the ingredients (I did too but fixed now :P) and making recipes unable to cook.
-- Current workaround is to re-apply these stuff if their mod is enabled.
if TUNING.HOF_IS_DHD_ENABLED then
	print("Heap of Foods Mod - WARNING: Dehydrated Mod is enabled!")
	print("Heap of Foods Mod - WARNING: Dehydrated Mod has incompatible patches for this mod.")

	AddSimPostInit(function()
		print("Heap of Foods Mod - WARNING: Dehydrated Mod is overriding key ingredients.")
		print("Heap of Foods Mod - WARNING: Trying to re-apply patches...")

		local cooking = require("cooking")

		local patches =
		{
			foliage          = "foliage",
			succulent_picked = "succulent",
			firenettles      = "fireweed",
			tillweed         = "tillweed",
			forgetmelots     = "forgetweed",
		}

		local success = true

		for prefab, tag in pairs(patches) do
			local ingredient = cooking.ingredients[prefab]

			if ingredient and ingredient.tags then
				ingredient.tags[tag] = 1
			else
				success = false
				print(string.format("Heap of Foods Mod - WARNING: Failed to patch %s", prefab))
			end
		end

		print(success and "Heap of Foods Mod - Successfully re-applied all patches for Dehydrated Mod."
		or "Heap of Foods Mod - WARNING: Failed to re-apply patches for Dehydrated Mod!")
	end)
end