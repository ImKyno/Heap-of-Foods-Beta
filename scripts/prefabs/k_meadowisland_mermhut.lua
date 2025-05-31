local assets =
{
    Asset("ANIM", "anim/kyno_meadowisland_mermhut.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_fishermermhut.zip"),
	Asset("ANIM", "anim/kyno_fishermermhut_wurt.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big",
    "merm",
    "boards",
    "rocks",

    "kyno_tropicalfish",
	"kyno_meadowisland_mermfisher",
}

local loot =
{
    "boards",
    "rocks",
    "kyno_tropicalfish",
}

local PLACER_SCALE = 1.5

local function OnUpdatePlacerHelper(helperinst)
    if not helperinst.placerinst:IsValid() then
        helperinst.components.updatelooper:RemoveOnUpdateFn(OnUpdatePlacerHelper)
        helperinst.AnimState:SetAddColour(0, 0, 0, 0)
    elseif helperinst:IsNear(helperinst.placerinst, TUNING.WURT_OFFERING_POT_RANGE) then
        helperinst.AnimState:SetAddColour(helperinst.placerinst.AnimState:GetAddColour())
    else
        helperinst.AnimState:SetAddColour(0, 0, 0, 0)
    end

end

local function CreatePlacerRing()
    local inst = CreateEntity()

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")

    inst.AnimState:SetBank("winona_battery_placement")
    inst.AnimState:SetBuild("winona_battery_placement")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetAddColour(0, .2, .5, 0)
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)

    inst.AnimState:Hide("outer")

    return inst
end

local function OnEnableHelper(inst, enabled, recipename, placerinst)
    if enabled then
        inst.helper = CreatePlacerRing()
        inst.helper.entity:SetParent(inst.entity)

        inst.helper:AddComponent("updatelooper")
        inst.helper.components.updatelooper:AddOnUpdateFn(OnUpdatePlacerHelper)
        inst.helper.placerinst = placerinst
        OnUpdatePlacerHelper(inst.helper)
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

local function OnStartHelper(inst)
    if inst.AnimState:IsCurrentAnimation("idle") then
        inst.components.deployhelper:StopHelper()
    end
end

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	
	inst.components.lootdropper:DropLoot()
	
    inst:RemoveComponent("childspawner")
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker)
        end
		
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function StartSpawning(inst)
    if not TheWorld.state.iswinter and inst.components.childspawner ~= nil and not inst:HasTag("burnt") then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil and not inst:HasTag("burnt") then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
        if TheWorld.state.isday and
            inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() >= 1 and
            child.components.combat.target == nil then
            StopSpawning(inst)
        end
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end

local function OnIgnite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function OnBurnt(inst)
    inst.AnimState:PlayAnimation("burnt")
end

local function OnIsDay(inst, isday)
    if isday then
        StopSpawning(inst)
    elseif not inst:HasTag("burnt") then
        if not TheWorld.state.iswinter then
            inst.components.childspawner:ReleaseAllChildren()
        end
		
        StartSpawning(inst)
    end
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
            not inst.components.childspawner:CanSpawn() or
            math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target = FindEntity(inst, 25, nil, { "character" }, { "merm", "playerghost", "INLIMBO" })
    if target then
        onhit(inst, target)
        return true
    else
        return false
    end
end

local function OnBuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
    inst.AnimState:PlayAnimation("idle")
end

local function OnBuiltCrafted(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
	inst.AnimState:PlayAnimation("place")
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermhut.tex")
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_meadowisland_mermhut")
    inst.AnimState:SetBuild("kyno_meadowisland_mermhut")
    inst.AnimState:PlayAnimation("idle", true)  

	inst:AddTag("structure")
    inst:AddTag("mermhouse_seaside")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boards", "rocks", "kyno_tropicalfish"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "merm"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(TUNING.MERMHOUSE_MERMS)
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.MERMHOUSE_EMERGENCY_MERMS)
	inst.components.childspawner.emergencychildname = "merm"
	inst.components.childspawner:SetEmergencyRadius(TUNING.MERMHOUSE_EMERGENCY_RADIUS)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst:WatchWorldState("isday", OnIsDay)
	StartSpawning(inst)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("onignite", OnIgnite)
	inst:ListenForEvent("burntup", OnBurnt)
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local function fishfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermhut.tex")
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_meadowisland_fishermermhut")
    inst.AnimState:SetBuild("kyno_meadowisland_fishermermhut")
    inst.AnimState:PlayAnimation("idle", true)  

	inst:AddTag("structure")
    inst:AddTag("mermhouse")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boards", "rocks", "kyno_tropicalfish"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "kyno_meadowisland_mermfisher"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.MERMHOUSE_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.MERMHOUSE_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(2)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst:WatchWorldState("isday", OnIsDay)
	StartSpawning(inst)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("onignite", OnIgnite)
	inst:ListenForEvent("burntup", OnBurnt)
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local MAX_COUNT = 6

local function UpdateSpawningTime(inst, data)
    if data.inst == nil or
        not data.inst:IsValid() or
        data.inst:GetDistanceSqToInst(inst) > TUNING.WURT_OFFERING_POT_RANGE * TUNING.WURT_OFFERING_POT_RANGE
    then
        return
    end

    local timer   = inst.components.worldsettingstimer
    local spawner = inst.components.childspawner

    if timer == nil or spawner == nil then
        return
    end

    inst.kelpofferings[data.inst.GUID] =  data.count and data.count > 0 and data.count or nil

    local topcount = 0

    for _, count in pairs(inst.kelpofferings) do
        if count > topcount then
            topcount = count
        end
    end

    local mult = Remap(topcount, 0, MAX_COUNT, 1, TUNING.WURT_MAX_OFFERING_REGEN_MULT)

    timer:SetMaxTime("ChildSpawner_RegenPeriod", TUNING.MERMHOUSE_REGEN_TIME / 2 * mult)
    spawner:SetRegenPeriod(TUNING.MERMHOUSE_REGEN_TIME / 2 * mult)
end

local function craftedfishfn()
	local inst = fishfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_fishermermhut_wurt.tex")
	
	inst.AnimState:SetBank("mermhouse_crafted")
	inst.AnimState:SetBuild("kyno_fishermermhut_wurt")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("fishermermhut_crafted")
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper:AddRecipeFilter("offering_pot")
        inst.components.deployhelper:AddRecipeFilter("offering_pot_upgraded")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
        inst.components.deployhelper.onstarthelper = OnStartHelper
    end
	
	if not TheWorld.ismastersim then
		return inst
	end
	
    inst.components.childspawner:SetRegenPeriod(TUNING.MERMHOUSE_REGEN_TIME / 2)
    inst.components.childspawner:SetSpawnPeriod(TUNING.MERMHOUSE_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
	
	inst.components.lootdropper:SetLoot(nil)
	
	inst.components.inspectable.nameoverride = "MERMHOUSE_CRAFTED"
	
	inst.UpdateSpawningTime = UpdateSpawningTime
    inst.kelpofferings = {}
	
	inst:ListenForEvent("onbuilt", OnBuiltCrafted)
	inst:ListenForEvent("ms_updateofferingpotstate", function(_, data) inst:UpdateSpawningTime(data) end, TheWorld)
	
	return inst 
end

local function placerfn(player, placer)
    if placer and placer.mouse_blocked then
        return
    end

    if player and player.components.talker then
        player.components.talker:Say(GetString(player, "ANNOUNCE_CANTBUILDHERE_FISHERMERMHOUSE"))
    end
end

return Prefab("kyno_meadowisland_mermhut", fn, assets, prefabs),
Prefab("kyno_meadowisland_fishermermhut", fishfn, assets, prefabs),
Prefab("kyno_fishermermhut_wurt", craftedfishfn, assets, prefabs),
MakePlacer("kyno_fishermermhut_wurt_placer", "kyno_fishermermhut_wurt", "kyno_fishermermhut_wurt", "idle", 
nil, nil, nil, nil, nil, nil, nil, nil, placerfn)