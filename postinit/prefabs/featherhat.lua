local _G = GLOBAL

local function FeatherHatPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.equippable ~= nil then
		local _OnEquip = inst.components.equippable.onequipfn

		inst.components.equippable.onequipfn = function(inst, owner, ...)
			if _OnEquip ~= nil then
				_OnEquip(inst, owner, ...)
			end

			local attractor = owner.components.birdattractor

			if attractor ~= nil then
				attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_MAXDELTA_FEATHERHAT,       "maxbirds")
				attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MIN, "mindelay")
				attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MAX, "maxdelay")

				local nightbirdspawner = TheWorld.components.nightbirdspawner

				if nightbirdspawner ~= nil then
					nightbirdspawner:ToggleUpdate(true)
				end
			end
		end

		local _OnUnequip = inst.components.equippable.onunequipfn

		inst.components.equippable.onunequipfn = function(inst, owner, ...)
			if _OnUnequip ~= nil then
				_OnUnequip(inst, owner, ...)
			end

			local attractor = owner.components.birdattractor

			if attractor ~= nil then
				attractor.spawnmodifier:RemoveModifier(inst)

				local nightbirdspawner = TheWorld.components.nightbirdspawner

				if nightbirdspawner ~= nil then
					nightbirdspawner:ToggleUpdate(true)
				end
			end
		end
	end
end

AddPrefabPostInit("featherhat", FeatherHatPostInit)