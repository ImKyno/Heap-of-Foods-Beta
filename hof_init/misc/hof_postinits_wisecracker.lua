-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

local function oceanhuntlosttrail(inst, data)
	if data.washedaway then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_LOST_TRAIL_RAIN"))
	else
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_LOST_TRAIL"))
	end
end

local function oceanhuntbeastnearby(inst, data)
	inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_BEAST_NEARBY"))
end

local function hofbirthdaycakecomplete(inst, data)
	inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HOFBIRTHDAY_CAKECOMPLETE"))
end

AddComponentPostInit("wisecracker", function(self)
	self.inst:ListenForEvent("oceanhuntlosttrail", oceanhuntlosttrail)
	self.inst:ListenForEvent("oceanhuntbeastnearby", oceanhuntbeastnearby)
	self.inst:ListenForEvent("hofbirthdaycakecomplete", hofbirthdaycakecomplete)
end)