require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/limpetrock.zip"),
	Asset("ANIM", "anim/limpets.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_limpets",
	"kyno_limpets_cooked",
	"rocks",
	"flint",
}   

SetSharedLootTable("limpetrockempty",
{
	{"rocks", 1.00},
	{"rocks", 1.00},
	{"rocks", 1.00},
	{"flint", 1.00},
	{"flint", 0.60},
})

SetSharedLootTable("limpetrockfull",
{
	{"rocks", 1.00},
	{"rocks", 1.00},
	{"rocks", 1.00},
	{"flint", 1.00},
	{"flint", 0.60},
	{"kyno_limpets", 1.00},
})

local function makeemptyfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("empty")
	else
		inst.AnimState:PlayAnimation("empty")
	end
	inst.components.workable:SetWorkable(true)
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		if not inst.components.pickable.hasbeenpicked then
			inst.AnimState:PlayAnimation("full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end

local function onpickedfn(inst, picker)
	if inst.components.pickable then
		inst.components.workable:SetWorkable(true)
		inst.AnimState:PlayAnimation("limpetmost_picked")
		
		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle")
		end
	end
end

local function getregentimefn(inst)
	return TUNING.KYNO_LIMPETROCK_GROWTIME
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			return "limpetmost"
		else
			if inst.components.pickable:IsBarren() then
				return "idle_dead"
			else
				return "idle"
			end
		end
	end
	return "idle"
end

local function makefullfn(inst)
	inst.components.workable:SetWorkable(false)
	inst.AnimState:PlayAnimation(pickanim(inst))
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_limpetrock.tex")
	
	inst.AnimState:SetBank("limpetrock")
	inst.AnimState:SetBuild("limpetrock")
	inst.AnimState:PlayAnimation("limpetmost", false)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("limpetrock")
	inst:AddTag("boulder")
	inst:AddTag("witherable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("witherable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("limpetrockempty")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	inst.components.pickable:SetUp("kyno_limpets", TUNING.KYNO_LIMPETROCK_GROWTIME)
	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
		local pt = Point(inst.Transform:GetWorldPosition())
		if workleft <= 0 then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
			inst.components.lootdropper:DropLoot(pt)
			if inst.components.pickable:CanBePicked() and worker and worker.components.groundpounder and worker.components.groundpounder.burner == true then
				inst.components.lootdropper:SpawnLootPrefab("kyno_limpets_cooked", pt)
			end
			inst:Remove()
		else
			if workleft < TUNING.ROCKS_MINE*(1/3) then
				inst.AnimState:PlayAnimation("low")
			elseif workleft < TUNING.ROCKS_MINE*(2/3) then
				inst.AnimState:PlayAnimation("med")
			else
				inst.AnimState:PlayAnimation("idle")
			end
		end
	end)

	inst.components.workable:SetWorkable(false)

	return inst
end

local function limpets()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("limpets")
	inst.AnimState:SetBuild("limpets")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("lureplant_bait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_LIMPETS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_LIMPETS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_LIMPETS_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_limpets"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_limpets_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function limpets_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("limpets")
	inst.AnimState:SetBuild("limpets")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_LIMPETS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_LIMPETS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_LIMPETS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_limpets_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_limpetrock", fn, assets, prefabs),
Prefab("kyno_limpets", limpets, assets, prefabs),
Prefab("kyno_limpets_cooked", limpets_cooked, assets, prefabs)