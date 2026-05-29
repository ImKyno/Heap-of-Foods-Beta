local _G = GLOBAL

local function SaplingPostInit(inst)
	local function SetLunarThrallProtection(inst, protected)
		inst._lunarthrall_protected = protected == true

		if inst._lunarthrall_protected then
			inst:RemoveTag("lunarplant_target")
		else
			inst:AddTag("lunarplant_target")
		end
	end

	inst:AddTag("plantboostable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.SetLunarThrallProtection = SetLunarThrallProtection

	inst._bonus_yield = false
	inst._lunarthrall_protected = false
	inst._original_transplanted = nil
	inst._vitality_active = false

	inst:AddComponent("plantboostable")

	inst:ListenForEvent("picked", _G.PlantBoosterBonusYield)

	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	inst.OnSave = function(inst, data)
		if _OnSave ~= nil then
			_OnSave(inst, data)
		end

		data.bonus_yield = inst._bonus_yield
		data.lunarthrall_protected = inst._lunarthrall_protected
		data.original_transplanted = inst._original_transplanted
		data.vitality_active = inst._vitality_active
	end

	inst.OnLoad = function(inst, data)
		if _OnLoad ~= nil then
			_OnLoad(inst, data)
		end

		if data ~= nil then
			if data.bonus_yield ~= nil then
				inst._bonus_yield = data.bonus_yield
			end

			if data.lunarthrall_protected ~= nil then
				SetLunarThrallProtection(inst, data.lunarthrall_protected)
			end

			if data.original_transplanted ~= nil then
				inst._original_transplanted = data.original_transplanted
			end

			if data.vitality_active ~= nil then
				inst._vitality_active = data.vitality_active

				if inst._vitality_active and inst.components.pickable ~= nil then
					inst.components.pickable.transplanted = false
				end
			end
		end
	end
end

AddPrefabPostInit("sapling",      SaplingPostInit)
AddPrefabPostInit("sapling_moon", SaplingPostInit)