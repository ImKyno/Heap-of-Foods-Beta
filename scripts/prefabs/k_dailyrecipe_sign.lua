require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_dailyrecipe_sign.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"collapse_small",
}

local function OnSpawnRecipeCard(inst)
	if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
		local dailyrecipe = TheWorld.net.components.dailyrecipe

		if dailyrecipe ~= nil then
			local recipe = dailyrecipe:GetDailyRecipe()

			if recipe ~= nil then
				SpawnDailyRecipeCard(recipe, nil, nil, inst)
			end
		end
	end
end

local function OnHammered(inst, worker)
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	OnSpawnRecipeCard(inst)

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")

	inst:Remove()
end

local function OnHit(inst)
	inst.AnimState:PlayAnimation("hit")
end

local function OnPicked(inst, picker)
	inst.AnimState:PlayAnimation("pick")

	inst:DoTaskInTime(0.1, function()
		inst.AnimState:HideSymbol("card")
	end)

	if inst.components.activatable ~= nil then
		inst.components.activatable.inactive = true
	end

	local dailyrecipe = TheWorld.net.components.dailyrecipe

	if dailyrecipe ~= nil then
		local recipe = dailyrecipe:GetDailyRecipe()

		if recipe ~= nil then
			SpawnDailyRecipeCard(recipe, picker)
		end
	end
end

local function OnRegen(inst)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:ShowSymbol("card")

	inst.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")

	if inst.components.activatable ~= nil then
		inst.components.activatable.inactive = false
	end
end

local function OnMakeEmpty(inst)
	inst.AnimState:HideSymbol("card")

	if inst.components.activatable ~= nil then
		inst.components.activatable.inactive = true
	end
end

local function UpdateState(inst)
	if inst.components.activatable ~= nil then
		if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
			inst.components.activatable.inactive = false
		else
			inst.components.activatable.inactive = true
		end
	end
end

local function UpdateRecipeSymbol(inst, data)
	local dailyrecipe = TheWorld.net.components.dailyrecipe
	local product = dailyrecipe ~= nil and dailyrecipe:GetDailyRecipe()

	if product then
		local build = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
		local symbol = product..".tex"

		inst.AnimState:OverrideSymbol("recipe", build, symbol)
	else
		inst.AnimState:OverrideSymbol("recipe", "kyno_dailyrecipe_sign", "recipe")
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")
end

local function OnActivate(inst, doer)
	if doer ~= nil and doer:HasTag("player") then
		doer:ShowPopUp(POPUPS.DAILYRECIPECARD, true)
	end

	UpdateState(inst)
end

local function OnBuilt(inst, data)
	inst.AnimState:PlayAnimation("place")
	inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function OnDrawn(inst, image, src, atlas, bgimage, bgatlas)
	if image == nil then
		return
	end

	local x, y, z = inst.Transform:GetWorldPosition()

	local newsign = SpawnPrefab("kyno_dailyrecipe_sign_decor")
	newsign.Transform:SetPosition(x, y, z)

	if newsign.components.drawable ~= nil then
		newsign.components.drawable:OnDrawn(image, src, atlas, bgimage, bgatlas)
	end

	OnSpawnRecipeCard(inst)

    inst:Remove()
end

local function GetVerb()
	return "DAILYRECIPE"
end

local function GetDescription(inst, viewer)
	local dailyrecipe = TheWorld.net.components.dailyrecipe
	local CHARACTER = STRINGS.CHARACTERS[string.upper(viewer.prefab)]
	local DESCRIBE = CHARACTER and CHARACTER.DESCRIBE.KYNO_DAILYRECIPE_SIGN 
	or STRINGS.CHARACTERS.GENERIC.DESCRIBE.KYNO_DAILYRECIPE_SIGN

	if dailyrecipe ~= nil then
		local recipe = dailyrecipe:GetDailyRecipeName()

		if recipe ~= nil then
			return string.format(DESCRIBE.GENERIC, recipe)
		end
	end

	return DESCRIBE.NONE
end

local function OnEntityWake(inst)
	UpdateState(inst)
	UpdateRecipeSymbol(inst)
end

local function OnEntitySleep(inst)
	UpdateState(inst)
	UpdateRecipeSymbol(inst)
end

local function OnInit(inst)
	UpdateState(inst)
	UpdateRecipeSymbol(inst)
end

local function OnLoad(inst, data)
	UpdateState(inst)
	UpdateRecipeSymbol(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dailyrecipe_sign.tex")

	MakeObstaclePhysics(inst, .4)

	inst.AnimState:SetBank("kyno_dailyrecipe_sign")
	inst.AnimState:SetBuild("kyno_dailyrecipe_sign")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("recipebg")

	inst:AddTag("drawable")
	inst:AddTag("structure")
	inst:AddTag("dailyrecipe_sign")

	inst.GetActivateVerb = GetVerb

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.descriptionfn = GetDescription

	inst:AddComponent("drawable")
	inst.components.drawable:SetOnDrawnFn(OnDrawn)

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.quickaction = true

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
	inst.components.pickable:SetUp(nil, nil)
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.makeemptyfn = OnMakeEmpty
	inst.components.pickable.quickpick = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)

	inst:DoTaskInTime(0, OnInit)

	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("dailyrecipechanged", function(_, data)
		local recipe_old = data ~= nil and data.old or nil
		local recipe_new = data ~= nil and data.new or nil

		if TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
			print("Heap of Foods Mod - Daily Recipe Board: Old Recipe", recipe_old)
			print("Heap of Foods Mod - Daily Recipe Board: New Recipe", recipe_new)
		end

		if recipe_old ~= nil and recipe_new ~= nil and recipe_new ~= recipe_old then
			if inst.components.pickable ~= nil then
				inst.components.pickable:Regen()
			end
		end
		
		UpdateState(inst)
		UpdateRecipeSymbol(inst, data) -- data comes from TheWorld.
	end, TheWorld.net)

	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep

	inst.OnLoad = OnLoad

	MakeSnowCovered(inst)
	SetLunarHailBuildupAmountSmall(inst)

	return inst
end

local function PlacerFn(inst)
	inst.AnimState:Hide("card")
end

return Prefab("kyno_dailyrecipe_sign", fn, assets, prefabs),
MakePlacer("kyno_dailyrecipe_sign_placer", "kyno_dailyrecipe_sign", "kyno_dailyrecipe_sign", "idle", false, nil, nil, nil, nil, nil, PlacerFn)