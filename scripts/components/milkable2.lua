local function SetupRegenTime(self)
	if not TheWorld.state.isspring then
		self.regentime = 2400
		self.baseregentime = 2400
		self.damage = 34
		self.canbemilked = true
	else
		self.regentime = 3840
		self.baseregentime = 3840
		self.damage = 68
		self.canbemilked = true
	end	
end

local function onmilkable(self)
    if self.canbemilked and self.caninteractwith then
        self.inst:AddTag("milkable2")
    else
        self.inst:RemoveTag("milkable2")
    end
end

local Milkable2 = Class(function(self, inst)
    self.inst = inst
    self.canbemilked = nil
    self.regentime = nil
	self.baseregentime = nil
    self.product = nil
    self.numtoharvest = 1
	self.damage = 34
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
    inst.components.milkable2:Regen()
end

function Milkable2:SetUp(product, regen, number)
	self.canbemilked = true
	self.product = product
	self.numtoharvest = number or 1

	if not TheWorld.state.isspring then
		self.regentime = 2400
		self.baseregentime = 2400
	else
		self.regentime = 3840
		self.baseregentime = 3840
	end		
end

function Milkable2:LongUpdate(dt)
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

function Milkable2:OnSave()
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

function Milkable2:OnLoad(data)
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

function Milkable2:Regen()
    self.canbemilked = true
    self.targettime = nil
    self.task = nil
end

function Milkable2:CanBeMilked()
	return canbemilked
end

function Milkable2:Milk(milker)

    if self.canbemilked and self.caninteractwith then
		local kick_chance
		if milker:HasTag("beefalo") then
			kick_chance = 10
		else 
			kick_chance = 70
		end
		
		if math.random(100) <= kick_chance and milker.components.combat then
			milker.components.combat:GetAttacked(self.inst, self.damage)
			self.inst.sg:GoToState("attack")
			milker:PushEvent("kick")	
		else
			self.inst.sg:GoToState("bellow")
		end
		
        local loot = nil
        if milker ~= nil and milker.components.inventory ~= nil and self.product ~= nil then
			loot = SpawnPrefab(self.product)
			if loot ~= nil then
				milker:PushEvent("picksomething", { object = self.inst, loot = loot })
				milker.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
				if TheWorld.state.isspring then
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

return Milkable2
