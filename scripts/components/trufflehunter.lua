local TruffleHunter = Class(function(self, inst)
	self.inst = inst
	
    self.min_truffles = TUNING.KYNO_TRUFFLEHUNTER_MIN_SPAWN    -- Min truffles to spawn.
	self.max_truffles = TUNING.KYNO_TRUFFLEHUNTER_MAX_SPAWN    -- Max truffles to spawn.
	self.start_chance = TUNING.KYNO_TRUFFLEHUNTER_START_CHANCE -- Chance to find extra truffles after min truffles.
	self.chance_decay = TUNING.KYNO_TRUFFLEHUNTER_CHANCE_DECAY -- Decay percent after each truffle found.
	self.truffle_prefab = "kyno_truffles_ground"               -- Prefab to spawn.

	self.hunting = false

	self.dig_animation = "pig_pickup"                          -- Animation to play while digging. nil for no animation.
	self.dig_repeats = 3                                       -- Times the digging animation will be played.

	self.accept_item_speech = nil                              -- Say something when hunt starts.
	self.truffle_found_speech = nil                            -- Say something when truffle is found.

	self.ontrufflefound = nil                                  -- Event callback for when truffle is found.
	self.onhuntfinished = nil                                  -- Event callback for when hunt is over.
end)

function TruffleHunter:Configure(params)
	for k, v in pairs(params) do
		if self[k] ~= nil then
			self[k] = v
		end
	end
end

function TruffleHunter:SetOnTruffleFoundFn(fn)
	self.ontrufflefound = fn
end

function TruffleHunter:SetOnHuntFinishedFn(fn)
	self.onhuntfinished = fn
end

function TruffleHunter:Say(text)
	if text and self.inst.components.talker then
		self.inst.components.talker:Say(text)
	end
end

function TruffleHunter:SpawnTruffle()
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local offset = Vector3(math.random(-3, 3), 0, math.random(-3, 3))
	local fx_x, fx_y, fx_z = x + offset.x, y, z + offset.z

	local fx = SpawnPrefab("dirt_puff")
	if fx ~= nil then
		fx.Transform:SetPosition(fx_x, fx_y, fx_z)
	end

	local truffle = SpawnPrefab(self.truffle_prefab)
	truffle.Transform:SetPosition(fx_x, fx_y, fx_z)

	if self.inst.SoundEmitter ~= nil then
		self.inst.SoundEmitter:PlaySound("dontstarve/common/dig")
	end

	self:Say(self.truffle_found_speech)

	if self.ontrufflefound then
		self.ontrufflefound(self.inst, truffle)
	end
end

function TruffleHunter:DogDigAnimation()
	if not self.dig_animation then
		self:SpawnTruffle()
		return
	end

	local count = 0
	
	local function PlayDigAnimation()
		if count < self.dig_repeats then
			self.inst.AnimState:PlayAnimation(self.dig_animation)
			count = count + 1
			self.inst:DoTaskInTime(self.inst.AnimState:GetCurrentAnimationLength(), PlayDigAnimation)
		else
			self:SpawnTruffle()
		end
	end

	PlayDigAnimation()
end

function TruffleHunter:MoveAndDig(remaining, chance, spawned)
	if spawned >= self.max_truffles then
		self.hunting = false
		
		if self.onhuntfinished then
			self.onhuntfinished(self.inst)
			
			if self.inst.components.trader ~= nil then
				self.inst.components.trader:Enable()
			end
		end
		
		return
	end

	local angle = math.random() * 2 * math.pi
	local distance = math.random(2, 5)
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local target = Vector3(x + math.cos(angle) * distance, y, z + math.sin(angle) * distance)

	if self.inst.components.locomotor then
		self.inst.components.locomotor:GoToPoint(target)
	end

	self.inst:DoTaskInTime(math.random(2, 4), function()
		if self.inst.components.locomotor then
			self.inst.components.locomotor:Stop()
		end

        self:DogDigAnimation()
        spawned = spawned + 1

		if spawned < self.min_truffles then
			self:MoveAndDig(remaining - 1, chance, spawned)
		elseif math.random() < chance and spawned < self.max_truffles then
			self:MoveAndDig(remaining - 1, chance - self.chance_decay, spawned)
		else
			self.hunting = false
			
			if self.onhuntfinished then
				self.onhuntfinished(self.inst)
				
				if self.inst.components.trader ~= nil then
					self.inst.components.trader:Enable()
				end
			end
		end
	end)
end

function TruffleHunter:StartHunt()
	if self.hunting then 
		return 
	end
	
	self.hunting = true
	self:Say(self.accept_item_speech)
	self:MoveAndDig(self.max_truffles, self.start_chance, 0)
	
	if self.inst.components.trader ~= nil then
		self.inst.components.trader:Disable()
	end
end

return TruffleHunter