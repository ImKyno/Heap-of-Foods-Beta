local _G        = GLOBAL
local DF_COFFEE = GetModConfigData("COFFEEDROPRATE")

-- Dragonfly drops Coffee Plants.
local function DragonflyPostInit(inst)
	local function OnDeath(inst)
		if inst.components.lootdropper ~= nil then
			if inst.enraged then
				inst:DoTaskInTime(1.1, function()
					inst.components.lootdropper:SpawnLootPrefab("kyno_opalpreciousapple") -- Guaranteed when enraged.
				end)
			else
				if math.random() < TUNING.KYNO_OPALPRECIOUSAPPLE_CHANCE then
					inst:DoTaskInTime(1.1, function()
						inst.components.lootdropper:SpawnLootPrefab("kyno_opalpreciousapple")
					end)
				end
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		for _ = 1, DF_COFFEE do
			inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		end
	end

	inst:ListenForEvent("death", OnDeath)
end

AddPrefabPostInit("dragonfly", DragonflyPostInit)