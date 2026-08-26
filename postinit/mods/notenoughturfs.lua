local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Not Enough Turfs so bird can land on their turfs too.
if TUNING.HOF_IS_NET_ENABLED then
	AddClassPostConstruct("components/birdspawner", function(self)
		local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

		if BIRD_TYPES ~= nil then
			BIRD_TYPES[WORLD_TILES.BEACH]      = { "toucan", "toucan_chubby" }
			BIRD_TYPES[WORLD_TILES.TIDALMARSH] = { "toucan", "toucan_chubby" }
			BIRD_TYPES[WORLD_TILES.FIELDS]     = { "kingfisher" }
		end
	end)
end