require("stategraphs/commonstates")

local function GoToLocoState(inst, state)
	if inst:IsLocoState(state) then
		return true
	end
	
	inst.sg:GoToState("goto"..string.lower(state), {endstate = inst.sg.currentstate.name})
end

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
			local fx_pos = position + (offset_direction1 * 3.2)

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

	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
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
		name = "gotobelow",
		tags = { "busy" },
		
		onenter = function(inst, data)
			inst.AnimState:PlayAnimation("submerge")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/submerge_med")
			
			inst.Physics:Stop()
			inst.sg.statemem.endstate = data.endstate
		end,

		onexit = function(inst)
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
			inst.Transform:SetNoFaced()
			
			inst:SetLocoState("below")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState(inst.sg.statemem.endstate) end),
		},
	},

	State{
		name = "gotoabove",
		tags = { "busy" },
		
		onenter = function(inst, data)
			inst:SetAboveWater(true)
			inst.Physics:Stop()
			
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
			inst.AnimState:PlayAnimation("emerge")
			
			inst.Transform:SetFourFaced()
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/submerge_med")
			
			inst.sg.statemem.endstate = data.endstate
		end,

		onexit = function(inst)
			inst:SetLocoState("above")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState(inst.sg.statemem.endstate) end),
		},
	},

	State{
		name = "idle",
		tags = { "idle", "canrotate" },
		
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			
			local anim = inst:IsLocoState("above") and "fishmed" or "shadow"

			if playanim then
				inst.AnimState:PlayAnimation(playanim)
				inst.AnimState:PushAnimation(anim, true)
			else
				inst.AnimState:PlayAnimation(anim, true)
			end
		end,
	},

	State{
		name = "swimming",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "below") then
				inst.AnimState:PlayAnimation("shadow_flap_loop", true)
				inst.components.locomotor:WalkForward()
			end
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
			if GoToLocoState(inst, "above") then
				inst.AnimState:PlayAnimation("fishmed", true)
				inst.components.locomotor:RunForward()
				
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/swim_emerge_med", "swimming")
			end
		end,

        onexit = function(inst)
			inst.SoundEmitter:KillSound("swimming")
		end,
	},

	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/swordfish/death")
				
				inst:Hide()
				inst.Physics:Stop()
				RemovePhysicsColliders(inst)
				
				inst.components.lootdropper:DropLoot(inst:GetPosition())
			end
		end,
	},

	State{
		name = "hit",
		tags = { "busy", "hit" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("hit")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/swordfish/hit")
			end
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
			if GoToLocoState(inst, "above") then
				inst.sg.statemem.target = target
				inst.Physics:Stop()
				
				inst.components.combat:StartAttack()
				
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
			end
		end,

		timeline =
		{
			TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/swordfish/attack_pre") end),
			TimeEvent(6 * FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
			end),
			
			TimeEvent(11 * FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
					-- AttackBoatHull(inst)
				end
				
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/swordfish/attack")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/swordfish/swing")
			end),
			
            TimeEvent(16*FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
				
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
			if GoToLocoState(inst, "above") then
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("sleep_pre")
			end
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
			if GoToLocoState(inst, "above") then
				inst.AnimState:PlayAnimation("sleep_loop")
			end
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
			if GoToLocoState(inst, "above") then
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("sleep_pst")
				
				if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
					inst.components.sleeper:WakeUp()
				end
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "frozen",
		tags = { "busy", "frozen" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.components.locomotor:StopMoving()
				
				inst.AnimState:PlayAnimation("frozen", true)
				inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
				
				inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
			end
		end,

		onexit = function(inst)
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
		end,

		events =
		{
			EventHandler("onthaw", function(inst) inst.sg:GoToState("thaw") end),
		},
	},

	State{
		name = "thaw",
		tags = { "busy", "thawing" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.components.locomotor:StopMoving()
				
				inst.AnimState:PlayAnimation("frozen_loop_pst", true)
				inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
                
				inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
			end
		end,

		onexit = function(inst)
			inst.SoundEmitter:KillSound("thawing")
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
		end,

		events =
		{
			EventHandler("unfreeze", function(inst) inst.sg:GoToState("hit") end),
		},
	},
}

CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("swordfishocean", states, events, "idle")