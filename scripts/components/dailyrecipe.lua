local cooking = require("cooking")
local brewing = require("hof_brewing")
local DAILY_RECIPES = require("hof_dailyrecipes")

-- c_announce(TheWorld.net.components.dailyrecipe:GetDailyRecipe())
-- print(require("hof_dailyrecipes").GetDailyRecipe())
-- print(TheWorld.net._dailyrecipe:value())

local function GetDailyRecipeDef(prefab)
	if cooking ~= nil and cooking.cookbook_recipes ~= nil then
		for category, list in pairs(cooking.cookbook_recipes) do
			if list[prefab] ~= nil then
				return { def = list[prefab], system = "cooking", category = category }
			end
		end
	end

	if brewing ~= nil and brewing.brewbook_recipes ~= nil then
		for category, list in pairs(brewing.brewbook_recipes) do
			if list[prefab] ~= nil then
				return { def = list[prefab], system = "brewing", category = category }
			end
		end
	end

	return nil
end

local function GetDailyRecipeCard(recipe)
	if cooking ~= nil and cooking.recipe_cards ~= nil then
		for _, card in ipairs(cooking.recipe_cards) do
			if card.recipe_name == recipe then
				return { cooker = card.cooker_name }
			end
		end
	end

	if brewing ~= nil and brewing.recipe_cards ~= nil then
		for _, card in ipairs(brewing.recipe_cards) do
			if card.recipe_name == recipe then
				return { cooker = card.brewer_name }
			end
		end
	end

	return nil
end

local DailyRecipe = Class(function(self, inst)
	self.inst = inst

	self.excluded = {}
	self.custom_seed = nil
	self.forced_recipe = nil

	self._task = inst:DoPeriodicTask(10, function()
		self:CheckForUpdate()
	end, 0)
end)

-- Please only force recipes when testing something.
-- It is highly unrecommended for actual gameplay, since it changes the Seed and messes with clients.
-- Forced Daily Recipes WILL NOT be saved during onload to preserve data!
-- Do not call this directly! Use the command instead: c_hofforcedailyrecipe(recipe)
function DailyRecipe:SetForcedDailyRecipe(recipe, sync)
	if TUNING.HOF_DEBUG_MODE or TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
		sync = sync ~= false

		self.forced_recipe = recipe
		self.current_recipe = recipe

		if self.inst._dailyrecipe ~= nil then
			self.inst._dailyrecipe:set(recipe or "")
		end

		self.inst:PushEvent("dailyrecipechanged", { old = self.current_recipe, new = recipe })

		if sync then
			SendModRPCToShard(GetShardModRPC("DailyRecipe", "SetForcedDailyRecipe"), nil, recipe)
		end
	end
end

function DailyRecipe:GetForcedDailyRecipe()
	return self.forced_recipe
end

function DailyRecipe:ClearForcedDailyRecipe()
	self:SetForcedDailyRecipe(nil)
end

function DailyRecipe:GetDailyRecipe()
	if self.forced_recipe ~= nil then
		return self.forced_recipe
	end

	return DAILY_RECIPES.GetDailyRecipe(self.custom_seed, self.excluded)
end

-- Format: Fancy Name
function DailyRecipe:GetDailyRecipeName()
	local recipe = self:GetDailyRecipe()

	if recipe == nil then
		return "None"
	end

	local key = string.upper(recipe)
	return STRINGS.NAMES[key] or recipe
end

-- Format: Fancy Name [prefab]
function DailyRecipe:GetDailyRecipePrefab()
	local recipe = self:GetDailyRecipe()

	if recipe == nil then
		return "None"
	end

	local key = string.upper(recipe)
	local name = STRINGS.NAMES[key] or recipe

	return string.format("%s [%s]", name, recipe)
end

function DailyRecipe:GetDailyRecipeTimeLeft()
	local timeleft = DAILY_RECIPES.GetDailyRecipeTimeLeft()
	return timeleft
end

function DailyRecipe:GetDailyRecipeData(prefab)
	local data = GetDailyRecipeDef(prefab)
	local carddata = GetDailyRecipeCard(prefab)

	return 
	{
		prefab     = prefab,
		name       = STRINGS.NAMES[string.upper(prefab)] or prefab,

		recipe_def = data and data.def or nil,
		system     = data and data.system or nil,
		category   = data and data.category or nil,


		cooker     = carddata and carddata.cooker or nil,
		recipes    = nil,
	}
end

function DailyRecipe:CheckForUpdate()
	if self.forced_recipe ~= nil then
		if self.inst._dailyrecipe ~= nil then
			self.inst._dailyrecipe:set(self.forced_recipe or "")
		end

		return
	end

	local recipe_old = self.current_recipe
	local recipe_new = self:GetDailyRecipe()

	if recipe_old ~= recipe_new then
		if self.inst._dailyrecipe ~= nil then
			self.inst._dailyrecipe:set(recipe_new or "")
		end

		self.inst:PushEvent("dailyrecipechanged", { old = recipe_old, new = recipe_new })
		self.current_recipe = recipe_new
	end
end

function DailyRecipe:OnPostInit()
	local recipe = self:GetDailyRecipe()

	self.current_recipe = recipe
	
	self.inst:DoTaskInTime(0, function()
		if self.inst._dailyrecipe ~= nil then
			self.inst._dailyrecipe:set(recipe or "")
		end

		if self._task == nil then
			self._task = inst:DoPeriodicTask(10, function()
				self:CheckForUpdate()
			end, 0)
		end
	end)
end

return DailyRecipe