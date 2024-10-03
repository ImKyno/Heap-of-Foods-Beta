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
	Asset("ANIM", "anim/quagmire_grill.zip"),
    Asset("ANIM", "anim/quagmire_grill_small.zip"),

	Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	Asset("ANIM", "anim/quagmire_ui_pot_1x4.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_cookware_grill_item",
	"kyno_cookware_small_grill_item",

	"kyno_cookware_fire2",
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

local function OnHammeredGrill(inst, worker)
	local firepit = GetFirepit(inst)
	
	if firepit then
		firepit:RemoveTag("firepit_has_grill")
		firepit:RemoveTag("firepit_with_cookware")
		firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
		firepit.components.burnable:OverrideBurnFXFinalOffset(3)
		firepit.components.cookwareinstaller.enabled = true
		firepit.firepit_has_grill = false
	end

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

local function OnHitGrill(inst, worker)
	if inst.components.stewer:IsCooking() then
		inst.AnimState:PlayAnimation("hit_cooking")
		inst.AnimState:PushAnimation("cooking_grill_big", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	elseif inst.components.stewer:IsDone() then
		inst.AnimState:PlayAnimation("hit_cooking")
		inst.AnimState:PushAnimation("cooking_grill_big", true)
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
		firepit:AddTag("firepit_has_grill")
		firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		firepit.components.cookwareinstaller.enabled = false
		firepit.firepit_has_grill = true
	end
end

function hofshallowcopy(orig)
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

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

for k, recipe in pairs(cookpotfoods) do
    local rep = hofshallowcopy(recipe)
    AddCookerRecipe("kyno_cookware_grill", rep)
	AddCookerRecipe("kyno_cookware_small_grill", rep)
end

local function OnGrillSmoke(inst)
    local fx = CreateEntity()

	fx.entity:AddTransform()
    fx.entity:AddAnimState()
    fx.entity:AddSoundEmitter()
	-- fx.entity:AddNetwork()

	fx.AnimState:SetBank("quagmire_grill")
    fx.AnimState:SetBuild("quagmire_grill")
    fx.AnimState:PlayAnimation("smoke", true)
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

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_grill_small")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
    end
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
		inst.AnimState:PlayAnimation("open")
    end
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
		inst.AnimState:PlayAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

	local product_image = SpawnPrefab("kyno_product_bubble")
	product_image.entity:SetParent(inst.entity)
	product_image.AnimState:SetFinalOffset(5)

	if inst:HasTag("grill_big") then
		product_image.AnimState:PlayAnimation("product_grill", false)
	else
		product_image.AnimState:PlayAnimation("product_grill_small", false)
	end

	product_image.AnimState:OverrideSymbol("product_image", GetInventoryItemAtlas(overridesymbol..".tex"), overridesymbol..".tex")
end

local function spoilfn(inst)
    if not inst:HasTag("burnt") then
		inst.components.stewer.product = "wetgoop"
		inst.AnimState:PushAnimation("cooking_burnt_loop", true)
		SetProductSymbol(inst, inst.components.stewer.product)
	end
end

local function ShowProductImage(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("cooking_grill_big", true)
		inst.SoundEmitter:KillSound("snd")
		inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
		inst.Light:Enable(false)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.smoke_task = inst:DoPeriodicTask(2, function()
			inst._smoke:push()
			OnGrillSmoke(inst)
		end)

		ShowProductImage(inst)
	end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_grill_big", true)

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end

		inst.smoke_task = inst:DoPeriodicTask(2, function()
			inst._smoke:push()
			OnGrillSmoke(inst)
		end)

		ShowProductImage(inst)
    end
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_grill_small")
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")

		local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("NOCLICK")
		end
    end
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

	if inst.smoke_task then
		inst.smoke_task:Cancel()
		inst.smoke_task = nil
	end

	local bubble = GetBubble(inst)
	if bubble then
		bubble:Remove()
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

	local firepit = GetFirepit(inst)
	
	if firepit and firepit:HasTag("firepit_has_grill") then
		data.firepit_has_grill = firepit.firepit_has_grill or nil
	end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end

	if data ~= nil and data.firepit_has_grill then
		firepit:AddTag("firepit_has_grill")
		firepit:AddTag("firepit_with_cookware")
		firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		firepit.components.cookwareinstaller.enabled = false
		firepit.firepit_has_grill = true
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

local function grillsmallfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_cookware_small_grill.tex")
	minimap:SetPriority(3)

	MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("quagmire_grill_small")
    inst.AnimState:SetBuild("quagmire_grill_small")
    inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	inst.AnimState:SetFinalOffset(4)

	inst:AddTag("structure")
	inst:AddTag("stewer")
	inst:AddTag("grill_small")

	inst._smoke = net_event(inst.GUID, "grillsmoke")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst:ListenForEvent("grillsmoke", OnGrillSmoke)

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

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_small_grill_item"})

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredGrill)
	inst.components.workable:SetOnWorkCallback(OnHitGrill)
	inst.components.workable:SetWorkLeft(3)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function grillbigfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_cookware_big_grill.tex")
	minimap:SetPriority(3)

	MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("quagmire_grill")
    inst.AnimState:SetBuild("quagmire_grill")
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	inst.AnimState:SetFinalOffset(4)

	inst:AddTag("structure")
	inst:AddTag("stewer")
	inst:AddTag("grill_big")

	inst._smoke = net_event(inst.GUID, "grillsmoke")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst:ListenForEvent("grillsmoke", OnGrillSmoke)

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

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_cookware_grill_item"})

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredGrill)
	inst.components.workable:SetOnWorkCallback(OnHitGrill)
	inst.components.workable:SetWorkLeft(3)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("kyno_cookware_grill", grillbigfn, assets, prefabs),
Prefab("kyno_cookware_small_grill", grillsmallfn, assets, prefabs)