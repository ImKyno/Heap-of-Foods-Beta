local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local UpvalueHacker = require("tools/hof_upvaluehacker")

require("behaviours/runaway")

-- Be able to eat invisible baits inside Oceanic Trap.
local OceanFishBrain = require("brains/oceanfishbrain")
local OCEANFISH_SEE_FOOD_DIST = 4
local OCEANFISH_FINDFOOD_CANT_TAGS = { "planted", "INLIMBO", "outofreach" }
local OCEANFISH_FINDFOOD_ONEOF_TAGS = { "fishinghook", "oceantrawler", "bait_invisible" }

local _FindFoodAction = UpvalueHacker.GetUpvalue(OceanFishBrain.OnStart, "FindFoodAction")

local function OceanFishFindFoodAction(inst, ...)
	if inst.food_target == nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = _G.TheSim:FindEntities(x, y, z, OCEANFISH_SEE_FOOD_DIST, {"bait_invisible"}, OCEANFISH_FINDFOOD_CANT_TAGS, OCEANFISH_FINDFOOD_ONEOF_TAGS)
			
		for _, baits in ipairs(ents) do
			if baits.components.bait ~= nil and inst.components.eater:CanEat(baits) then
				inst.food_target = baits
				inst.num_nibbles = 1
					
				return false
			end
		end
	end

	return _FindFoodAction(inst, ...)
end

UpvalueHacker.SetUpvalue(OceanFishBrain.OnStart, OceanFishFindFoodAction, "FindFoodAction")