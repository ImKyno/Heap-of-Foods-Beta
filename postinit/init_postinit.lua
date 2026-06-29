local _G = GLOBAL

local INIT_POSTINIT_MISC =
{
	"sim",
	"constants",
	"modcompatibility",
	"entityscript",
	"preparedfoods",
	"preparedfoods_warly",
	"preparednonfoods",
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
	"burnable",
	"combat",
	"container",
	"debuffable",
	"desolationspawner",
	"eater",
	"edible",
	"firedetector",
	"fishingrod",
	"foodaffinity",
	"freezable",
	"growable",
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
	"bat",
	"bee",
	"beebox",
	"beefalo",
	"beequeen",
	"berrybush",
	"berrybush_juicy",
	"birdcage",
	"bullkelp_plant",
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
	"decor_flowervase",
	"deer",
	"dragonfly",
	"dryables",
	"earmuffs",
	"featherpencil",
	"firepit",
	"fishfarm",
	"foliage",
	"foodbuffs",
	"frog",
	"grass",
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
	"marsh_bush",
	"messagebottleempty",
	"monkeyqueen",
	"monkeytail",
	"monsterfoods",
	"mushroom_farm",
	"mushrooms",
	"mushroomsprout",
	"mushtrees",
	"oceanfish",
	"oceanvine",
	"parsnip",
	"perd",
	"pigking",
	"pigking_trades",
	"pigman",
	"plant_normal",
	"player",
	"player_classified",
	"player_common_extensions",
	"pond_mos",
	"pondeel",
	"pondfish",
	"potatosack",
	"prime_mate",
	"resized_items",
	"rock_avocado_bush",
	"saddle_shadow_fx",
	"saltbox",
	"sapling",
	"seafood",
	"shark",
	"sharkboi",
	"sisturn",
	"sliceables",
	"spat",
	"sporecloud",
	"sunkenchest",
	"table_decorations",
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
	"wortox_soul_common",
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