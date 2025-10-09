--[[------------------------------------------------------------------------------------------------

	* Slaughter Tools should now work for any mob with "slaughterable" component.
	* Animals set to "Fearable" will run away from players who have recently used Slaughter Tools.
	* Animals set to "Aggressive" will be hostile towards players who have recently used Slaughter Tools.

	* Characters with tag "animal_butcher" can get extra loots set via "SetExtraLoot(table or string)"
	*  Custom loot code can be added via "SetExtraLootFn(function)"
	* Default loot is already handled by the game and doesn't need to be set.

	* To start, on your prefab:
	inst:AddComponent("slaughterable")

	* To make an animal run away from players who have recently used Slaughter Tools:
	inst.components.slaughterable:MakeFearable()

	* To make an animal hostile to players who have recently used Slaughter Tools:
	inst.components.slaughterable:MakeAggressive()

	* There are multiple ways to add extra loot:
	* Single loot
	inst.components.slaughterable:SetExtraLoot("meat")
	
	* Multiple loots
	inst.components.slaughterable:SetExtraLoot({"meat", "meat"})
	
	* Loot with quantity and chance:
	inst.components.slaughterable:SetExtraLoot(
	{
		{ prefab = "meat",        count = 2, chance = 0.75 }, -- 75%
		{ prefab = "beefalowool", count = 1, chance = 1.00 }, -- 100%
		{ prefab = "horn",        count = 1, chance = 0.10 },  -- 10%
	})

	* Extra Functions and Event listeners:
	* Function for extra loot
	inst.components.slaughterable:SetOnExtraLootDroppedFn(function(inst, doer, loot)
		print("Set something cool to happen?")
	end)

	* Event listener for when killed:
	inst:ListenForEvent("slaughtered", function(inst, data)
		print("We have been slaughtered!")
	end)

	* Event listener for extra loots:
	inst:ListenForEvent("slaughtered_extraloot", function(inst, data)
		print("Extra Loot:", data.prefab, "Doer:", data.doer and data.doer.prefab)
	end)
	
	* Relevant tags:
	* "slaughterable"      - Component tag.
	* "animal_butcher"     - Extra loot when slaughtering an animal.
	* "butcher_aggressive" - Makes animal aggressive towards the butcher.
	* "butcher_fearable"   - Makes animal fear the butcher.

]]------------------------------------------------------------------------------------------------

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