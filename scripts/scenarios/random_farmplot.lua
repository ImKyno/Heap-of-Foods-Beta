-- Grow random crop on farmplot.
local function OnCreate(inst, scenariorunner)
	if inst.components.grower ~= nil then
		local seed = SpawnPrefab("seeds")
		
		inst.components.grower:PlantItem(seed)
		
		for ent, _ in ipairs(inst.components.grower.crops) do
			if ent.components.crop ~= nil then
				for i = 1, 10 do
					ent.components.crop:DoGrow(9999)
				end
			end
		end
	end
end

local function OnLoad(inst, scenariorunner)

end

return 
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
}