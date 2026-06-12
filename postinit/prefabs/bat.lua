local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function BatPostInit(inst)
	local RETARGET_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.bat.fn, "Retarget", "RETARGET_CANT_TAGS")
	table.insert(RETARGET_CANT_TAGS, "batfriendly")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("bat", BatPostInit)