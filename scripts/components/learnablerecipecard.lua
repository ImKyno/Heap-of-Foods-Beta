local cooking = require("cooking")
local brewing = require("hof_brewing")

local function onlearnable(self)
    if self.canlearn then
        self.inst:AddTag("learnablerecipecard")
    else
        self.inst:RemoveTag("learnablerecipecard")
    end
end

local function GetIngredients(card)
    local ret = {}
	
    for i, data in pairs(card.ingredients) do
        for j=1, data[2] do
          table.insert(ret, data[1])
        end
    end

    return ret
end

local LearnableRecipeCard = Class(function(self, inst)
	self.inst = inst
end,
nil,
{
	canlearn = onlearnable,
})

function LearnableRecipeCard:OnLearn(inst, doer)
    local item = self.inst
	local cooker_recipes = cooking.recipes[item.cooker_name]
	local brewer_recipes = brewing.recipes[item.brewer_name]
	
	if item:HasTag("brewingrecipecard") then
		if brewer_recipes then
			local card_def = brewer_recipes[item.recipe_name] and brewer_recipes[item.recipe_name].card_def
			doer:PushEvent("learncookbookrecipe", {doer = doer, product = item.recipe_name, ingredients = GetIngredients(card_def)})
			-- self.inst:TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
			
			item:Remove()
		end
	else
		if cooker_recipes then
			local card_def = cooker_recipes[item.recipe_name] and cooker_recipes[item.recipe_name].card_def
			doer:PushEvent("learncookbookrecipe", {doer = doer, product = item.recipe_name, ingredients = GetIngredients(card_def)})

			item:Remove()
		end
	end
end

return LearnableRecipeCard