local assets =
{
	Asset("ANIM", "anim/kyno_kokonut.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_kokonut",
	"kyno_kokonut_cooked",
	"kyno_kokonut_halved",
	"kyno_kokonuttree_sapling",
}

local function OnPlant(inst, growtime)
    local sapling = SpawnPrefab("kyno_kokonuttree_sapling")
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

local function OnChopped(inst, worker)
    local kokonut = inst 
    if inst.components.inventoryitem then 
		local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then 
            kokonut = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end 
        if owner then 
            local cracked = SpawnPrefab("kyno_kokonut_halved")
			cracked.components.stackable.stacksize = 2
            if owner.components.inventory and not owner.components.inventory:IsFull() then
                owner.components.inventory:GiveItem(cracked)
            elseif owner.components.container and not owner.components.container:IsFull() then
                owner.components.container:GiveItem(cracked)
            else
                inst.components.lootdropper:DropLootPrefab(cracked)
            end
        else 
            inst.components.lootdropper:SpawnLootPrefab("kyno_kokonut_halved")
            inst.components.lootdropper:SpawnLootPrefab("kyno_kokonut_halved")
        end 
        worker.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree") -- inst.
    end
    kokonut:Remove()
end 

local function OnLoad(inst, data)
    if data ~= nil and data.growtime ~= nil then
        OnPlant(inst, data.growtime)
    end
end

local kokonuts = {}

local function kokonut()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_kokonut")
	inst.AnimState:SetBuild("kyno_kokonut")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("fruit")
	inst:AddTag("show_spoilage")
	inst:AddTag("deployedplant")
	inst:AddTag("cattoy")
	inst:AddTag("crackable")

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
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnChopped)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_kokonut"
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	inst.components.deployable.ondeploy = OnDeploy

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)
	
	inst.OnLoad = OnLoad

	return inst
end

local function kokonut_halved()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_kokonut")
	inst.AnimState:SetBuild("kyno_kokonut")
	inst.AnimState:PlayAnimation("halved")
	
	inst:AddTag("veggie")
	inst:AddTag("fruit")
	inst:AddTag("cookable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_KOKONUT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_KOKONUT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_KOKONUT_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_kokonut_halved"
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_kokonut_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function kokonut_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_kokonut")
	inst.AnimState:SetBuild("kyno_kokonut")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("veggie")
	inst:AddTag("fruit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_KOKONUT_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_KOKONUT_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_KOKONUT_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_kokonut_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_kokonut", kokonut, assets, prefabs),
Prefab("kyno_kokonut_halved", kokonut_halved, assets, prefabs),
Prefab("kyno_kokonut_cooked", kokonut_cooked, assets, prefabs),
MakePlacer("kyno_kokonut_placer", "kyno_kokonut", "kyno_kokonut", "planted")