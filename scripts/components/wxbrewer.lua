local brewing = require("hof_brewing")

local function SpawnBrewingFX(self)
	if self.brewing_fx ~= nil then
		return
	end

	if not self:IsBrewing() then
		return
	end

	local fx = SpawnPrefab("kyno_brewingbubbles_fx")

	if fx ~= nil then
		self.brewing_fx = fx
		local target = self.inst._brewer_owner

		if target ~= nil then
			fx.entity:SetParent(target.entity)
			fx.Transform:SetPosition(0, 0, 0)
			fx.AnimState:SetFinalOffset(5)
		end
	end
end

local function RemoveBrewingFX(self)
	local fx = self.brewing_fx

	if fx ~= nil then
		self.brewing_fx = nil

		if fx:IsValid() then
			fx.AnimState:PlayAnimation("level1_pst")
			fx:ListenForEvent("animover", fx.Remove)
		else
			fx:Remove()
		end
	end
end

local function OnDone(self, done)
	if done then
		self.inst:AddTag("donebrewing")
	else
		self.inst:RemoveTag("donebrewing")
	end
end

local function OnCheckReady(inst)
	if inst.components.container ~= nil
		and not inst.components.container:IsOpen()
		and inst.components.container:IsFull() then

		inst:AddTag("readytobrew")
	end
end

local function OnNotReady(inst)
	inst:RemoveTag("readytobrew")
end

local function DoBrew(inst, self)
	self.task = nil
	self.targettime = nil
	self.remainingtime = nil
	self.paused = false
	self.done = true

	local wx = self.inst._brewer_owner

	RemoveBrewingFX(self)

	local product = self.product
	local harvester = self.harvester
	local chef_id = self.chef_id
	local ingredient_prefabs = self.ingredient_prefabs
	local recipe = product ~= nil and brewing.GetBrewing(inst.prefab, product) or nil

	self.pending_product = product
	self.pending_harvester = harvester
	self.pending_chef_id = chef_id
	self.pending_ingredient_prefabs = ingredient_prefabs

	self.product = nil
	self.harvester = nil
	self.chef_id = nil
	self.ingredient_prefabs = nil
	self.done = nil

	if inst.components.container ~= nil then
		inst.components.container.canbeopened = true
	end

	-- if product ~= nil and harvester ~= nil and harvester.sg ~= nil then
	if product ~= nil and wx ~= nil and wx.sg ~= nil then
		wx.sg:GoToState("wx_brew",
		{
			product            = product,
			harvester          = wx,
			recipe             = recipe,
			chef_id            = chef_id,
			ingredient_prefabs = ingredient_prefabs,
		})
	end

	if wx ~= nil and wx.components.health ~= nil and not wx.components.health:IsDead() then
		wx:PushEvent("wx78brewer_done")
	end
end

local function CreateBrewTask(self, remainingtime)
	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end

	self.task = self.inst:DoTaskInTime(remainingtime, DoBrew, self)
end

local WXBrewer = Class(function(self, inst)
	self.inst = inst

	self.done = nil
	self.targettime = nil
	self.remainingtime = nil
	self.task = nil
	self.product = nil
	self.brewtimemult = 1
	self.paused = false

	self.chef_id = nil
	self.ingredient_prefabs = nil

	self.harvester = nil

	self.pending_product = nil
	self.pending_harvester = nil
	self.pending_chef_id = nil
	self.pending_ingredient_prefabs = nil

	inst:ListenForEvent("itemget", OnCheckReady)
	inst:ListenForEvent("onclose", OnCheckReady)

	inst:ListenForEvent("itemlose", OnNotReady)
	inst:ListenForEvent("onopen", OnNotReady)

	inst:AddTag("wxbrewer")
end,
nil,
{
	done = OnDone,
})

function WXBrewer:OnRemoveFromEntity()
	local wx = self.inst._brewer_owner

	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end

	self.inst:RemoveTag("wxbrewer")
	self.inst:RemoveTag("donebrewing")
	self.inst:RemoveTag("readytobrew")

	RemoveBrewingFX(self)

	if wx ~= nil then
		wx:RemoveTag("wx_brewing")
	end
end

function WXBrewer:IsDone()
	return self.done == true
end

function WXBrewer:IsBrewing()
	return not self.done and not self.paused and self.targettime ~= nil
end

function WXBrewer:IsPaused()
	return self.paused == true and self.product ~= nil
end

function WXBrewer:GetTimeToBrew()
	if self.paused then
		return self.remainingtime or 0
	end

	return not self.done and self.targettime ~= nil and math.max(0, self.targettime - GetTime()) or 0
end

function WXBrewer:CanBrew()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function WXBrewer:GetRecipeForProduct()
	return self.product ~= nil and brewing.GetBrewing(self.inst.prefab, self.product) or nil
end

function WXBrewer:StartBrewing(doer)
	local wx = self.inst._brewer_owner

	if self.targettime ~= nil or self.paused then
		return false
	end

	if self.inst.components.container == nil then
		return false
	end

	if not self.inst.components.container:IsFull() then
		return false
	end

	if wx == nil or not wx:IsValid() then
		return false
	end

	if wx:HasTag("wx_brewing") then
		return false
	end

	self.chef_id = (doer ~= nil and doer.player_classified ~= nil) and doer.userid or nil
	self.ingredient_prefabs = {}
	self.done = nil
	self.paused = false
	self.remainingtime = nil
	self.harvester = doer

	for _, item in pairs(self.inst.components.container.slots) do
		if item ~= nil then
			table.insert(self.ingredient_prefabs, item.prefab)
		end
	end

	local brewtime = 1

	self.product, brewtime = brewing.CalculateBrewing(self.inst.prefab, self.ingredient_prefabs)

	if self.product == nil then
		self.ingredient_prefabs = nil
		self.harvester = nil
		self.chef_id = nil

		return false
	end

	self.inst.components.container:Close()
	self.inst.components.container:DestroyContents()
	self.inst.components.container.canbeopened = false

	wx:AddTag("wx_brewing")

	if self.onstartbrewing ~= nil then
		self.onstartbrewing(self.inst)
	end

	brewtime = TUNING.BASE_COOK_TIME * brewtime * self.brewtimemult

	self.remainingtime = brewtime
	self.targettime = GetTime() + brewtime

	if self.task ~= nil then
		self.task:Cancel()
	end

	CreateBrewTask(self, brewtime)

	if wx ~= nil and wx.components.health ~= nil and not wx.components.health:IsDead() then
		wx:PushEvent("wx78brewer_start")
	end

	SpawnBrewingFX(self)

	return true
end

function WXBrewer:PauseBrewing()
	local wx = self.inst._brewer_owner

	if self.done or self.product == nil then
		return false
	end

	if self.paused then
		return true
	end

	if self.targettime == nil then
		return false
	end

	self.remainingtime = math.max(0, self.targettime - GetTime())
	self.targettime = nil
	self.paused = true

	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end

	RemoveBrewingFX(self)

	if wx ~= nil and wx.components.health ~= nil and not wx.components.health:IsDead() then
		wx:PushEvent("wx78brewer_pause")
	end

	return true
end

function WXBrewer:ResumeBrewing()
	local wx = self.inst._brewer_owner

	if self.done or self.product == nil then
		return false
	end

	if not self.paused then
		return false
	end

	if wx == nil or not wx:IsValid() then
		return false
	end

	if wx.components.upgrademoduleowner ~= nil and wx.components.upgrademoduleowner:IsChargeEmpty() then
		return false
	end

	local remainingtime = math.max(0, self.remainingtime or 0)

	self.paused = false
	self.targettime = GetTime() + remainingtime

	if self.task ~= nil then
		self.task:Cancel()
	end

	CreateBrewTask(self, remainingtime)

	wx:AddTag("wx_brewing")

	if self.oncontinuebrewing ~= nil then
		self.oncontinuebrewing(self.inst)
	end

	if wx ~= nil and wx.components.health ~= nil and not wx.components.health:IsDead() then
		wx:PushEvent("wx78brewer_resume")
	end

	SpawnBrewingFX(self)

	return true
end

function WXBrewer:CancelBrewing()
	local wx = self.inst._brewer_owner

	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end

	RemoveBrewingFX(self)

	self.targettime = nil
	self.remainingtime = nil
	self.product = nil
	self.done = nil
	self.paused = false

	self.chef_id = nil
	self.ingredient_prefabs = nil
	self.harvester = nil

	if wx ~= nil then
		wx:RemoveTag("wx_brewing")
	end

	if self.inst.components.container ~= nil then
		self.inst.components.container.canbeopened = true
	end

	self.inst:RemoveTag("donebrewing")
	self.inst:RemoveTag("readytobrew")

	if wx ~= nil and wx.components.health ~= nil and not wx.components.health:IsDead() then
		wx:PushEvent("wx78brewer_cancel")
	end

	return true
end

function WXBrewer:ClearPendingBrew()
	self.pending_product = nil
	self.pending_harvester = nil
	self.pending_chef_id = nil
	self.pending_ingredient_prefabs = nil
end

function WXBrewer:OnSave()
	local remainingtime = nil

	if self.paused then
		remainingtime = self.remainingtime
	elseif self.targettime ~= nil then
		remainingtime = math.max(0, self.targettime - GetTime())
	end

	local data =
	{
		product            = self.product,
		remainingtime      = remainingtime,
		paused             = self.paused,
		done               = self.done,
		chef_id            = self.chef_id,
		ingredient_prefabs = self.ingredient_prefabs,
	}

	return data
end

function WXBrewer:OnLoadData(data)
	local wx = self.inst._brewer_owner

	if data == nil or data.product == nil then
		return
	end

	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end

	self.product = data.product
	self.remainingtime = data.remainingtime
	self.paused = data.paused == true
	self.done = data.done == true

	self.chef_id = data.chef_id
	self.ingredient_prefabs = data.ingredient_prefabs
	self.harvester = self.inst._brewer_owner

	self.targettime = nil

	if self.done then
		return
	end

	if self.paused then
		if wx ~= nil then
			wx:AddTag("wx_brewing")
		end

		RemoveBrewingFX(self)

		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = false
		end

		return
	end

	if self.remainingtime ~= nil then
		self.targettime = GetTime() + math.max(0, self.remainingtime)

		if wx ~= nil then
			wx:AddTag("wx_brewing")
		end

		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = false
		end

		CreateBrewTask(self, math.max(0, self.remainingtime))

		if self.oncontinuebrewing ~= nil then
			self.oncontinuebrewing(self.inst)
		end

		SpawnBrewingFX(self)
	end
end

function WXBrewer:OnLoad(data)
	if data == nil or data.product == nil then
		return
	end

	self:OnLoadData(data)
end

function WXBrewer:LongUpdate(dt)
	if not self:IsBrewing() then
		return
	end

	local remaining = math.max(0, self.targettime - GetTime())

	if remaining > dt then
		self.remainingtime = remaining
		CreateBrewTask(self, remaining)
	else
		DoBrew(self.inst, self)
	end
end

function WXBrewer:GetDebugString()
	local status

	if self.paused then
		status = "PAUSED"
	elseif self:IsBrewing() then
		status = "BREWING"
	elseif self:IsDone() then
		status = "DONE"
	else
		status = "EMPTY"
	end

	return string.format("%s %s timetobrew: %.2f", self.product or "NONE", status, self:GetTimeToBrew())
end

return WXBrewer