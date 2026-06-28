require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.GOHOME,  "gohome"),
	ActionHandler(ACTIONS.EAT,     "eat"),
	ActionHandler(ACTIONS.PICKUP,  "pickup"),
	ActionHandler(ACTIONS.EQUIP,   "pickup"),
	ActionHandler(ACTIONS.ADDFUEL, "pickup"),
}

local events =
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true,true),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnElectrocute(),
	CommonHandlers.OnAttack(),
	CommonHandlers.OnAttacked(nil, TUNING.BUNNYMAN_MAX_STUN_LOCKS),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
	CommonHandlers.OnFallInVoid(),
}

local states =
{
	State{
		name = "funnyidle",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()

			local leader = inst.components.follower:GetLeader()
			local is_roll_called = leader ~= nil and leader.components.leader ~= nil and leader.components.leader:IsRollCalling() or nil

			if inst.components.health:GetPercent() < TUNING.KYNO_ELDERMANDRAKE_PANIC_THRESHOLD then
				inst.AnimState:PlayAnimation("idle_angry")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/angry")
			elseif leader ~= nil and inst.components.follower:GetLoyaltyPercent() < .05 and not is_roll_called then
				inst.AnimState:PlayAnimation("hungry")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")
			elseif inst.components.combat:HasTarget() then
				inst.AnimState:PlayAnimation("idle_angry")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/angry")
			elseif leader ~= nil and (inst.components.follower:GetLoyaltyPercent() > .3 or is_roll_called) then
				inst.AnimState:PlayAnimation("idle_happy")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/happy")
			else
				inst.AnimState:PlayAnimation("idle_creepy")
				inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/creepy")
			end
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "happy",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()

			inst.AnimState:PlayAnimation("idle_happy")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/happy")
		end,

		timeline =
		{
			TimeEvent(4  * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(10 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(16 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(22 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(34 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(40 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(46 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),
			TimeEvent(52 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/clap") end),

		},

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

		onenter = function(inst, data)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/death")
			inst.AnimState:PlayAnimation("death")

			inst.Physics:Stop()

			inst.causeofdeath = data ~= nil and data.afflicter or nil

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
		name = "abandon",
		tags = { "busy" },

		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("abandon")

			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/angry")

			if leader ~= nil and leader:IsValid() then
				inst:FacePoint(leader:GetPosition())
			end
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "attack",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/eat")
			inst.components.combat:StartAttack()

			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
		end,

		timeline =
		{
			TimeEvent(13 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/bite")
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
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
		name = "eat",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat")

			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/eat")
		end,

		timeline =
		{
			TimeEvent(20 * FRAMES, function(inst)
				inst:PerformBufferedAction()
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
		name = "hit",
		tags = { "busy" },

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/hit")
			inst.AnimState:PlayAnimation("hit")

			inst.Physics:Stop()

			CommonHandlers.UpdateHitRecoveryDelay(inst)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

CommonStates.AddWalkStates(states,
{
	walktimeline =
	{
		TimeEvent(0 * FRAMES, PlayFootstep),

		TimeEvent(0 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/hop")
		end),

		TimeEvent(6 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/foley")
		end),
	},
}, nil, true)

CommonStates.AddRunStates(states,
{
	runtimeline =
	{
		TimeEvent(0 * FRAMES, PlayFootstep),

		TimeEvent(0 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/hop")
		end),

		TimeEvent(6 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/foley")
		end),
	},
}, nil, true)

CommonStates.AddSleepStates(states,
{
	sleeptimeline =
	{
		TimeEvent(35 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/sleep")
		end),
	},
})

CommonStates.AddIdle(states, "funnyidle")
CommonStates.AddSimpleState(states, "refuse", "pig_reject", { "busy" })
CommonStates.AddFrozenStates(states)
CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})
CommonStates.AddSimpleActionState(states, "pickup", "pig_pickup", 10 * FRAMES, { "busy" })
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4  * FRAMES, { "busy" })
CommonStates.AddHopStates(states, true, { pre = "run_pre", loop = "run_loop", pst = "run_pst"})
CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)
CommonStates.AddParasiteReviveState(states)

CommonStates.AddInitState(states, "idle")
CommonStates.AddCorpseStates(states)

return StateGraph("eldermandrake", states, events, "init", actionhandlers)