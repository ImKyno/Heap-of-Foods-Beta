------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local STRINGS       = _G.STRINGS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Loading Tips and Lore.
local TIPS_LORE 	= LOADING_SCREEN_LORE_TIPS
local TIPS_SURVIVAL = LOADING_SCREEN_SURVIVAL_TIPS
local TIPS_HOF 		= STRINGS.UI.LOADING_SCREEN_OTHER_TIPS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local HOF_CATEGORY 	= _G.LOADING_SCREEN_TIP_CATEGORIES 

-- Our Tips.
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE", 			"You can get Coffee Bushes from the Dragonfly.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WEEDS",  			"You can plant Weeds using their own products, by giving them to a bird first.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WALRY",  			"Warly has exclusive recipes made just by him. Make sure to check it out.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_JELLYBEANS",  	"\"It seems that the Lusty Jellybeans makes my body feels super good!\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MONKEY",  		"\"I saw a Splumonkey carrying a \"Normal\" Banana yesterday, maybe I can get it from them...\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INGREDIENTS",   	"There are new ingredients from the base game available to be used in the Crock Pot.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WX78",          	"\"WX-78 wants to make a dish with Gears. If we have some of them without use, maybe I should help him out.\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_HUMANMEAT",     	"There's a small chance whenever a Player dies, they can drop an suspicious ingredient for cooking...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALT",          	"Salt can be used to restore the spoilage of a prepared food. Not losing that sweet dish again!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_OLDMOD",        	"The very first version of Heap Of Foods was called \"The Foods Pack\", it was discontinued due to errors, and remade into this brand new mod.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATHGRITHR",    	"Wigfrid can drink Coffee, if the option is enabled in mod configuration.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CARAMELCUBE",   	"Caramel Cube is Kyno's favorite dish.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WHEAT",         	"Wild Wheat can be grinded at the Mealing Stone to produce Flour.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FLOUR",         	"You can use Flour to make a simple Loaf of Bread. Yet, there are many other uses for Flour besides breads.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WORMWOOD",      	"\"Wormwood said he made a dish out of... and Salt. I'm not going to eat that, Mon dieu!\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGKING",       	"Pig King trades a variety of new items. For Example: Grass Tufts for Wild Wheat Tufts.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYISLAND",	"\"I'm certain that I saw a piece of pink-ish land in the ocean! Perhaps my compatriots will join me in a search for it...\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDER", 		"The Pig Elder trades a variety of exclusive items in exchange for foods.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABTRAP", 		"\"Those rock crabs seems to avoid all of my traps! Maybe some kind of special trap can work instead?\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAPTREE",			"You can Tap Sugarwood Trees using the Tree Tapping Kit, to make them produce a sweet Sap every Three days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_RUINEDSAPTREE",	"Careful, Tapped Sugarwood Trees that's overflowing with Sap, and not harvested can spoil. Producing Ruined Sap instead!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDERFOODS",	"\"I heard that strange Pig on the pink-ish island, wants some kind of food... Something to do with Caramels or Wobsters.\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTPOND",		"You can fish a different kind of fish in the Salt Ponds of the Serenity Archipelago.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTRACK", 		"The Salt Rack can be installed on the Salt Pond, to produce Salt Crystals every Four days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPOTTYSHRUB",		"Spotty Shrubs can be found all across the Serenity Archipelago. And they can be brought home using a Shovel.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SWEETFLOWER",		"The Sweet Flower can be used in the Crock Pot as a Sweetener option.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LIMPETROCK", 		"The only place that you will find the Limpet Rocks, is the Crab Quarry of the Serenity Archipelago!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CHICKEN",			"\"I wonder if those Chickens can give me some eggs. I need to wait a couple days and see what happens!\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SYRUPPOT", 		"Syrup made in the Syrup Pot will give Three units instead of One unit, when that's cooked on a normal Crock Pot.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE",		"Syrup Pots, Cookpots, Grills and Ovens cooks the food faster than a normal Crock Pot!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_PIT", 	"To cook using the special Cookware stations, you need to install them above a Fire Pit first.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_FIRE",	"Special Cookware stations will only cook the food, if the fire level of the Fire Pit below them is high enough.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_OLDPOT", "The Pig Elder may need your assist to repair his Old Pot.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPEED_DURATION",  "You can change how long the Speed Buff from foods will last in the Mod Configuration.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE",	"\"Yesterday when I was sailing, I saw a strange crate drifting in the ocean, I should check them out, if I find one again.\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYCRATE",	"Watery Crates fished on the Serenity Archipelago will re-appear on the same location after Seven days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE2",	"Watery Crates always yield a Seaweed and extra loots. Keep destroying them to see what you can find!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN",			"The \"Ballphin Free\" Tuna will never spoil, unless you open it.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CANNED_SOURCE",	"You can get Canned Foods and Drinks from Watery Crates and Sunken Chests!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN_HERMIT",	"The Hermit Crabby might have a special reward, if you complete her tasks.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABKING_LOOT",	"Need more Crab Meat? The Crab King drops Seven of them, when killed. The hunt season is open!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_REGROWTH",		"Mod entities such as: Plants, Trees, etc. Will regrow overtime if there are a low amount of them in the world.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL",		"Wortox can store Souls inside Empty Bottles. However, other survivors can't.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL2",	"Every survivors can carry the \"Soul in a Bottle\" on their inventory, but only Wortox can Release the Soul.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SOULSTEW",		"If Wortox eats the \"Soul Stew\" he will get the full stats from the food, instead of the half, like every other foods.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MYSTERYMEAT",		"\"Have you heard? There's something strange inside one of the Watery Crates. We should look for it, perhaps...\" -W.")

-- We want that our custom tips appears more often.
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})

-- Custom Icons for Loading Tips.
-- SetLoadingTipCategoryIcon("OTHER", "images/tipsimages/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex") 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------