local brewing = require("hof_brewing")

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

local Brewer = Class(function(self, inst)
	self.inst = inst

	self.done = nil
	self.targettime = nil
	self.task = nil
	self.product = nil
	self.brewtimemult = 1

	self.chef_id = nil
	self.ingredient_prefabs = nil

	inst:ListenForEvent("itemget", oncheckready)
	inst:ListenForEvent("onclose", oncheckready)

	inst:ListenForEvent("itemlose", onnotready)
	inst:ListenForEvent("onopen", onnotready)

	inst:AddTag("brewer")
end,
nil,
{
	done = ondone,
})

function Brewer:OnRemoveFromEntity()
	self.inst:RemoveTag("brewer")
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
	end

	self.done = true
end

function Brewer:IsDone()
	return self.done
end

function Brewer:IsSpoiling()
	return false
end

function Brewer:IsCooking()
	return not self.done and self.targettime ~= nil
end

function Brewer:GetTimeToCook()
	return not self.done and self.targettime ~= nil and self.targettime - GetTime() or 0
end

function Brewer:GetTimeToSpoil()
	return 0
end

function Brewer:CanCook()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function Brewer:GetRecipeForProduct()
	return self.product ~= nil and brewing.GetBrewing(self.inst.prefab, self.product) or nil
end

function Brewer:StartCooking(doer)
	if self.targettime == nil and self.inst.components.container ~= nil then
		self.chef_id = (doer ~= nil and doer.player_classified ~= nil) and doer.userid
		self.ingredient_prefabs = {}

		self.done = nil

		if self.onstartcooking ~= nil then
			self.onstartcooking(self.inst)
		end

		for k, v in pairs (self.inst.components.container.slots) do
			table.insert(self.ingredient_prefabs, v.prefab)
		end

		local cooktime = 1
		self.product, cooktime = brewing.CalculateBrewing(self.inst.prefab, self.ingredient_prefabs)

		cooktime = TUNING.BASE_COOK_TIME * cooktime * self.brewtimemult

		self.targettime = GetTime() + cooktime
		if self.task ~= nil then
			self.task:Cancel()
		end

		self.task = self.inst:DoTaskInTime(cooktime, dostew, self)

		self.inst.components.container:Close()
		self.inst.components.container:DestroyContents()
		self.inst.components.container.canbeopened = false
	end
end

local function StopProductPhysics(prod)
	prod.Physics:Stop()
end

function Brewer:StopCooking(reason)
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
	self.targettime = nil
	self.done = nil
end

function Brewer:OnSave()
	local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
	return
	{
		done = self.done,
		product = self.product,

		remainingtime = remainingtime > 0 and remainingtime or nil,

		chef_id = self.chef_id,
		ingredient_prefabs = self.ingredient_prefabs,
	}
end

function Brewer:OnLoad(data)
	if data.product ~= nil then
		self.chef_id = data.chef_id
		self.ingredient_prefabs = data.ingredient_prefabs

		self.done = data.done or nil
		self.product = data.product

		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end

		self.targettime = nil

		if data.remainingtime ~= nil then
			self.targettime = GetTime() + math.max(0, data.remainingtime)
			if self.done then
				if self.oncontinuedone ~= nil then
					self.oncontinuedone(self.inst)
				end
			else
				self.task = self.inst:DoTaskInTime(data.remainingtime, dostew, self)
				if self.oncontinuecooking ~= nil then
					self.oncontinuecooking(self.inst)
				end
			end
		elseif self.product ~= self.spoiledproduct then
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

function Brewer:GetDebugString()
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

function Brewer:Harvest(harvester)
	if self.done then
		if self.onharvest ~= nil then
			self.onharvest(self.inst)
		end

		if self.product ~= nil then
			local loot = SpawnPrefab(self.product)
			if loot ~= nil then
				local recipe = brewing.GetBrewing(self.inst.prefab, self.product)

				if harvester ~= nil and
					self.chef_id == harvester.userid and
					recipe ~= nil and
					recipe.brewbook_category ~= nil and
					brewing.brewbook_recipes[recipe.brewbook_category] ~= nil and
					brewing.brewbook_recipes[recipe.brewbook_category][self.product] ~= nil then
					harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
					harvester:PushEvent("learnbrewbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs}) -- For Accomplishments Mod.
				end

				local stacksize = recipe and recipe.stacksize or 1
				if stacksize > 1 then
					loot.components.stackable:SetStackSize(stacksize)
				end

				if loot.components.perishable ~= nil then
					loot.components.perishable:StartPerishing()
				end

				if harvester ~= nil and harvester.components.inventory ~= nil then
					harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
				else
					LaunchAt(loot, self.inst, nil, 1, 1)
				end

				-- Anniverary Event. Chance to get Anniversary Cheer when brewing.
				if not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[loot.prefab] and IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY)
				and harvester:HasTag("cheer_rewardable") --[[math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE]]  then
					local cheer = SpawnPrefab("kyno_hofbirthday_cheer")

					if harvester ~= nil and harvester.components.inventory ~= nil then
						harvester.components.inventory:GiveItem(cheer, nil, self.inst:GetPosition())
					else
						LaunchAt(cheer, self.inst, nil, 1, 1)
					end
				end

				-- For refunding Empty Bottles when harvesting.
				if harvester ~= nil and loot ~= nil and loot:HasTag("bottled") then
					local amount = loot.bottlesize or 1

					for i = 1, amount do
						local bottle = SpawnPrefab("messagebottleempty")

						if bottle then
							local inv = harvester.components.inventory

							if inv then
								inv:GiveItem(bottle, nil, self.inst:GetPosition())
							else
								LaunchAt(bottle, self.inst, nil, 1, 1)
							end
						end
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

		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = true
		end

		return true
	end
end

function Brewer:LongUpdate(dt)
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
end

return Brewer
