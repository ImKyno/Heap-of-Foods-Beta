local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Pollinators will also target Sugar Flowers as well.
local function BeePostInit(inst)
	local RETARGET_CANT_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.bee.fn, "SpringBeeRetarget", "RETARGET_CANT_TAGS")
	table.insert(RETARGET_CANT_TAGS, "beefriendly")

	inst:AddTag("sugarflowerpollinator")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("bee",       BeePostInit)
AddPrefabPostInit("killerbee", BeePostInit)
AddPrefabPostInit("medal_bee", BeePostInit) -- Mod compatibility: 能力勋章 Functional Medal.