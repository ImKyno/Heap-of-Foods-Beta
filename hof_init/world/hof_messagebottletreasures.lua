-- Common Dependencies.
local _G                         = GLOBAL
local require                    = _G.require
local UpvalueHacker              = require("hof_upvaluehacker")
local messagebottletreasures     = require("messagebottletreasures")
local weighted_treasure_contents = UpvalueHacker.GetUpvalue(messagebottletreasures.GetPrefabs, "weighted_treasure_contents")

-- New loots for Sunken Chests.
local hof_presets =
{
	hof_presets_cook =
	{
		guaranteed_loot = 
		{ 
			kyno_cookware_kit_hanger = 1, 
			kyno_cookware_kit_grill = 1, 
			kyno_cookware_kit_small_grill = 1, 
			kyno_cookware_kit_oven = 1, 
			kyno_cookware_kit_syrup = 1 
		},
	
		randomly_selected_loot =
		{
			{ kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,
	},
	
	hof_presets_tool =
	{
		guaranteed_loot = 
		{ 
			kyno_sapbucket_installer = 1, 
			kyno_crabtrap_installer = 1, 
			kyno_saltrack_installer = 1, 
			kyno_slaughtertool = 1, 
		},
	
		randomly_selected_loot =
		{
			{ kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,
	},
	
	hof_presets_food =
	{
		guaranteed_loot = 
		{ 
			kyno_oil = {2, 6}, 
			kyno_sugar = {2, 8}, 
			kyno_flour = {1, 5}, 
			kyno_beanbugs = {1, 3}, 
			kyno_gummybug = {1, 3},
		},
	
		randomly_selected_loot =
		{
			{ kyno_pineapple = .33, kyno_taroroot = .33, kyno_lotus_flower = .33 }, 
			{ kyno_waterycress = .33, kyno_seaweeds = .33, kyno_limpets = .33 },
			{ kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,	
	},
	
	hof_presets_can1 =
	{
		guaranteed_loot = 
		{ 
			kyno_sodacan = 1,
			kyno_cokecan = 1,
			kyno_energycan = 1,
		},
	
		randomly_selected_loot =
		{
			{ kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,	
	},
	
	hof_presets_can2 =
	{
		guaranteed_loot = 
		{ 
			kyno_tomatocan = 1, 
			kyno_meatcan = 1, 
			kyno_beancan = 1, 
		},
	
		randomly_selected_loot =
		{
			{ kyno_tunacan = .50, kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,	
	},
	
	hof_presets_fallout =
	{
		guaranteed_loot =
		{
			nukashine_sugarfree = {1, 4},
			nukacola = {1, 3},
			nukacola_quantum = {1, 2},
		},
		
		randomly_selected_loot =
		{
			{ sugarbombs = 1 },
			{ kyno_brewingrecipecard = .33 },
		},
		
		preset_weight = 1,
	},
	
	hof_presets_mobs =
	{
		guaranteed_loot = 
		{ 
			kyno_fishpackage = {1, 2}, -- Give them inside a bundle, who knows what might happen if let loose.
			kyno_mobpackage = {1, 2}, -- Pikos on a boat, holy shit...
		},
	
		randomly_selected_loot =
		{
			{ kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,	
	},
	
	hof_presets_misc =
	{
		guaranteed_loot = 
		{ 
			kyno_kokonut = {1, 3}, 
			kyno_sugartree_bud = {1, 3}, 
			kyno_oaktree_pod = {1, 3}, 
			kyno_sugartree_petals = {4, 6},
		},
	
		randomly_selected_loot =
		{
			{ mandrake = .33, kyno_brewingrecipecard = 1 },
		},

		preset_weight = 1,	
	},
}

for k, preset in pairs(hof_presets) do 
	weighted_treasure_contents.sunkenchest[preset] = preset.preset_weight
end