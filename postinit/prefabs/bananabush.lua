local _G = GLOBAL

-- Make Banana Bushes give our Bananas instead.
local function BananaBushPostInit(inst)
	inst:AddTag("plantboostable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.SetLunarThrallProtection = SetLunarThrallProtection

	inst._bonus_yield = false
	inst._original_transplanted = nil
	inst._vitality_active = false

	inst:AddComponent("plantboostable")

	if inst.components.pickable ~= nil then
		inst.components.pickable:SetUp("kyno_banana")
	end

	inst:ListenForEvent("picked", _G.PlantBoosterBonusYield)

	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	inst.OnSave = function(inst, data)
		if _OnSave ~= nil then
			_OnSave(inst, data)
		end

		data.bonus_yield = inst._bonus_yield
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

				if inst._bonus_yield then
					inst:AddTag("plantboosted_yield")
				else
					inst:RemoveTag("plantboosted_yield")
				end
			end

			if data.original_transplanted ~= nil then
				inst._original_transplanted = data.original_transplanted
			end

			if data.vitality_active ~= nil then
				inst._vitality_active = data.vitality_active

				if inst._vitality_active then
					inst:AddTag("plantboosted_vitality")

					if inst.components.pickable ~= nil then
						inst.components.pickable.transplanted = false
					end
				else
					inst:RemoveTag("plantboosted_vitality")
				end
			end
		end
	end
end

AddPrefabPostInit("bananabush", BananaBushPostInit)