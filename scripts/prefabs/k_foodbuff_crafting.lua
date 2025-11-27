local function OnBuild(target)
	if target ~= nil and target.components.sanity ~= nil then
		target.components.sanity:DoDelta(TUNING.KYNO_CRAFTINGBUFF_SANITY_PENALTY)
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if not target:HasTag("bigbrain") then
		target:AddTag("bigbrain")
	end
	
	if target.components.builder ~= nil then
		inst._added_bonuses = 
		{
			science_bonus            = 3,
			magic_bonus              = 3,
			ancient_bonus            = 4,
			celestial_bonus          = 3,
			cartography_bonus        = 2,
			seafaring_bonus          = 2,
			perdoffering_bonus       = 3,
			wargoffering_bonus       = 3,
			pigoffering_bonus        = 3,
			carratoffering_bonus     = 3,
			beefoffering_bonus       = 3,
			catcoonoffering_bonus    = 3,
			rabbitoffering_bonus     = 3,
			dragonoffering_bonus     = 3,
			wormoffering_bonus       = 3,
			madscience_bonus         = 1,
			rabbitkingshop_bonus     = 2,
			carpentry_bonus          = 3,
			fishing_bonus            = 2,
			orphanage_bonus          = 1,
			turfcrafting_bonus       = 2,
			carnival_prizeshop_bonus = 1,
			carnival_hostshop_bonus  = 3,
			lunarforging_bonus       = 2,
			shadowforging_bonus      = 2,
			sculpting_bonus          = 2,
			foodprocessing_bonus     = 1,
			shadow_bonus             = 2,
			spidercraft_bonus        = 1,
			robotmodulecraft_bonus   = 1,
			bookcraft_bonus          = 1,
			mashturfcrafting_bonus   = 1,
			mealing_bonus            = 1,
		}

		for k, v in pairs(inst._added_bonuses) do
			target.components.builder[k] = (target.components.builder[k] or 0) + v
		end
		
		target:PushEvent("techlevelchange")
		target:PushEvent("unlockrecipe")
			
		target:ListenForEvent("builditem", OnBuild)
		target:ListenForEvent("bufferbuild", OnBuild)
		target:ListenForEvent("buildstructure", OnBuild)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target:HasTag("bigbrain") then
		target:RemoveTag("bigbrain")
	end
	
	if target.components.builder ~= nil and inst._added_bonuses ~= nil then
		for k, v in pairs(inst._added_bonuses) do
			target.components.builder[k] = math.max(0, (target.components.builder[k] or 0) - v)
		end
			
		target:PushEvent("techlevelchange")
		target:PushEvent("unlockrecipe")
			
		target:RemoveEventCallback("builditem", OnBuild)
		target:RemoveEventCallback("bufferbuild", OnBuild)
		target:RemoveEventCallback("buildstructure", OnBuild)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_craftingbuff")
    inst.components.timer:StartTimer("kyno_craftingbuff", TUNING.KYNO_CRAFTINGBUFF_DURATION)
	
	if target:HasTag("bigbrain") then
		target:RemoveTag("bigbrain")
		target:AddTag("bigbrain")
	else
		target:AddTag("bigbrain")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_craftingbuff" then
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
	inst.components.timer:StartTimer("kyno_craftingbuff", TUNING.KYNO_CRAFTINGBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_craftingbuff", fn)