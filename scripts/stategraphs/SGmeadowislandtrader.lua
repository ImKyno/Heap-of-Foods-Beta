require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.GOHOME, "gohome"),
}

local events = 
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnHop(),
    CommonHandlers.OnSink(),
    CommonHandlers.OnFallInVoid(),
	
    EventHandler("dotrade", function(inst, data)
        if not inst.sg:HasStateTag("busy") then
			inst.sg.statemem.keeprevealed = true
            inst.sg:GoToState("dotrade", data)
        end
    end),
	
	EventHandler("dotradehat", function(inst, data)
        if not inst.sg:HasStateTag("busy") then
			inst.sg.statemem.keeprevealed = true
            inst.sg:GoToState("dotradehat", data)
        end
    end),
	
	EventHandler("dance", function(inst)
		if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("dancing") then
			inst.sg:GoToState("dance_start")
		end
	end),
}

local states = 
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        onupdate = function(inst)
			if not inst:IsAsleep() then
				if inst.sg.mem.trading then
					inst.sg:GoToState("trading_start")
				elseif inst:HasStock() and inst:IsNearPlayer(TUNING.RESEARCH_MACHINE_DIST, true) then
					inst:EnablePrototyper(true)
					inst.sg:GoToState("trading_start")
				end
			end
        end,
    },

    State{
        name = "trading_start",
		tags = { "canrotate", "revealed" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("trade_start") -- idle_creepy
			inst:SetRevealed(true)
        end,
		
        events = 
		{
			EventHandler("animover", function(inst)
                if inst.AnimState:IsCurrentAnimation("trade_start") then
                    if inst.sg.mem.trading then
                        inst.AnimState:PlayAnimation("trade_pre")
                    else
                        inst.AnimState:PlayAnimation("idle_loop")
                    end
                elseif inst.AnimState:IsCurrentAnimation("trade_pre") then
					inst.sg.statemem.keeprevealed = true
					
                    if inst.sg.mem.trading then
                        inst.sg:GoToState("trading")
                    else
                        inst.sg:GoToState("trading_stop")
                    end
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
    State{
        name = "trading",
		tags = { "canrotate", "revealed" },

        onenter = function(inst, data)
            if data == nil or not data.repeating then
                inst:TryChatter("MEADOWISLANDTRADER_STARTTRADING", math.random(#STRINGS.MEADOWISLANDTRADER_STARTTRADING), 1.5)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            end
			
            inst.components.locomotor:StopMoving()
			
			inst.AnimState:PlayAnimation("trade_loop")
			inst:SetRevealed(true)
        end,
		
        onupdate = function(inst)
            if not inst.sg.mem.trading then
                inst.sg:GoToState("trading_stop")
            end
        end,
		
        events = 
		{
            EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
				
                if inst.sg.mem.trading then
                    inst.sg:GoToState("trading", {repeating = true,})
                else
                    inst.sg:GoToState("trading_stop")
                end
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
    State{
        name = "trading_stop",
		tags = { "canrotate", "revealed" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("trade_pst")
			
            if inst.sg.mem.didtrade then
                inst:TryChatter("MEADOWISLANDTRADER_ENDTRADING_MADETRADE", math.random(#STRINGS.MEADOWISLANDTRADER_ENDTRADING_MADETRADE), 1.5)
                inst.sg.mem.didtrade = nil
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            else
                inst:TryChatter("MEADOWISLANDTRADER_ENDTRADING_NOTRADES", math.random(#STRINGS.MEADOWISLANDTRADER_ENDTRADING_NOTRADES), 1.5)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            end
			
			inst:SetRevealed(true)
        end,
		
        events = 
		{
            EventHandler("animover", function(inst)
                if inst.AnimState:IsCurrentAnimation("trade_pst") then
                    if inst.sg.mem.trading then
                        inst.AnimState:PlayAnimation("trade_pre")
                    else
                        inst.AnimState:PlayAnimation("idle_loop") -- idle_creepy
                    end
                elseif inst.AnimState:IsCurrentAnimation("trade_pre") then
					inst.sg.statemem.keeprevealed = true
                    if inst.sg.mem.trading then
                        inst.sg:GoToState("trading")
                    else
                        inst.sg:GoToState("trading_stop")
                    end
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
    State{
        name = "dotrade",
		tags = { "busy", "revealed" },
		
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pig_take")
			
            if data and data.no_stock then
                inst:DoChatter("MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            else
                if not inst.sg.mem.didtrade then
                    inst:DoChatter("MEADOWISLANDTRADER_DOTRADE", math.random(#STRINGS.MEADOWISLANDTRADER_DOTRADE), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                else
                    inst:TryChatter("MEADOWISLANDTRADER_DOTRADE", math.random(#STRINGS.MEADOWISLANDTRADER_DOTRADE), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                end
            end
			
			inst:SetRevealed(true)
        end,
		
        events = 
		{
            EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
                inst.sg:GoToState("trading") -- Let this state get out of trading.
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
	State{
        name = "dotradehat",
		tags = { "busy", "revealed" },
		
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pig_take")
			inst.sg.mem.didtrade = true -- Count this as a trade.
			
			if data and data.no_stock then
                inst:DoChatter("MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            else
                if not inst.sg.mem.didtrade then
                    inst:DoChatter("MEADOWISLANDTRADER_DOTRADEHAT", math.random(#STRINGS.MEADOWISLANDTRADER_DOTRADEHAT), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                else
                    inst:TryChatter("MEADOWISLANDTRADER_DOTRADEHAT", math.random(#STRINGS.MEADOWISLANDTRADER_DOTRADEHAT), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                end
            end
			
			inst:SetHatless(true)
			inst:SetRevealed(true)
        end,
		
        events = 
		{
            EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
                inst.sg:GoToState("trading") -- Let this state get out of trading.
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
	State{
        name = "refuse",
		tags = { "busy", "revealed" },
		
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pig_reject")
			
			if data and data.no_stock then
                inst:DoChatter("MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.MEADOWISLANDTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            else
                if not inst.sg.mem.didtrade then
                    inst:DoChatter("MEADOWISLANDTRADER_REFUSE", math.random(#STRINGS.MEADOWISLANDTRADER_REFUSE), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                else
                    inst:TryChatter("MEADOWISLANDTRADER_REFUSE", math.random(#STRINGS.MEADOWISLANDTRADER_REFUSE), 1.5)
					inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
                end
            end

			inst:SetRevealed(true)
        end,
		
        events = 
		{
            EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
                inst.sg:GoToState("trading") -- Let this state get out of trading.
            end),
        },
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
	State{
		name = "dance_start",
		tags = { "idle", "revealed", "dancing" },

        onenter = function(inst)
			inst.Physics:Stop()
			inst:ClearBufferedAction()
			
			inst:TryChatter("MEADOWISLANDTRADER_STARTDANCING", math.random(#STRINGS.MEADOWISLANDTRADER_STARTDANCING), 1.5)
			
			inst.AnimState:PlayAnimation("idle_happy")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("dance_loop")
            end),
		},
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
    },
	
	State{
		name = "dance_loop",
		tags = { "idle", "revealed", "dancing" },

        onenter = function(inst)
			inst.Physics:Stop()
			inst:ClearBufferedAction()
			
			inst.AnimState:PlayAnimation("idle_happy", true)
		end,
		
		events =
		{
			EventHandler("animover", function(inst)
				if inst.sg.mem.dancing then
					inst.sg:GoToState("dance_loop")
				else
					inst.sg:GoToState("idle")
				end
            end),
		},
		
		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
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

CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_take", 4 * FRAMES, { "busy" })

return StateGraph("meadowislandtrader", states, events, "idle", actionhandlers)