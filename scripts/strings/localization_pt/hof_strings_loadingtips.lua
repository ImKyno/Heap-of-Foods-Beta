-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS

-- New Loading Tips and Lore.
local TIPS_LORE 	= LOADING_SCREEN_LORE_TIPS
local TIPS_SURVIVAL = LOADING_SCREEN_SURVIVAL_TIPS
local TIPS_HOF 		= STRINGS.UI.LOADING_SCREEN_OTHER_TIPS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local HOF_CATEGORY 	= _G.LOADING_SCREEN_TIP_CATEGORIES

-- Our Tips.
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE", 			"Você pode conseguir Plantas de Café ao Derrotar a Libélula.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WEEDS",  			"Você pode Plantar Ervas Daninhas usando seus próprios produtos, dando elas para um passáro antes.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WALRY",  			"Warly has exclusive recipes made just by him.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_JELLYBEANS",      "\"It seems that the Lusty Jellybeans makes my body feels super good!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INGREDIENTS",   	"There are new ingredients from the base game available to be used in the Crock Pot. Even the strangest of all...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WX78",          	"\"WX-78 wants to make a dish with Gears. If we have some of them without use, maybe I should help him out.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_HUMANMEAT",     	"There's a small chance whenever a Player dies, they can drop a suspicious ingredient for cooking...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALT",          	"Salt can be used to restore the spoilage time of a prepared food. Never losing that sweet dish again!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_OLDMOD",        	"The very first version of Heap Of Foods was called The Foods Pack, it was discontinued due to errors. Later on, it was remade into this brand new mod.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CARAMELCUBE",   	"Caramel Cube is Kyno's favourite dish.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WHEAT",         	"Wild Wheat can be grinded at the Mealing Stone to produce Flour.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FLOUR",         	"You can use Flour to make a simple Loaf of Bread. Yet, there are many other uses for Flour besides breads.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WORMWOOD",      	"\"Wormwood said he made a dish out of... and Salt. I'm not going to eat that, Mon dieu!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGKING",       	"Pig King trades a variety of new items. For Example Grass Tufts for Wild Wheat Tufts, and Berry Bushes for Spotty Shurbs.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYISLAND",	"\"I'm certain that I saw a piece of pink-ish land in the ocean! Perhaps my compatriots will join me in a search for it...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDER", 		"The Pig Elder trades a variety of exclusive items in exchange for foods.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABTRAP", 		"\"Those rock crabs seems to avoid all of my traps! Maybe some kind of special trap can work, instead?\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAPTREE",			"You can Tap Sugarwood Trees using the Tree Tapping Kit, to make them produce a sweet Sap every Three days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_RUINEDSAPTREE",	"Careful, Tapped Sugarwood Trees that's overflowing with Sap, and not harvested can spoil. Producing Ruined Sap instead!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDERFOODS",	"\"I heard that strange Pig on the pink-ish island, wants some kind of food... Something to do with Caramels or Wobsters.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTPOND",		"You can fish a different kind of fish in the Salt Ponds of the Serenity Archipelago. Give it a try!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTRACK", 		"The Salt Rack can be installed on the Salt Pond, to produce Salt Crystals every Four days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPOTTYSHRUB",		"Spotty Shrubs can be found all across the Serenity Archipelago. And they can be brought home using a Shovel.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SWEETFLOWER",		"The Sweet Flower can be used in the Crock Pot as a Sweetener option.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LIMPETROCK", 		"The only place that you will find the Limpet Rocks, is the Crab Quarry of the Serenity Archipelago!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CHICKEN",			"\"I wonder if those Chickens could give me some eggs. I need some seeds to estimulate them!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SYRUPPOT", 		"Syrup made in the Syrup Pot will give Three units instead of One unit, when that's cooked on a normal Crock Pot.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE",		"Syrup Pots, Cookpots, Grills and Ovens cooks the food faster than a normal Crock Pot. And they have a small chance to yield double portions!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_PIT", 	"To cook using the special Cookware stations, you need to install them above a Fire Pit first.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_FIRE",	"Special Cookware stations will only cook the food if the fire level of the Fire Pit below them is high enough.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_OLDPOT", "The Pig Elder may need your assist to repair his Old Pot.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPEED_DURATION",  "You can change how long the Speed Buff from foods will last in the Mod Configuration.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE",	"\"Yesterday when I was sailing, I saw a strange crate drifting in the ocean, I should check them out, if I find one again.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYCRATE",	"Watery Crates fished on the Serenity Archipelago will re-appear on the same location after Seven days.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE2",	"Watery Crates will always yield a Seaweed and extra loots. Keep destroying them to see what you can find!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN",			"The \"Ballphin Free\" Tuna will never spoil, unless you open it.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CANNED_SOURCE",	"You can get Canned Foods and Drinks from Watery Crates and Sunken Chests. Happy treasure hunting!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN_HERMIT",	"The Crabby Hermit might have a special reward, if you complete her tasks.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABKING_LOOT",	"Out of Crab Meat? Crab King can be a reliable source for it.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_REGROWTH",		"Mod entities such as Plants, Trees, etc. Will regrow overtime if there are a low amount of them in the world.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL",		"Wortox can store Souls inside Empty Bottles for later meals...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL2",	"Every survivor can carry the Soul in a Bottle on their inventory, but only Wortox can Release the Soul.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SOULSTEW",		"If Wortox eats the Soul Stew he will gain the full stats from the food instead of the half, like he does with every other food.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MYSTERYMEAT",		"\"Have you heard? There's something strange inside one of the Watery Crates. We should look for it, perhaps...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_KEGANDJAR",       "The Wooden Keg and the Preserves Jar can be used to produce special recipes. They take longer to produce than other recipes.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ANTIDOTE",        "Your Sugarwood Trees got ruined? Don't worry, they can be healed! You just need to use the Musty Antidote on them and voilà!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MILKABLEANIMALS", "Some animals such as Beefalos and Koalefants can be milked using the Bucket. Be careful, though!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FORTUNECOOKIE",   "\"Do you really believe that stupid cookies tells your luck? Huh? W-what about me?! I-I don't believe in them, I swear!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PINEAPPLEBUSH",   "Pineapples Bushes take longer to grow in all seasons except for Summer.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BREWBOOK",        "Recipes made in the Wooden Keg or Preserves Jar will not appear in the Cookbook. Instead you can view them at the Brewbook!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIKOS",           "Be aware of Pikos! These little creatures enjoy stealing food from easy preys.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TIDALPOOL",       "The Tidal Pool has an array of fishes that can be fished throughout the Seasons! Make sure to bring your Freshwater Fishing Rod!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_GROUPER",         "Purple Groupers can be fished on the ponds found in the Swamps.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MEADOWISLAND",    "\"Sailing around the globe, I was capable of exploring almost everything... Except for a strange island full of Palm Trees.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INFESTTREE",      "Tea Trees can be infested with Pikos. Increasing your sources of getting those little guys!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWAREBONUS",   "Special Cookware stations have a small chance of giving an extra food when cooking. Cross your fingers and hope that sweet meal comes in double trouble!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_POISONBUNWICH",   "The Noxious Froggle Bunwich can be quite difficult to cook, but it has an interesting quirk: frogs will be pacific towards you for a whole day!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TWISTEDTEQUILE",  "\"Last night in the party, when I drank that drink, I think it's called Tequila, right? That thing made me so dizzy that in the next day, I found myself in another place!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERCUP",        "Want to get rid of your debuffs? Drink a Cup of Water and stay hydrated!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA",        "\"See that bottle of... \"Nuka-Cola\", that's the name, right? I think Wortox brought that thing from another dimension, in one of his travels.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA2",       "The unique taste of Nuka-Cola is the result of a combination of seventeen fruit essences, balanced to enhance the classic cola flavor. Zap that thirst!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SUGARBOMBS",      "A pack of sugary cereal that holds 100% of the recommended daily amount of sugar, Sugar Bombs have been preserved for 25 years after the Great War. However, this also caused a bit of radiation to slip in for most of them.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LUNARSOUP",       "\"I fear nothing when that Lunar Soup goes down in my belly!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPRINKLER",       "Tired of manually watering your crops? Build yourself a Garden Sprinkler today and say goodbye to manual labor!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKASHINE",       "Lewis originally created Nukashine so he could afford a warehouse for his Nuka-Cola collection, but its popularity meant that chapter president Judy Lowell and members of the wider Eta Psi fraternity became involved.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ITEMSLICER",      "Meat Chunks and some hard fruits can be sliced using a Cleaver.")

-- We want that our custom tips appears more often.
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})

-- Custom Icons for Loading Tips.
SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")