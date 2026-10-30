local function OnValidItem(owner, item, recipe)
	if owner == nil or item == nil then
		return false
	end

	local recipe_name = recipe ~= nil and (recipe.name or recipe.product) or nil

	if recipe_name ~= nil and table.contains(TUNING.KYNO_CRAFTINGBUFF_BLACKLIST, recipe_name) then
		return false
	end

	if recipe.actionstr ~= nil and string.find(recipe.actionstr, "SHOP") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "shop") then
		return false
	end

	if recipe.actionstr ~= nil and string.find(recipe.actionstr, "TRADER") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "trader") then
		return false
	end

	if recipe.hint_msg ~= nil and string.find(recipe.hint_msg, "HERMITCRAB") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "hermitcrab") then
		return false
	end

	if item.components.inventoryitem == nil then
		return false
	end

	if not item.components.inventoryitem.cangoincontainer then
		return false
	end

	return true
end

local function OnBuildItem(owner, data)
	if owner ~= nil and data ~= nil then
		local item = data.item
		local recipe = data.recipe

		if item ~= nil and data.recipe ~= nil then
			if not OnValidItem(owner, item, recipe) then
				return
			end

			if TryLuckRoll(owner, TUNING.KYNO_CRAFTINGBUFF_DUPLICATE_CHANCE, HofLuckFormulas.AlphabetSoupDuplicateItem) then
				-- This allows the duplicate to spawn with skins too!
				local duplicate = SpawnPrefab(item.prefab, item.skinname, item.skin_id)

				if duplicate ~= nil then
					if owner.components.inventory ~= nil then
						if duplicate.components.stackable ~= nil then
							local stacks = owner.components.inventory:FindItems(function(item)
								return item.prefab == duplicate.prefab and item.components.stackable ~= nil
								and not item.components.stackable:IsFull()
							end)

							local stack = stacks ~= nil and stacks[1] or nil

							if stack ~= nil then
								local leftover = stack.components.stackable:Put(duplicate)

								if leftover ~= nil then
									owner.components.inventory:GiveItem(leftover, nil, owner:GetPosition())
								end
							else
								owner.components.inventory:GiveItem(duplicate, nil, owner:GetPosition())
							end
						else
							owner.components.inventory:GiveItem(duplicate, nil, owner:GetPosition())
						end
					else
						LaunchAt(duplicate, owner, nil, 1, 1)
					end
				end
			end
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_START"))
	end

	if target.kyno_craftingbuff_active ~= nil then
        target.kyno_craftingbuff_active:set(true)
    end

	target:ListenForEvent("builditem", OnBuildItem)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_END"))
	end

	if target.kyno_craftingbuff_active ~= nil then
        target.kyno_craftingbuff_active:set(false)
    end

	target:RemoveEventCallback("builditem", OnBuildItem)

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_craftingbuff")
	inst.components.timer:StartTimer("kyno_craftingbuff", TUNING.KYNO_CRAFTINGBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRAFTINGBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_craftingbuff" then
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
	inst.components.timer:StartTimer("kyno_craftingbuff", TUNING.KYNO_CRAFTINGBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_craftingbuff", fn)