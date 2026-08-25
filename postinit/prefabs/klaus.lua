local _G      = GLOBAL
local require = _G.require

local function KlausPostInit(inst)
	local function OnDeath(inst)
		if inst.components.lootdropper ~= nil then
			if inst.enraged and inst:IsUnchained() then
				inst:DoTaskInTime(1.1, function()
					inst.components.lootdropper:SpawnLootPrefab("kyno_opalpreciousapple")
				end)
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:ListenForEvent("death", OnDeath)
end

AddPrefabPostInit("klaus", KlausPostInit)