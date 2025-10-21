local prefabs = {}

-- Display Stand Skins.
table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_cakestand", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_cakestand.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_cakestand",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_fridge", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_fridge.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_fridge",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_icebox", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_icebox.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_icebox",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_marble", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_marble.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_marble",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_marbledome", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_marbledome.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_marbledome",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_quagmire", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_quagmire.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_quagmire",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER", "VICTORIAN"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_traystand", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_traystand.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_traystand",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

table.insert(prefabs, CreatePrefabSkin("ms_kyno_itemshowcaser_yotp", 
{
	assets              = 
	{
		Asset("ANIM", "anim/ms_kyno_itemshowcaser_yotp.zip"),
	},
	
	base_prefab         = "kyno_itemshowcaser",
	build_name_override = "ms_kyno_itemshowcaser_yotp",

	type                = "item",
	rarity              = "ModMade",
	skin_tags           = {"KYNO_ITEMSHOWCASER"},
}))

return unpack(prefabs)