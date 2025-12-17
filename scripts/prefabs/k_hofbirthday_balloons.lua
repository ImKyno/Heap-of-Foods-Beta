require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_hofbirthday_balloons.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"rope",	
	"kyno_hofbirthday_cheer",
}

local function SanityAura(inst, observer)
	return TUNING.SANITYAURA_SMALL
end

local function OnHit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
end

local function OnHammered(inst, worker)
	inst.AnimState:PlayAnimation("remove")
	
	inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
	inst.SoundEmitter:PlaySound("wes/characters/wes/deflate_speedballoon")
	
	inst.components.lootdropper:DropLoot()
	
	inst:ListenForEvent("animover", inst.Remove)
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.SoundEmitter:PlaySound("wes/characters/wes/breath_idle")
	inst.SoundEmitter:PlaySound("wes/characters/wes/blow_idle")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("kyno_hofbirthday_balloons.tex")

	MakeObstaclePhysics(inst, .6)

	inst.AnimState:SetBank("kyno_hofbirthday_balloons")
	inst.AnimState:SetBuild("kyno_hofbirthday_balloons")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
	inst:AddTag("anniversary_balloons")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("kyno_hofbirthday_balloons", fn, assets, prefabs),
MakePlacer("kyno_hofbirthday_balloons_placer", "kyno_hofbirthday_balloons", "kyno_hofbirthday_balloons", "idle")