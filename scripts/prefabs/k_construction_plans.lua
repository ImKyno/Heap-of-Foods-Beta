require("prefabutil")

local function MakeConstructionPlan(data)
	local assets = 
	{
		Asset("ANIM", "anim/"..(data.build or data.name)..".zip"),
		
		Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
		Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	}
	
	local function OnConstructed(inst, doer)
		local concluded = true
    
		for _, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
			if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
				concluded = false
				break
			end
		end

		if concluded then
			local construction = ReplacePrefab(inst, data.prefab_name)
			construction:PushEvent("onbuilt")
		end
	end
	
	local function OnHammered(inst, worker)
		if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
			inst.components.burnable:Extinguish()
		end
    
		inst.components.lootdropper:DropLoot()
	
		local fx = SpawnPrefab(data.fx)
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial(data.material)
	
		if inst.components.constructionsite ~= nil then
			inst.components.constructionsite:DropAllMaterials()
		end
		
		inst:Remove()
	end
	
	local function OnHit(inst, worker)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle", true)
			inst.components.constructionsite:ForceStopConstruction()
		end
	end

	local function OnBuilt(inst)
		PreventCharacterCollisionsWithPlacedObjects(inst)
		inst.AnimState:PlayAnimation("place")
		inst.AnimState:PushAnimation("idle", true)
	end
	
	local function OnSave(inst, data)
		if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
			data.burnt = true
		end
	end

	local function OnLoad(inst, data)
		if data ~= nil and data.burnt then
			inst.components.burnable.onburnt(inst)
		end
	end
	
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon(data.minimapicon)

		inst.Transform:SetScale(data.scale or .9, data.scale or .9, data.scale or .9)
		
		inst:SetPhysicsRadiusOverride(data.radius or 1.5)
		MakeObstaclePhysics(inst, inst.physicsradiusoverride)

		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation(data.anim, true)

		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot(data.loot)
		inst.components.lootdropper.spawn_loot_inside_prefab = true
		
		inst:AddComponent("constructionsite")
		inst.components.constructionsite:SetConstructionPrefab("construction_container")
		inst.components.constructionsite:SetOnConstructedFn(OnConstructed)
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetOnFinishCallback(OnHammered)
		inst.components.workable:SetOnWorkCallback(OnHit)
		inst.components.workable:SetWorkLeft(4)
		
		if data.burnable then
			MakeHauntableWork(inst)
			MakeLargeBurnable(inst, nil, nil, true)
			MakeMediumPropagator(inst)
		end

		inst:ListenForEvent("onbuilt", OnBuilt)

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad

		return inst
	end
	
	return Prefab(data.name, fn, assets)
end

local constructions =
{
	-- Fish Hatchery.
	{
		name        = "kyno_fishfarmplot_construction",
		prefab_name = "kyno_fishfarmplot",
		bank        = "kyno_fishfarmplot_construction",
		build       = "kyno_fishfarmplot_construction",
		anim        = "idle",
		minimapicon = "kyno_fishfarmplot.tex",
		fx          = "collapse_big",
		material    = "wood",
		loot        = {"boards", "boards", "boards", "rope", "rope"},
		radius      = 5,
		burnable    = false,
	},
}

local prefabs = {}

for i, v in ipairs(constructions) do
	table.insert(prefabs, MakeConstructionPlan(v))
	table.insert(prefabs, MakePlacer(v.name.."_placer", v.bank, v.build, v.anim or "idle"))
end

return unpack(prefabs)