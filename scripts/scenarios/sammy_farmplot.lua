-- Make Sammy farm plants don't decay.
local function OnCreate(inst, scenariorunner)
	if inst.components.growable ~= nil then
		inst.components.growable:Pause("sammy_farmplot")
	end
end

local function OnLoad(inst, scenariorunner)
	if inst.components.growable ~= nil then
		inst.components.growable:Pause("sammy_farmplot")
	end
end

return 
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
}