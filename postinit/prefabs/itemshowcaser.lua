local _G = GLOBAL

-- Valid Foods for the Display Stand.
local ITEMSHOWCASER_VALID_ITEMS =
{
	"batnosehat",
	"dustmeringue",

	-- They're not Crock Pot foods...
	-- "carnivalfood_corntea",
	-- "yotp_food1",
	-- "yotp_food2",
	-- "yotp_food3",
	-- "yotr_food1",
	-- "yotr_food2",
	-- "yotr_food3",
	-- "yotr_food4",
}

local function ItemShowcaserItemsPostInit(inst)
	inst:AddTag("itemshowcaser_valid")
end

for k, v in pairs(ITEMSHOWCASER_VALID_ITEMS) do
	AddPrefabPostInit(v, ItemShowcaserItemsPostInit)
end