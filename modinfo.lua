name = "Heap of Foods"
version = "4.2-A"
local myupdate = "Souls and Cans"

description = "󰀄 Adds 118 brand new Crock Pot dishes alongside new ingredients to use!\n\n󰀦 Also features a brand new Biome somewhere in the Ocean!\n\n󰀌 Mod Version: "..version.."\n\󰀧 Update: "..myupdate..""
author = "Kyno"

api_version = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"Heap of Foods", "HOF", "Cooking", "Entertainment", "Kyno"}

icon = "ModiconHOF.tex"
icon_atlas = "ModiconHOF.xml"

local emptyoptions = {{description="", data=false}}
local function Title(title, hover)
	return {
		name=title,
		hover=hover,
		options={{description = "", data = 0}},
		default=0,
	}
end

configuration_options =
{
	Title("General Options", "General options for the entire mod."),
    {
        name = "keep_food_spoilage_k",
        label = "Keep Food Spoilage",
        hover = "Should food spoil if it's in the Crock Pot?",
        options =
        {
            {description = "No", 
			hover = "Food will spoil in Crock Pot, Portable Crock Pot, etc.",
			data = 0},
            {description = "Yes", 
			hover = "Food will not spoil in Crock Pot, Portable Crock Pot, etc.",
			data = 1},
        },
        default = 0,
    },
	{
        name = "df_coffee",
        label = "Coffee Plant Drop Rate",
        hover = "How many Coffee Plants Dragonfly should drop?",
        options =
        {
			
            {description = "0", 
			hover = "Dragonfly will not Coffee Plants.",
			data = 0},
            {description = "4", 
			hover = "Dragonfly will drop 4 Coffee Plants.",
			data = 1},
            {description = "8", 
			hover = "Dragonfly will drop 8 Coffee Plants.",
			data = 2},
			{description = "12", 
			hover = "Dragonfly will drop 12 Coffee Plants.",
			data = 3},
			{description = "16", 
			hover = "Dragonfly will drop 16 Coffee Plants.",
			data = 4},
        },
        default = 1,
    },
	Title("Food Options", "Options for foods and ingredients."),
	{
		name = "frida_coffee",
		label = "Wigfrid Drinks Coffee",
		hover = "Should Wigfrid drink coffee?",
		options =
		{
			{description = "No",
			hover = "Wigfrid can't drink coffee.",
			data = 0},
			{description = "Yes",
			hover = "Wigfrid can drink coffee.",
			data = 1},
		},
		default = 1,
	},
	{
		name = "coffee_speed",
		label = "Speed Buff",
		hover = "Should the foods give the Speed Buff when eaten?\n\This option applies to: Coffee Beans, Coffee and Tropical Bouillabaisse.",
		options =
		{
			{description = "No",
			hover = "Foods will not give the Speed Buff when eaten.",
			data = 0},
			{description = "Yes",
			hover = "Foods will give the Speed Buff when eaten.",
			data = 1},
		},
		default = 1,
	},
	{
		name = "coffee_duration",
		label = "Speed Buff Duration",
		hover = "How long the Speed Buff from foods will last?\n\This option applies to: Coffee and Tropical Bouillabaisse.",
		options =
		{
			{description = "Super Fast",
			hover = "Speed Buff will last for 2 Minutes.",
			data = 120},
			{description = "Fast",
			hover = "Speed Buff will last for a Half Day.",
			data = 240},
			{description = "Default",
			hover = "Speed Buff will last for 1 Day.",
			data = 480},
			{description = "Average",
			hover = "Speed Buff will last for 1.5 Days.",
			data = 640},
			{description = "Long",
			hover = "Speed Buff will last for 2 Days.",
			data = 960},
			{description = "Super Long",
			hover = "Speed Buff will last for 4 Days.",
			data = 1920},
		},
		default = 480,
	},
	{
		name = "xmas_foods",
		label = "Optional Foods",
		hover = "Should Winter's Feast \"craftable foods\" be cookable in the Crock Pot?\nWinter's Feast foods can't be cooked if this option is Disabled.",
		options =
		{
			{description = "No",
			hover = "Winter's Feast foods can't be cooked in the Crock Pot.",
			data = 0},
			{description = "Yes",
			hover = "Winter's Feast foods can be cooked in the Crock Pot.",
			data = 1},
		},
		default = 1,
	},
	{
		name = "human_meaty",
		label = "Long Pig From Players",
		hover = "Should Players drop Long Pigs upon death?\nNote: If disabled, this will cause Deadly Feast to be uncookable.",
		options =
		{
			{description = "No",
			hover = "Players will not drop Long Pigs upon death.",
			data = 0},
			{description = "Yes",
			hover = "Players will drop Long Pigs upon death.",
			data = 1},
		},
		default = 1,
	},
	Title("World Options", "Options for the world."),
	{
		name = "serenity_island",
		label = "Serenity Archipelago",
		hover = "If your world is missing the Serenity Archipelago enable this option.\nThis option will be disabled once the retrofitting is finished!",
		options =
		{
			{description = "No", 
			hover = "Serenity Archipelago is already generated in your world!",
			data = 0},
            {description = "Yes", 
			hover = "Serenity Archipelago will be generated during server initialization.",
			data = 1},
        },
        default = 0,
	},
	{
		name = "serenity_cc",
		label = "Serenity Archipelago CC",
		hover = "Should the Serenity Archipelago have The Gorge Colour Cubes?",
		options =
		{
			{description = "No", 
			hover = "Serenity Archipelago will not have The Gorge Colour Cubes.",
			data = 0},
            {description = "Yes", 
			hover = "Serenity Archipelago will have The Gorge Colour Cubes.",
			data = 1},
        },
        default = 0,
	},
	Title("Extra Options", "Extra Options for the Mod."),
	{
		name = "warly_mealgrinder",
		label = "Portable Grinding Mill Recipes",
		hover = "Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
		options =
		{
			{description = "No", 
			hover = "Warly's Portable Grinding Mill will not have the recipes from Mealing Stone.",
			data = 0},
            {description = "Yes", 
			hover = "Warly's Portable Grinding Mill will have the recipes from Mealing Stone.",
			data = 1},
        },
        default = 0,
	},
	{
		name = "fertilizer_recipetweak",
		label = "Bucket-o-Poop Recipe Tweak",
		hover = "Should Bucket-o-Poop use the Bucket instead of the default recipe?",
		options =
		{
			{description = "No", 
			hover = "Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
			data = 0},
            {description = "Yes", 
			hover = "Bucket-o-Poop will use the Bucket on its crafting recipe.",
			data = 1},
        },
        default = 0,
	},
}