local assets =
{
    Asset("ANIM", "anim/nukashine.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs = 
{
	"kyno_nukashinesugarfreebuff",
	"spoiled_food",
}

local BEAT_SOUNDNAME = "BEAT_SOUND"

local function NightVision_PlayBeatingSound(inst)
	inst.SoundEmitter:KillSound(BEAT_SOUNDNAME)
	inst.SoundEmitter:PlaySound("meta4/ancienttree/nightvision/fruit_pulse", BEAT_SOUNDNAME)
end

local function NightVision_OnEntityWake(inst)
	if inst._beatsoundtask ~= nil or inst:IsInLimbo() or inst:IsAsleep() then
		return
	end

	if inst._beatsoundtask ~= nil then
		inst._beatsoundtask:Cancel()
		inst._beatsoundtask = nil
	end

	local fulltime = inst.AnimState:GetCurrentAnimationLength()
	local currenttime = inst.AnimState:GetCurrentAnimationTime()

	inst:PlayBeatingSound()

	inst._beatsoundtask = inst:DoPeriodicTask(fulltime, inst.PlayBeatingSound, fulltime - currenttime)
end

local function NightVision_OnEntitySleep(inst)
	inst.SoundEmitter:KillSound(BEAT_SOUNDNAME)

	if inst._beatsoundtask ~= nil then
		inst._beatsoundtask:Cancel()
		inst._beatsoundtask = nil
	end
end

local function OnDrink(inst, eater)
	if eater ~= nil and eater.SoundEmitter ~= nil then
		eater.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open")
		eater.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink")
	else
		inst.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open")
		inst.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink")
	end

    if eater.components.playervision ~= nil and eater.components.combat ~= nil then
        eater:AddDebuff("kyno_nukashinesugarfreebuff", "kyno_nukashinesugarfreebuff")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.65)

    inst.AnimState:SetBank("nukashine")
    inst.AnimState:SetBuild("nukashine")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("preparedfood")
	inst:AddTag("preparedbrew")
	inst:AddTag("fooddrink")
	inst:AddTag("alcoholic_drink")
	inst:AddTag("nukashine")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "NUKASHINE"
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 20

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "nukashine_sugarfree"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = 100
	inst.components.edible.hungervalue = 150
	inst.components.edible.sanityvalue = -100
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnDrink)
	
	inst.PlayBeatingSound = NightVision_PlayBeatingSound
	inst.OnEntityWake = NightVision_OnEntityWake
	inst.OnEntitySleep = NightVision_OnEntitySleep
	
	inst:ListenForEvent("exitlimbo", inst.OnEntityWake)
	inst:ListenForEvent("enterlimbo", inst.OnEntitySleep)
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("nukashine_sugarfree", fn, assets, prefabs)