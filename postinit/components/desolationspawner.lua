local _G = GLOBAL

AddComponentPostInit("desolationspawner", function(self)
	self:SetSpawningForType("kyno_kokonuttree",       "kyno_kokonuttree_sapling",       TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kokonuttree"},       function()
		return TUNING.KYNO_KOKONUTTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_meadowisland_tree", "kyno_meadowisland_tree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"meadowislandtree"},  function()
		return TUNING.KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_short",   "kyno_sugartree_sapling",         TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"sugartree"},         function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_normal",   "kyno_sugartree_sapling",        TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"sugartree"},         function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_sugartree_tall",     "kyno_sugartree_sapling",        TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"sugartree"},         function()
		return TUNING.KYNO_SUGARTREE_REGROWTH_TIME_MULT
	end)

	self:SetSpawningForType("kyno_cavetubertree",      "kyno_cavetubertree_short",      TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"cavetubertree"},     function()
		return TUNING.KYNO_CAVETUBERTREE_REGROWTH_TIME_MULT
	end)
end)