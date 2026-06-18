local _G = GLOBAL

local VALID_AREAS =
{
	-- Deciduous Forest areas.
	BGDeciduous         = true,
	DeepDeciduous       = true,
	MagicalDeciduous    = true,
	DeciduousMole       = true,
	MolesvilleDeciduous = true,
	DeciduousClearing   = true,

	-- Pig King areas.
	PigCity             = true,
	PigKingdom          = true,
}

local function IsValidArea(id)
	if id == nil then
		return false
	end

	for area in pairs(VALID_AREAS) do
		if string.find(id, area, 1, true) then
			return true
		end
	end

	return false
end

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

	if inst.components.areaaware == nil then
		inst:AddComponent("areaaware")
	end

	inst._can_drop_truffle = false

	inst:ListenForEvent("changearea", function(inst, data)
		inst._can_drop_truffle = IsValidArea(data and data.id)
	end)

	inst:ListenForEvent("death", function(inst)
		if not inst._can_drop_truffle or inst.components.lootdropper == nil then
			return
		end

		local drop_truffles = inst:HasTag("werepig") or math.random() < TUNING.KYNO_TRUFFLES_PIG_CHANCE

		if drop_truffles then
			inst.components.lootdropper:SpawnLootPrefab("kyno_truffles")
		end
	end)
end

AddPrefabPostInit("pigman", PigmanPostInit)