local _G = GLOBAL

local HOF_ICEBOXSTACKSIZE = GetModConfigData("ICEBOXSTACKSIZE")

if HOF_ICEBOXSTACKSIZE then
	local function IceBoxPostInit(inst)
		local function OnUpgrade(inst, performer, upgraded_from_item)
			local numupgrades = inst.components.upgradeable.numupgrades

			if numupgrades == 1 then
				inst._chestupgrade_stacksize = true

				if inst.components.container ~= nil then
					inst.components.container:Close()
					inst.components.container:EnableInfiniteStackSize(true)
				end

				if upgraded_from_item then
					local x, y, z = inst.Transform:GetWorldPosition()
					local fx = _G.SpawnPrefab("chestupgrade_stacksize_fx")
					fx.Transform:SetPosition(x, y, z)
				end
			end

			inst.components.upgradeable.upgradetype = nil

			if inst.components.lootdropper ~= nil then
				inst.components.lootdropper:SetLoot({"alterguardianhatshard"})
			end
		end

		local function OnLoadPostPass(inst, newents, data)
			if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
				OnUpgrade(inst)
			end
		end

		local function OnDecontructStructure(inst, caster)
			if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
				if inst.components.lootdropper ~= nil then
					inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("upgradeable")
		inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
		inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)

		inst.OnLoadPostPass = OnLoadPostPass
	end

	AddPrefabPostInit("icebox", IceBoxPostInit)
end