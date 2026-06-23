--[[-------------------------------------------------------------------------------------------------------------------------------------------------

	[ Seeds Sack Public Mod API ]
	[ This file is meant to be required by other Mods ]

	* To add a custom seed icon to the Seeds Sack, register it through the API:
	Let's say you want to add your custom Strawberry Seeds...

	* In your modmain.lua:
	GLOBAL.SeedsBagAddSeedImage("strawberry_seeds", "strawberry")

	* Then add an inventory image asset named: "seedsbag_strawberry_seeds"
	* The Seeds Sack will automatically use: "seedsbag_strawberry_seeds.tex"

	* If a seed is not registered, then it will be displayed
	as the fallback icon "seedsbag_unknown_seeds.tex" (Regular Seeds).

	* And that's it, simple as that now the Seeds Sack should show your custom seeds icon!

	[ Final Considerations ]

	If you run into a problem, have any inquiries or just need help, please join our Discord and head to the dedicated channel
	exclusive to talk about the mod #hof-general. Otherwise you can also send me a private message on Discord, it
	might take a while for me to reply you, but I'll do as soon as I can.

	Discord Server Invite: https://discord.gg/jjNr4Vvutn
	My Discord: kynoox_

	Happy farming!

--]]-------------------------------------------------------------------------------------------------------------------------------------------------

global("HOF_SEEDSBAG_SEEDS")
HOF_SEEDSBAG_SEEDS =
{
	-- Vanilla Seeds.
	"asparagus_seeds",
	"carrot_seeds",
	"corn_seeds",
	"durian_seeds",
	"eggplant_seeds",
	"garlic_seeds",
	"onion_seeds",
	"pepper_seeds",
	"pomegranate_seeds",
	"potato_seeds",
	"pumpkin_seeds",
	"tomato_seeds",
	"dragonfruit_seeds",
	"watermelon_seeds",

	-- Our Seeds.
	"aloe_seeds",
	"cucumber_seeds",
	"fennel_seeds",
	"firenettles_seeds",
	"forgetmelots_seeds",
	"icenettles_seeds",
	"parznip_seeds",
	"radish_seeds",
	"rice_seeds",
	"sweetpotato_seeds",
	"tillweed_seeds",
	"turnip_seeds",
}

local HOF_SEEDSBAG_IMAGES = {}

local function GetSeedKey(prefab)
	if prefab == nil or prefab == "" then
		return nil
	end

	prefab = string.lower(prefab)
	prefab = string.gsub(prefab, "^kyno_", "")
	prefab = string.gsub(prefab, "_seeds$", "")

	return prefab
end

global("SeedsBagAddSeedImage")
function SeedsBagAddSeedImage(seedprefab, overlaykey)
	local key = GetSeedKey(seedprefab)

	if key ~= nil then
		HOF_SEEDSBAG_IMAGES[key] = overlaykey or key
	end
end

global("SeedsBagGetSeedImageKey")
function SeedsBagGetSeedImageKey(seedprefab)
	local key = GetSeedKey(seedprefab)
	return key ~= nil and HOF_SEEDSBAG_IMAGES[key] or nil
end

-- Add our own seeds as default.
for _, seed in ipairs(HOF_SEEDSBAG_SEEDS) do
	SeedsBagAddSeedImage(seed)
end