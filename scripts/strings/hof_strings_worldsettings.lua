--[[
	WARNING FOR LOCALIZATION:
	
	* DON'T COPY THIS FILE TO YOUR LOCALIZATION FOLDER!

	* This is separated from the other localization files 
	because it needs to load for both client and server. 
	
	* For some fucking reason LOC can't be GLOBAL server-side
	but it needs to be GLOBAL while client-side. I don't know 
	how to switch between them while initializating the world.
	
	* If we load both strings and hof_worldsettings.lua from client
	we can't apply any changes to worldgen. And if we load both
	strings and hof_worldsettings.lua from server, we will crash.
	
]]--

-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require
local STRINGS = _G.STRINGS
local locale  = _G.LOC.GetLocaleCode()

modimport("hof_init/misc/hof_tuning")

local function ChooseTranslationTable(tbl)
    return tbl[locale] or tbl[1]
end

local STRINGS_CUSTOMIZATION =
{
	-- WORLDGEN
	RESOURCES =
	{
		"Heap of Foods - Resources",
		zh  = "更多料理 - 资源",
		zht = "食物堆積 - 資源",
		pt  = "Amontoado de Comidas - Recursos",
		pl  = "Stos jedzenia - Zasoby",
		es  = "Montón de Alimentos - Recursos",
	},
	
	RESOURCES_OCEAN =
	{
		"Heap of Foods - Ocean Resources",
		zh  = "更多料理 - 海洋资源",
		zht = "食物堆積 - 海洋資源",
		pt  = "Amontoado de Comidas - Recursos do Oceano",
		pl  = "Stos jedzenia - Zasoby oceaniczne",
		es  = "Montón de Alimentos - Recursos oceánicos",
	},
	
	SERENITYISLAND =
	{
		"Heap of Foods - Serenity Archipelago",
		zh  = "更多料理 - 宁静群岛",
		zht = "食物堆積 - 寧靜群島",
		pt  = "Amontoado de Comidas - Arquipélago da Serenidade",
		pl  = "Stos jedzenia - Archipelag Spokoju",
		es  = "Montón de Alimentos - Archipiélago de Serenidad",
	},
	
	MEADOWISLAND =
	{
		"Heap of Foods - Seaside Island",
		zh  = "更多料理 - 海滨岛屿",
		zht = "食物堆積 - 海濱島嶼",
		pt  = "Amontoado de Comidas - Ilha Beira-mar",
		pl  = "Stos jedzenia - Wyspa Nadmorska",
		es  = "Montón de Alimentos - Isla Costera",
	},
	
	-- WORLDSETTINGS
	RESOURCES_REGROW =
	{
		"Heap of Foods - Resources Regrowth",
		zh  = "更多料理 - 资源再生",
		zht = "食物堆積 - 資源再生",
		pt  = "Amontoado de Comidas - Regeneração de Recursos",
		pl  = "Stos jedzenia - Odnowa zasobów",
		es  = "Montón de Alimentos - Regeneración de recursos",
	},
	
	RESOURCES_OCEAN_REGROW =
	{
		"Heap of Foods - Ocean Resources Regrowth",
		zh  = "更多料理 - 海洋资源再生",
		zht = "食物堆積 - 海洋資源再生",
		pt  = "Amontoado de Comidas - Regeneração de Recursos Oceânicos",
		pl  = "Stos jedzenia - Odnowa zasobów oceanicznych",
		es  = "Montón de Alimentos - Regeneración de recursos oceánicos",
	},
	
	SERENITYISLAND_REGROW =
	{
		"Heap of Foods - Serenity Archipelago Regrowth",
		zh  = "更多料理 - 宁静群岛再生",
		zht = "食物堆積 - 寧靜群島再生",
		pt  = "Amontoado de Comidas - Regeneração do Arquipélago da Serenidade",
		pl  = "Stos jedzenia - Odnowa Archipelagu Spokoju",
		es  = "Montón de Alimentos - Regeneración del Archipiélago de Serenidad",
	},
	
	MEADOWISLAND_REGROW =
	{
		"Heap of Foods - Seaside Island Regrowth",
		zh  = "更多料理 - 海滨岛屿再生",
		zht = "食物堆積 - 海濱島嶼再生",
		pt  = "Amontoado de Comidas - Regeneração da Ilha Beira-mar",
		pl  = "Stos jedzenia - Odnowa Wyspy Nadmorskiej",
		es  = "Montón de Alimentos - Regeneración de la Isla Costera",
	},
}

-- Main Menu world customization.
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof",            ChooseTranslationTable(STRINGS_CUSTOMIZATION.RESOURCES),              nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_ocean",      ChooseTranslationTable(STRINGS_CUSTOMIZATION.RESOURCES_OCEAN),        nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_serenity",   ChooseTranslationTable(STRINGS_CUSTOMIZATION.SERENITYISLAND),         nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_meadow",     ChooseTranslationTable(STRINGS_CUSTOMIZATION.MEADOWISLAND),           nil, nil, 14)

AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_r",          ChooseTranslationTable(STRINGS_CUSTOMIZATION.RESOURCES_REGROW),       nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_ocean_r",    ChooseTranslationTable(STRINGS_CUSTOMIZATION.RESOURCES_OCEAN_REGROW), nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_serenity_r", ChooseTranslationTable(STRINGS_CUSTOMIZATION.SERENITYISLAND_REGROW),  nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_meadow_r",   ChooseTranslationTable(STRINGS_CUSTOMIZATION.MEADOWISLAND_REGROW),    nil, nil, 14)

local function ChooseTranslationTable2()
	-- Try to load strings if we have the localization files.
	local ok, strings = _G.pcall(require, "strings/localization_" .. locale .. "/hof_strings_customizations")
	
	if ok and strings then
		return strings
	end

    -- Fallback to english if we don't have them.
	local ok2, fallback = _G.pcall(require, "strings/hof_strings_customizations")
	
	if ok2 and fallback then
		return fallback
	end

    -- HOW DID WE GET HERE? Fallback if even english can't be loaded.
	print("Heap of Foods Mod - Failed to load World Settings Localization!")
	return {}
end

ChooseTranslationTable2()

--[[
local function ChooseTranslationTable2()
	-- Try to load strings if we have the localization files.
	local ok, strings = pcall(require, "strings/localization_" .. locale .. "/hof_strings_customizations")
	
	if not ok or strings == nil or _G.next(strings) == nil then
		-- Fallback to english if we don't have them.
		local ok2, fallback = pcall(require, "strings/hof_strings_customizations")
		
		if ok2 and fallback ~= nil then
			print("Heap of Foods Mod - No Localization found! Using English as default.")
			return fallback
		else
			print("Heap of Foods Mod - Failed to load World Settings Localization!")
			return {}
		end
	end

	return strings
end

ChooseTranslationTable2()
]]--