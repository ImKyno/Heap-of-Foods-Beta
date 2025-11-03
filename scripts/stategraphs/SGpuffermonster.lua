require("stategraphs/commonstates")

local function AttackBoatHull(inst)
	local position = inst:GetPosition()
	local angle = inst:GetRotation() + (math.random() * 20 - 10)

	local angle_rads = angle * DEGREES
	local offset_direction1 = Vector3(math.cos(angle_rads), 0, -math.sin(angle_rads)):Normalize()

	local point = position + (offset_direction1 * 3.5)
	local platform = TheWorld.Map:GetPlatformAtPoint(point.x, point.y, point.z)
	
	if platform then
		local theta = inst.Transform:GetRotation() * DEGREES
		local offset = Vector3(math.cos( theta ), 0, -math.sin(theta))

		if platform.components.hullhealth ~= nil then
			platform.components.health:DoDelta(-TUNING.KYNO_SWORDFISH_HULLDAMAGE)
			
			-- Cool fx and sound to let the player know the boat is being damaged.
			local fx = SpawnPrefab("kyno_swordfish_damage_fx")
			local fx_pos = position + (offset_direction1 * 1)

			if fx ~= nil then
				fx.Transform:SetPosition(fx_pos.x, fx_pos.y, fx_pos.z)
			end
			
			if platform.SoundEmitter ~= nil then
				platform.SoundEmitter:PlaySound("turnoftides/common/together/boat/damage")
			end
		end
    end
end

local events =
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnElectrocute(),

	EventHandler("locomote", function(inst)
		if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then
			return
		end

		if not inst.components.locomotor:WantsToMoveForward() then
			if not inst.sg:HasStateTag("idle") then
				if not inst.sg:HasStateTag("running") then
					inst.sg:GoToState("idle")
				end
					
				inst.sg:GoToState("idle")
			end
		elseif inst.components.locomotor:WantsToRun() then
			if not inst.sg:HasStateTag("running") then
				inst.sg:GoToState("run")
			end
		else
			if not inst.sg:HasStateTag("swimming") then
				inst.sg:GoToState("swimming")
			end
		end
	end),

	EventHandler("death", function(inst)
		inst.sg:GoToState("death")
	end),
	
	EventHandler("attacked", function(inst, data)
		if not inst.components.health:IsDead() then
			if CommonHandlers.TryElectrocuteOnAttacked(inst, data) then
				return
			elseif not (inst.sg:HasAnyStateTag("attack", "electrocute")) then
				inst.sg:GoToState("hit")
			end
		end
	end),
	
	EventHandler("doattack", function(inst, data) 
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) and not inst.sg:HasStateTag("electrocute") then
			inst.sg:GoToState("attack", data.target) 
		end
	end),
	
	EventHandler("onhitother", function(inst, data)
		if data ~= nil and data.target ~= nil and data.target:HasTag("player") then
			AttackBoatHull(inst)
		end
	end),
}

local states =
{
	State{
		name = "idle",
		tags = { "idle", "canrotate" },
		
		onenter = function(inst, playanim)
			inst.Physics:Stop()

			if playanim then
				inst.AnimState:PlayAnimation("idle")
				inst.AnimState:PushAnimation("idle", true)
			else
				inst.AnimState:PlayAnimation("idle", true)
			end
		end,
	},

	State{
		name = "swimming",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
			inst.AnimState:PushAnimation("walk_loop", true)
			inst.components.locomotor:WalkForward()
		end,

		onupdate = function(inst)
			if not inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("idle")
			end
		end,
	},

	State{
		name = "run",
		tags = { "moving", "running", "canrotate" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
			inst.AnimState:PushAnimation("walk_loop", true)
			inst.components.locomotor:RunForward()
				
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/swim_emerge_med", "swimming")
		end,

        onexit = function(inst)
			inst.SoundEmitter:KillSound("swimming")
		end,
	},

	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},

	State{
		name = "hit",
		tags = { "busy", "hit" },
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("hit_splash")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "attack",
		tags = { "attack", "busy" },
		
		onenter = function(inst, target)
			inst.sg.statemem.target = target
			inst.Physics:Stop()
				
			inst.AnimState:PlayAnimation("attack", false)
		end,

		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
				
				inst.components.combat:StartAttack()
				inst.components.combat:DoAttack(inst.sg.statemem.target)
			end),
		},

		events =
		{
			EventHandler("animqueueover",  function(inst) inst.sg:GoToState("idle") end),
		},
	},

    State{
		name = "sleep",
		tags = { "busy", "sleeping" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("sleep_pre")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end),
			EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
		},
	},

	State{
		name = "sleeping",
		tags = { "busy", "sleeping" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("sleep_loop")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end),
			EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
		},
	},

	State{
		name = "wake",
		tags = { "busy", "waking" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("sleep_pst")
				
			if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
				inst.components.sleeper:WakeUp()
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("puffermonster", states, events, "idle")