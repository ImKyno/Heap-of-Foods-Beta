require("stategraphs/commonstates")

local function SpawnSplash(inst, size, pos)
	local splashpos = Vector3(inst.Transform:GetWorldPosition())
    
	if pos then
		splashpos = pos
	end
	
	if not TheWorld.Map:IsVisualGroundAtPoint(splashpos.x,splashpos.y,splashpos.z) and not TheWorld.Map:GetPlatformAtPoint(splashpos.x,splashpos.z) then
		local prefab = "splash_green_large"
		
		if size == "med" then
			prefab = "splash_green"
		end
		
		local fx = SpawnPrefab("splash_green_large")
		fx.Transform:SetPosition(splashpos.x,splashpos.y,splashpos.z)
	end
end

local function SpawnWaves(inst, time)
    inst.SpawnWhaleWaves(inst, 2, 20, nil, nil, nil, nil, true)
end

local ATTACK_WAVE_SPEED = 4
local ATTACK_WAVE_IDLE_TIME = 1.5
local ANGLE_OFFSET = 35 * DEGREES

local function SpawnWhaleAttackWaves(inst)
	local position = inst:GetPosition()
	local angle = inst:GetRotation() + (math.random() * 20 - 10)

	local angle_rads = angle * DEGREES
	local offset_direction1 = Vector3(math.cos(angle_rads), 0, -math.sin(angle_rads)):Normalize()

	local point = position + (offset_direction1 * 3.5)
	local platform = TheWorld.Map:GetPlatformAtPoint(point.x,point.y,point.z)
	
	if platform then
		local theta = inst.Transform:GetRotation() * DEGREES
		local offset = Vector3(math.cos( theta ), 0, -math.sin( theta ))

        platform.components.boatphysics:ApplyForce(offset.x, offset.z, TUNING.KYNO_WHALE_BOAT_PUSH)

		if platform.components.hullhealth then
			platform.components.health:DoDelta(inst.hull_damage)
		end
		
		-- Cool fx and sound to let the player know the boat is being damaged.
		local fx = SpawnPrefab("kyno_swordfish_damage_fx")
		local fx_pos = position + (offset_direction1 * 1)

		if fx ~= nil then
			fx.Transform:SetPosition(fx_pos.x, fx_pos.y, fx_pos.z)
		end
			
		if platform.SoundEmitter ~= nil then
			platform.SoundEmitter:PlaySound("turnoftides/common/together/boat/damage")
		end
	elseif not TheWorld.Map:IsVisualGroundAtPoint(point.x,point.y,point.z) then
		SpawnSplash(inst, "med", point)

		SpawnAttackWave(position + offset_direction1, angle, {ATTACK_WAVE_SPEED, 0, 0}, nil, ATTACK_WAVE_IDLE_TIME, true)

		local offset_direction2 = Vector3(math.cos(angle_rads + ANGLE_OFFSET), 0, -math.sin(angle_rads + ANGLE_OFFSET)):Normalize() * 3
		SpawnAttackWave(position + offset_direction2, angle, {ATTACK_WAVE_SPEED, 0, -1}, nil, ATTACK_WAVE_IDLE_TIME, true)

		local offset_direction3 = Vector3(math.cos(angle_rads - ANGLE_OFFSET), 0, -math.sin(angle_rads - ANGLE_OFFSET)):Normalize() * 3
		SpawnAttackWave(position + offset_direction3, angle, {ATTACK_WAVE_SPEED, 0, 1}, nil, ATTACK_WAVE_IDLE_TIME, true)
	end
end

local events =
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(false, true),
	
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnElectrocute(),
	CommonHandlers.OnAttack(),
	
	EventHandler("death", function(inst)
		inst.sg:GoToState("death")
	end),
	
	EventHandler("attacked", function(inst, data)
		if not inst.components.health:IsDead() then
			if CommonHandlers.TryElectrocuteOnAttacked(inst, data) then
				return
		elseif not (inst.sg:HasAnyStateTag("attack", "electrocute")) then
			inst.sg:GoToState("hit")
		end
	end
end),
}

local states =
{
	State{
		name = "idle",
		tags = { "idle", "canrotate" },
		
		onenter = function(inst, pushanim)
			inst.components.locomotor:StopMoving()
			
			inst.AnimState:PlayAnimation("idle", true)
			inst.sg:SetTimeout(2 + 2 * math.random())
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle_loop") end),
		},
	},

	State{
		name = "idle_loop",
		tags = { "idle", "canrotate" },

		timeline =
		{
			TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.idle) end),
			TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.idle) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle_loop") end),
		},
	},

	State{
		name = "attack",
		tags = { "busy", "attack", "canrotate", "splash_attack" },
		
		onenter = function(inst)
			inst.components.combat:StartAttack()
			inst.components.locomotor:StopMoving()
			
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
		end,

		timeline =
		{
			TimeEvent(11 * FRAMES, function(inst)
				if inst.components.combat.target then 
					inst:ForceFacePoint(inst.components.combat.target:GetPosition()) 
				end
				
				inst.SoundEmitter:PlaySound(inst.sounds.mouth_open)
			end),
			
			TimeEvent(25 * FRAMES, function(inst)
				if inst.components.combat.target then 
					inst:ForceFacePoint(inst.components.combat.target:GetPosition()) 
				end
				
				SpawnWhaleAttackWaves(inst)
				inst.components.combat:DoAttack()
				
				inst.SoundEmitter:PlaySound(inst.sounds.bite_chomp)
				inst.SoundEmitter:PlaySound(inst.sounds.bite)
			end),
		},

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
	
	State{
		name = "death",
		tags = { "busy" },
		
		onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.death)
			inst.AnimState:PlayAnimation("death")
			inst.components.locomotor:StopMoving()
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) SpawnAt(inst.carcass, inst) end),
		},
	},

	State{
		name = "walk_start",
		tags = { "moving", "canrotate" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("walk_pre")
		end,

		timeline =
		{
			TimeEvent(12 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/large") end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
		},
	},

	State{
		name = "walk",
		tags = { "moving", "canrotate" },
		
		onenter = function(inst)
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("walk_loop")
		end,

		timeline =
		{
			TimeEvent(15 * FRAMES, function(inst)
				inst.components.locomotor:WalkForward()
				
				inst.SoundEmitter:PlaySound(inst.sounds.breach_swim)
				inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/water_swimbreach_lrg")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
		},
	},

	State{
		name = "walk_stop",
		tags = { "canrotate" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
		end,

		timeline =
		{
			TimeEvent(15 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.breach_swim)
				inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/water_swimbreach_lrg")
			end),
		},

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("walk_stop_emerge") end),
		},
	},

	State{
		name = "walk_stop_emerge",
		tags = { "canrotate" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("walk_pst", false)
		end,

		timeline =
		{
			TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/water_emerge_lrg") end),
			TimeEvent(15 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/large") end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddSimpleState(states, "hit", "hit")
CommonStates.AddSleepStates(states,
{
	sleeptimeline =
	{
		TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end)
	},
})

CommonStates.AddFrozenStates(states)
CommonStates.AddElectrocuteStates(states, nil, { pre = "hit", loop = "hit", pst = "hit"})

return StateGraph("whaleocean", states, events, "idle")