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
	[SEASONS.SPRING] = "KYNO_PINEAPPLEBUSH_GROWTIME_SPRING",
	[SEASONS.SUMMER] = "KYNO_PINEAPPLEBUSH_GROWTIME_SUMMER",
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
	
	if inst.components.pickable:IsBarren() then
        inst.AnimState:PushAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PushAnimation("picked", false)
    end

	inst.AnimState:Hide("pineapple")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function OnRegen(inst)
	inst.AnimState:Show("pineapple")
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function OnMakeEmpty(inst)
	if not POPULATING and (inst.components.witherable ~= nil and inst.components.witherable:IsWithered() 
	or inst.AnimState:IsCurrentAnimation("dead")) then
        inst.AnimState:PlayAnimation("dead_to_idle")
        -- inst.AnimState:PushAnimation("picked", false)
    else
        inst.AnimState:PlayAnimation("picked")
    end
	
    inst.AnimState:Hide("pineapple")
end

local function OnMakeBarren(inst, wasempty)
	if not POPULATING and (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
        inst.AnimState:PlayAnimation(wasempty and "idle_to_dead" or "idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
	
	inst.AnimState:Hide("pineapple")
end

local function OnTransplant(inst)
	inst.components.pickable:MakeBarren()
end

local function OnDigUp(inst, chopper)
	if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
        end

        inst.components.lootdropper:SpawnLootPrefab(withered and "kyno_pineapple" or "dug_kyno_pineapplebush")
    end
	
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
	inst:AddTag("pickable_tall")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("kyno_pineapple", TUNING.KYNO_PINEAPPLEBUSH_GROWTIME)
    inst.components.pickable.onregenfn = OnRegen
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = OnMakeEmpty
	
	MakeLargeBurnable(inst)
	MakeMediumPropagator(inst)
	MakeHauntableIgnite(inst)
    MakeNoGrowInWinter(inst)
	
	inst:WatchWorldState("season", OnSeasonChange)
	OnSeasonChange(inst, TheWorld.state.season)

	return inst
end

local function transplantablefn()
	local inst = fn()
	
	inst:AddTag("witherable")
	inst:AddTag("lunarplant_target") -- Transplantable Pineapple Bushes are susceptible to them.
	
	inst:SetPrefabNameOverride("kyno_pineapplebush")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("witherable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(OnDigUp)
	inst.components.workable:SetWorkLeft(1)
	
	inst.components.inspectable.nameoverride = "KYNO_PINEAPPLEBUSH"
	
	inst.components.pickable.makebarrenfn = OnMakeBarren
	inst.components.pickable.max_cycles = 20
	inst.components.pickable.cycles_left = 20
	inst.components.pickable.ontransplantfn = OnTransplant
	
	MakeWaxablePlant(inst)
	
	return inst
end

return Prefab("kyno_pineapplebush", fn, assets, prefabs),
Prefab("kyno_pineapplebush2", transplantablefn, assets, prefabs)