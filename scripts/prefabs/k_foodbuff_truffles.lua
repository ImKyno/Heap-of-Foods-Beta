local banddt = 1
local FOLLOWER_ONEOF_TAGS = {"pig"}
local FOLLOWER_CANT_TAGS = {"werepig", "merm", "player"}
local HAUNTEDFOLLOWER_MUST_TAGS = {"pig"}

local function DisableBand(inst)
	if inst.updatetask then
		inst.updatetask:Cancel()
		inst.updatetask = nil
	end
end

local function UpdateBand(inst)	
	if inst:HasTag("playermerm") or inst:HasTag("playermonster") then
		return
	end
    
	if inst and inst.components.leader then
		local x,y,z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, TUNING.ONEMANBAND_RANGE, nil, FOLLOWER_CANT_TAGS, FOLLOWER_ONEOF_TAGS)
		
		for k, v in pairs(ents) do
			if v.components.follower and not v.components.follower.leader and not 
			inst.components.leader:IsFollower(v) and inst.components.leader.numfollowers < 10 then
				inst.components.leader:AddFollower(v)
			end
		end
		
		for k, v in pairs(inst.components.leader.followers) do
			if k.components.follower then
				if k:HasTag("pig") then
					k.components.follower:AddLoyaltyTime(3)
                end
            end
        end
	end
end

local function EnableBand(inst)
	inst.updatetask = inst:DoPeriodicTask(banddt, UpdateBand, 1)
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	-- Won't work for monster characters. But they will comment about it.
	if target:HasTag("playermerm") or target:HasTag("playermonster") then
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_TRUFFLESBUFF_START"))
		end
	else
		target:PushEvent("makefriend")
		EnableBand(target)
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_TRUFFLESBUFF_START"))
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target:HasTag("playermerm") or target:HasTag("playermonster") then
		return
	else
		DisableBand(target)
	
		if target.components.talker and target:HasTag("player") and not target:HasTag("playermerm") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_TRUFFLESBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_trufflesbuff")
    inst.components.timer:StartTimer("kyno_trufflesbuff", TUNING.KYNO_TRUFFLESBUFF_DURATION)
	
	if target:HasTag("playermerm") or target:HasTag("playermonster") then
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_TRUFFLESBUFF_START"))
		end
	else
		target:PushEvent("makefriend")
		DisableBand(target)
		EnableBand(target)
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_TRUFFLESBUFF_START"))
		end
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_trufflesbuff" then
        inst.components.debuff:Stop()
    end
end

local function fn()
    if not TheWorld.ismastersim then 
		return 
	end

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:Hide()
  
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_trufflesbuff", TUNING.KYNO_TRUFFLESBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_trufflesbuff", fn)