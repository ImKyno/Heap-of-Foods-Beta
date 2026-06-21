local _G               = GLOBAL
local DEBUFF_BLACKLIST = TUNING.KYNO_SPICE_CUREBUFF_DEBUFF_BLACKLIST

-- inst.components.debuffable:RemoveAllDebuffs()
AddComponentPostInit("debuffable", function(self)
	function self:RemoveAllDebuffs()
		for name, _ in pairs(self.debuffs) do
			self:RemoveDebuff(name)
		end
	end

	local _AddDebuff = self.AddDebuff

	-- For extending the duration of active debuffs.
	function self:AddDebuff(name, prefab, data, buffer, ...)
		local debuff = _AddDebuff(self, name, prefab, data, buffer, ...)

		if debuff ~= nil and not DEBUFF_BLACKLIST[name] and self.inst._spice_cure_debuff_duration_mult ~= nil then
			local mult = self.inst._spice_cure_debuff_duration_mult

			if debuff.components.timer ~= nil then
				for timername in pairs(debuff.components.timer.timers) do
					local timeleft = debuff.components.timer:GetTimeLeft(timername)

					if timeleft ~= nil then
						debuff.components.timer:SetTimeLeft(timername, timeleft * mult)
					end
				end
			end
		end

		return debuff
	end
end)