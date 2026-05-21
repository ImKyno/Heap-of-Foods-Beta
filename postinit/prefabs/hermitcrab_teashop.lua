local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local PEARL_TEAS =
{
	"kyno_hermitcrabtea_aloe",
	"kyno_hermitcrabtea_sugartree_petals",
}

local function HermitCrabTeaShopPostInit(inst)
	local TEA_RECIPES = UpvalueHacker.GetUpvalue(_G.Prefabs.hermitcrab_teashop.fn, "MakePrototyper", "UpdateRecipes", "TEA_RECIPES")
	
	for k, v in pairs(PEARL_TEAS) do
		table.insert(TEA_RECIPES, v)
	end
end

AddPrefabPostInit("hermitcrab_teashop", HermitCrabTeaShopPostInit)