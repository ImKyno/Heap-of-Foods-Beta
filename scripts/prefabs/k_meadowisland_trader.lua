local brain = require("brains/meadowislandtraderbrain")

local assets =
{
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("ANIM", "anim/merm_trader1_build.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_trader_build.zip"),
	
	-- Anniversary Event.
	-- Asset("ANIM", "anim/kyno_hofbirthday_merm_build.zip"),
	-- Asset("ANIM", "anim/kyno_hofbirthday_merm_trader_build.zip"),
	
	Asset("SOUND", "sound/merm.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"kyno_hofbirthday_sammyhat",
	"kyno_sammyhat",
}

local sounds = 
{
    attack = "dontstarve/creatures/merm/attack",
    hit    = "dontstarve/creatures/merm/hurt",
    death  = "dontstarve/creatures/merm/death",
    talk   = "dontstarve/creatures/merm/idle",
    buff   = "dontstarve/characters/wurt/merm/warrior/yell",
}

local FORGETABLE_RECIPES = {} -- Recipes that do not have a limit flag will be forgot on rerolling.

local WARES                             = 
{	
	-- Make sure there is at least one trade that has min = 1 in this table.
	ALWAYS                              = 
	{
		{
			["kyno_itemslicer_gold"]        = { recipe = "meadowislandtrader_kyno_itemslicer_gold",        min = 6,  max = 6,  limit = 6  },
			["kyno_bucket_metal"]           = { recipe = "meadowislandtrader_kyno_bucket_metal",           min = 6,  max = 6,  limit = 6  },
			["kyno_pineapple"]              = { recipe = "meadowislandtrader_kyno_pineapple",              min = 6,  max = 20, limit = 20 },
			["kyno_antchovycan"]            = { recipe = "meadowislandtrader_kyno_antchovycan",            min = 4,  max = 8,  limit = 8  },
			["kyno_tunacan"]                = { recipe = "meadowislandtrader_kyno_tunacan",                min = 2,  max = 5,  limit = 5  },
			["kyno_piko"]                   = { recipe = "meadowislandtrader_kyno_piko",                   min = 1,  max = 3,  limit = 3  },
			["kyno_chicken2"]               = { recipe = "meadowislandtrader_kyno_chicken2",               min = 1,  max = 4,  limit = 4  },
			["foliage"]                     = { recipe = "meadowislandtrader_foliage",                     min = 10, max = 25, limit = 25 },
			["barnacle"]                    = { recipe = "meadowislandtrader_barnacle",                    min = 5,  max = 12, limit = 12 },
		},
	},
	
	RANDOM_UNCOMMONS                        = 
	{
		{
			["kyno_meatcan"]                = { recipe = "meadowislandtrader_kyno_meatcan",                min = 3,  max = 6              }, 
			["kyno_tomatocan"]              = { recipe = "meadowislandtrader_kyno_tomatocan",              min = 3,  max = 7              },
			["kyno_beancan"]                = { recipe = "meadowislandtrader_kyno_beancan",                min = 3,  max = 8              },
			["kyno_piko_orange"]            = { recipe = "meadowislandtrader_kyno_piko_orange",            min = 1,  max = 3              },
			["kyno_shark_fin"]              = { recipe = "meadowislandtrader_kyno_shark_fin",              min = 1,  max = 7              },
			["tallbirdegg"]                 = { recipe = "meadowislandtrader_tallbirdegg",                 min = 1,  max = 5              },
		},
	},
	
	RANDOM_RARES                            = 
	{
		{
			["mandrake"]                    = { recipe = "meadowislandtrader_mandrake",                    min = 1,  max = 2              },
			["nukashine_sugarfree"]         = { recipe = "meadowislandtrader_nukashine_sugarfree",         min = 1,  max = 4              },
			["kyno_poison_froglegs"]        = { recipe = "meadowislandtrader_kyno_poison_froglegs",        min = 1,  max = 5              },
			["kyno_crabkingmeat"]           = { recipe = "meadowislandtrader_kyno_crabkingmeat",           min = 1,  max = 3              },
			["kyno_worm_bone"]              = { recipe = "meadowislandtrader_kyno_worm_bone",              min = 5,  max = 6              },
			["dug_kyno_coffeebush"]         = { recipe = "meadowislandtrader_dug_kyno_coffeebush",         min = 3,  max = 6              },
			["butter"]                      = { recipe = "meadowislandtrader_butter",                      min = 2,  max = 3              },
		},
	},
	
	RANDOM_ULTRARARES                       =
	{
		-- TO DO: Coffee Machine Kit
		{
			["kyno_bottlecap"]              = { recipe = "meadowislandtrader_kyno_bottlecap",              min = 3,  max = 6              },
		},
	},
	
	-- Make sure to always have seasonal seeds available to trade.
	SEASONAL                                = 
	{
		[SEASONS.AUTUMN]                    = 
		{
			-- TO DO: Srawberry Seeds
			["kyno_energycan"]              = { recipe = "meadowislandtrader_kyno_energycan",              min = 3,  max = 5              },
			["oceanfish_small_6_inv"]       = { recipe = "meadowislandtrader_oceanfish_small_6_inv",       min = 1,  max = 3              },
		},
		
		[SEASONS.WINTER]                    = 
		{
			-- TO DO: Artichoke Seeds
			["kyno_cokecan"]                = { recipe = "meadowislandtrader_kyno_cokecan",                min = 3,  max = 5              },
			["kyno_roe_pondfish"]           = { recipe = "meadowislandtrader_kyno_roe_pondfish",           min = 4,  max = 8              },
			["kyno_seeds_kit_forgetmelots"] = { recipe = "meadowislandtrader_kyno_seeds_kit_forgetmelots", min = 3,  max = 6              },
			["oceanfish_medium_8_inv"]      = { recipe = "meadowislandtrader_oceanfish_medium_8_inv",      min = 1,  max = 3              },
		},
		
		[SEASONS.SPRING]                    = 
		{
			["kyno_seeds_kit_rice"]         = { recipe = "meadowislandtrader_kyno_seeds_kit_rice",         min = 15, max = 15             },
			["kyno_seeds_kit_tillweed"]     = { recipe = "meadowislandtrader_kyno_seeds_kit_tillweed",     min = 3,  max = 6              },
			["oceanfish_small_7_inv"]       = { recipe = "meadowislandtrader_oceanfish_small_7_inv",       min = 1,  max = 3              },
		},
		
		[SEASONS.SUMMER]                    = 
		{
			-- TO DO: Melon Seeds
			["kyno_sodacan"]                = { recipe = "meadowislandtrader_kyno_sodacan",                min = 3,  max = 5              },
			["kyno_seeds_kit_firenettles"]  = { recipe = "meadowislandtrader_kyno_seeds_kit_firenettles",  min = 3,  max = 6              },
			["oceanfish_small_8_inv"]       = { recipe = "meadowislandtrader_oceanfish_small_8_inv",       min = 1,  max = 3              },
			["succulent_picked"]            = { recipe = "meadowislandtrader_succulent_picked",            min = 10, max = 25             },
		},
	},
	
	SPECIAL                                 = 
	{
		["isfullmoon"]                      =
		{
			["moon_cap"]                    = { recipe = "meadowislandtrader_moon_cap",                    min = 3,  max = 9              },
		},

		["islunarhailing"]                  = 
		{
			["kyno_moon_froglegs"]          = { recipe = "meadowislandtrader_kyno_moon_froglegs",          min = 3,  max = 9              },
		},
	},
}

for _, warebucket in pairs(WARES) do
    for _, prefabdata in pairs(warebucket) do
        for prefab, waredata in pairs(prefabdata) do
            if not table.contains(prefabs, prefab) then
                table.insert(prefabs, prefab)
            end
			
            if not waredata.limit then
                FORGETABLE_RECIPES[waredata.recipe] = true
            end
        end
    end
end

local function DoChatter(inst, name, index, cooldown)
	inst.sg.mem.canchattertimestamp = GetTime() + cooldown
	inst.components.talker:Chatter(name, index, nil, nil, CHATPRIORITIES.NOCHAT)
end

local function CanChatter(inst)
	return inst.sg.mem.canchattertimestamp == nil or (inst.sg.mem.canchattertimestamp < GetTime())
end

local function TryChatter(inst, name, index, cooldown)
	if inst:CanChatter() then
		inst:DoChatter(name, index, cooldown)
	end
end

local function OnTurnOn(inst)
	inst.components.timer:PauseTimer("refreshwares")
	inst.sg.mem.trading = true
end

local function OnTurnOff(inst)
	inst.components.timer:ResumeTimer("refreshwares")
	inst.sg.mem.trading = nil
end

local function OnActivate(inst)
	local no_stock = not inst:HasStock()
	
	if no_stock then
		inst:EnablePrototyper(false)
	end
	
	inst.sg.mem.didtrade = true
	inst:PushEvent("dotrade", {no_stock = no_stock, })
end

local function HasStock(inst)
	return #inst.components.craftingstation:GetRecipes() > 0
end

local function EnablePrototyper(inst, enabled)
	if not enabled then
		inst:RemoveComponent("prototyper")
	elseif inst.components.prototyper == nil then
		local prototyper = inst:AddComponent("prototyper")
		
		prototyper.onturnon = OnTurnOn
		prototyper.onturnoff = OnTurnOff
		prototyper.onactivate = OnActivate
		prototyper.trees = TUNING.PROTOTYPER_TREES.MEADOWSHOP_TWO
	end
end

local function AddWares(inst, wares)
	local craftingstation = inst.components.craftingstation
    
	for item, recipedata in pairs(wares) do
		local oldlimit = craftingstation:GetRecipeCraftingLimit(recipedata.recipe) or 0
		local caplimit = recipedata.limit or 255
		local newlimit = math.min(oldlimit + math.random(recipedata.min, recipedata.max), caplimit)
        
		if newlimit > 0 and newlimit > oldlimit then
			craftingstation:LearnItem(item, recipedata.recipe)
			craftingstation:SetRecipeCraftingLimit(recipedata.recipe, newlimit)
		end
	end
end

local function RerollWares(inst)
	local craftingstation = inst.components.craftingstation
	
	for recipe, _ in pairs(inst.FORGETABLE_RECIPES) do
		craftingstation:ForgetRecipe(recipe)
	end
	
	inst:AddWares(inst.WARES.ALWAYS[1])
	-- inst:AddWares(inst.WARES.STARTER[1])
    
	if math.random() < TUNING.KYNO_MEADOWISLANDTRADER_UNCOMMONS_ODDS then -- 25%
		inst:AddWares(inst.WARES.RANDOM_UNCOMMONS[math.random(#inst.WARES.RANDOM_UNCOMMONS)])
	end
	
	if math.random() < TUNING.KYNO_MEADOWISLANDTRADER_RARES_ODDS then -- 10%
		inst:AddWares(inst.WARES.RANDOM_RARES[math.random(#inst.WARES.RANDOM_RARES)])
	end
	
	if math.random() < TUNING.KYNO_MEADOWISLANDTRADER_ULTRARARES_ODDS then -- 5%
		inst:AddWares(inst.WARES.RANDOM_ULTRARARES[math.random(#inst.WARES.RANDOM_ULTRARARES)])
	end
	
	local seasonalwares = inst.WARES.SEASONAL[TheWorld.state.season]
	
	if seasonalwares then
		inst:AddWares(seasonalwares)
	end
	
	inst:EnablePrototyper(inst:HasTag("revealed"))
	-- inst:EnablePrototyper(inst:HasStock())
end

local function OnTimerDone(inst, data)
	if data then
		if data.name == "refreshwares" then
			local x, y, z = inst.Transform:GetWorldPosition()
			
			if IsAnyPlayerInRangeSq(x, y, z, PLAYER_CAMERA_SEE_DISTANCE_SQ, true) then
				-- A nearby alive player is too close, let us reschedule the timer.
				inst.components.timer:StartTimer("refreshwares", 5)
			else
				inst:RerollWares()
				inst.components.timer:StartTimer("refreshwares", TUNING.KYNO_MEADOWISLANDTRADER_REFRESHWARES)
			end
		end
	end
end

local function Initialize(inst)
	inst.inittask = nil
	inst.hattask = nil
	
	-- inst:AddWares(inst.WARES.STARTER[1])
	inst:RerollWares()
end

local function OnSave(inst, data)
	-- data.islunarhailing = inst.islunarhailing
	-- data.isfullmoon = inst.isfullmoon
	data.hatless = inst.hatless
end

local function OnLoad(inst, data)
	if inst.inittask ~= nil then
		inst.inittask:Cancel()
		inst.inittask = nil
	end
	
	if data and data.hatless then
		inst:SetHatless(true)
	end
	
	inst.islunarhailing = data.islunarhailing
	inst.isfullmoon = data.isfullmoon
	inst.hatless = data.hatless
end

local function SetIsLunarHailing(inst, active)
	if inst.islunarhailing ~= active then
		inst.islunarhailing = active
		
		if inst.islunarhailing then
			inst:AddWares(inst.WARES.SPECIAL["islunarhailing"])
		end
	end
end

local function SetIsFullMoon(inst, active)
	if inst.isfullmoon ~= active then
		inst.isfullmoon = active
		
		if inst.isfullmoon then
			inst:AddWares(inst.WARES.SPECIAL["isfullmoon"])
		end
	end
end

local function SetLordFruitFlyKilled(inst, active)
	if inst.fruitflykilled ~= active then
		inst.fruitflykilled = active
		
		if inst.fruitflykilled then
			inst.WARES.ALWAYS[1]["slow_farmplot_blueprint"] = { recipe = "meadowislandtrader_slow_farmplot_blueprint", min = 1, max = 2 }
			inst.FORGETABLE_RECIPES["meadowislandtrader_slow_farmplot_blueprint"] = true
			
			inst.WARES.ALWAYS[1]["fast_farmplot_blueprint"] = { recipe = "meadowislandtrader_fast_farmplot_blueprint", min = 1, max = 2 }
			inst.FORGETABLE_RECIPES["meadowislandtrader_fast_farmplot_blueprint"] = true
			
			inst:AddWares({ ["slow_farmplot_blueprint"] = { recipe = "meadowislandtrader_slow_farmplot_blueprint", min = 1, max = 2 } })
			inst:AddWares({ ["fast_farmplot_blueprint"] = { recipe = "meadowislandtrader_fast_farmplot_blueprint", min = 1, max = 2 } })
		end
	end
end

local function SetCelestialScionKilled(inst, active)
	if inst.celestialscionkilled ~= active then
		inst.celestialscionkilled = active

		if inst.celestialscionkilled then
			inst.WARES.RANDOM_ULTRARARES[1]["kyno_goldenapple"] = { recipe = "meadowislandtrader_kyno_goldenapple", min = 1, max = 3 }
			inst.FORGETABLE_RECIPES["meadowislandtrader_kyno_goldenapple"] = true

			inst:AddWares({ ["kyno_goldenapple"] = { recipe = "meadowislandtrader_kyno_goldenapple", min = 1, max = 3 } })
		end
	end
end

local function OnWorldInit(inst)
	inst:WatchWorldState("islunarhailing", inst.SetIsLunarHailing)
	inst:SetIsLunarHailing(TheWorld.state.islunarhailing)
	
	inst:WatchWorldState("isfullmoon", inst.SetIsFullMoon)
	inst:SetIsFullMoon(TheWorld.state.isfullmoon)
	
	-- Don't we need a LotFF tracker? I guess them being in WARES.ALWAYS will always override it on save/load anyway.

	if TheWorld.components.wagboss_tracker and TheWorld.components.wagboss_tracker:IsWagbossDefeated() then
		SetCelestialScionKilled(inst, true)
	end
	
	-- Anniversary Event.
	if IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) then
		-- inst.AnimState:AddOverrideBuild("kyno_hofbirthday_merm_trader_build")
		inst.AnimState:OverrideSymbol("swap_hat", "hat_hofbirthday_sammy", "swap_hat")
	end
end

local function SetRevealed(inst, revealed)
	if revealed then
		inst:AddTag("revealed")
		inst:EnablePrototyper(inst:HasStock())
	else
		inst:RemoveTag("revealed")
		inst:EnablePrototyper(false)
	end
end

local function SetHatless(inst, hatless)
	if hatless then
		inst:AddTag("hatless")
		inst.AnimState:Hide("hat")
		inst.AnimState:Hide("swap_hat")
		inst.components.trader:Disable()
		inst.hatless = true
	else
		inst:RemoveTag("hatless")
		inst.AnimState:Show("hat")
		inst.AnimState:Show("swap_hat")
		inst.components.trader:Enable()
		inst.hatless = false
	end
end

local function OnEntitySleep(inst)
	if inst.HiddenActionFn then
		inst:HiddenActionFn()
	end
end

local function ShouldAcceptItem(inst, item)
    if item.components.inventoryitem ~= nil and item:HasAnyTag("sammyfood", "anniversaryfood") and not inst:HasTag("hatless") then
        return true
    end
end

local function GetHatPrefab(inst)
	return IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) and "kyno_hofbirthday_sammyhat" or "kyno_sammyhat"
end

-- Sammy gives his hat to the player when gifted.
local function OnGetItemFromPlayer(inst, giver, item)
	local no_stock = not inst:HasStock()
	local hat = SpawnPrefab(GetHatPrefab(inst))
	
	if hat ~= nil then
		if giver ~= nil and giver.components.inventory ~= nil then
			giver.components.inventory:GiveItem(hat, nil, inst:GetPosition())
		else
			inst.components.inventory:DropItem(hat)
		end
	end

	inst.sg:GoToState("dotradehat")
	inst:PushEvent("dotrade", {no_stock = no_stock, })
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_seller.tex")
	minimap:SetPriority(5)
    
	inst.Transform:SetFourFaced()
    MakeCharacterPhysics(inst, 50, .5)
	
	inst.sounds = sounds

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("merm_trader1_build")
	inst.AnimState:AddOverrideBuild("kyno_meadowisland_trader_build")
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:Hide("ARM_carry_up")
	
	inst:AddTag("character")
    inst:AddTag("merm")
	inst:AddTag("trader")
	inst:AddTag("meadowislandtrader")
	inst:AddTag("_named")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -400, 0)
	inst.components.talker.name_colour = Vector3(130/255, 109/255, 57/255)
	-- inst.components.talker.chaticon = "npcchatflair_meadowislandtrader"
	inst.components.talker:MakeChatter()
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
	end
	
	inst:RemoveTag("_named")
	
	inst.WARES = WARES
	inst.FORGETABLE_RECIPES = FORGETABLE_RECIPES

	inst.DoChatter = DoChatter
	inst.CanChatter = CanChatter
	inst.TryChatter = TryChatter

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst.HiddenActionFn = nil
	inst.OnEntitySleep = OnEntitySleep

	inst.HasStock = HasStock
	inst.RerollWares = RerollWares
	inst.AddWares = AddWares
	inst.EnablePrototyper = EnablePrototyper

	inst.SetIsLunarHailing = SetIsLunarHailing
	inst.SetIsFullMoon = SetIsFullMoon
	inst.SetRevealed = SetRevealed
	inst.SetHatless = SetHatless
	
	inst:AddComponent("craftingstation")
	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_MEADOWISLANDTRADER_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.KYNO_MEADOWISLANDTRADER_RUNSPEED
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = true
	
	inst:AddComponent("named")
	inst.components.named.nameformat = STRINGS.MEADOWISLANDTRADER
	inst.components.named.possiblenames = STRINGS.MEADOWISLANDTRADER_TITLES
	inst.components.named:PickNewName()

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("refreshwares", TUNING.KYNO_MEADOWISLANDTRADER_REFRESHWARES)
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGmeadowislandtrader")

	inst.inittask = inst:DoTaskInTime(0, Initialize)
	inst:DoTaskInTime(0, OnWorldInit)
	
	inst:ListenForEvent("ms_lordfruitflykilled", function(world, data)
		SetLordFruitFlyKilled(inst, true)
	end, TheWorld)
	
	inst:ListenForEvent("wagboss_defeated", function(world, data)
		SetCelestialScionKilled(inst, true)
	end, TheWorld)
	
	-- We somehow got a Sammy without a home. Kill it! Kill it with fire!
	--[[
	inst:DoTaskInTime(2, function(inst)
		print("Heap of Foods - Found a Sammy without a home. Removing it!")
		if inst.components.homeseeker == nil then
			inst:Remove()
		end
	end)
	]]--

    return inst
end

return Prefab("kyno_meadowisland_seller", fn, assets, prefabs)