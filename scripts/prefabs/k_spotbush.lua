require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/quagmire_spiceshrub.zip"),
	Asset("ANIM", "anim/kyno_spotbush.zip"),
}

local prefabs =
{
	"kyno_spotspice_leaf",
	"dug_kyno_spotbush",
}

local function onpickedfn(inst)
	inst.AnimState:PlayAnimation("picked")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("empty")
end

local function ontransplantfn(inst)
	inst.AnimState:PlayAnimation("empty")
	inst.components.pickable:MakeEmpty()
end

local function dig_up(inst, chopper)
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end

	inst.components.lootdropper:SpawnLootPrefab("dug_kyno_spotbush")
	inst:Remove()
end

local function SetLunarThrallProtection(inst, protected)
	inst._lunarthrall_protected = protected == true

	if inst._lunarthrall_protected then
		inst:RemoveTag("lunarplant_target")
	else
		inst:AddTag("lunarplant_target")
	end
end

local function GetStatus(inst, viewer)
	return (inst.components.burnable:IsBurning() and "BURNING")
	or (not inst.components.pickable:CanBePicked() and "PICKED")
	or "GENERIC"
end

local function OnSave(inst, data)
	data.bonus_yield = inst._bonus_yield
	data.lunarthrall_protected = inst._lunarthrall_protected
	data.original_transplanted = inst._original_transplanted
	data.vitality_active = inst._vitality_active
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.bonus_yield ~= nil then
			inst._bonus_yield = data.bonus_yield
		end

		if data.lunarthrall_protected ~= nil then
			SetLunarThrallProtection(inst, data.lunarthrall_protected)
		end

		if data.original_transplanted ~= nil then
			inst._original_transplanted = data.original_transplanted
		end

		if data.vitality_active ~= nil then
			inst._vitality_active = data.vitality_active

			if inst._vitality_active and inst.components.pickable ~= nil then
				inst.components.pickable.transplanted = false
			end
		end
	end
end

local function OnPreLoad(inst, data)
	WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_SPOTBUSH_GROWTIME)

	if data and data.was_herd then
		if TheWorld.components.lunarthrall_plantspawner then
			TheWorld.components.lunarthrall_plantspawner:setHerdsOnPlantable(inst)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_spotspice_shrub.png")

	MakeSmallObstaclePhysics(inst, .01)

	inst.AnimState:SetBank("quagmire_spiceshrub")
	inst.AnimState:SetBuild("quagmire_spiceshrub")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("plant")
	inst:AddTag("bush")
	inst:AddTag("renewable")
	inst:AddTag("spotbush")
	inst:AddTag("lunarplant_target")
	inst:AddTag("plantboostable")
	inst:AddTag("pickablechickenfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.SetLunarThrallProtection = SetLunarThrallProtection

	inst._bonus_yield = false
	inst._lunarthrall_protected = false
	inst._original_transplanted = nil
	inst._vitality_active = false

	inst:AddComponent("lootdropper")
	inst:AddComponent("plantboostable")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_SPOTBUSH_GROWTIME, true)
	inst.components.pickable:SetUp("kyno_spotspice_leaf", TUNING.KYNO_SPOTBUSH_GROWTIME)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.ontransplantfn = ontransplantfn

	inst:ListenForEvent("picked", PlantBoosterBonusYield)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad

	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	MakeNoGrowInWinter(inst)
	MakeHauntableIgnite(inst)

	MakeWaxablePlant(inst)

	return inst
end

return Prefab("kyno_spotbush", fn, assets, prefabs)