-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local STRINGS		= _G.STRINGS

-- Datas.
STRINGS.SCRAPBOOK.DATA_BREWER = "CAN PREPARE DRINK"

-- Categories
STRINGS.SCRAPBOOK.SUBCATS.CHICKEN = "Chicken"
STRINGS.SCRAPBOOK.SUBCATS.PIKO = "Piko"
STRINGS.SCRAPBOOK.SUBCATS.CANNED = "Canned"
STRINGS.SCRAPBOOK.SUBCATS.COOKWARE = "Cookware"

-- Items & Foods
STRINGS.SCRAPBOOK.SPECIALINFO.FOODEFFECTS_SPEED = "Increased movement speed for a certain amount of time."
STRINGS.SCRAPBOOK.SPECIALINFO.FOODEFFECTS_COFFEE = "Increased movement speed and temperature for a certain amount of time. Hasta la vista, baby!"
STRINGS.SCRAPBOOK.SPECIALINFO.SALT = "Using a pinch of salt on a crock pot food will refresh its spoilage time by 30%. Don't worry about eating stale dishes again!"
STRINGS.SCRAPBOOK.SPECIALINFO.SALTRACK = "This rack will collect a small rock of salt every few days."
STRINGS.SCRAPBOOK.SPECIALINFO.CRABTRAP = "Once set on the ground, it will trigger when a crab move nearby, capturing them.\n\nCollecting a captured trap will put the creature inside your inventory.\n\nCrab Traps can be baited with meats."
STRINGS.SCRAPBOOK.SPECIALINFO.CARAMELCUBE = "This dish is a delicacy, a solid block of pure sweetness and love. It's a special entry for someone with sugar addiction, very popular with elderly folk."
STRINGS.SCRAPBOOK.SPECIALINFO.NECTAR = "Bees that have pollinated enough flowers will drop nectar when killed.\n\nNectar will be transformed into honey when stored the Honey Deposit."
STRINGS.SCRAPBOOK.SPECIALINFO.BOTTLESOUL = "A bottled Soul doesn't count towards the total amount inside Wortox's inventory."
STRINGS.SCRAPBOOK.SPECIALINFO.BOTTLECAP = "Durable, portable, and instantly recognizable bottle caps from the Nuka-Cola Corporation!"
STRINGS.SCRAPBOOK.SPECIALINFO.CANNEDFOOD = "A remarkable source of emergency food. It will never perish unless you open it!"
STRINGS.SCRAPBOOK.SPECIALINFO.BREWBOOK = "A record of all the beverages brewed and/or drank, as well as the ingredients used to brew them."
STRINGS.SCRAPBOOK.SPECIALINFO.BUCKET = "A bucket can be used to gather milk from animals.\n\nBe careful because some of them might get angry when you try to do it. Remember to always wear safety clothing.\n\nIt's easier to get milk from domesticated animals as they yield more units."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_HANGER_ITEM = "This hanger can be installed above Fire Pits to hold cooking pots."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_POT_ITEM = "This cooking pot requires a hanger placed above Fire Pits."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_OVEN_ITEM = "This oven can be installed on Fire Pits to place casserole dishes inside."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_CASSEROLE_ITEM = "This casserole dish requires an oven placed on Fire Pits."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_GRILL_ITEM = "This grill can be installed on Fire Pits to prepare foods."
STRINGS.SCRAPBOOK.SPECIALINFO.HUMANMEAT = "The campaign can wait, for now carnage calls.\n\nLog Ping can be harvested from the corpses of your fellow survivors."
STRINGS.SCRAPBOOK.SPECIALINFO.MUSSELSTICK_ITEM = "Can be placed in the water to catch mussels over time."
STRINGS.SCRAPBOOK.SPECIALINFO.REPAIRTOOLKIT = "Used to repair destroyed structures."
STRINGS.SCRAPBOOK.SPECIALINFO.SAPBUCKET = "Tap it to Sugarwood Trees to produce fresh Sap every few days."
STRINGS.SCRAPBOOK.SPECIALINFO.SLAUGHTERTOOL = "Butchering tools that instantly kills the animal."
STRINGS.SCRAPBOOK.SPECIALINFO.SAPHEALER = "Powerful antidote with healing capabilities for trees.\n\nUsing it on Ruined Sugarwood Trees will revert them back to their normal stage."

-- Creatures
STRINGS.SCRAPBOOK.SPECIALINFO.FEEDCHICKEN = "Can be feed with seeds to lay down an egg."
STRINGS.SCRAPBOOK.SPECIALINFO.PIKO = "Fluffy little buddies that loves to steal your most valuable items!"
STRINGS.SCRAPBOOK.SPECIALINFO.KINGFISHER = "Kingfishers will often drop Tropical Kois from above. It's raining fish, literally!"

-- Others & Point of Interest
STRINGS.SCRAPBOOK.SPECIALINFO.PIGELDER = "A Merchant from a distant archipelago. He's willing to trade his best cooking utensils and other useful items for delicious meals.\n\nThe Elder is craving for a meal with extreme sweetness or Butter mescled with seafood. He will reward you accordingly.\n\nBringing Elder's favourtie meal will unlock more trade deals."
STRINGS.SCRAPBOOK.SPECIALINFO.SAMMY = "Looks like someone is moving in to this old and abandoned house. His stuff is scattered all around.\n\nCome back in the next major update and stay tuned for news!"
STRINGS.SCRAPBOOK.SPECIALINFO.SALTPOND = "Ponds rich in salt. Salt Racks can be installed for an easy source of salt rocks every few days."
STRINGS.SCRAPBOOK.SPECIALINFO.MEALGRINDER = "Standing near this device will provide the survivor with new ingredients they can grind.\n\nYou'll need to be near the mealing stone every time you want to grind a new ingredient."
STRINGS.SCRAPBOOK.SPECIALINFO.PIKOTREE = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nThese Tea Trees are infested with little creatures known as Piko, and they are ready to cause trouble."
STRINGS.SCRAPBOOK.SPECIALINFO.ANTCHEST = "This special chest can only store honey-based items, up to 7 items simultaneously. It also gives off a healthy glow.\n\nIf honey-based foods are stored inside, the chest will refresh their spoilage time as well keep them fresh forever.\n\nNectar stored inside will eventually turn into honey."
STRINGS.SCRAPBOOK.SPECIALINFO.BREWER = "A 3 slot container that will receive ingredients for drink.\n\nPlacing 3 items in the container will allow them to be brewed creating some kind of drink depending on the items put in to begin with."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_HANGER = "Use to hold a cooking pot."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_POT = "A 4 slot container that will receive ingredients for food.\n\nPlacing 4 items in the container will allow them to be cooked creating some kind of food depending on the items put to begin with.\n\nThis cooking pot cooks faster than regular ones and also have a chance to yield multiple units of the cooked food."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_SYRUP_POT = "A 4 slot container that will receive ingredients for Syrup.\n\nPlacing 4 Sap in the container will allow them to be cooked creating Syrup.\n\nThis pot can only cook Syrup and always give an extra unit."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_OVEN = "Use to place a casserole dish inside."
STRINGS.SCRAPBOOK.SPECIALINFO.COOKWARE_CASSEROLE = "A 4 slot container that will receive ingredients for food.\n\nPlacing 4 items in the container will allow them to be cooked creating some kind of food depending on the items put to begin with.\n\nThis cooking pot cooks faster than regular ones and also have a chance to yield multiple units of the cooked food."
STRINGS.SCRAPBOOK.SPECIALINFO.KOKONUTTREE = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nBe aware of falling Coconuts!"
STRINGS.SCRAPBOOK.SPECIALINFO.MUSSELSTICK = "This stick is irresistible to mussels, leave it be for a while and it will be filled with mussels for you to collect."
STRINGS.SCRAPBOOK.SPECIALINFO.MUSHSTUMP = "This stump has a special kind of fungus growing considered by many as a delicacy.\n\nIt takes nearly 5 days for it to grow."
STRINGS.SCRAPBOOK.SPECIALINFO.SUGARTREE = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nThese trees can be tapped using a Tree Tapping Kit to produce fresh Sap every few days."
STRINGS.SCRAPBOOK.SPECIALINFO.SUGARTREE_SAPPED = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nIt takes nearly 3 days to produce Sap.\n\nDon't let the Sap overflow otherwise it will become ruined."
STRINGS.SCRAPBOOK.SPECIALINFO.SUGARTREE_RUINED = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nRuined Sugarwood Trees can't produce fresh Sap, they will produce Ruined Sap instead.\n\nYou can heal ruined trees using a Musty Antidote."
STRINGS.SCRAPBOOK.SPECIALINFO.SUGARTREE_RUINED2 = "Standing near a tree offers 35% protection from rain and cools survivor a small amount.\n\nYou can heal ruined trees using a Musty Antidote."
STRINGS.SCRAPBOOK.SPECIALINFO.RUBBLE = "Elder wants your help to repair his Old Pot so he can start making delicious Syrup again."
STRINGS.SCRAPBOOK.SPECIALINFO.PINEAPPLEBUSH = "Pineapple Bushes takes nearly 6 days to fully grow. They take longer to grow in all seasons except for Summer.\n\nDuring Summer they will start growing every 2 days."