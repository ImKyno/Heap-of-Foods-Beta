require("hof_foodrecipes")
require("hof_foodrecipes_optional")
local cooking = require("cooking")

local assets =
{
	Asset("ANIM", "anim/quagmire_pot.zip"),
    Asset("ANIM", "anim/quagmire_pot_small.zip"),
    Asset("ANIM", "anim/quagmire_pot_syrup.zip"),
    Asset("ANIM", "anim/quagmire_pot_hanger.zip"),
	
	Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ANIM", "anim/quagmire_ui_pot_1x4.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_cookware_hanger",
	"kyno_cookware_hanger_item",
	"kyno_cookware_syrup",
	"kyno_cookware_syrup_pot",
	"kyno_cookware_steam",
}

local function OnHammeredPot(inst, worker)
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
    fx:SetMaterial("metal")
	inst:Remove()
end

local function OnHammeredHanger(inst, worker)
	inst.components.lootdropper:DropLoot()	
	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
	inst:Remove()
end

local function OnHitHanger(inst, worker)
	inst.AnimState:PlayAnimation("hit_idle")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnHitPotSmall(inst, worker)
	if inst.components.stewer:IsCooking() then
		inst.AnimState:PlayAnimation("hit_cooking_loop")
		inst.AnimState:PushAnimation("cooking_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	elseif inst.components.stewer:IsDone() then
		inst.AnimState:PlayAnimation("hit_cooking_loop")
		inst.AnimState:PushAnimation("cooking_boil_small", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	else
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.components.container:Close()
		else
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		end
		inst.AnimState:PlayAnimation("hit_idle_loop")
		inst.AnimState:PushAnimation("idle_pot")
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	end
end

local function OnHitPotBig(inst, worker)
	if inst.components.stewer:IsCooking() then
		inst.AnimState:PlayAnimation("hit_cooking_loop")
		inst.AnimState:PushAnimation("cooking_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	elseif inst.components.stewer:IsDone() then
		inst.AnimState:PlayAnimation("hit_cooking_loop")
		inst.AnimState:PushAnimation("cooking_boil_big", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	else
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.components.container:Close()
		else
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		end
		inst.AnimState:PlayAnimation("hit_idle_loop")
		inst.AnimState:PushAnimation("idle_pot")
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	end
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("pot_installer") then
		return true -- Install the Pot.
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_POTHANGER_FAIL"))
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	-- Syrup Pot.
	if item.components.inventoryitem ~= nil and item:HasTag("pot_syrup_installer") then
		local syrup_pot = SpawnPrefab("kyno_cookware_syrup")
		syrup_pot.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		syrup_pot.AnimState:PlayAnimation("place_pot")
		syrup_pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	-- Small Cooking Pot.
	if item.components.inventoryitem ~= nil and item:HasTag("pot_small_installer") then
		local small_pot = SpawnPrefab("kyno_cookware_potsmall")
		small_pot.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		small_pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	-- Large Cooking Pot.
	if item.components.inventoryitem ~= nil and item:HasTag("pot_large_installer") then
		local large_pot = SpawnPrefab("kyno_cookware_potlarge")
		large_pot.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		large_pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	inst:Remove()
end

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

local function OnPotSteam(inst)
    local fx = CreateEntity()
	
	fx.entity:AddTransform()
    fx.entity:AddAnimState()
    fx.entity:AddSoundEmitter()
	-- fx.entity:AddNetwork()
	
	fx.AnimState:SetBank("quagmire_pot_hanger")
    fx.AnimState:SetBuild("quagmire_pot_hanger")
    fx.AnimState:PlayAnimation("steam", true)
    fx.AnimState:SetFinalOffset(1)

    fx:AddTag("FX")
    fx:AddTag("NOCLICK")
	
    fx.entity:SetCanSleep(false)
    fx.persists = false
	
	fx:ListenForEvent("animover", fx.Remove)

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", nil, .6)
    fx.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function HideGoops(inst)
	inst.AnimState:Hide("goop")
	inst.AnimState:Hide("goop_small")
	inst.AnimState:Hide("goop_syrup")
end

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
	HideGoops(inst)
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
		inst.AnimState:PlayAnimation("place_pot")
    end
	HideGoops(inst)
end

local function OnClose(inst)
    if not inst:HasTag("burnt") then
        if not inst.components.stewer:IsCooking() then
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
	HideGoops(inst)
end

local function spoilfn(inst)
    if inst:HasTag("pot_syrup") then
        inst.components.stewer.product = "kyno_sap_spoiled"
		inst.AnimState:Show("goop_syrup")
        inst.AnimState:PlayAnimation("boiled_over")
		inst.AnimState:PushAnimation("idle_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/boiled_over")
    elseif inst:HasTag("pot_big") then
		inst.components.stewer.product = "spoiled_food"
		inst.AnimState:Show("goop")
        inst.AnimState:PlayAnimation("boiled_over")
		inst.AnimState:PushAnimation("idle_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/boiled_over")
	else
		inst.components.stewer.product = "spoiled_food"
		inst.AnimState:Show("goop_small")
        inst.AnimState:PlayAnimation("boiled_over")
		inst.AnimState:PushAnimation("idle_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/boiled_over")
	end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") and inst:HasTag("pot_big") then
        inst.AnimState:PlayAnimation("cooking_boil_big", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
		
		inst.steam_task = inst:DoPeriodicTask(2, function() 
			inst._steam:push()
			OnPotSteam(inst) 
		end)
    else
		inst.AnimState:PlayAnimation("cooking_boil_small", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
		
		inst.steam_task = inst:DoPeriodicTask(2, function() 
			inst._steam:push()
			OnPotSteam(inst) 
		end)
	end
	HideGoops(inst)
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") and inst:HasTag("pot_big") then
        inst.AnimState:PlayAnimation("cooking_boil_big", true)
		inst._steam:push()
		inst.steam_task = inst:DoPeriodicTask(2, function() OnPotSteam(inst) end)
    else
		inst.AnimState:PlayAnimation("cooking_boil_small", true)
		
		inst.steam_task = inst:DoPeriodicTask(2, function() 
			inst._steam:push()
			OnPotSteam(inst) 
		end)
	end
	HideGoops(inst)
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
	HideGoops(inst)
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_pot")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
	HideGoops(inst)
	if inst.steam_task then
		inst.steam_task:Cancel()
		inst.steam_task = nil
		-- print("Pot steam is gone!")
	end
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.stewer:IsDone() and "DONE")
	or (not inst.components.stewer:IsCooking() and "EMPTY")
	or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
	or "COOKING_SHORT"
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

local function hangerfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pond_salt.tex")
	
	MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("quagmire_pot_hanger")
    inst.AnimState:SetBuild("quagmire_pot_hanger")
    inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
    
	inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("goop")
    inst.AnimState:Hide("goop_small")
    inst.AnimState:Hide("goop_syrup")

    inst.AnimState:SetFinalOffset(-2)
    
	inst:AddTag("structure")
	inst:AddTag("cookingpot_hanger")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_hanger_item"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POT_HANGER"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredHanger)
	inst.components.workable:SetOnWorkCallback(OnHitHanger)
	inst.components.workable:SetWorkLeft(3)
	
    return inst
end

local function syruppotfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pond_salt.tex")
	
	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)
	
	MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("quagmire_pot_hanger")
    inst.AnimState:SetBuild("quagmire_pot_hanger")
    inst.AnimState:PlayAnimation("idle_pot")
	
	inst.AnimState:AddOverrideBuild("quagmire_pot_syrup")
	inst.AnimState:OverrideSymbol("pot", "quagmire_pot_syrup", "pot")
	
    inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("goop")
    inst.AnimState:Hide("goop_small")
    inst.AnimState:Hide("goop_syrup")

    inst.AnimState:SetFinalOffset(5)
    
	inst:AddTag("structure")
	inst:AddTag("stewer")
	inst:AddTag("pot_syrup")
	
	inst._steam = net_event(inst.GUID, "steampot")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst:ListenForEvent("steampot", OnPotSteam)
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("syrup_pot") 
		end
        return inst
    end
	
	inst:AddComponent("stewer")
	inst.components.stewer.onstartcooking = startcookfn
	inst.components.stewer.oncontinuecooking = continuecookfn
	inst.components.stewer.oncontinuedone = continuedonefn
	inst.components.stewer.ondonecooking = donecookfn
	inst.components.stewer.onharvest = harvestfn
	inst.components.stewer.onspoil = spoilfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("syrup_pot")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_hanger_item", "kyno_cookware_syrup_pot"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredPot)
	inst.components.workable:SetOnWorkCallback(OnHitPotSmall)
	inst.components.workable:SetWorkLeft(3)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
    return inst
end

return Prefab("kyno_cookware_hanger", hangerfn, assets, prefabs),
Prefab("kyno_cookware_syrup", syruppotfn, assets, prefabs)--,
--Prefab("kyno_cookware_steam", steamfn, assets, prefabs)