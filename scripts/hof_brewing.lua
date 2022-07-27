require "tuning"

local official_foods = {}
local brewerrecipes = {}
local brewbook_recipes = {}

local MOD_BREWBOOK_CATEGORY = "mod"

global("AddBrewerRecipe")
AddBrewerRecipe = function(brewer, recipe, is_mod_food)
	if is_mod_food then
		recipe.brewbook_category = recipe.brewbook_category or MOD_BREWBOOK_CATEGORY
	else
		official_foods[recipe.name] = true
		recipe.brewbook_atlas = "images/cookbook_"..recipe.name..".xml"
	end

	if not brewerrecipes[brewer] then
		brewerrecipes[brewer] = {}
	end
	brewerrecipes[brewer][recipe.name] = recipe

	if brewer ~= "portablespicer" and not recipe.no_brewbook then
		if not brewbook_recipes[recipe.brewbook_category] then
			brewbook_recipes[recipe.brewbook_category] = {}
		end
		if not brewbook_recipes[recipe.brewbook_category][recipe.name] then
			brewbook_recipes[recipe.brewbook_category][recipe.name] = recipe
		end
	end
end

local function IsModBrewerFood(prefab)
	return not official_foods[prefab]
end

local function HasModBrewerFood()
	return brewbook_recipes[MOD_BREWBOOK_CATEGORY] ~= nil
end

local brewingredients = {}

global("AddBrewingValues")
AddBrewingValues = function(names, tags, cancook, candry)
	for _, name in pairs(names) do
		brewingredients[name] = { tags= {}}

		if cancook then
			brewingredients[name.."_cooked"] = {tags={}}
		end

		if candry then
			brewingredients[name.."_dried"] = {tags={}}
		end

		for tagname,tagval in pairs(tags) do
			brewingredients[name].tags[tagname] = tagval

			if cancook then
				brewingredients[name.."_cooked"].tags.precook = 1
				brewingredients[name.."_cooked"].tags[tagname] = tagval
			end
			
			if candry then
				brewingredients[name.."_dried"].tags.dried = 1
				brewingredients[name.."_dried"].tags[tagname] = tagval
			end
		end
	end
end

global("IsModBrewingProduct")
IsModBrewingProduct = function(brewer, name)
	local enabledmods = ModManager:GetEnabledModNames()
    for i,v in ipairs(enabledmods) do
        local mod = ModManager:GetMod(v)
        if mod.brewerrecipes and mod.brewerrecipes[brewer] and table.contains(mod.brewerrecipes[brewer], name) then
            return true
        end
    end
    return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ingredients.
--[[
AddBrewingValues({"kyno_wheat"},     {wheat=1})
AddBrewingValues({"kyno_spotspice"}, {spotspice=1})
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local aliases =
{
	cookedsmallmeat = "smallmeat_cooked",
	cookedmonstermeat = "monstermeat_cooked",
	cookedmeat = "meat_cooked",
}

local function IsBrewingIngredient(prefabname)
    return brewingredients[aliases[prefabname] or prefabname] ~= nil
end

-- Brewing Stations.
--[[
local brews = require("hof_foodrecipes_brew")
for k, recipe in pairs (brews) do
	if recipe.keg_product then
		AddBrewerRecipe("kyno_woodenkeg", recipe)
	else
		AddBrewerRecipe("kyno_preservesjar", recipe)
	end
end
]]--

local function GetBrewingValues(prefablist)
    local prefabs = {}
    local tags = {}
    for k,v in pairs(prefablist) do
        local name = aliases[v] or v
        prefabs[name] = (prefabs[name] or 0) + 1
        local data = brewingredients[name]
        if data ~= nil then
            for kk, vv in pairs(data.tags) do
                tags[kk] = (tags[kk] or 0) + vv
            end
        end
    end
    return { tags = tags, names = prefabs }
end

local function GetBrewing(brewer, product)
	local recipes = brewerrecipes[brewer] or {}
	return recipes[product]
end

global("GetCandidateBrewing")
GetCandidateBrewing = function(brewer, ingdata)
	local recipes = brewerrecipes[brewer] or {}
	local candidates = {}

	for k,v in pairs(recipes) do
		if v.test(brewer, ingdata.names, ingdata.tags) then
			table.insert(candidates, v)
		end
	end

	table.sort( candidates, function(a,b) return (a.priority or 0) > (b.priority or 0) end )
	if #candidates > 0 then
		local top_candidates = {}
		local idx = 1
		local val = candidates[1].priority or 0

		for k,v in ipairs(candidates) do
			if k > 1 and (v.priority or 0) < val then
				break
			end
			table.insert(top_candidates, v)
		end
		return top_candidates
	end

	return candidates
end

local function CalculateBrewing(brewer, names)
	local ingdata = GetBrewingValues(names)
	local candidates = GetCandidateBrewing(brewer, ingdata)

	table.sort( candidates, function(a,b) return (a.weight or 1) > (b.weight or 1) end )
	local total = 0
	for k,v in pairs(candidates) do
		total = total + (v.weight or 1)
	end

	local val = math.random()*total
	local idx = 1
	while idx <= #candidates do
		val = val - candidates[idx].weight
		if val <= 0 then
			return candidates[idx].name, candidates[idx].cooktime or 1
		end

		idx = idx+1
	end
end

return { CalculateBrewing = CalculateBrewing, IsBrewingIngredient = IsBrewingIngredient, recipes = brewerrecipes, brewingredients = brewingredients, GetBrewing = GetBrewing, brewbook_recipes = brewbook_recipes, HasModBrewerFood = HasModBrewerFood, IsModBrewerFood = IsModBrewerFood}
