local assets =
{
	Asset("ANIM", "anim/kyno_meadowisland_tree_sapling.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_oaktree_pod",
	"kyno_meadowisland_tree_sapling",
}

local function OnPlant(inst, growtime)
    local sapling = SpawnPrefab("kyno_meadowisland_tree_sapling")
    sapling:StartGrowing()
    sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst:Remove()
end

local LEIF_TAGS = { "leif" }
local function OnDeploy(inst, pt, deployer)
    inst = inst.components.stackable:Get()
    inst.Physics:Teleport(pt:Get())
    local timeToGrow = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
    OnPlant(inst, timeToGrow)

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

local function OnLoad(inst, data)
    if data ~= nil and data.growtime ~= nil then
        OnPlant(inst, data.growtime)
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_meadowisland_tree_sapling")
	inst.AnimState:SetBuild("kyno_meadowisland_tree_sapling")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("show_spoilage")
	inst:AddTag("deployedplant")
	inst:AddTag("cattoy")
	inst:AddTag("cookable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_oaktree_pod_cooked"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_oaktree_pod"
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	inst.components.deployable.ondeploy = OnDeploy

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)
	
	inst.OnLoad = OnLoad

	return inst
end

local function fn_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_meadowisland_tree_sapling")
	inst.AnimState:SetBuild("kyno_meadowisland_tree_sapling")
	inst.AnimState:PlayAnimation("cooked")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_OAKTREE_POD_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_OAKTREE_POD_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_OAKTREE_POD_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.RAW
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_oaktree_pod_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_oaktree_pod", fn, assets, prefabs),
Prefab("kyno_oaktree_pod_cooked", fn_cooked, assets, prefabs),
MakePlacer("kyno_oaktree_pod_placer", "kyno_meadowisland_tree_sapling", "kyno_meadowisland_tree_sapling", "planted")