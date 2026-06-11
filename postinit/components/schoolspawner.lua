local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- schoolspawner component modified to allow schools to spawn during specific phases.
local function PhaseAllowed(schooldata)
	if schooldata.schoolphases == nil then
		return true -- Vanilla fishes doesn't have this requirement.
	end

	local current = _G.TheWorld.state.phase

	if type(schooldata.schoolphases) == "table" then
		for _, phase in ipairs(schooldata.schoolphases) do
			if phase == current then
				return true
			end
		end

		return false
	end

	return schooldata.schoolphases == current
end

AddComponentPostInit("schoolspawner", function(self)
	local SpawnSchool = self.SpawnSchool
	local _PickSchool = UpvalueHacker.GetUpvalue(SpawnSchool, "PickSchool")

	local function NewPickSchool(spawnpoint)
		local schooldata = _PickSchool(spawnpoint)

		if schooldata == nil then
			return nil
		end

		if PhaseAllowed(schooldata) then
			return schooldata
		end

		return nil
	end

	UpvalueHacker.SetUpvalue(SpawnSchool, NewPickSchool, "PickSchool")
end)