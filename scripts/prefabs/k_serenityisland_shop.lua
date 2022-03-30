local assets =
{
    Asset("ANIM", "anim/quagmire_elderswampig.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "meat",
    "splash_sink",
}

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function SayThanks(inst)
	if math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY1)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY2)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY3)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY4)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY5)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_BUY6)
	end
end

local function SayFar(inst)
	if math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR1)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR2)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR3)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR4)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR5)
	elseif math.random() < 0.6 then
		inst.components.talker:Say(STRINGS.PIGELDER_TALK_FAR5)
    end
end

local function SayNear(inst)
	if math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR1)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR2)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR3)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR4)
    elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR5)
	elseif math.random() < 0.6 then
        inst.components.talker:Say(STRINGS.PIGELDER_TALK_NEAR6)
    end
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false
	if not inst.AnimState:IsCurrentAnimation("sleep_loop", true) then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
	end
	inst:DoTaskInTime(1, function() SayFar(inst) end)
end

local function OnTurnOn(inst)
    inst.components.prototyper.on = true
	if not inst.AnimState:IsCurrentAnimation("idle", true) then
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
	end
	inst:DoTaskInTime(.5, function() SayNear(inst) end)
end

local function OnActivate(inst)
	inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/friendship_music/3") -- Money sound?
	SayThanks(inst)
end

local function OnIsNight(inst, isnight)
    if isnight then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
		inst.components.prototyper.restrictedtag = "can_wakeup_elder" -- Just to prevent players from shopping at night.
    else
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
		inst.components.prototyper.restrictedtag = nil
    end
end

local function TestItem(inst, item, giver)
	-- 
end

local function OnGetItemFromPlayer(inst, giver, item)
	--
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_serenityisland_shop.tex")

    MakeObstaclePhysics(inst, 2, .5)

    inst.AnimState:SetBank("quagmire_elderswampig")
	inst.AnimState:SetBuild("quagmire_elderswampig") 
	inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("trader")
    inst:AddTag("prototyper")
	inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -600, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.talker.ontalk = ontalk
	
    inst:AddComponent("inspectable")
	inst:AddComponent("craftingstation")
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4, 4)

    inst:AddComponent("prototyper")
    inst.components.prototyper.onactivate = OnActivate
    inst.components.prototyper.onturnon = OnTurnOn
    inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SERENITYSHOP_TWO
	
	-- inst:AddComponent("trader")
	-- inst.components.trader:SetAcceptTest(TestItem)
    -- inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)

    return inst
end

return Prefab("kyno_serenityisland_shop", fn, assets, prefabs)