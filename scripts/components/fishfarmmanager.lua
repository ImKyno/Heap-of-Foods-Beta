local FishFarmManager = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("fishhatchery")

	self._roe_task = nil
	self._baby_task = nil

	self.onstartfn = nil
	self.onstopfn = nil
	self.onworkfn = nil
	
	self.slot_start = 3
	self.slot_end = 11
	
	self.consumefuel_roe = 5
	self.consumefuel_baby = 15
end)

function FishFarmManager:SetStartWorkingFn(fn)
	self.onstartfn = fn
end

function FishFarmManager:SetStopWorkingFn(fn)
	self.onstopfn = fn
end

function FishFarmManager:SetWorkingFn(fn)
	self.onworkfn = fn
end

function FishFarmManager:SetSlotStart(value)
	self.slot_start = value or 3
end

function FishFarmManager:SetSlotEnd(value)
	self.slot_end = value or 11
end

function FishFarmManager:SetRoeConsumption(value)
	self.consumefuel_roe = value or 5
end

function FishFarmManager:SetBabyConsumption(value)
	self.consumefuel_baby = value or 15
end

function FishFarmManager:StopWorking()
	if self._roe_task then
		self._roe_task:Cancel()
		self._roe_task = nil
	end
	
	if self._baby_task then
		self._baby_task:Cancel()
		self._baby_task = nil
	end

	if self.onstopfn then
		self.onstopfn(self.inst)
	end
end

function FishFarmManager:ProduceRoe()
	local inst = self.inst
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil or container == nil or fueled:IsEmpty() then
		self:StopWorking()
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent.components.fishfarmable
	
	if fish_parent == nil or fish_parent.components.fishfarmable == nil then
		self:StopWorking()
		return
	end
	
	if not fishfarmable:IsSeasonValid() then
		return
	end

	local roe_prefab = fish_parent.components.fishfarmable:GetRoePrefab()
	
	if roe_prefab == nil then
		self:StopWorking()
		return
	end

	local roeitem = container:GetItemInSlot(2)
	
	if roeitem ~= nil and roeitem.prefab == roe_prefab and roeitem.components.stackable ~= nil then
		local size = roeitem.components.stackable:StackSize()
		local max = roeitem.components.stackable.maxsize
		
		if size < max then
			roeitem.components.stackable:SetStackSize(size + 1)
			fueled:DoDelta(-self.consumefuel_roe)
		end
	elseif roeitem == nil then
		local roe = SpawnPrefab(roe_prefab)
		
		if roe ~= nil then
			-- local pos = inst:GetPosition()
			local pos = Vector3(inst.Transform:GetWorldPosition())
			roe.Transform:SetPosition(pos.x, pos.y, pos.z)
            
			if container:GiveItem(roe, 2, pos) then
				fueled:DoDelta(-self.consumefuel_roe)
			else
				roe:Remove()
			end
		end
	end
	
	if self.onworkfn then
		self.onworkfn(inst)
	end
end

function FishFarmManager:ProduceBaby()
	local inst = self.inst
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil or container == nil or fueled:IsEmpty() then
		self:StopWorking()
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent.components.fishfarmable
	
	if fish_parent == nil or fish_parent.components.fishfarmable == nil then
		self:StopWorking()
		return
	end
	
	if not fishfarmable:IsSeasonValid() then
		return
	end

	local baby_prefab = fish_parent.components.fishfarmable:GetBabyPrefab()
	
	if baby_prefab == nil then
		self:StopWorking()
		return
    end

	for i = self.slot_start, self.slot_end do
		if container:GetItemInSlot(i) == nil then
			local baby = SpawnPrefab(baby_prefab)
			
			if baby ~= nil then
				-- local pos = inst:GetPosition()
				local pos = Vector3(inst.Transform:GetWorldPosition())
				baby.Transform:SetPosition(pos.x, pos.y, pos.z)
				
				if container:GiveItem(baby, i, pos) then
					fueled:DoDelta(-self.consumefuel_baby)
				else
					baby:Remove()
				end
			end
			
			return
		end
	end
	
	if self.onworkfn then
		self.onworkfn(inst)
	end
end

function FishFarmManager:StartWorking()
	local inst = self.inst
	local container = inst.components.container
	local fish_parent = container:GetItemInSlot(1)

	if fish_parent == nil or fish_parent.components.fishfarmable == nil then
		return
	end

	local fishfarmable = fish_parent.components.fishfarmable

	self:StopWorking()

	self._roe_task = inst:DoPeriodicTask(fishfarmable:GetRoeTime(), function() 
		self:ProduceRoe() 
	end)
	
	self._baby_task = inst:DoPeriodicTask(fishfarmable:GetBabyTime(), function() 
		self:ProduceBaby() 
	end)

	if self.onstartfn then
		self.onstartfn(inst)
	end
end

function FishFarmManager:OnAddFuel()
	local container = self.inst.components.container
	local fish_parent = container:GetItemInSlot(1)
	
	if fish_parent == nil or fish_parent.components.fishfarmable == nil then
		self:StopWorking()
		return
	else
		self.inst.components.fueled:StartConsuming()
		self:StartWorking()
	end
end

function FishFarmManager:OnFuelEmpty()
	self:StopWorking()
end

function FishFarmManager:LongUpdate(dt)
	local inst = self.inst
	local container = inst.components.container
	local fueled = inst.components.fueled

	if not container or not fueled or fueled:IsEmpty() then
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	
	if not fish_parent or not fish_parent.components.fishfarmable then
		return
	end

	local farmable = fish_parent.components.fishfarmable
	local roe_interval = farmable:GetRoeTime()
	local baby_interval = farmable:GetBabyTime()

	if roe_interval > 0 then
		local roe_cycles = math.floor(dt / roe_interval)
		
		for i = 1, roe_cycles do
			if fueled:IsEmpty() then
				break
			end
			
			self:ProduceRoe()
		end
	end

	if baby_interval > 0 then
		local baby_cycles = math.floor(dt / baby_interval)
		
		for i = 1, baby_cycles do
			if fueled:IsEmpty() then
				break
			end
			
			self:ProduceBaby()
		end
	end
end

return FishFarmManager