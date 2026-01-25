require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/cartography_desk.zip"),
}

local prefabs =
{
	"collapse_small",
}

local function OnAddFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
end

local function OnFuelEmpty(inst)
	-- Placeholder, do something here later.
end

local function OnFuelSectionChange(new, old, inst)
	-- Placeholder, change animations here later.
end

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

local function OnBuilt(inst, data)
	inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
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
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cartographydesk.png") -- placeholder icon

	MakeObstaclePhysics(inst, .4)

	inst.AnimState:SetBank("cartography_desk") -- placeholder animations
	inst.AnimState:SetBuild("cartography_desk")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("animalfeeder")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
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

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_animalfeeder", fn, assets, prefabs),
MakePlacer("kyno_animalfeeder_placer", "cartography_desk", "cartography_desk", "idle")