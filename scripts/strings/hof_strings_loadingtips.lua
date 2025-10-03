-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local TIPS_HOF      = STRINGS.UI.LOADING_SCREEN_OTHER_TIPS

-- New Loading Tips and Lore.
local LOADINGTIPS   =
{
	COFFEE          = "You can get Coffee Bushes after defeating the Dragonfly.",
	WEEDS           = "You can plant Weeds using their own products, by giving them to a bird first.",
	WALRY           = "Warly has exclusive recipes made just by him.",
	JELLYBEANS      = "\"It seems that the Lusty Jellybeans makes my body feels super good!\" -W",
	INGREDIENTS     = "There are new ingredients from the base game available to be used in the Crock Pot. Even the strangest of all...",
	WX78            = "\"WX-78 wants to make a dish with Gears. If we have some of them without use, maybe I should help him out.\" -W",
	HUMANMEAT       = "There's a small chance whenever a Player dies, they can drop a suspicious ingredient for cooking...",
	SALT            = "Salt can be used to restore the spoilage time of a prepared food. Never losing that sweet dish again!",
	OLDMOD          = "The very first version of Heap Of Foods was called The Foods Pack, it was discontinued due to errors. Later on, it was remade into this brand new mod.",
	KYNOFOOD        = "Caramel Cube and Jawsbreaker are Kyno's favourite dishes.",
	WHEAT           = "Wild Wheat can be grinded at the Mealing Stone to produce Flour.",
	FLOUR           = "You can use Flour to make a simple Loaf of Bread. Yet, there are many other uses for Flour besides breads.",
	WORMWOOD        = "\"Wormwood said he made a dish out of... and Salt. I'm not going to eat that, Mon dieu!\" -W",
	PIGKING         = "Pig King trades a variety of new items. For Example Grass Tufts for Wild Wheat Tufts, and Berry Bushes for Spotty Shurbs.",
	SERENITYISLAND  = "\"I'm certain that I saw a piece of pink-ish land in the ocean! Perhaps my compatriots will join me in a search for it...\" -W",
	PIGELDER        = "The Pig Elder trades a variety of exclusive items in exchange for foods.",
	CRABTRAP        = "\"Those rock crabs seems to avoid all of my traps! Perhaps some kind of special trap can work instead?\" -W",
	SAPTREE         = "You can Tap Sugarwood Trees using the Tree Tapping Kit, to make them produce a sweet Sap every Three days.",
	RUINEDSAPTREE   = "Careful, Tapped Sugarwood Trees that's overflowing with Sap, and not harvested can spoil. Producing Ruined Sap instead!",
	PIGELDERFOODS   = "\"I heard that strange Pig on the pink-ish island, wants some kind of food... Something to do with Caramels or Wobsters.\" -W",
	SALTPOND        = "You can fish a different kind of fish in the Salt Ponds of the Serenity Archipelago. Give it a try!",
	SALTRACK        = "The Salt Rack can be installed on the Salt Pond to produce Salt Crystals every Four days.",
	SPOTTYSHRUB     = "Spotty Shrubs can be found all across the Serenity Archipelago. And they can be brought home using a Shovel.",
	SWEETFLOWER     = "The Sweet Flower can be used in the Crock Pot as a Sweetener option.",
	LIMPETROCK      = "The only place that you will find Limpet Rocks, is the Crab Quarry of Serenity Archipelago or the beach of Seaside Island!",
	CHICKEN         = "\"I wonder if those Chickens could give me some eggs. I need some seeds to estimulate them!\" -W",
	SYRUPPOT        = "Syrup made in the Syrup Pot will give Three units instead of One unit, when that's cooked on a normal Crock Pot.",
	COOKWARE        = "Syrup Pots, Cookpots, Grills and Ovens cooks the food faster than a normal Crock Pot. And they have a small chance to yield double portions!",
	COOKWARE_PIT    = "To cook using the special Cookware stations, you need to install them above a Fire Pit first.",
	COOKWARE_FIRE   = "Special Cookware stations will only cook the food if the fire level of the Fire Pit below them is high enough.",
	COOKWARE_OLDPOT = "The Pig Elder may need your assist to repair his Old Pot.",
	SPEED_DURATION  = "You can change how long the Speed Buff from foods will last in the Mod Configuration.",
	WATERY_CRATE    = "\"Yesterday when I was sailing, I saw a strange crate drifting in the ocean, I should check them out, if I find one again.\" -W",
	SERENITYCRATE   = "Watery Crates fished on the Serenity Archipelago will re-appear on the same location after Seven days.",
	WATERY_CRATE2   = "Watery Crates will always yield a Seaweed and extra loots. Keep destroying them to see what you can find!",
	TUNACAN         = "The \"Ballphin Free\" Tuna will never spoil, unless you open it.",
	CANNED_SOURCE   = "You can get Canned Foods and Drinks from Watery Crates and Sunken Chests. Happy treasure hunting!",
	CRABKING_LOOT   = "Out of Crab Meat? Crab King can be a reliable source for it.",
	REGROWTH        = "Mod entities such as Plants, Trees, etc. Will regrow overtime if there are a low amount of them in the world.",
	BOTTLE_SOUL     = "Wortox can store Souls inside Empty Bottles for later meals...",
	BOTTLE_SOUL2    = "Every survivor can carry the Soul in a Bottle on their inventory, but only Wortox can Release the Soul.",
	SOULSTEW        = "If Wortox eats the Soul Stew he will gain the full stats from the food instead of the half, like he does with every other food.",
	MYSTERYMEAT     = "\"Have you heard? There's something strange inside one of the Watery Crates. We should look for it, perhaps...\" -W",
	KEGANDJAR       = "The Wooden Keg and the Preserves Jar can be used to produce special recipes. They take longer to produce than other recipes.",
	ANTIDOTE        = "Your Sugarwood Trees got ruined? Don't worry, they can be healed! You just need to use the Musty Antidote on them and voilà!",
	MILKABLEANIMALS = "Some animals such as Beefalos and Koalefants can be milked using a Bucket. But be careful to not get kick!",
	FORTUNECOOKIE   = "\"Do you really believe that stupid cookies tells your luck? Huh? W-what about me?! I-I don't believe in them, I swear!\" -W",
	PINEAPPLEBUSH   = "Pineapples Bushes take longer to grow in all seasons except for Summer.",
	BREWBOOK        = "Recipes made in the Wooden Keg or Preserves Jar will not appear in the Cookbook. Instead you can view them at the Brewbook!",
	PIKOS           = "Be aware of Pikos! These little creatures enjoy stealing food from easy preys.",
	TIDALPOOL       = "The Tidal Pool has an array of fishes that can be fished throughout the Seasons! Make sure to bring your Freshwater Fishing Rod!",
	GROUPER         = "Purple Groupers can be fished on the ponds found in the Swamps.",
	MEADOWISLAND    = "\"Sailing around the globe, I was capable of exploring almost everything... Except for a strange island full of Palm Trees.\" -W",
	INFESTTREE      = "Tea Trees can be infested with Pikos. Increasing your sources of getting those little guys!",
	COOKWAREBONUS   = "Special Cookware stations have a small chance of giving an extra food when cooking. Cross your fingers and hope that sweet meal comes in double!",
	POISONBUNWICH   = "The Noxious Froggle Bunwich can be quite difficult to cook, but it has an interesting quirk: frogs will be passive towards you for a whole day!",
	TWISTEDTEQUILE  = "\"Last night in the party, when I drank that drink, I think it's called Tequila, right? That thing made me so dizzy that in the next day, I found myself in another place!\" -W",
	WATERCUP        = "Want to get rid of your debuffs? Drink a Cup of Water and stay hydrated!",
	NUKACOLA        = "\"See that bottle of... \"Nuka-Cola\ that's the name, right? I think Wortox brought that thing from another dimension, in one of his travels.\" -W",
	NUKACOLA2       = "The unique taste of Nuka-Cola is the result of a combination of seventeen fruit essences, balanced to enhance the classic cola flavor. Zap that thirst!",
	SUGARBOMBS      = "A pack of sugary cereal that holds 100% of the recommended daily amount of sugar, Sugar Bombs have been preserved for 25 years after the Great War. However, this also caused a bit of radiation to slip in for most of them.",
	LUNARSOUP       = "\"I fear nothing when that Lunar Soup goes down in my belly!\" -W",
	SPRINKLER       = "Tired of manually watering your crops? Build yourself a Garden Sprinkler today and say goodbye to manual labor!",
	NUKASHINE       = "Lewis originally created Nukashine so he could afford a warehouse for his Nuka-Cola collection, but its popularity meant that chapter president Judy Lowell and members of the wider Eta Psi fraternity became involved.",
	ITEMSLICER      = "Meat Chunks and some hard fruits can be sliced using a Cleaver.",
	ITEMSLICER_GOLD = "The Grand Cleaver has unlimited uses and can slice items quicker than a regular Cleaver.",
	SAMMY1          = "Sammy can be found on the Seaside Island selling an array of rare items and ingredients that you can't find so easily out there.",
	SAMMY2          = "Sammy's wares changes throughout the seasons and during special world occasions. Make sure to check his inventory every now and then to see what he has to offer.",
	JAWSBREAKER     = "Jawsbreaker can be used to lure Rockjaws and Gnarwails, killing them instantly. But don't use it too close to yourself.",
	METALBUCKET     = "What's better than a Bucket? A sturdy metal bucket that will not break when milking animals!",
	LUNARTEQUILA    = "Feeling a bit on your moon side? Why not drink an Enlightened Tequila to open your mind to the truth?",
	MIMICMONSA      = "If you want to sneak past dangerous foes, brew a Sneakmosa and no one and nothing will ever notice you!",
	RUMMAGEWAGON    = "\"I saw Sammy the other day rummaging his Wagon in search of something. I think he was trading with someone. Perhaps I should check what he stores in there...\" -W",
	RUMMAGEWAGON2   = "\"Its not robbery, I swear! Sammy's throwing away a bunch of useful junk we could use instead! Just look everything I got from his Wagon!\" -W.",
	SLAUGHTERHEAT   = "Beware! Some animals will attack if you slaughter one of their kind when more is around.",
	SLAUGHTERFLEE   = "Some animals can be scared away when they see you slaughtering one of their kind with the Slaughter Tools.",
}

for k, v in pairs(LOADINGTIPS) do
	AddLoadingTip(TIPS_HOF, "TIPS_HOF_"..k, v)
end

SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")

SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})