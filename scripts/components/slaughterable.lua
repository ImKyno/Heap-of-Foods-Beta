local Slaughterable = Class(function(self, inst)
	self.inst = inst
	self.extra_loot = nil
	self.extra_lootfn = nil
	
	self.inst:AddTag("slaughterable")
end)

function Slaughterable:MakeAggressive(doer)
	self.inst:RemoveTag("butcher_fearable")
	self.inst:AddTag("butcher_aggressive")

	if doer ~= nil and doer:IsValid() and doer:HasTag("recent_butcher") then
		if self.inst.components.combat ~= nil then
			self.inst.components.combat:SetTarget(doer)
			self.inst.components.combat:ShareTarget(doer, 30, function(dude)
				return dude:HasTag("butcher_aggressive")
			end, 5)
		end
	end
end

function Slaughterable:MakeFearable()
	self.inst:RemoveTag("butcher_aggressive")
	self.inst:AddTag("butcher_fearable")

	if self.inst.components.combat ~= nil then
		self.inst.components.combat:GiveUp()
		self.inst.components.combat:SetTarget(nil)
	end
end

function Slaughterable:SetExtraLoot(loot_table)
	local formatted = {}

	if type(loot_table) == "string" then
		table.insert(formatted, { prefab = loot_table, count = 1, chance = 1 })
	elseif type(loot_table) == "table" then
		for _, entry in ipairs(loot_table) do

		if type(entry) == "string" then
			table.insert(formatted, { prefab = entry, count = 1, chance = 1 })
		elseif type(entry) == "table" then
			table.insert(formatted, 
				{
					prefab = entry.prefab,
					count = entry.count or 1,
					chance = entry.chance or 1
				})
			end
		end
	end

	self.extra_loot = formatted
end

function Slaughterable:SetExtraLootFn(fn)
    self.extra_lootfn = fn
end

function Slaughterable:DropExtraLoot(doer)
	if not (self.extra_loot and doer and doer:HasTag("animal_butcher")) then
		return
	end
	
	if not self.inst.components.lootdropper then
		return
	end

	for _, entry in ipairs(self.extra_loot) do
		if math.random() <= entry.chance then
			local count = math.max(1, entry.count or 1)
			
			for i = 1, count do
				local loot = self.inst.components.lootdropper:SpawnLootPrefab(entry.prefab)

				if self.extra_lootfn then
					self.extra_lootfn(self.inst, doer, loot)
				end

				self.inst:PushEvent("slaughtered_extraloot", { doer = doer, prefab = entry.prefab, loot = loot })
			end
		end
	end
end

return Slaughterable