local FishFarmManager = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("fishhatchery")

	self._roe_task = nil
	self._baby_task = nil
	self._validity_task = nil

	-- Absolute time when the current timer will finish.
	self._roe_end_time = nil
	self._baby_end_time = nil

	-- Remaining time while paused/not running.
	self.roe_time_left = nil
	self.baby_time_left = nil

	self.onstartfn = nil
	self.onstopfn = nil
	self.onpausefn = nil
	self.onworkfn = nil

	self.slot_start = TUNING.KYNO_FISHFARMLAKE_SLOT_START
	self.slot_end = TUNING.KYNO_FISHFARMLAKE_SLOT_END

	self.consumefuel_roe = TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION
	self.consumefuel_baby = TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION

	self:WatchWorldStates()

	self._validity_task = inst:DoPeriodicTask(30, function()
		self:CheckInternalValidity()
	end)
end)

function FishFarmManager:SetStartWorkingFn(fn)
	self.onstartfn = fn
end

function FishFarmManager:SetStopWorkingFn(fn)
	self.onstopfn = fn
end

function FishFarmManager:SetPauseWorkingFn(fn)
	self.onpausefn = fn
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

function FishFarmManager:GetFishFarmable()
	local container = self.inst.components.container

	if container == nil then
		return nil
	end

	local fish_parent = container:GetItemInSlot(1)

	if fish_parent == nil then
		return nil
	end

	return fish_parent.components.fishfarmable
end

function FishFarmManager:IsFishValid()
	local fishfarmable = self:GetFishFarmable()

	if fishfarmable == nil then
		return false
	end

	return fishfarmable:IsPhaseValid()
	and fishfarmable:IsMoonPhaseValid()
	and fishfarmable:IsSeasonValid()
	and fishfarmable:IsWorldValid()
end

function FishFarmManager:UpdateRemainingTimes()
	local now = GetTime()

	if self._roe_task ~= nil and self._roe_end_time ~= nil then
		self.roe_time_left = math.max(0, self._roe_end_time - now)
	end

	if self._baby_task ~= nil and self._baby_end_time ~= nil then
		self.baby_time_left = math.max(0, self._baby_end_time - now)
	end
end

function FishFarmManager:CancelRoeTask()
	if self._roe_task ~= nil then
		self._roe_task:Cancel()
		self._roe_task = nil
	end

	self._roe_end_time = nil
end

function FishFarmManager:CancelBabyTask()
	if self._baby_task ~= nil then
		self._baby_task:Cancel()
		self._baby_task = nil
	end

	self._baby_end_time = nil
end

function FishFarmManager:CancelValidityTask()
	if self._validity_task ~= nil then
		self._validity_task:Cancel()
		self._validity_task = nil
	end
end

function FishFarmManager:StartRoeTimer()
	if self._roe_task ~= nil then
		return
	end

	if self.roe_time_left == nil then
		local fishfarmable = self:GetFishFarmable()

		if fishfarmable == nil then
			return
		end

		self.roe_time_left = fishfarmable:GetRoeTime()
	end

	local time = math.max(0, self.roe_time_left)

	self._roe_end_time = GetTime() + time

	self._roe_task = self.inst:DoTaskInTime(time, function()
		self._roe_task = nil
		self._roe_end_time = nil

		self.roe_time_left = 0

		self:ProduceRoe()
	end)
end

function FishFarmManager:StartBabyTimer()
	if self._baby_task ~= nil then
		return
	end

	if self.baby_time_left == nil then
		local fishfarmable = self:GetFishFarmable()

		if fishfarmable == nil then
			return
		end

		self.baby_time_left = fishfarmable:GetBabyTime()
	end

	local time = math.max(0, self.baby_time_left)

	self._baby_end_time = GetTime() + time

	self._baby_task = self.inst:DoTaskInTime(time, function()
		self._baby_task = nil
		self._baby_end_time = nil

		self.baby_time_left = 0

		self:ProduceBaby()
	end)
end

-- StopWorking() Completely resets the timers.
function FishFarmManager:StopWorking()
	self:UpdateRemainingTimes()

	self:CancelRoeTask()
	self:CancelBabyTask()

	self.roe_time_left = nil
	self.baby_time_left = nil

	if self.onstopfn then
		self.onstopfn(self.inst)
	end
end

-- PauseWorking() Does not reset the timers.
function FishFarmManager:PauseWorking()
	self:UpdateRemainingTimes() -- Save exact remaining time before cancelling tasks.

	self:CancelRoeTask()
	self:CancelBabyTask()

	if self.onpausefn then
		self.onpausefn(self.inst)
	elseif self.onstopfn then
		self.onstopfn(self.inst)
	end
end

function FishFarmManager:ProduceRoe(skiptask)
	local inst = self.inst
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil then
		return
	end

	if container == nil then
		return
	end

	if fueled:IsEmpty() then
		self:StopWorking()
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fish_parent == nil then
		self:StopWorking()
		return
	end

	if fishfarmable == nil then
		self:StopWorking()
		return
	end

	local valid = fishfarmable:IsPhaseValid()
	and fishfarmable:IsMoonPhaseValid()
	and fishfarmable:IsSeasonValid()
	and fishfarmable:IsWorldValid()

	if not valid then
		self.roe_time_left = 0
		self:PauseWorking()

		return
	end

	local roe_prefab = fishfarmable:GetRoePrefab()

	if roe_prefab == nil then
		return
	end

	local roeitem = container:GetItemInSlot(2)
	local produced = false

	if roeitem ~= nil then
		if roeitem.prefab == roe_prefab then
			if roeitem.components.stackable ~= nil then
				local size = roeitem.components.stackable:StackSize()
				local max = roeitem.components.stackable.maxsize

				if size < max then
					local newsize = size + 1

					roeitem.components.stackable:SetStackSize(newsize)
					local actual_size = roeitem.components.stackable:StackSize()

					if actual_size > size then
						fueled:DoDelta(-self.consumefuel_roe)
						produced = true
					end
				end
			end
		end
	else
		local roe = SpawnPrefab(roe_prefab)

		if roe ~= nil then
			local pos = Vector3(inst.Transform:GetWorldPosition())
			roe.Transform:SetPosition(pos.x, pos.y, pos.z)

			if container:GiveItem(roe, 2, pos) then
				fueled:DoDelta(-self.consumefuel_roe)
				produced = true
			else
				roe:Remove()
			end
		end
	end

	if produced then
		if self.onworkfn then
			self.onworkfn(inst)
		end
	end

	self.roe_time_left = fishfarmable:GetRoeTime()

	if not skiptask then
		self:StartRoeTimer()
	end
end

function FishFarmManager:ProduceBaby(skiptask)
	local inst = self.inst
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil then
		return
	end

	if container == nil then
		return
	end

	if fueled:IsEmpty() then
		self:StopWorking()
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fish_parent == nil then
		self:StopWorking()
		return
	end

	if fishfarmable == nil then
		self:StopWorking()
		return
	end

	local valid = fishfarmable:IsPhaseValid()
	and fishfarmable:IsMoonPhaseValid()
	and fishfarmable:IsSeasonValid()
	and fishfarmable:IsWorldValid()

	if not valid then
		self.baby_time_left = 0
		self:PauseWorking()

		return
	end

	local baby_prefab = fishfarmable:GetBabyPrefab()

	if baby_prefab == nil then
		return
	end

	local produced = false
	local empty_slot = nil

	for i = self.slot_start, self.slot_end do
		if container:GetItemInSlot(i) == nil then
			empty_slot = i
			break
		end
	end

	if empty_slot ~= nil then
		local baby = SpawnPrefab(baby_prefab)

		if baby ~= nil then
			local pos = Vector3(inst.Transform:GetWorldPosition())
			baby.Transform:SetPosition(pos.x, pos.y, pos.z)

			if container:GiveItem(baby, empty_slot, pos) then
				fueled:DoDelta(-self.consumefuel_baby)
				produced = true
			else
				baby:Remove()
			end
		end
	end

	if produced then
		if self.onworkfn then
			self.onworkfn(inst)
		end
	end

	self.baby_time_left = fishfarmable:GetBabyTime()

	if not skiptask then
		self:StartBabyTimer()
	end
end

function FishFarmManager:StartWorking()
	local inst = self.inst
	local container = inst.components.container

	if container == nil then
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fish_parent == nil or fishfarmable == nil then
		return
	end

	if not fishfarmable:IsPhaseValid()
	or not fishfarmable:IsMoonPhaseValid()
	or not fishfarmable:IsSeasonValid()
	or not fishfarmable:IsWorldValid() then
		return
	end

	if self.roe_time_left == nil then
		self.roe_time_left = fishfarmable:GetRoeTime()
	end

	if self.baby_time_left == nil then
		self.baby_time_left = fishfarmable:GetBabyTime()
	end

	local was_working = self._roe_task ~= nil or self._baby_task ~= nil

	self:StartRoeTimer()
	self:StartBabyTimer()

	local is_working = self._roe_task ~= nil or self._baby_task ~= nil

	if not was_working and is_working then
		if self.onstartfn then
			self.onstartfn(inst)
		end
	end
end

function FishFarmManager:OnAddFuel()
	local container = self.inst.components.container

	if container == nil then
		return
	end

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

function FishFarmManager:CheckInternalValidity()
	local inst = self.inst
	local container = inst.components.container
	local fueled = inst.components.fueled

	if container == nil then
		return
	end

	local fish_parent = container:GetItemInSlot(1)
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fishfarmable == nil then
		if self._roe_task ~= nil
		or self._baby_task ~= nil
		or self.roe_time_left ~= nil
		or self.baby_time_left ~= nil then
			self:StopWorking()
		end

		return
	end

	if fueled == nil or fueled:IsEmpty() then
		return
	end

	local valid = fishfarmable:IsPhaseValid()
	and fishfarmable:IsMoonPhaseValid()
	and fishfarmable:IsSeasonValid()
	and fishfarmable:IsWorldValid()

	if valid then
		self:StartWorking()
	else
		if self._roe_task ~= nil or self._baby_task ~= nil then
			self:PauseWorking()
		end
	end
end

function FishFarmManager:WatchWorldStates()
	self.inst:WatchWorldState("phase", function()
		self:CheckInternalValidity()
	end)

	self.inst:WatchWorldState("moonphase", function()
		self:CheckInternalValidity()
	end)

	self.inst:WatchWorldState("isalterawake", function()
		self:CheckInternalValidity()
	end)

	self.inst:WatchWorldState("season", function()
		self:CheckInternalValidity()
	end)
end

function FishFarmManager:LongUpdate(dt)
	self:UpdateRemainingTimes() -- Capture exact remaining time before cancelling tasks.

	self:CancelRoeTask()
	self:CancelBabyTask()

	local container = self.inst.components.container
	local fueled = self.inst.components.fueled

	if container == nil or fueled == nil or fueled:IsEmpty() then
		return
	end

	local fish = container:GetItemInSlot(1)
	local farmable = fish and fish.components.fishfarmable

	if farmable == nil then
		return
	end

	local valid = farmable:IsPhaseValid()
	and farmable:IsMoonPhaseValid()
	and farmable:IsSeasonValid()
	and farmable:IsWorldValid()

	if not valid then
		return
	end

	if self.roe_time_left == nil then
		self.roe_time_left = farmable:GetRoeTime()
	end

	if dt >= self.roe_time_left then
		self.roe_time_left = 0

		if not fueled:IsEmpty() then
			self:ProduceRoe(true)
		end
	else
		self.roe_time_left = math.max(0, self.roe_time_left - dt)
	end

	if self.baby_time_left == nil then
		self.baby_time_left = farmable:GetBabyTime()
	end

	if dt >= self.baby_time_left then
		self.baby_time_left = 0

		if not fueled:IsEmpty() then
			self:ProduceBaby(true)
		end
	else
		self.baby_time_left = math.max(0, self.baby_time_left - dt)
	end

	self:StartWorking()
end

function FishFarmManager:OnSave()
	self:UpdateRemainingTimes()

	return
	{
		roe_time_left = self.roe_time_left,
		baby_time_left = self.baby_time_left,
	}
end

function FishFarmManager:OnLoad(data)
	self:CancelRoeTask()
	self:CancelBabyTask()

	if data ~= nil then
		self.roe_time_left = data.roe_time_left
		self.baby_time_left = data.baby_time_left
	end
end

function FishFarmManager:GetDebugString()
	local inst = self.inst
	local container = inst.components.container

	local fish_parent = container and container:GetItemInSlot(1) or nil
	local fish_product = container and container:GetItemInSlot(2) or nil
	local fishfarmable = fish_parent and fish_parent.components.fishfarmable

	if fish_parent == nil or fishfarmable == nil then
		print("-------------------------------------------------------")
		print("---- FishFarmManager Debug - Fish Status Checker   ----")
		print("No Main Fish Found!")
		print("-------------------------------------------------------")
		return
	end

	self:UpdateRemainingTimes() -- Update displayed timers without changing them.

	local fish = fish_parent.prefab or "Unknown Fish"
	local roe = fishfarmable:GetRoePrefab() or "Unknown Roe"
	local baby = fishfarmable:GetBabyPrefab() or "Unknown Offspring"

	local roe_time_total = fishfarmable:GetRoeTime()
	local baby_time_total = fishfarmable:GetBabyTime()

	local roe_time_left = self.roe_time_left
	local baby_time_left = self.baby_time_left

	local phase = fishfarmable:IsPhaseValid()
	local moonphase = fishfarmable:IsMoonPhaseValid()
	local season = fishfarmable:IsSeasonValid()
	local world = fishfarmable:IsWorldValid()

	local valid = phase and moonphase and season and world

	local world_tag = (TheWorld:HasTag("cave") and "cave")
	or (TheWorld:HasTag("forest") and "forest") or "unknown (Possibly a modded world?)"

	print("-------------------------------------------------------")
	print("---- FishFarmManager Debug - Fish Checker Status   ----")
	print(" ")

	print("Main Fish:             ", fish)
	print("Roe:                   ", roe)
	print("Offspring:             ", baby)
	print(" ")

	if roe_time_total then
		print(string.format("Roe Timer:              Total Time = %.0fs | Time Left: %s", roe_time_total, roe_time_left
		and string.format("%.1fs", roe_time_left)
		or "No Roe Timer found!"))
	else
		print("This Fish does not produce any Roe!")
	end

	if baby_time_total then
		print(string.format("Offspring Timer:        Total Time = %.0fs | Time Left: %s", baby_time_total, baby_time_left
		and string.format("%.1fs", baby_time_left)
		or "No Offspring Timer found!"))
	else
		print("This Fish does not produce any Offspring!")
	end

	print(" ")
	print("Roe Task Active:       ", self._roe_task ~= nil)
	print("Baby Task Active:      ", self._baby_task ~= nil)
	print("Validity Check Active: ", self._validity_task ~= nil)
	print("Working:               ", self._roe_task ~= nil or self._baby_task ~= nil)

	print("Paused:                ", valid == false and (self.roe_time_left ~= nil or self.baby_time_left ~= nil)
	and self._roe_task == nil and self._baby_task == nil)

	print(" ")
	print("Roe Slot 2:            ", fish_product and fish_product.prefab or "EMPTY")

	if fish_product ~= nil and fish_product.prefab == roe and fish_product.components.stackable ~= nil then
		print("Roe Stack:             ", string.format("%d / %d",
		fish_product.components.stackable:StackSize(),
		fish_product.components.stackable.maxsize))
	end

	local empty_baby_slots = 0
	local occupied_baby_slots = 0

	for i = self.slot_start, self.slot_end do
		if container:GetItemInSlot(i) == nil then
			empty_baby_slots = empty_baby_slots + 1
		else
			occupied_baby_slots = occupied_baby_slots + 1
		end
	end

	print("Baby Slots:            ", string.format("%d occupied / %d empty", occupied_baby_slots, empty_baby_slots))
	print(" ")

	print("-------------------------------------------------------")
	print("---- FishFarmManager Debug - Fish Validity Checker ----")
	print(" ")

	print("Phase Valid:          ", phase, "(" .. TheWorld.state.phase .. ")")
	print("Moon Valid:           ", moonphase, "(" .. TheWorld.state.moonphase .. ")")
	print("Season Valid:         ", season, "(" .. TheWorld.state.season .. ")")
	print("World Valid:          ", world, "(" .. world_tag .. ")")

	print(" ")

	local reasons = {}

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
		print("Something is Invalid! Reasons: ".. table.concat(reasons, " | "))
	end

	print("-------------------------------------------------------")
end

-- Watchers and validity task are already initialized in the constructor.
-- Kept here in case any code explicit calls for it.
function FishFarmManager:OnPostInit()

end

return FishFarmManager