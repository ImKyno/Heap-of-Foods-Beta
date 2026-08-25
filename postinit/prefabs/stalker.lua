local _G = GLOBAL

local function StalkerAtriumPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		local _lootsetupfn = inst.components.lootdropper.lootsetupfn

		inst.components.lootdropper:SetLootSetupFn(function(lootdropper)
			if _lootsetupfn ~= nil then
				_lootsetupfn(lootdropper)
			end

			if not lootdropper.inst.atriumdecay then
				lootdropper:AddChanceLoot("kyno_opalpreciousapple", 0.10)
			end
		end)
	end
end

AddPrefabPostInit("stalker_atrium", StalkerAtriumPostInit)