require "prefabutil"
local cooking = require("cooking")
local cookpotfoods = cooking.recipes["hof_brewrecipes"]

local assets =
{
    Asset("ANIM", "anim/cook_pot.zip"),
	Asset("ANIM", "anim/cookpot_archive.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
	
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ANIM", "anim/ui_cookpot_1x2.zip"),
}

local prefabs =
{
    "collapse_small",
	"wetgoop",
	"spoiled_food",
}

for k, v in pairs(cooking.recipes.kyno_keg) do
    table.insert(prefabs, v.name)

	if v.overridebuild then
        table.insert(assets, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
	end
end

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
	
    inst.components.lootdropper:DropLoot()
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
	
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("hit_cooking")
            inst.AnimState:PushAnimation("cooking_loop", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        elseif inst.components.stewer:IsDone() then
            inst.AnimState:PlayAnimation("hit_full")
            inst.AnimState:PushAnimation("idle_full", false)
        else
            if inst.components.container ~= nil and inst.components.container:IsOpen() then
                inst.components.container:Close()
            else
                inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
            end
            inst.AnimState:PlayAnimation("hit_empty")
            inst.AnimState:PushAnimation("idle_empty", false)
        end
    end
end

local function StartCookFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pre_loop")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function OnClose(inst)
    if not inst:HasTag("burnt") then
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty")
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
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
        inst.components.stewer.product = inst.components.stewer.spoiledproduct
        SetProductSymbol(inst, inst.components.stewer.product)
    end
end

local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function DoneCookFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
        inst.AnimState:PushAnimation("idle_full", false)
		
        ShowProduct(inst)
		
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
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
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function HarvestFn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.stewer:IsDone() and "DONE")
	or (not inst.components.stewer:IsCooking() and "EMPTY")
	or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
	or "COOKING_SHORT"
end

local function OnBuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_empty", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
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
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cookpot.png")
	
	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)
	
	MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("cook_pot")
    inst.AnimState:SetBuild("cook_pot")
    inst.AnimState:PlayAnimation("idle_empty")
	
	inst:AddTag("structure")
	inst:AddTag("stewer")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("brewer") 
		end
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("stewer")
	inst.components.stewer.onstartcooking = StartCookFn
	inst.components.stewer.oncontinuecooking = ContinueCookFn
	inst.components.stewer.oncontinuedone = ContinueDoneFn
	inst.components.stewer.ondonecooking = DoneCookFn
	inst.components.stewer.onharvest = HarvestFn
	inst.components.stewer.onspoil = SpoilFn

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

return Prefab("kyno_keg", kegfn, assets, prefabs)
-- Prefab("kyno_preservejar", preservejarfn, assets, prefabs)