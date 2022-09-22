local function SetupRegenTime(self)
	if not TheWorld.state.isspring then
		self.regentime     = TUNING.MILKABLE_SPRING_TIME
		self.baseregentime = TUNING.MILKABLE_SPRING_TIME * 0.5
		self.canbemilked   = true
	else
		self.regentime     = TUNING.MILKABLE_NORMAL_TIME
		self.baseregentime = TUNING.MILKABLE_NORMAL_TIME * 0.5
		self.canbemilked   = true
	end	
end

local function onmilkable(self)
    if self.canbemilked and self.caninteractwith then
        self.inst:AddTag("milkableanimal")
    else
        self.inst:RemoveTag("milkableanimal")
    end
end

local MilkableAnimal = Class(function(self, inst)
    self.inst = inst
    self.canbemilked = nil
    self.regentime = nil
	self.baseregentime = nil
    self.product = nil
    self.numtoharvest = 1
	self.damage = TUNING.MILKABLE_NORMAL_DAMAGE
	self.caninteractwith = true
    self.targettime = nil
    self.task = nil
	self.inst:WatchWorldState("season", SetupRegenTime)
	end,
	nil,
	{
    canbemilked = onmilkable,
	caninteractwith = onmilkable,
})

local function OnRegen(inst)
    inst.components.MilkableAnimal:Regen()
end

function MilkableAnimal:SetUp(product, regen, number)
	self.canbemilked = true
	self.product = product
	self.numtoharvest = number or 1

	if not TheWorld.state.isspring then
		self.regentime     = TUNING.MILKABLE_SPRING_TIME
		self.baseregentime = TUNING.MILKABLE_SPRING_TIME * 0.5
	else
		self.regentime     = TUNING.MILKABLE_NORMAL_TIME
		self.baseregentime = TUNING.MILKABLE_NORMAL_TIME * 0.5
	end		
end

function MilkableAnimal:LongUpdate(dt)
    if self.targettime ~= nil then
        if self.task ~= nil then 
            self.task:Cancel()
            self.task = nil
        end

        local time = GetTime()
        if self.targettime > time + dt then
            local time_to_milkable = self.targettime - time - dt
            self.task = self.inst:DoTaskInTime(time_to_milkable, OnRegen)
            self.targettime = time + time_to_milkable
        else
            self:Regen()
        end
    end
end

function MilkableAnimal:OnSave()
    local data =
    {
        milked2 = not self.canbemilked and true or nil,
        caninteractwith = self.caninteractwith and true or nil,
    }

    if self.targettime ~= nil then
        local time = GetTime()
        if self.targettime > time then
            data.time = math.floor(self.targettime - time)
        end
    end

    return next(data) ~= nil and data or nil
end

function MilkableAnimal:OnLoad(data)
    if data.milked2 or data.time ~= nil then
        self.canbemilked = false
    else
        self.canbemilked = true
    end

    if data.caninteractwith then
        self.caninteractwith = data.caninteractwith
    end

    if data.time ~= nil then
        if self.task ~= nil then
            self.task:Cancel()
        end
        self.task = self.inst:DoTaskInTime(data.time, OnRegen)
        self.targettime = GetTime() + data.time
    end    
end

function MilkableAnimal:Regen()
    self.canbemilked = true
    self.targettime = nil
    self.task = nil
end

function MilkableAnimal:CanBeMilked()
	return canbemilked
end

function MilkableAnimal:Milk(milker)
    if self.canbemilked and self.caninteractwith then
	
		if self.onmilkedfn then
			self.onmilkedfn(self.inst, milker)
		end
		
		--[[ I'll handle this from the postinits, it's better I think.
		local kick_chance
		
		if self.inst:HasTag("domesticated") then
			kick_chance = 0
		elseif milker:HasTag("beefalo") then
			kick_chance = 10
		else
			kick_chance = 70
		end
	
		-- GoToState/Animations is really weird and makes them bugged when milking. I don't know how to fix this.
		-- So for now, unless I figure out, just play some stupid sound and nothing more...
		if math.random(100) <= kick_chance and milker.components.combat and not self.inst:HasTag("sleeping")
		and not self.inst:HasTag("is_frozen") and not self.inst:HasTag("is_thawing") then
			milker.components.combat:GetAttacked(self.inst, self.damage)
			milker:PushEvent("kick")
		elseif self.inst:HasTag("domesticated") then
			-- Do something?
		else
			-- Do something?
		end
		]]--
		
        local loot = nil
        if milker ~= nil and milker.components.inventory ~= nil and self.product ~= nil then
			loot = SpawnPrefab(self.product)
			if loot ~= nil then
				milker:PushEvent("picksomething", { object = self.inst, loot = loot })
				milker.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
				
				-- Extra loot if is Spring or is Domesticated!
				if TheWorld.state.isspring or self.inst:HasTag("domesticated") then
					local extraloot = SpawnPrefab(self.product)
					milker.components.inventory:GiveItem(extraloot, nil, self.inst:GetPosition())
				end
			end
        end

        self.canbemilked = false

        if self.baseregentime ~= nil then
            if self.task ~= nil then
                self.task:Cancel()
            end
            self.task = self.inst:DoTaskInTime(self.regentime, OnRegen)
            self.targettime = GetTime() + self.regentime
        end

        self.inst:PushEvent("milked", { milker = milker, loot = loot, animal = self.inst })
	end
end

return MilkableAnimal
