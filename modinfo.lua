name = "Heap of Foods"
version = "3.4-A"
local myupdate = "Salty & Sweet Travels"

description = "󰀄 Adds 117 brand new Crock Pot dishes alongside new ingredients to use!\n\n󰀦 Also features a brand new Biome somewhere in the Ocean!\n\n󰀌 Mod Version: "..version.."\n\󰀧 Update: "..myupdate..""
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
		name = "xmas_foods",
		label = "Festive Foods",
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
}