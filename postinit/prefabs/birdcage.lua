local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Invalid Birdcage foods.
local function BirdcagePostInit(inst)
	local invalid_foods = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "ShouldAcceptItem", "invalid_foods")
	table.insert(invalid_foods, "kyno_chicken_egg")
	table.insert(invalid_foods, "kyno_chicken_egg_cooked")
end

AddPrefabPostInit("birdcage", BirdcagePostInit)