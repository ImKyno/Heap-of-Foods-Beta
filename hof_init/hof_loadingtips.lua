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
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WX78",          	"\"WX-78 wants to make a dish with Gears, maybe I should help him out.\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_HUMANMEAT",     	"There's a small chance whenever a Player dies, they can drop an suspicious ingredient for cooking...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALT",          	"Salt can be used to restore the spoilage of a prepared food. Not losing that sweet dish again!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_OLDMOD",        	"The very first version of Heap Of Foods was called \"The Foods Pack\", it was discontinued due to errors, and remade into this brand new mod.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATHGRITHR",    	"Wigfrid can drink Coffee, if the option is enabled in mod configuration.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CARAMELCUBE",   	"Caramel Cube is Kyno's favorite dish.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WHEAT",         	"Wild Wheat can be grinded at the Mealing Stone to produce Flour.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FLOUR",         	"You can use Flour to make a simple Loaf of Bread. Yet, there are many other uses for Flour besides breads.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WORMWOOD",      	"\"Wormwood said he made a dish out of... and Salt. I'm not going to eat that, Mon dieu!\" -W.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGKING",       	"Pig King trades a variety of new items, in case you don't had \"Natural Spawns\" option enabled when generating the world.")

-- We want that our custom tips appears more often.
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})

-- Custom Icons for Loading Tips.
SetLoadingTipCategoryIcon("TIPS_HOF", "images/tipsimages/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex") 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------