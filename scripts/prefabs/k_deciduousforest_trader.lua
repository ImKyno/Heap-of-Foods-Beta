local brain = require("brains/deciduousforesttraderbrain")

local assets =
{
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("ANIM", "anim/quagmire_swampig_build.zip"),
	Asset("ANIM", "anim/quagmire_swampig_extras.zip"),
	Asset("ANIM", "anim/kyno_deciduousforest_trader_build.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),

	Asset("SOUND", "sound/pig.fsb"),

	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"kyno_hofbirthday_partitiohat",
}

local sounds =
{
	attack = "dontstarve/pig/attack",
	hit    = "dontstarve/pig/oink",
	death  = "dontstarve/pig/grunt",
	talk   = "dontstarve/pig/grunt",
	buff   = "dontstarve/pig/grunt",
}

local FORGETABLE_RECIPES = {} -- Recipes that do not have a limit flag will be forgot on rerolling.

local WARES                             =
{
	-- Make sure there is at least one trade that has min = 1 in this table.
	ALWAYS                              =
	{
		{
			["kyno_itemslicer_gold"]        = { recipe = "meadowislandtrader_kyno_itemslicer_gold",        min = 6,  max = 6,  limit = 6  },
		},
	},

	-- Make sure to always have seasonal seeds available to trade.
	SEASONAL                                =
	{
		[SEASONS.AUTUMN]                    =
		{
			["kyno_energycan"]              = { recipe = "meadowislandtrader_kyno_energycan",              min = 3,  max = 5              },
		},

		[SEASONS.WINTER]                    =
		{
			["kyno_cokecan"]                = { recipe = "meadowislandtrader_kyno_cokecan",                min = 3,  max = 5              },
		},

		[SEASONS.SPRING]                    =
		{
			["kyno_seeds_kit_rice"]         = { recipe = "meadowislandtrader_kyno_seeds_kit_rice",         min = 15, max = 15             },
		},

		[SEASONS.SUMMER]                    =
		{
			["kyno_sodacan"]                = { recipe = "meadowislandtrader_kyno_sodacan",                min = 3,  max = 5              },
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
	local no_stock = not inst:HasStock() and not inst:CanTrade()

	if no_stock then
		inst:EnablePrototyper(false)
	end

	inst.sg.mem.didtrade = true
	inst:PushEvent("dotrade", { no_stock = no_stock })
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
		prototyper.trees = TUNING.PROTOTYPER_TREES.DECIDUOUSSHOP_TWO
		prototyper.restrictedtag = "pigfriendly" -- All characters have this tag except Wurt. We don't do business with mermfolk!
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

	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 35, true)

	-- Disabled until we get the fruit tree saplings to sell.
	--[[
	local seasonalwares = inst.WARES.SEASONAL[TheWorld.state.season]

	if seasonalwares then
		inst:AddWares(seasonalwares)
	end
	]]--

	-- inst:EnablePrototyper(inst:HasTag("revealed"))
	inst:EnablePrototyper(inst:HasTag("revealed") and inst:CanTrade())
end

local function OnTimerDone(inst, data)
	if data then
		if data.name == "refreshwares" then
			local x, y, z = inst.Transform:GetWorldPosition()

			if IsAnyPlayerInRangeSq(x, y, z, PLAYER_CAMERA_SEE_DISTANCE_SQ, true) and inst.entity:IsVisible() then
				-- We are outside and a nearby alive player is too close, let us reschedule the timer.
				inst.components.timer:StartTimer("refreshwares", 5)
			else
				inst:RerollWares()
				inst.components.timer:StartTimer("refreshwares", TUNING.KYNO_DECIDUOUSFORESTTRADER_REFRESHWARES)
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

	inst.hatless = data.hatless
end

local function OnWorldInit(inst)
	-- Anniversary Event.
	if IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) then
		inst.AnimState:OverrideSymbol("swap_hat", "hat_hofbirthday_partitio", "swap_hat")
	end
end

local function SetRevealed(inst, revealed)
	if revealed then
		inst:AddTag("revealed")
		-- inst:EnablePrototyper(inst:HasStock())
		inst:EnablePrototyper(inst:HasStock() and inst:CanTrade())
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

local function IsHouseRepaired(inst)
	local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
	return home ~= nil and home:IsValid() and home.HouseRepaired
end

local function CanTrade(inst)
	return IsHouseRepaired(inst) and inst:HasStock()
end

local function IsNearMerm(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, TUNING.RESEARCH_MACHINE_DIST, true)

	for _, player in ipairs(players) do
		if player:HasTag("playermerm") then
			return player
		end
	end
end

-- Unlike Sammy, Partitio does not have a regular hat, just his anniversary one.
-- We can only get it if the event is currently active.
local function ShouldAcceptItem(inst, item, giver)
	if not inst:IsHouseRepaired() then
		return false
	end

	if IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) then
		if item.components.inventoryitem ~= nil and item:HasAnyTag("partitiofood", "anniversaryfood") 
		and not inst:HasTag("hatless") and not giver:HasTag("playermerm") then -- We don't take gifts from mermfolk!
			return true
		end
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	local no_stock = not inst:HasStock() and not inst:CanTrade()
	local hat = SpawnPrefab("kyno_hofbirthday_partitiohat")

	if hat ~= nil then
		if giver ~= nil and giver.components.inventory ~= nil then
			giver.components.inventory:GiveItem(hat, nil, inst:GetPosition())
		else
			inst.components.inventory:DropItem(hat)
		end
	end

	inst.sg:GoToState("dotradehat")
	inst:PushEvent("dotrade", { no_stock = no_stock })
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
end

local function AllNightTest(inst)
	if inst.segs and inst.segs["night"] + inst.segs["dusk"] >= 16 then
		return true
	end

	return false
end

local function GetStatus(inst, viewer)
	return (IsHouseRepaired(inst) and "HOUSE_REPAIRED")
	or "GENERIC"
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
	minimap:SetIcon("kyno_deciduousforest_seller.tex")
	minimap:SetPriority(5)

	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 50, .5)

	inst.sounds = sounds

	inst.AnimState:SetBank("pigman")
	inst.AnimState:SetBuild("quagmire_swampig_build")
	inst.AnimState:AddOverrideBuild("kyno_deciduousforest_trader_build")
	inst.AnimState:PlayAnimation("idle_loop")

	inst.AnimState:OverrideSymbol("pig_arm",   "quagmire_swampig_build", "pig_arm2")
	inst.AnimState:OverrideSymbol("pig_head",  "quagmire_swampig_build", "pig_head1")
	inst.AnimState:OverrideSymbol("pig_torso", "quagmire_swampig_build", "pig_torso4")
	inst.AnimState:OverrideSymbol("swap_hat",  "quagmire_swampig_build", "swap_hat2")

	inst.AnimState:Hide("ARM_carry_up")

	inst:AddTag("character")
	inst:AddTag("pig")
	inst:AddTag("trader")
	inst:AddTag("deciduousforesttrader")
	inst:AddTag("_named")

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -400, 0)
	inst.components.talker.name_colour = Vector3(130/255, 109/255, 57/255)
	-- inst.components.talker.chaticon = "npcchatflair_deciduousforesttrader"
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

	inst.SetRevealed = SetRevealed
	inst.SetHatless = SetHatless

	inst.AllNightTest = AllNightTest
	inst.IsHouseRepaired = IsHouseRepaired
	inst.CanTrade = CanTrade
	inst.IsNearMerm = IsNearMerm

	inst:AddComponent("craftingstation")
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_DECIDUOUSFORESTTRADER_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.KYNO_DECIDUOUSFORESTTRADER_RUNSPEED

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = true

	inst:AddComponent("named")
	inst.components.named.nameformat = STRINGS.DECIDUOUSFORESTTRADER
	inst.components.named.possiblenames = STRINGS.DECIDUOUSFORESTTRADER_TITLES
	inst.components.named:PickNewName()

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("refreshwares", TUNING.KYNO_DECIDUOUSFORESTTRADER_REFRESHWARES)
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGdeciduousforesttrader")

	inst:ListenForEvent("clocksegschanged", function(world, data)
		inst.segs = data
	end, TheWorld)

	inst.inittask = inst:DoTaskInTime(0, Initialize)
	inst:DoTaskInTime(0, OnWorldInit)

	-- We somehow got a Partitio without a home. Kill it! Kill it with fire!
	--[[
	inst:DoTaskInTime(2, function(inst)
		print("Heap of Foods Mod - Found a Partitio without a home. Removing it!")
		if inst.components.homeseeker == nil then
			inst:Remove()
		end
	end)
	]]--

	return inst
end

return Prefab("kyno_deciduousforest_seller", fn, assets, prefabs)