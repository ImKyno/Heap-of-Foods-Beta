local assets =
{
	Asset("ANIM", "anim/kyno_cannedfoods.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"kyno_tomatocan",
    "kyno_tomatocan_open",
	"kyno_beancan",
	"kyno_beancan_open",
	"kyno_meatcan",
	"kyno_meatcan_open",
	"kyno_antchovycan", -- Special case
}    

local function OnOpenCan(inst, pos, doer)
	local name = inst.closed_name

	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	else
		inst.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	end

	local openedcan = SpawnPrefab(name.."_open")
	if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
	and not doer:HasTag("playerghost") then 
		doer.components.inventory:GiveItem(openedcan) 
	else
		openedcan.Transform:SetPosition(pos:Get())
		openedcan.components.inventoryitem:OnDropped(false, .5)
	end
	
	if inst.components.stackable ~= nil then
		inst.components.stackable:Get():Remove()
        
		if inst.components.stackable:StackSize() <= 0 then
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function OnOpenAntchovy(inst, pos, doer)
	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	else
		inst.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	end

	local antchovy1 = SpawnPrefab("kyno_antchovy")
	local antchovy2 = SpawnPrefab("kyno_antchovy")
	
	if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
	and not doer:HasTag("playerghost") then 
		doer.components.inventory:GiveItem(antchovy1)
		doer.components.inventory:GiveItem(antchovy2)
	else
		antchovy1.Transform:SetPosition(pos:Get())
		antchovy1.components.inventoryitem:OnDropped(false, .5)
		
		antchovy2.Transform:SetPosition(pos:Get())
		antchovy2.components.inventoryitem:OnDropped(false, .5)
	end
	
	if inst.components.stackable ~= nil then
		inst.components.stackable:Get():Remove()
        
		if inst.components.stackable:StackSize() <= 0 then
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function closed_fn(bank, build, anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)
	
	inst:AddTag("canned_food")
	
	inst.pickupsound = "metal"
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
        
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CANNEDFOOD"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = inst.closed_name
	inst.components.inventoryitem:SetSinks(true)
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 1

    inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenCan)

    return inst
end

local function opened_fn(bank, build, anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)
	
	inst:AddTag("foodsack_valid")
	inst:AddTag("canned_food_open")
	inst:AddTag("pre-preparedfood") -- So warly can eat them.
	
	inst.pickupsound = "metal"
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
    inst:AddComponent("edible")
        
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CANNEDFOOD_OPEN"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = inst.opened_name

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

-- Canned Toma Roots.
local function closed_tomato()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "tomato_closed")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.closed_name = "kyno_tomatocan"
	
	return inst
end

local function opened_tomato()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "tomato_opened")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.opened_name = "kyno_tomatocan_open"
	
	inst.components.edible.healthvalue = TUNING.KYNO_TOMATOCAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TOMATOCAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TOMATOCAN_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

-- Canned Beans.
local function closed_bean()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "bean_closed")
		
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.closed_name = "kyno_beancan"
	
	return inst
end

local function opened_bean()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "bean_opened")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.opened_name = "kyno_beancan_open"
	
	inst.components.edible.healthvalue = TUNING.KYNO_BEANCAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BEANCAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BEANCAN_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

-- Canned Beef.
local function closed_meat()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "meat_closed")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.closed_name = "kyno_meatcan"
	
	return inst
end

local function opened_meat()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "meat_opened")
	
	inst:AddTag("cattoy")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.opened_name = "kyno_meatcan_open"
	
	inst.components.tradable.goldvalue = 1 -- Only meat is valuable!

	inst.components.edible.healthvalue = TUNING.KYNO_MEATCAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MEATCAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MEATCAN_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	return inst
end

-- Canned Ant-Chovy.
local function closed_antchovy()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "antchovy_closed")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.closed_name = "kyno_antchovycan"
	
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenAntchovy)
	
	return inst
end

return Prefab("kyno_tomatocan", closed_tomato, assets, prefabs),
Prefab("kyno_tomatocan_open", opened_tomato, assets, prefabs),
Prefab("kyno_beancan", closed_bean, assets, prefabs),
Prefab("kyno_beancan_open", opened_bean, assets, prefabs),
Prefab("kyno_meatcan", closed_meat, assets, prefabs),
Prefab("kyno_meatcan_open", opened_meat, assets, prefabs),
Prefab("kyno_antchovycan", closed_antchovy, assets, prefabs)