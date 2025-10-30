--[[------------------------------------------------------------------------------------------------

	* This component is for transforming mushrooms into mushtrees during full moon.
	* BUT it should work for anything. Structures, items, creatures, you name it.
	* Does not work for caves, will probably change this if I ever need...
	
	* To start, on your both prefabs:
	inst:AddComponent("fullmoontransformer")
	
	* To set the transformed prefab:
	inst.components.fullmoontransformer.transform_prefab = "prefab"
	
	* To set the chance of transforming:
	inst.components.fullmoontransformer.chance = 1.00 -- 100% chance.
	
	* To set the chance of transforming back:
	inst.components.fullmoontransformer.revert_chance = 0.50 -- 50% chance.
	
	* To set the delay between transformations:
	inst.components.fullmoontransformer.delay = 5 -- 5 seconds.
	
	* To set a custom FX for when transforming:
	inst.components.fullmoontransformer.fx_prefab = "fx_prefab"
	
]]--------------------------------------------------------------------------------------------------

local FullMoonTransformer = Class(function(self, inst)
	self.inst = inst

	self.original_prefab = inst.prefab
	self.transform_prefab = nil
	self.chance = 1
	self.revert_chance = 1
	self.delay = 5
	self.fx_prefab = "small_puff"
	
	self._isTransformed = false
	self._task = nil
	self._reverttask = nil
	
	self._data = {}

	self.inst:WatchWorldState("isfullmoon", function(_, isfullmoon)
		self:OnFullMoonChange(isfullmoon)
	end)
end)

function FullMoonTransformer:SpawnFX(fx_prefab, x, y, z)
	if fx_prefab then
		local fx = SpawnPrefab(fx_prefab)
		
		if fx and x and y and z then
			fx.Transform:SetPosition(x, y, z)
		end
	end
end

-- Don't tell RegrowthManager to repopulate this prefab.
function FullMoonTransformer:SafeRemove()
	if self.inst.OnStartRegrowth then
		-- print("FullMoonTransformer - This prefab has regrowth, but we are going to skip it.")
		self.inst:RemoveEventCallback("onremove", self.inst.OnStartRegrowth)
	end
	
	RemoveFromRegrowthManager(self.inst)
	self.inst:Remove()
end

function FullMoonTransformer:DoTransform()
	if TheWorld:HasTag("cave") or self._isTransformed or not self.transform_prefab then
		return
	end

	if math.random() > self.chance then
		return
	end

	local delay = math.max(0, GetRandomWithVariance(self.delay * 0.5, self.delay * 0.5))
	
	self._task = self.inst:DoTaskInTime(delay, function()
		if not self.inst:IsValid() then
			return
		end

		local newprefab = SpawnPrefab(self.transform_prefab)
		
		if newprefab then
			newprefab.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			self:SpawnFX(self.fx_prefab, self.inst.Transform:GetWorldPosition())
			
			self._isTransformed = true
			newprefab._isTransformed = true

			local comp = newprefab.components.fullmoontransformer
			
			comp.original_prefab = self.original_prefab
			comp.transform_prefab = self.transform_prefab
			comp.chance = self.chance
			comp.revert_chance = self.revert_chance
			comp.delay = self.delay
			comp.fx_prefab = self.fx_prefab
			comp._isTransformed = true

			local revert_time = 10 -- TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time) + math.random(2, 4)
            
			comp._reverttask = newprefab:DoTaskInTime(revert_time, function()
				if not TheWorld.state.isfullmoon then
					comp:DoRevert()
				end
			end)
		end
		
		self:SafeRemove()
	end)
end

function FullMoonTransformer:DoRevert()
	if TheWorld:HasTag("cave") or not self._isTransformed or not self.original_prefab then
		return
	end

	local delay = math.max(0, GetRandomWithVariance(self.delay * 0.5, self.delay * 0.5))
	
	self._task = self.inst:DoTaskInTime(delay, function()
		if not self.inst:IsValid() then
			return
		end

		local oldprefab = SpawnPrefab(self.original_prefab)
		
		if oldprefab then
			oldprefab.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			self:SpawnFX(self.fx_prefab, oldprefab.Transform:GetWorldPosition())
			
			self._isTransformed = false
			oldprefab._isTransformed = false
			
			local comp = oldprefab.components.fullmoontransformer
			
			comp.original_prefab = self.original_prefab
			comp.transform_prefab = self.transform_prefab
			-- comp.chance = self.chance
			comp.revert_chance = self.revert_chance
			comp.delay = self.delay
			comp.fx_prefab = self.fx_prefab
			comp._isTransformed = false
		end

		self:SafeRemove()
	end)
end

function FullMoonTransformer:OnFullMoonChange(isfullmoon)
	if self._task ~= nil then
		self._task:Cancel()
		self._task = nil
	end

	if isfullmoon and not self._isTransformed then
		self._task = self.inst:DoTaskInTime(math.random(1, 3), function()
			self:DoTransform()
		end)
	elseif not isfullmoon and self._isTransformed then
		self._task = self.inst:DoTaskInTime(math.random(1, 3), function()
			self:DoRevert()
		end)
	end
end

function FullMoonTransformer:OnSave()
	return 
	{
		_isTransformed = self._isTransformed,
		_original_prefab_saved = self.original_prefab,
		_transform_prefab_saved = self.transform_prefab,
		_data = self._data,
	}
end

function FullMoonTransformer:OnLoad(data)
	if data then
		self._isTransformed = data._isTransformed
		self.original_prefab = data._original_prefab_saved or self.original_prefab
		self.transform_prefab = data._transform_prefab_saved or self.transform_prefab
		self._data = data._data or {}
	end
	
	self.inst:DoTaskInTime(1, function()
		if TheWorld:HasTag("cave") then
			return
		end

		if self._isTransformed and not TheWorld.state.isfullmoon then
			self:DoRevert()
		end
		
		if not self._isTransformed and TheWorld.state.isfullmoon then
			self:DoTransform()
		end
	end)
end

return FullMoonTransformer