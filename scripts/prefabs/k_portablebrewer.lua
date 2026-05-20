require("prefabutil")

local brewing = require("hof_brewing")
local TOTAL_BREWING_TIME = TUNING.TOTAL_DAY_TIME -- 480

local assets =
{
	Asset("ANIM", "anim/ui_brewer_1x3.zip"),

	Asset("ANIM", "anim/portable_cook_pot.zip"),
	Asset("ANIM", "anim/cook_pot_food.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),

	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local assets_item =
{
	Asset("ANIM", "anim/portable_cook_pot.zip"),
}

local prefabs =
{
	"collapse_small",
	"kyno_portablebrewer_item",
}

local prefabs_item =
{
	"kyno_portablebrewer",
}

for k, v in pairs(brewing.recipes.kyno_woodenkeg) do
	table.insert(prefabs, v.name)
end

for k, v in pairs(brewing.recipes.kyno_preservesjar) do
	table.insert(prefabs, v.name)
end

local function OnChangeToItem(inst)
	if inst.components.brewer.product ~= nil and inst.components.brewer:IsDone() then
		inst.components.brewer:Harvest()
	end

	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end

	local item = SpawnPrefab("kyno_portablebrewer_item")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())

	item.AnimState:PlayAnimation("collapse")
	item.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_destroy")
end

local function OnHammered(inst)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end

	if inst:HasTag("burnt") then
		inst.components.lootdropper:SpawnLootPrefab("ash")
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("metal")
	else
		OnChangeToItem(inst)
	end

	inst:Remove()
end

local function OnHit(inst)
	if not inst:HasTag("burnt") then
		if inst.components.brewer ~= nil then
			if inst.components.brewer:IsCooking() then
				-- inst.AnimState:PlayAnimation("hit")
				-- inst.AnimState:PushAnimation("brew_loop", true)
				inst.AnimState:PlayAnimation("hit_cooking")
				inst.AnimState:PushAnimation("cooking_loop", true)
			elseif inst.components.brewer:IsDone() then
				-- inst.AnimState:PlayAnimation("hit")
				-- inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:PlayAnimation("hit_full")
				inst.AnimState:PushAnimation("idle_full", false)
			else
				if inst.components.container ~= nil and inst.components.container:IsOpen() then
					inst.components.container:Close()
				end

				-- inst.AnimState:PlayAnimation("hit")
				-- inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:PlayAnimation("hit_empty")
				inst.AnimState:PushAnimation("idle_empty", false)
			end
		end
	end
end

local function StartCookFn(inst)
	if not inst:HasTag("burnt") then
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			-- inst.AnimState:PlayAnimation("close")
			-- inst.AnimState:PushAnimation("brew_loop", true)
			inst.AnimState:PlayAnimation("cooking_loop", true)
		else
			-- inst.AnimState:PushAnimation("brew_loop", true)
			inst.AnimState:PlayAnimation("cooking_loop", true)
		end

		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_loop", "brew_loop")
	end
end

local function OnOpen(inst)
	if not inst:HasTag("burnt") then
		-- inst.AnimState:PlayAnimation("open")
		-- inst.AnimState:PushAnimation("idle_open", true)
		inst.AnimState:PlayAnimation("cooking_pre_loop")

		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end
end

local function OnClose(inst)
	if not inst:HasTag("burnt") then
		if not inst.components.brewer:IsCooking() then
			-- inst.AnimState:PlayAnimation("close")
			inst.AnimState:PlayAnimation("idle_empty")
			inst.SoundEmitter:KillSound("brew_loop")
		end

		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end
end

local function SetProductSymbol(inst, product, overridebuild)
	local recipe = brewing.GetBrewing(inst.prefab, product)
	local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

	inst.AnimState:ShowSymbol("product_sign")
	inst.AnimState:ShowSymbol("product_image")
	inst.AnimState:OverrideSymbol("product_image", resolvefilepath("images/inventoryimages/hof_inventoryimages.xml"), overridesymbol..".tex")
end

local function ShowProductImage(inst)
	if not inst:HasTag("burnt") then
		local product = inst.components.brewer.product
		SetProductSymbol(inst, product, IsModBrewingProduct(inst.prefab, product) and product or nil)
	end
end

local function HideProductImage(inst)
	inst.AnimState:HideSymbol("goop")
	inst.AnimState:HideSymbol("product_sign")
	inst.AnimState:HideSymbol("product_image")

	inst.AnimState:ClearOverrideSymbol("goop")
	inst.AnimState:ClearOverrideSymbol("product_image")
end

local function DoneCookFn(inst, product)
	if not inst:HasTag("burnt") then
		ShowProductImage(inst)

		inst.AnimState:ShowSymbol("goop")

		local recipe = inst.components.brewer ~= nil and inst.components.brewer.product

		if recipe ~= nil and recipe == "wetgoop2" then
			inst.AnimState:OverrideSymbol("goop", "portable_cook_pot", "goop_spoiled")
		else
			inst.AnimState:OverrideSymbol("goop", "portable_cook_pot", "goop")
		end

		-- inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:PushAnimation("idle_full", false)

		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_harvest")
	end
end

local function ContinueDoneFn(inst, product)
	if not inst:HasTag("burnt") then
		ShowProductImage(inst)

		inst.AnimState:ShowSymbol("goop")

		local recipe = inst.components.brewer ~= nil and inst.components.brewer.product

		if recipe ~= nil and recipe == "wetgoop2" then
			inst.AnimState:OverrideSymbol("goop", "portable_cook_pot", "goop_spoiled")
		else
			inst.AnimState:OverrideSymbol("goop", "portable_cook_pot", "goop")
		end

		-- inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:PushAnimation("idle_full", false)
	end
end

local function ContinueCookFn(inst)
	if not inst:HasTag("burnt") then
		-- inst.AnimState:PlayAnimation("brew_loop", true)
		inst.AnimState:PlayAnimation("cooking_loop", true)

		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_loop", "brew_loop")
	end
end

local function HarvestFn(inst, harvester)
	if not inst:HasTag("burnt") then
		-- inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:PlayAnimation("idle_empty")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end

	HideProductImage(inst)
end

local function OnBurnt(inst)
	DefaultBurntStructureFn(inst)
	RemovePhysicsColliders(inst)

	SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

	HideProductImage(inst)
	inst.SoundEmitter:KillSound("brew_loop")

	if inst.components.workable ~= nil then
		inst:RemoveComponent("workable")
	end

	if inst.components.portablestructure ~= nil then
		inst:RemoveComponent("portablestructure")
	end

	inst.persists = false

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst:ListenForEvent("animover", ErodeAway)
	inst.AnimState:PlayAnimation("burnt_collapse")
end

local function OnDismantle(inst)
	OnChangeToItem(inst)
	inst:Remove()
end

local function OnDeploy(inst, pt, deployer)
	local brewer = SpawnPrefab("kyno_portablebrewer")
	
	if brewer ~= nil then
		brewer.Physics:SetCollides(false)
		brewer.Physics:Teleport(pt.x, 0, pt.z)
		brewer.Physics:SetCollides(true)

		brewer.AnimState:PlayAnimation("place")
		brewer.AnimState:PushAnimation("idle_empty", false)
		brewer.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")

		inst:Remove()
		PreventCharacterCollisionsWithPlacedObjects(brewer)
	end
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable:IsBurning() and "BURNT")
	or (inst.components.brewer:IsDone() and "DONE")
	or (not inst.components.brewer:IsCooking() and "EMPTY")
	or (inst.components.brewer:GetTimeToCook() > TOTAL_BREWING_TIME * 2 and "BREWING_LONG")
	or "BREWING_SHORT"
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.burnt then
		if inst.components.burnable ~= nil then
			inst.components.burnable.onburnt(inst)
			OnBurnt(inst)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portablecookpot.png")

	inst:SetDeploySmartRadius(DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT] / 2)
	inst:SetPhysicsRadiusOverride(.5)

	MakeObstaclePhysics(inst, inst.physicsradiusoverride)

	inst.AnimState:SetBank("portable_cook_pot")
	inst.AnimState:SetBuild("portable_cook_pot")
	inst.AnimState:PlayAnimation("idle_empty")

	inst:AddTag("brewer")
	inst:AddTag("structure")
	inst:AddTag("mastercookware")
	inst:AddTag("cook_robot_cooker_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			if not inst:HasTag("burnt") then
				inst.replica.container:WidgetSetup("brewer")
			end
		end

		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("portablestructure")
	inst.components.portablestructure:SetOnDismantleFn(OnDismantle)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("brewer")
	inst.components.brewer.brewtimemult = .1--TUNING.PORTABLE_COOK_POT_TIME_MULTIPLIER -- .8
	inst.components.brewer.onstartcooking = StartCookFn
	inst.components.brewer.oncontinuecooking = ContinueCookFn
	inst.components.brewer.oncontinuedone = ContinueDoneFn
	inst.components.brewer.ondonecooking = DoneCookFn
	inst.components.brewer.onharvest = HarvestFn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("brewer")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(2)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	inst.components.burnable:SetFXLevel(2)
	inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

local function itemfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.1, 0.8)

	inst.AnimState:SetBank("portable_cook_pot")
	inst.AnimState:SetBuild("portable_cook_pot")
	inst.AnimState:PlayAnimation("idle_ground")

	inst:AddTag("portableitem")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("deployable")
	inst.components.deployable.restrictedtag = "masterchef"
	inst.components.deployable.ondeploy = OnDeploy

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("kyno_portablebrewer", fn, assets, prefabs),
Prefab("kyno_portablebrewer_item", itemfn, assets_item, prefabs_item),
MakePlacer("kyno_portablebrewer_item_placer", "portable_cook_pot", "portable_cook_pot", "idle_empty")