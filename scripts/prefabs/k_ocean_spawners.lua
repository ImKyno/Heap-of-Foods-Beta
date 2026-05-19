require("worldsettingsutil")

local assets =
{
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"kyno_jellyfish_ocean",
	"kyno_jellyfish_rainbow_ocean",
}

local function OnSpawn(inst, child)

end

local function OnSpawnJellyfish(inst, child)
	if child.components.knownlocations ~= nil then
		child.components.knownlocations:RememberLocation("home", child:GetPosition())
	end
end

local function OnAddChild(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
end

local function OnInit(inst)

end

local function OnPreLoadJelly(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_JELLYFISH_RELEASE_TIME, TUNING.KYNO_JELLYFISH_REGEN_TIME)
end

local function OnPreLoadJellyRainbow(inst, data)
	WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_JELLYFISH_RAINBOW_RELEASE_TIME, TUNING.KYNO_JELLYFISH_RAINBOW_REGEN_TIME)
end

local function OnPreLoadDogfish(inst, data)
	WorldSettings_Spawner_PreLoad(inst, data, TUNING.KYNO_DOGFISH_SPAWN_TIME)
end

local function OnPreLoadSwordfish(inst, data)
    WorldSettings_Spawner_PreLoad(inst, data, TUNING.KYNO_SWORDFISH_SPAWN_TIME)
end

local function OnPreLoadPufferMonster(inst, data)
	WorldSettings_Spawner_PreLoad(inst, data, TUNING.KYNO_PUFFERMONSTER_SPAWN_TIME)
end

local function jellyfishfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("jellyfishspawner")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_jellyfish_ocean"
	inst.components.childspawner.spawnoffscreen = true
	inst.components.childspawner.wateronly = true
	inst.components.childspawner.spawnradius = TUNING.KYNO_JELLYFISH_RADIUS
    inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_JELLYFISH_RELEASE_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_JELLYFISH_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_JELLYFISH_AMOUNT)
	inst.components.childspawner:SetSpawnedFn(OnSpawnJellyfish)
	inst.components.childspawner:StartSpawning()
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_JELLYFISH_RELEASE_TIME, TUNING.KYNO_JELLYFISH_ENABLED)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_JELLYFISH_REGEN_TIME, TUNING.KYNO_JELLYFISH_ENABLED)
    if not TUNING.KYNO_JELLYFISH_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
	inst.OnPreLoad = OnPreLoadJelly

    return inst
end

local function jellyfishrainbowfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("jellyfishrainbowspawner")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_jellyfish_rainbow_ocean"
	inst.components.childspawner.spawnoffscreen = true
	inst.components.childspawner.wateronly = true
	inst.components.childspawner.spawnradius = TUNING.KYNO_JELLYFISH_RAINBOW_RADIUS
    inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_JELLYFISH_RAINBOW_RELEASE_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_JELLYFISH_RAINBOW_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_JELLYFISH_RAINBOW_AMOUNT)
	inst.components.childspawner:SetSpawnedFn(OnSpawnJellyfish)
	inst.components.childspawner:StartSpawning()
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_JELLYFISH_RAINBOW_RELEASE_TIME, TUNING.KYNO_JELLYFISH_RAINBOW_ENABLED)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_JELLYFISH_RAINBOW_REGEN_TIME, TUNING.KYNO_JELLYFISH_RAINBOW_ENABLED)
    if not TUNING.KYNO_JELLYFISH_RAINBOW_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
	inst.OnPreLoad = OnPreLoadJellyRainbow

    return inst
end

local function dogfishfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("dogfishspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	if TUNING.KYNO_DOGFISH_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_DOGFISH_SPAWN_TIME, true)
		inst.components.spawner:Configure("kyno_dogfish", TUNING.KYNO_DOGFISH_SPAWN_TIME)
		inst.components.spawner:SetWaterSpawning(true, false)
		
		inst.OnPreLoad = OnPreLoadDogfish
	end

    return inst
end

local function swordfishfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_swordfish_spawner.tex")
	minimap:SetPriority(5)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("swordfishspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	if TUNING.KYNO_SWORDFISH_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_SWORDFISH_SPAWN_TIME, true)
		inst.components.spawner:Configure("kyno_swordfish", TUNING.KYNO_SWORDFISH_SPAWN_TIME)
		inst.components.spawner:SetWaterSpawning(true, false)
		
		inst.OnPreLoad = OnPreLoadSwordfish
	end

    return inst
end

local function puffermonsterfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("puffermonsterspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	if TUNING.KYNO_PUFFERMONSTER_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_PUFFERMONSTER_SPAWN_TIME, true)
		inst.components.spawner:Configure("kyno_puffermonster", TUNING.KYNO_PUFFERMONSTER_SPAWN_TIME)
		inst.components.spawner:SetWaterSpawning(true, false)
		
		inst.OnPreLoad = OnPreLoadPufferMonster
	end

    return inst
end

return Prefab("kyno_jellyfish_spawner", jellyfishfn, assets, prefabs),
Prefab("kyno_jellyfish_rainbow_spawner", jellyfishrainbowfn, assets, prefabs),
Prefab("kyno_swordfish_spawner", swordfishfn, assets, prefabs),
Prefab("kyno_puffermonster_spawner", puffermonsterfn, assets, prefabs),
Prefab("kyno_dogfish_spawner", dogfishfn, assets, prefabs)