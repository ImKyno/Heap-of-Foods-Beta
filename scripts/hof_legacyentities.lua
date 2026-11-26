-- Please consider not editing this file, otherwise stuff in here would be meaningless...
local ALLOWED_USERIDS =
{
	"KU_B43ZaVv6",
	"KU_QW6v-Pdo",
	"KU_SFlxL3d1",
	"KU_MrWebber", -- wtf this mf has a custom KU.
}

local LEGACY_PREFABS =
{
	"kyno_hofbirthday_5hat",
}

return function(action, value)
	if action == "isallowed" then
		return value ~= nil and table.contains(ALLOWED_USERIDS, value)
	elseif action == "islegacy" then
		return table.contains(LEGACY_PREFABS, value)
	end

	return false
end