local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

-- New foods that can be dried on Drying Racks.
local dryables =
{
	red_cap    =
	{
		raw    = "red_cap",
		dried  = "kyno_red_cap_dried",
		build  = "kyno_meatrack_red_cap",
	},
	
	green_cap  =
	{
		raw    = "green_cap",
		dried  = "kyno_green_cap_dried",
		build  = "kyno_meatrack_green_cap",
	},
	
	blue_cap   =
	{
		raw    = "blue_cap",
		dried  = "kyno_blue_cap_dried",
		build  = "kyno_meatrack_blue_cap",
	},
	
	moon_cap   =
	{
		raw    = "moon_cap",
		dried  = "kyno_moon_cap_dried",
		build  = "kyno_meatrack_moon_cap",
	},
	
	plantmeat  =
	{
		raw    = "plantmeat",
		dried  = "kyno_plantmeat_dried",
		build  = "kyno_meatrack_plantmeat",
	},
}

local function DryablePostinit(inst)
	inst:AddTag("dryable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("dryable")
	inst.components.dryable:SetDryTime(TUNING.DRY_MED)
	
	entry = dryables[inst.prefab]
	if entry then
		inst.components.dryable:SetProduct(entry.dried)
		inst.components.dryable:SetBuildFile(entry.build)
		inst.components.dryable:SetDriedBuildFile(entry.build)
	end
end

for k, v in pairs(dryables) do
	AddPrefabPostInit(k, DryablePostinit)
end