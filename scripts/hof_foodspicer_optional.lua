local spicedfoods 	= {}
local foods2 		= require("hof_foodrecipes_optional")

GenerateSpicedFoods(foods2)
local list = require("spicedfoods")

for k, data in pairs(list) do
    for name, v in pairs(foods2) do
        if data.basename == name then
            spicedfoods[k] = data
        end
    end
end

return spicedfoods
