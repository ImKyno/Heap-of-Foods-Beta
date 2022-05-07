local assets =
{
	Asset("ANIM", "anim/kyno_cannedfoods.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_tomatocan",
    "kyno_tomatocan_open",
	"kyno_beancan",
	"kyno_beancan_open",
	"kyno_meatcan",
	"kyno_meatcan_open",
}    

local function OnOpenCan(inst, pos, doer)
	local name = inst.name

	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("hookline_2/characters/hermit/tacklebox/small_open")
	else
		inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/tacklebox/small_open")
	end

	local openedcan = SpawnPrefab(name.."_open")
	if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
	and not doer:HasTag("playerghost") then 
		doer.components.inventory:GiveItem(openedcan) 
	else
		openedcan.Transform:SetPosition(pos:Get())
		openedcan.components.inventoryitem:OnDropped(false, .5)
	end
	
	inst:Remove()
end		

local function closed_fn(bank, build, anim, closed_name)
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
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.name = closed_name
        
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CANNEDFOOD"
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = closed_name
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 1

    inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenCan)

    return inst
end

local function opened_fn(bank, build, anim, opened_name)
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
	
	inst:AddTag("canned_food_open")
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
    inst:AddComponent("edible")
        
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CANNEDFOOD_OPEN"
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = opened_name

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

-- Canned Toma Roots.
local function closed_tomato()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "tomato_closed", "kyno_tomatocan")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

local function opened_tomato()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "tomato_opened", "kyno_tomatocan_open")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = 12.5
	inst.components.edible.hungervalue = 20
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

-- Canned Beans.
local function closed_bean()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "bean_closed", "kyno_beancan")
		
	if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

local function opened_bean()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "bean_opened", "kyno_beancan_open")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 20
	inst.components.edible.sanityvalue = 10
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

-- Canned Beef.
local function closed_meat()
	local inst = closed_fn("kyno_cannedfoods", "kyno_cannedfoods", "meat_closed", "kyno_meatcan")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

local function opened_meat()
	local inst = opened_fn("kyno_cannedfoods", "kyno_cannedfoods", "meat_opened", "kyno_meatcan_open")
	
	inst:AddTag("cattoy")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1 -- Only meat is valuable!

	inst.components.edible.healthvalue = 5
	inst.components.edible.hungervalue = 25
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	return inst
end


return Prefab("kyno_tomatocan", closed_tomato, assets, prefabs),
Prefab("kyno_tomatocan_open", opened_tomato, assets, prefabs),
Prefab("kyno_beancan", closed_bean, assets, prefabs),
Prefab("kyno_beancan_open", opened_bean, assets, prefabs),
Prefab("kyno_meatcan", closed_meat, assets, prefabs),
Prefab("kyno_meatcan_open", opened_meat, assets, prefabs)
