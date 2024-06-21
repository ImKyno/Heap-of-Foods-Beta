local assets =
{
	Asset("ANIM", "anim/kyno_pineapplebush.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
    "kyno_pineapple",
	-- "dug_kyno_pineapplebush",
}

local SEASON_BASEREGENTIME_TUNING_LOOKUP =
{
    [SEASONS.SUMMER] = "KYNO_PINEAPPLEBUSH_GROWTIME_SPRING",
    [SEASONS.SPRING] = "KYNO_PINEAPPLEBUSH_GROWTIME_SUMMER",
}

local function OnSeasonChange(inst, season)
    local tuning = SEASON_BASEREGENTIME_TUNING_LOOKUP[season] or "KYNO_PINEAPPLEBUSH_GROWTIME"
    inst.components.pickable.baseregentime = TUNING[tuning]
end

local function OnPicked(inst, picker)
	if picker ~= nil then
        if picker.components.combat ~= nil and not (picker.components.inventory ~= nil and 
		picker.components.inventory:EquipHasTag("bramble_resistant")) and not picker:HasTag("shadowminion") then
            picker.components.combat:GetAttacked(inst, TUNING.CACTUS_DAMAGE) -- Get hurt!
            picker:PushEvent("thorns")
        end
	end

	inst.AnimState:Hide("pineapple")
    inst.AnimState:PlayAnimation("picked")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function OnRegen(inst)
	inst.AnimState:Show("pineapple")
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function OnMakeEmpty(inst)
    inst.AnimState:Hide("pineapple")
end

local function OnMakeBarren(inst)
	if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
		inst.AnimState:Hide("pineapple")
        inst.AnimState:PlayAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
end

local function OnTransplant(inst)
	inst.AnimState:Hide("pineapple")
    inst.AnimState:PlayAnimation("dead")
	
	inst.components.pickable:MakeEmpty()
end

local function OnDigUp(inst, chopper)
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
    end
	
	inst.components.lootdropper:SpawnLootPrefab("dug_kyno_pineapplebush")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pineapplebush.tex")
	
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	
	MakeSmallObstaclePhysics(inst, .1)
	
	inst.AnimState:SetBank("kyno_pineapplebush")
	inst.AnimState:SetBuild("kyno_pineapplebush")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("plant")
	inst:AddTag("bush")
	inst:AddTag("thorny")
	inst:AddTag("pineapplebush")
	inst:AddTag("lunarplant_target")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	-- inst:AddComponent("workable")
	-- inst.components.workable:SetWorkAction(ACTIONS.DIG)
	-- inst.components.workable:SetOnFinishCallback(OnDigUp)
	-- inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("kyno_pineapple", TUNING.KYNO_PINEAPPLEBUSH_GROWTIME)
    inst.components.pickable.onregenfn = OnRegen
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = OnMakeEmpty
	-- inst.components.pickable.makebarrenfn = OnMakeBarren
	inst.components.pickable.ontransplantfn = OnTransplant
	
	MakeLargeBurnable(inst)
	MakeMediumPropagator(inst)
	MakeHauntableIgnite(inst)
    MakeNoGrowInWinter(inst)
	-- MakeWaxablePlant(inst)
	
	inst:WatchWorldState("season", OnSeasonChange)

	return inst
end

return Prefab("kyno_pineapplebush", fn, assets, prefabs)