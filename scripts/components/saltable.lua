local Saltable = Class(function(self, inst)
    self.inst = inst
    self.saltlevel = 0
    self.maxgain = 0.5
    inst:AddTag("saltable")
end)

local function OnDestack(inst)
    inst.components.saltable.saltlevel = self.saltlevel
end

local function GetSaltedFoodBonus(inst, eater)
    local edible = inst.components.edible
    local bonus =
    {
        health = 0,
        sanity = 0,
        hunger = 0,
    }
	
    if edible then
        if edible.foodtype == FOODTYPE.MEAT then
            bonus.health = 0
        end
        if inst:HasTag("sweetener") then
            bonus.sanity = 0
        end
        if inst:HasTag("preparedfood") then
            bonus.health = 0
        end
    end
	
    return bonus
end

local function OnEaten(inst, eater)
    local bonus = GetSaltedFoodBonus(inst, eater)
    local healthbonus = (bonus.health) or 0
    local sanitybonus = (bonus.sanity) or 0
    local hungerbonus = (bonus.hunger) or 0
end

function Saltable:SetUp()
    local stackable = self.inst.components.stackable
    if stackable then
        stackable.ondestack = OnDestack
    end
	
    local edible = self.inst.components.edible
    if edible then
        edible.oneaten = OnEaten
    end
end

function Saltable:UpdatePerishable()
    local perishable = self.inst.components.perishable
	
    if perishable then
        local multiplier = math.max(1 - (self.saltlevel * self.maxgain), 0)
		local percentage = perishable:GetPercent()
		perishable:SetPercent(percentage + .3) -- Refreshes 30% of the food.
    end
end

function Saltable:Dilute(numberadded, saltlevel)
    local oldsize = self.inst.components.stackable and self.inst.components.stackable.stacksize or 1
    local newsize = oldsize + numberadded
	
    self.saltlevel = math.min(((oldsize * self.saltlevel) + (numberadded * saltlevel)) / newsize, 1)
    self:UpdatePerishable()
end

function Saltable:AddSalt()
    local stackable = self.inst.components.stackable
    local inc = 1 / (stackable and stackable.stacksize or 1)
	
    self.saltlevel = math.min(self.saltlevel + inc, 1)
    self:UpdatePerishable()
	self.inst:AddTag("saltedfood")
end

function Saltable:GetSanityModifier(eater, basevalue)
    if basevalue > 0 and self:IsSalted() then
        return 2
    end
	
    return 0
end

function Saltable:GetSaltLevel()
    return self.saltlevel
end

function Saltable:IsSalted()
    return self.saltlevel > 0.1
end

function Saltable:CanSalt()
    return self.saltlevel == 0
end

function Saltable:OnSave()
	local data =
	{
		issalted = self.inst:HasTag("saltedfood"),
	}
	
	return data 
end

function Saltable:OnLoad(data)
	if data == nil then
        return
    end
	
	self.issalted = data.issalted
	
	if self.issalted then
		self.inst:AddTag("saltedfood")
	end
end

return Saltable
