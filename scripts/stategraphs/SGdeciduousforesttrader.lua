require("stategraphs/commonstates")

local TALKING_SOUNDS =
{
	"dontstarve/pig/attack",
	"dontstarve/pig/oink",
	"dontstarve/pig/grunt",
}

local PlayTalkingSound = TALKING_SOUNDS[math.random(#TALKING_SOUNDS)]

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

	EventHandler("refusemerm", function(inst)
		if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("refusing") then
			inst.sg:GoToState("refuse_merm")
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
			if inst:IsAsleep() then
				return
			end

			if inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("refusing") then
				return
			end

			if inst.sg.mem.trading then
				inst.sg:GoToState("trading_start")
				return
			end

			if not inst:IsNearPlayer(TUNING.RESEARCH_MACHINE_DIST, true) then
				inst:EnablePrototyper(false)
				inst.sg.mem.refusedmerm = nil
				inst.sg.mem.refusedrundown = nil
				return
			end

			local merm = inst:IsNearMerm()

			if merm then
				if not inst.sg.mem.refusedmerm then
					inst.sg.mem.refusedmerm = true

					inst:PushEvent("refusemerm")

					inst:DoTaskInTime(10, function()
						if inst:IsValid() then
							inst.sg.mem.refusedmerm = nil
						end
					end)
				end
			else
				inst.sg.mem.refusedmerm = nil
			end

			if not inst:CanTrade() and not merm then
				inst:EnablePrototyper(false)

				if not inst.sg.mem.refusedrundown then
					inst.sg.mem.refusedrundown = true
					inst.sg:GoToState("refuse_rundown")
				end

				return
			end

			inst.sg.mem.refusedrundown = nil

			inst:EnablePrototyper(true)
			inst.sg:GoToState("trading_start")
		end,
	},

	State{
		name = "trading_start",
		tags = { "canrotate", "revealed" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("trade_start")
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
				if inst:CanChatter() then
					inst:TryChatter("DECIDUOUSFORESTTRADER_STARTTRADING", math.random(#STRINGS.DECIDUOUSFORESTTRADER_STARTTRADING), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound) -- Culprit.
				end
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
				inst:TryChatter("DECIDUOUSFORESTTRADER_ENDTRADING_MADETRADE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_ENDTRADING_MADETRADE), 1.5)
				inst.sg.mem.didtrade = nil
				inst.SoundEmitter:PlaySound(PlayTalkingSound)
			else
				inst:TryChatter("DECIDUOUSFORESTTRADER_ENDTRADING_NOTRADES", math.random(#STRINGS.DECIDUOUSFORESTTRADER_ENDTRADING_NOTRADES), 1.5)
				inst.SoundEmitter:PlaySound(PlayTalkingSound)
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
		name = "dotrade",
		tags = { "busy", "revealed" },

		onenter = function(inst, data)	
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("pig_take")

			if data and data.no_stock then
				inst:DoChatter("DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound(PlayTalkingSound)
			else
				if not inst.sg.mem.didtrade then
					inst:DoChatter("DECIDUOUSFORESTTRADER_DOTRADE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_DOTRADE), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
				else
					inst:TryChatter("DECIDUOUSFORESTTRADER_DOTRADE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_DOTRADE), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
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
				inst:DoChatter("DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound(PlayTalkingSound)
			else
				if not inst.sg.mem.didtrade then
					inst:DoChatter("DECIDUOUSFORESTTRADER_DOTRADEHAT", math.random(#STRINGS.DECIDUOUSFORESTTRADER_DOTRADEHAT), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
				else
					inst:TryChatter("DECIDUOUSFORESTTRADER_DOTRADEHAT", math.random(#STRINGS.DECIDUOUSFORESTTRADER_DOTRADEHAT), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
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
		tags = { "busy", "revealed", "refusing" },

		onenter = function(inst, data)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("pig_reject")

			if data and data.no_stock then
				inst:DoChatter("DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES", math.random(#STRINGS.DECIDUOUSFORESTTRADER_OUTOFSTOCK_FROMTRADES), 15)
				inst.SoundEmitter:PlaySound(PlayTalkingSound)
			else
				if not inst.sg.mem.didtrade then
					inst:DoChatter("DECIDUOUSFORESTTRADER_REFUSE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
				else
					inst:TryChatter("DECIDUOUSFORESTTRADER_REFUSE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE), 1.5)
					inst.SoundEmitter:PlaySound(PlayTalkingSound)
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
		name = "refuse_rundown",
		tags = { "busy", "revealed", "refusing" },

		onenter = function(inst, data)

			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_creepy")

			inst:TryChatter("DECIDUOUSFORESTTRADER_REFUSE_RUNDOWN", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE_RUNDOWN), 5)
			inst.SoundEmitter:PlaySound(PlayTalkingSound)

			inst:SetRevealed(true)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
				inst.sg:GoToState("idle")
			end),
		},

		onexit = function(inst)
			if not inst.sg.statemem.keeprevealed then
				inst:SetRevealed(false)
			end
		end,
	},

	State{
		name = "refuse_merm",
		tags = { "busy", "revealed", "refusing" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_angry")

			inst:TryChatter("DECIDUOUSFORESTTRADER_REFUSE_MERM", math.random(#STRINGS.DECIDUOUSFORESTTRADER_REFUSE_MERM), 10)
			inst.SoundEmitter:PlaySound("dontstarve/pig/attack")

			inst:SetRevealed(true)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg.statemem.keeprevealed = true
				inst.sg:GoToState("idle") -- Let this state get out of trading.
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

			inst:TryChatter("DECIDUOUSFORESTTRADER_STARTDANCING", math.random(#STRINGS.DECIDUOUSFORESTTRADER_STARTDANCING), 1.5)

			inst.AnimState:PlayAnimation("idle_happy")
			inst.SoundEmitter:PlaySound(PlayTalkingSound)
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

	State{
		name = "appreciate",
		tags = { "busy", "revealed" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_happy", true)

			inst:TryChatter("DECIDUOUSFORESTTRADER_APPRECIATE", math.random(#STRINGS.DECIDUOUSFORESTTRADER_APPRECIATE), 10)
			inst.SoundEmitter:PlaySound(PlayTalkingSound)

			inst:SetRevealed(true)

			inst.sg.statemem.exit_task = inst:DoTaskInTime(3, function()
				if inst.sg.currentstate.name == "appreciate" then
					inst.sg.statemem.keeprevealed = true
					inst.sg:GoToState("idle") -- Let this state get out of trading.
				end
			end)
		end,

		onexit = function(inst)
			if inst.sg.statemem.exit_task ~= nil then
				inst.sg.statemem.exit_task:Cancel()
			end

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

return StateGraph("deciduousforesttrader", states, events, "idle", actionhandlers)