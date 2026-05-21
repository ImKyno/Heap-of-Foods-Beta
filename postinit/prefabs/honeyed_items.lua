local _G = GLOBAL

-- Honey and Honey-based foods do not spoil inside Honey Deposits.
local HONEYED_ITEMS =
{
	"bandage",
	"honey",
	"royal_jelly",
	"spice_sugar",
	"honeynuggets",
	"honeyham",
	"powcake",
	"freshfruitcrepes",
	"taffy",
	"icecream",
	"leafymeatsouffle",
	"voltgoatjelly",
	"sweettea",
	"pumpkincookie",
	"leafymeatsouffle",
	"beeswax",
	"bee",
	"killerbee",
	"beemine",
	"hivehat",
}

local function HoneyedItemsPostInit(inst)
	if not inst:HasTag("honeyed") then -- Just in case if they already have.
		inst:AddTag("honeyed")
	end
end

for k, v in pairs(HONEYED_ITEMS) do
	AddPrefabPostInit(v, HoneyedItemsPostInit)

	for k, s in pairs(TUNING.HOF_SPICES) do
		AddPrefabPostInit(v.."_spice_"..s, HoneyedItemsPostInit)
	end
end