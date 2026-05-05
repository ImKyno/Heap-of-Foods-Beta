local DailyRecipe = Class(function(self, inst)
	self.inst = inst

	self.recipes = nil
	self.excluded = {}
	self.forced = nil

	self.custom_seed = nil
end)

local ROTATION_SECONDS = 24 * 60 * 60

-- This list needs to be exactly like the website's list (sort/order).
-- Seasonal Recipes can be disabled by players and this WILL change the list...
local RECIPES_LIST =
{
	"recipes_cookpot",          -- 1
	"recipes_cookpot_warly",    -- 2
	"recipes_cookpot_jar",      -- 4
	"recipes_cookpot_keg",      -- 5
}

-- Hash convertion for Lua <> JavaScript so we can use the same Seed.
local function JSHash(seed)
	local v = (seed * 1103515245 + 12345)
	local wrapped = v % 4294967296
	return wrapped % 2147483647
end

local function CollectRecipes()
	local list = {}

	for _, modname in ipairs(RECIPES_LIST) do
		local ok, recipes = pcall(require, "website/" .. modname)

		-- print("Heap of Foods Mod - DailyRecipe: LOADING", modname, ok, recipes and "OK" or "NIL")

		if ok and type(recipes) == "table" then
			for _, recipe in ipairs(recipes) do
				if recipe ~= nil then
					table.insert(list, recipe)
				end
			end
		end
	end

	return list
end

function DailyRecipe:GetDailySeed()
	if self.custom_seed then
		return self.custom_seed
	end

	return math.floor(os.time() / ROTATION_SECONDS)
end

function DailyRecipe:SetDailySeed(seed)
	if not TheWorld.ismastersim then
		return
	end

	self.custom_seed = seed
end

function DailyRecipe:ClearDailySeed()
	if not TheWorld.ismastersim then
		return
	end

	self.custom_seed = nil
end

function DailyRecipe:GetValidRecipes()
	if not self.recipes then
		self.recipes = CollectRecipes()
	end

	local valid = {}

	for _, recipe in ipairs(self.recipes) do
		if recipe ~= nil and not self.excluded[recipe] then
			table.insert(valid, recipe)
		end
	end

	return valid
end

function DailyRecipe:GetAllRecipes()
	if not self.recipes then
		self.recipes = CollectRecipes()
	end

	return self.recipes
end

function DailyRecipe:GetValidRecipeCount()
	return #self:GetValidRecipes()
end

function DailyRecipe:GetCurrentRecipe()
	if self.forced then
		return self.forced
	end

	local list = self:GetValidRecipes()

	if not list or #list == 0 then
		return "None"
	end

	local seed = self:GetDailySeed()
	local hash = JSHash(seed)
	local index = (hash % #list) + 1

	local recipe = list[index]

	--[[
	print("Heap of Foods Mod - DailyRecipe: Seed", seed)
	print("Heap of Foods Mod - DailyRecipe: Index", index)
	print("Heap of Foods Mod - DailyRecipe: Recipe", recipe)
	print("Heap of Foods Mod - DailyRecipe: List Size", #list)
	print("Heap of Foods Mod - DailyRecipe: First 20 Recipes")

	for i = 1, 20 do
    	print(i, list[i])
	end
	]]--

	-- return recipe or "None"
	return list[index]
end

function DailyRecipe:GetDailyRecipe(recipe)
	local recipe = self:GetCurrentRecipe()

	if recipe == nil then
		return "None"
	end

	local key = string.upper(recipe)
	local name = STRINGS.NAMES[key] or recipe

	return string.format("%s [%s]", name, recipe)
end

function DailyRecipe:ForceRecipe(recipe)
	self.forced = recipe
end

function DailyRecipe:ClearForcedRecipe()
	self.forced = nil
end

function DailyRecipe:ExcludeRecipe(recipe)
	self.excluded[recipe] = true
end

function DailyRecipe:IncludeRecipe(recipe)
	self.excluded[recipe] = nil
end

function DailyRecipe:ClearExclusions()
	self.excluded = {}
end

return DailyRecipe