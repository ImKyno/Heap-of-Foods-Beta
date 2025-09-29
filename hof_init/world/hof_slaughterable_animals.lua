local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

-- Animals that can be killed using Slaughter Tools.
local slaughterable_animals =
{
	beefalo =
	{
		loot = {"meat", "meat"},
		aggressive = false,
	},
	
	lightninggoat =
	{
		loot = {"meat", "meat"},
		aggressive = false,
	},
	
	koalefant_summer =
	{
		loot = {"meat", "meat"},
		aggressive = false,
	},
	
	koalefant_winter =
	{
		loot = {"meat", "meat"},
		aggressive = false,
	},
	
	spat =
	{
		loot = {"meat", "meat"},
		aggressive = true,
	},
	
	grassgator =
	{
		loot = {"plantmeat", "plantmeat"},
		aggressive = false,
	},
	
	perd =
	{
		loot = {"drumstick", "drumstick"},
		aggressive = false,
	},
	
	deer =
	{
		loot = {"meat", "meat"},
		aggressive = false,
	}
}

local function SlaughterablePostinit(inst)
	inst:AddTag("slaughterable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("slaughterable")
	
	entry = slaughterable_animals[inst.prefab]
	if entry then
		inst.components.slaughterable:SetExtraLootFn(ExtraLootFn)
		inst.components.slaughterable:SetExtraLoot(entry.loot)
		
		if entry.aggressive then
			inst.components.slaughterable:MakeAggressive()
		else
			inst.components.slaughterable:MakeFearable()
		end
	end

	inst:ListenForEvent("slaughtered_extraloot", function(inst, data)
		print("Extra loot:", data.prefab, "doer", data.doer and data.doer.prefab)
	end)
end

for k, v in pairs(slaughterable_animals) do
	AddPrefabPostInit(k, SlaughterablePostinit)
end

local function BeefaloPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:ListenForEvent("entermood", function(inst)
		if not inst:HasTag("domesticated") then
			if inst.components.slaughterable ~= nil then
				inst.components.slaughterable:MakeAggressive()
			end
		end
	end)

	inst:ListenForEvent("leavemood", function(inst)
		if not inst:HasTag("domesticated") then
			if inst.components.slaughterable ~= nil then
				inst.components.slaughterable:MakeFearable()
			end
		end
	end)
end

AddPrefabPostInit("beefalo", BeefaloPostInit)