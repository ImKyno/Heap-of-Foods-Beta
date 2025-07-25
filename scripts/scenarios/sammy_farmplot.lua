-- Make Sammy farm plants don't decay.
local function OnCreate(inst, scenariorunner)
	for k, v in pairs(Ents) do
		if v.components.growable ~= nil then
			v.components.growable:Pause("sammy_farmplot")
		end
	end
end

return 
{
	OnCreate = OnCreate
}