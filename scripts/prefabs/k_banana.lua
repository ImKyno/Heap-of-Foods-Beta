local assets =
{
	Asset("ANIM", "anim/kyno_banana.zip"),
	Asset("ANIM", "anim/kyno_bananatree_sapling.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_banana",
	"kyno_banana_cooked",
}

local function plant(inst, growtime)
    local sapling = SpawnPrefab("kyno_bananatree_sapling")
    sapling:StartGrowing()
    sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst:Remove()
end

local LEIF_TAGS = { "leif" }
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

local function OnLoad(inst, data)
    if data ~= nil and data.growtime ~= nil then
        plant(inst, data.growtime)
    end
end

local bananas = {}

local function banana()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_banana")
	inst.AnimState:SetBuild("kyno_banana")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("fruit")
	inst:AddTag("cookable")
	-- inst:AddTag("deployedplant")
	inst:AddTag("cattoy")
	inst:AddTag("saltbox_valid")
	inst:AddTag("surface_banana")
	inst:AddTag("monkeyqueenbribe")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BANANA_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BANANA_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BANANA_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_banana"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_banana_cooked"

	-- inst:AddComponent("deployable")
	-- inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	-- inst.components.deployable.ondeploy = ondeploy

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	-- inst.OnLoad = OnLoad

	return inst
end

local function banana_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_banana")
	inst.AnimState:SetBuild("kyno_banana")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("fruit")
	inst:AddTag("surface_banana")
	inst:AddTag("monkeyqueenbribe")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BANANA_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BANANA_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BANANA_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_banana_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_banana", banana, assets, prefabs),
Prefab("kyno_banana_cooked", banana_cooked, assets, prefabs),
MakePlacer("kyno_banana_placer", "kyno_bananatree_sapling", "kyno_bananatree_sapling", "planted")