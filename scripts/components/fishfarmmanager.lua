local FishFarmManager = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("fishhatchery")

	self._roe_task = nil
	self._baby_task = nil
	
	self.roe_time_left = 0
	self.baby_time_left = 0

	self.onstartfn = nil
	self.onstopfn = nil
	self.onworkfn = nil
	
	self.slot_start = TUNING.KYNO_FISHFARMLAKE_SLOT_START
	self.slot_end = TUNING.KYNO_FISHFARMLAKE_SLOT_END
	
	self.consumefuel_roe = TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION
	self.consumefuel_baby = TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION
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
	self.slot_start = value or TUNING.KYNO_FISHFARMLAKE_SLOT_START
end

function FishFarmManager:SetSlotEnd(value)
	self.slot_end = value or TUNING.KYNO_FISHFARMLAKE_SLOT_END
end

function FishFarmManager:SetRoeConsumption(value)
	self.consumefuel_roe = value or TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION
end

function FishFarmManager:SetBabyConsumption(value)
	self.consumefuel_baby = value or TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION
end

function FishFarmManager:StopWorking()
	if self._time_left_task then
		self._time_left_task:Cancel()
		self._time_left_task = nil
	end

	self.roe_time_left = nil
	self.baby_time_left = nil

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
	
	--[[
	if self.inst.components.fueled ~= nil then
		self.inst.components.fueled:StopConsuming()
	end
	]]--
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
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable
	
	if fish_parent == nil or fishfarmable == nil then
		self:StopWorking()
		return
	end
	
	if not fishfarmable:IsPhaseValid()
		or not fishfarmable:IsMoonPhaseValid()
		or not fishfarmable:IsSeasonValid()
		or not fishfarmable:IsWorldValid() then
		return
	end

	local roe_prefab = fishfarmable:GetRoePrefab()
	
	if roe_prefab == nil then
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
	
	self.roe_time_left = fishfarmable:GetRoeTime()
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
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable
	
	if fish_parent == nil or fishfarmable == nil then
		self:StopWorking()
		return
	end
	
	if not fishfarmable:IsPhaseValid()
		or not fishfarmable:IsMoonPhaseValid()
		or not fishfarmable:IsSeasonValid()
		or not fishfarmable:IsWorldValid() then
		return
	end

	local baby_prefab = fishfarmable:GetBabyPrefab()
	
	if baby_prefab == nil then
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
	
	self.baby_time_left = fishfarmable:GetBabyTime()
end

function FishFarmManager:StartWorking()
	local inst = self.inst
	local container = inst.components.container
	
	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fish_parent == nil or fishfarmable == nil then
		return
	end

	self:StopWorking()
	
	self.roe_time_left = fishfarmable:GetRoeTime()
	self.baby_time_left = fishfarmable:GetBabyTime()
	
	if self._time_left_task then
		self._time_left_task:Cancel()
	end

	self._time_left_task = inst:DoPeriodicTask(1, function()
		if self.roe_time_left then
			self.roe_time_left = math.max(0, self.roe_time_left - 1)
		end
		
		if self.baby_time_left then
			self.baby_time_left = math.max(0, self.baby_time_left - 1)
		end
	end)

	self._roe_task = inst:DoPeriodicTask(fishfarmable:GetRoeTime(), function() 
		self:ProduceRoe()
	end)
    
	self._baby_task = inst:DoPeriodicTask(fishfarmable:GetBabyTime(), function() 
		self:ProduceBaby()
	end)

	if self.onstartfn then
		self.onstartfn(inst)
	end
	
	-- Decided on not spending fuel when working only when something was produced.
	--[[
	if self.inst.components.fueled ~= nil then
		self.inst.components.fueled:StartConsuming()
	end
	]]--
end

function FishFarmManager:OnAddFuel()
	local container = self.inst.components.container
	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable
    
	if fish_parent == nil or fishfarmable == nil then
		self:StopWorking()
		return
	end

	self:StartWorking()
end

function FishFarmManager:OnFuelEmpty()
	self:StopWorking()
end

local function CheckFishValidity(self)
	local container = self.inst.components.container
	local fish_parent = container and container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if not fishfarmable then
		self:StopWorking()
		return
	end
end

function FishFarmManager:WatchWorldStates()
	self.inst:WatchWorldState("phase", function() 
		CheckFishValidity(self)
	end)
    
	self.inst:WatchWorldState("moonphase", function() 
		CheckFishValidity(self)
	end)
	
	self.inst:WatchWorldState("isalterawake", function() 
		CheckFishValidity(self)
	end)
    
	self.inst:WatchWorldState("season", function() 
		CheckFishValidity(self)
	end)
end

function FishFarmManager:LongUpdate(dt)
	local inst = self.inst
	local container = inst.components.container
	local fueled = inst.components.fueled

	if not container or not fueled or fueled:IsEmpty() then
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable
    
	if not fish_parent or not fishfarmable then
		return
	end

	local roe_interval = fishfarmable:GetRoeTime()
	local baby_interval = fishfarmable:GetBabyTime()

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

function FishFarmManager:GetDebugString()
	local inst      = self.inst
	local container = inst.components.container
	
	local fish_parent  = container:GetItemInSlot(1) or nil
	local fish_product = container:GetItemInSlot(2) or nil
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable
	
	if fish_parent == nil then
		print("-------------------------------------------------------")
		print("---- FishFarmManager Debug - Fish Status Checker   ----")
		print("No Main Fish Found!")
		print("-------------------------------------------------------")
		return
	end

	local fish = fish_parent and fish_parent.prefab or "Unknown Fish"
	local roe  = fishfarmable:GetRoePrefab() or "Unknown Roe"
	local baby = fishfarmable:GetBabyPrefab() or "Unknown Offspring"
	
	local roe_time_total  = fishfarmable:GetRoeTime() or nil
    local baby_time_total = fishfarmable:GetBabyTime() or nil

	local roe_time_left  = self.roe_time_left
	local baby_time_left = self.baby_time_left

	local phase     = fishfarmable:IsPhaseValid()
	local moonphase = fishfarmable:IsMoonPhaseValid()
	local season    = fishfarmable:IsSeasonValid()
	local world     = fishfarmable:IsWorldValid()
	
	local world_tag = (TheWorld:HasTag("cave") and "cave")
	or (TheWorld:HasTag("forest") and "forest")
	or "unknown (Possibly a modded world?)"
	
	print("-------------------------------------------------------")
	print("---- FishFarmManager Debug - Fish Checker Status   ----")
	print(" ")
	print("Main Fish:           ", fish)
	print("Roe:                 ", roe)
	print("Offspring:           ", baby)
	print(" ")
	
	if roe_time_total then
		print(string.format("Roe Timer:              Total Time = %.0fs | Time Left: %s", roe_time_total, roe_time_left and (roe_time_left.."s")
		or "No Roe Timer found!"))
	else
		print("This Fish does not produce any Roe!")
    end

	if baby_time_total then
		print(string.format("Offspring Timer:        Total Time = %.0fs | Time Left: %s", baby_time_total, baby_time_left and (baby_time_left.."s")
		or "No Offspring Timer found!"))
	else
		print("This Fish does not produce any Offspring!")
	end
	
	print("-------------------------------------------------------")
	print("---- FishFarmManager Debug - Fish Validity Checker ----")	
	print(" ")
	print("Phase Valid:         ", phase,        "(".. TheWorld.state.phase ..")")
	print("Moon Valid:          ", moonphase,    "(".. TheWorld.state.moonphase ..")")
	print("Season Valid:        ", season,       "(".. TheWorld.state.season ..")")
	print("World Valid:         ", world,        "(".. world_tag ..")")
	print(" ")
	
	local reasons = {}
	
	if not fish then
		table.insert(reasons, "No Main Fish found!")
	end

	if not phase then 
		table.insert(reasons, "Invalid Phase!")
	end
		
	if not moonphase then
		table.insert(reasons, "Invalid Moon Phase or World without a Moon!")
	end
		
	if not season then
		table.insert(reasons, "Invalid Season!")
	end
		
	if not world then
		table.insert(reasons, "Invalid World!")
	end
	
	if #reasons == 0 then
		print("Everything is Valid! Producing Roe and Offspring.")
	else
		print("Something is Invalid! Reasons: " .. table.concat(reasons, " | "))
	end

	print("-------------------------------------------------------")
end

function FishFarmManager:OnPostInit()
	self:WatchWorldStates()
end

return FishFarmManager