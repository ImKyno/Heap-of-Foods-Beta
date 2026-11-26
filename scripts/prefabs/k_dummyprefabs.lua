-- Dummy prefabs because some of them can't be used on TILED... 💀💀

local function berrybush_juicyfn()
	local inst = Prefabs["berrybush_juicy"].fn()

	inst:SetPrefabName("berrybush_juicy")

	return inst
end

return Prefab("kyno_dummy_berrybush_juicy", berrybush_juicyfn)