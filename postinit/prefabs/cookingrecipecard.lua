local _G = GLOBAL

-- For trading and learning Recipe Cards.
local function CookingRecipeCardPostInit(inst)
	inst:AddTag("learnablerecipecard")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("tradable")
	inst:AddComponent("learnablerecipecard")
end

AddPrefabPostInit("cookingrecipecard", CookingRecipeCardPostInit)