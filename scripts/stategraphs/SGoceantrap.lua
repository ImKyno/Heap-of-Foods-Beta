local function TrapHasLoot(inst)
	return inst.components.trap ~= nil and (
	(inst.components.trap.lootprefabs ~= nil and next(inst.components.trap.lootprefabs) ~= nil)
	or (inst.components.trap.captured_fish ~= nil and inst.components.trap.captured_fish:IsValid()))
end

local events =
{
	EventHandler("ondropped", function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local onland = TheWorld.Map:IsPassableAtPoint(x, y, z)
		
		inst.sg:GoToState(onland and "idle_ground" or "idle")
	end),
}

local states =
{
	State{
		name = "idle_ground",

		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle")
			inst.SoundEmitter:PlaySound("hof_sounds/common/oceantrap/drop_ground")
		end,
    },

	State{
		name = "idle",
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.components.trap.bait and "idle_baited" or "idle_water", true)
			inst.SoundEmitter:PlaySound("hof_sounds/common/oceantrap/drop_water")
		end,

		events =
		{
			EventHandler("springtrap", function(inst, data)
				if data ~= nil and data.loading then
					inst.sg:GoToState(TrapHasLoot(inst) and "full" or "empty")
				elseif inst.entity:IsAwake() then
					inst.sg:GoToState("sprung")
				else
					inst.components.trap:DoSpring()
					inst.sg:GoToState(TrapHasLoot(inst) and "full" or "empty")
				end
			end),

			EventHandler("baited", function(inst) inst.AnimState:PlayAnimation("idle_baited", true) end),
			EventHandler("removed_bait", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "full",
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("trap_loop", true)
		end,

		events =
		{
			EventHandler("harvesttrap", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "empty",
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("side", true)
			inst.AnimState:HideSymbol("trapped")
		end,

		events =
		{
			EventHandler("harvesttrap", function(inst) inst.sg:GoToState("idle") end),
		},
		
		onexit = function(inst)
			inst.AnimState:ShowSymbol("trapped")
		end,
	},

	State{
		name = "sprung",
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation(inst.components.trap.bait and "trap_baited_pre" or "trap_pre")
		end,

		timeline =
		{
			TimeEvent(13 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/common/oceantrap/drop_water") end),
			TimeEvent(15 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/common/oceantrap/drop_ground") end),
            TimeEvent(17 * FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("hof_sounds/common/oceantrap/captured")
				inst.components.trap:DoSpring()
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState(TrapHasLoot(inst) and "full" or "empty")
			end),
		},
	},
}

return StateGraph("oceantrap", states, events, "idle")