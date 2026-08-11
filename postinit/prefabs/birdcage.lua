local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function BirdcagePostInit(inst)
	-- Invalid Birdcage foods.
	local invalid_foods = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "ShouldAcceptItem", "invalid_foods")
	table.insert(invalid_foods, "kyno_chicken_egg")
	table.insert(invalid_foods, "kyno_chicken_egg_cooked")

	local function GetBird(inst)
		return (inst.components.occupiable ~= nil and inst.components.occupiable:GetOccupant()) or nil
	end

	local function GetHunger(bird)
		return (bird and bird.components.perishable ~= nil and bird.components.perishable:GetPercent()) or 1
	end

	-- Night Birds sleep during the day and stay awake during the night.
	local _OnOccupied = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "OnOccupied")
	local _OnEmptied  = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "OnEmptied")

	local function OnOccupied(inst, bird)
		if _OnOccupied ~= nil then
			_OnOccupied(inst, bird)
		end

		if inst.components.sleeper ~= nil then
			local _sleeptestfn = inst.components.sleeper.sleeptestfn
			local _waketestfn = inst.components.sleeper.waketestfn

			if _sleeptestfn ~= nil and _waketestfn ~= nil then
				inst.components.sleeper:SetSleepTest(function(occupant)
					local bird = GetBird(occupant)

					if bird ~= nil and bird:HasTag("nightbird") then
						return not _G.TheWorld.state.isnight and GetHunger(bird) >= 0.33
					else
						return _sleeptestfn(occupant)
					end
				end)

				inst.components.sleeper:SetWakeTest(function(occupant)
					local bird = GetBird(occupant)

					if bird ~= nil and bird:HasTag("nightbird") then
						return _G.TheWorld.state.isnight or GetHunger(bird) < 0.33
					else
						return _waketestfn(occupant)
					end
				end)
			end
		end
	end

	local function OnEmptied(inst, bird)
		if _OnEmptied ~= nil then
			_OnEmptied(inst, bird)
		end
	end

	UpvalueHacker.SetUpvalue(_G.Prefabs.birdcage.fn, OnOccupied, "OnOccupied")
	UpvalueHacker.SetUpvalue(_G.Prefabs.birdcage.fn, OnEmptied, "OnEmptied")
end

AddPrefabPostInit("birdcage", BirdcagePostInit)