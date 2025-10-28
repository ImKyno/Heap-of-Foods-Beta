require("worldsettingsutil")

local assets =
{	
	Asset("ANIM", "anim/kyno_antchovy_ocean.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_antchovy",
	"kyno_jellyfish_ocean",
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

local function OnPreLoadJelly(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_JELLYFISH_RELEASE_TIME, TUNING.KYNO_JELLYFISH_REGEN_TIME)
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
	inst.components.childspawner.allowwater = true
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

    return inst
end

-- FUCK. I need to use the cursed fishable component because antchovy unique component does not work
-- because its unfinished and I will not try to mess with it. Yeah you gonna usa regular rod on ocean.
local antchovy_defs = 
{
	mouseover = { { 0, 0, 0 } },
}

local function antchovyfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_antchovy_ocean.tex")
	
	inst:SetPhysicsRadiusOverride(6)
	
	inst.AnimState:SetMultColour(.5, .5, .5, 1)
	
	inst.AnimState:SetBank("kyno_antchovy_ocean")
	inst.AnimState:SetBuild("kyno_antchovy_ocean")
	inst.AnimState:PlayAnimation("group_pre")
	inst.AnimState:PushAnimation(math.random() < .5 and "group_loop1" or "group_loop2")
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("antchovyspawner")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("birdblocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = antchovy_defs
	inst.decor = {}
	
	for item_name, data in pairs(decor_items) do
		for i, offset in pairs(data) do
			local item_inst = SpawnPrefab("kyno_antchovy_mouseover")
			item_inst.AnimState:PushAnimation("mouseover")
			item_inst.entity:SetParent(inst.entity)
			item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
			table.insert(inst.decor, item_inst)
		end
	end
	
	inst:AddComponent("fishable")
	inst.components.fishable:AddFish("kyno_antchovy")
	inst.components.fishable.maxfish = TUNING.KYNO_ANTCHOVY_MAX_FISH
	inst.components.fishable:SetRespawnTime(TUNING.KYNO_ANTCHOVY_REGROW_TIME)
	
	return inst
end

local function mouseoverfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetMultColour(1, 1, 1, 0)
	
	inst.AnimState:SetBank("kyno_antchovy_ocean")
	inst.AnimState:SetBuild("kyno_antchovy_ocean")
	inst.AnimState:PlayAnimation("mouseover")
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	
	inst:AddTag("FX")
	inst.persists = false
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

return Prefab("kyno_swordfish_spawner", swordfishfn, assets, prefabs),
Prefab("kyno_jellyfish_spawner", jellyfishfn, assets, prefabs),
Prefab("kyno_antchovy_spawner", antchovyfn, assets, prefabs),
Prefab("kyno_antchovy_mouseover", mouseoverfn, assets)