local _G = GLOBAL

local INIT_POSTINIT_MISC =
{
	"sim",
	"constants",
	"modcompatibility",
	"preparedfoods",
	"preparedfoods_warly",
}

local INIT_POSTINIT_BRAINS =
{
	"beefalobrain",
	"deerbrain",
	"gnarwailbrain",
	"oceanfishbrain",
	"sharkbrain",
}

local INIT_POSTINIT_COMPONENTS =
{
	"ambientsound",
	"birdspawner",
	"combat",
	"container",
	"debuffable",
	"desolationspawner",
	"eater",
	"edible",
	"firedetector",
	"fishingrod",
	"foodaffinity",
	"playervision",
	"pollinator",
	"regrowthmanager",
	"schoolspawner",
	"spell",
	"stewer",
	"trap",
	"wisecracker",
}

local INIT_POSTINIT_MAP =
{
	"terrain",
}

local INIT_POSTINIT_PREFABS =
{
	"any",
	"forest",
	"cave",

	"antlion",
	"ash",
	"bananabush",
	"bee",
	"beebox",
	"beefalo",
	"beequeen",
	"berrybush_juicy",
	"birdcage",
	"catcoon",
	"characters",
	"charcoal_items",
	"chum",
	"cook_robot",
	"cookiecutter",
	"cookingrecipecard",
	"cookpot",
	"crabking",
	"crabking_mob",
	"deer",
	"dragonfly",
	"dryables",
	"earmuffs",
	"firepit",
	"fishfarm",
	"foliage",
	"foodbuffs",
	"frog",
	"grassgator",
	"greenthumb",
	"grotto_pool_big",
	"hermitcrab_teashop",
	"honeyed_items",
	"icebox",
	"itemshowcaser",
	"koalefant",
	"lightninggoat",
	"livingtree_halloween",
	"malbatross",
	"mandrake",
	"marbleshrub",
	"messagebottleempty",
	"monkeyqueen",
	"mushroom_farm",
	"mushrooms",
	"mushroomsprout",
	"mushtrees",
	"oceanfish",
	"parsnip",
	"perd",
	"pigking_trades",
	"pigman",
	"plant_normal",
	"player",
	"player_classified",
	"pond_mos",
	"pondeel",
	"pondfish",
	"potatosack",
	"prime_mate",
	"resized_items",
	"saddle_shadow_fx",
	"saltbox",
	"seafood",
	"shark",
	"sharkboi",
	"sisturn",
	"sliceables",
	"spat",
	"sporecloud",
	"sunkenchest",
	"toadstool",
	"trident",
	"trinkets",
	"trophyscale_fish",
	"tumbleweed",
	"turfs",
	"twiggytree",
	"wasphive",
	"waxed_plants",
	"weeds",
	"wobster",
	"woby_rack_swap_fx",
	"worm",
	"worm_boss_segment",
}

local INIT_POSTINIT_STATEGRAPHS =
{
	"SGbearger",
	"SGbee",
	"SGshark",
	"SGwilson",
}

local INIT_POSTINIT_WIDGETS =
{
	"cookbookpage_crockpot",
	"invslot",
	"itemtile",
}

for _, v in pairs(INIT_POSTINIT_MISC) do
	modimport("postinit/hof_"..v)
end

for _, v in pairs(INIT_POSTINIT_BRAINS) do
	modimport("postinit/brains/"..v)
end

for _, v in pairs(INIT_POSTINIT_COMPONENTS) do
	modimport("postinit/components/"..v)
end

for _, v in pairs(INIT_POSTINIT_MAP) do
	modimport("postinit/map/"..v)
end

for _, v in pairs(INIT_POSTINIT_PREFABS) do
	modimport("postinit/prefabs/"..v)
end

for _, v in pairs(INIT_POSTINIT_STATEGRAPHS) do
	modimport("postinit/stategraphs/"..v)
end

for _, v in pairs(INIT_POSTINIT_WIDGETS) do
	modimport("postinit/widgets/"..v)
end