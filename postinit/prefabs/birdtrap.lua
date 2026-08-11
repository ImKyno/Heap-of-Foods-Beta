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

	local function CatchOffScreen(inst)
		if not _G.TheWorld.state.isnight then
			return _CatchOffScreen(inst)
		end

		inst._sleeptask = nil

		if not inst:IsInLimbo() and inst.components.trap ~= nil and inst.components.trap:IsBaited() and math.random() < 0.5 then
			local birdspawner = _G.TheWorld.components.birdspawner

			if birdspawner ~= nil then
				local pos = inst:GetPosition()
				local prefab = GetNightBirdPrefab()

				if prefab ~= nil then
					local bird = _G.SpawnPrefab(prefab)

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

AddPrefabPostInit("birdtrap", BirdTrapPostInit)