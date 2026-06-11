local _G      = GLOBAL
local require = _G.require

require("constants")
require("hof_util")

local function KoalefantPostInit(inst)
	local function OnFreeze(inst)
		inst:AddTag("is_frozen")
	end

	local function OnThaw(inst)
		inst:AddTag("is_thawing")
	end

	local function OnUnfreeze(inst)
		inst:RemoveTag("is_frozen")
		inst:RemoveTag("is_thawing")
	end

	local function OnMilked(inst, milker)
		local kick_chance

		if inst:HasTag("domesticated") then
			kick_chance = TUNING.MILKABLE_KICK_CHANCE_DOMESTICATED
		elseif milker:HasTag("beefalo") then
			kick_chance = TUNING.MILKABLE_KICK_CHANCE_BEEFALOHAT
		else
			kick_chance = TUNING.MILKABLE_KICK_CHANCE_NORMAL
		end

		local should_kick = false

		if milker.components.luckuser ~= nil then
			should_kick = _G.TryLuckRoll(milker, kick_chance, HofLuckFormulas.MilkableAnimalKick)
		else
			should_kick = math.random() <= kick_chance
		end

		if should_kick and milker.components.combat ~= nil and inst.components.sleeper ~= nil 
		and inst.components.freezable ~= nil
		and not inst.components.sleeper:IsAsleep()
		and not (inst.components.freezable:IsFrozen()
		or inst.components.freezable:IsThawing()) then
			inst.AnimState:PlayAnimation("atk", false)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")

			milker.components.combat:GetAttacked(inst, TUNING.MILKABLE_KOALEFANT_DAMAGE)
			milker:PushEvent("kick")
		else
			if inst.components.sleeper ~= nil and not inst.components.sleeper:IsAsleep() then
				inst.AnimState:PlayAnimation("bellow", false)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/grunt")
			end
		end
	end

	inst:AddTag("slaughterable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("milkableanimal")
	inst.components.milkableanimal:SetUp("kyno_milk_koalefant")
	inst.components.milkableanimal.onmilkedfn = OnMilked

	inst:AddComponent("slaughterable")
	inst.components.slaughterable:SetExtraLoot({"meat", "meat"})
	inst.components.slaughterable:MakeFearable()

	inst:ListenForEvent("slaughtered_extraloot", function(inst, data)
		if TUNING.HOF_DEBUG_MODE then
			print("Extra loot:", data.prefab, "doer", data.doer and data.doer.prefab)
		end
	end)

	inst:ListenForEvent("onthaw", OnThaw)
	inst:ListenForEvent("freeze", OnFreeze)
	inst:ListenForEvent("unfreeze", OnUnfreeze)
end

AddPrefabPostInit("koalefant_summer", KoalefantPostInit)
AddPrefabPostInit("koalefant_winter", KoalefantPostInit)