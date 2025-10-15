local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

-- Mushrooms that turn into Mushtrees during Full Moon nights.
local MUSHROOMS = 
{
	red_mushroom =
	{
		transform_prefab = "mushtree_medium",
		chance = 0.30,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
	
	green_mushroom =
	{
		transform_prefab = "mushtree_small",
        chance = 0.20,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
	
	blue_mushroom =
	{
		transform_prefab = "mushtree_tall",
		chance = 0.10,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
}

for prefab_name, data in pairs(MUSHROOMS) do
	AddPrefabPostInit(prefab_name, function(inst)
		if not _G.TheWorld.ismastersim then
			return
		end

		inst:AddComponent("fullmoontransformer")
		inst.components.fullmoontransformer.transform_prefab = data.transform_prefab
		inst.components.fullmoontransformer.chance = data.chance
		inst.components.fullmoontransformer.delay = data.delay
		inst.components.fullmoontransformer.fx_prefab = data.fx_prefab
	end)
end

local MUSHTREES =
{	
	"mushtree_medium",
	"mushtree_small",
	"mushtree_tall",
}

for k, v in pairs(MUSHTREES) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return
		end

		inst:AddComponent("fullmoontransformer")
	end)
end