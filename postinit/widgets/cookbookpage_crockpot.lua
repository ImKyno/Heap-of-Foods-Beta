local _G = GLOBAL

-- Fake stats for showing nice values on Cookbook.
-- i.e: Wortox loses sanity if he's Nice inclined, but will show as positive values.
AddClassPostConstruct("widgets/redux/cookbookpage_crockpot", function(self)
	local _PopulateRecipeDetailPanel = self.PopulateRecipeDetailPanel

	function self:PopulateRecipeDetailPanel(data)
		if data and data.recipe_def then
			data.recipe_def.health = data.recipe_def.health2 or data.recipe_def.health
			data.recipe_def.hunger = data.recipe_def.hunger2 or data.recipe_def.hunger
			data.recipe_def.sanity = data.recipe_def.sanity2 or data.recipe_def.sanity
		end

		return _PopulateRecipeDetailPanel(self, data)
	end
end)