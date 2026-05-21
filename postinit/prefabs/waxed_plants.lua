local _G      = GLOBAL
local require = _G.require

-- Allows us to edit some stuff for waxed plants.
local WAXED_PLANTS = require("prefabs/waxed_plant_common")

local function Common_CreateWaxedPlant(inst, data)
	if data.minimapicon2 ~= nil then -- For using .tex instead.
		inst.MiniMapEntity:SetIcon(data.minimapicon2..".tex")
	end
end

local _CreateWaxedPlant = WAXED_PLANTS.CreateWaxedPlant
function WAXED_PLANTS.CreateWaxedPlant(data, ...)
	local _common_postinit = data.common_postinit

	data.common_postinit = function(inst, ...)
		Common_CreateWaxedPlant(inst, data)
		return _common_postinit ~= nil and _common_postinit(inst, ...) or nil
	end

	return _CreateWaxedPlant(data, ...)
end