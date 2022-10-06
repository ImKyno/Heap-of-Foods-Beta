local brewing = require("hof_brewing")

local assets =
{
    Asset("ANIM", "anim/kyno_brewingrecipecard.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function SetRecipe(inst, recipe_name, brewer_name)
    inst.recipe_name = recipe_name
    inst.brewer_name = brewer_name

    inst.components.named:SetName(subfmt(STRINGS.NAMES.KYNO_BREWINGRECIPECARD, { item = STRINGS.NAMES[string.upper(recipe_name)] or recipe_name }))
end

local function PickRandomRecipe(inst)
	local card = brewing.recipe_cards[math.random(#brewing.recipe_cards)]
	SetRecipe(inst, card.recipe_name, card.brewer_name)
end

local function GetDesc(inst, viewer)
	local brewer_recipes = brewing.recipes[inst.brewer_name]
	if brewer_recipes then
		local card = brewer_recipes[inst.recipe_name] and brewer_recipes[inst.recipe_name].card_def
		if card then
			local ing_str = subfmt(STRINGS.COOKINGRECIPECARD_DESC.INGREDIENTS_FIRST, {num = card.ingredients[1][2], ing = STRINGS.NAMES[string.upper(card.ingredients[1][1])]})
			for i = 2, #card.ingredients do
				ing_str = ing_str .. subfmt(STRINGS.COOKINGRECIPECARD_DESC.INGREDIENTS_MORE, {num = card.ingredients[i][2], ing = STRINGS.NAMES[string.upper(card.ingredients[i][1])]})
			end

			return subfmt(STRINGS.COOKINGRECIPECARD_DESC.BASE, {name = STRINGS.NAMES[string.upper(inst.recipe_name)], ingredients = ing_str})
		end
	end

	return nil
end

local function OnSave(inst, data)
    data.r = inst.recipe_name
    data.b = inst.brewer_name
end

local function OnLoad(inst, data)
	if data ~= nil then
		SetRecipe(inst, data.r, data.b)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("kyno_brewingrecipecard")
    inst.AnimState:SetBuild("kyno_brewingrecipecard")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("brewingrecipecard")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("named")
	inst:AddComponent("erasablepaper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.getspecialdescription = GetDesc

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_brewingrecipecard"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	PickRandomRecipe(inst)

    return inst
end

return Prefab("kyno_brewingrecipecard", fn, assets)