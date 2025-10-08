-- Grow random crop on farmplot.
local function OnCreate(inst, scenariorunner)
	if inst.components.grower ~= nil then
		local seed = SpawnPrefab("seeds")
		inst.components.grower:PlantItem(seed)

		inst:DoTaskInTime(0, function()
			for plant, _ in pairs(inst.components.grower.crops) do
				if plant ~= nil and plant.components.crop ~= nil then
					plant.components.crop:DoGrow(9999, true)
				end
			end
		end)
	end
end

local function OnLoad(inst, scenariorunner)

end

return 
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
}