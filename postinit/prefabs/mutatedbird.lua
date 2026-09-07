local _G = GLOBAL

local function MutatedBirdPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	local nightbirdspawner = _G.TheWorld.components.nightbirdspawner

	if nightbirdspawner ~= nil then
		inst:ListenForEvent("onremove", nightbirdspawner.StopTrackingFn)
		inst:ListenForEvent("enterlimbo", nightbirdspawner.StopTrackingFn)

		nightbirdspawner:StartTracking(inst)
	end
end

AddPrefabPostInit("mutatedbird", MutatedBirdPostInit)