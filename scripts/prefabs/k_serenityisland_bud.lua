local assets =
{
	Asset("ANIM", "anim/kyno_serenityisland_bud.zip"),
	Asset("ANIM", "anim/kyno_serenityisland_sapling.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_sugartree_bud",
	"kyno_sugartree_flower",
	"kyno_sugartree_flower_planted",
	"kyno_sugartree_petals",
	"kyno_sugartree_sapling",
}

local names               = { "idle1", "idle2" }
local FINDLIGHT_MUST_TAGS = { "daylight", "lightsource" }
local LEIF_TAGS           = { "leif" }

local function plant(inst, growtime)
    local sapling = SpawnPrefab("kyno_sugartree_sapling")
    sapling:StartGrowing()
	
    sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
	
    inst:Remove()
end

local function ondeploy(inst, pt, deployer)
    inst = inst.components.stackable:Get()
    inst.Physics:Teleport(pt:Get())
	
    local timeToGrow = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
    plant(inst, timeToGrow)

    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.LEIF_PINECONE_CHILL_RADIUS, LEIF_TAGS)

    local played_sound = false
    for i, v in ipairs(ents) do
        local chill_chance =
            v:GetDistanceSqToPoint(pt:Get()) < TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS * TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS and
            TUNING.LEIF_PINECONE_CHILL_CHANCE_CLOSE or
            TUNING.LEIF_PINECONE_CHILL_CHANCE_FAR

        if math.random() < chill_chance then
            if v.components.sleeper ~= nil then
                v.components.sleeper:GoToSleep(1000)
                AwardPlayerAchievement( "pacify_forest", deployer )
            end
        elseif not played_sound then
            v.SoundEmitter:PlaySound("dontstarve/creatures/leif/taunt_VO")
            played_sound = true
        end
    end
end

local function onpickedfn(inst, picker)
    local pos = inst:GetPosition()

    if picker ~= nil then
        if picker.components.sanity ~= nil and not picker:HasTag("plantkin") then
			picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
		end
	end

    TheWorld:PushEvent("plantkilled", { doer = picker, pos = pos })
end

local function DieInDarkness(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,0,z, TUNING.DAYLIGHT_SEARCH_RANGE, FINDLIGHT_MUST_TAGS)

    for i,v in ipairs(ents) do
        local lightrad = v.Light:GetCalculatedRadius() * .7
        if v:GetDistanceSqToPoint(x,y,z) < lightrad * lightrad then
            return
        end
    end
	
    inst:Remove()
	
    SpawnPrefab("flower_withered").Transform:SetPosition(x,y,z)
end

local function OnIsCaveDay(inst, isday)
    if isday then
        inst:DoTaskInTime(5.0 + math.random()* 5.0, DieInDarkness)
    end
end

local function OnBurnt(inst)
    DefaultBurntFn(inst)
end

local function OnSave(inst, data)
	data.planted = inst.planted
	data.anim = inst.animname
	
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
	end
end

local function OnLoad(inst, data)
    if data ~= nil and data.growtime ~= nil then
        plant(inst, data.growtime)
    end
	
	if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname, true)
    end
	
	if data and data.burnt then
		OnBurnt(inst)
	end
	
	inst.planted = data ~= nil and data.planted or nil
end

local function budfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	local s = .75
	inst.AnimState:SetScale(s, s, s)

	inst.AnimState:SetBank("kyno_serenityisland_bud")
	inst.AnimState:SetBuild("kyno_serenityisland_bud")
	inst.AnimState:PlayAnimation("idle_nut")
	
	inst:AddTag("deployedplant")
	inst:AddTag("cattoy")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("winter_treeseed")
	inst.components.winter_treeseed:SetTree("kyno_winter_sugartree")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	inst.components.deployable.ondeploy = ondeploy

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)
	
	inst.OnLoad = OnLoad

	return inst
end

local function flowerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("kyno_serenityisland_bud")
    inst.AnimState:SetBuild("kyno_serenityisland_bud")
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("sugarflower")
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_sugartree_petals")
    inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.remove_when_picked = true
    inst.components.pickable.quickpick = true
    inst.components.pickable.wildfirestarter = true
	
	if TheWorld:HasTag("cave") then
        inst:WatchWorldState("iscaveday", OnIsCaveDay)
    end
	
	inst.OnSave	= OnSave
	inst.OnLoad = OnLoad

	MakeSmallBurnable(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeSmallPropagator(inst)
	-- AddToRegrowthManager(inst)

    return inst
end

local function petalsfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_serenityisland_bud")
	inst.AnimState:SetBuild("kyno_serenityisland_bud")
	inst.AnimState:PlayAnimation("idle", false)
	
	inst:AddTag("show_spoilage")
	inst:AddTag("cattoy")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 5
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

function plantedflowerfn()
    local inst = flowerfn()

    inst:SetPrefabName("kyno_sugartree_flower")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.planted = true

    return inst
end

return Prefab("kyno_sugartree_bud", budfn, assets, prefabs),
Prefab("kyno_sugartree_flower", flowerfn, assets, prefabs),
Prefab("kyno_sugartree_flower_planted", plantedflowerfn, assets, prefabs),
Prefab("kyno_sugartree_petals", petalsfn, assets, prefabs),
MakePlacer("kyno_sugartree_bud_placer", "kyno_serenityisland_sapling", "kyno_serenityisland_sapling", "planted")