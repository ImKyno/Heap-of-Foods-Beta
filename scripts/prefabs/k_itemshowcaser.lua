-- idle_ice_box
-- idle_yotp
-- bank
-- idle_barrel_dome
-- idle_cakestand
-- idle_fridge_display

local assets =
{
	Asset("ANIM", "anim/kyno_itemshowcaser.zip"),
}

local prefabs =
{
    "collapse_small",
}

local FOOD_ONEOF_TAGS = 
{
	"preparedfood",
	"preparedbrew",
}

local function OnBuilt(inst)
	inst.SoundEmitter:PlaySound("rifts4/gelblob_storage/place")
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
end

local function GetStatus(inst)
    return inst.components.inventoryitemholder:IsHolding() and "FULL" or nil
end

local function MakeItemShowcaser(data)
	local function OnHammered(inst, data)
		inst.components.lootdropper:DropLoot()

		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial(data.material)

		if inst.components.inventoryitemholder ~= nil then
			inst.components.inventoryitemholder:TakeItem()
		end

		inst:Remove()
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
		inst.AnimState:PlayAnimation(data.anim, true)

		inst:AddTag("structure")
		inst:AddTag("itemshowcaser")

		inst.takeitem = net_entity(inst.GUID, "gelblob_storage.takeitem")

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

local showcasers =
{
	{
		name        = "icebox",
		anim        = "idle_ice_box",
		material    = "wood",
		minimapicon = "kyno_itemshowcaser_icebox",
	},
}

for i, v in ipairs(showcasers) do
	table.insert(prefabs, MakeItemShowcaser(v))
	table.insert(prefabs, MakeItemShowcaser("kyno_itemshowcaser_"..v.name.."_placer", "kyno_itemshowcaser", "kyno_itemshowcaser", v.anim))
end

return unpack(prefabs)