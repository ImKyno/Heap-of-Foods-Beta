local _G = GLOBAL

local TRINKETS =
{
	antliontrinket =
	{
		octopusvalue = TUNING.OCTOPUS_VALUES.ANTLIONTRINKET
	},

	cotl_trinket   =
	{
		octopusvalue = TUNING.OCTOPUS_VALUES.COTLTRINKET
	},
}

local function TrinketPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.tradable ~= nil then
		inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.TRINKETS[i] or 3
	end
end

local function TrinketCustomPostInit(inst)
	inst:AddTag("hof_trinket")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.tradable ~= nil then
		entry = TRINKETS[inst.prefab]

		if entry then
			inst.components.tradable.octopusvalue = entry.octopusvalue
		end
	end
end

for i = 1, _G.NUM_TRINKETS do
	AddPrefabPostInit("trinket_"..i, TrinketPostInit)
end

for k, v in pairs(TRINKETS) do
	AddPrefabPostInit(k, TrinketCustomPostInit)
end