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

	"kyno_cookware_big",
	"kyno_cookware_big_pot",

	"kyno_cookware_small",
	"kyno_cookware_small_pot",

	"kyno_cookware_fire",
}

-- Remember to update this function if Klei updates the stewer component.
local function ExtraHarvest(self, harvester)
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

				local stacksize = recipe and recipe.stacksize or 1

				stacksize = stacksize + 2

				if stacksize > 1 then
					loot.components.stackable:SetStackSize(stacksize)
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

				local stacksize = recipe and recipe.stacksize or 1

				if math.random() < 0.30 then -- 30% of Extra food.
					stacksize = stacksize + 1
				end

				if stacksize > 1 then
					loot.components.stackable:SetStackSize(stacksize)
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
            if v.prefab == 'firepit' then
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
            if v.prefab == 'kyno_product_bubble' then
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

	local firepit = GetFirepit(inst)
	if firepit then
		firepit:RemoveTag("firepit_has_pot")
		firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
	end

	inst.components.lootdropper:DropLoot()

	local hng = SpawnPrefab("kyno_cookware_hanger")
	hng.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function OnHammeredHanger(inst, worker)
	local firepit = GetFirepit(inst)
	if firepit then
		firepit.components.trader.enabled = true
	end

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

local function ChangeFireFX(inst)
	local firepit = GetFirepit(inst)
	if firepit then
		firepit:AddTag("firepit_has_pot")
		firepit.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
		firepit.components.trader.enabled = false
		-- print("Added tag to firepit")
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
		ChangeFireFX(inst)
	end
	-- Small Cooking Pot.
	if item.components.inventoryitem ~= nil and item:HasTag("pot_small_installer") then
		local small_pot = SpawnPrefab("kyno_cookware_small")
		small_pot.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		small_pot.AnimState:PlayAnimation("place_pot")
		small_pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
		ChangeFireFX(inst)
	end
	-- Large Cooking Pot.
	if item.components.inventoryitem ~= nil and item:HasTag("pot_big_installer") then
		local large_pot = SpawnPrefab("kyno_cookware_big")
		large_pot.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		large_pot.AnimState:PlayAnimation("place_pot")
		large_pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
		ChangeFireFX(inst)
	end
	inst:Remove()
end

function hofshallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

for k, recipe in pairs(cookpotfoods) do
    local rep = hofshallowcopy(recipe)
    AddCookerRecipe("kyno_cookware_big", rep)
	AddCookerRecipe("kyno_cookware_small", rep)
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
		inst.AnimState:PlayAnimation("place_pot")
		inst.AnimState:PushAnimation("idle_pot")
    end
	HideGoops(inst)
end

local function OnClose(inst, doer)
    if not inst:HasTag("burnt") then
        if not inst.components.stewer:IsCooking() then
            inst.SoundEmitter:KillSound("snd")

			if not inst.components.container:IsOpenedByOthers(doer) and
                inst.components.stewer:CanCook() then
                startcookfn(inst)
                inst.components.stewer:StartCooking(doer)
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
	product_image.AnimState:PlayAnimation("product_pothanger", false)
	product_image.AnimState:SetFinalOffset(5)

	product_image.AnimState:OverrideSymbol("product_image", GetInventoryItemAtlas(overridesymbol..".tex"), overridesymbol..".tex")
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
	SetProductSymbol(inst, inst.components.stewer.product)
end

local function ShowProductImage(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") and inst:HasTag("pot_big") then
        inst.AnimState:PlayAnimation("cooking_boil_big", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
		
		inst.steam_task = inst:DoPeriodicTask(2, function()
			inst._steam:push()
			OnPotSteam(inst)
		end)
    else
		inst.AnimState:PlayAnimation("cooking_boil_small", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.steam_task = inst:DoPeriodicTask(2, function()
			inst._steam:push()
			OnPotSteam(inst)
		end)
	end
	
	HideGoops(inst)
	ShowProductImage(inst)
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") and inst:HasTag("pot_big") then
        inst.AnimState:PlayAnimation("cooking_boil_big", true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
		
		inst.steam_task = inst:DoPeriodicTask(2, function()
			inst._steam:push()
			OnPotSteam(inst)
		end)
    else
		inst.AnimState:PlayAnimation("cooking_boil_small", true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.steam_task = inst:DoPeriodicTask(2, function()
			inst._steam:push()
			OnPotSteam(inst)
		end)
	end
	
	HideGoops(inst)
	ShowProductImage(inst)
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
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
        inst.AnimState:PlayAnimation("idle_pot")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end

	local firepit = GetFirepit(inst)
	if firepit then
		firepit:RemoveTag("NOCLICK")
	end

	if inst.steam_task then
		inst.steam_task:Cancel()
		inst.steam_task = nil
		-- print("Pot steam is gone!")
	end

	local bubble = GetBubble(inst)
	if bubble then
		bubble:Remove()
	end
	
	HideGoops(inst)
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
	
	local firepit = GetFirepit(inst)
	if firepit and firepit:HasTag("firepit_has_pot") then
		data.firepit_has_pot = true
	end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end
	
	if data ~= nil and data.firepit_has_pot then
		ChangeFireFX(inst)
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
	minimap:SetIcon("kyno_cookware_hanger.tex")

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
	minimap:SetIcon("kyno_cookware_syrup.tex")

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

    inst.AnimState:SetFinalOffset(-2)

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
	inst.components.stewer.cooktimemult = TUNING.KYNO_COOKWARE_COOKTIMEMULT_SYRUP
	inst.components.stewer.onstartcooking = startcookfn
	inst.components.stewer.oncontinuecooking = continuecookfn
	inst.components.stewer.oncontinuedone = continuedonefn
	inst.components.stewer.ondonecooking = donecookfn
	inst.components.stewer.onharvest = harvestfn
	inst.components.stewer.Harvest = ExtraHarvest -- Extra Syrup!
	inst.components.stewer.onspoil = spoilfn
	inst.components.stewer.CanCook = cancookfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("syrup_pot")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_syrup_pot"})

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredPot)
	inst.components.workable:SetOnWorkCallback(OnHitPotSmall)
	inst.components.workable:SetWorkLeft(1)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function potfn(small)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	if small then
		minimap:SetIcon("kyno_cookware_small_pot.tex")
	else
		minimap:SetIcon("kyno_cookware_big_pot.tex")
	end
	minimap:SetPriority(3)

	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)

	MakeObstaclePhysics(inst, .3)

    inst.AnimState:SetBank("quagmire_pot_hanger")
    inst.AnimState:SetBuild("quagmire_pot_hanger")
    inst.AnimState:PlayAnimation("idle_pot")

	if small then
		inst.AnimState:AddOverrideBuild("quagmire_pot_small")
		inst.AnimState:OverrideSymbol("pot", "quagmire_pot_small", "pot")
	else
		inst.AnimState:AddOverrideBuild("quagmire_pot")
		inst.AnimState:OverrideSymbol("pot", "quagmire_pot", "pot")
	end

    inst.AnimState:Hide("mouseover")
    inst.AnimState:Hide("goop")
    inst.AnimState:Hide("goop_small")
    inst.AnimState:Hide("goop_syrup")

    inst.AnimState:SetFinalOffset(-2)

	inst:AddTag("structure")
	inst:AddTag("stewer")
	inst:AddTag("pot_syrup")
	if small then
		inst:AddTag("pot_small")
	else
		inst:AddTag("pot_big")
	end

	inst._steam = net_event(inst.GUID, "steampot")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst:ListenForEvent("steampot", OnPotSteam)
		
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("cooking_pot")
		end
		
        return inst
    end

	inst:AddComponent("stewer")
	inst.components.stewer.cooktimemult = TUNING.KYNO_COOKWARE_COOKTIMEMULT
	inst.components.stewer.onstartcooking = startcookfn
	inst.components.stewer.oncontinuecooking = continuecookfn
	inst.components.stewer.oncontinuedone = continuedonefn
	inst.components.stewer.ondonecooking = donecookfn
	inst.components.stewer.onharvest = harvestfn
	inst.components.stewer.Harvest = DoubleHarvest
	inst.components.stewer.onspoil = spoilfn
	inst.components.stewer.CanCook = cancookfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("cooking_pot")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("lootdropper")
	if small then
		inst.components.lootdropper:SetLoot({"kyno_cookware_small_pot"})
	else
		inst.components.lootdropper:SetLoot({"kyno_cookware_big_pot"})
	end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredPot)
	if small then
		inst.components.workable:SetOnWorkCallback(OnHitPotSmall)
	else
		inst.components.workable:SetOnWorkCallback(OnHitPotBig)
	end
	inst.components.workable:SetWorkLeft(1)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function potbigfn()
	local inst = potfn(false)
	return inst
end

local function potsmallfn()
	local inst = potfn(true)
    return inst
end

local pit_defs = 
{
	pit = { { 0, 0, 0 } },
}

local function elderpotfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_cookware_syrup.tex")

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

    inst.AnimState:SetFinalOffset(-2)

	inst:AddTag("structure")
	inst:AddTag("stewer")
	inst:AddTag("pot_syrup")
	inst:AddTag("pot_elder")

	inst._steam = net_event(inst.GUID, "steampot")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst:ListenForEvent("steampot", OnPotSteam)
		
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("syrup_pot")
		end
		
        return inst
    end

	local decor_items = pit_defs
	inst.decor = {}
	for item_name, data in pairs(decor_items) do
		for l, offset in pairs(data) do
			local item_inst = SpawnPrefab("firepit")
			item_inst.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
			item_inst.components.workable:SetWorkable(false)
			item_inst.components.trader.enabled = false
			item_inst.entity:SetParent(inst.entity)
			item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
			table.insert(inst.decor, item_inst)
		end
	end

	inst:AddComponent("stewer")
	inst.components.stewer.cooktimemult = TUNING.KYNO_COOKWARE_COOKTIMEMULT_SYRUP
	inst.components.stewer.onstartcooking = startcookfn
	inst.components.stewer.oncontinuecooking = continuecookfn
	inst.components.stewer.oncontinuedone = continuedonefn
	inst.components.stewer.ondonecooking = donecookfn
	inst.components.stewer.onharvest = harvestfn
	inst.components.stewer.Harvest = ExtraHarvest -- Extra Syrup!
	inst.components.stewer.onspoil = spoilfn
	inst.components.stewer.CanCook = cancookfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("syrup_pot")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	-- inst:AddComponent("lootdropper")
	-- inst.components.lootdropper:SetLoot({"kyno_cookware_syrup_pot"})

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	-- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	-- inst.components.workable:SetOnFinishCallback(OnHammeredPot)
	-- inst.components.workable:SetOnWorkCallback(OnHitPotSmall)
	-- inst.components.workable:SetWorkLeft(1)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("kyno_cookware_hanger", hangerfn, assets, prefabs),
Prefab("kyno_cookware_syrup", syruppotfn, assets, prefabs),
Prefab("kyno_cookware_big", potbigfn, assets, prefabs),
Prefab("kyno_cookware_small", potsmallfn, assets, prefabs),
Prefab("kyno_cookware_elder", elderpotfn, assets, prefabs) -- This pot is for the Pig Elder on Serenity Island.