require("prefabutil")

local brewing = require("hof_brewing")
local TOTAL_BREWING_TIME = TUNING.TOTAL_DAY_TIME -- 480

local assets =
{
	Asset("ANIM", "anim/cook_pot.zip"),
	Asset("ANIM", "anim/cookpot_archive.zip"),
	Asset("ANIM", "anim/cook_pot_food.zip"),

	Asset("ANIM", "anim/ui_brewer_1x3.zip"),

	Asset("ANIM", "anim/kyno_brewers_keg.zip"),
	Asset("ANIM", "anim/kyno_brewers_jar.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),

	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"collapse_small",
	"wetgoop",
	"wetgoop2",

	"kyno_product_bubble",
}

for k, v in pairs(brewing.recipes.kyno_woodenkeg) do
	table.insert(prefabs, v.name)
end

for k, v in pairs(brewing.recipes.kyno_preservesjar) do
	table.insert(prefabs, v.name)
end

local function GetProductIcon(inst)
	if not inst.producticon or not inst.producticon:IsValid() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, 0.01)
		
		inst.producticon = nil
		
		for k, v in pairs(ents) do
			if v.prefab == "kyno_product_bubble" then
				inst.producticon = v
				break
			end
		end
	end
	
	return inst.producticon
end

local function OnHammered(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end

	if not inst:HasTag("burnt") then
		if inst.components.brewer ~= nil and inst.components.brewer.product ~= nil and inst.components.brewer:IsDone() then
			inst.components.brewer:Harvest()
		end
	end

	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_destroy")

	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		if inst.components.brewer ~= nil then
			if inst.components.brewer:IsCooking() then
				inst.AnimState:PlayAnimation("hit")
				inst.AnimState:PushAnimation("brew_loop", true)
			elseif inst.components.brewer:IsDone() then
				inst.AnimState:PlayAnimation("hit")
				inst.AnimState:PushAnimation("idle", true)
			else
				if inst.components.container ~= nil and inst.components.container:IsOpen() then
					inst.components.container:Close()
				end
				
				inst.AnimState:PlayAnimation("hit")
				inst.AnimState:PushAnimation("idle", true)
			end
		end
	end
end

local function StartCookFn(inst)
	if not inst:HasTag("burnt") then
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.AnimState:PlayAnimation("close")
			inst.AnimState:PushAnimation("brew_loop", true)
		else
			inst.AnimState:PushAnimation("brew_loop", true)
		end
		
		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_loop", "brew_loop")
    end
end

local function OnOpen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.AnimState:PushAnimation("idle_open", true)
		
		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end
end

local function OnClose(inst)
	if not inst:HasTag("burnt") then
		if not inst.components.brewer:IsCooking() then
			inst.AnimState:PlayAnimation("close")
			inst.SoundEmitter:KillSound("brew_loop")
		end
		
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end
end

local function SetProductSymbol(inst, product, overridebuild)
	local recipe = brewing.GetBrewing(inst.prefab, product)
	local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

	local product_image = SpawnPrefab("kyno_product_bubble")
	product_image.entity:SetParent(inst.entity)
	product_image.AnimState:SetFinalOffset(5)

	if inst:HasTag("woodenkeg") then
		product_image.AnimState:PlayAnimation("product_keg", false)
	else
		product_image.AnimState:PlayAnimation("product_jar", false)
	end

	product_image.AnimState:OverrideSymbol("product_image", resolvefilepath("images/inventoryimages/hof_inventoryimages.xml"), overridesymbol..".tex")
end

local function ShowProductImage(inst)
	if not inst:HasTag("burnt") then
		local product = inst.components.brewer.product
		SetProductSymbol(inst, product, IsModBrewingProduct(inst.prefab, product) and product or nil)
	end
end

local function DoneCookFn(inst, product)
	if not inst:HasTag("burnt") then
		ShowProductImage(inst)
		inst.AnimState:ShowSymbol("goop")

		local brewer = (inst:HasTag("woodenkeg") and "kyno_brewers_keg") or "kyno_brewers_jar"
		local recipe = inst.components.brewer ~= nil and inst.components.brewer.product

		if recipe ~= nil and recipe == "wetgoop2" then
			inst.AnimState:OverrideSymbol("goop", brewer, "goop_spoiled")
		else
			inst.AnimState:OverrideSymbol("goop", brewer, "goop")
		end
		
		inst.AnimState:PlayAnimation("idle", true)

		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_harvest")
	end
end

local function ContinueDoneFn(inst, product)
	if not inst:HasTag("burnt") then
		ShowProductImage(inst)
		inst.AnimState:ShowSymbol("goop")
		
		local brewer = (inst:HasTag("woodenkeg") and "kyno_brewers_keg") or "kyno_brewers_jar"
		local recipe = inst.components.brewer ~= nil and inst.components.brewer.product

		if recipe ~= nil and recipe == "wetgoop2" then
			inst.AnimState:OverrideSymbol("goop", brewer, "goop_spoiled")
		else
			inst.AnimState:OverrideSymbol("goop", brewer, "goop")
		end
		
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function ContinueCookFn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("brew_loop", true)
		
		inst.SoundEmitter:KillSound("brew_loop")
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_loop", "brew_loop")
	end
end

local function HarvestFn(inst, harvester)
	if not inst:HasTag("burnt") then
		inst.AnimState:HideSymbol("goop")
		inst.AnimState:ClearOverrideSymbol("goop")
		
		inst.AnimState:PlayAnimation("idle", true)
		
		inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
	end

	local product_icon = GetProductIcon(inst)
	
	if product_icon then
		product_icon:Remove()
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.SoundEmitter:PlaySound("hof_sounds/common/brewers/brew_start")
end

local function OnBurnt(inst)
	local product_icon = GetProductIcon(inst)
	
	if product_icon then
		product_icon:Remove()
	end
	
	inst.SoundEmitter:KillSound("brew_loop")
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

local function OnLoadPostPass(inst, newents, data)
	if data and data.additems and inst.components.container ~= nil then
		for i, itemname in ipairs(data.additems) do
			local ent = SpawnPrefab(itemname)
			inst.components.container:GiveItem(ent)
		end
	end
end

local function commonfn(bank, build, minimapicon, tags, physics, scale)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon(minimapicon..".tex")
	
	MakeObstaclePhysics(inst, physics)
	
	inst.AnimState:SetScale(scale or 1, scale or 1, scale or 1)
	
	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:HideSymbol("goop")
	
	inst:AddTag("structure")
	inst:AddTag("brewer")
	inst:AddTag("cook_robot_cooker_valid")
	
	if tags ~= nil then
		for i, v in pairs(tags) do
			inst:AddTag(v)
		end
	end
	
	MakeSnowCoveredPristine(inst)
	
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
	
	inst:AddComponent("brewer")
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
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("onburnt", OnBurnt)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	MakeSnowCovered(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
	return inst
end

local function kegfn()
	return commonfn("kyno_brewers_keg", "kyno_brewers_keg", "kyno_woodenkeg", {"woodenkeg"}, .6)
end

local function jarfn()
	return commonfn("kyno_brewers_jar", "kyno_brewers_jar", "kyno_preservesjar", {"preservesjar"}, .5, 1.8)
end

local function placerfn(inst)
	inst.AnimState:HideSymbol("goop")
end

return Prefab("kyno_woodenkeg", kegfn, assets, prefabs),
Prefab("kyno_preservesjar", jarfn, assets, prefabs),
MakePlacer("kyno_woodenkeg_placer", "kyno_brewers_keg", "kyno_brewers_keg", "idle"),
MakePlacer("kyno_preservesjar_placer", "kyno_brewers_jar", "kyno_brewers_jar", "idle", false, nil, nil, 1.8, nil, nil, placerfn)