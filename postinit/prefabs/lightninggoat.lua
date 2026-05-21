local _G      = GLOBAL
local require = _G.require

require("constants")
require("hof_util")

local function LightningGoatPostInit(inst)
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
		local kick_chance = TUNING.MILKABLE_KICK_CHANCE_NORMAL

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
			inst.AnimState:PlayAnimation("taunt", false)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/taunt")

			milker.components.combat:GetAttacked(inst, TUNING.MILKABLE_LIGHTNINGGOAT_DAMAGE)
			milker:PushEvent("kick")
		else
			if inst.components.sleeper ~= nil and not inst.components.sleeper:IsAsleep() then
				inst.AnimState:PlayAnimation("bleet", false)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/bleet")
			end
		end
	end

	inst:AddTag("slaughterable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("milkableanimal")
	inst.components.milkableanimal:SetUp("goatmilk")
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

AddPrefabPostInit("lightninggoat", LightningGoatPostInit)