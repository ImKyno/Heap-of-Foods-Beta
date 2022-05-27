------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local STRINGS			= _G.STRINGS
local ACTIONS 			= _G.ACTIONS
local ActionHandler		= _G.ActionHandler
local SpawnPrefab		= _G.SpawnPrefab
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Coffee Plant can be Only Fertilized by Ashes.
AddComponentAction("USEITEM", "fertilizer", function(inst, doer, target, actions)
    if actions[1] == ACTIONS.FERTILIZE and inst:HasTag("coffeefertilizer2") ~= target:HasTag("kyno_coffeebush") then
        actions[1] = nil
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Action for the Salt.
AddAction("SALT", STRINGS.ACTIONS.SALT, function(act)
	local saltable = act.target and act.target.components.saltable or nil
	if act.invobject and saltable ~= nil then
		saltable:AddSalt()
		act.doer.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/salt_shake") -- Play a cool salting sound yay.
		act.invobject.components.stackable:Get(1):Remove()
		return true
	end
end)

ACTIONS.SALT.mount_valid = true

AddComponentAction("USEITEM", "salter", function(inst, doer, target, actions)
	if target:HasTag("saltable") then
		table.insert(actions, ACTIONS.SALT)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Action for the Slaughter Tools.
AddAction("FLAY", STRINGS.ACTIONS.FLAY, function(act)
	if act.target and act.target.components.health and not act.target.components.health:IsDead() and act.target.components.lootdropper then
		act.target.components.health.invincible = false
	
		if act.doer.prefab == "wathgrithr" then -- Wigfrid gets 2 extra meats!
			act.target.components.lootdropper:SpawnLootPrefab("meat")
			act.target.components.lootdropper:SpawnLootPrefab("meat")
		end
			
		if act.invobject ~= nil and act.invobject.components.finiteuses then
			act.invobject.components.finiteuses:Use(1)
		end					
		
		act.target.components.health:Kill()		
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

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- For chopping items inside the inventory, such as Coconuts.
AddComponentAction("USEITEM", "tool", function(inst, doer, target, actions, right)
	if target:HasTag("crackable") then
		table.insert(actions, ACTIONS.CHOP)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Action for storing Souls inside bottles. (Only Wortox).
AddPrefabPostInit("messagebottleempty", function(inst)
	inst:AddTag("soul_storage")
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

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SAPHEAL, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SAPHEAL, "give"))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Action for Milking animals. If Beefalo Milk mod is enabled, use their system instead?
-- if not _G.KnownModIndex:IsModEnabled("workshop-436654027") or _G.KnownModIndex:IsModEnabled("workshop-1277605967") or
-- _G.KnownModIndex:IsModEnabled("workshop-2431867642") or _G.KnownModIndex:IsModEnabled("workshop-1935156140") then
AddAction("PULLMILK", STRINGS.ACTIONS.PULLMILK, function(act)
	local milkable = act.target and act.target.components.milkable2 or nil
	if act.invobject and milkable ~= nil then
		act.target.components.milkable2:Milk(act.doer)
		act.doer.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/small")
		act.invobject.components.finiteuses:Use(1)
		return true
	end
end)

ACTIONS.PULLMILK.priority = 2
ACTIONS.PULLMILK.mount_valid = true
ACTIONS.PULLMILK.encumbered_valid = true

AddComponentAction("USEITEM", "milker", function(inst, doer, target, actions)
	if target and target:HasTag("milkable2") and not target:HasTag("sleeping") and inst:HasTag("bucket_empty")
	and not target.components.freezable:IsFrozen() then
		table.insert(actions, ACTIONS.PULLMILK)
	elseif target and target:HasTag("milkable2") and target:HasTag("koalefant") and inst:HasTag("bucket_empty") 
	and not target.components.freezable:IsFrozen() then
		table.insert(actions, ACTIONS.PULLMILK) -- Koalefants can be milked when they are sleeping.
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	if act.target:HasTag("elderpot_rubble") and act.invobject:HasTag("serenity_repairtool") then
		return subfmt(STRINGS.KYNO_REPAIR_TOOL, {item = act.invobject:GetBasicDisplayName()})
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

ACTIONS.COOK.stroverridefn = function(act)
	if act.target.prefab == "kyno_keg" or "kyno_preservesjar" then
		return STRINGS.KYNO_COOK_BREWER
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix for fuel items, because the action was "Give" instead of "Add Fuel".
ACTIONS.ADDFUEL.priority = 5
ACTIONS.ADDWETFUEL.priority = 5
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Quick open Canned Items.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UNWRAP, function(inst, action)
	local target = action.target or action.invobject
	if target.components.unwrappable and target:HasTag("canned_food") then
		return "doshortaction"
	else
		return "dolongaction"
	end
end))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------