require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass1.zip"),
	Asset("ANIM", "anim/kyno_wheat.zip"),
    Asset("SOUND", "sound/common.fsb"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local grasspart_assets =
{
    Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass1.zip"),
	Asset("ANIM", "anim/kyno_wheat.zip"),
}

local prefabs =
{
    "kyno_wheat",
    "dug_kyno_wildwheat",
    "spoiled_food",
    "grasspartfx",
}

local function dig_up(inst, worker)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
        end

        inst.components.lootdropper:SpawnLootPrefab(withered and "kyno_wheat" or "dug_kyno_wildwheat")
    end
	
    inst:Remove()
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function makeemptyfn(inst)
    if not POPULATING and (inst.components.witherable ~= nil and inst.components.witherable:IsWithered() 
	or inst.AnimState:IsCurrentAnimation("idle_dead")) then
        inst.AnimState:PlayAnimation("dead_to_empty")
        inst.AnimState:PushAnimation("picked", false)
    else
        inst.AnimState:PlayAnimation("picked")
    end
end

local function makebarrenfn(inst, wasempty)
    if not POPULATING and (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
        inst.AnimState:PlayAnimation(wasempty and "empty_to_dead" or "full_to_dead")
        inst.AnimState:PushAnimation("idle_dead", false)
    else
        inst.AnimState:PlayAnimation("idle_dead")
    end
end

local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("picking")

    if inst.components.pickable:IsBarren() then
        inst.AnimState:PushAnimation("empty_to_dead")
        inst.AnimState:PushAnimation("idle_dead", false)
    else
        inst.AnimState:PushAnimation("picked", false)
    end
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function ontransplantfn(inst)
    inst.components.pickable:MakeBarren()
end

local function grass(name, stage)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

		local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("kyno_wildwheat.tex")

        inst.AnimState:SetBank("kyno_wheat")
        inst.AnimState:SetBuild("kyno_wheat")
        inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:SetRayTestOnBB(true)

		inst:AddTag("plant")
        inst:AddTag("renewable")
		inst:AddTag("silviculture")
		inst:AddTag("lunarplant_target")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.AnimState:SetTime(math.random() * 2)
        local color = 0.75 + math.random() * 0.25
        inst.AnimState:SetMultColour(color, color, color, 1)

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
        inst.components.pickable:SetUp("kyno_wheat", TUNING.KYNO_WILDWHEAT_GROWTIME)
        inst.components.pickable.onregenfn = onregenfn
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.max_cycles = 20
        inst.components.pickable.cycles_left = 20
        inst.components.pickable.ontransplantfn = ontransplantfn

        if stage == 1 then
            inst.components.pickable:MakeBarren()
        end

        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(dig_up)
		inst.components.workable:SetWorkLeft(1)

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
		MakeNoGrowInWinter(inst)
        MakeHauntableIgnite(inst)
		-- MakeWaxablePlant(inst)

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function grasspart_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("grass1")
    inst.AnimState:PlayAnimation("grass_part")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return grass("kyno_wildwheat", 0),
grass("kyno_wildwheat_depleted", 1),
Prefab("kyno_grasspartfx", grasspart_fn, grasspart_assets)