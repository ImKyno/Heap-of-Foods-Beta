local _G = GLOBAL

local INIT_POSTINIT_MISC =
{
	"sim",
	"modcompatibility",
	"entityscript",
	"preparedfoods",
	"preparedfoods_warly",
	"preparednonfoods",
	"wx78moduledefs",
}

local INIT_POSTINIT_BRAINS =
{
	"beefalobrain",
	"deerbrain",
	"gnarwailbrain",
	"lightninggoatbrain",
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
	"health",
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

	"alterguardian_phase3dead",
	"ancienttrees",
	"antlion",
	"ash",
	"bananabush",
	"barnacle",
	"bat",
	"bee",
	"beebox",
	"beefalo",
	"beequeen",
	"berrybush",
	"berrybush_juicy",
	"birdcage",
	"birdtrap",
	"blueprint",
	"books",
	"bullkelp_plant",
	"catcoon",
	"cave_banana_tree",
	"characters",
	"charcoal_items",
	"chum",
	"cook_robot",
	"cookiecutter",
	"cookingrecipecard",
	"cookpot",
	"crabking",
	"crabking_mob",
	"deciduoustree",
	"decor_flowervase",
	"deer",
	"dragonfly",
	"driftwood_tree",
	"dryables",
	-- "dustmoth",
	"earmuffs",
	"evergreens",
	"featherhat",
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
	"klaus",
	"koalefant",
	"leif",
	"lightninggoat",
	"livingtree",
	"malbatross",
	"mandrake",
	"marbleshrub",
	"marsh_bush",
	"marsh_tree",
	"messagebottleempty",
	"monkeyqueen",
	"monkeytail",
	"monsterfoods",
	"moontree",
	"mushroom_farm",
	"mushrooms",
	"mushroomsprout",
	"mushtrees",
	"mutatedbird",
	"oceanfish",
	"oceantree",
	"oceantree_pillar",
	"oceanvine",
	"palmconetree",
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
	"stalker",
	"sunkenchest",
	"table_decorations",
	"toadstool",
	"trident",
	"trinkets",
	"trophyscale_fish",
	"tumbleweed",
	"turfs",
	"wagboss_robot",
	"wasphive",
	"watertree_root",
	"waxed_plants",
	"weeds",
	"wobster",
	"woby_rack_swap_fx",
	"worm",
	"worm_boss_segment",
	"wortox_soul_common",
	"wx78_backupbody",
	"wx78_common",
	"wx78_modules",
	"wx78_possessedbody",
	"wx78_scanner",
}

local INIT_POSTINIT_STATEGRAPHS =
{
	"SGbearger",
	"SGbee",
	"SGshark",
	"SGwilson",
	"SGwx78_possessedbody",
}

local INIT_POSTINIT_WIDGETS =
{
	"brewbookpage",
	"cookbookpage_crockpot",
	"invslot",
	"itemtile",
	"upgrademoduledisplay",
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