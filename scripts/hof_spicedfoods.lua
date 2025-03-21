require("tuning")

local spicedfoods   = {}
local foods         = require("hof_foodrecipes")
local foods_w       = require("hof_foodrecipes_warly")
local foods_s       = require("hof_foodrecipes_seasonal")

GenerateSpicedFoods(foods)
GenerateSpicedFoods(foods_w)
GenerateSpicedFoods(foods_s)

local spices = require("spicedfoods")

for k, data in pairs(spices) do
	for name, v in pairs(MergeMaps(foods, foods_w, foods_s)) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
end

return spicedfoods