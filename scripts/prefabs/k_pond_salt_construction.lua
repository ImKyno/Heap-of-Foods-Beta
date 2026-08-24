require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/hermithotspring.zip"),
	Asset("ANIM", "anim/quagmire_salt_pond.zip"),
	Asset("ANIM", "anim/quagmire_salt_rack.zip"),
	Asset("ANIM", "anim/splash.zip"),

	Asset("ANIM", "anim/kyno_salt_pond_rack.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"boards",
	"collapse_small",
	"construction_container",
	"rope",

	"kyno_pond_salt2",
}

local function OnHammered(inst)
	if not inst:IsAsleep() then
		local fx = SpawnPrefab("collapse_small")

		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("stone")
	end

	inst.components.lootdropper:DropLoot()

	if inst.components.constructionsite ~= nil then
		inst.components.constructionsite:DropAllMaterials()
	end

	inst:Remove()
end

local function DoSyncAnim(inst)
	if inst.AnimState:IsCurrentAnimation("construction_place") then
		local t = inst.AnimState:GetCurrentAnimationTime()

		for _, v in ipairs(inst.pegs) do
			v.AnimState:PlayAnimation("peg_place")
			v.AnimState:SetTime(t)
			v.AnimState:PushAnimation("peg_idle", false)
		end

		inst.hole.AnimState:PlayAnimation("construction_hole_place")
		inst.hole.AnimState:SetTime(t)
		inst.hole.AnimState:PushAnimation("empty", false)
	else
		inst.hole.AnimState:PlayAnimation("empty")

		if inst.AnimState:IsCurrentAnimation("construction_reveal") then
			local t = inst.AnimState:GetCurrentAnimationTime()

			for _, v in ipairs(inst.pegs) do
				v.AnimState:PlayAnimation("peg_reveal")
				v.AnimState:SetTime(t)
			end
		elseif not inst.pegs[1].AnimState:IsCurrentAnimation("peg_hit") then
			for _, v in ipairs(inst.pegs) do
				v.AnimState:PlayAnimation("peg_idle")
			end
		end
	end

	if inst.postupdating then
		inst.postupdating = nil
		inst.components.updatelooper:RemovePostUpdateFn(DoSyncAnim)
	end
end

local function OnSyncAnimDirty(inst)
	if inst.syncanim:value() then
		if inst.pegs[1].AnimState:IsCurrentAnimation("peg_idle") or
			inst.pegs[1].AnimState:IsCurrentAnimation("peg_hit")
		then
			for _, v in ipairs(inst.pegs) do
				v.AnimState:PlayAnimation("peg_hit")
				v.AnimState:PushAnimation("peg_idle", false)
			end

			if inst.postupdating then
				inst.postupdating = nil
				inst.components.updatelooper:RemovePostUpdateFn(DoSyncAnim)
			end
		end
	elseif TheWorld.ismastersim then
		DoSyncAnim(inst)
	elseif not inst.postupdating then
		inst.postupdating = true
		inst.components.updatelooper:AddPostUpdateFn(DoSyncAnim)
	end
end

local function PushSyncAnim(inst, anim)
	inst.syncanim:set_local(false)
	inst.syncanim:set(anim == "hit")

	if inst.pegs then
		OnSyncAnimDirty(inst)
	end
end

local function CreateHole()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("hermithotspring")
	inst.AnimState:SetBuild("hermithotspring")
	inst.AnimState:PlayAnimation("empty")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset(-1)

	inst:AddTag("FX")
	inst.persists = false

	return inst
end

local function CreatePeg()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.Transform:SetSixFaced()

	inst.AnimState:SetBank("hermithotspring")
	inst.AnimState:SetBuild("hermithotspring")

	inst:AddTag("FX")
	inst.persists = false

	return inst
end

-- Number order is left to right.
local PEGS =
{
	{ r = 2.40, dir = 2   },
	{ r = 2.40, dir = 62  },
	{ r = 2.35, dir = 115 },
	{ r = 2.30, dir = 177 },
	{ r = 2.20, dir = 237 },
	{ r = 2.20, dir = 298 },
}

local function OnEntityWake(inst)
	inst.OnEntityWake = nil

	if inst.highlightchildren == nil then
		inst.highlightchildren = {}
	end

	inst.pegs = {}

	for i, v in ipairs(PEGS) do
		local peg = CreatePeg()

		peg.entity:SetParent(inst.entity)
		inst.pegs[i] = peg

		table.insert(inst.highlightchildren, peg)

		local theta = v.dir * DEGREES
		peg.Transform:SetPosition(v.r * math.cos(theta), 0, -v.r * math.sin(theta))
		peg.Transform:SetRotation(v.dir)
	end

	inst.hole = CreateHole()
	inst.hole.entity:SetParent(inst.entity)

	if not TheWorld.ismastersim then
		inst:AddComponent("updatelooper")
		inst:ListenForEvent("syncanimdirty", OnSyncAnimDirty)
	end

	DoSyncAnim(inst)
end

local function OnConstructed(inst, doer)
	local concluded = true

	for _, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end

	if concluded then
		local rotation = inst.Transform:GetRotation()
		local construction = ReplacePrefab(inst, "kyno_pond_salt2")

		construction.Transform:SetRotation(rotation)
		construction:PushEvent("onbuilt", { builder = doer })
	end
end

local function OnBuilt(inst)
	if not inst:IsAsleep() then
		inst.AnimState:PlayAnimation("construction_place")
		inst.AnimState:PushAnimation("construction_idle", false)

		inst.SoundEmitter:PlaySound("hookline_2/common/hotspring/construction_place")
		PushSyncAnim(inst, "place")
	end
end

local function OnHit(inst)
	inst.components.constructionsite:ForceStopConstruction()

	if not inst:IsAsleep() then
		PushSyncAnim(inst, "hit")
	end
end

local rack_defs =
{
	rack = { { 0, 0, 0 } },
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pond_rack.tex")

	inst.Transform:SetScale(1.2, 1.2, 1.2)

	inst:SetPhysicsRadiusOverride(3)
	MakeObstaclePhysics(inst, inst.physicsradiusoverride)

	inst.AnimState:SetBank("hermithotspring")
	inst.AnimState:SetBuild("hermithotspring")
	inst.AnimState:PlayAnimation("construction_idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("blocker")
	inst:AddTag("constructionsite")

	inst.syncanim = net_bool(inst.GUID, "hermithotspring_constr.syncanim", "syncanimdirty")

	if not TheNet:IsDedicated() then
		inst.OnEntityWake = OnEntityWake
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("constructionsite")
	inst.components.constructionsite:SetConstructionPrefab("construction_container")
	inst.components.constructionsite:SetOnConstructedFn(OnConstructed)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(4)

	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeHauntableWork(inst)

	return inst
end

local function CreateSaltPondPlacer(inst, offset)
	local placer = CreateEntity()

	placer.entity:SetCanSleep(false)
	placer.persists = false

	placer.entity:AddTransform()
	placer.entity:AddAnimState()

	placer.AnimState:SetBank("quagmire_salt_pond")
	placer.AnimState:SetBuild("quagmire_salt_pond")
	placer.AnimState:PlayAnimation("idle", true)
	placer.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	placer.AnimState:SetLightOverride(1)

	placer:AddTag("CLASSIFIED")
	placer:AddTag("NOCLICK")
	placer:AddTag("placer")

	placer.Transform:SetPosition(offset[1], offset[2], offset[3])
	placer.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(placer)

	return placer
end

local function placerfn(inst)
	for item_name, data in pairs(rack_defs) do
		for i, offset in pairs(data) do
			CreateSaltPondPlacer(inst, offset)
		end
	end
end

return Prefab("kyno_pond_salt2_construction", fn, assets, prefabs),
MakePlacer("kyno_pond_salt2_construction_placer", "quagmire_salt_rack", "quagmire_salt_rack", "idle", false, nil, nil, 1, 90, nil, placerfn)