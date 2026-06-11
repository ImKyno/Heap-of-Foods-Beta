local _G = GLOBAL

-- Weeds don't have SoundEmitter.
local PLANT_WEEDS =
{
	"weed_firenettle",
	"weed_forgetmelots",
	"weed_tillweed",
}

local function WeedsPostInit(inst)
	inst.entity:AddSoundEmitter()
end

for k, v in pairs(PLANT_WEEDS) do
	AddPrefabPostInit(v, WeedsPostInit)
end