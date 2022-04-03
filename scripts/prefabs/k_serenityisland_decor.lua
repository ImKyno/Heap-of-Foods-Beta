local assets =
{
	Asset("ANIM", "anim/quagmire_rubble.zip"),
}

local names = {"f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9"}

local function SetAnim(inst, anim)
	inst.anim = anim
	inst.AnimState:PlayAnimation("idle" .. anim)
end

local function OnSave(inst, data)
    data.anim = inst.animname
end

local function OnLoad(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local s = .75

local function rubblefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
    inst.AnimState:SetBank("quagmire_rubble")
    inst.AnimState:SetBuild("quagmire_rubble")
    
	inst:AddTag("DECOR")
    inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks"})
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("kyno_serenityisland_decor", rubblefn, assets)