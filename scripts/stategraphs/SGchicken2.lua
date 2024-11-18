local WALK_SPEED = 4
local RUN_SPEED = 2

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat_pre"),
	ActionHandler(ACTIONS.GOHOME, "gohome"),
}

local events =
{
    CommonHandlers.OnSleep(),
    CommonHandlers.OnHop(),		
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("trapped", function(inst) inst.sg:GoToState("trapped") end),
    EventHandler("locomote", function(inst) 
		if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then return end
            
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
			if not inst.sg:HasStateTag("hopping") then
				inst.sg:GoToState("hop")
			end
		end
	end),
}

local states =
{
    State
    {
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

    State
    {
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("glide", true)
            inst.components.locomotor:RunForward()
			
            inst.flapSound = inst:DoPeriodicTask(6 * FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/birds/flyin") 
			end)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        onexit = function(inst)
            if inst.flapSound then
                inst.flapSound:Cancel()
                inst.flapSound = nil
            end
        end, 
    },    
    
    State
    {
        name = "honk",
        tags = {"idle"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("honk")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
        end,

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State
    {
        name = "eat_pre",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("peck", false)
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events =
        {
            EventHandler("animover", function(inst, data)
				inst.sg:GoToState("eat")
			end),
        }
    },

    State
    {
        name = "eat",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat", true)
            inst.sg:SetTimeout(2 + math.random() * 4)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("eat_pst")
        end,
    },

    State
    {
        name = "eat_pst",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PushAnimation("eat_pst")
			
			-- Whatever, math.random does nothing here.
			-- if math.random() < 1.00 and not inst.components.timer:TimerExists("kyno_chicken_egg_cooldown") then
			if inst.components.playerprox:IsPlayerClose() and not inst.components.timer:TimerExists("kyno_chicken_egg_cooldown") then
				local x, y, z = inst.Transform:GetWorldPosition()
				local egg = SpawnPrefab("kyno_chicken_egg")
				egg.Transform:SetPosition(x, y, z)
				
				inst.components.timer:StartTimer("kyno_chicken_egg_cooldown", 480)
			end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	-- New states just to not mess up with the already existing ones.
	State
    {
        name = "eat_seeds",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat", true)
            inst.sg:SetTimeout(2 + math.random() * 4)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("eat_seeds_pst")
        end,
    },
	
	State
    {
        name = "eat_seeds_pst",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PushAnimation("eat_pst")
			
			local x, y, z = inst.Transform:GetWorldPosition()
			local egg = SpawnPrefab("kyno_chicken_egg")
			egg.Transform:SetPosition(x, y, z)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State
    {
        name = "hop",
        tags = {"moving", "canrotate", "hopping"},
        
        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst) 
                inst.Physics:Stop() 
                inst.SoundEmitter:PlaySound("dontstarve/rabbit/hop")
            end ),
        },
        
        onenter = function(inst) 
            inst.AnimState:PlayAnimation("hop")
            inst.components.locomotor:WalkForward()
            inst.sg:SetTimeout(2 * math.random() + 0.5)
        end,
        
        onupdate = function(inst)
            if not inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("idle")
            end
        end,        
        
        ontimeout = function(inst)
            inst.sg:GoToState("hop")
        end,
    },

    State
    {
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)        
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))   
        end,
    },

    State
    {
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },
	
	State{
        name = "trapped",
        tags = {"busy", "trapped"},

        onenter = function(inst)
            inst.Physics:Stop()
			inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(1)
        end,

        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },
}
CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)
CommonStates.AddHopStates(states, true, { pre = "hop", loop = "hop", pst = "hop"})
CommonStates.AddSimpleActionState(states, "GoHome", "hop", 4 * FRAMES, {"busy"})

return StateGraph("chicken2", states, events, "idle", actionhandlers)