------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require

require("hof_brewing")
require("hof_constants")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Wooden Keg and Preserves Jar Ingredients.
AddBrewingValues({"honey"},						{sweetener=1,	honey=1})
AddBrewingValues({"honeycomb"},					{sweetener=1,	honeycomb=1})
AddBrewingValues({"pomegranate"}, 				{fruit=1,		pomegranate=1})
AddBrewingValues({"dragonfruit"}, 				{fruit=1,		dragonfruit=1})
AddBrewingValues({"cave_banana"},				{fruit=1,		cave_banana=1})
AddBrewingValues({"durian"},					{fruit=1,		durian=1})
AddBrewingValues({"watermelon"},				{fruit=1,		watermelon=1})
AddBrewingValues({"berries"},					{fruit=0.5,		berries=1})
AddBrewingValues({"berries_juicy"},				{fruit=0.5,		berries_juicy=1})
AddBrewingValues({"fig"},						{fruit=1,		fig=1})
AddBrewingValues({"carrot"},					{veggie=1,		carrot=1})
AddBrewingValues({"corn"},						{veggie=1,		corn=1})
AddBrewingValues({"eggplant"},					{veggie=1,		eggplant=1})
AddBrewingValues({"pumpkin"},					{veggie=1,		pumpkin=1})
AddBrewingValues({"foliage"},					{veggie=0.5,	foliage=1})
AddBrewingValues({"succulent_picked"},			{veggie=0.5,	succulent=1})
AddBrewingValues({"cutlichen"},					{veggie=0.5,	cutlichen=1})
AddBrewingValues({"cactus_meat"},				{veggie=1,		cactus_meat=1})
AddBrewingValues({"cactus_flower"},				{veggie=1,		cactus_flower=1})
AddBrewingValues({"garlic"},					{veggie=1,		garlic=1})
AddBrewingValues({"asparagus"},					{veggie=1,		asparagus=1})
AddBrewingValues({"onion"},						{veggie=1,		onion=1})
AddBrewingValues({"tomato"},					{veggie=1,		tomato=1})
AddBrewingValues({"potato"},					{veggie=1,		potato=1})
AddBrewingValues({"pepper"},					{veggie=1,		pepper=1})
AddBrewingValues({"red_cap"},					{veggie=0.5, 	mushroom=1})
AddBrewingValues({"green_cap"},					{veggie=0.5, 	mushroom=1})
AddBrewingValues({"blue_cap"},					{veggie=0.5, 	mushroom=1})
AddBrewingValues({"moon_cap"},					{veggie=0.5, 	mushroom=1})
AddBrewingValues({"kelp"},						{veggie=1,		kelp=1})
AddBrewingValues({"rock_avocado_fruit_ripe"},	{veggie=1,		avocado=1})
AddBrewingValues({"kyno_wheat"}, 				{veggie=1,		wheat=1})
AddBrewingValues({"kyno_spotspice_leaf"}, 		{veggie=1,		spotspice=1})
AddBrewingValues({"kyno_syrup"},				{syrup=1,		sweetener=1})
AddBrewingValues({"kyno_banana"},				{fruit=1,		banana=1})
AddBrewingValues({"kyno_kokonut_halved"},		{fruit=1,		kokonut=1})
AddBrewingValues({"kyno_kokonut_cooked"},		{fruit=1,		kokonut=1})
AddBrewingValues({"kyno_white_cap"},			{veggie=0.5,	mushroom=1})
AddBrewingValues({"kyno_foliage"},				{veggie=0.5,	foliage=1})
AddBrewingValues({"kyno_aloe"},					{veggie=1, 		aloe=1})
AddBrewingValues({"kyno_radish"},				{veggie=1, 		radish=1})
AddBrewingValues({"kyno_sweetpotato"},			{veggie=1, 		sweetpotato=1})
AddBrewingValues({"kyno_lotus_flower"},			{veggie=1, 		lotus=1})
AddBrewingValues({"kyno_seaweeds"},				{veggie=1, 		seaweeds=1})
AddBrewingValues({"kyno_taroroot"},				{veggie=1, 		taroroot=1})
AddBrewingValues({"kyno_waterycress"},			{veggie=1, 		waterycress=1})
AddBrewingValues({"kyno_cucumber"},				{veggie=1, 		cucumber=1})
AddBrewingValues({"kyno_parznip"},				{veggie=1, 		parznip=1})
AddBrewingValues({"kyno_parznip_eaten"},		{veggie=1, 		parznip=1})
AddBrewingValues({"kyno_turnip"},				{veggie=1, 		turnip=1})
AddBrewingValues({"kyno_sugartree_petals"},		{sweetener=1,	sugarflower=1})
AddBrewingValues({"tallbirdegg"},				{egg=4,			tallbirdegg=1})
AddBrewingValues({"bird_egg"},					{egg=1})
AddBrewingValues({"kyno_chicken_egg"},			{egg=1,			chicken_egg=1})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Icons For Brewbook.
local brewbook_icons = 
{
	"kyno_wheat.tex",
	"kyno_spotspice_leaf.tex",
}

for k,v in pairs(brewbook_icons) do
	RegisterInventoryItemAtlas("images/inventoryimages/hof_inventoryimages.xml", v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Import The Foods.
for k, v in pairs(require("hof_foodrecipes_brew")) do
	AddBrewerRecipe("kyno_woodenkeg", 			v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------