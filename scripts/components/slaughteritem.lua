local SlaughterItem = Class(function(self, inst)
    self.inst = inst
end)

function SlaughterItem:Slaughter(doer, target)
	if not target:HasTag("slaughterable") then
		return
	end

	if target.components.health ~= nil then
		target.components.health.invincible = false
		target.components.health:Kill()
	end
	
	if target.components.slaughterable ~= nil then
		target.components.slaughterable:DropExtraLoot(doer)
	end
	
	if self.inst.components.finiteuses ~= nil then
		self.inst.components.finiteuses:Use(1)
	end

	doer:AddTag("recent_butcher")
	
	if doer.butcher_task ~= nil then
		doer.butcher_task:Cancel()
	end

	doer.butcher_task = doer:DoTaskInTime(TUNING.KYNO_SLAUGHTERTOOLS_COOLDOWN, function()
		if doer:IsValid() then
			doer:RemoveTag("recent_butcher")
			doer.butcher_task = nil
		end
	end)
	
	if doer.components.talker ~= nil then
		doer.components.talker:Say(GetString(doer, "ANNOUNCE_KYNO_SLAUGHTERTOOLS_USED"))
	end
	
	target:PushEvent("slaughtered", { doer = doer, target = target })

    self:MakeNearbyAnimalsAware(doer, target)
end

function SlaughterItem:SlaughterInsideInventory(doer, target)
	if not target:HasTag("slaughterable") then
		return
	end

	local owner = target.components.inventoryitem.owner
	
	if owner ~= nil and owner.components.inventory ~= nil then
		owner.components.inventory:RemoveItem(target, true)
	end

	if target.components.lootdropper ~= nil then
		local loot = target.components.lootdropper:GenerateLoot()

		for _, prefab in ipairs(loot) do
			local item = SpawnPrefab(prefab)
			
			if item ~= nil then
				doer.components.inventory:GiveItem(item)
			end
		end
	end

	if target.components.slaughterable ~= nil then
		target.components.slaughterable:DropExtraLoot(doer, function(item)
			doer.components.inventory:GiveItem(item)
		end)
	end

	if self.inst.components.finiteuses ~= nil then
		self.inst.components.finiteuses:Use(1)
	end

	doer:AddTag("recent_butcher")

	if doer.butcher_task ~= nil then
		doer.butcher_task:Cancel()
	end

	doer.butcher_task = doer:DoTaskInTime(TUNING.KYNO_SLAUGHTERTOOLS_COOLDOWN, function()
		if doer:IsValid() then
			doer:RemoveTag("recent_butcher")
			doer.butcher_task = nil
		end
	end)

	if doer.components.talker ~= nil then
		doer.components.talker:Say(GetString(doer, "ANNOUNCE_KYNO_SLAUGHTERTOOLS_USED"))
	end

	target:PushEvent("slaughtered", { doer = doer, target = target })
	-- target:Remove()
	
	self:MakeNearbyAnimalsAware(doer, target)
end

function SlaughterItem:MakeNearbyAnimalsAware(doer, target)
    if not (target and target:IsValid()) then 
        return 
    end

    local x, y, z = target.Transform:GetWorldPosition()
	local MAX_DIST = TUNING.KYNO_SLAUGHTERTOOLS_MAXDIST
	
	-- TheSim:FindEntities(x, y, z, radius, musttags, canttags, mustoneoftags)
    local nearby_animals = TheSim:FindEntities(x, y, z, MAX_DIST, {"slaughterable"}, {"player", "FX", "NOCLICK", "INLIMBO"})

	for _, mob in ipairs(nearby_animals) do
		if mob:IsValid() then
			if mob.components.slaughterable ~= nil and mob:HasTag("butcher_aggressive") then
				mob.components.slaughterable:MakeAggressive(doer)
			end
			
			if mob.components.slaughterable ~= nil and mob:HasTag("butcher_fearable") then
				mob.components.slaughterable:MakeFearable()
			end
		end
	end
end

return SlaughterItem