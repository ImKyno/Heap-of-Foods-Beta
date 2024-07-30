require("stategraphs/commonstates")

local actionhandlers = {}

local events =
{
    EventHandler("putoutfire", function(inst, data) 
        if inst.components.machine:IsOn() then
            if inst.sg:HasStateTag("idle") then
                inst.sg:GoToState("spin_up", {firePos = data.firePos})
            elseif inst.sg:HasStateTag("shooting") then
                inst.sg:GoToState("shoot", {firePos = data.firePos})
            end
        end
    end)
}

local states =
{
    State
    {
        name = "turn_on",
        tags = {"idle"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/on")
            inst.AnimState:PlayAnimation("turn_on")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_on") end),
        }
    },

    State
    {
        name = "turn_off",
        tags = {"idle"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/off")
            inst.AnimState:PlayAnimation("turn_off")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_off") end),
        }
    },

    State
    {
        name = "idle_on",
        tags = {"idle"},

        onenter = function(inst)
            if not inst.SoundEmitter:PlayingSound("firesuppressor_idle") then
                inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/working", "firesuppressor_idle")
            end
            inst.AnimState:PlayAnimation("launch")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_on") end),
        }
    },

    State
    {
        name = "idle_off",
        tags = {"idle"},

        onenter = function(inst)
            inst.SoundEmitter:KillSound("firesuppressor_idle")
            inst.AnimState:PlayAnimation("idle_off", true)
        end,
    },

    State
    {
        name = "spin_up",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("launch_pre")
            inst.sg.statemem.data = data
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("shoot", inst.sg.statemem.data) end)
        },
    },

    State
    {  
        name = "shoot",
        tags = {"busy", "shooting"},

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("launch", true)
            inst.sg.statemem.firePos = data.firePos
        end,

        timeline =
        {
            TimeEvent(8*FRAMES,
            function(inst)
            end)
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("spin_down") end)
        },
    },

    State
    {
        name = "spin_down",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("launch_pst")
            inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/off")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_on") end)
        },
    },

    State
    {  
        name = "place",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("place")
        end,

        timeline = {},

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_on") end)
        },
    },

    State
    {  
        name = "hit",
        tags = {"busy"},

        onenter = function(inst, data)
            if inst.on then 
                inst.AnimState:PlayAnimation("hit_on")
            else
                inst.AnimState:PlayAnimation("hit_off")
            end
        end,

        timeline = {},

        events =
        {
            EventHandler("animover", function(inst) 
                if inst.on then 
                    inst.sg:GoToState("idle_on")
                else
                    inst.sg:GoToState("idle_off")
                end
            end)
        },
    },
}

return StateGraph("gardensprinkler", states, events, "idle_off", actionhandlers)