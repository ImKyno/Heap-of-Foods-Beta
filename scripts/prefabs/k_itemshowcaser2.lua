local cooking = require("cooking")
local brewing = require("hof_brewing")

require("prefabutil")

local function MakeItemShowcaser(data)
	local assets =
	{
		Asset("ANIM", "anim/kyno_itemshowcaser.zip"),
		
		Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
		Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
		
		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}
	
	local FOOD_ONEOF_TAGS =
	{
		"preparedfood",
		"preparedbrew",
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
	
	local function OnHammered(inst)
		inst.components.lootdropper:DropLoot()

		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial(data.material)

		if inst.components.inventoryitemholder ~= nil then
			inst.components.inventoryitemholder:TakeItem()
		end

		inst:Remove()
	end

	local function OnFoodGiven(inst, item, giver)
		local stacked = item == nil or not item:IsValid()

		if not POPULATING then
			inst.SoundEmitter:PlaySound("rifts4/gelblob_storage/store")
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
		
		local cooker = GetCookerForFood(item.prefab)
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
	end

	local function OnFoodTaken(inst, item, taker, wholestack)
		inst.SoundEmitter:PlaySound("rifts4/gelblob_storage/store")

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
	end

	local function GetStatus(inst)
		return inst.components.inventoryitemholder:IsHolding() and "FULL" or nil
	end

	local function OnBuilt(inst)
		inst.SoundEmitter:PlaySound("rifts4/gelblob_storage/place")
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		local minimap = inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon(data.minimapicon)

		MakeObstaclePhysics(inst, .5)
		inst:SetPhysicsRadiusOverride(.8)

		inst.AnimState:SetBank("kyno_itemshowcaser")
		inst.AnimState:SetBuild("kyno_itemshowcaser")
		inst.AnimState:PlayAnimation(data.anim)
		
		inst.AnimState:HideSymbol("sign_overlay")

		inst:AddTag("structure")
		inst:AddTag("itemshowcaser")

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
	
		inst:ListenForEvent("onbuilt", OnBuilt)

		MakeHauntableWork(inst)

		return inst
	end
	
	return Prefab("kyno_itemshowcaser_"..data.name, fn, assets)
end

local itemshowcaser =
{
	{
		name        = "barrel_dome",
		anim        = "idle_barrel_dome",
		material    = "wood",
		minimapicon = "kyno_itemshowcaser_barrel_dome",
	},
	
	{
		name        = "cakestand",
		anim        = "idle_cakestand",
		material    = "marble",
		minimapicon = "kyno_itemshowcaser_cakestand",
	},

	{
		name        = "fridge",
		anim        = "idle_fridge_display",
		material    = "metal",
		minimapicon = "kyno_itemshowcaser_fridge",
	},

	{
		name        = "ice_box",
		anim        = "idle_ice_box",
		material    = "wood",
		minimapicon = "kyno_itemshowcaser_ice_box",
	},

	{
		name        = "marble_dome",
		anim        = "idle_marble_dome",
		material    = "marble",
		minimapicon = "kyno_itemshowcaser_marble_dome",
	},
	
	{
		name        = "quagmire",
		anim        = "idle_quagmire",
		material    = "stone",
		minimapicon = "kyno_itemshowcaser_quagmire",
	},

	{
		name        = "yotp",
		anim        = "idle_yotp",
		material    = "wood",
		minimapicon = "kyno_itemshowcaser_yotp",
	},
}

local prefabs = {}

for i, v in ipairs(itemshowcaser) do
	table.insert(prefabs, MakeItemShowcaser(v))
	MakePlacer("kyno_itemshowcaser_"..v.name.."_placer", "kyno_itemshowcaser", "kyno_itemshowcaser", v.anim)
end

return unpack(prefabs)