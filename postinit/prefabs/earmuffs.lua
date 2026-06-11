local _G = GLOBAL

local function EarmuffsHatPostInit(inst)
	local _OnEquip
	local function OnEquip(inst, owner)
		if owner ~= nil then
			owner:AddTag("soundproof")
		end

		return _OnEquip(inst, owner)
	end

	local _OnUnequip
	local function OnUnequip(inst, owner)
		if owner ~= nil then
			owner:RemoveTag("soundproof")
		end

		return _OnUnequip(inst, owner)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.equippable ~= nil then
		_OnEquip = inst.components.equippable.onequipfn
		inst.components.equippable.onequipfn = OnEquip

		_OnUnequip = inst.components.equippable.onunequipfn
		inst.components.equippable.onunequipfn = OnUnequip
	end
end

AddPrefabPostInit("earmuffshat", EarmuffsHatPostInit)