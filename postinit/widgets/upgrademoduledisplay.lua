local _G      = GLOBAL
local require = _G.require

local CUSTOM_MODULES =
{
	cooker   = true,
	dryer    = true,
	dryer2   = true,
	gourmand = true,
}

AddClassPostConstruct("widgets/upgrademodulesdisplay", function(self)
	local GetModuleDefinitionFromNetID = require("wx78_moduledefs").GetModuleDefinitionFromNetID
	local _OnModuleAdded = self.OnModuleAdded

	function self:OnModuleAdded(moduledefinition_index, ...)
		_OnModuleAdded(self, moduledefinition_index, ...)

		local module_def = GetModuleDefinitionFromNetID(moduledefinition_index)

		if module_def == nil then
			return
		end
		
		local modulename = module_def.name

		if CUSTOM_MODULES[modulename] then
			for i, chip in ipairs(self.chip_objectpool) do
				if chip and chip.moduledefinition_index == moduledefinition_index then
					chip:GetAnimState():SetBuild("kyno_wx78_status")
					chip:GetAnimState():OverrideSymbol("movespeed2_chip", "kyno_wx78_status", modulename.."_chip")
					break
				end
			end
		end
	end
end)