-- Keys and Locks for generating biomes together.
require("map/lockandkey")

local function AddKeyLock(name)
	table.insert(KEYS_ARRAY, name)
	KEYS[name] = #KEYS_ARRAY

	table.insert(LOCKS_ARRAY, name)
	LOCKS[name] = #KEYS_ARRAY
	LOCKS_KEYS[LOCKS[name]] = {KEYS[name]}
end

AddKeyLock("SUNKENFOREST")