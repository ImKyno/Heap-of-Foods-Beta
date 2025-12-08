require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_hofbirthday_cake.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_hofbirthday_cake_fx_white",
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("cloth")

	inst:Remove()
end

local function OnBuilt(inst, data)	
	local fx = SpawnPrefab("kyno_hofbirthday_cake_fx_white")
	fx.Follower:FollowSymbol(inst.GUID, "level3", 0, 0, 0, true)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_hofbirthday_cake.tex")

	MakeObstaclePhysics(inst, 1.2)

	inst.AnimState:SetBank("kyno_hofbirthday_cake")
	inst.AnimState:SetBuild("kyno_hofbirthday_cake")
	inst.AnimState:PlayAnimation("idle_full", true)

	inst:AddTag("structure")
	inst:AddTag("anniversarycake")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

return Prefab("kyno_hofbirthday_cake", fn, assets, prefabs),
MakePlacer("kyno_hofbirthday_cake_placer", "kyno_hofbirthday_cake", "kyno_hofbirthday_cake", "idle_full")