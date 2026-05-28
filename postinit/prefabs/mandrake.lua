local _G = GLOBAL

local function MandrakePostInit(inst)
	inst:AddTag("mandrake")
end

local MANDRAKE_ITEMS =
{
	"mandrake",
	"cookedmandrake",
	"mandrakesoup",
}

for k, v in pairs(MANDRAKE_ITEMS) do
	AddPrefabPostInit(v, MandrakePostInit)
end

for k, s in pairs(TUNING.HOF_SPICES) do
	AddPrefabPostInit("mandrakesoup_spice_"..s, MandrakePostInit)
end