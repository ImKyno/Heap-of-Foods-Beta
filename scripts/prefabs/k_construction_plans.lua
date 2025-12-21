require("prefabutil")

local function MakeConstructionPlan(data)
	local assets = 
	{
		Asset("ANIM", "anim/"..(data.build or data.name)..".zip"),
		
		Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
		Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
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
			if data.onhitanim then
				inst.AnimState:PlayAnimation("hit")
				inst.AnimState:PushAnimation("idle", true)
			end
			
			inst.components.constructionsite:ForceStopConstruction()
		end
	end
	
	local function OnIgnite(inst)
		if inst.components.constructionsite ~= nil then
			inst.components.constructionsite:ForceStopConstruction()
			inst.components.constructionsite:Disable()
		end
	end
	
	local function OnExtinguish(inst)
		if inst.components.constructionsite ~= nil then
			inst.components.constructionsite:Enable()
		end
	end
	
	local function OnBurnt(inst)
		if inst.components.constructionsite ~= nil then
			inst.components.constructionsite:DropAllMaterials()
		end
		
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
		end
		
		inst:Remove()
	end
	
	local function OnBuilt(inst)
		PreventCharacterCollisionsWithPlacedObjects(inst)
		
		if data.onplaceanim then
			inst.AnimState:PlayAnimation("place")
			inst.AnimState:PushAnimation("idle", true)
		end
		
		if data.customonbuiltfx then
			local fx = SpawnPrefab(data.onbuiltfx)
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
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
		minimap:SetIcon(data.minimapicon..".tex")

		inst.Transform:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
		
		inst:SetPhysicsRadiusOverride(data.radius or 1.5)
		MakeObstaclePhysics(inst, inst.physicsradiusoverride)

		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation(data.anim, true)
		
		inst:AddTag("blocker")
		inst:AddTag("constructionsite")
		
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
		
		if data.nameoverride then
			inst:SetPrefabNameOverride(data.nameoverride)
		end

		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper.spawn_loot_inside_prefab = true
		if data.loot then
			inst.components.lootdropper:SetLoot(data.loot)
		end
		
		inst:AddComponent("constructionsite")
		inst.components.constructionsite:SetConstructionPrefab("construction_container")
		inst.components.constructionsite:SetOnConstructedFn(OnConstructed)
		
		if data.workable then
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
			inst.components.workable:SetOnFinishCallback(OnHammered)
			inst.components.workable:SetOnWorkCallback(OnHit)
			inst.components.workable:SetWorkLeft(4)
		end
		
		if data.burnable then
			MakeLargeBurnable(inst, nil, nil, true)
			inst.components.burnable:SetOnIgniteFn(OnIgnite)
			inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
			inst.components.burnable:SetOnBurntFn(OnBurnt)
			MakeSmallPropagator(inst)
		end
		
		if data.postinit ~= nil then
			data.postinit(inst)
		end
		
		MakeHauntableWork(inst)

		inst:ListenForEvent("onbuilt", OnBuilt)

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad

		return inst
	end
	
	return Prefab(data.name, fn, assets)
end

local constructions =
{
	--[[
	-- Moved to its own prefab due to reasons.
	-- Fish Hatchery.
	{
		name            = "kyno_fishfarmplot_construction",
		prefab_name     = "kyno_fishfarmplot",
		bank            = "kyno_fishfarmplot_construction",
		build           = "kyno_fishfarmplot_construction",
		anim            = "idle",
		minimapicon     = "kyno_fishfarmplot.tex",
		fx              = "collapse_big",
		material        = "wood",
		loot            = {"boards", "boards", "boards", "rope", "rope"},
		radius          = 5,
		workable        = true,
		burnable        = false,
		onhitanim       = true,
		onplaceanim     = true,
		customonbuiltfx = false,
	},
	]]--
	
	-- Anniversary Cake (Construction Empty)
	{
		name            = "kyno_hofbirthday_cake_empty_construction",
		prefab_name     = "kyno_hofbirthday_cake_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "idle_empty",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		material        = "straw",
		radius          = 1.2,
		workable        = true,
		burnable        = false,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = false,
		postinit        = function(inst)
			inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/table/food")
		end,
	},
	
	-- Anniversary Cake (Construction)
	{
		name            = "kyno_hofbirthday_cake_construction",
		prefab_name     = "kyno_hofbirthday_cake_stage1_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "construction",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		material        = "straw",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_EMPTY_CONSTRUCTION",
		radius          = 1.2,
		workable        = true,
		burnable        = false,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = false,
		postinit        = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
		end,
	},
	
	-- Anniversary Cake (Stage 1)
	{
		name            = "kyno_hofbirthday_cake_stage1_construction",
		prefab_name     = "kyno_hofbirthday_cake_stage2_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "stage1",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		onbuiltfx       = "kyno_hofbirthday_cake_fx_pink",
		material        = "cloth",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_STAGE",
		radius          = 1.2,
		workable        = false,
		burnable        = true,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = true,
	},
	
	-- Anniversary Cake (Stage 2)
	{
		name            = "kyno_hofbirthday_cake_stage2_construction",
		prefab_name     = "kyno_hofbirthday_cake_stage3_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "stage2",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		onbuiltfx       = "kyno_hofbirthday_cake_fx_white",
		material        = "cloth",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_STAGE",
		radius          = 1.2,
		workable        = false,
		burnable        = true,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = true,
	},
	
	-- Anniversary Cake (Stage 3)
	{
		name            = "kyno_hofbirthday_cake_stage3_construction",
		prefab_name     = "kyno_hofbirthday_cake_stage4_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "stage3",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		material        = "cloth",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_STAGE",
		radius          = 1.2,
		workable        = false,
		burnable        = true,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = false,
		postinit        = function(inst)
			local fx = SpawnPrefab("kyno_hofbirthday_cake_fx_orange")
			fx.Follower:FollowSymbol(inst.GUID, "level2", 0, 0, 0, true)
		end,
	},
	
	-- Anniversary Cake (Stage 4)
	{
		name            = "kyno_hofbirthday_cake_stage4_construction",
		prefab_name     = "kyno_hofbirthday_cake_stage5_construction",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "stage4",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		material        = "cloth",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_STAGE",
		radius          = 1.2,
		workable        = false,
		burnable        = true,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = false,
		postinit        = function(inst)
			local fx = SpawnPrefab("kyno_hofbirthday_cake_fx_white")
			fx.Follower:FollowSymbol(inst.GUID, "level2", 0, 0, 0, true)
		end,
	},
	
	-- Anniversary Cake (Stage 5)
	{
		name            = "kyno_hofbirthday_cake_stage5_construction",
		prefab_name     = "kyno_hofbirthday_cake",
		bank            = "kyno_hofbirthday_cake",
		build           = "kyno_hofbirthday_cake",
		anim            = "stage5",
		minimapicon     = "kyno_hofbirthday_cake",
		fx              = "collapse_big",
		tags            = { "anniversarycake" },
		material        = "cloth",
		nameoverride    = "KYNO_HOFBIRTHDAY_CAKE_STAGE",
		radius          = 1.2,
		workable        = false,
		burnable        = true,
		onhitanim       = false,
		onplaceanim     = false,
		customonbuiltfx = false,
		postinit        = function(inst)
			local fx = SpawnPrefab("kyno_hofbirthday_cake_fx_brown")
			fx.Follower:FollowSymbol(inst.GUID, "level3", 0, 0, 0, true)
		end,
	},
}

local prefabs = {}

for i, v in ipairs(constructions) do
	table.insert(prefabs, MakeConstructionPlan(v))
	table.insert(prefabs, MakePlacer(v.name.."_placer", v.bank, v.build, v.anim or "idle"))
end

return unpack(prefabs)