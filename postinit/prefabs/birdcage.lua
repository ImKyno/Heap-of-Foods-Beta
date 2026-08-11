local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function BirdcagePostInit(inst)
	local invalid_foods = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "ShouldAcceptItem", "invalid_foods")
	table.insert(invalid_foods, "kyno_chicken_egg")
	table.insert(invalid_foods, "kyno_chicken_egg_cooked")

	local function GetBird(inst)
		return inst.components.occupiable ~= nil and inst.components.occupiable:GetOccupant() or nil
	end

	local function GetHunger(bird)
		return bird ~= nil and bird.components.perishable ~= nil and bird.components.perishable:GetPercent() or 1
	end

	local function NightBirdSleepTest(inst)
		local bird = GetBird(inst)

		if bird ~= nil and bird:HasTag("nightbird") then
			return not _G.TheWorld.state.isnight and GetHunger(bird) >= 0.33
		end

		return false
	end

	local function NightBirdWakeTest(inst)
		local bird = GetBird(inst)

		if bird ~= nil and bird:HasTag("nightbird") then
			return _G.TheWorld.state.isnight or GetHunger(bird) < 0.33
		end

		return false
	end

	local function SetupNightBird(inst)
		local bird = GetBird(inst)

		if bird == nil or not bird:HasTag("nightbird") or inst.components.sleeper == nil then
			return
		end

		if inst._nightbird_sleepfn ~= nil and inst.components.sleeper.sleeptestfn == inst._nightbird_sleepfn then
			return
		end

		local _sleeptestfn = inst.components.sleeper.sleeptestfn
		local _waketestfn  = inst.components.sleeper.waketestfn

		local sleeptestfn = function(cage)
			local current_bird = GetBird(cage)

			if current_bird ~= nil and current_bird:HasTag("nightbird") then
				return NightBirdSleepTest(cage)
			end

			if _sleeptestfn ~= nil then
				return _sleeptestfn(cage)
			end

			return false
		end

		local waketestfn = function(cage)
			local current_bird = GetBird(cage)

			if current_bird ~= nil and current_bird:HasTag("nightbird") then
				return NightBirdWakeTest(cage)
			end

			if _waketestfn ~= nil then
				return _waketestfn(cage)
			end

			return false
		end

		inst._nightbird_sleepfn = sleeptestfn
		inst._nightbird_wakefn = waketestfn

		inst.components.sleeper:SetSleepTest(sleeptestfn)
		inst.components.sleeper:SetWakeTest(waketestfn)
	end

	local _OnOccupied = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "OnOccupied")

	local function OnOccupied(inst, bird)
		if _OnOccupied ~= nil then
			_OnOccupied(inst, bird)
		end

		if bird ~= nil and bird:HasTag("nightbird") then
			SetupNightBird(inst)
		end
	end

	UpvalueHacker.SetUpvalue(_G.Prefabs.birdcage.fn, OnOccupied, "OnOccupied")

	local _OnLoadPostPass = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "OnLoadPostPass")

	local function OnLoadPostPass(inst, ents, data)
		if _OnLoadPostPass ~= nil then
			_OnLoadPostPass(inst, ents, data)
		end

		SetupNightBird(inst)
	end

	UpvalueHacker.SetUpvalue(_G.Prefabs.birdcage.fn, OnLoadPostPass, "OnLoadPostPass")

	inst:DoTaskInTime(0, function()
		if inst:IsValid() then
			SetupNightBird(inst)
		end
	end)
end

AddPrefabPostInit("birdcage", BirdcagePostInit)