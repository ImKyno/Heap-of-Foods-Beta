require("stategraphs/commonstates")

local function GoToLocoState(inst, state)
	if inst:IsLocoState(state) then
		return true
	end
	
	inst.sg:GoToState("goto"..string.lower(state), {endstate = inst.sg.currentstate.name})
end

local events =
{
	CommonHandlers.OnLocomote(true, true),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnElectrocute(),
        
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
}

local states =
{
	State{
		name = "gotobelow",
		tags = { "busy" },
		
		onenter = function(inst, data)
			local splash = SpawnPrefab("ocean_splash_med1")
			local pos = inst:GetPosition()
			splash.Transform:SetPosition(pos.x, pos.y, pos.z)

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
			local splash = SpawnPrefab("ocean_splash_med2")
			splash.Transform:SetPosition(inst.Transform:GetWorldPosition())
            
			inst:SetAboveWater(true)
			inst.Physics:Stop()
			
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
			inst.Transform:SetFourFaced()
			
			inst.AnimState:PlayAnimation("emerge")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/emerge_med")
			
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
			
			if playanim then
				inst.AnimState:PlayAnimation(playanim)
				inst.AnimState:PushAnimation("shadow", true)
			else
				inst.AnimState:PlayAnimation("shadow", true)
			end
		end,
	},

	State{
		name = "walk_start",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst) 
			if GoToLocoState(inst, "below") then
				inst.AnimState:PlayAnimation("shadow_flap_loop")
				inst.components.locomotor:WalkForward()
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
		},
	},

	State{
		name = "walk",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst) 
			if GoToLocoState(inst, "below") then
				inst.AnimState:PlayAnimation("shadow_flap_loop")
				inst.components.locomotor:WalkForward()
			end
		end,     

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
		},
	},

	State{
		name = "walk_stop",
		tags = { "moving", "canrotate", "swimming" },
		
		onenter = function(inst)
			inst.sg:GoToState("idle")
		end,
	},

	State{
		name = "run_start",
		tags = { "moving", "running", "canrotate" },
		
		onenter = function(inst) 
			if GoToLocoState(inst, "above") then
				inst.AnimState:PlayAnimation("fishmed", true)
				
				inst.components.locomotor:RunForward()
				
				if not inst.SoundEmitter:PlayingSound("swimming") then
					inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/swim_emerge_med", "swimming")
				end
			end
		end,
        
		timeline =
		{
			TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/emerge_med") end),
			TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/dogfish/emerge") end),
		},
            
		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
		},
	},

	State{
		name = "run",
		tags = { "moving", "running", "canrotate" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.components.locomotor:RunForward()
				
				inst.AnimState:PlayAnimation("fishmed")
				
                if not inst.SoundEmitter:PlayingSound("swimming") then
					inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/swim_emerge_med", "swimming")
				end
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
		},
	},

	State{
		name = "run_stop",
		tags = { "moving", "running", "canrotate" },
        
		onenter = function(inst) 
			if GoToLocoState(inst, "below") then
				inst.AnimState:PlayAnimation("shadow_flap_loop")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/submerge_med")
				inst.SoundEmitter:KillSound("swimming")
			end
		end,
        
		events =
		{   
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
    
	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			if inst.SoundEmitter:PlayingSound("swimming") then
				inst.SoundEmitter:KillSound("swimming")
			end

			inst.SoundEmitter:PlaySound("hof_sounds/creatures/dogfish/death")
			
			inst:Hide()
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
			
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},

	State{
		name = "hit",
		tags = { "busy", "hit" },
		
		onenter = function(inst)
			if GoToLocoState(inst, "above") then
				inst.Physics:Stop()
				
				inst.AnimState:PlayAnimation("hit")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/dogfish/hit")
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddSleepStates(states, 
{
	starttimeline = 
	{
		TimeEvent(0, function(inst) GoToLocoState(inst, "above") end)
	},
})

CommonStates.AddFrozenStates(states, function(inst)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
	inst.Transform:SetFourFaced()
end)

CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("dogfishocean", states, events, "idle")