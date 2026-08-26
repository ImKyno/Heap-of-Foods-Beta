local _G      = GLOBAL
local require = _G.require

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