local _G = GLOBAL

local SLICEABLES =
{
	drumstick      =
	{
		product    = "smallmeat",
		slicesize  = 1,
	},

	fishmeat       =
	{
		product    = "fishmeat_small",
		slicesize  = 2,
	},

	fishmeat_dried =
	{
		product    = "fishmeat_small_dried",
		slicesize  = 2,
	},

	meat           =
	{
		product    = "smallmeat",
		slicesize  = 2,
	},

	meat_dried     =
	{
		product    = "smallmeat_dried",
		slicesize  = 2,
	},
}

local function SliceablePostInit(inst)
	inst:AddTag("sliceable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("sliceable")

	entry = SLICEABLES[inst.prefab]
	if entry then
		inst.components.sliceable:SetProduct(entry.product)
		inst.components.sliceable:SetSliceSize(entry.slicesize)
	end
end

for k, v in pairs(SLICEABLES) do
	AddPrefabPostInit(k, SliceablePostInit)
end