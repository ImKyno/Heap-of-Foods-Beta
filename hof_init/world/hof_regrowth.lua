-- Common Dependencies.
local _G            = GLOBAL
local PlantRegrowth = require("components/plantregrowth")

AddComponentPostInit("regrowthmanager", function(self)
	local _worldstate = _G.TheWorld.state
	
	self:SetRegrowthForType("kyno_aloe_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aloe_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and TUNING.KYNO_ALOE_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_radish_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_radish_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and TUNING.KYNO_RADISH_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_sweetpotato_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_sweetpotato_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and TUNING.KYNO_SWEETPOTATO_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_turnip_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_turnip_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and TUNING.KYNO_TURNIP_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_turnip_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_turnip_cave", function()
        return TUNING.KYNO_TURNIP_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_cucumber_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_cucumber_ground", function()
        return TUNING.KYNO_CUCUMBER_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_limpetrock", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_limpetrock", function()
        return not (_worldstate.isday) and TUNING.KYNO_LIMPETROCK_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_sugartree_flower", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_sugartree_flower", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and TUNING.KYNO_SUGARFLOWER_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_rockflippable", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_rockflippable", function()
        return not (_worldstate.isday) and TUNING.KYNO_FLIPPABLE_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_rockflippable_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_rockflippable_cave", function()
        return TUNING.KYNO_FLIPPABLE_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_mushstump_natural", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_mushstump_natural", function()
        return not (_worldstate.isday) and TUNING.KYNO_MUSHSTUMP_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_mushstump_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_mushstump_cave", function()
        return not (_worldstate.isday) and TUNING.KYNO_MUSHSTUMP_REGROWTH_TIME_MULT or 0
    end)
	
	self:SetRegrowthForType("kyno_fennel_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_fennel_ground", function()
        return TUNING.KYNO_FENNEL_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_parznip_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_parznip_ground", function()
        return TUNING.KYNO_PARZNIP_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_parznip_big", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_parznip_big", function()
        return TUNING.KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_aspargos_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aspargos_ground", function()
        return TUNING.KYNO_ASPARGOS_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_aspargos_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aspargos_cave", function()
        return TUNING.KYNO_ASPARGOS_REGROWTH_TIME_MULT
    end)
	
	--[[
	self:SetRegrowthForType("kyno_serenityisland_crate", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_serenityisland_crate", function()
        return TUNING.KYNO_CRATE_REGROWTH_TIME_MULT
    end)
	]]--
	
	self:SetRegrowthForType("kyno_watery_crate", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_watery_crate", function()
        return TUNING.KYNO_CRATE_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_meadowisland_crate", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_meadowisland_crate", function()
        return TUNING.KYNO_ISLANDCRATE_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_wildwheat", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_wildwheat", function()
        return TUNING.KYNO_WILDWHEAT_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_spotbush", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_spotbush", function()
        return TUNING.KYNO_SPOTBUSH_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_ocean_wreck", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_ocean_wreck", function()
        return TUNING.KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_pineapplebush", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_pineapplebush", function()
        return TUNING.KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT
    end)
	
	self:SetRegrowthForType("kyno_meadowisland_sandhill", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_meadowisland_sandhill", function()
        return TUNING.KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT
    end)
end) 

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

--[[
local regrowthtime_multipliers = 
{
    kyno_meadowisland_tree = function()
        return 1 * ((TheWorld.state.iswinter and 0) or 1)
    end,
   
	kyno_kokonuttree = function()
        return 1 * ((TheWorld.state.iswinter and 0) or 1)
    end,
}

AddComponentPostInit("plantregrowth", function(self)
    for i, v in pairs(regrowthtime_multipliers) do
        self.TimeMultipliers[i] = v
    end
end)
]]--