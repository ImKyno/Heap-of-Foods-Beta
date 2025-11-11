require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/graves_water.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs = 
{
	"kelp",
	
	"kyno_tunacan",
	"kyno_mysterymeat",
    "kyno_seaweeds",
	"kyno_waterycress",
	"kyno_taroroot",
	"kyno_mussel",
	"kyno_limpets",
	"kyno_neonfish",
	"kyno_tropicalfish",
	"kyno_grouper",
	"kyno_koi",
	"kyno_pierrotfish",
	"kyno_tomatocan",
	"kyno_beancan",
	"kyno_meatcan",
	"kyno_antchovycan",
	"kyno_sodacan",
	"kyno_cokecan",
	"kyno_energycan",
	"kyno_fishpackage",
}

local anims =
{
    {idle = "idle1", pst = "fishing_pst1"},
    {idle = "idle2", pst = "fishing_pst2"},
    {idle = "idle3", pst = "fishing_pst3"},
    {idle = "idle4", pst = "fishing_pst4"},
    {idle = "idle5", pst = "fishing_pst5"},
}

local names = {"idle1", "idle2", "idle3", "idle4", "idle5"}

local function OnRetrieve(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")

	if worker and worker.components.sanity then
		worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
	end
	
	if inst:HasTag("not_serenity_crate") then
		inst:Remove()
	else
		SpawnPrefab("kyno_serenityisland_crate_spawner").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	end
end

local function OnFished(inst, worker)
	local pt = worker and worker:GetPosition() or nil
	
	inst.components.lootdropper:SpawnLootPrefab("kyno_seaweeds")
	inst.components.lootdropper:DropLoot()
	
	if math.random() < 0.10 then
		local squid = SpawnPrefab("squid")
		squid.Transform:SetPosition(inst.Transform:GetWorldPosition())
		squid.components.combat:SuggestTarget(worker)
	end

    OnRetrieve(inst, worker)
end

local function OnWorkedInventory(inst, worker)
    local loot = {}
	
    if inst.sunkeninventory ~= nil then
        for k,v in pairs(inst.sunkeninventory) do
            local pref = SpawnPrefab(v.prefab)
            pref:SetPersistData(v.data, {})
            table.insert(loot, pref)
        end
    end
	
    OnRetrieve(inst, worker, loot)
end

local function OnIgnite(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
end

local function OnBurnt(inst, worker)
	local pt = worker and worker:GetPosition() or nil
	
	inst.components.pickable.canbepicked = false
	
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	
    inst:Remove()
end

local DAMAGE_SCALE = 0.2
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * 9)
    end
end

local function OnSave(inst, data)
    data.sunkeninventory = inst.sunkeninventory
	data.anim = inst.animname
	
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
	end
end

local function OnLoad(inst, data)
    if data and data.sunkeninventory then
        inst.sunkeninventory = data.sunkeninventory
    end
	
	if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname, true)
    end
	
	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_serenityisland_crate.tex")
	
	inst:SetPhysicsRadiusOverride(.7)
	MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.AnimState:SetBank("graves_water")
    inst.AnimState:SetBuild("graves_water")
	
	inst:AddTag("blocker")
	inst:AddTag("watery_crate")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnFished)
    inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp(nil)
    inst.components.pickable.onpickedfn = OnFished
	inst.components.pickable.quickpick = true
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	inst:AddComponent("lootdropper")
	
	local rarity = 
	{
		verylow 	= 64,
		low			= 32,
		med			= 16,
		high		= 8,
		veryhigh	= 4,
		extreme		= 1,
		easteregg	= .1,
    }
	
	inst.components.lootdropper:AddRandomLoot("kyno_tunacan", 		 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("meat_dried",   		 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("spoiled_food", 		 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("cutgrass", 		  	 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("twigs", 		         rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("log", 				 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("kyno_tomatocan", 		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_beancan", 		 	 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_meatcan", 		 	 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_antchovycan", 		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_waterycress", 		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_taroroot",    		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_seaweeds",    		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_limpets",     		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("rope", 			  		 rarity.low)
	inst.components.lootdropper:AddRandomLoot("boards", 			  	 rarity.low)
	inst.components.lootdropper:AddRandomLoot("kyno_cokecan", 			 rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_sodacan", 			 rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_energycan", 		 rarity.med)
	inst.components.lootdropper:AddRandomLoot("seeds", 					 rarity.med)
	inst.components.lootdropper:AddRandomLoot("boneshard", 			     rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_oil",               rarity.high)
	inst.components.lootdropper:AddRandomLoot("kyno_lotus_flower", 		rarity.high)
	inst.components.lootdropper:AddRandomLoot("kelp", 	           		rarity.high)
	inst.components.lootdropper:AddRandomLoot("kyno_roe_pondfish", 		rarity.high)
	inst.components.lootdropper:AddRandomLoot("silk",                   rarity.high)
	inst.components.lootdropper:AddRandomLoot("livinglog", 			rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("batwing",       		rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("saltrock",      		rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("kyno_crabmeat", 		rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("wormlight",     		rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("wormlight_lesser", 	rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("purplegem", 			rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("bluegem",			rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("orangegem", 			rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("yellowgem", 			rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("greengem", 			rarity.veryhigh) 
	inst.components.lootdropper:AddRandomLoot("mandrake", 	         rarity.extreme)
	
	inst.components.lootdropper.numrandomloot = 1
	
    if math.random() < 0.20 then
		inst.components.lootdropper:AddChanceLoot("kyno_fishpackage",		   1.00)
    end
	
	if math.random() < 0.01 then
		inst.components.lootdropper:AddChanceLoot("kyno_mysterymeat", 		   1.00)
	end
	
	inst:ListenForEvent("on_collide", OnCollide)
	
	inst.sunkeninventory = {}

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
	MakeSmallPropagator(inst)

    return inst
end

local function wateryfn()
	local inst = fn()
	
	inst:AddTag("not_serenity_crate")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	AddToRegrowthManager(inst)
	
	return inst
end

return Prefab("kyno_serenityisland_crate", fn, assets, prefabs), -- This only spawns near the Serenity Archipelago.
Prefab("kyno_watery_crate", wateryfn, assets, prefabs) -- This one is for other places.