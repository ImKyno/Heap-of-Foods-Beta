require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.FISH, "fishing_pre"),
}


local events =
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states =
{
	State{

        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,

    },

    State{
        name = "fishing_pre",
        tags = {"canrotate", "prefish", "fishing", "busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("fish_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("fishing")
            end),
        },
    },

    State{
        name = "fishing",
        tags = {"canrotate", "fishing", "busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("fish_loop", true)
            inst.components.fishingrod:WaitForFish()
        end,

        events =
        {
            EventHandler("fishingnibble", function(inst) inst.sg:GoToState("fishing_nibble") end),
            EventHandler("fishingloserod", function(inst) inst.sg:GoToState("loserod") end),
        },
    },

    State{
        name = "fishing_pst",
        tags = {"canrotate", "fishing", "busy"},
        onenter = function(inst)
            -- inst.AnimState:PushAnimation("fish_loop", true)
            inst.AnimState:PlayAnimation("fish_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "fishing_nibble",
        tags = {"canrotate", "fishing", "nibble", "busy"},
        onenter = function(inst)
            inst.AnimState:PushAnimation("fish_loop", true)
            if inst.components.fishingrod.target.components.fishable.fishleft > 0 then
                inst.components.fishingrod:Hook()
            else
                inst.sg:GoToState("fishing_pst")
            end
        end,

        events =
        {
            EventHandler("fishingstrain", function(inst) inst.sg:GoToState("fishing_strain") end),
        },
    },

    State{
        name = "fishing_strain",
        tags = {"canrotate", "fishing", "busy"},
        onenter = function(inst)
            inst.components.fishingrod:Reel()
        end,

        events =
        {
            EventHandler("fishingcatch", function(inst, data)
                inst.sg:GoToState("catchfish", data.build)
            end),

            EventHandler("fishingloserod", function(inst)
                -- inst.sg:GoToState("loserod")
                inst.sg:GoToState("fishing_pst")
            end),
        },
    },
	
	State{
        name = "catchfish",
        tags = {"canrotate", "fishing", "catchfish", "busy"},
        onenter = function(inst, build)
            inst.AnimState:PlayAnimation("fishcatch")
            inst.AnimState:OverrideSymbol("fish01", build, "fish01")
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("hof_sounds/creatures/mermfisher/whoosh_throw")
            end),
            TimeEvent(14 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("hof_sounds/creatures/mermfisher/spear_water")
            end),
            TimeEvent(34 * FRAMES, function(inst)
                inst.components.fishingrod:Collect()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:RemoveStateTag("fishing")
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("fish01")
        end,
    },
	
	State{
        name = "eat",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("eat")

			local buffaction = inst:GetBufferedAction()
			inst.sg.statemem.item = buffaction ~= nil and buffaction.target or nil -- Don't care about validity.
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst:PerformBufferedAction()

                if inst.sg.statemem.item ~= nil then
                    inst:TestForLunarMutation(inst.sg.statemem.item)
                end
            end),
            TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/eat") end),
            TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
            TimeEvent(21 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
}

CommonStates.AddWalkStates(states,
{
	walktimeline = 
	{
		TimeEvent(0 * FRAMES, PlayFootstep),
		TimeEvent(12 * FRAMES, PlayFootstep),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = 
	{
		TimeEvent(0 * FRAMES, PlayFootstep),
		TimeEvent(10 * FRAMES, PlayFootstep),
	},
})

CommonStates.AddSleepStates(states,
{
	sleeptimeline = 
	{
		TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep") end),
	},
})

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") end),
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
        TimeEvent(16 * FRAMES, function(inst) inst.components.combat:DoAttack() end),
    },
    hittimeline = 
    {
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/hurt") end),
    },
    deathtimeline = 
    {
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death") end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4 * FRAMES, {"busy"})
-- CommonStates.AddSimpleActionState(states, "eat", "eat", 10 * FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "fish", "fishing", 10 * FRAMES, {"busy"})
CommonStates.AddFrozenStates(states)

return StateGraph("mermfisher", states, events, "idle", actionhandlers)