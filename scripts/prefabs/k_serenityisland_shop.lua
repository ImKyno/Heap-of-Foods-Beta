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
	"cookingrecipecard",
	"lobsterdinner",
	"turf_road",
	"turf_deciduous",
    "splash_sink",
	
	"kyno_sugartree_bud",
	"kyno_sugartree_petals",
	"kyno_brewingrecipecard",
	"turf_pinkpark",
	"turf_stonecity",
	"gorge_caramel_cube",
	"dug_kyno_spotbush",
	"dug_kyno_wildwheat",
}

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/talk")
end

local function Say(inst, str)
	inst.components.talker:Chatter(str, math.random(#STRINGS[str]))
end

local function SayBuy(inst)
	Say(inst, "PIGELDER_TALK_BUY")
end

local function SayThanks(inst)
	Say(inst, "PIGELDER_TALK_THANK")
end

local function SayFar(inst)
	Say(inst, "PIGELDER_TALK_FAR")
end

local function SayNear(inst)
	if not inst:HasTag("pigelder_gifted") then
		Say(inst, "PIGELDER_TALK_NEAR1")
	else
		Say(inst, "PIGELDER_TALK_NEAR2")
    end
end

local function OnFar(inst, isnight)
	if not TheWorld.state.isnight then
		SayNear(inst)
	end
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false
	if not inst.AnimState:IsCurrentAnimation("sleep_loop", true) then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/sleep_in")
	end
	-- inst:DoTaskInTime(1, function() SayFar(inst) end) -- OnFar instead is better.
end

local function OnTurnOn(inst)
    inst.components.prototyper.on = true
	if not inst.AnimState:IsCurrentAnimation("idle", true) then
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/sleep_out")
	end
	inst:DoTaskInTime(.5, function() SayNear(inst) end)
end

local function OnActivate(inst)
	inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/friendship_music/3") -- Money sound?
	SayBuy(inst)
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
	if item.components.inventoryitem ~= nil and item.prefab == "lobsterdinner" or item.prefab == "gorge_caramel_cube" and not inst:HasTag("pigelder_gifted") then
		return true -- Accept the Item.
	elseif item.components.inventoryitem ~= nil and item.prefab == "turf_road" or item.prefab == "turf_deciduous" then
		return true
	elseif item.components.inventoryitem ~= nil and item.prefab == "cookingrecipecard" then
		return true
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_PIGELDER_FAIL"))
	end
end

local function LaunchItem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item.prefab == "lobsterdinner" or item.prefab == "gorge_caramel_cube" and not inst:HasTag("pigelder_gifted") then
		inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/friendship_music/10")
		
		inst:DoTaskInTime(1, function() 
			SayThanks(inst) 
		end)
		
		-- New Recipes available in the shop!
		inst.components.craftingstation:LearnItem("dug_kyno_spotbush",     "dug_kyno_spotbush_p")
		inst.components.craftingstation:LearnItem("dug_kyno_wildwheat",    "dug_kyno_wildwheat_p")
		inst.components.craftingstation:LearnItem("kyno_sugartree_petals", "kyno_sugartree_petals_p")
		inst.components.craftingstation:LearnItem("kyno_sugartree_bud",    "kyno_sugartree_bud_p")

		inst:AddTag("pigelder_gifted")
		inst.foodgift = true
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end
	
	if item.components.inventoryitem ~= nil and item.prefab == "turf_road" then
		local turf = SpawnPrefab("turf_stonecity")
		turf.Transform:SetPosition(x, y, z)
		LaunchItem(turf, angle)
	end 
	
	if item.components.inventoryitem ~= nil and item.prefab == "turf_deciduous" then
		local turf = SpawnPrefab("turf_pinkpark")
		turf.Transform:SetPosition(x, y, z)
		LaunchItem(turf, angle)
	end

	if item.components.inventoryitem ~= nil and item.prefab == "cookingrecipecard" then
		local card = SpawnPrefab("kyno_brewingrecipecard")
		card.Transform:SetPosition(x, y, z)
		LaunchItem(card, angle)
	end
end

local function OnSave(inst, data)
	data.foodgift = inst.foodgift
	data.potrepaired = inst.potrepaired
end

local function OnLoad(inst, data)
    if data ~= nil and data.foodgift ~= nil then
        inst:AddTag("pigelder_gifted")
    end
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
	minimap:SetPriority(5)

    MakeObstaclePhysics(inst, 2, .5)

    inst.AnimState:SetBank("quagmire_elderswampig")
	inst.AnimState:SetBuild("quagmire_elderswampig")
	inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("trader")
    inst:AddTag("prototyper")
	inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("serenity_pigelder") -- Using this as a flag for generating the island.

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
	inst.components.playerprox:SetDist(4, 7)
	inst.components.playerprox:SetOnPlayerFar(OnFar)

    inst:AddComponent("prototyper")
    inst.components.prototyper.onactivate = OnActivate
    inst.components.prototyper.onturnon = OnTurnOn
    inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SERENITYSHOP_TWO

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

	inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)

	-- inst:ListenForEvent("elderpot_repaired", SellKitchenStuff)

	inst.OnSave	= OnSave
	inst.OnLoad = OnLoad

    return inst
end

return Prefab("kyno_serenityisland_shop", fn, assets, prefabs)