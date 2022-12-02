name = "Heap of Foods"
version = "5.3-A"
local myupdate = "Artisan Goods (Part II)"

description = [[
󰀄 Adds over +100 brand new Crock Pot dishes alongside new ingredients to use!

󰀠 Also features brand new Biomes somewhere in the Ocean!
󰀦 Complete Recipe Sheet on the Mod Page!

󰀏 Featuring the Artisan Goods Update
This update brings two new structures that can be used to make a whole new category of recipes!

The Wooden Keg and the Preserves Jar, use them to brew Wines, Juices, Jams, Pickles, Mayonnaises, Teas and more!
They take longer to produce a product, but are totally worth your time! Some of them comes with unique abilities.

󰀌 Mod Version: 5.3-A
󰀧 Update: Artisan Goods (Part II)
]]

author = "Kyno"
api_version = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"Heap of Foods", "HOF", "Cooking", "Entertainment", "Kyno"}

icon = "ModiconHOF.tex"
icon_atlas = "ModiconHOF.xml"

local emptyoptions = {{description = "", data = false}}
local function Title(title, hover)
	return {
		name	= title,
		hover   = hover,
		options = {{description = "", data = 0}},
		default = 0,
	}
end

configuration_options =
{
	{
        name = "HOF_LANGUAGE",
        label = "Language",
        hover = "Choose the language for the mod.\nYou can submit your translation in our Discord.",
        options =
        {
            {
				description = "English", 
				hover = "Translation by: Kyno.",
				data = "hof_strings"
			},
            {
				description = "繁體中文", 
				hover = "Translation by: Djr.",
				data = "hof_strings_zht"
			},
			{
				description = "Português Brasileiro",
				hover = "Translation by: Kyno.",
				data = "hof_strings_br"
			},
        },
        default = "hof_strings",
    },
	
	Title("General Options", "General options for the entire mod."),
    {
        name = "HOF_KEEPFOOD",
        label = "Keep Food Spoilage",
        hover = "Should food spoil if it's in the Crock Pot?",
        options =
        {
            {
				description = "No", 
				hover = "Food will spoil in Crock Pot, Portable Crock Pot, etc.",
				data = 0
			},	
			{
				description = "Yes", 
				hover = "Food will not spoil in Crock Pot, Portable Crock Pot, etc.",
				data = 1
			},
        },
        default = 0,
    },
	{
        name = "HOF_COFFEEDROPRATE",
        label = "Coffee Plant Drop Rate",
        hover = "How many Coffee Plants Dragonfly should drop?",
        options =
        {
			
            {
				description = "0", 
				hover = "Dragonfly will not Coffee Plants.",
				data = 0
			},
            {
				description = "4", 
				hover = "Dragonfly will drop 4 Coffee Plants.",
				data = 1
			},
            {
				description = "8", 
				hover = "Dragonfly will drop 8 Coffee Plants.",
				data = 2
			},
			{	
				description = "12", 
				hover = "Dragonfly will drop 12 Coffee Plants.",
				data = 3
			},
			{
				description = "16", 
				hover = "Dragonfly will drop 16 Coffee Plants.",
				data = 4
			},
        },
        default = 1,
    },
	
	Title("Food Options", "Options for foods and ingredients."),
	{
		name = "HOF_COFFEEGOODIES",
		label = "Wigfrid Drinks Coffee",
		hover = "Should Wigfrid drink coffee?",
		options =
		{
			{
				description = "No",
				hover = "Wigfrid can't drink coffee.",
				data = 0
			},
			{
				description = "Yes",
				hover = "Wigfrid can drink coffee.",
				data = 1
			},
		},
		default = 1,
	},
	{
		name = "HOF_COFFEESPEED",
		label = "Speed Buff",
		hover = "Should the foods give the Speed Buff when eaten?\n\This option applies to: Coffee Beans, Coffee and Tropical Bouillabaisse.",
		options =
		{
			{
				description = "No",
				hover = "Foods will not give the Speed Buff when eaten.",
				data = 0
			},
			{
				description = "Yes",
				hover = "Foods will give the Speed Buff when eaten.",
				data = 1
			},
		},
		default = 1,
	},
	{
		name = "HOF_COFFEEDURATION",
		label = "Speed Buff Duration",
		hover = "How long the Speed Buff from foods will last?\n\This option applies to: Coffee and Tropical Bouillabaisse.",
		options =
		{
			{
				description = "Super Fast",
				hover = "Speed Buff will last for 2 Minutes.",
				data = 120
			},
			{
				description = "Fast",
				hover = "Speed Buff will last for a Half Day.",
				data = 240
			},
			{
				description = "Default",
				hover = "Speed Buff will last for 1 Day.",
				data = 480
			},
			{
				description = "Average",
				hover = "Speed Buff will last for 1.5 Days.",
				data = 640
			},
			{
				description = "Long",
				hover = "Speed Buff will last for 2 Days.",
				data = 960
			},
			{
				description = "Super Long",
				hover = "Speed Buff will last for 4 Days.",
				data = 1920
			},
		},
		default = 480,
	},
	{
		name = "HOF_HUMANMEAT",
		label = "Long Pig From Players",
		hover = "Should Players drop Long Pigs upon death?\nNote: If disabled, this will cause Deadly Feast to be uncookable.",
		options =
		{
			{
				description = "No",
				hover = "Players will not drop Long Pigs upon death.",
				data = 0
			},
			{
				description = "Yes",
				hover = "Players will drop Long Pigs upon death.",
				data = 1
			},
		},
		default = 1,
	},
	{
		name = "HOF_ALCOHOLICDRINKS",
		label = "Alcoholic Restriction",
		hover = "Should some characters be unable to drink Alcoholic-like drinks?",
		options =
		{
			{
				description = "No", 
				hover = "All characters can drink Alcoholic-like drinks.",
				data = 0
			},
            {	
				description = "Yes", 
				hover = "Some characters like Webber, Wendy, etc. can't drink Alcoholic-like drinks.",
				data = 1
			},
        },
        default = 0,
	},
	
	Title("World Options", "Options for the world."),
	{
		name = "HOF_RETROFIT",
		label = "Retrofit Contents",
		hover = "If your world is missing the Mod Contents enable this option.\nThis option will be set as \"Updated\" once the retrofitting is finished!",
		options =
		{
			{
				description = "Updated", 
				hover = "Your world is already updated with the Mod Contents.",
				data = 0
			},
            {
				description = "Retrofit Serenity Archipelago", 
				hover = "Serenity Archipelago will be generated during server initialization.",
				data = 1
			},
			{
				description = "Retrofit Seaside Island", 
				hover = "Seaside Island will be generated during server initialization.",
				data = 2
			},
        },
        default = 0,
	},
	{
		name = "HOF_OCEANSETPIECE_COUNT",
		label = "Ocean Setpieces",
		hover = "How many Ocean Setpieces should be generated in the world?",
		options =
		{
			{
				description = "None", 
				hover = "Nothing will be generated.",
				data = 0
			},
			{
				description = "Less", 
				hover = "At least One of each will be generated.",
				data = 1
			},
			{
				description = "Default", 
				hover = "At least Two of each will be generated.",
				data = 2
			},
			{
				description = "More", 
				hover = "At least Three of each will be generated.",
				data = 3
			},
        },
        default = 2,
	},
	{
		name = "HOF_REGROWTH",
		label = "World Regrowth",
		hover = "Should the Mod plants and objects regrow overtime in the world?",
		options =
		{
			{
				description = "No", 
				hover = "Mod Plants and objects will not regrow overtime in the world.",
				data = 0
			},
            {
				description = "Yes", 
				hover = "Mod Plants and objects will regrow overtime in the world.",
				data = 1
			},
        },
        default = 0,
	},
	
	Title("Extra Options", "Extra Options for the Mod."),
	{
		name = "HOF_WARLYMEALGRINDER",
		label = "Portable Grinding Mill Recipes",
		hover = "Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
		options =
		{
			{
				description = "No", 
				hover = "Warly's Portable Grinding Mill will not have the recipes from Mealing Stone.",
				data = 0
			},
            {
				description = "Yes", 
				hover = "Warly's Portable Grinding Mill will have the recipes from Mealing Stone.",
				data = 1
			},
        },
        default = 0,
	},
	{
		name = "HOF_FERTILIZERTWEAK",
		label = "Bucket-o-Poop Recipe",
		hover = "Should Bucket-o-Poop use the Bucket instead of the default recipe?",
		options =
		{
			{
				description = "Default", 
				hover = "Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
				data = 0
			},
            {
				description = "Tweaked", 
				hover = "Bucket-o-Poop will use the Bucket on its crafting recipe.",
				data = 1
			},
        },
        default = 0,
	},
	--[[
	{
		name = "serenity_cc",
		label = "Serenity Archipelago CC",
		hover = "Should the Serenity Archipelago have The Gorge Colour Cubes?",
		options =
		{
			{
				description = "No", 
				hover = "Serenity Archipelago will not have The Gorge Colour Cubes.",
				data = 0
			},
            {
				description = "Yes", 
				hover = "Serenity Archipelago will have The Gorge Colour Cubes.",
				data = 1
			},
        },
        default = 0,
	},
	]]--
}