require("stategraphs/commonstates")

local events =
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnElectrocute(),
	CommonHandlers.OnLocomote(false, true),
	
	EventHandler("attacked", function(inst, data)
		if not inst.components.health:IsDead() then
			if CommonHandlers.TryElectrocuteOnAttacked(inst, data) then
				return
			elseif not inst.sg:HasStateTag("electrocute") then
				inst.sg:GoToState("hit")
				inst.SoundEmitter:PlaySound(inst.sounds.hurt)
			end
		end
	end),
	
	EventHandler("death", function(inst)
		inst.sg:GoToState("death")
	end),
	
	EventHandler("doattack", function(inst, data)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("electrocute") then
			inst.sg:GoToState("fireattack", data.target)
		end
	end),
}

local function SetContainerCanBeOpened(inst, canbeopened)
	if canbeopened then
		if inst.components.container ~= nil then
			inst.components.container.canbeopened = true
		elseif inst.components.container_proxy ~= nil and inst.components.container_proxy:GetMaster() ~= nil then
			inst.components.container_proxy:SetCanBeOpened(true)
		end
	elseif inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = false
	elseif inst.components.container_proxy ~= nil then
		inst.components.container_proxy:Close()
		inst.components.container_proxy:SetCanBeOpened(false)
	end
end

local states =
{
	State{
		name = "idle",
		tags = { "idle", "canrotate" },
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		timeline =
		{
			TimeEvent(2  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(27 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "death",
		tags = { "busy" },

		onenter = function(inst)
			SetContainerCanBeOpened(inst, false)
			
			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
			end

			inst.SoundEmitter:PlaySound(inst.sounds.death)

			inst.AnimState:PlayAnimation("death")
			
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
		end,
		
		timeline =
		{
			TimeEvent(6 * FRAMES, function(inst)
				if inst.PackimState == "FAT" then
					inst.SoundEmitter:PlaySound(inst.sounds.fat_death_spin)
				end
			end),
		},
	},

	State{
		name = "open",
		tags = { "busy", "open" },
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("open")
		end,

		timeline =
		{
			TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.open) end),
			TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end),
		},
	},

	State{
		name = "open_idle",
		tags = { "busy", "open" },
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle_loop_open")

			if not inst.sg.mem.pant_ducking or inst.sg:InNewState() then
				inst.sg.mem.pant_ducking = 1
			end
		end,

		timeline =
		{
			TimeEvent(3  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(27 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end),
		},
	},

	State{
		name = "close",
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("closed")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline =
		{
			TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.close) end),
			TimeEvent(5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},
	},

	State{
		name = "swallow",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()

			SetContainerCanBeOpened(inst, false)
			inst.components.sleeper:WakeUp()
			
			inst.AnimState:PlayAnimation("swallow")
		end,

		onexit = function(inst)
			SetContainerCanBeOpened(inst, true)
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline =
		{
			TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swallow) end),
			TimeEvent(2  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(9  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(36 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},
	},

	State{
		name = "transform",
		tags = { "busy", "noelectrocute" },
		
		onenter = function(inst, swallowed)
			inst.Physics:Stop()

			SetContainerCanBeOpened(inst, false)
			inst.components.sleeper:WakeUp()
			
			if swallowed then
				inst.SoundEmitter:PlaySound(inst.sounds.swallow)
				inst.AnimState:PlayAnimation("swallow", false) 
			else
				inst.sg:GoToState("transform_stage2")
			end
		end,

		onexit = function(inst)
			SetContainerCanBeOpened(inst, true)
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("transform_stage2") end),
		},
	},

	State{
		name = "transform_stage2",
		tags = { "busy", "noelectrocute" },

		onenter = function(inst)
			inst.Physics:Stop()

			SetContainerCanBeOpened(inst, false)
			inst.components.sleeper:WakeUp()
			
			inst.AnimState:PlayAnimation("transform", false)
			inst.AnimState:PushAnimation("transform_pst", false)
			
			inst.SoundEmitter:PlaySound(inst.sounds.transform)
			inst.SoundEmitter:PlaySound(inst.sounds.trasnform_stretch)
		end,

		onexit = function(inst)
			SetContainerCanBeOpened(inst, true)
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline = 
		{
			TimeEvent(30*FRAMES, function(inst)
				if inst.MorphPackimBaggims then
					inst:MorphPackimBaggims()
				end

				inst.SoundEmitter:PlaySound(inst.sounds.transform_pop)
			end)
		},
	},

	State{
		name = "hit",
		tags = { "busy" },
		
		onenter = function(inst)
			if inst.components.locomotor then
				inst.components.locomotor:StopMoving()
			end
			
			inst.AnimState:PlayAnimation("hit")
		end,

		timeline =
		{
			TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddWalkStates(states,
{
	starttimeline = 
	{
		TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	
	walktimeline = 
	{
		TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(3  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(18 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(19 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(27 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	
	endtimeline = 
	{
		TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

CommonStates.AddSleepStates(states,
{
	starttimeline =
	{
		TimeEvent(2  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(17 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(32 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
	},
	
	sleeptimeline =
	{
		TimeEvent(1  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(29 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(45 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(34 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
	},
	
	waketimeline =
	{
		TimeEvent(1  * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(22 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(23 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(26 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(34 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"},
{
	loop_onenter = function(inst)
		SetContainerCanBeOpened(inst, false)
	end,
	
	loop_onexit = function(inst)
		if not inst.sg.statemem.not_interrupted then
			SetContainerCanBeOpened(inst, true)
		end
	end,
	
	pst_onexit = function(inst)
		SetContainerCanBeOpened(inst, true)
	end,
})

return StateGraph("packimbaggims", states, events, "idle")