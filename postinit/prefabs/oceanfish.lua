local _G           = GLOBAL
local require      = _G.require
local OceanFishDef = require("prefabs/oceanfishdef")

-- Trappable for Ocean Trap.
-- "oceanfish" and "smalloceancreature" tags are inconsistent.
local function OceanFishPostInit(inst)
	inst:AddTag("smalloceanfish")
	inst:AddTag("canbetrapped")
end

for _, fish_def in pairs(OceanFishDef.fish) do
	AddPrefabPostInit(fish_def.prefab, OceanFishPostInit)
end