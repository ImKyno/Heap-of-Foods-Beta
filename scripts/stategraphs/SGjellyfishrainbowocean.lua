require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.GOHOME, "action"),
}

local events = 
{
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("locomote", function(inst)
		if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then
			return
		end

		if not inst.components.locomotor:WantsToMoveForward() then
			if not inst.sg:HasStateTag("idle") then
				inst.sg:GoToState("idle")
			end
		else
			if not inst.sg:HasStateTag("moving") then
				inst.sg:GoToState("swimming")
			end
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
			inst.AnimState:PlayAnimation(playanim or "idle")
		end,

		events = 
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "swimming",
		tags = { "moving", "canrotate" },

		onenter = function(inst, skipanim)
			if skipanim then
				inst.AnimState:PlayAnimation("run")
			else
				inst.AnimState:PlayAnimation("run_pre")
				inst.AnimState:PushAnimation("run")
			end
			
			inst.components.locomotor:WalkForward()
		end,

		onupdate = function(inst)
			if not inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("idle", "run_pst")
			end
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("swimming", true) end),
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("swimming", true) end),
		},
	},

	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			inst:Hide()
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
			
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/jellyfish/murder")
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},

	State{
		name = "hit",
		tags = { "busy", "hit" },
		
		onenter = function(inst, cb)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/jellyfish/hit")
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
			inst.AnimState:PlayAnimation("idle", true)
			inst.sg:SetTimeout(2 + math.random() * 4)
        end,

		ontimeout = function(inst)
			inst:PerformBufferedAction()
			inst.sg:GoToState("idle")
		end,
    },
}

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)
CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("jellyfishrainbowocean", states, events, "idle", actionhandlers)