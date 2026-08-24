require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/quagmire_salt_pond.zip"),
	Asset("ANIM", "anim/quagmire_salt_rack.zip"),
	Asset("ANIM", "anim/splash.zip"),

	Asset("ANIM", "anim/kyno_salt_pond_rack.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"collapse_small",
	"saltrock",

	"kyno_pond_salt",
	"kyno_bucket_metal",
	"kyno_saltrack_installer",
}

local REGROW_TIME = TUNING.KYNO_SALTRACK_REGROW_TIME * 1.5 -- Grows slower than natural salt ponds.

local function OnHit(inst)
	if inst.components.pickable ~= nil then
		if inst.components.pickable:CanBePicked() then
			inst.AnimState:PlayAnimation("hit_idle")
			inst.AnimState:PushAnimation("idle", true)
		else
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle_picked", true)
		end
	end
end

local function OnPicked(inst)
	inst.AnimState:PlayAnimation("idle_picked", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function OnRegen(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function OnMakeEmpty(inst)
	inst.AnimState:PlayAnimation("idle_picked", true)
end

local function OnHammered(inst, worker)
	if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		end
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	local fx = SpawnPrefab("collapse_small")	
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")

	inst:Remove()
end

local function OnBuilt(inst, data)
	if inst.components.pickable ~= nil then
		inst.components.pickable:MakeEmpty()
	end
	
	local fx = SpawnPrefab("collapse_small")	
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")

	if data ~= nil and data.builder ~= nil then
		local player = data.builder
		local bucket = SpawnPrefab("kyno_bucket_metal")

		if bucket ~= nil then
			if player.components.inventory ~= nil then
				player.components.inventory:GiveItem(bucket, nil, player:GetPosition())
			else
				LaunchAtRandomly(bucket, nil, 1)
			end
		end
	end
end

local function GetStatus(inst, viewer)
	return (not inst.components.pickable:CanBePicked() and "PICKED")
	or "GENERIC"
end

local function OnPreLoad(inst, data)
	WorldSettings_Pickable_PreLoad(inst, data, REGROW_TIME)
end

local rack_defs = 
{
	rack = { { 0, 0, 0 } },
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1.95)

	inst.AnimState:SetBank("kyno_salt_pond_rack")
	inst.AnimState:SetBuild("kyno_salt_pond_rack")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("birdblocker")
	inst:AddTag("drying_rack_salt")
	inst:AddTag("antlion_sinkhole_blocker")

	inst:SetPrefabNameOverride("kyno_saltrack")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	local decor_items = rack_defs

	inst.decor = {}

	for item_name, data in pairs(decor_items) do
		for i, offset in pairs(data) do
			local pond = SpawnPrefab("kyno_pond_rack")

			pond.Transform:SetPosition(offset[1], offset[2], offset[3])
			pond.AnimState:PushAnimation("idle", true)
			pond.entity:SetParent(inst.entity)

			table.insert(inst.decor, pond)
		end
	end

	inst.AnimState:SetTime(math.random() * 2)

	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	WorldSettings_Pickable_RegenTime(inst, REGROW_TIME, true)
	inst.components.pickable:SetUp("saltrock", REGROW_TIME)
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.makeemptyfn = OnMakeEmpty

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)

	inst:ListenForEvent("onbuilt", OnBuilt)

	inst.OnPreLoad = OnPreLoad

	return inst
end

return Prefab("kyno_pond_salt2", fn, assets, prefabs)