local SlaughterItem = Class(function(self, inst)
    self.inst = inst
end)

function SlaughterItem:Slaughter(doer, target)
	target.components.health.invincible = false
	target.components.health:Kill()
	
	doer:AddTag("recent_butcher")
	
	if doer.butcher_task then
		doer.butcher_task:Cancel()
		doer.butcher_task = nil
	end
	
	-- We are scary, make prey run away from us.
	doer.butcher_task = doer:DoTaskInTime(TUNING.KYNO_SLAUGHTERTOOLS_COOLDOWN, function()
		if doer:IsValid() then
			doer:RemoveTag("recent_butcher")
			doer.butcher_task = nil
		end
	end)
	
	self:ScareNearbyAnimals(doer, target)
end

function SlaughterItem:ScareNearbyAnimals(doer, target)
	local x, y, z = target.Transform:GetWorldPosition()
	
	-- TheSim:FindEntities(x, y, z, radius, musttags, canttags, mustoneoftags)
	local nearby = TheSim:FindEntities(x, y, z, 20, {"slaughterable"}, {"player", "FX", "NOCLICK", "INLIMBO"})

	for _, mob in ipairs(nearby) do
		if mob:IsValid() and mob.components.locomotor and mob.components.combat and not mob.components.combat.target then
			-- Give up and run.
			mob.components.combat:SetTarget(nil)
			
			-- Run away from butcher for about 4 secs.
			mob:DoTaskInTime(math.random() * 0.5, function()
				if mob:IsValid() then
					local mx, my, mz = mob.Transform:GetWorldPosition()
					local dx, dz = mx - doer.Transform:GetWorldPosition()
					local flee_pt = Vector3(mx + dx * 6, my, mz + dz * 6)

					mob.components.locomotor:GoToPoint(flee_pt)
				end
			end)
		end
	end
end

return SlaughterItem