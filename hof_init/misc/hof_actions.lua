-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local STRINGS			= _G.STRINGS
local ACTIONS 			= _G.ACTIONS
local ActionHandler		= _G.ActionHandler
local SpawnPrefab		= _G.SpawnPrefab
local cooking           = require("cooking")
local brewing           = require("hof_brewing")
local UpvalueHacker     = require("hof_upvaluehacker")

-- Coffee Plant can be Only Fertilized by Ashes.
AddComponentAction("USEITEM", "fertilizer", function(inst, doer, target, actions)
    if actions[1] == ACTIONS.FERTILIZE and inst:HasTag("coffeefertilizer2") ~= target:HasTag("kyno_coffeebush") then
        actions[1] = nil
    end
end)

-- Action for the Salt.
AddAction("SALT", STRINGS.ACTIONS.SALT, function(act)
	local saltable = act.target and act.target.components.saltable or nil
	
	if act.invobject and saltable ~= nil then
		saltable:AddSalt()
		act.doer:PushEvent("saltfood") -- Play a cool sound, yay.
		act.invobject.components.stackable:Get(1):Remove()
		return true
	end
end)

ACTIONS.SALT.mount_valid = true

AddComponentAction("USEITEM", "salter", function(inst, doer, target, actions)
	if target:HasTag("saltable") and not target:HasTag("saltedfood") then
		table.insert(actions, ACTIONS.SALT)
	end
end)

-- Action for the Slaughter Tools.
AddAction("FLAY", STRINGS.ACTIONS.FLAY, function(act)
	if act.target and act.target.components.health and not act.target.components.health:IsDead() and act.target.components.lootdropper then
		act.target.components.health.invincible = false
	
		-- if act.doer.prefab == "wathgrithr" then
		if act.doer:HasTag("animal_butcher") then -- Characters with this tag gets 2 extra meats!
			act.target.components.lootdropper:SpawnLootPrefab("meat")
			act.target.components.lootdropper:SpawnLootPrefab("meat")
		end
			
		if act.invobject ~= nil and act.invobject.components.finiteuses then
			act.invobject.components.finiteuses:Use(1)
		end					
		
		act.target.components.health:Kill()
		
		-- Needed for the Accomplishment.
		local data = {doer = act.doer, target = act.target, tool = act.invobject}
        act.doer:PushEvent("hof_FlayOther", data)
        act.target:PushEvent("hof_Flayed", data)
		
		return true
	end
end)

ACTIONS.FLAY.distance = 2
ACTIONS.FLAY.priority = 3
ACTIONS.FLAY.mount_valid = true

AddComponentAction("USEITEM", "slaughteritem", function(inst, doer, target, actions, right)
	if target:HasTag("slaughterable") then
		table.insert(actions, ACTIONS.FLAY)
	end
end)

-- For slicing items into something else.
AddAction("SLICE", STRINGS.ACTIONS.SLICE, function(act)
	local sliceable = act.target and act.target.components.sliceable or nil
	
	if act.invobject and sliceable ~= nil then
		sliceable:OnSlice()
		act.doer.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")
		return true
	end
end)

ACTIONS.SLICE.priority = 2
ACTIONS.SLICE.mount_valid = true

AddAction("SLICESTACK", STRINGS.ACTIONS.SLICESTACK, function(act)
	local sliceable = act.target and act.target.components.sliceable or nil
	local owner = act.invobject.components.inventoryitem:GetGrandOwner()
	
	if act.invobject and sliceable ~= nil then
		sliceable:OnSliceStack()
		owner.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")
		return true
	end
end)

ACTIONS.SLICESTACK.priority = 2
ACTIONS.SLICESTACK.mount_valid = true

-- For slicing items inside the inventory, such as Coconuts.
AddComponentAction("USEITEM", "slicer", function(inst, doer, target, actions, right)
	local act = target.replica.stackable ~= nil and target.replica.stackable:IsStack() and 
	(doer.components.playercontroller ~= nil and doer.components.playercontroller:IsControlPressed(CONTROL_FORCE_STACK)) and
	ACTIONS.SLICESTACK or ACTIONS.SLICE
	
	if target:HasTag("sliceable") then
		table.insert(actions, act)
	end
end)

AddComponentAction("INVENTORY", "slicer", function(inst, doer, actions, right)
	local act = inst.replica.stackable ~= nil and inst.replica.stackable:IsStack() and 
	(doer.components.playercontroller ~= nil and doer.components.playercontroller:IsControlPressed(CONTROL_FORCE_STACK)) and
	ACTIONS.SLICESTACK or ACTIONS.SLICE

	if inst:HasTag("sliceable") then
		table.insert(actions, act)
	end
end)

AddAction("STORESOUL", STRINGS.ACTIONS.STORESOUL, function(act)
	local bottle = act.target and act.target.components.unwrappable or nil
	
	if act.invobject:HasTag("soul") and act.target:HasTag("soul_storage") then
		local bottle_soul = SpawnPrefab("kyno_bottle_soul")
		
		act.doer.components.inventory:GiveItem(bottle_soul) 
		act.doer.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out")
		
		act.invobject.components.stackable:Get(1):Remove()
		act.target.components.stackable:Get(1):Remove()
		return true
	end
end)

ACTIONS.STORESOUL.mount_valid = true
ACTIONS.UNWRAP.mount_valid = true -- This is for unwrapping bundles while on beefalo.

AddComponentAction("USEITEM", "soul", function(inst, doer, target, actions, right)
	if target:HasTag("soul_storage") and doer:HasTag("soulstealer") and inst:HasTag("soul") then
		table.insert(actions, ACTIONS.STORESOUL)
	end
end)

-- Action for healing Ruined Sugarwood Trees.
AddAction("SAPHEAL", STRINGS.ACTIONS.SAPHEAL, function(act)
	 if act.target ~= nil and act.target:HasTag("sap_healable") then
	    act.invobject.components.saphealer:Heal(act.target)
		return true
	end
end)

ACTIONS.SAPHEAL.mount_valid = true

AddComponentAction("USEITEM", "saphealer", function(inst, doer, target, actions, right)
	if target and target:HasTag("sap_healable") then
		table.insert(actions, ACTIONS.SAPHEAL)
	end
end)

-- Action for Milking animals. If Beefalo Milk mod is enabled, use their system instead?
-- if not _G.KnownModIndex:IsModEnabled("workshop-436654027") or _G.KnownModIndex:IsModEnabled("workshop-1277605967") or
-- _G.KnownModIndex:IsModEnabled("workshop-2431867642") or _G.KnownModIndex:IsModEnabled("workshop-1935156140") then
AddAction("PULLMILK", STRINGS.ACTIONS.PULLMILK, function(act)
	local milkable = act.target and act.target.components.milkableanimal or nil
	
	if act.invobject and milkable ~= nil then
		act.target.components.milkableanimal:Milk(act.doer)
		act.doer.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
		act.invobject.components.finiteuses:Use(1)
		return true
	end
end)

ACTIONS.PULLMILK.priority = 2
ACTIONS.PULLMILK.mount_valid = true
ACTIONS.PULLMILK.encumbered_valid = true

AddComponentAction("USEITEM", "milker", function(inst, doer, target, actions)
	if target and target:HasTag("milkableanimal") and inst:HasTag("bucket_empty") 
	and not target:HasTag("is_frozen") and not target:HasTag("is_thawing") then
		table.insert(actions, ACTIONS.PULLMILK)
	end
end)

-- Action for Brewing.
AddAction("BREWER", STRINGS.ACTIONS.BREWER, function(act)
	if act.target.components.cooker ~= nil then
        local cook_pos = act.target:GetPosition()
        local ingredient = act.doer.components.inventory:RemoveItem(act.invobject)

        ingredient.Transform:SetPosition(cook_pos:Get())

        if not act.target.components.cooker:CanCook(ingredient, act.doer) then
            act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
            return false
        end

        if ingredient.components.health ~= nil and ingredient.components.combat ~= nil then
            act.doer:PushEvent("killed", { victim = ingredient })
        end

        local product = act.target.components.cooker:CookItem(ingredient, act.doer)
        if product ~= nil then
            act.doer.components.inventory:GiveItem(product, nil, cook_pos)
            return true
        elseif ingredient:IsValid() then
            act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
        end
        return false
    elseif act.target.components.brewer ~= nil then
        if act.target.components.brewer:IsCooking() then
            return true
        end
        local container = act.target.components.container
        if container ~= nil and container:IsOpenedByOthers(act.doer) then
            return false, "INUSE"
        elseif not act.target.components.brewer:CanCook() then
            return false
        end
        act.target.components.brewer:StartCooking(act.doer)
        return true
    elseif act.target.components.cookable ~= nil
        and act.invobject ~= nil
        and act.invobject.components.cooker ~= nil then

        local cook_pos = act.target:GetPosition()

        if act.doer:GetPosition():Dist(cook_pos) > 2 then
            return false, "TOOFAR"
        end

        local owner = act.target.components.inventoryitem:GetGrandOwner()
        local container = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
        local stacked = act.target.components.stackable ~= nil and act.target.components.stackable:IsStack()
        local ingredient = stacked and act.target.components.stackable:Get() or act.target

        if ingredient ~= act.target then
            ingredient.Transform:SetPosition(cook_pos:Get())
        end

        if not act.invobject.components.cooker:CanCook(ingredient, act.doer) then
            if container ~= nil then
                container:GiveItem(ingredient, nil, cook_pos)
            elseif stacked and ingredient ~= act.target then
                act.target.components.stackable:SetStackSize(act.target.components.stackable:StackSize() + 1)
                ingredient:Remove()
            end
            return false
        end

        if ingredient.components.health ~= nil and ingredient.components.combat ~= nil then
            act.doer:PushEvent("killed", { victim = ingredient })
        end

        local product = act.invobject.components.cooker:CookItem(ingredient, act.doer)
        if product ~= nil then
            if container ~= nil then
                container:GiveItem(product, nil, cook_pos)
            else
                product.Transform:SetPosition(cook_pos:Get())
                if stacked and product.Physics ~= nil then
                    local angle = math.random() * 2 * PI
                    local speed = math.random() * 2
                    product.Physics:SetVel(speed * math.cos(angle), GetRandomWithVariance(8, 4), speed * math.sin(angle))
                end
            end
            return true
        elseif ingredient:IsValid() then
            if container ~= nil then
                container:GiveItem(ingredient, nil, cook_pos)
            elseif stacked and ingredient ~= act.target then
                act.target.components.stackable:SetStackSize(act.target.components.stackable:StackSize() + 1)
                ingredient:Remove()
            end
        end
        return false
    end
end)

ACTIONS.BREWER.priority = 1
ACTIONS.BREWER.mount_valid = true

local oldHARVESTfn = ACTIONS.HARVEST.fn
function ACTIONS.HARVEST.fn(act, ...)
    if act.target and act.target.components.brewer and act.target:HasTag("brewer") then
        return act.target.components.brewer:Harvest(act.doer)
    else
        return oldHARVESTfn(act, ...)
    end
end

AddComponentAction("SCENE", "brewer", function(inst, doer, actions, right)
	if not inst:HasTag("burnt") and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
		if inst:HasTag("donecooking") then
			table.insert(actions, ACTIONS.HARVEST)
		elseif right and (
		(   inst:HasTag("readytocook") and
			(not inst:HasTag("mastercookware") or doer:HasTag("masterchef"))
		) or
			(   inst.replica.container ~= nil and
				inst.replica.container:IsFull() and
				inst.replica.container:IsOpenedBy(doer)
			)
		) then
			table.insert(actions, ACTIONS.BREWER)
		end
	end
end)

-- Action for reading the Brewbook.
AddAction("READBREWBOOK", STRINGS.ACTIONS.READBREWBOOK, function(act)
    local target = act.target or act.invobject
	
    if target ~= nil and act.doer ~= nil then
		if target.components.brewbook ~= nil then
			target.components.brewbook:Read(act.doer)
			return true
		end
	end
end)

ACTIONS.READBREWBOOK.priority = 1
ACTIONS.READBREWBOOK.mount_valid = true
ACTIONS.READBREWBOOK.encumbered_valid = true

AddComponentAction("INVENTORY", "brewbook", function(inst, doer, actions)
	table.insert(actions, ACTIONS.READBREWBOOK)
end)

-- Action for installing Cookware on Fire Pit / Tools.
AddAction("INSTALLCOOKWARE", STRINGS.ACTIONS.INSTALLCOOKWARE, function(act)
	local target = act.target or act.invobject
	
	if target ~= nil and act.doer ~= nil then
		if act.target.components.cookwareinstaller ~= nil then
            local count

            if act.target.components.cookwareinstaller:IsAcceptingStacks() then
                count = (
                    act.target.components.inventory ~= nil and
                    act.target.components.inventory:CanAcceptCount(act.invobject)
                ) or (
                    act.invobject.components.stackable ~= nil and
                    act.invobject.components.stackable.stacksize
                )
                or 1

                if count <= 0 then
                    return false
                end
            end

			local able, reason = act.target.components.cookwareinstaller:AbleToAccept(act.invobject, act.doer, count)
			if not able then
				return false, reason
			end

			act.target.components.cookwareinstaller:AcceptGift(act.doer, act.invobject, count)

			return true
		end
	end
end)

ACTIONS.INSTALLCOOKWARE.distance = 1
ACTIONS.INSTALLCOOKWARE.priority = 5
ACTIONS.INSTALLCOOKWARE.mount_valid = true

AddComponentAction("USEITEM", "cookwareinstallable", function(inst, doer, target, actions, right)
	if target:HasTag("cookware_installable") and not target:HasTag("firepit_with_cookware") then
		table.insert(actions, ACTIONS.INSTALLCOOKWARE)
	end
	
	if target:HasTag("cookware_post_installable") and not target:HasTag("firepit_with_cookware") then
		table.insert(actions, ACTIONS.INSTALLCOOKWARE)
	end
	
	if target:HasTag("cookware_other_installable") then
		table.insert(actions, ACTIONS.INSTALLCOOKWARE)
	end 
end)

local function GetIngredients(card)
	local ret = {}
	
	for i, data in pairs(card.ingredients) do
		for j = 1, data[2] do
			table.insert(ret, data[1])
		end
	end

	return ret
end

-- Action for learning Recipe Cards.
AddAction("LEARNRECIPECARD", STRINGS.ACTIONS.LEARNRECIPECARD, function(act)
	local target = act.target or act.invobject

	if target ~= nil and act.doer ~= nil then
		local cooker_recipes = cooking.recipes[target.cooker_name]
		local brewer_recipes = brewing.recipes[target.brewer_name]
		
		if target:HasTag("brewingrecipecard") then
			if brewer_recipes then
				local card_def = brewer_recipes[target.recipe_name] and brewer_recipes[target.recipe_name].card_def
				act.doer:PushEvent("learncookbookrecipe", {product = target.recipe_name, ingredients = GetIngredients(card_def)})
				act.doer:PushEvent("learnrecipecard") -- Play a cool sound, yay.

				target:Remove()
				
				return true
			end
		else
			if cooker_recipes then
				local card_def = cooker_recipes[target.recipe_name] and cooker_recipes[target.recipe_name].card_def
				act.doer:PushEvent("learncookbookrecipe", {product = target.recipe_name, ingredients = GetIngredients(card_def)})
				act.doer:PushEvent("learnrecipecard")

				target:Remove()
			
				return true
			end
		end
	end
end)

AddComponentAction("INVENTORY", "learnablerecipecard", function(inst, doer, actions)	
	table.insert(actions, ACTIONS.LEARNRECIPECARD)
end)

-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
-- Hope they don't smack and bonk my head...
local _FISHfn = ACTIONS.FISH.fn
function ACTIONS.FISH.fn(act, ...)
    if act.doer and act.doer.components.fishingrod then
        act.doer.components.fishingrod:StartFishing(act.target, act.doer)
        return true
    end
    return _FISHfn(act, ...)
end

local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(_G.EntityScript.CollectActions, "COMPONENT_ACTIONS")
local USEITEM = COMPONENT_ACTIONS.USEITEM
local EQUIPPED = COMPONENT_ACTIONS.EQUIPPED

local _USEITEMfishingrod = USEITEM.fishingrod
function USEITEM.fishingrod(inst, doer, target, actions, ...)
    if inst.replica.fishingrod:HasCaughtFish() then
        if doer.sg == nil or doer.sg:HasStateTag("fishing") then
            table.insert(actions, ACTIONS.REEL)
        end
    else
        return _USEITEMfishingrod(inst, doer, target, actions, ...)
    end
end

local _EQUIPPEDfishingrod = EQUIPPED.fishingrod
function EQUIPPED.fishingrod(inst, doer, target, actions, ...)
    if inst.replica.fishingrod:HasCaughtFish() then
        if doer.sg == nil or doer.sg:HasStateTag("fishing") then
            table.insert(actions, ACTIONS.REEL)
        end
    else
        return _EQUIPPEDfishingrod(inst, doer, target, actions, ...)
    end
end

-- Action String overrides.
ACTIONS.GIVE.stroverridefn = function(act)
	if act.target:HasTag("serenity_installable") and act.invobject:HasTag("serenity_installer") then
		return subfmt(STRINGS.KYNO_INSTALL_INSTALLER, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("sugartree_installable") and act.invobject:HasTag("serenity_installer") then
		return subfmt(STRINGS.KYNO_INSTALL_TAPPER, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("cookingpot_hanger") and act.invobject:HasTag("pot_installer") then
		return subfmt(STRINGS.KYNO_INSTALL_POT, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("serenity_oven") and act.invobject:HasTag("casserole_installer") then
		return subfmt(STRINGS.KYNO_INSTALL_POT, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("elderpot_rubble") and act.invobject:HasTag("serenity_repairtool") then
		return subfmt(STRINGS.KYNO_REPAIR_TOOL, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("infestable_tree") and act.invobject:HasTag("squirrel") then
		return subfmt(STRINGS.KYNO_INFEST_TREE, {item = act.invobject:GetBasicDisplayName()})
	end
	
	if act.target:HasTag("chicken2") then
		return subfmt(STRINGS.KYNO_FEED_CHICKEN, {item = act.invobject:GetBasicDisplayName()})
	end
end

ACTIONS.PICK.stroverridefn = function(act)
	if act.target.prefab == "kyno_sugartree_sapped" then
		return STRINGS.KYNO_HARVEST_SUGARTREE
	end
	
	if act.target.prefab == "kyno_sugartree_ruined" then
		return STRINGS.KYNO_HARVEST_SUGARTREE_RUINED
	end
	
	if act.target.prefab == "kyno_saltrack" then
		return STRINGS.KYNO_HARVEST_SALTRACK
	end
	
	if act.target.prefab == "kyno_cookware_syrup" then
		return STRINGS.KYNO_HARVEST_POTSYRUP
	end
	
	if act.target.prefab == "kyno_rockflippable" then
		return STRINGS.KYNO_PICKUP_ROCKFLIPPABLE
	end
	
	if act.target.prefab == "kyno_rockflippable_cave" then
		return STRINGS.KYNO_PICKUP_ROCKFLIPPABLE
	end
end

ACTIONS.FLAY.stroverridefn = function(act)
    return act.invobject ~= nil
	and act.invobject.GetSlaughterActionString ~= nil
	and act.invobject:GetSlaughterActionString(act.target)
	or nil
end

ACTIONS.EAT.stroverridefn = function(act)
	local obj = act.target or act.invobject
	
	if obj:HasTag("drinkable_food") then 
		return STRINGS.KYNO_DRINK_FOOD 
	end
end

ACTIONS.UNWRAP.stroverridefn = function(act)
	local obj = act.target or act.invobject
	
	if obj:HasTag("canned_food") then
		return STRINGS.KYNO_OPEN_CAN
	end
	
	if obj:HasTag("bottled_soul") then
		return STRINGS.KYNO_OPEN_BOTTLE_SOUL
	end
end

ACTIONS.STORE.stroverridefn = function(act)
	if act.target:HasTag("brewer") then
		return STRINGS.ACTIONS.BREWER
	end
end

ACTIONS.INSTALLCOOKWARE.stroverridefn = function(act)
	if act.target:HasTag("cookware_post_installable") then
		return STRINGS.KYNO_INSTALL_POT
	end 
	
	if act.target:HasTag("elderpot_rubble") then
		return STRINGS.KYNO_REPAIR_TOOL
	end
	
	if act.target:HasTag("infestable_tree") then 
		return STRINGS.KYNO_INFEST_TREE
	end
	
	if act.target:HasTag("cookware_other_installable") then
		return STRINGS.KYNO_INSTALL_INSTALLER
	end
	
	if act.target:HasTag("cookware_pond_installable") then
		return STRINGS.KYNO_INSTALL_SALTRACK
	end
end

ACTIONS.LEARNRECIPECARD.stroverridefn = function(act)
	if act.invobject:HasTag("brewingrecipecard") then
		return STRINGS.ACTIONS.LEARNRECIPECARD2
	end
end