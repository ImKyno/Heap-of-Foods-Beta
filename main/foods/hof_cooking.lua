local _G               = GLOBAL
local require          = _G.require
local cooking          = require("cooking")
local CookbookData     = require("cookbookdata")
local PIG_COIN_ECONOMY = require("hof_pigcoineconomy")
local ingredients      = cooking.ingredients

require("hof_constants")
require("craftpot/ingredienttags")

-- Function to insert new values for ingredients while keeping old values.
-- Not to self: I really hate the cooking system for ingredients.
-- Source: https://forums.kleientertainment.com/forums/topic/69732-dont-use-addingredientvalues-in-mods/
local function ModifyIngredientValues(names, tags, cancook, candry, keepoldvalues)
	for _, name in pairs(names) do
		if ingredients[name] == nil then
			ingredients[name] = {tags = {}}

			if cancook then
				ingredients[name .. "_cooked"] = {tags = {}}
			end

			if candry then
				ingredients[name .. "_dried"] = {tags = {}}
			end

			for tagname, tagval in pairs(tags) do
				ingredients[name].tags[tagname] = tagval

				if cancook then
					ingredients[name .. "_cooked"].tags.precook = 1
					ingredients[name .. "_cooked"].tags[tagname] = tagval
				end

				if candry then
					ingredients[name .. "_dried"].tags.dried = 1
					ingredients[name .. "_dried"].tags[tagname] = tagval
				end
			end
		else
			for tagname, tagval in pairs(tags) do
				if ingredients[name].tags[tagname] == nil or not keepoldvalues then
					ingredients[name].tags[tagname] = tagval
				end

				if cancook then
					if ingredients[name .. "_cooked"] == nil then
						ingredients[name .. "_cooked"] = {tags = {}}
					end

					if ingredients[name .. "_cooked"].tags.precook == nil or not keepoldvalues then
						ingredients[name .. "_cooked"].tags.precook = 1
					end

					if ingredients[name .. "_cooked"].tags[tagname] == nil or not keepoldvalues then
						ingredients[name .. "_cooked"].tags[tagname] = tagval
					end
				end

				if candry then
					if ingredients[name .. "_dried"] == nil then
						ingredients[name .. "_dried"] = { tags = {} }
					end

					if ingredients[name .. "_dried"].tags.dried == nil or not keepoldvalues then
						ingredients[name .. "_dried"].tags.dried = 1
					end

					if ingredients[name .. "_dried"].tags[tagname] == nil or not keepoldvalues then
						ingredients[name .. "_dried"].tags[tagname] = tagval
					end
				end
			end
		end
	end
end

-- New Vanilla Crock Pot Ingredients.
ModifyIngredientValues({"slurtle_shellpieces"},      {shell      = 1,    elemental  = 1},                    false, false, false)
ModifyIngredientValues({"rabbit"},                   {rabbit     = 1},                                       false, false, false)
ModifyIngredientValues({"firenettles"},              {fireweed   = 1,    decoration = 1},                    false, true,  false)
ModifyIngredientValues({"tillweed"},                 {tillweed   = 1,    decoration = 1},                    false, true,  false)
ModifyIngredientValues({"forgetmelots"},             {forgetweed = 1,    decoration = 1},                    false, true,  false)
ModifyIngredientValues({"foliage"},                  {veggie     = 0.25, foliage    = 1,    decoration = 1}, false, true,  false)
ModifyIngredientValues({"succulent_picked"},         {veggie     = 0.25, foliage    = 1,    succulent  = 1}, false, true,  false)
ModifyIngredientValues({"petals"},                   {decoration = 1},                                       false, false, false)
ModifyIngredientValues({"petals_evil"},              {decoration = 1},                                       false, false, false)
ModifyIngredientValues({"moon_tree_blossom"},        {decoration = 1},                                       false, false, false)
ModifyIngredientValues({"gears"},                    {gears      = 1},                                       false, false, false)
ModifyIngredientValues({"rocks"},                    {elemental  = 1,    rock       = 1},                    false, false, false)
ModifyIngredientValues({"poop"},                     {poop       = 1},                                       false, false, false)
ModifyIngredientValues({"guano"},                    {poop       = 1},                                       false, false, false)
ModifyIngredientValues({"glommerfuel"},              {poop       = 1},                                       false, false, false)
ModifyIngredientValues({"papyrus"},                  {paper      = 1,    roughage   = 1},                    false, false, false)
ModifyIngredientValues({"deerclops_eyeball"},        {boss       = 1},                                       false, false, false)
ModifyIngredientValues({"bearger_fur"},              {boss       = 1,    inedible   = 1},                    false, false, false)
ModifyIngredientValues({"horn"},                     {horn       = 1,    inedible   = 1},                    false, false, false)
ModifyIngredientValues({"kelp"},                     {veggie     = 0.5,  algae      = 0.5},                  true,  true,  false)
ModifyIngredientValues({"milkywhites"},              {dairy      = 1,    milk       = 1},                    false, false, false)
ModifyIngredientValues({"goatmilk"},                 {dairy      = 1,    milk       = 1},                    false, false, false)
ModifyIngredientValues({"berries"},                  {fruit      = 0.5,  berries    = 1},                    true,  false, false)
ModifyIngredientValues({"berries_juicy"},            {fruit      = 0.5,  berries    = 1},                    true,  false, false)
ModifyIngredientValues({"cave_banana"},              {fruit      = 1,    banana     = 1},                    true,  false, false)
ModifyIngredientValues({"red_cap"},                  {veggie     = 0.5,  mushrooms  = 1},                    true,  false, false)
ModifyIngredientValues({"green_cap"},                {veggie     = 0.5,  mushrooms  = 1},                    true,  false, false)
ModifyIngredientValues({"blue_cap"},                 {veggie     = 0.5,  mushrooms  = 1},                    true,  false, false)
ModifyIngredientValues({"moon_cap"},                 {veggie     = 0.5,  mushrooms  = 1},                    true,  false, false)
ModifyIngredientValues({"livinglog"},                {inedible   = 1,    magic      = 1},                    false, false, false)
ModifyIngredientValues({"spider"},                   {monster    = 1,    spider     = 1},                    false, false, false)
ModifyIngredientValues({"wagpunk_bits"},             {junk       = 1},                                       false, false, false)
ModifyIngredientValues({"butter"},                   {fat        = 1,    dairy      = 1,    butter    = 1},  false, false, false)
ModifyIngredientValues({"baconeggs"},                {prepfood   = 1},                                       false, false, false)
ModifyIngredientValues({"townportaltalisman"},       {boss       = 1,    elemental  = 1,    rocks     = 1},  false, false, false)
ModifyIngredientValues({"lavae_egg"},                {boss       = 1,    lavaegg    = 1,    egg       = 2},  false, false, false)
ModifyIngredientValues({"wobster_sheller_land"},     {meat       = 1,    fish       = 1,    wobster   = 1},  false, false, false)
ModifyIngredientValues({"potato"},                   {veggie     = 1,    potato     = 1},                    true,  false, false)

-- New Mod Crock Pot Ingredients.
AddIngredientValues({"kyno_coffeebeans"},            {seeds      = 1},                                                      true)
AddIngredientValues({"kyno_shark_fin"},              {fish       = 1})
AddIngredientValues({"kyno_roe"},                    {fish       = 0.25, meat       = 0.25, roe = 1},                       true) -- Deprecated, but kept for old worlds.
AddIngredientValues({"kyno_mussel"},                 {fish       = 0.5,  mussel     = 1},                                   true)
AddIngredientValues({"kyno_beanbugs"},               {beanbug    = 1,    veggie     = 0.5},                                 true)
AddIngredientValues({"kyno_gummybug"},               {gummybug   = 1,    veggie     = 0.5},                                 true)
AddIngredientValues({"kyno_humanmeat"},              {meat       = 1,    monster    = 1},                             true, true)
AddIngredientValues({"kyno_syrup"},                  {sweetener  = 1,    syrup      = 1})
AddIngredientValues({"kyno_flour"},                  {inedible   = 1,    flour      = 1})
AddIngredientValues({"kyno_spotspice"},              {spotspice  = 1})
AddIngredientValues({"kyno_bacon"},                  {meat       = 0.5,  bacon      = 1},                                   true)
AddIngredientValues({"gorge_bread"},                 {bread      = 1})
AddIngredientValues({"kyno_white_cap"},              {veggie     = 0.5,  mushrooms  = 1},                                   true)
AddIngredientValues({"kyno_foliage"},                {veggie     = 0.25, foliage    = 1},                                   true)
AddIngredientValues({"kyno_sap"},                    {inedible   = 1,    sap        = 1})
AddIngredientValues({"kyno_aloe"},                   {veggie     = 1,    succulent  = 1},                             true, true)
AddIngredientValues({"kyno_radish"},                 {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_fennel"},                 {veggie     = 1,    foliage    = 1},                                   true)
AddIngredientValues({"kyno_sweetpotato"},            {veggie     = 1,    potato     = 1},                                   true)
AddIngredientValues({"kyno_lotus_flower"},           {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_seaweeds"},               {veggie     = 1,    algae      = 1},                             true, true)
AddIngredientValues({"kyno_limpets"},                {fish       = 0.5,  limpet     = 1},                                   true)
AddIngredientValues({"kyno_taroroot"},               {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_cucumber"},               {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_waterycress"},            {veggie     = 1,    algae      = 1})
AddIngredientValues({"kyno_salt"},                   {inedible   = 1})
AddIngredientValues({"kyno_parznip"},                {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_parznip_eaten"},          {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_turnip"},                 {veggie     = 1},                                                      true)
AddIngredientValues({"kyno_banana"},                 {fruit      = 1,    banana     = 1},                                   true)
AddIngredientValues({"kyno_kokonut_halved"},         {fruit      = 1})
AddIngredientValues({"kyno_kokonut_cooked"},         {fruit      = 1})
AddIngredientValues({"kyno_twiggynuts"},             {seeds      = 1,    fruit      = 0.5})
AddIngredientValues({"kyno_grouper"},                {fish       = 1,    meat       = 1},                                   true)
AddIngredientValues({"kyno_neonfish"},               {fish       = 1,    meat       = 1},                                   true)
AddIngredientValues({"kyno_koi"},                    {fish       = 1,    meat       = 1},                                   true)
AddIngredientValues({"kyno_tropicalfish"},           {fish       = 0.5,  meat       = 0.5},                                 true)
AddIngredientValues({"kyno_pierrotfish"},            {fish       = 0.5,  meat       = 0.5},                                 true)
AddIngredientValues({"kyno_salmonfish"},             {fish       = 1,    salmon     = 1},                                   true)
AddIngredientValues({"kyno_crabmeat"},               {meat       = 0.5,  crab       = 1},                             true, true)
AddIngredientValues({"kyno_crabkingmeat"},           {meat       = 1,    crab       = 2},                             true, true)
AddIngredientValues({"kyno_chicken2"},               {chicken    = 1}) -- No longer has meat value, I know what you did.
AddIngredientValues({"kyno_chicken_coop"},           {chicken    = 1})
AddIngredientValues({"kyno_chicken_egg"},            {egg        = 1,    chickenegg = 1},                                   true)
AddIngredientValues({"kyno_chicken_egg_large"},      {egg        = 2,    chickenegg = 2})
AddIngredientValues({"kyno_bottle_soul"},            {soul       = 1})
AddIngredientValues({"kyno_milk_beefalo"},           {dairy      = 0.5,  milk       = 1})
AddIngredientValues({"kyno_milk_koalefant"},         {dairy      = 0.5,  milk       = 1})
AddIngredientValues({"kyno_sugartree_petals"},       {sweetener  = 0.5,  sugar      = 0.5},                          false, true)
AddIngredientValues({"kyno_sugarflywings"},          {decoration = 1,    sugar      = 0.5})
AddIngredientValues({"cheese_yellow"},               {dairy      = 1,    cheese     = 1})
AddIngredientValues({"cheese_white"},                {dairy      = 1,    cheese     = 1})
AddIngredientValues({"cheese_koalefant"},            {dairy      = 1,    cheese     = 1})
AddIngredientValues({"milk_box"},                    {dairy      = 1,    milk       = 2})
AddIngredientValues({"kyno_red_cap_dried"},          {veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_green_cap_dried"},        {veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_blue_cap_dried"},         {veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_moon_cap_dried"},         {veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_plantmeat_dried"},        {meat       = 1})
AddIngredientValues({"kyno_piko"},                   {piko       = 1})
AddIngredientValues({"kyno_piko_orange"},            {piko       = 1})
AddIngredientValues({"kyno_poison_froglegs"},        {meat       = 0.5},                                                    true)
AddIngredientValues({"kyno_oil"},                    {oil        = 1})
AddIngredientValues({"chocolate_black"},             {sweetener  = 2,    chocolate  = 1})
AddIngredientValues({"chocolate_white"},             {sweetener  = 2,    chocolate  = 1})
AddIngredientValues({"littlebread"},                 {bread      = 1})
AddIngredientValues({"kyno_sugar"},                  {sweetener  = 1,    sugar      = 1})
AddIngredientValues({"kyno_wheat"},                  {seeds      = 1},                                                      true)
AddIngredientValues({"kyno_rice"},                   {veggie     = 0.5,  seeds      = 0.5},                                 true)
AddIngredientValues({"kyno_pineapple_halved"},       {fruit      = 1})
AddIngredientValues({"kyno_pineapple_cooked"},       {fruit      = 1})
AddIngredientValues({"kyno_worm_bone"},              {inedible   = 1})
AddIngredientValues({"butter_beefalo"},              {dairy      = 1,    fat       = 1,    butter    = 1})
AddIngredientValues({"butter_goat"},                 {dairy      = 1,    fat       = 1,    butter    = 1})
AddIngredientValues({"butter_koalefant"},            {dairy      = 1,    fat       = 1,    butter    = 1})
AddIngredientValues({"kyno_tealeaf"},                {leaf       = 1})
AddIngredientValues({"kyno_moon_froglegs"},          {meat       = 0.5},                                                    true)
AddIngredientValues({"kyno_truffles"},               {veggie     = 1,    mushrooms = 1},                                    true)
AddIngredientValues({"kyno_sporecap"},               {veggie     = 0.5,  mushrooms = 1,    monster   = 0.5},                true)
AddIngredientValues({"kyno_sporecap_dark"},          {veggie     = 0.5,  mushrooms = 1,    monster   = 0.5},                true)
AddIngredientValues({"truffleoil"},                  {oil        = 1})
AddIngredientValues({"kyno_jellyfish"},              {monster    = 1,    fish      = 1,    jellyfish = 1},            true, true)
AddIngredientValues({"kyno_jellyfish_dead"},         {monster    = 1,    fish      = 1,    jellyfish = 1})
AddIngredientValues({"kyno_jellyfish_rainbow"},      {monster    = 1,    fish      = 1,    jellyfish = 1},                  true)
AddIngredientValues({"kyno_jellyfish_rainbow_dead"}, {monster    = 1,    fish      = 1,    jellyfish = 1})
AddIngredientValues({"kyno_dogfish_dead"},           {meat       = 1,    fish      = 1})
AddIngredientValues({"kyno_swordfish_dead"},         {meat       = 1,    fish      = 2,    swordfish = 1})
AddIngredientValues({"kyno_swordfish_blue"},         {meat       = 1,    fish      = 2,    swordfish = 1})
AddIngredientValues({"wobster_monkeyisland_land"},   {meat       = 1,    fish      = 1,    wobster   = 1})
AddIngredientValues({"kyno_blubber"},                {meat       = 1,    fat       = 1})
AddIngredientValues({"kyno_brainrock_coral"},        {meat       = 0.5})
AddIngredientValues({"kyno_fishmeat_small_dried"},   {meat       = 0.5,  fish      = 1,    salted    = 1})
AddIngredientValues({"kyno_fishmeat_dried"},         {meat       = 1,    fish      = 2,    salted    = 1})
AddIngredientValues({"kyno_cavetuber"},              {veggie     = 1,    tuber     = 1,    monster   = 1},                  true)
AddIngredientValues({"kyno_cavetuber_blooming"},     {veggie     = 1,    tuber     = 1},                                    true)

local fishroes_meat =
{
	"kyno_roe_grouper",
	"kyno_roe_jellyfish",
	"kyno_roe_jellyfish_rainbow",
	"kyno_roe_koi",
	"kyno_roe_neonfish",
	"kyno_roe_oceanfish_medium_1",
	"kyno_roe_oceanfish_medium_2",
	"kyno_roe_oceanfish_medium_3",
	"kyno_roe_oceanfish_medium_4",
	"kyno_roe_oceanfish_medium_6",
	"kyno_roe_oceanfish_medium_7",
	"kyno_roe_oceanfish_medium_8",
	"kyno_roe_oceanfish_medium_9",
	"kyno_roe_oceanfish_midnight_carp",
	"kyno_roe_oceanfish_pufferfish",
	"kyno_roe_oceanfish_small_1",
	"kyno_roe_oceanfish_small_2",
	"kyno_roe_oceanfish_small_3",
	"kyno_roe_oceanfish_small_4",
	"kyno_roe_oceanfish_small_6",
	"kyno_roe_oceanfish_small_7",
	"kyno_roe_oceanfish_small_8",
	"kyno_roe_oceanfish_small_9",
	"kyno_roe_oceanfish_sturgeon",
	"kyno_roe_pierrotfish",
	"kyno_roe_pondeel",
	"kyno_roe_pondfish",
	"kyno_roe_salmonfish",
	"kyno_roe_swordfish_blue",
	"kyno_roe_tropicalfish",
	"kyno_roe_wobster",
	"kyno_roe_wobster_monkeyisland",
	"kyno_roe_wobster_moonglass",
}

local fishroes_veggie =
{
	"kyno_roe_oceanfish_medium_5",
	"kyno_roe_oceanfish_small_5",
}

for k, v in pairs(fishroes_meat) do
	AddIngredientValues({v}, {fish = 0.25, meat = 0.25, roe = 1})
end

for k, v in pairs(fishroes_veggie) do
	AddIngredientValues({v}, {veggie = 0.25, roe = 1})
end

local oceanfishes =
{
	oceanfish_pufferfish_inv =
	{
		meat = 0.5, fish = 0.5,
	},

	oceanfish_midnight_carp_inv =
	{
		meat = 1, fish = 1,
	},

	oceanfish_sturgeon_inv =
	{
		meat = 1, fish = 2
	},
}

for k, v in pairs(oceanfishes) do
	AddIngredientValues({k}, v, false)
end

-- Import the Foods.
local cookpots =
{
	"cookpot",
	"portablecookpot",
	"archive_cookpot",
	"kyno_cookware_syrup",
	"kyno_cookware_small",
	"kyno_cookware_big",
	"kyno_cookware_small_grill",
	"kyno_cookware_grill",
	"kyno_cookware_oven_small_casserole",
	"kyno_cookware_oven_casserole",
	"kyno_cookware_elder",
}

local cookpots_master  = {"portablecookpot"}
local cookpots_spicer  = {"portablespicer"}

local common_recipes   = require("hof_foodrecipes")
local seasonal_recipes = require("hof_foodrecipes_seasonal")
local warly_recipes    = require("hof_foodrecipes_warly")
local item_recipes     = require("hof_foodrecipes_items")
local spiced_recipes   = require("hof_spicedfoods")
local recipe_cards     = cooking.recipe_cards

for _, cooker in pairs(cookpots)         do for _, recipe in pairs(common_recipes)   do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots)         do for _, recipe in pairs(seasonal_recipes) do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots)         do for _, recipe in pairs(item_recipes)     do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots_master)  do for _, recipe in pairs(warly_recipes)    do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots_spicer)  do for _, recipe in pairs(spiced_recipes)   do AddCookerRecipe(cooker, recipe) end end

for _, recipe in pairs(common_recipes)   do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end
for _, recipe in pairs(seasonal_recipes) do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end
for _, recipe in pairs(item_recipes)     do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end
for _, recipe in pairs(warly_recipes)    do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "portablecookpot"}) end end

-- Pig King Coin Economy System.
local all_recipes =
{
	common_recipes,
	seasonal_recipes,
	warly_recipes,
	item_recipes,
	spiced_recipes,
}

for _, recipes in pairs(all_recipes) do
	PIG_COIN_ECONOMY.RegisterRecipes(recipes)
end

-- Inject Warly recipes in Chef's Specials page instead of Mod Recipes page in the Cookbook.
-- I'm not sure if this can lead to problems in the future, will leave it on for now.
local HOF_WARLYRECIPES = GetModConfigData("WARLYRECIPES")

if HOF_WARLYRECIPES then
	for k, recipe in pairs(warly_recipes) do
		cooking.cookbook_recipes["mod"][k] = nil
		cooking.cookbook_recipes["portablecookpot"][k] = recipe
		recipe.cookbook_category = "portablecookpot" -- Need this here so it can properly register the recipes.
	end
end