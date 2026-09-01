local brewing = require("hof_brewing")

local assets =
{
	Asset("ANIM", "anim/ui_brewer_1x3.zip"),
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

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("wxbrewer")

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
	inst.components.container.stay_open_on_hide = true

	return inst
end

return Prefab("kyno_wx78_inventorybrewer", fn, assets)