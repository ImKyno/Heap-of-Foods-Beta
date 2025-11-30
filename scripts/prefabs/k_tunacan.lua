local assets =
{
	Asset("ANIM", "anim/kyno_tuna.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
    "fishmeat",
	"fishmeat_cooked",
	"spoiled_fish",
	"kyno_tunacan_open",
}    

local function OnOpenCan(inst, pos, doer)
	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	else
		inst.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	end

	local tunacan = SpawnPrefab("kyno_tunacan_open")
	if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
	and not doer:HasTag("playerghost") then 
		doer.components.inventory:GiveItem(tunacan) 
	else
		tunacan.Transform:SetPosition(pos:Get())
		tunacan.components.inventoryitem:OnDropped(false, .5)
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

local function closed_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("kyno_tuna")
    inst.AnimState:SetBuild("kyno_tuna")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("canned_food")
	inst:AddTag("cattoy")
	
	inst.pickupsound = "metal"
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
        
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_tunacan"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD

    inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenCan)

    return inst
end

local function opened_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("kyno_tuna")
    inst.AnimState:SetBuild("kyno_tuna")
    inst.AnimState:PlayAnimation("opened")
	
	inst:AddTag("canned_food_open")
	inst:AddTag("pre-preparedfood") -- So warly can eat them.
	
	inst.pickupsound = "metal"
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
        
    inst:AddComponent("inspectable")
	inst:AddComponent("bait")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_tunacan_open"
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_TUNACAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TUNACAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TUNACAN_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_fish"

    return inst
end

return Prefab("kyno_tunacan", closed_fn, assets, prefabs),
Prefab("kyno_tunacan_open", opened_fn, assets, prefabs)
-- What should we do? When open give the fish like in SW, or just open the can?
-- Well... Maybe open the can just to be different...