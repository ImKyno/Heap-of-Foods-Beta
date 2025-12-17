local foodrecipes =
{
	"preparedfoods",
	"preparednonfoods",
	"hof_foodrecipes",
	"hof_foodrecipes_seasonal",
}

for k, v in pairs(foodrecipes) do
	require(v)
end

local cooking = require("cooking")
local cookpotfoods = cooking.recipes["cookpot"]

local assets =
{
	Asset("ANIM", "anim/quagmire_oven.zip"),
	Asset("ANIM", "anim/quagmire_casseroledish.zip"),
	Asset("ANIM", "anim/quagmire_casseroledish_small.zip"),

	Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ANIM", "anim/quagmire_ui_pot_1x3.zip"),
	Asset("ANIM", "anim/quagmire_ui_pot_1x4.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"kyno_cookware_oven",
	"kyno_cookware_oven_back",
	"kyno_cookware_oven_item",

	"kyno_cookware_oven_casserole",
	"kyno_cookware_oven_small_casserole",

	"kyno_cookware_fire",
}

-- Remember to update this function if Klei updates the stewer component.
local function DoubleHarvest(self, harvester)
    if self.done then
        if self.onharvest ~= nil then
            self.onharvest(self.inst)
        end

        if self.product ~= nil then
            local loot = SpawnPrefab(self.product)
            if loot ~= nil then
				local recipe = cooking.GetRecipe(self.inst.prefab, self.product)

				if harvester ~= nil and
					self.chef_id == harvester.userid and
					recipe ~= nil and
					recipe.cookbook_category ~= nil and
					cooking.cookbook_recipes[recipe.cookbook_category] ~= nil and
					cooking.cookbook_recipes[recipe.cookbook_category][self.product] ~= nil then
					harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
				end

				if loot.components.stackable ~= nil then
					local stacksize = recipe and recipe.stacksize or 1
					stacksize = stacksize + TUNING.KYNO_COOKWARE_BONUSHARVEST -- Always grants +1 for large stations.

					if stacksize > 1 then
						loot.components.stackable:SetStackSize(stacksize)
					end
				end

                if self.spoiltime ~= nil and loot.components.perishable ~= nil then
                    local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
                    loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
                    loot.components.perishable:StartPerishing()
                end
                if harvester ~= nil and harvester.components.inventory ~= nil then
                    harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
                else
                    LaunchAt(loot, self.inst, nil, 1, 1)
                end
            end
			
            self.product = nil
        end

        if self.task ~= nil then
            self.task:Cancel()
            self.task = nil
        end
		
        self.targettime = nil
        self.done = nil
        self.spoiltime = nil
        self.product_spoilage = nil

        if self.inst.components.container ~= nil then
            self.inst.components.container.canbeopened = true
        end

        return true
    end
end

local function GetFirepit(inst)
    if not inst.firepit or not inst.firepit:IsValid() or not inst.firepit.components.fueled then
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 0.01)
        inst.firepit = nil
        for k,v in pairs(ents) do
            if v.prefab == "firepit" then
                inst.firepit = v
                break
            end
        end
    end
	
    return inst.firepit
end

local function GetBubble(inst)
    if not inst.bubble or not inst.bubble:IsValid() then
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 0.01)
        inst.bubble = nil
        for k,v in pairs(ents) do
            if v.prefab == "kyno_product_bubble" then
                inst.bubble = v
                break
            end
        end
    end
    return inst.bubble
end

local function cancookfn(self)
    local function IsContainerFull(inst)
        return inst.components.container and inst.components.container:IsFull()
    end
    local function HasEnoughFire(inst)
        local firepit = GetFirepit(inst)
        return firepit and firepit.components.fueled and
               firepit.components.fueled:GetCurrentSection() >= 2
    end
    return IsContainerFull(self.inst) and HasEnoughFire(self.inst)
end

local function OnHammeredCass(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end

	if not inst:HasTag("burnt") and inst.components.cookwarestewer.product ~= nil and inst.components.cookwarestewer:IsDone() then
        inst.components.cookwarestewer:Harvest()
    end

	if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end

	inst.components.lootdropper:DropLoot()

	local hng = SpawnPrefab("kyno_cookware_oven")
	hng.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function OnHammeredOven(inst, worker)
	local firepit = GetFirepit(inst)
	
	if firepit then
		firepit:RemoveTag("firepit_has_oven")
		firepit:RemoveTag("firepit_with_cookware")
		firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
		firepit.components.cookwareinstaller.enabled = true
		firepit.hasoven = false
		firepit.hascookware = false
	end
	
	if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end

	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
	inst:Remove()
end

local function OnHitOven(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
end

local function OnHitCass(inst, worker)
	if inst.components.cookwarestewer:IsCooking() then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("cooking_bake_small", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	elseif inst.components.cookwarestewer:IsDone() then
		inst.AnimState:PlayAnimation("hit_cooking_loop")
		inst.AnimState:PushAnimation("cooking_boil_big", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	else
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.components.container:Close()
		else
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		end
		
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	end
end

local function ChangeFireFX(inst)
	local firepit = GetFirepit(inst)
	
	if firepit then
		firepit:AddTag("firepit_has_oven")
		firepit:AddTag("firepit_with_cookware")
		firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		firepit.components.cookwareinstaller.enabled = false
		firepit.hasoven = true
		firepit.hascookware = true
	end
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("casserole_installer") then
		return true -- Install the Pot.
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_CASSEROLE_FAIL"))
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item:HasTag("casserole_small_installer") then
		local small_cass = SpawnPrefab("kyno_cookware_oven_small_casserole")

		small_cass.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/dish_place_oven")
		small_cass.AnimState:PlayAnimation("place_casserole")
		small_cass.Transform:SetPosition(inst.Transform:GetWorldPosition())

		ChangeFireFX(inst)
	end

	if item.components.inventoryitem ~= nil and item:HasTag("casserole_big_installer") then
		local big_cass = SpawnPrefab("kyno_cookware_oven_casserole")

		big_cass.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/dish_place_oven")
		big_cass.AnimState:PlayAnimation("place_casserole")
		big_cass.Transform:SetPosition(inst.Transform:GetWorldPosition())

		ChangeFireFX(inst)
	end

	inst:Remove()
end

--[[
local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end
]]--

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

for k, recipe in pairs(cookpotfoods) do
    local rep = shallowcopy(recipe)
    AddCookerRecipe("kyno_cookware_oven_small_casserole", rep)
	AddCookerRecipe("kyno_cookware_oven_casserole", rep)
end

local function OnOvenSteam(inst)
    local fx = CreateEntity()

	fx.entity:AddTransform()
    fx.entity:AddAnimState()
    fx.entity:AddSoundEmitter()
	-- fx.entity:AddNetwork()

	fx.AnimState:SetBank("quagmire_oven")
    fx.AnimState:SetBuild("quagmire_oven")
    fx.AnimState:PlayAnimation("steam", true)
    fx.AnimState:SetFinalOffset(5)

    fx:AddTag("FX")
    fx:AddTag("NOCLICK")

    fx.entity:SetCanSleep(false)
    fx.persists = false

	fx:ListenForEvent("animover", fx.Remove)

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", nil, .6)
    fx.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function ShowGoops(inst)
	if inst:HasTag("oven_casserole_small") then
		inst.AnimState:Show("goop_small")
	else
		inst.AnimState:Show("goop")
	end
end

local function HideGoops(inst)
	inst.AnimState:Hide("goop")
	inst.AnimState:Hide("goop_small")
end

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_bake_small", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
    end
	HideGoops(inst)
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
		inst.AnimState:PlayAnimation("place_casserole")
		inst.AnimState:PushAnimation("idle")
    end

	HideGoops(inst)
end

local function OnClose(inst, doer)
    if not inst:HasTag("burnt") then
        if not inst.components.cookwarestewer:IsCooking() then
            inst.SoundEmitter:KillSound("snd")

			if not inst.components.container:IsOpenedByOthers(doer) and
                inst.components.cookwarestewer:CanCook() then
                startcookfn(inst)
                inst.components.cookwarestewer:StartCooking(doer)
            end
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end

	HideGoops(inst)
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

	local product_image = SpawnPrefab("kyno_product_bubble")
	product_image.entity:SetParent(inst.entity)
	product_image.AnimState:SetFinalOffset(6) -- Otherwise it will be on the back.
	product_image.AnimState:PlayAnimation("product_oven", false)

	product_image.AnimState:OverrideSymbol("product_image", GetInventoryItemAtlas(overridesymbol..".tex"), overridesymbol..".tex")
end

local function spoilfn(inst)
	inst.components.cookwarestewer.product = "wetgoop"
	
	ShowGoops(inst)
	
	inst.AnimState:PlayAnimation("burnt")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/boiled_over")
	-- SetProductSymbol(inst, inst.components.cookwarestewer.product)
	
	if inst.oven_task then
		inst.oven_task:Cancel()
		inst.oven_task = nil
	end
	
	inst:AddTag("spoiledcookware")
end

local function ShowProductImage(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.cookwarestewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_bake_large", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.oven_task = inst:DoPeriodicTask(2, function()
			inst._steamoven:push()
			OnOvenSteam(inst)
		end)
	end

	HideGoops(inst)
	-- ShowProductImage(inst)
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_bake_large", true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.oven_task = inst:DoPeriodicTask(2, function()
			inst._steamoven:push()
			OnOvenSteam(inst)
		end)
	end

	HideGoops(inst)
	-- ShowProductImage(inst)
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_bake_small", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
    end

	HideGoops(inst)
end

local function harvestfn(inst, doer)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end

	local firepit = GetFirepit(inst)
	if firepit then
		firepit:RemoveTag("NOCLICK")
	end

	if inst.oven_task then
		inst.oven_task:Cancel()
		inst.oven_task = nil
	end

	local bubble = GetBubble(inst)
	if bubble then
		bubble:Remove()
	end
	
	HideGoops(inst)
	
	inst:RemoveTag("spoiledcookware")
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.cookwarestewer:IsDone() and "DONE")
	or (not inst.components.cookwarestewer:IsCooking() and "EMPTY")
	or (inst.components.cookwarestewer:GetTimeToCook() > 15 and "COOKING_LONG")
	or "COOKING_SHORT"
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
end

local function OnSave(inst, data)
	local firepit = GetFirepit(inst)

    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
	
	if firepit and firepit:HasTag("firepit_has_oven") then
		data.hasoven = true
		data.hascookware = true
	end
	
	if inst:HasTag("spoiledcookware") then
		data.spoiled = true
	end
end

local function OnLoad(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end

	if data and data.hasoven then
		inst:DoTaskInTime(1, function() 
			ChangeFireFX(inst) 
		end)
	end
	
	if data and data.spoiled then
		inst:DoTaskInTime(1, function()
			spoilfn(inst)
		end)
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

local function ovenfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_cookware_oven.tex")

	MakeObstaclePhysics(inst, .3)

    inst.AnimState:SetBank("quagmire_oven")
    inst.AnimState:SetBuild("quagmire_oven")
    -- inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")

	inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("goop")
	inst.AnimState:Hide("goop_small")
	inst.AnimState:Hide("oven_back")

    inst.AnimState:SetFinalOffset(4)

	inst:AddTag("structure")
	inst:AddTag("cookware_post_installable")
	inst:AddTag("serenity_oven")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.back = SpawnPrefab("kyno_cookware_oven_back")
	-- inst.back.AnimState:PlayAnimation("place")
	inst.back.AnimState:PushAnimation("idle")
	inst.back.entity:SetParent(inst.entity)
	inst.back.AnimState:SetFinalOffset(-1)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_oven_item"})

	inst:AddComponent("cookwareinstaller")
	inst.components.cookwareinstaller:SetAcceptTest(TestItem)
    inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredOven)
	inst.components.workable:SetOnWorkCallback(OnHitOven)
	inst.components.workable:SetWorkLeft(3)

    return inst
end

local function backfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("quagmire_oven")
    inst.AnimState:SetBuild("quagmire_oven")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:Hide("steam")
    inst.AnimState:Hide("smoke")
    inst.AnimState:Hide("oven")
    inst.AnimState:Hide("goop")
    inst.AnimState:Hide("goop_small")
    inst.AnimState:Hide("casserole")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function casserolefn(small)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	if small then
		minimap:SetIcon("kyno_cookware_small_casserole.tex")
	else
		minimap:SetIcon("kyno_cookware_casserole.tex")
	end
	minimap:SetPriority(3)

	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)

	MakeObstaclePhysics(inst, .3)

    inst.AnimState:SetBank("quagmire_oven")
    inst.AnimState:SetBuild("quagmire_oven")
    inst.AnimState:PlayAnimation("idle")

	if small then
		inst.AnimState:AddOverrideBuild("quagmire_casseroledish_small")
	else
		inst.AnimState:AddOverrideBuild("quagmire_casseroledish")
	end

    inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("goop")
	inst.AnimState:Hide("goop_small")
	inst.AnimState:Hide("oven_back")
	inst.AnimState:Hide("shadow")

    inst.AnimState:SetFinalOffset(4)

	inst:AddTag("structure")
	inst:AddTag("cookwarestewer")
	inst:AddTag("cookwarestewer_oven")
	inst:AddTag("oven_with_casserole")
	if small then
		inst:AddTag("oven_casserole_small")
	else
		inst:AddTag("oven_casserole")
	end

	inst._steamoven = net_event(inst.GUID, "steamoven")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then	
		inst:ListenForEvent("steamoven", OnOvenSteam)

		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("cooking_pot_small")
		end

        return inst
    end

	inst.back = SpawnPrefab("kyno_cookware_oven_back")
	-- inst.back.AnimState:PlayAnimation("place")
	inst.back.AnimState:PushAnimation("idle")
	inst.back.entity:SetParent(inst.entity)
	inst.back.AnimState:SetFinalOffset(-1)

	inst:AddComponent("cookwarestewer")
	inst.components.cookwarestewer.cooktimemult = TUNING.KYNO_COOKWARE_COOKTIMEMULT
	inst.components.cookwarestewer.onstartcooking = startcookfn
	inst.components.cookwarestewer.oncontinuecooking = continuecookfn
	inst.components.cookwarestewer.oncontinuedone = continuedonefn
	inst.components.cookwarestewer.ondonecooking = donecookfn
	inst.components.cookwarestewer.onharvest = harvestfn
	-- inst.components.cookwarestewer.Harvest = DoubleHarvest
	inst.components.cookwarestewer.onspoil = spoilfn
	inst.components.cookwarestewer.CanCook = cancookfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("cooking_pot_small") -- cooking_pot
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("lootdropper")
	if small then
		inst.components.lootdropper:SetLoot({"kyno_cookware_small_casserole"})
	else
		inst.components.lootdropper:SetLoot({"kyno_cookware_casserole"})
	end

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredCass)
	inst.components.workable:SetOnWorkCallback(OnHitCass)
	inst.components.workable:SetWorkLeft(1)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function casserolesmallfn()
	local inst = casserolefn(true)
    return inst
end

local function casserolebigfn()
	local inst = casserolefn(false)
	
	if not TheWorld.ismastersim then	
		inst:ListenForEvent("steamoven", OnOvenSteam)

		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("cooking_pot")
		end

        return inst
    end
	
	inst.components.container:WidgetSetup("cooking_pot")
	-- inst.components.cookwarestewer.Harvest = DoubleHarvest
	
	return inst
end

return Prefab("kyno_cookware_oven", ovenfn, assets, prefabs),
Prefab("kyno_cookware_oven_back", backfn, assets, prefabs),
Prefab("kyno_cookware_oven_small_casserole", casserolesmallfn, assets, prefabs),
Prefab("kyno_cookware_oven_casserole", casserolebigfn, assets, prefabs)