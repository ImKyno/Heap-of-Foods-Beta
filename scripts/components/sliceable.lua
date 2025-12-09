local function onsliceable(self)
    if self.canbesliced then
        self.inst:AddTag("sliceable")
    else
        self.inst:RemoveTag("sliceable")
    end
end

local function onslicestack(self)
	if self.canslicestack then
		self.inst:AddTag("sliceablestack")
	else
		self.inst:RemoveTag("sliceablestack")
	end
end

local function onsliceableworld(self)
	if self.canbesliceworld then
		self.inst:AddTag("sliceable_world")
	else
		self.inst:RemoveTag("sliceable_world")
	end
end

local Sliceable = Class(function(self, inst)
	self.inst = inst
	self.product = nil -- The product your item will be sliced into.
	self.productfn = nil -- Custom function for the sliced product.
	self.slicesize = 1 -- The size of your sliced item, if it can be 1,2,3,4 slices etc.
	self.slicestack = false -- If Cleaver can slice the entire stack of your item. (Unused)
	
	self.onslicefn = nil
	self.onslicestackfn = nil
	
	self.onsliceworld = false
	self.onsliceworldfn = nil
end,
nil,
{
	canbesliced = onsliceable,
	canslicestack = onslicestack,
	canbesliceworld = onsliceableworld,
})

function Sliceable:SetOnSliceFn(fn)
    self.onslicefn = fn
end

function Sliceable:SetOnSliceStackFn(fn)
	self.onslicestackfn = fn
end

function Sliceable:SetWorldSlice(bool)
	self.onsliceworld = bool
end

function Sliceable:SetOnWorldSliceFn(fn)
	self.onsliceworldfn = fn
end

function Sliceable:SetProduct(product, number)
	self.product = product
end

function Sliceable:SetProductFn(fn)
	self.productfn = fn
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

function Sliceable:OnSliceStack(inst)
	local item = self.inst
	local position = self.inst:GetPosition()
	local stacksize = 1 
	
	if self.inst.components.stackable ~= nil then
		stacksize = item.components.stackable:StackSize()
	end
		
	if self.inst.components.inventoryitem ~= nil then 
		local owner = self.inst.components.inventoryitem.owner
		local slice = SpawnPrefab(self.product)
		local stackslice = self.slicesize * stacksize
		
		if slice.components.stackable ~= nil then
			slice.components.stackable:SetStackSize(stackslice)
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

function Sliceable:OnSliceWorld(doer)
	local inst = self.inst
	local item = nil
	
	if self.productfn ~= nil then
		item = self.productfn(inst)
	elseif self.product ~= nil then
		item = self.product
    end

	if item == nil then
		return
	end

	local slice = SpawnPrefab(item)

	if slice ~= nil then
		if doer ~= nil and doer.components.inventory ~= nil then
			doer.components.inventory:GiveItem(slice, nil, self.inst:GetPosition())
		else
			LaunchAt(slice, self.inst, nil, 1, 1)
		end
	end

    if self.onsliceworldfn ~= nil then
		self.onsliceworldfn(inst)
	end
end

return Sliceable