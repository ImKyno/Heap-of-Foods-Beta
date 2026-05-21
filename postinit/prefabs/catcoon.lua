local _G = GLOBAL

-- Catcoon drops Gummy Slug / Mystery Meat.
local function CatcoonPostInit(inst)
	local _OnGetItemFromPlayer

	local function OnGetItemFromPlayer(inst, giver, item)
		if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end

		if inst.components.combat.target == giver then
			inst.components.combat:SetTarget(nil)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")
		end

		if item:HasTag("fish") then
			if not inst.sg:HasStateTag("busy") then
				inst:FacePoint(giver.Transform:GetWorldPosition())
				inst.sg:GoToState("pawground2")
			end
		end

		item:Remove()

		return _OnGetItemFromPlayer(inst, giver, item)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.trader ~= nil then
		_OnGetItemFromPlayer = inst.components.trader.onaccept
		inst.components.trader.onaccept = OnGetItemFromPlayer
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_gummybug", 0.35)
	end
end

AddPrefabPostInit("catcoon", CatcoonPostInit)