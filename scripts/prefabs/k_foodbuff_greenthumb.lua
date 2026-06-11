local function GiveExtraLoot(inst, loot)
	if loot == nil then
		return
	end

	if loot.prefab ~= nil then
		local extra = SpawnPrefab(loot.prefab)

		if extra ~= nil then
			if loot.components.stackable ~= nil and extra.components.stackable ~= nil then
				extra.components.stackable:SetStackSize(loot.components.stackable:StackSize())
			end

			if inst.components.inventory ~= nil then
				inst.components.inventory:GiveItem(extra)
			end
		end

		return
	end

	if type(loot) == "table" then
		for _, item in ipairs(loot) do
			if item ~= nil and item.prefab ~= nil then
				local extra = SpawnPrefab(item.prefab)

				if extra ~= nil then
					if item.components.stackable ~= nil and extra.components.stackable ~= nil then
						extra.components.stackable:SetStackSize(item.components.stackable:StackSize())
					end

					if inst.components.inventory ~= nil then
						inst.components.inventory:GiveItem(extra)
					end
				end
			end
		end
	end
end

local function IsValidPlant(target)
	return target ~= nil and target:HasAnyTag("plant", "tree", "greenthumb_valid")
	and not table.contains(TUNING.KYNO_GREENTHUMBBUFF_BLOCKED_PREFABS, target.prefab) -- Blocked prefabs.
	and not target.is_oversized -- Blocks Oversized crops.
end

local function OnPickSomething(inst, data)
	if data == nil or data.object == nil or data.loot == nil then
		return
	end

	if not IsValidPlant(data.object) then
		return
	end

	GiveExtraLoot(inst, data.loot)
end

local function OnHarvestSomething(inst, data)
	if data == nil or data.object == nil then
		return
	end

	if not IsValidPlant(data.object) then
		return
	end

	local target = data.object

	if target.components.harvestable == nil then
		return
	end

	local product = target.components.harvestable.product

	if product == nil then
		return
	end

	local produce = 1 -- target.components.harvestable.maxproduce or 1
	local loot = SpawnPrefab(product)

	if loot ~= nil and loot.components.stackable ~= nil then
		loot.components.stackable:SetStackSize(produce)
	end

	GiveExtraLoot(inst, loot)
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GREENTHUMBBUFF_START"))
	end

	target:ListenForEvent("picksomething", OnPickSomething)
	target:ListenForEvent("harvestsomething", OnHarvestSomething)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	target:RemoveEventCallback("picksomething", OnPickSomething)
	target:RemoveEventCallback("harvestsomething", OnHarvestSomething)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GREENTHUMBBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_greenthumbbuff")
	inst.components.timer:StartTimer("kyno_greenthumbbuff", TUNING.KYNO_GREENTHUMBBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_GREENTHUMBBUFF_START"))
	end

	target:RemoveEventCallback("picksomething", OnPickSomething)
	target:RemoveEventCallback("harvestsomething", OnHarvestSomething)

	inst:DoTaskInTime(1, function()
		target:ListenForEvent("picksomething", OnPickSomething)
		target:ListenForEvent("harvestsomething", OnHarvestSomething)
	end)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_greenthumbbuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	if not TheWorld.ismastersim then
		return
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()

	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_greenthumbbuff", TUNING.KYNO_GREENTHUMBBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_greenthumbbuff", fn)