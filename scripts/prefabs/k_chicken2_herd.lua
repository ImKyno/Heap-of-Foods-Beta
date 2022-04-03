local prefabs =
{
    "kyno_chicken2",
}

local function CanSpawn(inst)
    return inst.components.herd ~= nil and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, newent)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("chicken2")
	inst.components.herd:SetMaxSize(2)
    inst.components.herd:SetGatherRange(10)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    inst.components.herd.nomerging = false

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(960, 0.5*480)
    inst.components.periodicspawner:SetPrefab("kyno_chicken2")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    inst.components.periodicspawner:Start()

    return inst
end

return Prefab("kyno_chicken2_herd", fn, nil, prefabs)