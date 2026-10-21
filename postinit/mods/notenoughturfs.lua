local _G            = GLOBAL
local require       = _G.require
local WORLD_TILES   = _G.WORLD_TILES
local UpvalueHacker = require("tools/hof_upvaluehacker")

if TUNING.HOF_IS_NET_ENABLED then
	-- Not Enough Turfs so bird can land on their turfs too.
	AddClassPostConstruct("components/birdspawner", function(self)
		local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

		if BIRD_TYPES ~= nil then
			BIRD_TYPES[WORLD_TILES.BEACH]      = { "toucan", "toucan_chubby" }
			BIRD_TYPES[WORLD_TILES.TIDALMARSH] = { "toucan", "toucan_chubby" }
			BIRD_TYPES[WORLD_TILES.FIELDS]     = { "kingfisher" }
		end
	end)
end