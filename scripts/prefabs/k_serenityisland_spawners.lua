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

local function OnAddCrab(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
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
    inst.components.childspawner:SetSpawnedFn(OnSpawnCrab)
    inst.components.childspawner:SetOnAddChildFn(OnAddCrab)
    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner:SetSpawnPeriod(60)
    inst.components.childspawner:SetRegenPeriod(960)
    inst.components.childspawner:StartRegen()
	inst.components.childspawner:StartSpawning()

    return inst
end

local function CanSpawnHerdMember(inst)
    return inst.components.herd ~= nil and not inst.components.herd:IsFull()
end

local function OnSpawnedHerdMember(inst, newent)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
end

local function chickenfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_chicken2_spawner.tex")

    inst:AddTag("herd")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("chicken2")
	inst.components.herd:SetMaxSize(3)
    inst.components.herd:SetGatherRange(20)
    inst.components.herd:SetUpdateRange(40)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    inst.components.herd.nomerging = true

    inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(20, 20)
    -- inst.components.periodicspawner:SetRandomTimes(960, 960 * 0.5)
    inst.components.periodicspawner:SetPrefab("kyno_chicken2")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawnedHerdMember)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawnHerdMember)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    inst.components.periodicspawner:Start()

    return inst
end

local function OnInitCrate(inst)
	inst:DoTaskInTime(3360, function(inst)
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