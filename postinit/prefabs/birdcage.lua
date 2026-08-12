local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local _OnOccupied
local _OnEmptied

local function GetBird(inst)
	local occupiable = inst.components.occupiable
	return occupiable ~= nil and occupiable:GetOccupant() or nil
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

	if bird == nil or not bird:HasTag("nightbird") then
		return
	end

	local sleeper = inst.components.sleeper

	if sleeper == nil then
		return
	end

	if inst._nightbird_sleeper ~= sleeper then
		inst._nightbird_sleeper = sleeper

		inst._original_sleeptestfn = sleeper.sleeptestfn
		inst._original_waketestfn = sleeper.waketestfn

		inst._nightbird_sleepfn = nil
		inst._nightbird_wakefn = nil
	end

	if inst._nightbird_sleepfn ~= nil
		and sleeper.sleeptestfn == inst._nightbird_sleepfn then
		return
	end

	local _sleeptestfn = inst._original_sleeptestfn
	local _waketestfn = inst._original_waketestfn

	local sleepfn = function(cage)
		local current_bird = GetBird(cage)

		if current_bird ~= nil and current_bird:HasTag("nightbird") then
			return NightBirdSleepTest(cage)
		end

		if _sleeptestfn ~= nil then
			return _sleeptestfn(cage)
		end

		return false
	end

	local wakefn = function(cage)
		local current_bird = GetBird(cage)

		if current_bird ~= nil and current_bird:HasTag("nightbird") then
			return NightBirdWakeTest(cage)
		end

		if _waketestfn ~= nil then
			return _waketestfn(cage)
		end

		return false
	end

	inst._nightbird_sleepfn = sleepfn
	inst._nightbird_wakefn = wakefn

	sleeper:SetSleepTest(sleepfn)
	sleeper:SetWakeTest(wakefn)

	--[[
	if not _G.TheWorld.state.isnight and GetHunger(bird) >= 0.33 and not sleeper:IsAsleep() then
		sleeper:GoToSleep()
	end
	]]--
end

local function OnOccupied(inst, bird, ...)
	if _OnOccupied ~= nil then
		_OnOccupied(inst, bird, ...)
	end

	if bird ~= nil and bird:HasTag("nightbird") then
		inst:DoTaskInTime(0, function()
			if inst:IsValid() then
				SetupNightBird(inst)
			end
		end)
	end
end

local function OnEmptied(inst, ...)
	if _OnEmptied ~= nil then
		_OnEmptied(inst, ...)
	end

	inst._nightbird_sleeper = nil
	inst._original_sleeptestfn = nil
	inst._original_waketestfn = nil
	inst._nightbird_sleepfn = nil
	inst._nightbird_wakefn = nil
end

local function BirdcagePostInit(inst)
	local invalid_foods = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "ShouldAcceptItem", "invalid_foods")
	table.insert(invalid_foods, "kyno_chicken_egg")
	table.insert(invalid_foods, "kyno_chicken_egg_cooked")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.occupiable then
		if not _OnOccupied then
			_OnOccupied = inst.components.occupiable.onoccupied
		end

		if not _OnEmptied then
			_OnEmptied = inst.components.occupiable.onemptied
		end

		inst.components.occupiable.onoccupied = OnOccupied
		inst.components.occupiable.onemptied = OnEmptied
	end

	inst:DoTaskInTime(0, function()
		if inst:IsValid() then
			SetupNightBird(inst)
		end
	end)
end

AddPrefabPostInit("birdcage", BirdcagePostInit)