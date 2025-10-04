-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require
local locale  = _G.LOC.GetLocaleCode()

modimport("hof_init/misc/hof_tuning")

local function ChooseTranslationTable(tbl)
    return tbl[locale] or tbl[1]
end

local STRINGS =
{
	-- WORLDGEN
	RESOURCES =
	{
		"Heap of Foods - Resources",
		zh  = "食物堆积 - 资源",
		zht = "食物堆積 - 資源",
		pt  = "Amontoado de Comidas - Recursos",
		pl  = "Stos jedzenia - Zasoby",
		es  = "Montón de Alimentos - Recursos",
	},
	
	RESOURCES_OCEAN =
	{
		"Heap of Foods - Ocean Resources",
		zh  = "食物堆积 - 海洋资源",
		zht = "食物堆積 - 海洋資源",
		pt  = "Amontoado de Comidas - Recursos do Oceano",
		pl  = "Stos jedzenia - Zasoby oceaniczne",
		es  = "Montón de Alimentos - Recursos oceánicos",
	},
	
	SERENITYISLAND =
	{
		"Heap of Foods - Serenity Archipelago",
		zh  = "食物堆积 - 宁静群岛",
		zht = "食物堆積 - 寧靜群島",
		pt  = "Amontoado de Comidas - Arquipélago da Serenidade",
		pl  = "Stos jedzenia - Archipelag Spokoju",
		es  = "Montón de Alimentos - Archipiélago de Serenidad",
	},
	
	MEADOWISLAND =
	{
		"Heap of Foods - Seaside Island",
		zh  = "食物堆积 - 海滨岛屿",
		zht = "食物堆積 - 海濱島嶼",
		pt  = "Amontoado de Comidas - Ilha Beira-mar",
		pl  = "Stos jedzenia - Wyspa Nadmorska",
		es  = "Montón de Alimentos - Isla Costera",
	},
	
	-- WORLDSETTINGS
	RESOURCES_REGROW =
	{
		"Heap of Foods - Resources Regrowth",
		zh  = "食物堆积 - 资源再生",
		zht = "食物堆積 - 資源再生",
		pt  = "Amontoado de Comidas - Regeneração de Recursos",
		pl  = "Stos jedzenia - Odnowa zasobów",
		es  = "Montón de Alimentos - Regeneración de recursos",
	},
	
	RESOURCES_OCEAN_REGROW =
	{
		"Heap of Foods - Ocean Resources Regrowth",
		zh  = "食物堆积 - 海洋资源再生",
		zht = "食物堆積 - 海洋資源再生",
		pt  = "Amontoado de Comidas - Regeneração de Recursos Oceânicos",
		pl  = "Stos jedzenia - Odnowa zasobów oceanicznych",
		es  = "Montón de Alimentos - Regeneración de recursos oceánicos",
	},
	
	SERENITYISLAND_REGROW =
	{
		"Heap of Foods - Serenity Archipelago Regrowth",
		zh  = "食物堆积 - 宁静群岛再生",
		zht = "食物堆積 - 寧靜群島再生",
		pt  = "Amontoado de Comidas - Regeneração do Arquipélago da Serenidade",
		pl  = "Stos jedzenia - Odnowa Archipelagu Spokoju",
		es  = "Montón de Alimentos - Regeneración del Archipiélago de Serenidad",
	},
	
	MEADOWISLAND_REGROW =
	{
		"Heap of Foods - Seaside Island Regrowth",
		zh  = "食物堆积 - 海滨岛屿再生",
		zht = "食物堆積 - 海濱島嶼再生",
		pt  = "Amontoado de Comidas - Regeneração da Ilha Beira-mar",
		pl  = "Stos jedzenia - Odnowa Wyspy Nadmorskiej",
		es  = "Montón de Alimentos - Regeneración de la Isla Costera",
	},
}

-- Main Menu world customization.
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof",            ChooseTranslationTable(STRINGS.RESOURCES),              nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_ocean",      ChooseTranslationTable(STRINGS.RESOURCES_OCEAN),        nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_serenity",   ChooseTranslationTable(STRINGS.SERENITYISLAND),         nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_meadow",     ChooseTranslationTable(STRINGS.MEADOWISLAND),           nil, nil, 14)

AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_r",          ChooseTranslationTable(STRINGS.RESOURCES_REGROW),       nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_ocean_r",    ChooseTranslationTable(STRINGS.RESOURCES_OCEAN_REGROW), nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_serenity_r", ChooseTranslationTable(STRINGS.SERENITYISLAND_REGROW),  nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_meadow_r",   ChooseTranslationTable(STRINGS.MEADOWISLAND_REGROW),    nil, nil, 14)

local customization_worldgen      = require("map/hof_customizations_worldgen")
local customization_worldsettings = require("map/hof_customizations_worldsettings")

for k, v in pairs(customization_worldgen) do
	v.image = "worldgen_"..v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldgen.xml",
	})
end

for k, v in pairs(customization_worldsettings) do
	v.image = v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldsettings.xml",
	})
end