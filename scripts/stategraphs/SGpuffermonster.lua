require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.GOHOME, "action"),
}

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
		local is_moving = inst.sg:HasStateTag("moving")
		local is_running = inst.sg:HasStateTag("running")
		local is_idling = inst.sg:HasStateTag("idle")

		local should_move = inst.components.locomotor:WantsToMoveForward()
		local should_run = inst.components.locomotor:WantsToRun()

		if is_moving and not should_move then
			inst.sg:GoToState((is_running and "run_stop") or "swimming_stop")
		elseif (is_idling and should_move) or (is_moving and should_move and is_running ~= should_run) then
			inst.sg:GoToState((should_run and "run_pre") or "swimming_pre")
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
				inst.AnimState:PlayAnimation("idle", true)
			else
				inst.AnimState:PlayAnimation("idle", true)
			end
		end,
	},

	State{
		name = "swimming_pre",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
			inst.components.locomotor:WalkForward()
		end,

		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("swimming")
				end
			end),
		},
	},
	
	State{
		name = "swimming",
		tags = { "moving", "canrotate", "swimming" },

		onenter = function(inst)
			inst.components.locomotor:WalkForward()
			
			inst.AnimState:PlayAnimation("walk_loop")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
		end,

		timeline =
		{
			TimeEvent(6 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
			end),
		},

		ontimeout = function(inst)
			inst.sg:GoToState("swimming")
		end,
	},
	
	State{
		name = "swimming_stop",
		tags = { "canrotate" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()

			local run_anim_time_remaining = inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime()
			inst.sg:SetTimeout(run_anim_time_remaining + 1 * FRAMES)

			inst.AnimState:PushAnimation("walk_pst", false)
		end,

		ontimeout = function(inst)
			inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "run_pre",
		tags = { "moving", "canrotate", "running" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
			inst.components.locomotor:WalkForward()
		end,

		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("run")
				end
			end),
		},
	},
	
	State{
		name = "run",
		tags = { "moving", "canrotate", "running" },

		onenter = function(inst)
			inst.components.locomotor:WalkForward()
			
			inst.AnimState:PlayAnimation("walk_loop")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
		end,

		timeline =
		{
			TimeEvent(6 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
			end),
		},

		ontimeout = function(inst)
			inst.sg:GoToState("run")
		end,
	},
	
	State{
		name = "run_stop",
		tags = { "canrotate" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()

			local run_anim_time_remaining = inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime()
			inst.sg:SetTimeout(run_anim_time_remaining + 1 * FRAMES)

			inst.AnimState:PushAnimation("walk_pst", false)
		end,

		ontimeout = function(inst)
			inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small", nil, .25)
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			
			inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
			inst.SoundEmitter:PlaySound("wes/characters/wes/deflate_speedballoon")
			
			inst.components.floater:OnNoLongerLandedServer()
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},

	State{
		name = "hit",
		tags = { "busy", "hit" },
		
		onenter = function(inst)
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("hit_splash")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/puffermonster/hit")
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
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/puffermonster/attack")
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
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/puffermonster/sleep")
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
	
	State{
		name = "eat",
		
		onenter = function(inst)
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("hit_splash", false)
			inst.sg:SetTimeout(2 + math.random() * 4)
        end,

		ontimeout = function(inst)
			inst:PerformBufferedAction()
			inst.sg:GoToState("idle")
		end,
    },
}

CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("puffermonster", states, events, "idle")