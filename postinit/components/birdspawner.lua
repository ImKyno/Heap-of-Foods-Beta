local _G            = GLOBAL
local require       = _G.require
local WORLD_TILES   = _G.WORLD_TILES
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function AddBirdsToTile(BIRD_TYPES, tile, birds)
	if tile == nil or birds == nil then
		return
	end

	local tilebirds = BIRD_TYPES[tile]

	if tilebirds == nil then
		tilebirds = {}
		BIRD_TYPES[tile] = tilebirds
	end

	for _, bird in ipairs(birds) do
		if _G.Prefabs[bird] ~= nil then
			local exists = false

			for _, existing in ipairs(tilebirds) do
				if existing == bird then
					exists = true
					break
				end
			end

			if not exists then
				table.insert(tilebirds, bird)
			end
		end
	end
end

AddClassPostConstruct("components/birdspawner", function(self)
	-- New birds will spawn when landing on these turfs.
	local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Birdspawner Component: BIRD_TYPES function:", BIRD_TYPES)
	end

	if BIRD_TYPES ~= nil then
		AddBirdsToTile(BIRD_TYPES, WORLD_TILES.QUAGMIRE_PARKFIELD, { "quagmire_pigeon"         })
		AddBirdsToTile(BIRD_TYPES, WORLD_TILES.QUAGMIRE_CITYSTONE, { "quagmire_pigeon"         })
		AddBirdsToTile(BIRD_TYPES, WORLD_TILES.MONKEY_GROUND,      { "toucan", "toucan_chubby" })

		AddBirdsToTile(BIRD_TYPES, WORLD_TILES.HOF_TIDALMARSH,     { "toucan", "toucan_chubby" })
		AddBirdsToTile(BIRD_TYPES, WORLD_TILES.HOF_FIELDS,         { "kingfisher"              })
	end
end)