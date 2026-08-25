local _G                  = GLOBAL
local HOF_ALCOHOLICDRINKS = GetModConfigData("ALCOHOLICDRINKS")

AddComponentPostInit("eater", function(self)
	local _PrefersToEat = self.PrefersToEat

	function self:PrefersToEat(food, ...)
		-- This will prevent some characters from drinking Alcoholic-like drinks.
		if HOF_ALCOHOLICDRINKS and food:HasTag("alcoholic_drink") and self.inst.tagvar_no_alcoholic_drinker then
			return false
		end

		-- Wormwood can eat prepared foods made with fertilizers.
		if self.inst:HasTag("plantkin") and food.components.edible ~= nil 
		and food.components.edible.foodtype == _G.FOODTYPE.PREPAREDPOOP then
			return true
		end

		-- Wortox can eat prepared foods made with souls.
		if self.inst:HasTag("souleater") and food.components.edible ~= nil
		and food.components.edible.foodtype == _G.FOODTYPE.PREPAREDSOUL then
			return true
		end

		-- Cannot eat Shimmer/Enchanted Foods while under the effects of Food Healing Sickness.
		if self.inst.components.debuffable ~= nil and self.inst.components.debuffable:HasDebuff("kyno_healingsicknessbuff")
		and food:HasAnyTag("shimmerfood", "enchantedfood") then
			return false
		end

		return _PrefersToEat(self, food, ...)
	end
end)