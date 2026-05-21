local _G      = GLOBAL
local require = _G.require

-- Mod Strings and Localizations.
-- If you want to contribute with your localization please head to "scripts/strings/HOF_LANGUAGE.lua" for more information.
modimport("scripts/strings/hof_strings_loadingtips")

local INIT_STRINGS = 
{
	"strings",
	"strings_scrapbook",
	"strings_skinprefabs",
}

local INIT_STRINGS_CHARACTERS =
{
	"wilson",
	"willow",
	"wolfgang",
	"wendy",
	"wx78",
	"wickerbottom",
	"woodie",
	"waxwell",
	"wathgrithr",
	"webber",
	"winona",
	"wortox",
	"wormwood",
	"warly",
	"wurt",
	"walter",
	"wanda",
}

for _, v in pairs(INIT_STRINGS) do
	require("strings/hof_"..v)
end

for _, v in pairs(INIT_STRINGS_CHARACTERS) do
	require("strings/characters/hof_speech_"..v)
end

local HOF_LANGUAGE = GetModConfigData("LANGUAGE")

if HOF_LANGUAGE then
	modimport("scripts/strings/localization_"..HOF_LANGUAGE.."/hof_strings_loadingtips")

	for _, v in pairs(HOF_INIT_STRINGS) do
		require("strings/localization_"..HOF_LANGUAGE.."/"..v)
	end
	
	for _, v in pairs(HOF_INIT_STRINGS_CHARACTERS) do
		require("strings/localization_"..HOF_LANGUAGE.."/characters/"..v)
	end
end

modimport("main/init_main")

-- Not to be confused with the above, this is game env instead of mod env.
-- NEEDS TO BE LOADED AFTER STRINGS AND MAIN IMPORTS.
require("hof_main")

modimport("postinit/init_postinit")

-- This belongs to the Accomplishments Mod.
-- modimport("achievementsmain")

-- Testing Mod Options.
if TUNING.HOF_DEBUG_MODE then
	local mod_options = 
	{
		{ name = "LANGUAGE",         default = false },

		{ name = "SEASONALFOOD",     default = false },
		{ name = "HUMANMEAT",        default = true  },
		{ name = "GIANTSPAWNING",    default = true  },
		{ name = "ALCOHOLICDRINKS",  default = true  },
		{ name = "ICEBOXSTACKSIZE",  default = false },
		{ name = "COFFEESPEED",      default = true  },
		{ name = "COFFEEDURATION",   default = 480   },
		{ name = "COFFEEDROPRATE",   default = 4     },

		{ name = "SCRAPBOOK",        default = true  },
		{ name = "WARLYRECIPES",     default = true  },
		{ name = "WARLYSPICES",      default = false },
		{ name = "WARLYMEALGRINDER", default = false },
		{ name = "KEEPFOOD",         default = false },
		{ name = "FERTILIZERTWEAK",  default = false },

		{ name = "SCRAPBOOK2",       default = false },
		{ name = "SERENITY_CC",      default = false },
		{ name = "MEADOW_CC",        default = false },
		{ name = "FULLMOONTRANS",    default = false },

		{ name = "RETROCOMPAT",      default = false },
		{ name = "MODTRADES",        default = false },
	}

	for _, option in ipairs(mod_options) do
		local value = GetModConfigData(option.name)
		print(string.format("Heap of Foods Mod - Config: %s = %s", option.name, tostring(value)))
	end
end	