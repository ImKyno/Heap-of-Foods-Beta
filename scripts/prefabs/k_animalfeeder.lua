require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_animalfeeder.zip"),
}

local prefabs =
{
	"collapse_small",
}

local function OnHammered(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	inst:Remove()
end

local function OnHit(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
	end
end

local function OnInteract(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("interact")
		inst.AnimState:PushAnimation("idle", true)
		
		inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	end
end

local function UpdateFoodSymbol(inst)
	if inst then
		local fueled = inst.components.fueled
		local percent = fueled.currentfuel / fueled.maxfuel

		if percent <= 0 then
			inst.AnimState:HideSymbol("food")
		elseif percent <= 0.20 then
			inst.AnimState:OverrideSymbol("food", "kyno_animalfeeder", "food")
		elseif percent <= 0.50 then
			inst.AnimState:OverrideSymbol("food", "kyno_animalfeeder", "food")
		elseif percent <= 1.00 then
			inst.AnimState:OverrideSymbol("food", "kyno_animalfeeder", "food")
		else
			inst.AnimState:OverrideSymbol("food", "kyno_animalfeeder", "food")
		end
	end
end

local function OnAddFuel(inst)
	if not inst:HasTag("burnt") then
		OnInteract(inst)
		UpdateFoodSymbol(inst)
	end
end

local function OnFuelEmpty(inst)
	UpdateFoodSymbol(inst)
end

local function OnFuelSectionChange(new, old, inst)
	UpdateFoodSymbol(inst)
end

local function OnBuilt(inst, data)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	inst.SoundEmitter:PlaySound("farming/common/farm/compost/place")
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable:IsBurning() and "BURNT")
	or (inst.components.fueled:IsEmpty() and "EMPTY")
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.20 and "FUEL_LOW") 
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.50 and "FUEL_MED")
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.70 and "FUEL_HIGH")
	or "GENERIC"
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
		inst.components.burnable.onburnt(inst)
	end

	UpdateFoodSymbol(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_animalfeeder.tex")

	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetScale(1.1, 1.1, 1.1)

	inst.AnimState:SetBank("kyno_animalfeeder")
	inst.AnimState:SetBuild("kyno_animalfeeder")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
	inst:AddTag("animalfeeder")
	
	MakeSnowCoveredPristine(inst)

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
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("fueled")
	inst.components.fueled.accepting = true
	inst.components.fueled.fueltype = FUELTYPE.ANIMALFOOD
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.maxfuel = TUNING.KYNO_ANIMALFEEDER_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_ANIMALFEEDER_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_ANIMALFEEDER_SECTIONS)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("onfeed", OnInteract)
	
	MakeSnowCovered(inst)
	MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_animalfeeder", fn, assets, prefabs),
MakePlacer("kyno_animalfeeder_placer", "kyno_animalfeeder", "kyno_animalfeeder", "idle", false, nil, nil, 1.1)