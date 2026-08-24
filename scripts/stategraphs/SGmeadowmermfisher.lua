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
	CommonHandlers.OnElectrocute(),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
	CommonHandlers.OnFallInVoid(),
	CommonHandlers.OnCorpseChomped(),

	EventHandler("attacked", function(inst, data)
		if inst.components.health ~= nil and not inst.components.health:IsDead() then
			if CommonHandlers.TryElectrocuteOnAttacked(inst, data) then
				return
			elseif not CommonHandlers.HitRecoveryDelay(inst, nil, TUNING.MERM_MAX_STUN_LOCKS)
			and (not inst.sg:HasStateTag("busy") or inst.sg:HasAnyStateTag("caninterrupt", "frozen")) then
				inst.sg:GoToState("hit")
			end
		end
	end),

	EventHandler("onmermkingcreated_anywhere", function(inst)
		inst.sg:GoToState("buff")
	end),

	EventHandler("onmermkingdestroyed_anywhere", function(inst)
		inst.sg:GoToState("debuff")
	end),
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
		tags = {"canrotate", "prefish", "fishing", "busy", "noelectrocute"},
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
		tags = {"canrotate", "fishing", "busy", "noelectrocute"},

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
		tags = {"canrotate", "fishing", "busy", "noelectrocute"},
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
		tags = {"canrotate", "fishing", "nibble", "busy", "noelectrocute"},
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
		tags = {"canrotate", "fishing", "busy", "noelectrocute"},
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
		tags = {"canrotate", "fishing", "catchfish", "busy", "noelectrocute"},
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

	State{
		name = "buff",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()

			if inst:HasTag("guard") then
				inst.AnimState:PlayAnimation("transform_pre")
			else
				inst.AnimState:PlayAnimation("buff")
			end

			local fx = SpawnPrefab("merm_splash")
			inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/buff")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end,

		timeline =
		{
			TimeEvent(9 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.buff)
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "debuff",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("debuff")
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "death",
		tags = { "busy" },

		onenter = function(inst)
			if inst.components.locomotor ~= nil then
				inst.components.locomotor:StopMoving()
			end

			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound(inst.sounds.death)

			if not inst.shadowthrall_parasite_hosted_death or not TheWorld.components.shadowparasitemanager then
				RemovePhysicsColliders(inst)
				inst:DropDeathLoot()
			end
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.shadowthrall_parasite_hosted_death and TheWorld.components.shadowparasitemanager then
					TheWorld.components.shadowparasitemanager:ReviveHosted(inst)
				elseif inst.AnimState:AnimDone() then
					inst.sg:GoToState("corpse")
				end
			end),
		},
	},

	State{
		name = "hit",
		tags = { "hit", "busy" },

		onenter = function(inst)
			if inst.components.locomotor ~= nil then
				inst.components.locomotor:StopMoving()
			end

			inst.AnimState:PlayAnimation("hit")
			inst._last_hitreact_time = GetTime()
		end,

		timeline =
		{
			TimeEvent(0 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.hit)
			end),
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

CommonStates.AddIdle(states)
CommonStates.AddSimpleState(states, "refuse", "pig_reject", { "busy" })
CommonStates.AddFrozenStates(states)
CommonStates.AddElectrocuteStates(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4 * FRAMES, {"busy"})
-- CommonStates.AddSimpleActionState(states, "eat", "eat", 10 * FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "fish", "fishing", 10 * FRAMES, {"busy"})
CommonStates.AddHopStates(states, true, { pre = "boat_jump_pre", loop = "boat_jump_loop", pst = "boat_jump_pst"})
CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)

CommonStates.AddParasiteReviveState(states)
CommonStates.AddInitState(states, "idle")
CommonStates.AddCorpseStates(states)

return StateGraph("kyno_meadowisland_mermfisher", states, events, "init", actionhandlers)