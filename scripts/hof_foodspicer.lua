local spicedfoods 	= {}
local foods 		= require("hof_foodrecipes")
local foods_warly   = require("hof_foodrecipes_warly")
local foods_festive = require("hof_foodrecipes_seasonal")

GenerateSpicedFoods(foods)
GenerateSpicedFoods(foods_warly)
GenerateSpicedFoods(foods_festive)

local list = require("spicedfoods")

for k, data in pairs(list) do
    for name, v in pairs(foods) do
        if data.basename == name then
            spicedfoods[k] = data
        end
    end

    for name, v in pairs(foods_warly) do
        if data.basename == name then
            spicedfoods[k] = data
        end
    end
	
	for name, v in pairs(foods_festive) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
end

return spicedfoods