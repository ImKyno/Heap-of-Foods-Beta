local _G             = GLOBAL
local require        = _G.require
local LegacyEntities = require("hof_legacyentities")

AddComponentPostInit("builder", function(self)
	local _DoBuild = self.DoBuild

	self.DoBuild = function(self, recname, pt, rotation, skin, ...)
		local recipe = _G.GetValidRecipe(recname)

		if recipe ~= nil and recipe.product ~= nil then
			local prefab = recipe.product

			if LegacyEntities("islegacy", recipe.product) and not LegacyEntities("isallowed", self.inst.userid) then
            	return false
        	end
		end

		return _DoBuild(self, recname, pt, rotation, skin, ...)
	end
end)