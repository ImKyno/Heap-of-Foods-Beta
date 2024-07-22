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

local function OnSpawn(inst, child)
	child.sg:GoToState("emerge")
end

local function OnAddChild(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
end

local function OnInit(inst)
	inst:DoTaskInTime(3360, function(inst)
		local crate = SpawnPrefab("kyno_serenityisland_crate")
	
		crate.Transform:SetPosition(inst.Transform:GetWorldPosition())
		crate.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
		
		inst:Remove()
	end)
end

local function crabfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
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
    inst.components.childspawner:SetSpawnedFn(OnSpawn)
    inst.components.childspawner:SetOnAddChildFn(OnAddChild)
    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner:SetSpawnPeriod(60)
    inst.components.childspawner:SetRegenPeriod(960)
    inst.components.childspawner:StartRegen()
	inst.components.childspawner:StartSpawning()

    return inst
end

local function chickenfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_chicken2_spawner.tex")
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("chicken2spawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_chicken2"
    inst.components.childspawner:SetOnAddChildFn(OnAddChild)
    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner:SetSpawnPeriod(60)
    inst.components.childspawner:SetRegenPeriod(960)
    inst.components.childspawner:StartRegen()
	inst.components.childspawner:StartSpawning()

    return inst
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
	
	OnInit(inst)
	
	return inst
end

return Prefab("kyno_pebblecrab_spawner", crabfn, assets, prefabs),
Prefab("kyno_chicken2_spawner", chickenfn, assets, prefabs),
Prefab("kyno_serenityisland_crate_spawner", cratefn, assets, prefabs)