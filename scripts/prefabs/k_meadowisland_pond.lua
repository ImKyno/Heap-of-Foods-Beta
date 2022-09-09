local assets =
{
	Asset("ANIM", "anim/kyno_meadowisland_pond.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_planty.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_meadowisland_planty",
	
	"kyno_tropicalfish",
	"kyno_pierrotfish",
	"kyno_neonfish",
	"kyno_grouper",
	"kyno_koi",
}

local function SpawnPlants(inst, plantname, count, maxradius)
	if inst.decor then
		for i,item in ipairs(inst.decor) do
			item:Remove()
		end
	end
	
	inst.decor = {}
	local plant_offsets = {}

	for i=1, math.random(math.ceil(count/2), count) do
		local a = math.random()*math.pi*2
		local x = math.sin(a)*maxradius+math.random()*0.3
		local z = math.cos(a)*maxradius+math.random()*0.3
		table.insert(plant_offsets, {x,0,z})
	end

	for k, offset in pairs(plant_offsets) do
		local plant = SpawnPrefab(plantname)
		plant.entity:SetParent(inst.entity)
		plant.Transform:SetPosition(offset[1], offset[2], offset[3])
		table.insert(inst.decor, plant)
	end
end

local sizes =
{
	{anim = "small_idle", rad = 2.0, plantcount = 2, plantrad = 1.6},
	{anim = "med_idle",   rad = 2.6, plantcount = 3, plantrad = 2.5},
	{anim = "big_idle",   rad = 3.6, plantcount = 4, plantrad = 3.4},
}

local function SetSize(inst, size)
	inst.size = math.random(1, #sizes)
	inst.AnimState:PlayAnimation(sizes[inst.size].anim, true)
	inst.Physics:SetCylinder(sizes[inst.size].rad, 1.0)
	SpawnPlants(inst, "kyno_meadowisland_planty", sizes[inst.size].plantcount, sizes[inst.size].plantrad)
end

local function GetFish(inst, isfullmoon)
    return (TheWorld.state.isautumn and "kyno_tropicalfish") or (TheWorld.state.iswinter and "kyno_neonfish") 
	or (TheWorld.state.isspring and "kyno_pierrotfish") or (TheWorld.state.issummer and "kyno_koi")
end

local function OnSave(inst, data)
	data.size = inst.size
end

local function OnLoad(inst, data, newents)
	if data and data.size then
		SetSize(inst, data.size)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_pond.tex")
	
    MakeObstaclePhysics(inst, 3.5)

    inst.AnimState:SetBuild("kyno_meadowisland_pond")
    inst.AnimState:SetBank("kyno_meadowisland_pond")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("fishable")
	inst:AddTag("watersource")
	inst:AddTag("blocker")
	inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("savedrotation")
	inst:AddComponent("watersource")

	inst:AddComponent("fishable")
	inst.components.fishable.maxfish = TUNING.MEADOWISLAND_POND_MAX_FISH
	inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	inst.components.fishable:SetGetFishFn(GetFish)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	SetSize(inst)

	return inst
end

local function plantfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_meadowisland_planty")
	inst.AnimState:SetBuild("kyno_meadowisland_planty")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	
	return inst
end

return Prefab("kyno_meadowisland_pond", fn, assets, prefabs),
Prefab("kyno_meadowisland_planty", plantfn, assets, prefabs)