local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EQUIPSLOTS    = _G.EQUIPSLOTS
local EventHandler  = _G.EventHandler
local FRAMES        = _G.FRAMES
local State         = _G.State
local TimeEvent     = _G.TimeEvent
local FrameEvent    = _G.FrameEvent
local POPUPS        = _G.POPUPS
local PlayFootstep  = _G.PlayFootstep
local UpvalueHacker = require("tools/hof_upvaluehacker")

require("stategraphs/commonstates")

local function ClearStatusAilments(inst)
	if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
		inst.components.freezable:Unfreeze()
	end

	if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
		inst.components.pinnable:Unstick()
	end
end

local function ForceStopHeavyLifting(inst)
	if inst.components.inventory:IsHeavyLifting() then
		inst.components.inventory:DropItem(inst.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
	end
end

local function IsMinigameItem(inst)
	return inst:HasTag("minigameitem")
end

-- New Stategraphs.
AddStategraphState("wilson",
	State{
		name = "brewbook_open",
		tags = { "doing" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:OverrideSymbol("book_cook", "kyno_brewbook", "book_brew")
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("reading_in", false)
			inst.AnimState:PushAnimation("reading_loop", true)
		end,

		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
		},

		onupdate = function(inst)
			if not CanEntitySeeTarget(inst, inst) then
				inst.sg:GoToState("brewbook_close")
			end
		end,

		events =
		{
			EventHandler("ms_closepopup", function(inst, data)
				if data.popup == POPUPS.BREWBOOK then
					inst.sg:GoToState("brewbook_close")
				end
			end),
		},

		onexit = function(inst)
			inst:ShowPopUp(POPUPS.BREWBOOK, false)
		end
	}
)

AddStategraphState("wilson",
	State{
		name = "brewbook_close",
		tags = { "idle", "nodangle" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("reading_pst")
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and "item_out" or "idle")
				end
			end),
		},
	}
)

AddStategraphState("wilson_client",
	State{
		name = "brewbook_open",
		tags = { "doing" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("action_uniqueitem_lag", false)

			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(2)
		end,

		onupdate = function(inst)
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,

		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end,
	}
)

AddStategraphState("wilson",
	State{
		name = "pickable_tall",
		tags = { "doing", "busy", "nodangle" },

		onenter = function(inst, timeout)
			if timeout == nil then
				timeout = 1
			elseif timeout > 1 then
				inst.sg:AddStateTag("slowaction")
			end

			inst.sg:SetTimeout(inst:HasTag("fasthands") and 0.3 or timeout)
			inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")

			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil then
				inst.sg.statemem.dohighaction = (inst.bufferedaction.target:HasTag("pickable_tall")
				and not inst.components.rider:IsRiding()) or false
			end

			inst.AnimState:PlayAnimation(inst.sg.statemem.dohighaction and "construct_pre" or "build_pre")
			inst.AnimState:PushAnimation(inst.sg.statemem.dohighaction and "construct_loop" or "build_loop", true)

			if inst.bufferedaction ~= nil then
				inst.sg.statemem.action = inst.bufferedaction

				if inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
					inst.bufferedaction.target:PushEvent("startlongaction", inst)
				end
			end
		end,

		timeline =
		{
			TimeEvent(3 * FRAMES, function(inst)
				if inst.sg.statemem.delayed then
					inst.sg:RemoveStateTag("busy")
				end
			end),
		},

		ontimeout = function(inst)
			inst.SoundEmitter:KillSound("make")
			inst.AnimState:PlayAnimation(inst.sg.statemem.dohighaction and "construct_pst" or "build_pst")

			inst.sg:RemoveStateTag("busy")
			inst:PerformBufferedAction()
		end,

		events =
		{
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},

		onexit = function(inst)
			inst.SoundEmitter:KillSound("make")

			if inst.bufferedaction == inst.sg.statemem.action
			and (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
				inst:ClearBufferedAction()
			end
		end,
	}
)

AddStategraphState("wilson_client",
	State{
		name = "pickable_tall",
		tags = { "doing", "busy", "nodangle" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make_preview")

			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil then
				local rider = inst.replica.rider
				inst.sg.statemem.dohighaction = (inst.bufferedaction.target:HasTag("high_dolongaction") and (rider == nil or not rider:IsRiding())) or false
            end

			inst.AnimState:PlayAnimation(inst.sg.statemem.dohighaction and "construct_pre" or "build_pre")
			inst.AnimState:PushAnimation(inst.sg.statemem.dohighaction and "construct_loop" or "build_loop", true)

			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(inst:HasTag("fasthands") and 0.3 or 1)
		end,

		timeline =
		{
			TimeEvent(3 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},

		onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.AnimState:PlayAnimation(inst.sg.statemem.dohighaction and "construct_pst" or "build_pst")
				inst.sg:GoToState("idle", true)
			end
		end,

		ontimeout = function(inst)
			inst:ClearBufferedAction()

			inst.AnimState:PlayAnimation(inst.sg.statemem.dohighaction and "construct_pst" or "build_pst")
			inst.sg:GoToState("idle", true)
		end,

		onexit = function(inst)
			inst.SoundEmitter:KillSound("make_preview")
		end,
	}
)

AddStategraphState("wilson",
	State{
		name = "fishregistry_open",
		tags = { "doing" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("idle_loop", true)
		end,

		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
		},

		onupdate = function(inst)
			if not _G.CanEntitySeeTarget(inst, inst) then
				inst.sg:GoToState("fishregistry_close")
			end
		end,

		events =
		{
			EventHandler("ms_closepopup", function(inst, data)
				if data.popup == POPUPS.FISHREGISTRY then
					inst.sg:GoToState("fishregistry_close")
				end
			end),
		},

		onexit = function(inst)
			inst:ShowPopUp(POPUPS.FISHREGISTRY, false)
		end,
	}
)

AddStategraphState("wilson",
	State{
		name = "fishregistry_close",
		tags = { "idle", "nodangle" },

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.sg:GoToState(inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS) ~= nil and "item_out" or "idle")
		end,
	}
)

-- Klei made sharks don't actually eat food, they just remove it from the scene...
local function PlayGroundSound(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	if inst:GetCurrentPlatform() then
		inst.SoundEmitter:PlaySound("dangerous_sea/creatures/shark/boat_land")
	elseif _G.TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		PlayFootstep(inst)
	end
end

AddStategraphState("shark",
	State{
		name = "eat_pst2",
		tags = { "busy", "jumping" },

		onenter = function(inst, cb)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat")
		end,

		timeline =
		{
			TimeEvent(1 * FRAMES, function(inst)
				if inst.foodtoeat and inst.foodtoeat:HasTag("jawsbreaker") then
					inst:DoTaskInTime(1, function()
						if inst.components.health ~= nil and not inst.components.health:IsDead() then
							inst.components.health:Kill()
						end
					end)

					inst.foodtoeat:Remove()
				else
					if inst.foodtoeat and not inst.foodtoeat:HasTag("jawsbreaker") then
						inst.foodtoeat:Remove()
					end
				end

				inst.foodtoeat = nil
			end),

			TimeEvent(7 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dangerous_sea/creatures/shark/bite")
				_G.SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end),

			TimeEvent(30 * FRAMES, function(inst)
				if inst:HasTag("swimming") then
					_G.SpawnPrefab("splash_green_large").Transform:SetPosition(inst.Transform:GetWorldPosition())
				else
					PlayGroundSound(inst)
				end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	}
)

AddStategraphState("catcoon",
	State{
		name = "pawground2",
		tags = { "busy" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("action")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")
		end,

		onexit = function(inst)

		end,

		timeline =
		{
			TimeEvent(6  * FRAMES, function(inst) PlayFootstep(inst) end),
			TimeEvent(13 * FRAMES, function(inst) PlayFootstep(inst) end),
			TimeEvent(20 * FRAMES, function(inst) PlayFootstep(inst) end),
			TimeEvent(27 * FRAMES, function(inst) PlayFootstep(inst) end),
			TimeEvent(34 * FRAMES, function(inst) PlayFootstep(inst) end),
			TimeEvent(42 * FRAMES, function(inst) PlayFootstep(inst) end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("mysterymeat") end),
		},
	}
)

AddStategraphState("catcoon",
	State{
		name = "mysterymeat",
		tags = { "busy", "hairball", "mysterymeat" },

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PushAnimation("furball", false)

			inst.hairballfollowup = math.random() <= .75

			if inst.hairballfollowup then
				inst.AnimState:PushAnimation("idle_loop", false)
				inst.AnimState:PushAnimation("action", false)
			end
		end,

		onexit = function(inst)

		end,

		timeline =
		{
			TimeEvent(37 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/hairball_vomit") end),
			TimeEvent(46 * FRAMES, function(inst)

				inst.vomit = _G.SpawnPrefab("kyno_mysterymeat")

				if inst.vomit ~= nil then
					local downvec = _G.TheCamera:GetDownVec()
					local face = math.atan2(downvec.z, downvec.x) * (180 / math.pi)
					local pos = inst:GetPosition() + downvec:Normalize()

					inst.Transform:SetRotation(-face)
					inst.vomit.Transform:SetPosition(pos.x, pos.y, pos.z)

					inst.vomit:AddTag("nosteal")
					inst.vomit:RemoveTag("cattoy")

					if inst.vomit.components.inventoryitem ~= nil and inst.vomit.components.inventoryitem.ondropfn then
						inst.vomit.components.inventoryitem.ondropfn(inst.vomit)
					end

					if inst.vomit.components.weighable ~= nil then
						inst.vomit.components.weighable.prefab_override_owner = inst.prefab
					end
				end

				inst:PerformBufferedAction()
			end),
		},

		events =
		{
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	}
)

AddStategraphState("wilson",
	State{
		name = "smallknockbacklanded",
		tags = { "knockback", "busy", "nopredict", "nomorph", "nointerrupt", "jumping" },

		onenter = function(inst, data)
			ClearStatusAilments(inst)
			ForceStopHeavyLifting(inst)

			if inst.components.locomotor ~= nil then
				inst.components.locomotor:Stop()
			end

			inst:ClearBufferedAction()

			if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
				inst.AnimState:PlayAnimation("hit_spike_heavy")
			end

			if data ~= nil then
				if data.propsmashed then
					local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					local pos

					if item ~= nil then
						pos = inst:GetPosition()
						pos.y = TUNING.KNOCKBACK_DROP_ITEM_HEIGHT_LOW

						local dropped = inst.components.inventory:DropItem(item, true, true, pos)

						if dropped ~= nil then
							dropped:PushEvent("knockbackdropped", { owner = inst, knocker = data.knocker, delayinteraction = TUNING.KNOCKBACK_DELAY_INTERACTION_LOW, delayplayerinteraction = TUNING.KNOCKBACK_DELAY_PLAYER_INTERACTION_LOW })
						end
					end

					if item == nil or not item:HasTag("propweapon") then
						item = inst.components.inventory:FindItem(IsMinigameItem)

						if item ~= nil then
							if pos == nil then
								pos = inst:GetPosition()
								pos.y = TUNING.KNOCKBACK_DROP_ITEM_HEIGHT_LOW
							end

							item = inst.components.inventory:DropItem(item, false, true, pos)

							if item ~= nil then
								item:PushEvent("knockbackdropped", { owner = inst, knocker = data.knocker, delayinteraction = TUNING.KNOCKBACK_DELAY_INTERACTION_LOW, delayplayerinteraction = TUNING.KNOCKBACK_DELAY_PLAYER_INTERACTION_LOW })
							end
						end
					end
				end

				if data.radius ~= nil and data.knocker ~= nil and data.knocker:IsValid() then
					local x, y, z = data.knocker.Transform:GetWorldPosition()
					local distsq = inst:GetDistanceSqToPoint(x, y, z)
					local rangesq = data.radius * data.radius
					local rot = inst.Transform:GetRotation()
					local rot1 = distsq > 0 and inst:GetAngleToPoint(x, y, z) or data.knocker.Transform:GetRotation() + 180
					local drot = math.abs(rot - rot1)

					while drot > 180 do
						drot = math.abs(drot - 360)
					end

					local k = distsq < rangesq and .3 * distsq / rangesq - 1 or -.7
					inst.sg.statemem.speed = (data.strengthmult or 1) * 8 * k
					inst.sg.statemem.dspeed = 0

					if drot > 90 then
						inst.sg.statemem.reverse = true
						inst.Transform:SetRotation(rot1 + 180)
						inst.Physics:SetMotorVel(-inst.sg.statemem.speed, 0, 0)
					else
						inst.Transform:SetRotation(rot1)
						inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
					end
				end
			end

			local x, y, z = inst.Transform:GetWorldPosition()
			inst.sg.statemem.ispassableatpt = GetActionPassableTestFnAt(x, y, z)

			if inst.sg.statemem.ispassableatpt(x, y, z, true) then
				inst.sg.statemem.safepos = Vector3(x, y, z)
			elseif data ~= nil and data.knocker ~= nil and data.knocker:IsValid() and data.knocker:IsOnPassablePoint(true) then
				local x1, y1, z1 = data.knocker.Transform:GetWorldPosition()
				local radius = data.knocker:GetPhysicsRadius(0) - inst:GetPhysicsRadius(0)

				if radius > 0 then
					local dx = x - x1
					local dz = z - z1
					local dist = radius / math.sqrt(dx * dx + dz * dz)

					x = x1 + dx * dist
					z = z1 + dz * dist

					if inst.sg.statemem.ispassableatpt(x, y, z, true) then
						x1, z1 = x, z
					end
				end

				inst.sg.statemem.safepos = Vector3(x1, 0, z1)
			end

			inst.sg:SetTimeout(11 * FRAMES)
		end,

		onupdate = function(inst)
			if inst.sg.statemem.speed ~= nil then
				inst.sg.statemem.speed = inst.sg.statemem.speed + inst.sg.statemem.dspeed

				if inst.sg.statemem.speed < 0 then
					inst.sg.statemem.dspeed = inst.sg.statemem.dspeed + .075
					inst.Physics:SetMotorVel(inst.sg.statemem.reverse and -inst.sg.statemem.speed or inst.sg.statemem.speed, 0, 0)
				else
					inst.sg.statemem.speed = nil
					inst.sg.statemem.dspeed = nil
					inst.Physics:Stop()
				end
			end

			local safepos = inst.sg.statemem.safepos

			if safepos ~= nil then
				local x, y, z = inst.Transform:GetWorldPosition()

				if inst.sg.statemem.ispassableatpt(x, y, z, true) then
					safepos.x, safepos.y, safepos.z = x, y, z
				elseif inst.sg.statemem.landed then
					local mass = inst.Physics:GetMass()

					if mass > 0 then
						inst.sg.statemem.restoremass = mass
						inst.Physics:SetMass(99999)
					end

					inst.Physics:Teleport(safepos.x, 0, safepos.z)
					inst.sg.statemem.safepos = nil
				end
			end
		end,

		timeline =
		{
			TimeEvent(9 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
			end),

			FrameEvent(10, function(inst)
				inst.sg.statemem.landed = true
				inst.sg:RemoveStateTag("nointerrupt")
				inst.sg:RemoveStateTag("jumping")
			end),
		},

		ontimeout = function(inst)
			inst.sg:GoToState("idle", true)
		end,

		onexit = function(inst)
			if inst.sg.statemem.restoremass ~= nil then
				inst.Physics:SetMass(inst.sg.statemem.restoremass)
			end

			if inst.sg.statemem.speed ~= nil then
				inst.Physics:Stop()
			end
		end,
	}
)

-- Brewbook Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.READBREWBOOK, function(inst, action)
	-- return (action.invobject ~= nil and action.invobject.components.brewbook ~= nil and "brewbook_open")
	return "brewbook_open"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.READBREWBOOK, function(inst, action)
	-- return (action.invobject ~= nil and action.invobject:HasTag("brewbook")) and "brewbook_open"
	return "brewbook_open"
end))

-- Brewing Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BREWER, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BREWER, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Cookware Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.COOKWARECOOK, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.COOKWARECOOK, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Milking Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Slaughter Tools Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Store Soul Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Heal Sugarwood Tree Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SAPHEAL, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SAPHEAL, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
end))

-- Quick open Canned Items.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UNWRAP, function(inst, action)
	local target = action.target or action.invobject

	if target.components.unwrappable and target:HasTag("canned_food") then
		return "doshortaction"
	else
		return "dolongaction"
	end
end))

-- Install Cookwares and Tools.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.INSTALLCOOKWARE, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("cookware_installable") then
		return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
	end

	if target:HasTag("cookware_post_installable") then
		return "give"
	end

	if target:HasTag("cookware_other_installable") then
		return "give"
	end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.INSTALLCOOKWARE, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("cookware_installable") then
		return inst:HasTag("fasthands") and "doshortaction" or "dolongaction"
	end

	if target:HasTag("cookware_post_installable") then
		return "give"
	end

	if target:HasTag("cookware_other_installable") then
		return "give"
	end
end))

-- Slice Items.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLICE, function(inst, action)
	local target = action.target or action.invobject

	if target:HasAnyTag("sliceable", "sliceable_world") and not action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "domediumaction" or "dolongaction"
	end

	if target:HasAnyTag("sliceable", "sliceable_world") and action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLICE, function(inst, action)
	local target = action.target or action.invobject

	if target:HasAnyTag("sliceable", "sliceable_world") and not action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "domediumaction" or "dolongaction"
	end

	if target:HasAnyTag("sliceable", "sliceable_world") and action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))

-- Slice Item Stacks.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLICESTACK, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("sliceable") and not action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "domediumaction" or "dolongaction"
	end

	if target:HasTag("sliceable") and action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLICESTACK, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("sliceable") and not action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "domediumaction" or "dolongaction"
	end

	if target:HasTag("sliceable") and action.invobject:HasTag("professionalslicer") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))

-- Learn Recipe Cards.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.LEARNRECIPECARD, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("learnablerecipecard") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.LEARNRECIPECARD, function(inst, action)
	local target = action.target or action.invobject

	if target:HasTag("learnablerecipecard") then
		return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
	end
end))

-- Researching Fishes and Roes.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FISHREGISTRY_RESEARCH, function(inst, action)
	return "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FISHREGISTRY_RESEARCH, function(inst, action)
	return "dolongaction"
end))

-- Applying Plant Boosters.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOOSTPLANT, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOOSTPLANT, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
end))

-- Dumping Water.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DUMPWATER, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.DUMPWATER, function(inst, action)
	return inst:HasTag("fasthands") and "doshortaction" or "domediumaction"
end))