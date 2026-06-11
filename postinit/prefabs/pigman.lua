local _G = GLOBAL

-- Truffles make pigs happy, yay.
local function PigmanPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.trader ~= nil then
		local _onaccept = inst.components.trader.onaccept

		inst.components.trader.onaccept = function(inst, giver, item, ...)
			if item and item:HasTag("truffles") then
				if giver and giver.components.leader ~= nil then
					if not (inst:HasTag("guard") or giver:HasTag("monster") or giver:HasTag("merm")) then
						giver:PushEvent("makefriend")
						giver.components.leader:AddFollower(inst)

						-- Pigs befriended with truffles will follow for longer times.
						inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
						inst.components.follower.maxfollowtime = giver:HasTag("polite")
						and TUNING.KYNO_TRUFFLES_PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
						or TUNING.KYNO_TRUFFLES_PIG_LOYALTY_MAXTIME
					end
				end
			end

			if _onaccept then
				_onaccept(inst, giver, item, ...)
			end
		end
	end
end

AddPrefabPostInit("pigman", PigmanPostInit)