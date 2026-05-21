local _G = GLOBAL

-- Frostjaw gives Fish Hatchery Foundation Kit blueprint and Special rewards.
local function SharkBoiPostInit(inst)
	local function CustomAcceptTest(inst, item)
		if item:HasTag("sharkboifood") then
			return not inst.sunkenchestgiven
		end

		return inst.pendingreward == nil
		and inst.stock > 0
		and item:HasTag("oceanfish")
		and item.components.weighable
		and item.components.weighable:GetWeight() >= TUNING.KYNO_SHARKBOI_FISH_WEIGHT_THRESHOLD
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	inst.OnSave = function(inst, data)
		if _OnSave ~= nil then
			_OnSave(inst, data)
		end

		data.blueprintgiven = inst.blueprintgiven or nil
		data.sunkenchestgiven = inst.sunkenchestgiven or nil
	end

	inst.OnLoad = function(inst, data)
		if _OnLoad ~= nil then
			_OnLoad(inst, data)
		end

		if data ~= nil then
			inst.blueprintgiven = data.blueprintgiven
			inst.sunkenchestgiven = data.sunkenchestgiven
		end
	end

	if inst.GiveReward ~= nil then
		local _GiveReward = inst.GiveReward

		inst.GiveReward = function(inst, target)
			_GiveReward(inst, target)

			if target == nil or not target:IsValid() then
				return
			end

			if inst.blueprintgiven then
				return
			end

			local blueprint = "kyno_fishfarmplot_construction_blueprint"

			if inst.sketchgiven == nil or inst.blueprintgiven == nil then
				if _G.IsSpecialEventActive(_G.SPECIAL_EVENTS.WINTERS_FEAST) then
					local gift = _G.SpawnPrefab("gift")

					gift.components.unwrappable:WrapItems({
						blueprint,
						"oceanfishinglure_hermit_snow",
						_G.GetRandomLightWinterOrnament(),
						"winter_food"..math.random(9), -- NUM_WINTERFOOD
					})

					_G.LaunchAt(gift, inst, target, 1.5, 2, 1.25)
				else
					local loot = _G.SpawnPrefab(blueprint)

					if loot ~= nil then
						_G.LaunchAt(loot, inst, target, 1.5, 2, 1.25)
					end
				end

				inst.blueprintgiven = true
			end
		end
	end

	if inst.MakeTrader ~= nil then
		local _MakeTrader = inst.MakeTrader

		inst.MakeTrader = function(inst, ...)
			local result = _MakeTrader(inst, ...)
			local trader = inst.components.trader

			if trader ~= nil and not trader._modded then
				trader._modded = true
				trader:SetAcceptTest(CustomAcceptTest)

				local _onaccept = trader.onaccept
				trader.onaccept = function(inst, giver, item, ...)
					if inst.sunkenchestgiven then
						if _onaccept and not item:HasTag("sharkboifood") then
							_onaccept(inst, giver, item, ...)
						end

						return
					end

					if item:HasTag("sharkboifood") then
						local chest = _G.SpawnPrefab("sunkenchest")

						if chest ~= nil then
							local x, y, z = inst.Transform:GetWorldPosition()
							chest.Transform:SetPosition(x, y, z)

							chest:AddComponent("scenariorunner")
							chest.components.scenariorunner:SetScript("sunkenchest_sharkboi")
							chest.components.scenariorunner:Run()

							_G.LaunchAt(chest, inst, giver, 2, 2, 2.25)
							inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
						end

						inst.sunkenchestgiven = true
						return
					end

					if _onaccept ~= nil then
						_onaccept(inst, giver, item, ...)
					end
				end
			end

			return result
		end
	end
end

AddPrefabPostInit("sharkboi", SharkBoiPostInit)