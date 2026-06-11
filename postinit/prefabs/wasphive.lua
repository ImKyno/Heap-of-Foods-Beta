local _G = GLOBAL

local function WaspHivePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.playerprox ~= nil then
		local _OnNear = inst.components.playerprox.onnear

		inst.components.playerprox:SetOnPlayerNear(function(inst, target)
			if target ~= nil and target:HasTag("beefriendly") then
				return
			end

			return _OnNear(inst, target)
		end)
	end
end

AddPrefabPostInit("wasphive", WaspHivePostInit)