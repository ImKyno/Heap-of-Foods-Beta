-- Modified version of the "hatchable" component, without some requirements.
-- Can control when the egg can incubate (progress) and hatch (birth).
-- Which type of heat it requires or none at all.
-- Which part of the day it can progress and hatch.

local FIRE_MUST_TAGS = { "HASHEATER" }
local FIRE_MUST_NOT_TAGS = { "INLIMBO" }

local HatchableEgg = Class(function(self, inst)
	self.inst = inst

	self.requires_heat = true
	self.heat_radius = TUNING.HATCH_CAMPFIRE_RADIUS or 3
	self.accepts_exothermic = true
	self.accepts_endothermic = false

	self.crack_mode = false
	self.crack_time = 10
	self.crack_progress = 0
	self.crack_prefab = nil
	self.oncrackfn = nil

	self.incubate_mode = false
	self.hatch_time = 600
	self.progress = 0
	self.onhatchfn = nil

	self.allowed_phases =
	{
		day = true,
		dusk = true,
		night = true,
	}

	self.task = nil
end)

function HatchableEgg:SetHeatTypes(exo, endo)
	self.accepts_exothermic = exo
	self.accepts_endothermic = endo
end

function HatchableEgg:SetHeatRadius(radius)
	self.heat_radius = radius
end

function HatchableEgg:SetRequiresHeat(bool)
	self.requires_heat = bool
end

function HatchableEgg:SetAllowedPhases(day, dusk, night)
	self.allowed_phases.day = day
	self.allowed_phases.dusk = dusk
	self.allowed_phases.night = night
end

function HatchableEgg:GetCrackTimeLeft()
	if not self.crack_mode then
		return nil
	end

	local timeleft = self.crack_time - self.crack_progress
	return math.max(0, timeleft)
end

function HatchableEgg:GetHatchTimeLeft()
	if not self.incubate_mode then
		return nil
	end

	local timeleft = self.hatch_time - self.progress
	return math.max(0, timeleft)
end

function HatchableEgg:GetTimeLeft()
	if self.crack_mode then
		return self:GetCrackTimeLeft()
	end

	if self.incubate_mode then
		return self:GetHatchTimeLeft()
	end

	return nil
end

function HatchableEgg:SetOnCrackFn(fn)
	self.oncrackfn = fn
end

function HatchableEgg:SetOnHatchFn(fn)
	self.onhatchfn = fn
end

function HatchableEgg:IsNearValidHeat()
	if not self.requires_heat then
		return true
	end

	local x,y,z = self.inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, self.heat_radius, FIRE_MUST_TAGS, FIRE_MUST_NOT_TAGS)

	for _, ent in ipairs(ents) do
		if ent.components.heater then
			local heater = ent.components.heater
			local heat = heater:GetHeat(self.inst)

			if heat and heat ~= 0 then
				if heat > 0 and heater:IsExothermic() and self.accepts_exothermic then
					return true
				end
				
				if heat < 0 and heater:IsEndothermic() and self.accepts_endothermic then
					return true
				end
			end
		end
	end

	return false
end

function HatchableEgg:StartCrackMode(prefab_to_spawn, time)
	self.crack_mode = true
	self.crack_prefab = prefab_to_spawn
	self.crack_time = time or self.crack_time
	self.crack_progress = 0

	self:StartUpdating()
end

function HatchableEgg:StartIncubateMode(time)
	self.incubate_mode = true
	self.hatch_time = time or self.hatch_time
	self.progress = 0

	self:StartUpdating()
end

function HatchableEgg:StartUpdating()
	if not self.task then
		self.task = self.inst:DoPeriodicTask(1, function()
			self:OnUpdate(1)
		end)
	end
end

function HatchableEgg:StopUpdating()
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
end

function HatchableEgg:OnUpdate(dt)
	if self.crack_mode then
		if not self:IsNearValidHeat() then
			self.crack_progress = 0
			return
		end

		self.crack_progress = self.crack_progress + dt

		if self.crack_progress >= self.crack_time then
			local x, y, z = self.inst.Transform:GetWorldPosition()
			local newegg = SpawnPrefab(self.crack_prefab)

			if newegg then
				newegg.Transform:SetPosition(x, y, z)
			end
			
			if self.oncrackfn then
				self.oncrackfn(self.inst)
			end
		end

		return
	end

    if self.incubate_mode then
		if not self:IsNearValidHeat() then
			return
		end

		if not self.allowed_phases[TheWorld.state.phase] then
			return
		end

		self.progress = self.progress + dt

		if self.progress >= self.hatch_time then
			self:StopUpdating()

			if self.onhatchfn then
				self.onhatchfn(self.inst)
			end
		end
	end
end

function HatchableEgg:GetDebugString()
	if self.crack_mode then
		return string.format("CRACK %.2f / %.2f", self.crack_progress, self.crack_time)
	end
	
	if self.incubate_mode then
		return string.format("INCUBATE %.2f / %.2f", self.progress, self.hatch_time)
	end
	
	return "EGG IS IDLE"
end

return HatchableEgg