local _G = GLOBAL

-- Allows Wickerbottom's book to grow some plants.
local function PlantNormalPostInit(inst)
	inst:AddTag("plant")
end

AddPrefabPostInit("plant_normal", PlantNormalPostInit)