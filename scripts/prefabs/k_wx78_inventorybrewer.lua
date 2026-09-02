local brewing = require("hof_brewing")

local assets =
{
	Asset("ANIM", "anim/ui_brewer_1x3.zip"),
	Asset("ANIM", "anim/ui_wx78_brewer_1x3.zip"),

	Asset("ANIM", "anim/kyno_brewingbubbles_fx.zip"),
}

local prefabs =
{

}

for k, v in pairs(brewing.recipes.kyno_woodenkeg) do
	table.insert(prefabs, v.name)
end

for k, v in pairs(brewing.recipes.kyno_preservesjar) do
	table.insert(prefabs, v.name)
end

local function GetBrewerActionString(inst, owner)
	local owner = inst.entity:GetParent()
	local brewer_net = owner ~= nil and owner._brewer_container_net
	local container = brewer_net ~= nil and brewer_net:value()

	if container ~= nil and container.replica.container ~= nil and container.replica.container:IsOpenedBy(owner) then
		return STRINGS.ACTIONS.RUMMAGE.CLOSE
	end

	return STRINGS.ACTIONS.BREWER
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("wxbrewer")

	inst.GetBrewerActionString = GetBrewerActionString

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("wx78_brewer")
		end

		return inst
	end

	inst:AddComponent("wxbrewer")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("wx78_brewer")

	return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_brewingbubbles_fx")
	inst.AnimState:SetBuild("kyno_brewingbubbles_fx")
	inst.AnimState:PlayAnimation("level1_pre")
	inst.AnimState:PushAnimation("level1_loop", true)

	inst:AddTag("DECOR")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

return Prefab("kyno_wx78_inventorybrewer", fn, assets, prefabs),
Prefab("kyno_brewingbubbles_fx", fxfn, assets)