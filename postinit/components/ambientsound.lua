local _G            = GLOBAL
local require       = _G.require
local WORLD_TILES   = _G.WORLD_TILES
local UpvalueHacker = require("tools/hof_upvaluehacker")

local AMBIENT_TILES =
{
	[WORLD_TILES.QUAGMIRE_CITYSTONE] =
	{
		sound       = "dontstarve/AMB/quagmire/city_stone",
		wintersound = "dontstarve/AMB/quagmire/city_stone",
		springsound = "dontstarve/AMB/quagmire/city_stone",
		summersound = "dontstarve/AMB/quagmire/city_stone",
		rainsound   = "dontstarve/AMB/rocky_rain",
	},

	[WORLD_TILES.QUAGMIRE_PARKFIELD] =
	{
		sound       = "dontstarve/AMB/quagmire/park_field",
		wintersound = "dontstarve/AMB/quagmire/park_field",
		springsound = "dontstarve/AMB/quagmire/park_field",
		summersound = "dontstarve/AMB/quagmire/park_field",
		rainsound   = "dontstarve/AMB/meadow_rain",
	},

	[WORLD_TILES.HOF_FIELDS] =
	{
		sound       = "dontstarve/AMB/meadow",
		wintersound = "dontstarve/AMB/meadow_winter",
		springsound = "dontstarve/AMB/meadow",
		summersound = "dontstarve_DLC001/AMB/meadow_summer",
		rainsound   = "dontstarve/AMB/meadow_rain"
	},

	[WORLD_TILES.HOF_TIDALMARSH] =
	{
		sound       = "dontstarve/AMB/marsh",
		wintersound = "dontstarve/AMB/marsh_winter",
		springsound = "dontstarve/AMB/marsh",
		summersound = "dontstarve_DLC001/AMB/marsh_summer",
		rainsound   = "dontstarve/AMB/marsh_rain"
	},
}

-- This runs in client-side only.
AddClassPostConstruct("components/ambientsound", function(self)
	local AMBIENT_SOUNDS = UpvalueHacker.GetUpvalue(self.OnUpdate, "AMBIENT_SOUNDS")

	if AMBIENT_SOUNDS == nil then
		return
	end

	for tile, data in pairs(AMBIENT_TILES) do
		if tile ~= nil then
			if AMBIENT_SOUNDS[tile] == nil then
				AMBIENT_SOUNDS[tile] = data
			else
				for k, v in pairs(data) do
					AMBIENT_SOUNDS[tile][k] = v
				end
			end
		end
	end
end)