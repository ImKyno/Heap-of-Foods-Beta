local function onsliceable(self)
    if self.canbesliced then
        self.inst:AddTag("sliceable")
    else
        self.inst:RemoveTag("sliceable")
    end
end

local Sliceable = Class(function(self, inst)
	self.inst = inst
	self.product = nil
	self.slicesize = 1
	self.onslicefn = nil
end,
nil,
{
	canbesliced = onsliceable,
})

function Sliceable:SetOnSliceFn(fn)
    self.onslicefn = fn
end

function Sliceable:SetProduct(product, number)
	self.product = product
end

function Sliceable:SetSliceSize(number)
	self.slicesize = number or 1
end

function Sliceable:OnSlice(inst)
	local item = self.inst
	local position = self.inst:GetPosition()
	
	if self.inst.components.stackable ~= nil and self.inst.components.stackable.stacksize > 1 then
		item = self.inst.components.stackable:Get()
	end
		
	if self.inst.components.inventoryitem ~= nil then 
		local owner = self.inst.components.inventoryitem.owner
		local slice = SpawnPrefab(self.product)
			
		if slice.components.stackable ~= nil then
			slice.components.stackable.stacksize = self.slicesize
		end
		
		if owner ~= nil then
			local container = owner.components.inventory or owner.components.container
			local ownerpos = owner:GetPosition()
			
			if container ~= nil then 
				container:GiveItem(slice, nil, ownerpos)
			end
		else
			LaunchAt(slice, self.inst, nil, 0.5, 0.5)
		end
	end
	
	item:Remove()
end

return Sliceable