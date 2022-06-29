require "prefabutil"
local brewing = require("hof_brewing")

local assets =
{	
	Asset("ANIM", "anim/cook_pot.zip"),
	Asset("ANIM", "anim/cookpot_archive.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
	
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ANIM", "anim/ui_cookpot_1x2.zip"),
	
	Asset("ANIM", "anim/kyno_brewers_keg.zip"),
	Asset("ANIM", "anim/kyno_brewers_jar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
    "collapse_small",
	"wetgoop",
	"wetgoop2",
	"spoiled_food",
}

for k, v in pairs(brewing.recipes.kyno_woodenkeg) do
    table.insert(prefabs, v.name)
end

for k, v in pairs(brewing.recipes.kyno_preservesjar) do
    table.insert(prefabs, v.name)
end

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.brewer.product ~= nil and inst.components.brewer:IsDone() then
        inst.components.brewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
	
    inst.components.lootdropper:DropLoot()
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("hof_sounds/common/brew_destroy")
	
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.brewer:IsCooking() then
            inst.AnimState:PlayAnimation("hit_empty")
            inst.AnimState:PushAnimation("idle_empty", true)
        elseif inst.components.brewer:IsDone() then
            inst.AnimState:PlayAnimation("hit_full")
            inst.AnimState:PushAnimation("idle_full", false)
        else
            if inst.components.container ~= nil and inst.components.container:IsOpen() then
                inst.components.container:Close()
            end
            inst.AnimState:PlayAnimation("hit_empty")
            inst.AnimState:PushAnimation("idle_empty", false)
        end
    end
end

local function StartCookFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty", true)
        inst.SoundEmitter:KillSound("brew_loop")
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_loop", "brew_loop")
    end
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.SoundEmitter:KillSound("brew_loop")
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_start")
    end
end

local function OnClose(inst)
    if not inst:HasTag("burnt") then
        if not inst.components.brewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty")
            inst.SoundEmitter:KillSound("brew_loop")
        end
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_start")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = brewing.GetBrewing(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

    if potlevel == "high" then
        inst.AnimState:Show("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Hide("swap_low")
    elseif potlevel == "low" then
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Show("swap_low")
    else
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Show("swap_mid")
        inst.AnimState:Hide("swap_low")
    end

    inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
end

local function SpoilFn(inst)
    if not inst:HasTag("burnt") then
        inst.components.brewer.product = inst.components.brewer.spoiledproduct
        SetProductSymbol(inst, inst.components.brewer.product)
    end
end

local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.brewer.product
        SetProductSymbol(inst, product, IsModBrewingProduct(inst.prefab, product) and product or nil)
    end
end

local function DoneCookFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.AnimState:PushAnimation("idle_full", false)
		
        ShowProduct(inst)
		
        inst.SoundEmitter:KillSound("brew_loop")
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_harvest")
    end
end

local function ContinueDoneFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_full")
        ShowProduct(inst)
    end
end

local function ContinueCookFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty", true)
        inst.SoundEmitter:KillSound("brew_loop")
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_loop", "brew_loop")
    end
end

local function HarvestFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.SoundEmitter:PlaySound("hof_sounds/common/brew_start")
    end
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.brewer:IsDone() and "DONE")
	or (not inst.components.brewer:IsCooking() and "EMPTY")
	or (inst.components.brewer:GetTimeToCook() > 15 and "COOKING_LONG")
	or "COOKING_SHORT"
end

local function OnBuilt(inst)
    inst.AnimState:PlayAnimation("idle_empty")
    inst.AnimState:PushAnimation("idle_empty", false)
    inst.SoundEmitter:PlaySound("hof_sounds/common/brew_start")
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnLoadPostPass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems)do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem(ent)
        end
    end
end

local function kegfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_woodenkeg.tex")
	
	MakeObstaclePhysics(inst, .6)
	inst.AnimState:SetScale(1.7, 1.7, 1.7)
	
    inst.AnimState:SetBank("kyno_brewers_keg")
    inst.AnimState:SetBuild("kyno_brewers_keg")
    inst.AnimState:PlayAnimation("idle_empty", true)
	
	inst:AddTag("structure")
	inst:AddTag("brewer")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("brewer") 
		end
        return inst
    end
	
	local color = 0.5 + math.random() * 0.5
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("brewer")
	inst.components.brewer.onstartcooking = StartCookFn
	inst.components.brewer.oncontinuecooking = ContinueCookFn
	inst.components.brewer.oncontinuedone = ContinueDoneFn
	inst.components.brewer.ondonecooking = DoneCookFn
	inst.components.brewer.onharvest = HarvestFn
	inst.components.brewer.onspoil = SpoilFn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("brewer")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	MakeSnowCovered(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
	return inst
end

local function preservejarfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_preservesjar.tex")
	
	MakeObstaclePhysics(inst, .5)
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	
    inst.AnimState:SetBank("kyno_brewers_jar")
    inst.AnimState:SetBuild("kyno_brewers_jar")
    inst.AnimState:PlayAnimation("idle_empty", true)
	
	inst:AddTag("structure")
	inst:AddTag("brewer")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("brewer") 
		end
        return inst
    end
	
	local color = 0.5 + math.random() * 0.5
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("brewer")
	inst.components.brewer.onstartcooking = StartCookFn
	inst.components.brewer.oncontinuecooking = ContinueCookFn
	inst.components.brewer.oncontinuedone = ContinueDoneFn
	inst.components.brewer.ondonecooking = DoneCookFn
	inst.components.brewer.onharvest = HarvestFn
	inst.components.brewer.onspoil = SpoilFn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("brewer")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	MakeSnowCovered(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
	return inst
end

return Prefab("kyno_woodenkeg", kegfn, assets, prefabs),
Prefab("kyno_preservesjar", preservejarfn, assets, prefabs),
MakePlacer("kyno_woodenkeg_placer", "kyno_brewers_keg", "kyno_brewers_keg", "idle_empty", false, nil, nil, 1.7),
MakePlacer("kyno_preservesjar_placer", "kyno_brewers_jar", "kyno_brewers_jar", "idle_empty", false, nil, nil, 1.4)