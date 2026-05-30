local _G               = GLOBAL
local require          = _G.require
local PIG_COIN_ECONOMY = require("hof_pigcoineconomy")

local function PigKingPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return
	end

	if inst.components.trader ~= nil then
		local _abletoaccepttest = inst.components.trader.abletoaccepttest

		inst.components.trader:SetAbleToAcceptTest(function(inst, item, giver, ...)
			if PIG_COIN_ECONOMY.PrefabHasValue(item) then
				return true
			end

			return _abletoaccepttest ~= nil and _abletoaccepttest(inst, item, giver, ...) or true
		end)

		local _test = inst.components.trader.test

		inst.components.trader:SetAcceptTest(function(inst, item, giver, ...)
			if PIG_COIN_ECONOMY.PrefabHasValue(item) then
				return true
			end

			return _test ~= nil and _test(inst, item, giver, ...) or false
		end)

		local _onaccept = inst.components.trader.onaccept

		inst.components.trader.onaccept = function(inst, giver, item, ...)
			if PIG_COIN_ECONOMY.PrefabHasValue(item) then
				inst.sg:GoToState("cointoss")

				inst:DoTaskInTime(2 / 3, function()
					PIG_COIN_ECONOMY.GiveCoins(inst, giver, item)
				end)

				return
			end

			if _onaccept ~= nil then
				return _onaccept(inst, giver, item, ...)
			end
		end
	end
end

AddPrefabPostInit("pigking", PigKingPostInit)