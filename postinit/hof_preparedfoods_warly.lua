local _G        = GLOBAL
local require   = _G.require
local WarlyFood = require("preparedfoods_warly")

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