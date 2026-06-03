local _G = GLOBAL

local function BullKelpPlantPostInit(inst)
	inst:AddTag("plantboostable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst._bonus_yield = false

	inst:AddComponent("plantboostable")

	inst:ListenForEvent("picked", _G.PlantBoosterBonusYield)

	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	inst.OnSave = function(inst, data)
		if _OnSave ~= nil then
			_OnSave(inst, data)
		end

		data.bonus_yield = inst._bonus_yield
	end

	inst.OnLoad = function(inst, data)
		if _OnLoad ~= nil then
			_OnLoad(inst, data)
		end

		if data ~= nil then
			if data.bonus_yield ~= nil then
				inst._bonus_yield = data.bonus_yield

				if inst._bonus_yield then
					inst:AddTag("plantboosted_yield")
				else
					inst:RemoveTag("plantboosted_yield")
				end
			end
		end
	end
end

AddPrefabPostInit("bullkelp_plant", BullKelpPlantPostInit)