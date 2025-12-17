local assets =
{	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
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

local function flupfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("meadowflupspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	--[[
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "kyno_meadowflup"
    inst.components.childspawner:SetSpawnedFn(OnSpawn)
    inst.components.childspawner:SetOnAddChildFn(OnAddChild)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(60)
    inst.components.childspawner:SetRegenPeriod(960)
    inst.components.childspawner:StartRegen()
	inst.components.childspawner:StartSpawning()
	]]--

    return inst
end

return Prefab("kyno_meadowflup_spawner", flupfn, assets, prefabs)