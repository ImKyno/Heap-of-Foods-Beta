local UpvalueHacker = require("hof_upvaluehacker")

local assets =
{
	Asset("ANIM", "anim/kyno_oceantrap.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_seaweeds",
	"kyno_jellyfish",
	"kyno_messagebottle_empty",
}

local sounds =
{
    close = "dontstarve/common/trap_close",
    rustle = "dontstarve/common/trap_rustle",
}

local function OnHarvested(inst)
    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:Use(1)
    end
end

local function OnBaited(inst, bait)
	inst:PushEvent("baited")
	
	bait:AddTag("bait_invisible")
	bait:Hide()
end

local function OnPickup(inst, doer)
	if inst.components.trap ~= nil and inst.components.trap.bait and doer.components.inventory ~= nil then
		inst.components.trap.bait:RemoveTag("bait_invisible")
		inst.components.trap.bait:Show()
		
		inst.components.trap.bait:DoTaskInTime(0, function(bait)
			doer.components.inventory:GiveItem(bait)
		end)
	end

	inst.components.trap:Reset()
end

local function TrapHasLoot(inst)
	return inst.components.trap ~= nil and (
	(inst.components.trap.lootprefabs ~= nil and next(inst.components.trap.lootprefabs) ~= nil)
	or (inst.components.trap.captured_fish ~= nil and inst.components.trap.captured_fish:IsValid()))
end

local function OnLoad(inst, data)
	inst:DoTaskInTime(0, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local onland = TheWorld.Map:IsPassableAtPoint(x, y, z)
		local trap = inst.components.trap

		if onland then
			inst.sg:GoToState("idle_ground")
		end
	end)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_oceantrap.tex")

	MakeInventoryPhysics(inst)
	
	inst:SetPhysicsRadiusOverride(2) -- For extra action range.

	inst.AnimState:SetBank("kyno_oceantrap")
	inst.AnimState:SetBuild("kyno_oceantrap")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("trap")
	inst:AddTag("smalloceanfish_trap")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = sounds

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetOnPickupFn(OnPickup)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_oceantrap"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_OCEANTRAP_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_OCEANTRAP_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("trap")
	inst.components.trap.targettag = "smalloceanfish"
	inst.components.trap:SetOnHarvestFn(OnHarvested)
	inst.components.trap.onbaited = OnBaited
	inst.components.trap.baitsortorder = -1
	inst.components.trap.range = TUNING.KYNO_OCEANTRAP_RANGE
	
	local OnPickup = UpvalueHacker.GetUpvalue(inst.components.trap.OnRemoveFromEntity, "OnPickup")
	inst:RemoveEventCallback("onpickup", OnPickup)
	
	inst:SetStateGraph("SGoceantrap")
	
	inst.OnLoad = OnLoad
	
	MakeHauntableLaunchAndIgnite(inst)

	return inst
end

return Prefab("kyno_oceantrap", fn, assets, prefabs)