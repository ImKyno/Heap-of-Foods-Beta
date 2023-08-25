-- Common Dependencies.
local _G            = GLOBAL
local PlantRegrowth = require("components/plantregrowth")

AddComponentPostInit("regrowthmanager", function(self)
	local _worldstate = _G.TheWorld.state
	
	self:SetRegrowthForType("kyno_aloe_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aloe_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_radish_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_radish_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_sweetpotato_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_sweetpotato_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_turnip_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_turnip_ground", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_turnip_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_turnip_cave", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_cucumber_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_cucumber_ground", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_limpetrock", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_limpetrock", function()
        return not (_worldstate.isday) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_sugartree_flower", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_sugartree_flower", function()
        return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_rockflippable", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_rockflippable", function()
        return not (_worldstate.isday) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_rockflippable_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_rockflippable_cave", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_mushstump_natural", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_mushstump_natural", function()
        return not (_worldstate.isday) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_mushstump_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_mushstump_cave", function()
        return not (_worldstate.isday) and 1 or 0
    end)
	
	self:SetRegrowthForType("kyno_fennel_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_fennel_ground", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_parznip_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_parznip_ground", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_parznip_big", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_parznip_big", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_aspargos_ground", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aspargos_ground", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_aspargos_cave", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_aspargos_cave", function()
        return 1
    end)
	
	self:SetRegrowthForType("kyno_limpetrock", TUNING.KYNO_PLANT_REGROWTH_TIME, "kyno_limpetrock", function()
		return not (_worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
	end)
end) 

AddComponentPostInit("desolationspawner", function(self)
	self:SetSpawningForType("kyno_kokonuttree", "kyno_kokonuttree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_kokonuttree"}, function()
		return 1
	end)
	
	self:SetSpawningForType("kyno_sugartree_short", "kyno_sugartree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_sugartree"}, function()
		return 1
	end)
	
	self:SetSpawningForType("kyno_meadowisland_tree", "kyno_meadowisland_tree_sapling", TUNING.KYNO_DESOLATION_RESPAWN_TIME, {"kyno_meadowisland_tree"}, function()
		return 1
	end)
end)

local regrowthtime_multipliers = 
{
    kyno_sugartree_short = function()
        return 1 * ((TheWorld.state.iswinter and 0) or 1)
    end,
	
    kyno_meadowisland_tree = function()
        return 1 * ((TheWorld.state.iswinter and 0) or 1)
    end,
   
	kyno_kokonuttree = function()
        return 1 * ((TheWorld.state.iswinter and 0) or 1)
    end,
}

for i,v in pairs(regrowthtime_multipliers) do
    PlantRegrowth.TimeMultipliers[i] = v
end