require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "gohome"),
}

local events =
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true, true),
	
	EventHandler("death", function(inst, data)
		inst.sg:GoToState("death", data)
	end),
	
	EventHandler("trapped", function(inst)
		inst.sg:GoToState("trapped")
	end),
}

local function CrabSteps(inst)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/pebble_crab/walk")
end

local states =
{
    State{

        name = "idle",
        tags = { "idle", "canrotate" },
		
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation(math.random() >= 0.25 and "idle" or "idle2", true)
        end,
		
        events =
        {
            EventHandler("animover", function (inst, data) inst.sg:GoToState("idle") end),
        }
    },

    State{
        name = "emerge",
		
        onenter = function(inst, playanim)
            inst.Physics:Stop()
			inst.SoundEmitter:PlaySound(inst.sounds.emerge)
            inst.AnimState:PlayAnimation("emerge")
        end,
		
		timeline = {
			TimeEvent(28 * FRAMES, function(inst)
				inst:SetAbovePhysics()
				inst.DynamicShadow:Enable(true)
			end),
		},
		
        events =
        {
            EventHandler("animover", function (inst, data) inst.sg:GoToState("idle") end),
        },
		
		onexit = function(inst)
			inst:AddTag("serenitycrab")
		end,
    },
	
    State{
        name = "burrow",
        tags = { "canrotate" },
		
        onenter = function(inst)
            inst.Physics:Stop()
			inst.SoundEmitter:PlaySound(inst.sounds.burrow)
            inst.AnimState:PlayAnimation("burrow")
        end,
		
		timeline = {
			TimeEvent(14 * FRAMES, function(inst)
				inst:SetUnderPhysics()
				inst.DynamicShadow:Enable(false)
			end),
			
			TimeEvent(34 * FRAMES, function(inst)
				inst:RemoveTag("serenitycrab")
			end),
		},
    },
	
    State{
        name = "eat",
		
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle3", true)
            inst.sg:SetTimeout(2 + math.random() * 4)
        end,

        ontimeout= function(inst)
            inst:PerformBufferedAction()
            inst.sg:GoToState("idle")
        end,
    },
	
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst, data)
            inst.Physics:Stop()
			
            inst.AnimState:PlayAnimation("death")
			
			inst.SoundEmitter:PlaySound(inst.sounds.hurt)
			
            inst:SetAbovePhysics()
            RemovePhysicsColliders(inst)
			
            inst.components.lootdropper:DropLoot(inst:GetPosition())
			
			if inst.components.inventory ~= nil then
				inst.components.inventory:DropEverything(false, true)
			end
        end,
    },

    State{
        name = "trapped",
        tags = { "busy", "trapped" },

        onenter = function(inst)
            inst.Physics:Stop()
			inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(1)
        end,

        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(0*FRAMES, CrabSteps ),
		
		TimeEvent(12*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, CrabSteps ),
	},
},
{
	startwalk 	= "walk_pre",
	walk 		= "walk_loop",
	stopwalk 	= "walk_pst",
})

return StateGraph("serenitycrab", states, events, "idle", actionhandlers)