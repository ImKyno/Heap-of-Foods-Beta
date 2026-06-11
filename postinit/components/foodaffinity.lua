local _G      = GLOBAL
local require = _G.require

-- Uuugh. Our mod spices have a nasty bug regarding foodaffinity, I don't know how to fix it yet.
-- This is a temporary workaround for it to work with favorite foods.
AddComponentPostInit("foodaffinity", function(self)
	local spicedfoods = _G.MergeMaps(require("spicedfoods"), require("hof_spicedfoods"))

	function self:GetFoodBasePrefab(food)
		local prefab = food.prefab
		return spicedfoods[prefab] and spicedfoods[prefab].basename or prefab
	end
end)