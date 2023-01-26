local assets =
{
    Asset("ANIM", "anim/quagmire_pebble_crab.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
    "kyno_pebblecrab",
}

local function OnSpawn(inst, child)
	child.sg:GoToState("emerge")
end

local function OnAddChild(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
end

local function spawnerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_crab_spawner.tex")
	
	inst:AddTag("serenitycrabspawner")
	inst:AddTag("CLASSIFIED")

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

return Prefab("kyno_pebblecrab_spawner", spawnerfn, assets, prefabs)