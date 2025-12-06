local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

-- New foods that can be dried on Drying Racks.
local dryables           =
{
	red_cap              =
	{
		raw              = "red_cap",
		dried            = "kyno_red_cap_dried",
		
		rawbuild         = "kyno_meatrack_red_cap",
		build            = "kyno_meatrack_red_cap",
		
		drytime          = TUNING.DRY_FAST,
	},
	
	green_cap            =
	{
		raw              = "green_cap",
		dried            = "kyno_green_cap_dried",
		
		rawbuild         = "kyno_meatrack_green_cap",
		build            = "kyno_meatrack_green_cap",
		
		drytime          = TUNING.DRY_FAST,
	},
	
	blue_cap             =
	{
		raw              = "blue_cap",
		dried            = "kyno_blue_cap_dried",
		
		rawbuild         = "kyno_meatrack_blue_cap",
		build            = "kyno_meatrack_blue_cap",
		
		drytime          = TUNING.DRY_FAST,
	},
	
	moon_cap             =
	{
		raw              = "moon_cap",
		dried            = "kyno_moon_cap_dried",
		
		rawbuild         = "kyno_meatrack_moon_cap",
		build            = "kyno_meatrack_moon_cap",
		
		drytime          = TUNING.DRY_FAST,
	},
	
	plantmeat            =
	{
		raw              = "plantmeat",
		dried            = "kyno_plantmeat_dried",

		rawbuild         = "kyno_meatrack_plantmeat",
		build            = "kyno_meatrack_plantmeat",
		
		drytime          = TUNING.DRY_MED,
	},
	
	-- Tier II
	fishmeat_small_dried =
	{
		raw              = "fishmeat_small_dried",
		dried            = "kyno_fishmeat_small_dried",
		
		rawbuild         = "meat_rack_food_tot",
		build            = "kyno_meatrack_fishmeat",
		
		drytime          = TUNING.DRY_FAST * 2, -- DRY_FAST is 1 Day.
	},
	
	fishmeat_dried       =
	{
		raw              = "fishmeat_dried",
		dried            = "kyno_fishmeat_dried",
		
		rawbuild         = "meat_rack_food_tot",
		build            = "kyno_meatrack_fishmeat",
		
		drytime          = TUNING.DRY_FAST * 3,
	},
}

local function DryablePostinit(inst)
	inst:AddTag("dryable")

	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if not inst.components.dryable then
		inst:AddComponent("dryable")
		
		entry = dryables[inst.prefab]
		if entry then
			inst.components.dryable:SetProduct(entry.dried)
			inst.components.dryable:SetBuildFile(entry.rawbuild)
			inst.components.dryable:SetDriedBuildFile(entry.build)
			inst.components.dryable:SetDryTime(entry.drytime)
		end
	end
end

for k, v in pairs(dryables) do
	AddPrefabPostInit(k, DryablePostinit)
end