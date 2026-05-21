local _G = GLOBAL

AddComponentPostInit("desolationspawner", function(self)
	self:SetSpawningForType("kyno_kokonuttree", "kyno_kokonuttree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_kokonuttree"}, function()
		return TUNING.KYNO_KOKONUTTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_meadowisland_tree", "kyno_meadowisland_tree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_meadowisland_tree"}, function()
		return TUNING.KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_short", "kyno_sugartree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_sugartree"}, function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_normal", "kyno_sugartree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_sugartree"}, function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_tall", "kyno_sugartree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_sugartree"}, function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_ruined2", "kyno_sugartree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_sugartree"}, function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)
end)