local _G = GLOBAL

local function GrassGatorPostInit(inst)
	inst:AddTag("slaughterable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("slaughterable")
	inst.components.slaughterable:SetExtraLoot({"plantmeat", "plantmeat"})
	inst.components.slaughterable:MakeFearable()

	inst:ListenForEvent("slaughtered_extraloot", function(inst, data)
		if TUNING.HOF_DEBUG_MODE then
			print("Extra loot:", data.prefab, "doer", data.doer and data.doer.prefab)
		end
	end)
end

AddPrefabPostInit("grassgator", GrassGatorPostInit)