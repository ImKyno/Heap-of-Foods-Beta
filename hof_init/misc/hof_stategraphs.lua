-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EQUIPSLOTS    = _G.EQUIPSLOTS
local EventHandler  = _G.EventHandler
local FRAMES        = _G.FRAMES
local State         = _G.State
local TimeEvent     = _G.TimeEvent
local POPUPS        = _G.POPUPS
local PlayFootstep  = _G.PlayFootstep
local UpvalueHacker = require("hof_upvaluehacker")

require("stategraphs/commonstates")

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
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
			
            if timeout ~= nil then
                inst.sg:SetTimeout(timeout)
                inst.sg.statemem.delayed = true
                inst.AnimState:PlayAnimation("build_pre")
                inst.AnimState:PushAnimation("build_loop", true)
            else
                inst.sg:SetTimeout(.5)
                inst.AnimState:PlayAnimation("construct_pre")
                inst.AnimState:PushAnimation("construct_loop", true)
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                if inst.sg.statemem.delayed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
			TimeEvent(9 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        ontimeout = function(inst)
            if not inst.sg.statemem.delayed then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("construct_pst")
            elseif not inst:PerformBufferedAction() then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("build_pst")
            end
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
            if not inst.sg.statemem.constructing then
                inst.SoundEmitter:KillSound("make")
            end
        end,
	}
)

AddStategraphState("wilson_client",
	State{
        name = "pickable_tall",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
			
            if timeout ~= nil then
                inst.sg:SetTimeout(timeout)
                inst.sg.statemem.delayed = true
                inst.AnimState:PlayAnimation("build_pre")
                inst.AnimState:PushAnimation("build_loop", true)
            else
                inst.sg:SetTimeout(.5)
                inst.AnimState:PlayAnimation("construct_pre")
                inst.AnimState:PushAnimation("construct_loop", true)
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                if inst.sg.statemem.delayed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
			TimeEvent(9 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        ontimeout = function(inst)
            if not inst.sg.statemem.delayed then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("construct_pst")
            elseif not inst:PerformBufferedAction() then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("build_pst")
            end
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
            if not inst.sg.statemem.constructing then
                inst.SoundEmitter:KillSound("make")
            end
        end,
	}
)

-- Change the animations of some things.
AddStategraphPostInit("wilson", function(self)
    local _givehandler       = self.actionhandlers[ACTIONS.GIVE].deststate
	local _pickhandler       = self.actionhandlers[ACTIONS.PICK].deststate
	local _harvesthandler    = self.actionhandlers[ACTIONS.HARVEST].deststate
	local _buildhandler      = self.actionhandlers[ACTIONS.BUILD].deststate
	local _dismantlehandler  = self.actionhandlers[ACTIONS.DISMANTLE].deststate
	local _takeitemhandler   = self.actionhandlers[ACTIONS.TAKEITEM].deststate
	local _takesinglehandler = self.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate
	local _eathandler        = self.actionhandlers[ACTIONS.EAT].deststate

	-- More sofisticated animation for repairing things.
    self.actionhandlers[ACTIONS.GIVE].deststate = function(inst, action, ...)
        local target = action.target or action.invobject

		if target and target:HasTags({"trader", "serenity_installable"}) then
			return "domediumaction"
		end

        return _givehandler(inst, action, ...)
    end
	
	-- Currently for Pineapple Bushes and Palm Trees.
	self.actionhandlers[ACTIONS.PICK].deststate = function(inst, action, ...)
        local target = action.target or action.invobject
        
        if target and target:HasTags({"plant", "pickable_tall"}) and inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
            return "pickable_tall" -- "construct"
		end
		
		-- Haste Buff.
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end
		
		return _pickhandler(inst, action, ...)
	end
	
	self.actionhandlers[ACTIONS.HARVEST].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end
		
		return _harvesthandler(inst, action, ...)
	end
	
	self.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasthands") then
			return "domediumaction" -- doshortaction is too fast, ruins the mood.
		end
		
		return _buildhandler(inst, action, ...)
	end
	
	self.actionhandlers[ACTIONS.DISMANTLE].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end
		
		return _dismantlehandler(inst, action, ...)
	end
	
	self.actionhandlers[ACTIONS.TAKEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end
		
		return _takeitemhandler(inst, action, ...)
	end
	
	self.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end
		
		return _takesinglehandler(inst, action, ...)
	end

	-- Makes eating faster with any food.
	self.actionhandlers[ACTIONS.EAT].deststate = function(inst, action, ...)
		local target = action.target or action.invobject
		
		if inst:HasTag("fasteater") then
			return "quickeat"
		end
		
		return _eathandler(inst, action, ...)
	end
end)

-- Klei made sharks don't actually eat food, they just remove it from the scene...
local function groundsound(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	
    if inst:GetCurrentPlatform() then
        inst.SoundEmitter:PlaySound("dangerous_sea/creatures/shark/boat_land")
    elseif _G.TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
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
                    groundsound(inst)
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }
)

AddStategraphPostInit("shark", function(sg)
	local oldeat_pre = sg.states["eat_pre"].ontimeout
	sg.states["eat_pre"].ontimeout = function(inst)
		oldeat_pre(inst)
		
		local targetpt = _G.Vector3(inst.Transform:GetWorldPosition())
		
		if inst.foodtoeat and inst.foodtoeat:IsValid() then
			targetpt = _G.Vector3(inst.foodtoeat.Transform:GetWorldPosition())
		end
		
		inst.Transform:SetPosition(targetpt.x,0,targetpt.z)
		inst.sg:GoToState("eat_pst2")
	end
end)

-- Checking if Chum The Waters Mod is enabled to not add duplicates.
if not TUNING.HOF_IS_CTW_ENABLED then
	AddStategraphState("catcoon",
		State{
			name = "pawground2",
			tags = {"busy"},

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
			tags = {"busy", "hairball", "mysterymeat"},

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
					
						if inst.vomit.components.inventoryitem and inst.vomit.components.inventoryitem.ondropfn then
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
end

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