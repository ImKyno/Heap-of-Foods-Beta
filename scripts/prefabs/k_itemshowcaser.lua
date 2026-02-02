require("prefabutil")

local cooking = require("cooking")
local brewing = require("hof_brewing")

local assets =
{
	Asset("ANIM", "anim/kyno_itemshowcaser.zip"),
		
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"collapse_small",
}
	
local FOOD_ONEOF_TAGS =
{
	"preparedfood",
	"preparedbrew",
	"itemshowcaser_valid",
}
	
local function GetCookerForFood(foodname)
	for cooker, recipes in pairs(cooking.recipes) do
		if recipes[foodname] ~= nil then
			return cooker
		end
	end
		
	return nil
end
	
local function GetBrewerForFood(foodname)
	for brewer, recipes in pairs(brewing.recipes) do
		if recipes[foodname] ~= nil then
			return brewer
		end
	end
		
	return nil
end

local function GetBaseFoodPrefab(item)
	if item ~= nil and item.food_basename ~= nil then
		return item.food_basename
	end

	return item.prefab
end
	
local function OnHammered(inst)
	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")

	if inst.components.inventoryitemholder ~= nil then
		inst.components.inventoryitemholder:TakeItem()
	end

	inst:Remove()
end

local function OnFoodGiven(inst, item, giver)
	local stacked = item == nil or not item:IsValid()

	if not POPULATING then
		inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/table/food")
	end

	if stacked then
		return
	end

	if item.components.perishable ~= nil then
		item.components.perishable:StopPerishing()
	end

	if item.components.propagator ~= nil then
		item.components.propagator.acceptsheat = false
	end

	item:AddTag("NOCLICK")
	item:ReturnToScene()

	item.components.inventoryitem.canbepickedup = false

	inst.takeitem:set(item)

	if item.Follower == nil then
		item.entity:AddFollower()
	end
	
	item.Follower:FollowSymbol(inst.GUID, "swap_object", 0, 0, 0, true)
	
	local basefood = GetBaseFoodPrefab(item)
	local cooker = GetCookerForFood(basefood) -- Spiced Foods relies on base prefab.
	local brewer = GetBrewerForFood(item.prefab)
		
	inst.AnimState:ShowSymbol("cooker_overlay")

	if cooker == "portablecookpot" then
		inst.AnimState:OverrideSymbol("cooker_overlay", "kyno_itemshowcaser", "swap_cooker_warly")
	elseif brewer == "kyno_woodenkeg" then
		inst.AnimState:OverrideSymbol("cooker_overlay", "kyno_itemshowcaser", "swap_cooker_keg")
	elseif brewer == "kyno_preservesjar" then
		inst.AnimState:OverrideSymbol("cooker_overlay", "kyno_itemshowcaser", "swap_cooker_jar")
	else
		inst.AnimState:OverrideSymbol("cooker_overlay", "kyno_itemshowcaser", "swap_cooker")
	end
	
	-- SPECIAL CASES!
	if item ~= nil then
		if item.prefab == "batnosehat" and item.components.perishable ~= nil then
			item.components.perishable:StopPerishing()
		end
	end
end

local function OnFoodTaken(inst, item, taker, wholestack)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")

	if not wholestack then
		return
	end

	inst.takeitem:set(nil)

	if item == nil or not item:IsValid() then
		return
	end

	if item.components.perishable ~= nil then
		item.components.perishable:StartPerishing()
	end

	if item.components.propagator ~= nil then
		item.components.propagator.acceptsheat = true
	end

	item.components.inventoryitem.canbepickedup = true

	item:RemoveTag("NOCLICK")
	item.Follower:StopFollowing()
		
	inst.AnimState:ClearOverrideSymbol("cooker_overlay")
	inst.AnimState:HideSymbol("cooker_overlay")
	
	-- SPECIAL CASES!
	if item ~= nil then
		if item.prefab == "batnosehat" and item.components.perishable ~= nil then
			item.components.perishable:StopPerishing()
		end
	end
end

local function GetStatus(inst)
	return inst.components.inventoryitemholder:IsHolding() and "FULL" or nil
end

local function OnBuilt(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("kyno_itemshowcaser.tex")

	MakeObstaclePhysics(inst, .5)
	inst:SetPhysicsRadiusOverride(.8)

	inst.AnimState:SetBank("kyno_itemshowcaser")
	inst.AnimState:SetBuild("kyno_itemshowcaser")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("itemshowcaser")
	
	inst.AnimState:HideSymbol("cooker_overlay")

	inst.takeitem = net_entity(inst.GUID, "gelblob_storage.takeitem")
		
	inst:SetPrefabNameOverride("KYNO_ITEMSHOWCASER")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("inventoryitemholder")
	inst.components.inventoryitemholder:SetAllowedTags(FOOD_ONEOF_TAGS)
	inst.components.inventoryitemholder:SetAcceptStacks(true)
	inst.components.inventoryitemholder:SetOnItemGivenFn(OnFoodGiven)
	inst.components.inventoryitemholder:SetOnItemTakenFn(OnFoodTaken)
	
	inst.OnBuilt = OnBuilt
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeHauntableWork(inst)

	return inst
end

return Prefab("kyno_itemshowcaser", fn, assets, prefabs),
MakePlacer("kyno_itemshowcaser_placer", "kyno_itemshowcaser", "kyno_itemshowcaser", "idle")