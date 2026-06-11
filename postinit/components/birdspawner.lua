local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- New birds will spawn when landing on these turfs.
AddClassPostConstruct("components/birdspawner", function(self)
	local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

	BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD] = { "quagmire_pigeon" }
	BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE] = { "quagmire_pigeon" }

	BIRD_TYPES[WORLD_TILES.MONKEY_GROUND]      = { "toucan", "toucan_chubby" }
	BIRD_TYPES[WORLD_TILES.HOF_TIDALMARSH]     = { "toucan", "toucan_chubby" }
	BIRD_TYPES[WORLD_TILES.HOF_FIELDS]         = { "kingfisher" }
end)