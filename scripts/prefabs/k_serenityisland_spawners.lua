require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/quagmire_pebble_crab.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
    "kyno_pebblecrab",
	"kyno_chicken2",
	"kyno_serenityisland_crate",
}

local function OnSpawnCrab(inst, child)
	child.sg:GoToState("emerge")
end

local function OnSpawnChicken(inst, child)
	child.sg:GoToState("honk")
end

local function OnAddChildren(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnPreLoadCrab(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_PEBBLECRAB_RELEASE_TIME, TUNING.KYNO_PEBBLECRAB_REGEN_TIME)
end

local function OnPreLoadChicken(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_CHICKEN_RELEASE_TIME, TUNING.KYNO_CHICKEN_REGEN_TIME)
end

local function crabfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_crab_spawner.tex")
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("serenitycrabspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_pebblecrab"
	inst.components.childspawner.spawnoffscreen = true
    inst.components.childspawner:SetSpawnedFn(OnSpawnCrab)
    inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_PEBBLECRAB_RELEASE_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_PEBBLECRAB_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_PEBBLECRAB_AMOUNT)
	inst.components.childspawner:StartSpawning()
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_PEBBLECRAB_RELEASE_TIME, TUNING.KYNO_PEBBLECRAB_ENABLED)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_PEBBLECRAB_REGEN_TIME, TUNING.KYNO_PEBBLECRAB_ENABLED)
    if not TUNING.KYNO_PEBBLECRAB_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
	inst.OnPreLoad = OnPreLoadCrab

    return inst
end

local function chickenfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("chicken2spawner")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_chicken2"
	inst.components.childspawner.spawnoffscreen = true
	inst.components.childspawner:SetSpawnedFn(OnSpawnChicken)
    inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_CHICKEN_RELEASE_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_CHICKEN_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_CHICKEN_AMOUNT)
	inst.components.childspawner:StartSpawning()
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_CHICKEN_RELEASE_TIME, TUNING.KYNO_CHICKEN_ENABLED)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_CHICKEN_REGEN_TIME, TUNING.KYNO_CHICKEN_ENABLED)
    if not TUNING.KYNO_CHICKEN_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
	inst.OnPreLoad = OnPreLoadChicken

    return inst
end

local function OnInitCrate(inst)
	inst:DoTaskInTime(TUNING.KYNO_CRATE_GROWTIME, function(inst)
		local crate = SpawnPrefab("kyno_serenityisland_crate")
	
		crate.Transform:SetPosition(inst.Transform:GetWorldPosition())
		crate.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
		
		inst:Remove()
	end)
end

local function cratefn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("serenitycratespawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	OnInitCrate(inst)
	
	return inst
end

return Prefab("kyno_pebblecrab_spawner", crabfn, assets, prefabs),
Prefab("kyno_chicken2_herd", chickenfn, assets, prefabs),
Prefab("kyno_serenityisland_crate_spawner", cratefn, assets, prefabs)