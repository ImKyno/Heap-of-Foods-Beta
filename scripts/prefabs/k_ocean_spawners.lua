require("worldsettingsutil")

local assets =
{	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{

}

local function OnSpawn(inst, child)

end

local function OnAddChild(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
end

local function OnInit(inst)

end

local function swordfishfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("swordfishspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	--[[
    if TUNING.KYNO_SWORDFISH_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_SWORDFISH_SPAWN_TIME, true)
		inst.components.spawner:Configure("kyno_swordfish", TUNING.KYNO_SWORDFISH_SPAWN_TIME)
		inst.components.spawner:SetOnVacateFn(OnSpawned)
		inst.components.spawner:SetOnOccupiedFn(OnOcuppied)
		
		inst.OnPreLoad = OnPreLoad
	end
	]]--

    return inst
end

local function jellyfishfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("jellyfishspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	--[[
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_jellyfish"
	inst.components.childspawner:SetRareChild("kyno_jellyfish_rainbow", TUNING.KYNO_JELLYFISH_RAINBOW_CHANCE)
	inst.components.childspawner.spawnoffscreen = true
    inst.components.childspawner:SetSpawnedFn(OnSpawnJellyFish)
    inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_JELLYFISH_RELEASE_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_JELLYFISH_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_JELLYFISH_AMOUNT)
	inst.components.childspawner:StartSpawning()
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_JELLYFISH_RELEASE_TIME, TUNING.KYNO_JELLYFISH_ENABLED)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_JELLYFISH_REGEN_TIME, TUNING.KYNO_JELLYFISH_ENABLED)
    if not TUNING.KYNO_JELLYFISH_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
	inst.OnPreLoad = OnPreLoadJelly
	]]--

    return inst
end

return Prefab("kyno_swordfish_spawner", swordfishfn, assets, prefabs),
Prefab("kyno_jellyfish_spawner", jellyfishfn, assets, prefabs)