local _G      = GLOBAL
local require = _G.require

require("hof_util")

-- Morons at Klei made this stupid thing's loot table a local variable, holy fuck...
local function WormBossSegmentPostInit(inst)
	local function GenerateLoot(inst, pos, loot)
		local loottable = { kyno_worm_bone = 20 }
	
		-- Helper function from hof_util.lua
		local choice = _G.ChooseWeightedRandom(loottable)

		if loot then
			choice = loot
		end

		if choice ~= nil then
			inst.components.lootdropper:FlingItem(_G.SpawnPrefab(choice), pos)
		end
	end
	
	local function OnAnimOver(inst)
		if inst.AnimState:IsCurrentAnimation("segment_death_pst") then
			GenerateLoot(inst)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.OnAnimOver = OnAnimOver
	inst:ListenForEvent("animover", inst.OnAnimOver)
end

AddPrefabPostInit("worm_boss_segment", WormBossSegmentPostInit)