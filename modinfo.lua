name                        = "Heap of Foods (Beta)"
version                     = "7.9-A"

description                 = 
[[
󰀄 Adds over +100 brand new Crock Pot dishes alongside new ingredients to use. Happy Cooking!

󰀠 Also features brand new Biomes somewhere in the Ocean!
󰀦 Complete Recipe Sheet on the Mod Page!

󰀏 Featuring the Bountiful Harvest Update:
This update focused on revamping the visuals of the farming crops as well as adding new ones! And some smaller changes and improvements in general to the mod.

Our survivors have managed to find new types of seeds out in the wild! And far, far away from the mainland, on a tropical island a new kind of bush is blooming, waiting for them to uncover it.

󰀌 Mod Version: 7.9-A
󰀧 Update: Bountiful Harvest
]]

author                      = "Kyno"
api_version                 = 10
priority                    = -15

dst_compatible              = true
all_clients_require_mod     = true
client_only_mod             = false

server_filter_tags          = {"Heap of Foods", "HOF", "Cooking", "Entertainment", "Kyno"}

icon                        = "ModiconHOF.tex"
icon_atlas                  = "ModiconHOF.xml"

local emptyoptions          = {{description = "", data = false}}
local function Title(title, hover)
	return 
	{
		name	            = title,
		hover               = hover,
		options             = {{description = "", data = 0}},
		default             = 0,
	}
end

configuration_options       =
{
	{
        name                = "HOF_LANGUAGE",
        label               = "Language",
        hover               = "Choose the language for the mod.\nYou can submit your translation in our Discord.",
        options             =
        {
            {
				description = "English", 
				hover       = "Translation by: Kyno.",
				data        = "hof_strings"
			},
			{
				description = "Português (BR)",
				hover       = "Translation by: Kyno.",
				data        = "hof_strings_br"
			},
        },
        default             = "hof_strings",
    },
	
	Title("General Options", "General options for the entire mod."),
    {
        name                = "HOF_KEEPFOOD",
        label               = "Keep Food Spoilage",
        hover               = "Should food spoil if it's in the Crock Pot?",
        options             =
        {
            {
				description = "No", 
				hover       = "Food will spoil in Crock Pot, Portable Crock Pot, etc.",
				data        = 0
			},	
			{
				description = "Yes", 
				hover       = "Food will not spoil in Crock Pot, Portable Crock Pot, etc.",
				data        = 1
			},
        },
        default             = 0,
    },
	{
        name                = "HOF_COFFEEDROPRATE",
        label               = "Coffee Plant Drop Rate",
        hover               = "How many Coffee Plants Dragonfly should drop?",
        options             =
        {
			
            {
				description = "0", 
				hover       = "Dragonfly will not Coffee Plants.",
				data        = 0
			},
            {
				description = "4", 
				hover       = "Dragonfly will drop 4 Coffee Plants.",
				data        = 4
			},
            {
				description = "8", 
				hover       = "Dragonfly will drop 8 Coffee Plants.",
				data        = 8
			},
			{	
				description = "12", 
				hover       = "Dragonfly will drop 12 Coffee Plants.",
				data        = 12
			},
			{
				description = "16", 
				hover       = "Dragonfly will drop 16 Coffee Plants.",
				data        = 16
			},
        },
        default             = 1,
    },
	
	Title("Food Options", "Options for foods and ingredients."),
	{
		name                = "HOF_SEASONALFOOD",
		label               = "Seasonal Recipes",
		hover               = "Should Seasonal Recipes only be cooked during Special Events?",
		options             =
		{
			{
				description = "No",
				hover       = "Seasonal Recipes can be cooked without restrictions.",
				data        = true
			},
			{
				description = "Yes",
				hover       = "Seasonal Recipes can only be cooked when Special Events are active.",
				data        = false
			},
		},
		default             = false,
	},
	{
		name                = "HOF_HUMANMEAT",
		label               = "Long Pig Recipes",
		hover               = "Should Players drop Long Pigs upon death?\nNote: If disabled, this will cause some Recipes to be uncookable.",
		options             =
		{
			{
				description = "No",
				hover       = "Players will not drop Long Pigs upon death.",
				data        = 0
			},
			{
				description = "Yes",
				hover       = "Players may have a chance to drop Long Pigs upon death.",
				data        = 1
			},
		},
		default             = 1,
	},
	{
		name                = "HOF_ALCOHOLICDRINKS",
		label               = "Alcoholic Restriction",
		hover               = "Should some characters be unable to drink Alcoholic-like drinks?",
		options             =
		{
			{
				description = "No", 
				hover       = "All characters can drink Alcoholic-like drinks.",
				data        = 0
			},
            {	
				description = "Yes", 
				hover       = "Some characters like Webber, Wendy, etc. can't drink Alcoholic-like drinks.",
				data        = 1
			},
        },
        default             = 0,
	},
	{
		name                = "HOF_GIANTSPAWNING",
		label               = "Giants from Foods",
		hover               = "Should Players spawn Giants when eating their special food?",
		options             =
		{
			{
				description = "No",
				hover       = "Players will not spawn Giants when eating their special food.",
				data        = 0
			},
			{
				description = "Yes",
				hover       = "Players will spawn Giants when eating their special food.",
				data        = 1
			},
		},
		default             = 1,
	},
	{
		name                = "HOF_COFFEESPEED",
		label               = "Speed Buff",
		hover               = "Should the foods give the Speed Buff when eaten?\n\This option applies to: Coffee Beans, Coffee and Tropical Bouillabaisse.",
		options             =
		{
			{
				description = "No",
				hover       = "Foods will not give the Speed Buff when eaten.",
				data        = 0
			},
			{
				description = "Yes",
				hover       = "Foods will give the Speed Buff when eaten.",
				data        = 1
			},
		},
		default             = 1,
	},
	{
		name                = "HOF_COFFEEDURATION",
		label               = "Speed Buff Duration",
		hover               = "How long the Speed Buff from foods will last?\n\This option applies to: Coffee and Tropical Bouillabaisse.",
		options             =
		{
			{
				description = "Super Fast",
				hover       = "Speed Buff will last for 2 Minutes.",
				data        = 120
			},
			{
				description = "Fast",
				hover       = "Speed Buff will last for a Half Day.",
				data        = 240
			},
			{
				description = "Default",
				hover       = "Speed Buff will last for 1 Day.",
				data        = 480
			},
			{
				description = "Average",
				hover       = "Speed Buff will last for 1.5 Days.",
				data        = 640
			},
			{
				description = "Long",
				hover       = "Speed Buff will last for 2 Days.",
				data        = 960
			},
			{
				description = "Super Long",
				hover       = "Speed Buff will last for 4 Days.",
				data        = 1920
			},
		},
		default             = 480,
	},
	
	Title("Extra Options", "Extra Options for the Mod."),
	{
		name                = "HOF_WARLYMEALGRINDER",
		label               = "Portable Grinding Mill Recipes",
		hover               = "Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
		options             =
		{
			{
				description = "No", 
				hover       = "Warly's Portable Grinding Mill will not have the recipes from Mealing Stone.",
				data        = 0
			},
            {
				description = "Yes", 
				hover       = "Warly's Portable Grinding Mill will have the recipes from Mealing Stone.",
				data        = 1
			},
        },
        default             = 0,
	},
	{
		name                = "HOF_FERTILIZERTWEAK",
		label               = "Bucket-o-Poop Recipe",
		hover               = "Should Bucket-o-Poop use the Bucket instead of the default recipe?",
		options             =
		{
			{
				description = "Default", 
				hover       = "Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
				data        = 0
			},
            {
				description = "Tweaked", 
				hover       = "Bucket-o-Poop will use the Bucket on its crafting recipe.",
				data        = 1
			},
        },
        default = 0,
	},
	
	Title("Retrofit Options", "Options for retrofitting old worlds."),
	{
		name                = "HOF_RETROFIT",
		label               = "Retrofit Contents",
		hover               = "If your world is missing the Mod Contents enable this option.\nThis option will be set as \"Updated\" once the retrofitting is finished!",
		options             =
		{
			{
				description = "Updated", 
				hover       = "Your world is already updated with the Mod Contents.",
				data        = 0
			},
            {
				description = "Retrofit Islands", 
				hover       = "Mod Islands will be generated during server initialization.",
				data        = 1
			},
			{
				description = "Retrofit Prefabs", 
				hover       = "Mod Prefabs will be generated during server initialization.",
				data        = 2
			},
        },
        default             = 0,
	},
}