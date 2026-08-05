local _G                       = GLOBAL
local require                  = _G.require
local UpvalueHacker            = require("tools/hof_upvaluehacker")

local BASE_RADIUS              = 20
local EXCLUDE_RADIUS           = 3
local REGROWBLOCKER_ONEOF_TAGS = { "structure", "wall", "regrowth_blocker" }

AddComponentPostInit("regrowthmanager", function(self)
	local _TestForRegrow = UpvalueHacker.GetUpvalue(self.LongUpdate, "DoRegrowth", "TestForRegrow")

	local function TestForRegrow(x, y, z, orig_tile, ...)
		if _G.IsOceanTile(orig_tile) then
			if _G.TheWorld.Map:GetTileAtPoint(x, y, z) ~= orig_tile then
				return false
			end

			local ents = _G.TheSim:FindEntities(x, y, z, EXCLUDE_RADIUS)

			if #ents > 0 then
				return false
			end

			local ents = _G.TheSim:FindEntities(x, y, z, BASE_RADIUS, nil, nil, REGROWBLOCKER_ONEOF_TAGS)

			if #ents > 0 then
				return false
			end

			return true
		end

		return _TestForRegrow(x, y, z, orig_tile, ...)
	end

	UpvalueHacker.SetUpvalue(self.LongUpdate, TestForRegrow, "DoRegrowth", "TestForRegrow")
	UpvalueHacker.HideFn(TestForRegrow, _TestForRegrow)

	local _worldstate = _G.TheWorld.state

	-- Land.
	self:SetRegrowthForType("kyno_aloe_ground", TUNING.KYNO_ALOE_REGROWTH_TIME, "kyno_aloe_ground", function()
		return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0)
		and TUNING.KYNO_ALOE_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_radish_ground", TUNING.KYNO_RADISH_REGROWTH_TIME, "kyno_radish_ground", function()
		return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0)
		and TUNING.KYNO_RADISH_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_sweetpotato_ground", TUNING.KYNO_SWEETPOTATO_REGROWTH_TIME, "kyno_sweetpotato_ground", function()
		return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0)
		and TUNING.KYNO_SWEETPOTATO_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_turnip_ground", TUNING.KYNO_TURNIP_REGROWTH_TIME, "kyno_turnip_ground", function()
		return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0)
		and TUNING.KYNO_TURNIP_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_turnip_cave", TUNING.KYNO_TURNIP_REGROWTH_TIME, "kyno_turnip_cave", function()
		return TUNING.KYNO_TURNIP_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_fennel_ground", TUNING.KYNO_FENNEL_REGROWTH_TIME, "kyno_fennel_ground", function()
		return TUNING.KYNO_FENNEL_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_parznip_ground", TUNING.KYNO_PARZNIP_REGROWTH_TIME, "kyno_parznip_ground", function()
		return TUNING.KYNO_PARZNIP_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_parznip_big", TUNING.KYNO_PARZNIP_BIG_REGROWTH_TIME, "kyno_parznip_big", function()
		return TUNING.KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_aspargos_ground", TUNING.KYNO_ASPARGOS_REGROWTH_TIME, "kyno_aspargos_ground", function()
		return TUNING.KYNO_ASPARGOS_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_aspargos_cave", TUNING.KYNO_ASPARGOS_REGROWTH_TIME, "kyno_aspargos_cave", function()
		return TUNING.KYNO_ASPARGOS_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_truffles_ground", TUNING.KYNO_TRUFFLES_REGROWTH_TIME, "kyno_truffles_ground", function()
		return not (_worldstate.isday) and TUNING.KYNO_TRUFFLES_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_limpetrock", TUNING.KYNO_LIMPETROCK_REGROWTH_TIME, "kyno_limpetrock", function()
		return not (_worldstate.isnight) and TUNING.KYNO_LIMPETROCK_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_rockflippable", TUNING.KYNO_FLIPPABLE_REGROWTH_TIME, "kyno_rockflippable", function()
		return not (_worldstate.isday) and TUNING.KYNO_FLIPPABLE_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_rockflippable_cave", TUNING.KYNO_FLIPPABLE_REGROWTH_TIME, "kyno_rockflippable_cave", function()
		return TUNING.KYNO_FLIPPABLE_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_wildwheat", TUNING.KYNO_WILDWHEAT_REGROWTH_TIME, "kyno_wildwheat", function()
		return TUNING.KYNO_WILDWHEAT_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_spotbush", TUNING.KYNO_SPOTBUSH_REGROWTH_TIME, "kyno_spotbush", function()
		return TUNING.KYNO_SPOTBUSH_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_pineapplebush", TUNING.KYNO_PINEAPPLEBUSH_REGROWTH_TIME, "kyno_pineapplebush", function()
		return ((_worldstate.issummer or _worldstate.isspring) and TUNING.KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT or 0)
	end)

	self:SetRegrowthForType("kyno_meadowisland_sandhill", TUNING.KYNO_MEADOWISLAND_SAND_REGROWTH_TIME, "kyno_meadowisland_sandhill", function()
		return TUNING.KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_sugartree_flower", TUNING.KYNO_SUGARFLOWER_REGROWTH_TIME, "kyno_sugartree_flower", function()
		return ((_worldstate.israining or _worldstate.isnight or _worldstate.iswinter or _worldstate.wetness <= 1 or _worldstate.snowlevel > 0) and 0)
		or (_worldstate.isspring and 2 * TUNING.KYNO_SUGARFLOWER_REGROWTH_TIME_MULT) or TUNING.KYNO_SUGARFLOWER_REGROWTH_TIME_MULT
	end)

	-- Ocean.
	self:SetRegrowthForType("kyno_cucumber_ground", TUNING.KYNO_CUCUMBER_REGROWTH_TIME, "kyno_cucumber_ground", function()
		return TUNING.KYNO_CUCUMBER_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_waterycress_ocean", TUNING.KYNO_WATERYCRESS_REGROWTH_TIME, "kyno_waterycress_ocean", function()
		return TUNING.KYNO_WATERYCRESS_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_taroroot_ocean", TUNING.KYNO_TAROROOT_REGROWTH_TIME, "kyno_taroroot_ocean", function()
		return TUNING.KYNO_TAROROOT_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_seaweeds_ocean", TUNING.KYNO_WEEDSEA_REGROWTH_TIME, "kyno_seaweeds_ocean", function()
		return TUNING.KYNO_WEEDSEA_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_watery_crate", TUNING.KYNO_CRATE_REGROWTH_TIME, "kyno_watery_crate", function()
		return TUNING.KYNO_CRATE_REGROWTH_TIME_MULT or 0
	end)

	self:SetRegrowthForType("kyno_ocean_wreck", TUNING.KYNO_OCEAN_WRECK_REGROWTH_TIME, "kyno_ocean_wreck", function()
		return TUNING.KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT or 0
	end)
end)