GLOBAL.setfenv(1, GLOBAL)

local _SpawnPrefab = SpawnPrefab
function SpawnPrefab(name, skin, skin_id, creator, skin_custom, ...)
	local inst = _SpawnPrefab(name, skin, skin_id, creator, skin_custom, ...)

	if inst ~= nil and inst.components.legacyentity ~= nil then
		local actual_creator = creator

		if actual_creator == nil then
			actual_creator = ThePlayer
		end

		inst:DoTaskInTime(0, function(inst)
			if inst:IsValid() and inst.components.legacyentity ~= nil then
				inst.components.legacyentity:Check(actual_creator)
			end
		end)
	end

	return inst
end