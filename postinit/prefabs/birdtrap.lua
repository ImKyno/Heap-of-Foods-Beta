local _G            = GLOBAL
local require       = _G.require
local NIGHTBIRDS    = TUNING.HOF_NIGHTBIRDS
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function GetNightBirdPrefab()
	local available = {}

	for _, data in ipairs(NIGHTBIRDS) do
		if not data.winter or _G.TheWorld.state.iswinter then
			table.insert(available, data.prefab)
		end
	end

	if #available > 0 then
		return available[math.random(#available)]
	end
end

local function BirdTrapPostInit(inst)
	local _CatchOffScreen = UpvalueHacker.GetUpvalue(_G.Prefabs.birdtrap.fn, "OnEntitySleep", "CatchOffScreen")

	if _CatchOffScreen ~= nil then
		local function CatchOffScreen(inst)
			if not _G.TheWorld.state.isnight then
				return _CatchOffScreen(inst)
			else
				inst._sleeptask = nil

				if not inst:IsInLimbo() and inst.components.trap ~= nil
				and inst.components.trap:IsBaited() and math.random() < 0.5 then
					local nightbirdspawner = TheWorld.components.nightbirdspawner

					if nightbirdspawner ~= nil then
						local pos = inst:GetPosition()
						local bird = nightbirdspawner:SpawnBird(pos)

						if bird ~= nil then
							bird.Physics:Teleport(pos:Get())
							bird:ReturnToScene()

							inst.components.trap.target = bird
							inst.components.trap:DoSpring()
							inst.sg:GoToState("full")
						end
					end
				end
			end
		end

		UpvalueHacker.SetUpvalue(_G.Prefabs.birdtrap.fn, CatchOffScreen, "OnEntitySleep", "CatchOffScreen")
	end
end

AddPrefabPostInit("birdtrap", BirdTrapPostInit)