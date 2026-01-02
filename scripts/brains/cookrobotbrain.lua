require("behaviours/standstill")

local cooking         = require("cooking")
local brewing         = require("hof_brewing")
local CookRobotCommon = require("prefabs/k_cook_robot_common")

local ignorethese = { }

local CookRobotBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function CookRobotBrain:IgnoreItem(item)
	self:UnignoreItem()

	self._targetitem = item
	
	self._targetitem_event_onputininventory = function()
		self:UnignoreItem()
	end

	ignorethese[item] = self.inst
	item:ListenForEvent("onputininventory", self._targetitem_event_onputininventory)
end

function CookRobotBrain:UnignoreItem()
	if self._targetitem then
		ignorethese[self._targetitem] = nil

		if self._targetitem_event_onputininventory ~= nil then
			if self._targetitem:IsValid() then
				self._targetitem:RemoveEventCallback("onputininventory", self._targetitem_event_onputininventory)
			end
			
			self._targetitem_event_onputininventory = nil
		end
		
		self._targetitem = nil
	end
end

function CookRobotBrain:ShouldIgnoreItem(item)
	return ignorethese[item] ~= nil and ignorethese[item] ~= self.inst
end

local function HasFoodOrder(inst)
	if inst.components.inventory == nil then
		print("[CookRobot] HasFoodOrder = false (no inventory)")
		return false
	end

	print("[CookRobot] HasFoodOrder:", inst._foodorder_prefab or "nil")
	return inst._foodorder_prefab ~= nil
end

local function GetFoodOrder(inst)
	if inst.components.inventory == nil then
		print("[CookRobot] GetFoodOrder = nil (no inventory)")
		return nil
	end
	
	if inst._foodorder_prefab == nil then
		print("[CookRobot] GetFoodOrder = nil (no valid food)")
		return nil
	end

	print("[CookRobot] HasFoodOrder:", inst._foodorder_prefab or "nil")
	return inst._foodorder_prefab
end

local function GetOrderRecipeData(inst)
	local product_prefab = GetFoodOrder(inst)
	
	if product_prefab == nil then
		print("[CookRobot] GetOrderRecipeData: product_prefab = nil")
		return nil
    end

	for cooker_type, station_prefab in pairs(TUNING.KYNO_COOK_ROBOT_COOKINGPOTS) do
		print("[CookRobot] trying cooker_type:", cooker_type)
		
		if cooker_type == "cookpot" then
			local recipes = cooking.recipes[cooker_type]
			print("[CookRobot] recipes table:", recipes ~= nil)
			
			local recipe = recipes and recipes[product_prefab]
			print("[CookRobot] recipe found:", recipe ~= nil)
			
			if recipe ~= nil then
				print("[CookRobot] VALID COOKING RECIPE FOUND")
				return 
				{
					system          = "cooking",
					cooker_type     = cooker_type,
					station_prefab  = station_prefab,
					recipe          = recipe,
					product         = product_prefab,
					maxslots        = 4,
				}
			end
		elseif brewing and brewing.recipes and brewing.recipes[cooker_type] then
			local recipes = brewing.recipes[cooker_type]
			print("[CookRobot] recipes table:", recipes ~= nil)
			
			local recipe = recipes and recipes[product_prefab]
			print("[CookRobot] recipe found:", recipe ~= nil)
			
			if recipe ~= nil then
				print("[CookRobot] VALID BREWING RECIPE FOUND")
				return 
				{
					system          = "brewing",
					cooker_type     = cooker_type,
					station_prefab  = station_prefab,
					recipe          = recipe,
					product         = product_prefab,
					maxslots        = 3,
				}
			end
		end
	end

	print("[CookRobot] ❌ No recipe matched for", food.prefab)
	return nil
end

local function HasValidOrder(inst)
	local valid = GetOrderRecipeData(inst) ~= nil
	print("[CookRobot] HasValidOrder:", valid)
	return valid
end

local function IsCookerAvailable(inst, cooker)
	if cooker == nil or not cooker:IsValid() or cooker.components.container == nil then
		return false
	end

	local container = cooker.components.container

	if cooker:HasTag("burnt") then
		return false
	end
	
	if cooker:HasTag("cook_robot_reserved") and cooker._cook_robot_reserved_by ~= inst then
		return false
	end

	if cooker:GetCurrentPlatform() ~= inst:GetCurrentPlatform() then
		return false
	end

	if not container:IsEmpty() then
		return false
	end

	if container:IsOpenedByOthers(inst) then
		return false
	end
	
	if cooker.components.stewer ~= nil then
		if cooker.components.stewer:IsCooking() or cooker.components.stewer:IsDone() then
			return false
		end
	end

	if cooker.components.brewer ~= nil then
		if cooker.components.brewer:IsCooking() or cooker.components.brewer:IsDone() then
			return false
		end
	end
	
	--[[
	if container:IsOpen() then
		return false
	end
	]]--

	return true
end

local function FindUsableCooker(inst)
	local cooker = CookRobotCommon.FindNearestAvailableCooker(inst, IsCookerAvailable)
	
	if cooker == nil then
		print("[CookRobot] No cooker found nearby")
		return nil
	end

	if cooker ~= nil then
		print("[CookRobot] Found cooker:", cooker.prefab)
		print("[CookRobot] Cooker is AVAILABLE:", cooker.prefab)
	end

	return cooker
end

local ReleaseCooker

local function BindCookingCallbacks(inst, cooker)
	if cooker == nil or not cooker:IsValid() then
		return
	end

	if cooker.components.stewer ~= nil then
		local stewer = cooker.components.stewer

		inst._old_onstartcooking = stewer.onstartcooking

		stewer.onstartcooking = function(cooker_inst)
			if inst._old_onstartcooking ~= nil then
				inst._old_onstartcooking(cooker_inst)
			end

			ReleaseCooker(inst)
		end
	end

	if cooker.components.brewer ~= nil then
		local brewer = cooker.components.brewer

		inst._old_onstartbrewing = brewer.onstartcooking

		brewer.onstartcooking = function(cooker_inst)
			if inst._old_onstartbrewing ~= nil then
				inst._old_onstartbrewing(cooker_inst)
			end

			ReleaseCooker(inst)
		end
	end
end

local function UnbindCookingCallbacks(inst, cooker)
	if cooker == nil or not cooker:IsValid() then
		return
	end

	if cooker.components.stewer ~= nil then
		cooker.components.stewer.onstartcooking = inst._old_onstartcooking
		inst._old_onstartcooking = nil
	end

	if cooker.components.brewer ~= nil then
		cooker.components.brewer.onstartcooking = inst._old_onstartbrewing
		inst._old_onstartbrewing = nil
	end
end

ReleaseCooker = function(inst)
	if inst._targetcooker ~= nil and inst._targetcooker:IsValid() then
		UnbindCookingCallbacks(inst, inst._targetcooker)

		inst._targetcooker._cook_robot_reserved_by = nil
		inst._targetcooker:RemoveTag("cook_robot_reserved")
	end

	inst._targetcooker = nil
	inst._cooktask = nil
	
	if inst._pending_foodorder ~= nil then
		print("[CookRobot] Switching to pending order:", inst._pending_foodorder)
		inst._foodorder_prefab = inst._pending_foodorder
		inst._pending_foodorder = nil
	end
end

local function EnsureTargetCooker(inst)
	if inst._targetcooker ~= nil and IsCookerAvailable(inst, inst._targetcooker) then
		print("[CookRobot] Reusing existing cooker")
		return true
	end

	local cooker = FindUsableCooker(inst)
	
	if cooker ~= nil then
		inst._targetcooker = cooker

		cooker._cook_robot_reserved_by = inst
		cooker:AddTag("cook_robot_reserved")

		print("[CookRobot] Cooker reserved:", cooker.prefab)
		BindCookingCallbacks(inst, cooker)

		return true
	end

	print("[CookRobot] No valid cooker available")

	inst._targetcooker = nil
	inst._returning_items = true
	
	return false
end

local function TestCombination(orderdata, combo)
	if orderdata.system == "cooking" then
		return cooking.CalculateRecipe(orderdata.cooker_type, combo)
	else
		return brewing.CalculateBrewing(orderdata.cooker_type, combo)
	end
end

local function FindValidIngredientsToCook(orderdata, ingredients)
	local maxslots = orderdata.maxslots
	local n = #ingredients

	local function testcombos(start, combo)
		local product = TestCombination(orderdata, combo)
		
		if product == orderdata.product then
			return combo
		end

		if #combo == maxslots then
			return nil
		end

		for i = start, n do
			table.insert(combo, ingredients[i])

			local result = testcombos(i + 1, combo)
			
			if result ~= nil then
				return result
			end

			table.remove(combo)
		end

		return nil
	end

	return testcombos(1, {})
end

local function FindValidIngredientsToFill(orderdata, base, available)
	local chosen = shallowcopy(base)

	while #chosen < orderdata.maxslots do
		local added = false

		for _, prefab in ipairs(available) do
			table.insert(chosen, prefab)

			local product
			
			if orderdata.system == "cooking" then
				product = cooking.CalculateRecipe(orderdata.cooker_type, chosen)
			else
				product = brewing.CalculateBrewing(orderdata.cooker_type, chosen)
			end

			if product == orderdata.product then
				added = true
				break
			else
				table.remove(chosen)
			end
		end

		if not added then
			return nil
		end
	end

	return chosen
end

local function CollectAvailableIngredients(inst, orderdata)
	local available = {}
	
	print("[CookRobot] Collecting ingredients for:", orderdata.product)

	local x, y, z = CookRobotCommon.GetSpawnPoint(inst):Get()
	local ents = TheSim:FindEntities(x, y, z, TUNING.KYNO_COOK_ROBOT_WORK_RADIUS, nil, CookRobotCommon.CONTAINER_CANT_TAGS, CookRobotCommon.CONTAINER_MUST_ONEOF_TAGS)
	
	print("[CookRobot] Containers found:", #ents)

	for _, container in ipairs(ents) do
		if container.components.container ~= nil -- and not container.components.container:IsOpenedByOthers(inst)
		and container:GetCurrentPlatform() == inst:GetCurrentPlatform() then
			for _, item in pairs(container.components.container.slots) do
				if orderdata.system == "cooking" then
					if cooking.IsCookingIngredient(item.prefab) then
						table.insert(available, item.prefab)
					end
				else
					if brewing.IsBrewingIngredient(item.prefab) then
						table.insert(available, item.prefab)
					end
				end
			end
		end
	end
	
	print("[CookRobot] Available ingredients:", table.concat(available, ", "))

	return available
end

local function ResolveIngredientsForOrder(inst, orderdata)
	local available = CollectAvailableIngredients(inst, orderdata)
	
	if available == nil or #available == 0 then
		print("[CookRobot] No available ingredients")
		return nil
	end

	local base = FindValidIngredientsToCook(orderdata, available)
	
	if base == nil then
		print("[CookRobot] No valid ingredient combination")
		return nil
	end

	print("[CookRobot] Base combo:", table.concat(base, ", "))
	return FindValidIngredientsToFill(orderdata, base, available)
end

local function FindAllIngredientInstances(inst, ingredient_list)
	local result = {}
	local needed = {}

	for _, prefab in ipairs(ingredient_list) do
		needed[prefab] = (needed[prefab] or 0) + 1
	end

	local x, y, z = CookRobotCommon.GetSpawnPoint(inst):Get()
	local containers = TheSim:FindEntities(x, y, z, TUNING.KYNO_COOK_ROBOT_WORK_RADIUS, nil, CookRobotCommon.CONTAINER_CANT_TAGS, CookRobotCommon.CONTAINER_MUST_ONEOF_TAGS)

	for prefab, count in pairs(needed) do
		local remaining = count

		for _, container in ipairs(containers) do
			if remaining <= 0 then
				break
			end

			local c = container.components.container
			
			if c ~= nil and --[[ not c:IsOpenedByOthers(inst) and ]] container:GetCurrentPlatform() == inst:GetCurrentPlatform() then
				c:ForEachItem(function(item)
					if remaining <= 0 then
						return
					end
					
					if item.prefab == prefab then
						local stack = item.components.stackable
						local stacksize = stack and stack:StackSize() or 1
						local take = math.min(stacksize, remaining)

						table.insert(result, 
						{
							container = container,
							item      = item,
							count     = take,
						})

						remaining = remaining - take
					end
				end)
			end
		end

		if remaining > 0 then
			print("[CookRobot] Missing ingredient:", prefab)
			return nil
		end
	end

	return result
end

local function InitCookTaskAction(inst)
	if inst._cooktask ~= nil then
		return nil
	end

	if not HasValidOrder(inst) then
		return nil
	end

	if not EnsureTargetCooker(inst) then
		return nil
	end

	local orderdata = GetOrderRecipeData(inst)
	
	if orderdata == nil then
		return nil
	end

	local ingredients = ResolveIngredientsForOrder(inst, orderdata)
	
	if ingredients == nil then
		inst._returning_items = true
		return nil
	end
	
	local queue = FindAllIngredientInstances(inst, ingredients)

	if queue == nil then
		inst._returning_items = true
		return nil
	end

	inst._cooktask =
	{
		state             = "take_item", -- open_container
		orderdata         = orderdata,
		ingredients       = ingredients,
		cooker            = inst._targetcooker,
		queue             = queue,
	}

	return nil
end

local function OpenContainerAction(inst)
	local task = inst._cooktask
	
	if task == nil or task.state ~= "open_container" then
		return nil
	end

	local entry = task.queue and task.queue[1]
	
	if entry == nil then
		task.state = "take_item"
		return nil
	end

	local container = entry.container

	if container == nil or not container:IsValid() then
		table.remove(task.queue, 1)
		return nil
	end

	local cooker = container.components.container
	
	if cooker == nil then
		table.remove(task.queue, 1)
		return nil
	end

	if not task._opened then
		print("[CookRobot] Opening container:", container.prefab)
		task._opened = true
		task.state = "take_item"
		
		return BufferedAction(inst, container, ACTIONS.RUMMAGE)
	end
	
	return nil
end

local function CollectAllIngredientsAction(inst)
	local task = inst._cooktask
	
	if task == nil or task.state ~= "take_item" then
		return nil
	end
	
	inst:PushEvent("cookrobot_start")
	
	local entry = task.queue[1]
	
	if entry == nil then
		print("[CookRobot] All ingredients collected")
		task.state = "insert_all"
		return nil
	end

	if inst.components.inventory:IsFull() then
		print("[CookRobot] Inventory is full")
		task.state = "fail"
		inst._returning_items = true
		return nil
	end

	local container = entry.container
	local item = entry.item

	if container ~= nil and item ~= nil then
		inst.brain:IgnoreItem(item)

		print("[CookRobot] Taking from container:", item.prefab)
		
		entry.count = entry.count - 1
		
		if entry.count <= 0 then
			table.remove(task.queue, 1)
		end

		return BufferedAction(inst, container, ACTIONS.TAKEFROMCONTAINER, item)
	end
	
	table.remove(task.queue, 1)
	return nil
end

local function InsertAllIngredientsAction(inst)
	local task = inst._cooktask
	
	if task == nil or task.state ~= "insert_all" then
		return nil
	end

	if task.cooker.components.container:IsOpenedByOthers(inst) then
		task.state = "fail"
		inst._returning_items = true
		return nil
	end

	local item = inst.components.inventory:GetFirstItemInAnySlot()
	
	if item == nil then
		task.state = "cook"
		return nil
	end

	return BufferedAction(inst, task.cooker, ACTIONS.STORE, item)
end

local function CookAction(inst)
	local task = inst._cooktask

	if task == nil or task.state ~= "cook" then
		return nil
	end

	if not task.cooker or not task.cooker:IsValid() then
		task.state = "fail"
		inst._returning_items = true
		return nil
	end

	local action = task.orderdata.system == "cooking" and ACTIONS.COOK or ACTIONS.BREWER

	return BufferedAction(inst, task.cooker, action)
end

local function StoreItemAction(inst)
	if not inst._returning_items then
		return nil
	end
	
	if inst.LOW_BATTERY_GOHOME and inst.components.fueled:GetPercent() < TUNING.WINONA_STORAGE_ROBOT_LOW_FUEL_PCT 
	and CookRobotCommon.GetSpawnPoint(inst) then
		return
	end

	local item = inst.components.inventory:GetFirstItemInAnySlot() or inst.components.inventory:GetActiveItem()

	if item == nil then
		inst._returning_items = false
		inst._cooktask = nil
		return nil
	end

	inst.brain:UnignoreItem()

	local container = CookRobotCommon.FindContainerWithItem(inst, item)
	
	if container ~= nil then
		return BufferedAction(inst, container, ACTIONS.STORE, item)
	else
		inst._returning_items = false
		return nil
	end
end

local function GoHomeAction(inst)
	local pos = CookRobotCommon.GetSpawnPoint(inst)

	if pos == nil then
		return
	end

	inst.brain:UnignoreItem()

	local item = inst.components.inventory:GetFirstItemInAnySlot() or inst.components.inventory:GetActiveItem()

	if item ~= nil then
		inst.components.inventory:DropItem(item, true, true)
	end

	if inst:GetDistanceSqToPoint(pos) < 0.25 then
		return
	end
	
	inst:PushEvent("cookrobot_stop")
	
	return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, pos, nil, 0.2)
end

function CookRobotBrain:OnStart()
	local root = PriorityNode(
	{
		WhileNode(function()
			return not self.inst.sg:HasAnyStateTag("busy", "broken") and HasFoodOrder(self.inst)
		end, "No Brain when Busy or Broken",
			PriorityNode({
				DoAction(self.inst, InitCookTaskAction,          "Init Cook Task",          true),
			 -- DoAction(self.inst, OpenContainerAction,         "Open Container",          true),
				DoAction(self.inst, CollectAllIngredientsAction, "Collect All Ingredients", true),
				DoAction(self.inst, InsertAllIngredientsAction,  "Insert All Ingredients",  true),
				DoAction(self.inst, CookAction,                  "Cook / Brew",             true),
				DoAction(self.inst, StoreItemAction,             "Store Item",              true), -- Store Item is for when failing to cook something.
				DoAction(self.inst, GoHomeAction,                "Return to Spawn",         true),
				ParallelNode{
					StandStill(self.inst),
					SequenceNode{
						ParallelNodeAny{
							WaitNode(6),
							ConditionWaitNode(function()
								return self.inst.LOW_BATTERY_GOHOME and self.inst.components.fueled:GetPercent() < TUNING.WINONA_STORAGE_ROBOT_LOW_FUEL_PCT
							end),
						},
						ActionNode(function()
							self.inst:PushEvent("sleepmode")
						end),
					},
				},
			}, .25)
		),
	}, .25)

	self.bt = BT(self.inst, root)
end

function CookRobotBrain:OnStop()
	self:UnignoreItem()
	
	if self.inst._targetcooker ~= nil then
		self.inst._targetcooker._cook_robot_reserved_by = nil
		self.inst._targetcooker:RemoveTag("cook_robot_reserved")
		self.inst._targetcooker = nil
	end
end

function CookRobotBrain:OnInitializationComplete()
	CookRobotCommon.UpdateSpawnPoint(self.inst, true)
end

return CookRobotBrain