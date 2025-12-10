local cooking = require("cooking")

local function ondone(self, done)
    if done then
        self.inst:AddTag("donecooking")
    else
        self.inst:RemoveTag("donecooking")
    end
end

local function oncheckready(inst)
    if inst.components.container ~= nil and
        not inst.components.container:IsOpen() and
        inst.components.container:IsFull() then
        inst:AddTag("readytocook")
    end
end

local function onnotready(inst)
    inst:RemoveTag("readytocook")
end

local CookwareStewer = Class(function(self, inst)
	self.inst = inst

	self.done = nil
	self.targettime = nil
	self.task = nil
	self.product = nil
	self.product_spoilage = nil
	self.spoiledproduct = "spoiled_food"
	self.spoiltime = nil
	self.cooktimemult = 1

	self.chef_id = nil
	self.ingredient_prefabs = nil
	self.ingredient_items = {}

	inst:ListenForEvent("itemget", oncheckready)
	inst:ListenForEvent("onclose", oncheckready)

	inst:ListenForEvent("itemlose", onnotready)
	inst:ListenForEvent("onopen", onnotready)

	inst:AddTag("cookwarestewer")
end,
nil,
{
	done = ondone,
})

function CookwareStewer:OnRemoveFromEntity()
	self.inst:RemoveTag("cookwarestewer")
	self.inst:RemoveTag("donecooking")
	self.inst:RemoveTag("readytocook")
end

local function dospoil(inst, self)
	self.task = nil
	self.targettime = nil
	self.spoiltime = nil

	if self.onspoil ~= nil then
		self.onspoil(inst)
	end
end

local function dostew(inst, self)
	self.task = nil
	self.targettime = nil
	self.spoiltime = nil

	if self.ondonecooking ~= nil then
		self.ondonecooking(inst)
	end

	if self.product == self.spoiledproduct then
		if self.onspoil ~= nil then
			self.onspoil(inst)
		end
	elseif self.product ~= nil then
		local recipe = cooking.GetRecipe(inst.prefab, self.product)
		local prep_perishtime = (recipe ~= nil and (recipe.cookpot_perishtime or recipe.perishtime)) or 0
		
		if prep_perishtime > 0 then
			local prod_spoil = self.product_spoilage or 1
			
			self.spoiltime = prep_perishtime * prod_spoil
			self.targettime =  GetTime() + self.spoiltime
			
			if self.inst:HasTag("cookwarestewer_furnace") then -- (cookwarestewer_oven) Deprecated.
				self.spoiltime = nil
				self.targettime = nil
            else
				self.task = self.inst:DoTaskInTime(self.spoiltime, dospoil, self)
			end
		end
	end

	self.done = true
end

function CookwareStewer:IsDone()
	return self.done
end

function CookwareStewer:IsSpoiling()
	return self.done and self.targettime ~= nil
end

function CookwareStewer:IsCooking()
	return not self.done and self.targettime ~= nil
end

function CookwareStewer:GetTimeToCook()
	return not self.done and self.targettime ~= nil and self.targettime - GetTime() or 0
end

function CookwareStewer:GetTimeToSpoil()
	return self.done and self.targettime ~= nil and self.targettime - GetTime() or 0
end

function CookwareStewer:CanCook()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function CookwareStewer:GetRecipeForProduct()
	return self.product ~= nil and cooking.GetRecipe(self.inst.prefab, self.product) or nil
end

function CookwareStewer:StartCooking(doer)
	if self.targettime == nil and self.inst.components.container ~= nil then
		self.chef_id = (doer ~= nil and doer.player_classified ~= nil) and doer.userid
		self.ingredient_prefabs = {}

		self.done = nil
		self.spoiltime = nil

		if self.onstartcooking ~= nil then
			self.onstartcooking(self.inst)
		end

		for k, v in pairs (self.inst.components.container.slots) do
			table.insert(self.ingredient_prefabs, v.prefab)
		end

		local cooktime = 1
		self.product, cooktime = cooking.CalculateRecipe(self.inst.prefab, self.ingredient_prefabs)
        
		local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
		local productperishtime = (recipe ~= nil and (recipe.cookpot_perishtime or recipe.perishtime)) or 0
		local keepspoilage = self.inst:HasTag("cookwarestewer_furnace") -- (cookwarestewer_oven) Deprecated.
		local alwaysfresh = self.inst:HasTag("cookwarestewer_grill")

		if productperishtime > 0 then
			local spoilage_total = 0
			local spoilage_n = 0

			for k, v in pairs(self.inst.components.container.slots) do
				if v.components.perishable ~= nil then
					spoilage_n = spoilage_n + 1
					spoilage_total = spoilage_total + v.components.perishable:GetPercent()
				end
			end

			if alwaysfresh then
				self.product_spoilage = 1
			elseif keepspoilage then
				self.product_spoilage = spoilage_n > 0 and (spoilage_total / spoilage_n) or 1
			else
				self.product_spoilage = spoilage_n > 0 and (1 - (1 - spoilage_total / spoilage_n) * 0.5) or 1
			end
		else
			self.product_spoilage = nil
		end

		cooktime = TUNING.BASE_COOK_TIME * cooktime * self.cooktimemult
        
		self.targettime = GetTime() + cooktime
		
		if self.task ~= nil then
			self.task:Cancel()
		end
		
		self.task = self.inst:DoTaskInTime(cooktime, dostew, self)
		
		self.ingredient_items = {}

		for slot, item in pairs(self.inst.components.container.slots) do
			if item ~= nil then
				self.ingredient_items[slot] = 
				{
					prefab = item.prefab,
					perish = item.components.perishable ~= nil and item.components.perishable:GetPercent() or nil,
					stacksize = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1,
				}
			end
		end

		self.inst.components.container:Close()
		self.inst.components.container:DestroyContents()
		self.inst.components.container.canbeopened = false
	end
end

local function StopProductPhysics(prod)
	prod.Physics:Stop()
end

function CookwareStewer:StopCooking(reason)
	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end
	
	if self.product ~= nil and reason == "fire" then
		local prod = SpawnPrefab(self.product)
		
		if prod ~= nil then
			prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			prod:DoTaskInTime(0, StopProductPhysics)
		end
	end
	
	self.product = nil
	self.product_spoilage = nil
	self.spoiltime = nil
	self.targettime = nil
	self.done = nil
end

function CookwareStewer:OnSave()
	local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
	local saved_ingredients = nil
	
	if self.ingredient_items ~= nil and next(self.ingredient_items) ~= nil then
		saved_ingredients = {}
		local valid_slots = {}
		
		for slot, _ in pairs(self.ingredient_items) do
			table.insert(valid_slots, slot)
		end

		local chosen_slot = valid_slots[math.random(#valid_slots)]
		local item = self.ingredient_items[chosen_slot]

		if item ~= nil then
			if item.components ~= nil then
				saved_ingredients[chosen_slot] = 
				{
					prefab = item.prefab,
					perish = item.components.perishable ~= nil and item.components.perishable:GetPercent() or nil,
					stacksize = item.components.stackable ~= nil and item.components.stackable:StackSize() or nil,
				}
			else
				saved_ingredients[chosen_slot] = item
			end
		end
	end
	
	return
	{
		done = self.done,
		product = self.product,
		product_spoilage = self.product_spoilage,
		spoiltime = self.spoiltime,
		remainingtime = remainingtime > 0 and remainingtime or nil,

		chef_id = self.chef_id,
		ingredient_prefabs = self.ingredient_prefabs,
		ingredient_save = saved_ingredients,
	}
end

function CookwareStewer:OnLoad(data)
	if data.product ~= nil then
		self.chef_id = data.chef_id
		self.ingredient_prefabs = data.ingredient_prefabs

		self.done = data.done or nil
		self.product = data.product
		self.product_spoilage = data.product_spoilage
		self.spoiltime = data.spoiltime

		self.ingredient_items = {}
		
		local ingredients_data = data.ingredient_save or data.ingredient_items
		
		if ingredients_data ~= nil then
			for slot, item_data in pairs(ingredients_data) do
				if item_data ~= nil and item_data.prefab ~= nil then
					self.ingredient_items[slot] = 
					{
						prefab = item_data.prefab,
						perish = item_data.perish,
						stacksize = item_data.stacksize,
					}
				end
			end
		end

		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end
		
		self.targettime = nil

		if data.remainingtime ~= nil then
			self.targettime = GetTime() + math.max(0, data.remainingtime)
			
			if self.done then
				self.task = self.inst:DoTaskInTime(data.remainingtime, dospoil, self)
				
				if self.oncontinuedone ~= nil then
					self.oncontinuedone(self.inst)
				end
			else
				self.task = self.inst:DoTaskInTime(data.remainingtime, dostew, self)
				
				if self.oncontinuecooking ~= nil then
					self.oncontinuecooking(self.inst)
				end
			end
		elseif self.product ~= self.spoiledproduct and data.product_spoilage ~= nil then
			self.targettime = GetTime()
			self.task = self.inst:DoTaskInTime(0, dostew, self)
			
			if self.oncontinuecooking ~= nil then
				self.oncontinuecooking(self.inst)
			end
		elseif self.oncontinuedone ~= nil then
			self.oncontinuedone(self.inst)
		end

		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = false
		end
	end
end

function CookwareStewer:GetDebugString()
	local status = (self:IsCooking() and "COOKING")
	or (self:IsDone() and "FULL")
	or "EMPTY"

	return string.format("%s %s timetocook: %.2f timetospoil: %.2f productspoilage: %.2f",
	self.product or "<none>",
	status,
	self:GetTimeToCook(),
	self:GetTimeToSpoil(),
	self.product_spoilage or -1)
end

function CookwareStewer:Harvest(harvester)
	if self.done then
		if self.onharvest ~= nil then
			self.onharvest(self.inst)
		end

		if self.product ~= nil then
			local loot = SpawnPrefab(self.product)
			
			if loot ~= nil then
				local recipe = cooking.GetRecipe(self.inst.prefab, self.product)

				if harvester ~= nil and
					self.chef_id == harvester.userid and
					recipe ~= nil and
					recipe.cookbook_category ~= nil and
					cooking.cookbook_recipes[recipe.cookbook_category] ~= nil and
					cooking.cookbook_recipes[recipe.cookbook_category][self.product] ~= nil then
					harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
				end

				if loot.components.stackable ~= nil then
					local stacksize = recipe and recipe.stacksize or 1
				
					if stacksize > 1 then
						loot.components.stackable:SetStackSize(stacksize)
					end
				end
				
				local is_oven = self.inst:HasTag("oven_casserole")
				local is_small = self.inst:HasTag("oven_casserole_small")
				local should_save = false

				if is_oven then
					should_save = true
				elseif is_small and math.random() < 0.5 then
					should_save = true
				end
				
				if should_save and self.ingredient_items ~= nil and next(self.ingredient_items) ~= nil then
					local valid_slots = {}
    
					for slot, _ in pairs(self.ingredient_items) do
						table.insert(valid_slots, slot)
					end
					
					local random_slot = valid_slots[math.random(#valid_slots)]
					local original_item_data = self.ingredient_items[random_slot]

					if original_item_data ~= nil then
						local ing = SpawnPrefab(original_item_data.prefab)
						
						if ing ~= nil and self.inst.components.container ~= nil then
							if original_item_data.stacksize and ing.components.stackable ~= nil then
								ing.components.stackable:SetStackSize(original_item_data.stacksize)
							end
							
							if original_item_data.perish and ing.components.perishable ~= nil then
								ing.components.perishable:SetPercent(original_item_data.perish)
							end
							
							if self.inst.components.container:GetItemInSlot(random_slot) == nil then
								self.inst.components.container:GiveItem(ing, random_slot)
							else
								self.inst.components.container:GiveItem(ing)
							end

							-- print(string.format("CookwareStewer - %s Saved '%s' in slot %d with %.1f%% spoilage time.", is_small and "Small Casserole" or "Casserole",
							-- ing.prefab, random_slot, (ing.components.perishable and ing.components.perishable:GetPercent() * 100 or 100)))
						end
					end
				end
				
				if self.spoiltime ~= nil and loot.components.perishable ~= nil then
					if self.inst:HasTag("cookwarestewer_grill") then
						loot.components.perishable:SetPercent(1)
						loot.components.perishable:StartPerishing()
					else
						local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
						loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
						loot.components.perishable:StartPerishing()
					end
				end
				
				if harvester ~= nil and harvester.components.inventory ~= nil then
					harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
				else
					LaunchAt(loot, self.inst, nil, 1, 1)
				end
				
				-- Anniverary Event. Chance to get Anniversary Cheer when cooking.
				if not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[loot.prefab] and IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) 
				and harvester:HasTag("cheer_rewardable") --[[math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE]]  then
					local cheer = SpawnPrefab("kyno_hofbirthday_cheer")
					
					if harvester ~= nil and harvester.components.inventory ~= nil then
						harvester.components.inventory:GiveItem(cheer, nil, self.inst:GetPosition())
					else
						LaunchAt(cheer, self.inst, nil, 1, 1)
					end
				end
			end
			
			self.product = nil
		end

		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end
		
		self.targettime = nil
		self.done = nil
		self.spoiltime = nil
		self.product_spoilage = nil

		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = true
		end

		return true
	end
end

function CookwareStewer:LongUpdate(dt)
	if self:IsCooking() then
		if self.task ~= nil then
			self.task:Cancel()
		end
		
		if self.targettime - dt > GetTime() then
			self.targettime = self.targettime - dt
			self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), dostew, self)
			dt = 0
		else
			dt = dt - self.targettime + GetTime()
			dostew(self.inst, self)
		end
	end

	if dt > 0 and self:IsSpoiling() then
		if self.task ~= nil then
			self.task:Cancel()
		end
		
		if self.targettime - dt > GetTime() then
			self.targettime = self.targettime - dt
			self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), dospoil, self)
		else
			dospoil(self.inst, self)
		end
	end
end

return CookwareStewer
