local cooking = require("cooking")
local brewing = require("hof_brewing")

local ROTATION_SECONDS = 24 * 60 * 60

-- This list needs to be exactly like the website's list (sort/order).
-- Seasonal Recipes can be disabled by players and this WILL lock out some recipes...
local WEB_RECIPES_LIST =
{
	"hof_recipes_cookpot",          -- 1
	"hof_recipes_cookpot_warly",    -- 2
	"hof_recipes_cookpot_seasonal", -- 3
	"hof_recipes_cookpot_jar",      -- 4
	"hof_recipes_cookpot_keg",      -- 5
}

local MOD_RECIPES_LIST =
{
	"hof_foodrecipes",
	"hof_foodrecipes_warly",
	"hof_foodrecipes_seasonal",
	"hof_brewrecipes_jar",
	"hof_brewrecipes_keg",
}

local CARD_DEFS = {}

local RECIPES_BLACKLIST =
{
	["gorge_bread"]   = true,
	["kyno_syrup"]    = true,
	["littlebread"]   = true,
	["watercup"]      = true,
}

-- Hash convertion for Lua <> JavaScript so we can use the same Seed.
local function JSHash(seed)
	local v = (seed * 1103515245 + 12345)
	local wrapped = v % 4294967296
	return wrapped % 2147483647
end

local function GetDailySeed(custom_seed)
	if custom_seed then
		return custom_seed
	end

	return math.floor(os.time() / ROTATION_SECONDS)
end

local function CollectRecipes()
	local list = {}

	for _, modname in ipairs(WEB_RECIPES_LIST) do
		local ok, recipes = pcall(require, "tools/website/" .. modname)

		if TUNING.HOF_DEBUG_MODE or TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
			print("Heap of Foods Mod - DailyRecipe: LOADING", modname, ok, recipes and "OK" or "NIL")
		end

		if ok and type(recipes) == "table" then
			for _, recipe in ipairs(recipes) do
				table.insert(list, recipe)
			end
		end
	end

	return list
end

local function CollectIngredients()
	local list = {}

	for _, modname in ipairs(MOD_RECIPES_LIST) do
		local ok, recipes = pcall(require, modname)

		if TUNING.HOF_DEBUG_MODE or TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
			print("Heap of Foods Mod - DailyRecipe: LOADING", modname, ok, type(recipes))
		end

		if ok and type(recipes) == "table" then
			for k, v in pairs(recipes) do
				if v ~= nil then
					CARD_DEFS[k] = v

					if v.card_def then
						if TUNING.HOF_DEBUG_MODE or TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
							print("Heap of Foods Mod - DailyRecipe: CARD_DEF", k)
						end
					end
				end
			end
		end
	end

	return list
end

CollectIngredients()

local function GetBlacklistRecipes(recipe, excluded)
	if RECIPES_BLACKLIST[recipe] then
		return true
	end

	if excluded and excluded[recipe] then
		return true
	end

	return false
end

local function GetDailyRecipeSeed(custom_seed, excluded)
	local recipes = CollectRecipes()

	local valid = {}

	for _, r in ipairs(recipes) do
		if not GetBlacklistRecipes(r, excluded) then
			table.insert(valid, r)
		end
	end

	if #valid == 0 then
		return "None"
	end

	local seed = GetDailySeed(custom_seed)
	local hash = JSHash(seed)
	local index = (hash % #valid) + 1

	return valid[index]
end

local function GetDailyRecipe()
	local shard = TheWorld.net

	if shard ~= nil and shard._dailyrecipe ~= nil then
		local recipe = shard._dailyrecipe:value()

		if recipe ~= nil and recipe ~= "" then
			return recipe
		end
	end

	return GetDailyRecipeSeed()
end

local function GetDailyRecipeName()
	local recipe = GetDailyRecipe()

	if recipe == nil then
		return "None"
	end

	local key = string.upper(recipe)
	return STRINGS.NAMES[key] or recipe
end

local function GetDailyRecipePrefab()
	local recipe = GetDailyRecipe()

	if recipe == nil then
		return "None"
	end

	local key = string.upper(recipe)
	local name = STRINGS.NAMES[key] or recipe

	return string.format("%s [%s]", name, recipe)
end

local function GetDailyRecipeTimeLeft()
	local current_time = os.time()

	local elapsed = current_time % ROTATION_SECONDS
	local remaining = ROTATION_SECONDS - elapsed

	if remaining >= ROTATION_SECONDS then
		remaining = 0
	end

	local hours = math.floor(remaining / 3600)
	local minutes = math.floor((remaining % 3600) / 60)
	local seconds = remaining % 60

	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

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

local function GetDailyRecipeData(prefab)
	local data = GetDailyRecipeDef(prefab)
	local carddata = GetDailyRecipeCard(prefab)
	local card = CARD_DEFS[prefab]

	return {
		prefab     = prefab,
		name       = STRINGS.NAMES[string.upper(prefab)] or prefab,

		recipe_def = data and data.def or nil,
		system     = data and data.system or nil,
		category   = data and data.category or nil,

		cooker     = carddata and carddata.cooker or nil,
		recipes    = card and card.card_def and card.card_def.ingredients or nil,
	}
end

return 
{
	GetDailyRecipe         = GetDailyRecipe,
	GetDailyRecipeName     = GetDailyRecipeName,
	GetDailyRecipePrefab   = GetDailyRecipePrefab,
	GetDailyRecipeTimeLeft = GetDailyRecipeTimeLeft,
	GetDailyRecipeData     = GetDailyRecipeData,
}