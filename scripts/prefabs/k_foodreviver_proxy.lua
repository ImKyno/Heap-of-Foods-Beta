local function OnActivate(inst, player)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("shadow_puff").Transform:SetPosition(x, y, z)

	TheWorld:PushEvent("ms_sendlightningstrike", inst:GetPosition())

	inst:DoTaskInTime(0, inst.Remove)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("foodreviver")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:ListenForEvent("activateresurrection", OnActivate)

	return inst
end

return Prefab("kyno_foodreviver_proxy", fn)