local _G               = GLOBAL
local require          = _G.require
local WarlyFood        = require("preparedfoods_warly")
local SpicedFood       = require("spicedfoods")
local HofSpicedFood    = require("hof_spicedfoods")
local PIG_COIN_ECONOMY = require("hof_pigcoineconomy")

-- Some changes for Warly foods.
WarlyFood.monstertartare.test = function(cooker, names, tags)
	return tags.monster and tags.monster >= 2 and not tags.inedible and not tags.fruit
end

WarlyFood.monstertartare.health = -20
WarlyFood.monstertartare.hunger = 62.5
WarlyFood.monstertartare.sanity = -20
WarlyFood.monstertartare.cooktime = 2
WarlyFood.monstertartare.oneatenfn = function(inst, eater)
	if eater ~= nil and eater:HasTag("playermonster") and
	not (eater.components.health ~= nil and eater.components.health:IsDead()) and
	not eater:HasTag("playerghost") then
		eater.components.health:DoDelta(20)
		eater.components.sanity:DoDelta(20)
	end
end

WarlyFood.freshfruitcrepes.test = function(cooker, names, tags)
	return tags.fruit and tags.fruit >= 1.5 and tags.butter and names.honey
end

-- For Preservation Powder Spice.
for k, v in pairs(WarlyFood) do
	AddPrefabPostInit(v, function(inst, data)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.edible ~= nil then
			inst.components.edible.degrades_with_spoilage = data.degrades_with_spoilage == nil or data.degrades_with_spoilage
		end
	end)
end

-- Pig King Coin Economy System.
local PIG_COIN_VALUES =
{
	nightmarepie     = {4, 2, 0},
	voltgoatjelly    = {0, 0, 1},
	glowberrymousse  = {6, 2, 0},
	frogfishbowl     = {5, 2, 0},
	dragonchilisalad = {8, 1, 1},
	gazpacho         = {5, 1, 1},
	potatosouffle    = {5, 1, 0},
	monstertartare   = {4, 1, 0},
	freshfruitcrepes = {9, 3, 1},
	bonesoup         = {7, 2, 0},
	moqueca          = {6, 0, 1},
}

for prefab, value in pairs(PIG_COIN_VALUES) do
	if WarlyFood[prefab] ~= nil then
		WarlyFood[prefab].pigcoinvalue = value
	end
end

for prefab, data in pairs(SpicedFood) do
	local value = data.basename and PIG_COIN_VALUES[data.basename]

	if value ~= nil then
		data.pigcoinvalue = value
	end
end

for prefab, data in pairs(HofSpicedFood) do
	local value = data.basename and PIG_COIN_VALUES[data.basename]

	if value ~= nil then
		data.pigcoinvalue = value
	end
end

PIG_COIN_ECONOMY.RegisterRecipes(WarlyFood)
PIG_COIN_ECONOMY.RegisterRecipes(SpicedFood)
PIG_COIN_ECONOMY.RegisterRecipes(HofSpicedFood)