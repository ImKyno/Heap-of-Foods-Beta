require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/kyno_ocean_wreck.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"boards",
	"collapse_big",
	"ghost",
	
	"kyno_limpets",
}

local MAST       = 1
local BOW        = 2
local MIDSHIP    = 3
local STERN      = 4

local anims      =
{
	mast         =
	{
		full     = "idle_full1",
		empty    = "idle_empty1",
		grow     = "grow1",
		picked   = "picked1",
		hitfull  = "hit_full1",
		hitempty = "hit_empty1",
	},
	bow          =
	{
		full     = "idle_full2",
		empty    = "idle_empty2",
		grow     = "grow2",
		picked   = "picked2",
		hitfull  = "hit_full2",
		hitempty = "hit_empty2",
	},
	midship      =
	{
		full     = "idle_full3",
		empty    = "idle_empty3",
		grow     = "grow3",
		picked   = "picked3",
		hitfull  = "hit_full3",
		hitempty = "hit_empty3",
	},
	stern        =
	{
		full     = "idle_full4",
		empty    = "idle_empty4",
		grow     = "grow4",
		picked   = "picked4",
		hitfull  = "hit_full4",
		hitempty = "hit_empty4",
	},
}

local sizes      =
{
	mast         = 0.1,
	bow          = 0.9,
	midship      = 0.9,
	stern        = 0.9,
}

local sounds     =
{
	-- mast      = "dontstarve_DLC002/common/graveyard_shipwreck/shipwreck_1",
	-- bow       = "dontstarve_DLC002/common/graveyard_shipwreck/shipwreck_2",
	-- midship   = "dontstarve_DLC002/common/graveyard_shipwreck/shipwreck_3",
	-- stern     = "dontstarve_DLC002/common/graveyard_shipwreck/shipwreck_4",
}

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation(anims[inst.wrecktype].empty, true)
end

local function makebarrenfn(inst)
	-- What we do?
end

local function onpickedfn(inst, picker)
	if inst.components.pickable then
		inst.AnimState:PlayAnimation(anims[inst.wrecktype].picked)
		inst.AnimState:PushAnimation(anims[inst.wrecktype].empty, true)
	end
end

local function getregentimefn(inst)
	return TUNING.KYNO_LIMPETROCK_GROWTIME
end

local function makefullfn(inst)
	inst.AnimState:PlayAnimation(anims[inst.wrecktype].grow)
	inst.AnimState:PushAnimation(anims[inst.wrecktype].full, true)
end

local function OnWorked(inst, worker, workleft)
	if inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation(anims[inst.wrecktype].hitfull)
		inst.AnimState:PushAnimation(anims[inst.wrecktype].full, true)
	else
		inst.AnimState:PlayAnimation(anims[inst.wrecktype].hitempty)
		inst.AnimState:PushAnimation(anims[inst.wrecktype].empty, true)
	end
end

local function OnHammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	
	if math.random() < 0.50 then
		local ghost = SpawnPrefab("ghost")
		if ghost then
			local pos = Point(inst.Transform:GetWorldPosition())
			ghost.Transform:SetPosition(pos.x - .3, pos.y, pos.z - .3)
		end
	end
	
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		for i = 1, inst.components.pickable.numtoharvest do
			inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		end
	end
	
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")

	inst:Remove()
end

local function SetType(inst, wrecktype)
	if type(wrecktype) == "number" or wrecktype == "random" then
		local types = {"mast", "bow", "midship", "stern"}
		inst.wrecktype = types[math.random(1, #types)]
	elseif wrecktype == "hull" then
		local hulls = {"bow", "midship", "stern"}
		inst.wrecktype = hulls[math.random(1, #hulls)]
	else
		inst.wrecktype = wrecktype
	end
	
	inst.AnimState:PlayAnimation(anims[inst.wrecktype].full, true)
	inst.Physics:SetCapsule(sizes[inst.wrecktype], 2.0)
end

local function PickNames(inst)
	if inst.components.named == nil then
		inst:AddComponent("named")
		inst.components.named.nameformat = STRINGS.NAMES.WRECKOF
		inst.components.named.possiblenames = STRINGS.SHIPNAMES
		inst.components.named:PickNewName()
	end
end

local function MakeHaunted(inst)
	inst.haunted = true
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.EVERGREEN_CHOPS_SMALL)
    end
end

local function OnSave(inst, data)
	data.wrecktype = inst.wrecktype
	data.haunted = inst.haunted
end

local function OnLoad(inst, data)
	if data and data.werecktype then
		SetType(inst, data.wrecktype)
	end
end

local function OnPreLoad(inst, data)
    WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_OCEAN_WRECK_GROWTIME)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ocean_wreck.tex")
	
	MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)
	-- MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("shipwreck")
	inst.AnimState:SetBuild("kyno_ocean_wreck")
	
	inst:AddTag("ocean_wreck")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_OCEAN_WRECK_GROWTIME, true)
	inst.components.pickable:SetUp("kyno_limpets", TUNING.KYNO_OCEAN_WRECK_GROWTIME)
	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.numtoharvest = math.random(2, 3)
	inst.components.pickable.witherable = false

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_OCEANWRECK_WORKLEFT)
	inst.components.workable:SetOnWorkCallback(OnWorked)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:AddComponent("named")
	inst.components.named.nameformat = STRINGS.NAMES.KYNO_WRECK_OF
	inst.components.named.possiblenames = STRINGS.KYNO_WRECK_NAMES
	inst.components.named:PickNewName()

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boards", "boards", "kyno_limpets"})

	SetType(inst, "random")

	inst:ListenForEvent("on_collide", OnCollide)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad

	MakeLargeBurnable(inst)
    MakeSmallPropagator(inst)
	AddToRegrowthManager(inst)

	return inst
end

return Prefab("kyno_ocean_wreck", fn, assets, prefabs)