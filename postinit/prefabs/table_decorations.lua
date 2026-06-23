if TUNING.HOF_IS_OTT_ENABLED then
	return -- On To Table Mod already does this feature.
end

local _G          = GLOBAL
local require     = _G.require
local VanillaFood = require("preparedfoods")
local WarlyFood   = require("preparedfoods_warly")
local ItemsFood   = require("preparednonfoods")

local TABLE_DECOR_PREFABS =
{
	--[[
	"book_bees",
	"book_birds",
	"book_brimstone",
	"book_fire",
	"book_fish",
	"book_gardening",
	"book_horticulture",
	"book_horticulture_upgraded",
	"book_light",
	"book_light_upgraded",
	"book_moon",
	"book_rain",
	"book_research_station",
	"book_silviculture",
	"book_sleep",
	"book_temperature",
	"book_tentacles",
	"book_web",
	]]--

	"cookbook",
	"portableblender_item",
	"portablecookpot_item",
	"portablespicer_item",
	-- "waxwelljournal",
}

for k, v in pairs(_G.MergeMaps(VanillaFood, WarlyFood, ItemsFood)) do
	table.insert(TABLE_DECOR_PREFABS, k)
end

local function TableDecorationsPostInit(inst)
	local function GetVerb()
		return "READBOOK"
	end

	local function OnActivate(inst, doer)
		doer:ShowPopUp(_G.POPUPS.COOKBOOK, true)

		if inst.components.activatable ~= nil then
			inst.components.activatable.inactive = true
		end
	end

	local function OnPutOnFurniture(inst)
		if TUNING.HOF_KEEPFOOD then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
		end

		inst:AddTag("outofreach")

		if inst.prefab == "cookbook" then
			if not inst.components.activatable then
				inst:AddComponent("activatable")
			else
				inst._activatable_book = true
			end

			if inst.components.activatable ~= nil then
				inst.components.activatable.quickaction = true
				inst.components.activatable.OnActivate = OnActivate
			end
		end
	end

	local function OnTakeOffFurniture(inst)
		if TUNING.HOF_KEEPFOOD then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
		end

		inst:RemoveTag("outofreach")

		if inst.prefab == "cookbook" then
			if inst._activatable_book then
				return
			else
				inst:RemoveComponent("activatable")
			end
		end
	end

	if inst.Follower == nil then
		inst.entity:AddFollower()
	end

	inst:AddTag("furnituredecor")

	if inst.prefab == "cookbook" then
		inst.GetActivateVerb = GetVerb
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("furnituredecor")
	inst.components.furnituredecor.onputonfurniture = OnPutOnFurniture
	inst.components.furnituredecor.ontakeofffurniture = OnTakeOffFurniture
end

for k, v in pairs(TABLE_DECOR_PREFABS) do
	AddPrefabPostInit(v, TableDecorationsPostInit)
end