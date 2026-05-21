local _G = GLOBAL

local INIT_MAIN_MISC =
{
	"tuning",
	"assets",
	"prefabs",
	"skins",
	"recipes",
	"recipes_hofbirthday",
	"recipes_serenity",
	"recipes_meadow",
	"popups",
	"actions",
	"stategraphs",
	"containers",
}

local INIT_MAIN_WORLD =
{
	-- "worldtiledefs",
	-- "worldtilenoise",
	-- "static_layouts",
	-- "storygen",
	-- "worldgen",
	-- "worldsettings",
	"messagebottletreasures",
	"data_oceanfish",
	"data_tree_rock",
}

local INIT_MAIN_FOOD =
{
	"farming",
	"cooking",
	"brewing",
}

for _, v in pairs(INIT_MAIN_MISC) do
	modimport("main/misc/hof_"..v)
end

for _, v in pairs(INIT_MAIN_WORLD) do
	modimport("main/map/hof_"..v)
end

for _, v in pairs(INIT_MAIN_FOOD) do
	modimport("main/foods/hof_"..v)
end

if TUNING.HOF_SCRAPBOOK then
	modimport("main/misc/hof_scrapbook")
end

if TUNING.HOF_SCRAPBOOK and TUNING.HOF_SCRAPBOOK_EXTRAS then
	modimport("main/misc/hof_scrapbook_extras")
end

if TUNING.HOF_AUTORETROFIT then
	modimport("main/misc/hof_retrofit")
end