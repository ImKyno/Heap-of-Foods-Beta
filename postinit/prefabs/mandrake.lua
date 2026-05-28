local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local MANDRAKE_ITEMS =
{
	"mandrake",
	"cookedmandrake",
	"mandrakesoup",
}

local function MandrakeCommonPostInit(inst)
	inst:AddTag("mandrake")
end

local function MandrakePostInit(inst)
	local SLEEPTARGETS_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.mandrake.fn, 
	"oneaten_raw", "doareasleep", "SLEEPTARGETS_CANT_TAGS")
	
	table.insert(SLEEPTARGETS_CANT_TAGS, "soundproof")
end

local function MandrakeCookedPostInit(inst)
	local SLEEPTARGETS_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.cookedmandrake.fn, 
	"oneaten_cooked", "doareasleep", "SLEEPTARGETS_CANT_TAGS")
	
	table.insert(SLEEPTARGETS_CANT_TAGS, "soundproof")
end

local function MandrakeActivePostInit(inst)
	local SLEEPTARGETS_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.mandrake_active.fn, 
	"oncooked", "doareasleep", "SLEEPTARGETS_CANT_TAGS")
	
	table.insert(SLEEPTARGETS_CANT_TAGS, "soundproof")
end

for k, v in pairs(MANDRAKE_ITEMS) do
	AddPrefabPostInit(v, MandrakeCommonPostInit)
end

for k, s in pairs(TUNING.HOF_SPICES) do
	AddPrefabPostInit("mandrakesoup_spice_"..s, MandrakePostInit)
end

AddPrefabPostInit("mandrake", MandrakePostInit)
AddPrefabPostInit("cookedmandrake", MandrakeCookedPostInit)
AddPrefabPostInit("mandrake_active", MandrakeActivePostInit)