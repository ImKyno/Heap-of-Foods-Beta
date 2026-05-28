local _G = GLOBAL

local function BerryBushJuicyPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
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
			end
		end
	end
end

AddPrefabPostInit("berrybush_juicy", BerryBushJuicyPostInit)