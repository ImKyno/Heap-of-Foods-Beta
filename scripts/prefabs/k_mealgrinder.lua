require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_mealingstone.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onturnoff(inst)
	inst.components.prototyper.on = false
	inst.AnimState:PlayAnimation("idle", true)
	inst.SoundEmitter:KillSound("mealing")
end

local function onturnon(inst)
	inst.components.prototyper.on = true
	inst.AnimState:PlayAnimation("proximity_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/mealing_stone/proximity_LP", "mealing")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("place")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_mealingstone.png")
	
    MakeObstaclePhysics(inst, .4)
	
    inst.AnimState:SetBank("quagmire_mealingstone")
    inst.AnimState:SetBuild("quagmire_mealingstone")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("mealinggrinder")
	inst:AddTag("prototyper")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("prototyper")
	inst.components.prototyper.onturnon = onturnon
	inst.components.prototyper.onturnoff = onturnoff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MEALING_TWO
	
	inst:AddComponent("wardrobe")
	inst.components.wardrobe:SetCanUseAction(false)
	inst.components.wardrobe:SetCanBeShared(true)
	inst.components.wardrobe:SetRange(TUNING.RESEARCH_MACHINE_DIST + .1)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_mealgrinder", fn, assets),
MakePlacer("kyno_mealgrinder_placer", "quagmire_mealingstone", "quagmire_mealingstone", "idle")