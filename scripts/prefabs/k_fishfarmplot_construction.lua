require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/hermithotspring.zip"),

    Asset("ANIM", "anim/kyno_fishfarmplot.zip"),
	Asset("ANIM", "anim/kyno_fishfarmplot_kit.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"boards",
	"construction_container",
	"rope",

	"kyno_fishfarmplot",
	"kyno_fishfarmplot_kit",
}

local function OnHammered(inst)
	if not inst:IsAsleep() then
		local fx = SpawnPrefab("collapse_big")
		
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
	{ r = 2.75,	dir = 2		},
	{ r = 2.75,	dir = 62	},
	{ r = 2.7,	dir = 115	},
	{ r = 2.6,	dir = 177	},
	{ r = 2.55,	dir = 237	},
	{ r = 2.5,	dir = 298	},
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
		local construction = ReplacePrefab(inst, "kyno_fishfarmplot")
		construction:PushEvent("onbuilt")
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

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_fishfarmplot.tex")
	
	inst.Transform:SetScale(1.4, 1.4, 1.4)

	inst:SetPhysicsRadiusOverride(5)
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

return Prefab("kyno_fishfarmplot_construction", fn, assets, prefabs),
MakePlacer("kyno_fishfarmplot_construction_placer", "kyno_fishfarmplot", "kyno_fishfarmplot", "idle", true, nil, nil, .9)