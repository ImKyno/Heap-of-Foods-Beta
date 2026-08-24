require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/quagmire_salt_pond.zip"),
	Asset("ANIM", "anim/quagmire_salt_rack.zip"),
	Asset("ANIM", "anim/splash.zip"),

	Asset("ANIM", "anim/blueprint_rare02.zip"),
	Asset("ANIM", "anim/kyno_salt_pond_rack.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"saltrock",
	"kyno_salmonfish",
	"kyno_saltrack",
	"kyno_saltrack_installer",
}

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

	SpawnPrefab("kyno_pond_salt").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("salt_rack_installer") then
		return true -- Install the Salt Rack.
	else
		giver:PushEvent("cookwareinstallfail")
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item:HasTag("salt_rack_installer") then
		local rack = SpawnPrefab("kyno_saltrack")

		rack.Transform:SetPosition(inst.Transform:GetWorldPosition())
		rack.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
		rack.AnimState:PlayAnimation("place", false)

		if rack.components.pickable ~= nil then
			rack.components.pickable:MakeEmpty()
		end
	end

	inst:Remove()
end

local function DoSplash(inst)
	if inst:HasTag("saltpondrack") then
		inst:DoTaskInTime(5 + math.random() * 5, function()
			DoSplash(inst)
		end)

		inst.AnimState:PlayAnimation("splash")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function GetFish(inst)
	local blueprint = "kyno_pond_salt2_construction_blueprint"
	return math.random() < TUNING.KYNO_SALTRACK_BLUEPRINT_CHANCE and blueprint or "kyno_salmonfish"
end

local function GetStatus(inst, viewer)
	return (not inst.components.pickable:CanBePicked() and "PICKED")
	or "GENERIC"
end

local function OnPreLoad(inst, data)
	WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_SALTRACK_REGROW_TIME)
end

local rack_defs =
{
	rack = { { 0, 0, 0 } },
}

local function pondfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pond_salt.tex")

	MakeObstaclePhysics(inst, 1.95)

	inst.AnimState:SetBank("quagmire_salt_pond")
	inst.AnimState:SetBuild("quagmire_salt_pond")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("watersource")
	inst:AddTag("birdblocker")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("cookware_installable")
	inst:AddTag("cookware_pond_installable")

	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")
	inst:AddComponent("watersource")
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POND_SALT"

	inst:AddComponent("cookwareinstaller")
	inst.components.cookwareinstaller:SetAcceptTest(TestItem)
	inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

	inst:AddComponent("fishable")
	inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	inst.components.fishable:SetGetFishFn(GetFish)

	return inst
end

local function pondsaltfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pond_rack.tex")

	MakeObstaclePhysics(inst, 1.95)

	inst.AnimState:SetBank("quagmire_salt_pond")
	inst.AnimState:SetBuild("quagmire_salt_pond")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("watersource")
	inst:AddTag("birdblocker")
	inst:AddTag("antlion_sinkhole_blocker")

	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")
	inst:AddComponent("watersource")
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POND_SALT"

	DoSplash(inst)

	return inst
end

local function rackfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1.95)

	inst.AnimState:SetBank("kyno_salt_pond_rack")
	inst.AnimState:SetBuild("kyno_salt_pond_rack")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("drying_rack_salt")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	local decor_items = rack_defs

	inst.decor = {}

	for item_name, data in pairs(decor_items) do
		for l, offset in pairs(data) do
			local item_inst = SpawnPrefab("kyno_pond_rack")

			item_inst.AnimState:PushAnimation("idle", true)
			item_inst.entity:SetParent(inst.entity)
			item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])

			table.insert(inst.decor, item_inst)
		end
	end

	inst.highlightchildren = inst.decor

	inst.AnimState:SetTime(math.random() * 2)

	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_saltrack_installer"})

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_SALTRACK_REGROW_TIME, true)
	inst.components.pickable:SetUp("saltrock", TUNING.KYNO_SALTRACK_REGROW_TIME)
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.makeemptyfn = OnMakeEmpty

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)

	inst.OnPreLoad = OnPreLoad

	return inst
end

return Prefab("kyno_pond_salt", pondfn, assets, prefabs),
Prefab("kyno_pond_rack", pondsaltfn, assets, prefabs),
Prefab("kyno_saltrack", rackfn, assets, prefabs)