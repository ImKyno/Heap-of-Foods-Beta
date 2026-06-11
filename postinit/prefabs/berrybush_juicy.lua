local _G = GLOBAL

local function BerryBushJuicyPostInit(inst)
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

				if inst._bonus_yield then
					inst:AddTag("plantboosted_yield")
				else
					inst:RemoveTag("plantboosted_yield")
				end
			end

			if data.lunarthrall_protected ~= nil then
				SetLunarThrallProtection(inst, data.lunarthrall_protected)
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

	if inst.components.pickable ~= nil then
		local _OnPicked = inst.components.pickable.onpickedfn

		inst.components.pickable.onpickedfn = function(inst, picker, ...)
			if _OnPicked ~= nil then
				_OnPicked(inst, picker, ...)
			end

			if picker ~= nil then
				local debuffable = picker.components.debuffable

				if debuffable ~= nil and debuffable:HasDebuff("kyno_greenthumbbuff") then
					for i = 1, 3 do
						local extra = _G.SpawnPrefab(inst.components.pickable.product)

						if extra ~= nil then
							_G.LaunchAt(extra, inst, nil, 1, 1)
						end
					end
				end

				-- Yes... you get 9 berries with both buff and booster.
				if inst._bonus_yield then
					for i = 1, 3 do
						local extra = _G.SpawnPrefab(inst.components.pickable.product)

						if extra ~= nil then
							_G.LaunchAt(extra, inst, nil, 1, 1)
						end
					end
				end
			end
		end
	end
end

AddPrefabPostInit("berrybush_juicy", BerryBushJuicyPostInit)