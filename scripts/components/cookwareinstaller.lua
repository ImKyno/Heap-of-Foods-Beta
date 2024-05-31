local function onenabled(self, enabled)
    if enabled then
        self.inst:AddTag("cookwareinstaller")
        if self.acceptnontradable then
            self.inst:AddTag("allcookwareinstaller")
        end
    else
        self.inst:RemoveTag("cookwareinstaller")
        if self.acceptnontradable then
            self.inst:RemoveTag("allcookwareinstaller")
        end
    end
end

local function onacceptnontradable(self, acceptnontradable)
    if self.enabled then
        if acceptnontradable then
            self.inst:AddTag("allcookwareinstaller")
        else
            self.inst:RemoveTag("allcookwareinstaller")
        end
    end
end

local CookwareInstaller = Class(function(self, inst)
    self.inst = inst
    self.enabled = true
    self.deleteitemonaccept = true
    self.acceptnontradable = false
    self.test = nil
    self.abletoaccepttest = nil

    self.acceptstacks = nil
end,
nil,
{
    enabled = onenabled,
    acceptnontradable = onacceptnontradable,
})

function CookwareInstaller:OnRemoveFromEntity()
    self.inst:RemoveTag("cookwareinstaller")
    self.inst:RemoveTag("allcookwareinstaller")
end

function CookwareInstaller:IsTryingToTradeWithMe(inst)
    local act = inst:GetBufferedAction()
    return act ~= nil and act.target == self.inst and (act.action == ACTIONS.INSTALLCOOKWARE)
end

function CookwareInstaller:IsAcceptingStacks()
    return self.acceptstacks
end

function CookwareInstaller:Enable()
    self.enabled = true
end

function CookwareInstaller:Disable()
    self.enabled = false
end

function CookwareInstaller:SetAcceptTest(fn)
    self.test = fn
end

function CookwareInstaller:SetAbleToAcceptTest(fn)
    self.abletoaccepttest = fn
end

function CookwareInstaller:SetOnAccept(fn)
    self.onaccept = fn
end

function CookwareInstaller:SetOnRefuse(fn)
    self.onrefuse = fn
end

function CookwareInstaller:SetAcceptStacks()
    self.acceptstacks = true
end

function CookwareInstaller:AbleToAccept(item, giver, count)
    local on_inventory = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner ~= nil

    if not self.enabled or item == nil then
        return false
    elseif self.abletoaccepttest ~= nil then
        return self.abletoaccepttest(self.inst, item, giver, count)
    elseif self.inst.components.health ~= nil and self.inst.components.health:IsDead() then
        return false, "DEAD"
    elseif (self.inst.components.sleeper ~= nil and self.inst.components.sleeper:IsAsleep()) and not on_inventory then
        return false, "SLEEPING"
    elseif self.inst.sg ~= nil and self.inst.sg:HasStateTag("busy") and not on_inventory then
        return false, "BUSY"
    end
    return true
end

function CookwareInstaller:WantsToAccept(item, giver, count)
    return self.enabled and (not self.test or self.test(self.inst, item, giver, count))
end

function CookwareInstaller:AcceptGift(giver, item, count)
    if not self:AbleToAccept(item, giver, count) then
        return false
    end

    if self:WantsToAccept(item, giver, count) then
        count = count or 1

        if item.components.stackable ~= nil and item.components.stackable.stacksize > count then
            item = item.components.stackable:Get(count)
        else
            item.components.inventoryitem:RemoveFromOwner(true)
        end

        if self.deleteitemonaccept then
            item:Remove()
        elseif self.inst.components.inventory ~= nil then
            item.prevslot = nil
            item.prevcontainer = nil
            self.inst.components.inventory:GiveItem(item, nil, giver ~= nil and giver:GetPosition() or nil)
        end

        if self.onaccept ~= nil then
            self.onaccept(self.inst, giver, item, count)
        end

        self.inst:PushEvent("trade", { giver = giver, item = item })

        return true
    end

    if self.onrefuse ~= nil then
        self.onrefuse(self.inst, giver, item)
    end
    return false
end

function CookwareInstaller:GetDebugString()
    return self.enabled and "true" or "false"
end

return CookwareInstaller
