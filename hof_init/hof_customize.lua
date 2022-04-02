require("hof_customization_strings")

AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, "hof", 		"Heap of Foods", nil, nil, 1.0)
AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, "hof_cave", 	"Heap of Foods", nil, nil, 1.0)

for k, v in pairs(require("map/hof_customizations")) do
	if v.category == LEVELCATEGORY.SETTINGS then
		v.image = "worldsettings_"..v.name
	else
		v.image = "worldgen_"..v.name
	end
	AddCustomizeItem(v.category, v.group, v.name, {value = v.value, desc = GetCustomizeDescription(v.desc), world = v.world, image = v.image..".tex", atlas = "images/customizationimages/hof_customizationicons.xml"})
end