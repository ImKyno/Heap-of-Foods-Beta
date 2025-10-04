-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

local customization_worldgen      = require("map/hof_customizations_worldgen")
local customization_worldsettings = require("map/hof_customizations_worldsettings")

for k, v in pairs(customization_worldgen) do
	v.image = "worldgen_"..v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldgen.xml",
	})
end

for k, v in pairs(customization_worldsettings) do
	v.image = v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldsettings.xml",
	})
end