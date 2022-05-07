UPGRADETYPES.KYNO_ELDERPOT = "kyno_elderpot_repairtool"

local assets =
{
	Asset("ANIM", "anim/quagmire_salt_rack.zip"),
	Asset("ANIM", "anim/quagmire_sapbucket.zip"),
	Asset("ANIM", "anim/quagmire_crab_trap.zip"),
	Asset("ANIM", "anim/quagmire_slaughtertool.zip"),
	
	Asset("ANIM", "anim/hammer.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_saltrack_installer",
	"kyno_sapbucket_installer",
	"kyno_crabtrap_installer",
	
	"kyno_slaughtertool",
}

local sounds =
{
    close = "dontstarve/common/trap_close",
    rustle = "dontstarve/common/trap_rustle",
}

local function OnHarvested(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function GetSlaughterActionString(inst, target)
    local t = GetTime()
    if target ~= inst._lasttarget or inst._lastactionstr == nil or inst._actionresettime < t then
        inst._lastactionstr = GetRandomItem(STRINGS.ACTIONS.SLAUGHTER2)
        inst._lasttarget = target
    end
    inst._actionresettime = t + .1
    return inst._lastactionstr
end

local function rackfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_salt_rack")
	inst.AnimState:SetBuild("quagmire_salt_rack")
	inst.AnimState:PlayAnimation("builder")

	inst:AddTag("salt_rack_installer")
	inst:AddTag("serenity_installer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

	return inst
end

local function bucketfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_sapbucket")
	inst.AnimState:SetBuild("quagmire_sapbucket")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sap_bucket_installer")
	inst:AddTag("serenity_installer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function trapfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_crabtrap_installer.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_crab_trap")
	inst.AnimState:SetBuild("quagmire_crab_trap")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("shell", "quagmire_pebble_crab", "shell")

	inst:AddTag("trap")
	inst:AddTag("serenitycrab_trap")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = sounds

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("trap")
    inst.components.trap.targettag = "serenitycrab"
    inst.components.trap:SetOnHarvestFn(OnHarvested)
    inst.components.trap.baitsortorder = 1
	
	inst:SetStateGraph("SGpebblecrabtrap")
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

	return inst
end

local function slaughterfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_slaughtertool")
	inst.AnimState:SetBuild("quagmire_slaughtertool")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("slaughter_tool")
	inst:AddTag("sharp")
	
	inst.GetSlaughterActionString = GetSlaughterActionString

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("slaughteritem")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(4)
    inst.components.finiteuses:SetUses(4)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	MakeHauntableLaunch(inst)

	return inst
end

local function repairtoolfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("hammer")
    inst.AnimState:SetBuild("swap_hammer")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")
	inst:AddTag("serenity_repairtool")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "HAMMER"
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
	inst.components.inventoryitem.imagename = "hammer"

    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("kyno_saltrack_installer", rackfn, assets, prefabs),
Prefab("kyno_sapbucket_installer", bucketfn, assets, prefabs),
Prefab("kyno_crabtrap_installer", trapfn, assets, prefabs),
Prefab("kyno_slaughtertool", slaughterfn, assets, prefabs),
Prefab("kyno_repairtool", repairtoolfn, assets, prefabs)