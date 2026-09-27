local _G = GLOBAL

local function IsRightOfPassageActive(queen)
	return queen ~= nil and queen.components.timer ~= nil and queen.components.timer:TimerExists("right_of_passage")
end

-- Do not advance natural pirate raid chance while Right of Passage is active.
-- We still execute the rest of OnUpdate so existing pirate ships, music, cleanup, etc. continue working.
-- We temporarily prevent the natural raid timer from advancing by passing 0 dt to the original function.
AddComponentPostInit("piratespawner", function(self)
	local _OnUpdate = self.OnUpdate

	self.OnUpdate = function(self, dt, ...)
		if IsRightOfPassageActive(self.queen) then
			_OnUpdate(self, 0, ...)
		else
			_OnUpdate(self, dt, ...)
		end
	end
end)