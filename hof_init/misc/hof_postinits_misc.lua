-- Common Dependencies.
local _G              = GLOBAL
local next            = _G.next
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab
local cooking         = require("cooking")
local UpvalueHacker   = require("hof_upvaluehacker")

require("hof_debugcommands")

local HOF_HUMANMEAT       = GetModConfigData("HUMANMEAT")
local HOF_KEEPFOOD        = GetModConfigData("KEEPFOOD")
local HOF_ICEBOXSTACKSIZE = GetModConfigData("ICEBOXSTACKSIZE")

-- Favorite Mod Foods.
AddPrefabPostInit("wilson", function(inst)
    inst:AddTag("wislanhealer")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_steak_frites", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("wine_dragonfruit", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("willow", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("feijoada",       TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_pepper", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wolfgang", function(inst)
    inst:AddTag("mightyman")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_potato_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_potato",    TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wendy", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("icedtea",   TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_fig", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wx78", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("bowlofgears", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wickerbottom", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("tea",      TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teagreen", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("woodie", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_sliders", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("beer",          TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("waxwell", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_crab_roll", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teared",          TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wes", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("sharkfinsoup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("tartarsauce",  TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wathgrithr", function(inst)
	inst:AddTag("animal_butcher")

	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_pot_roast", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mead",            TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("webber", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("cottoncandy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise",  TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("winona", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("coffee",  TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("paleale", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wortox", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("jellyopop",         TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_pomegranate", TUNING.AFFINITY_15_CALORIES_HUGE)
    end

    if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.PREPAREDSOUL, FOODGROUP.OMNI })
    end
end)

AddPrefabPostInit("wormwood", function(inst)
	inst:AddTag("PREPAREDPOOP_eater")

	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gummy_cake",    TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_kokonut", TUNING.AFFINITY_15_CALORIES_HUGE)
    end

    if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI, FOODTYPE.PREPAREDPOOP })
    end
end)

AddPrefabPostInit("warly", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetPrefersEatingTag("warly_caneat") -- New tag that allows Warly to eat stuff.
	end
end)

AddPrefabPostInit("wurt", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("duriansoup",    1.93)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_durian",  1.93)
		inst.components.foodaffinity:AddPrefabAffinity("wine_durian",   1.93)
		inst.components.foodaffinity:AddPrefabAffinity("duriansplit",   1.93)
		inst.components.foodaffinity:AddPrefabAffinity("duriansoup",    1.93)
		inst.components.foodaffinity:AddPrefabAffinity("durianchicken", 1.93)
		inst.components.foodaffinity:AddPrefabAffinity("monstermuffin", 1.33)
    end
	
	if inst.components.locomotor ~= nil then
		inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.HOF_TIDALMARSH, true)
	end
end)

AddPrefabPostInit("walter", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("smores",             TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise_chicken", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wanda", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_candy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("nukacola",    TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wonkey", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("coconutwater", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_banana", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

-- Action for storing Souls inside bottles. (Only Wortox).
AddPrefabPostInit("messagebottleempty", function(inst)
	inst:AddTag("soul_storage")
end)

-- Players Have a Chance to Drop Long Pig. Except WX-78, Wurt, Wortox and Wormwood.
if HOF_HUMANMEAT then
    local longpig_characters =
	{
        "wilson",
        "willow",
        "wolfgang",
        "wendy",
        "wickerbottom",
        "woodie",
        "waxwell",
        "wes",
        "webber",
        "wathgrithr",
        "winona",
        "warly",
        "walter",
        "wanda",
    }

	local function LongPigPostinit(inst)
		local function OnDeathLongPig(inst)
			if math.random() < 0.33 then
				local x, y, z = inst.Transform:GetWorldPosition()
				local humanmeat = SpawnPrefab("kyno_humanmeat")
				
				if humanmeat ~= nil then
					if humanmeat.Physics ~= nil then
						local speed = 1 + math.random()
						local angle = math.random() * 1 * PI
						humanmeat.Physics:Teleport(x, y + 1, z)
						humanmeat.Physics:SetVel(speed * math.cos(angle), speed * 0.5, speed * math.sin(angle))
					else
						humanmeat.Transform:SetPosition(x, y, z)
					end
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:ListenForEvent("death", OnDeathLongPig)
	end

    for k,v in pairs(longpig_characters) do
        AddPrefabPostInit(v, LongPigPostinit)
    end
end

-- Ashes are Now a Fertilizer. Also using the Nutrients of Manure as placeholder for now, check "ash.lua".
local function AshPostinit(inst)
	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

    local function GetFertilizerKey(inst)
        return inst.prefab
    end

    local function fertilizerresearchfn(inst)
        return inst:GetFertilizerKey()
    end

    MakeDeployableFertilizerPristine(inst)

    inst:AddTag("fertilizerresearchable")
    inst:AddTag("coffeefertilizer2")
    inst:AddTag("fertilizer_volcanic")
	
    inst.GetFertilizerKey = GetFertilizerKey

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fertilizerresearchable")
    inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.SPOILEDFOOD_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.ash.nutrients)

    MakeDeployableFertilizer(inst)
end

AddPrefabPostInit("ash", AshPostinit)

-- Prevent food from spoiling in stations.
if HOF_KEEPFOOD then
	for k, v in pairs(TUNING.HOF_COOKPOTS) do
		AddPrefabPostInit(v, function(inst)
			if inst.components.stewer then
				inst.components.stewer.onspoil = function()
					inst.components.stewer.spoiltime = 1
					inst.components.stewer.targettime = _G.GetTime()
					inst.components.stewer.product_spoilage = 0
				end
			end
		end)
	end
end

-- For using Salt on Crock Pot foods. 
AddComponentPostInit("edible", function(self, inst)
    if not inst.components.saltable and inst:HasTag("preparedfood") then
        inst:AddComponent("saltable")
    end
	
	-- Stuffed Starch spice tweak.
	function self:GetHunger(eater)
		local multiplier = 1
		local spice_source = self.spice
		
		local ignore_spoilage = not self.degrades_with_spoilage or self.hungervalue < 0 or 
		(eater ~= nil and eater.components.eater ~= nil and eater.components.eater.ignoresspoilage)
		
		if not ignore_spoilage and self.inst.components.perishable ~= nil then
			if self.inst.components.perishable:IsStale() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.stale_hunger or self.stale_hunger
			elseif self.inst.components.perishable:IsSpoiled() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.spoiled_hunger or self.spoiled_hunger
				spice_source = nil
			end
		end
		
		if eater ~= nil and eater.components.foodaffinity ~= nil then
			local affinity_bonus = eater.components.foodaffinity:GetAffinity(self.inst)
			
			if affinity_bonus ~= nil then
				multiplier = multiplier * affinity_bonus
			end
		end
		
		if spice_source and TUNING.SPICE_MULTIPLIERS[spice_source] and TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER then
			multiplier = multiplier + TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER
		end
		
		return multiplier * self.hungervalue
	end
end)
-- Speed boost for the White Stone Road.
AddComponentPostInit("locomotor", function(inst)
	local QUGSM = inst.UpdateGroundSpeedMultiplier
	
	inst.UpdateGroundSpeedMultiplier = function(self)
	QUGSM(self)
	if self.wasoncreep == false and self:FasterOnRoad() and
	_G.TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition()) == WORLD_TILES.QUAGMIRE_CITYSTONE then
			self.groundspeedmultiplier = self.fastmultiplier
		end
	end
end)

-- inst.components.debuffable:RemoveAllDebuffs()
AddComponentPostInit("debuffable", function(self)
    function self:RemoveAllDebuffs()
        for name, _ in pairs(self.debuffs) do
            self:RemoveDebuff(name)
        end
    end
end)

-- Uuugh. Our mod spices have a nasty bug regarding foodaffinity, I don't know how to fix it yet.
-- This is a temporary workaround for it to work with favorite foods.
AddComponentPostInit("foodaffinity", function(self)
	 local spicedfoods = _G.MergeMaps(require("spicedfoods"), require("hof_spicedfoods"))
	
	function self:GetFoodBasePrefab(food)
		local prefab = food.prefab
		return spicedfoods[prefab] and spicedfoods[prefab].basename or prefab
	end
end)

-- For increasing fishing yields.
AddComponentPostInit("fishingrod", function(self)
    local oldReel = self.Reel
	
    function self:Reel(...)
        local ret = {oldReel(self, ...)}

		if self.target ~= nil and self.caughtfish ~= nil and self.fisherman ~= nil and self.fisherman:HasTag("skilledfisherman") then
			local extraFish = SpawnPrefab(self.caughtfish.prefab)
			
			if self.fisherman ~= nil and extraFish.components.weighable ~= nil then
				extraFish.components.weighable:SetPlayerAsOwner(self.fisherman)
			end
            
			local spawnPos = self.fisherman:GetPosition()
			local offset = spawnPos - self.target:GetPosition()
			spawnPos = spawnPos + offset:GetNormalized()
            
			self.inst:DoTaskInTime(.8, function()
				if extraFish.Physics ~= nil then
					extraFish.Physics:Teleport(spawnPos:Get())
				else
					extraFish.Transform:SetPosition(spawnPos:Get())
				end
			end)
				
			-- Random chance for one more extra fish.
			if math.random() < TUNING.KYNO_FISHINGBUFF_EXTRA_FISH_CHANCE then
				local extraFish2 = SpawnPrefab(self.caughtfish.prefab)
				
				if self.fisherman ~= nil and extraFish2.components.weighable ~= nil then
					extraFish2.components.weighable:SetPlayerAsOwner(self.fisherman)
				end
					
				local spawnPos = self.fisherman:GetPosition()
				local offset = spawnPos - self.target:GetPosition()
				spawnPos = spawnPos + offset:GetNormalized()
				
				self.inst:DoTaskInTime(.8, function()
					if extraFish2.Physics ~= nil then
						extraFish2.Physics:Teleport(spawnPos:Get())
					else
						extraFish2.Transform:SetPosition(spawnPos:Get())
					end
				end)
			end
		end

        return unpack(ret)
    end
end)

-- Antchovy special case that don't let them sink right after catching it.
AddComponentPostInit("fishingrod", function(self)
	local oldReel = self.Reel

	function self:Reel(...)
		local ret = {oldReel(self, ...)}
		
		if self.caughtfish ~= nil and self.fisherman ~= nil and self.fisherman.components.inventory ~= nil then
			local fish = self.caughtfish

			if fish:HasTag("antchovy") and fish.components.inventoryitem ~= nil then
				fish.components.inventoryitem:SetSinks(false)

				if self.fisherman.components.inventory:GiveItem(fish, nil, self.fisherman:GetPosition()) then
					fish:DoTaskInTime(3, function(f)
						if f:IsValid() and f.components.inventoryitem ~= nil then
							f.components.inventoryitem:SetSinks(true)
							f:AddTag("antchovy_sinkable")
						end
					end)
				else
					fish.Transform:SetPosition(self.fisherman.Transform:GetWorldPosition())
					fish.components.inventoryitem:SetSinks(true)
					fish:AddTag("antchovy_sinkable")
				end
			end
		end

		return unpack(ret)
	end
end)

-- For trading and learning Recipe Cards.
local function CookingRecipeCardPostInit(inst)
	inst:AddTag("learnablerecipecard")
	
	if not _G.TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
	inst:AddComponent("learnablerecipecard")
end

AddPrefabPostInit("cookingrecipecard", CookingRecipeCardPostInit)

-- Sound listeners for clients.
local function PlayerClassifiedPostInit(inst)
	local function OnLearnRecipeCardEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		end
	end
	
	local function OnSaltFoodEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/salt_shake")
		end
	end
	
	local function OnPlayNukashineEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:KillSound("open_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("drink_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("nukashine_jukebox")
		
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open", "open_nukashine")
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink", "drink_nukashine")
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/music/jukebox", "nukashine_jukebox")
		end
	end
	
	local function OnStopNukashineEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:KillSound("open_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("drink_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("nukashine_jukebox")
		end
	end
	
	local function OnPirateRumEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh", "piraterum", 0.5)
		end
	end
	
	local function OnBottleCapEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
		end
	end
	
	local function OnPlayGoldenAppleEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/music/gorge_win", "goldenapple", 0.5)
		end
	end
	
	local function OnStopGoldenAppleEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/transform/music/2")
		end
	end

	local function OnLearnRecipeCard(parent)
		parent.player_classified.learnrecipecardevent:push()
	end
	
	local function OnSaltFood(parent)
		parent.player_classified.saltfoodevent:push()
	end
	
	local function OnPlayNukashine(parent)
		parent.player_classified.playnukashineevent:push()
	end
	
	local function OnStopNukashine(parent)
		parent.player_classified.stopnukashineevent:push()
	end
	
	local function OnPirateRum(parent)
		parent.player_classified.piraterumevent:push()
	end
	
	local function OnBottleCap(parent)
		parent.player_classified.bottlecapevent:push()
	end
	
	local function OnPlayGoldenApple(parent)
		parent.player_classified.playgoldenappleevent:push()
	end
	
	local function OnStopGoldenApple(parent)
		parent.player_classified.stopgoldenappleevent:push()
	end

	local function RegisterNetListeners(inst)
		if _G.TheWorld.ismastersim then
			inst:ListenForEvent("learnrecipecard", OnLearnRecipeCard, inst.entity:GetParent())
			inst:ListenForEvent("saltfood", OnSaltFood,               inst.entity:GetParent())
			inst:ListenForEvent("playnukashine", OnPlayNukashine,     inst.entity:GetParent())
			inst:ListenForEvent("stopnukashine", OnStopNukashine,     inst.entity:GetParent())
			inst:ListenForEvent("piraterum", OnPirateRum,             inst.entity:GetParent())
			inst:ListenForEvent("bottlecap", OnBottleCap,             inst.entity:GetParent())
			inst:ListenForEvent("playgoldenapple", OnPlayGoldenApple, inst.entity:GetParent())
			inst:ListenForEvent("stopgoldenapple", OnStopGoldenApple, inst.entity:GetParent())
		end

		inst:ListenForEvent("action.learnrecipecard", OnLearnRecipeCardEvent)
		inst:ListenForEvent("action.salt",            OnSaltFoodEvent)
		inst:ListenForEvent("buff.playnukashine",     OnPlayNukashineEvent)
		inst:ListenForEvent("buff.stopnukashine",     OnStopNukashineEvent)
		inst:ListenForEvent("buff.piraterum",         OnPirateRumEvent)
		inst:ListenForEvent("buff.bottlecap",         OnBottleCapEvent)
		inst:ListenForEvent("buff.playgoldenapple",   OnPlayGoldenAppleEvent)
		inst:ListenForEvent("buff.stopgoldenapple",   OnStopGoldenAppleEvent)
	end
	
	inst.learnrecipecardevent = net_event(inst.GUID, "action.learnrecipecard")
	inst.saltfoodevent        = net_event(inst.GUID, "action.salt")
	inst.playnukashineevent   = net_event(inst.GUID, "buff.playnukashine")
	inst.stopnukashineevent   = net_event(inst.GUID, "buff.stopnukashine")
	inst.piraterumevent       = net_event(inst.GUID, "buff.piraterum")
	inst.bottlecapevent       = net_event(inst.GUID, "buff.bottlecap")
	inst.playgoldenappleevent = net_event(inst.GUID, "buff.playgoldenapple")
	inst.stopgoldenappleevent = net_event(inst.GUID, "buff.stopgoldenapple")

	inst:DoStaticTaskInTime(0, RegisterNetListeners)
end

AddPrefabPostInit("player_classified", PlayerClassifiedPostInit)

-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
-- Hope they don't smack and bonk my head...
local FishingRod = require("components/fishingrod")
function FishingRod:OnUpdate()
	if self:IsFishing() then
		if not self.fisherman:IsValid()
		or (not self.fisherman.sg:HasStateTag("fishing") and not self.fisherman.sg:HasStateTag("catchfish"))
		or (self.inst.components.equippable and not self.inst.components.equippable.isequipped) then
            self:StopFishing()
		end
	end
end

-- Allows us to edit some stuff for waxed plants.
local WAXED_PLANTS = require("prefabs/waxed_plant_common")
local function Common_CreateWaxedPlant(inst, data)
	if data.minimapicon2 ~= nil then -- For using .tex instead.
		inst.MiniMapEntity:SetIcon(data.minimapicon2..".tex")
	end
end

local _CreateWaxedPlant = WAXED_PLANTS.CreateWaxedPlant
function WAXED_PLANTS.CreateWaxedPlant(data, ...)

	local _common_postinit = data.common_postinit
	
	data.common_postinit = function(inst, ...)
		Common_CreateWaxedPlant(inst, data)
		return _common_postinit ~= nil and _common_postinit(inst, ...) or nil
	end

	return _CreateWaxedPlant(data, ...)
end

if HOF_ICEBOXSTACKSIZE then
	local function ElastispacerPostInit(inst)
		local function OnUpgrade(inst, performer, upgraded_from_item)
			local numupgrades = inst.components.upgradeable.numupgrades
	
			if numupgrades == 1 then
				inst._chestupgrade_stacksize = true
		
				if inst.components.container ~= nil then
					inst.components.container:Close()
					inst.components.container:EnableInfiniteStackSize(true)
				end
		
				if upgraded_from_item then
					local x, y, z = inst.Transform:GetWorldPosition()
					local fx = SpawnPrefab("chestupgrade_stacksize_fx")
					fx.Transform:SetPosition(x, y, z)
				end
			end
	
			inst.components.upgradeable.upgradetype = nil

			if inst.components.lootdropper ~= nil then
				inst.components.lootdropper:SetLoot({"alterguardianhatshard"})
			end
		end
	
		local function OnLoadPostPass(inst, newents, data)
			if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
				OnUpgrade(inst)
			end
		end

		local function OnDecontructStructure(inst, caster)
			if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
				if inst.components.lootdropper ~= nil then
					inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
				end
			end
		end
	
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("upgradeable")
		inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
		inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
	
		inst.OnLoadPostPass = OnLoadPostPass
	end

	AddPrefabPostInit("icebox", ElastispacerPostInit)
	AddPrefabPostInit("saltbox", ElastispacerPostInit)
end

local function WobyRackPostInit(inst)
	local CS = 
	{
		r = 0.4, 
		g = 0.4, 
		b = 0.6, 
		a = 0.5,
	}
	
	local function ApplyColourToSlot(slotfx, r, g, b, a)
		if slotfx and slotfx.AnimState then
			slotfx.AnimState:SetMultColour(r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("rope", r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("rope_empty", r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("swap_dried", r, g, b, a)
		end
	end
	
	local function StealthMultColour(inst)
		inst.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
		inst.AnimState:SetSymbolMultColour("rack", CS.r, CS.g, CS.b, CS.a)
		
		if inst.slots ~= nil then
			for _, v in ipairs(inst.slots) do
				if v.fx ~= nil then
					ApplyColourToSlot(v.fx, CS.r, CS.g, CS.b, CS.a)
				end
			end
		end
	end
	
	local function DefaultMultColour(inst)
		inst.AnimState:SetMultColour(1, 1, 1, 1)
		inst.AnimState:SetSymbolMultColour("rack", 1, 1, 1, 1)
		
		if inst.slots ~= nil then
			for _, v in ipairs(inst.slots) do
				if v.fx ~= nil then
					ApplyColourToSlot(v.fx, 1, 1, 1, 1)
				end
			end
		end
	end

	local function RackStealth(inst)
		local parent = inst.entity:GetParent()
		
		if parent and parent:HasTag("mimicmosa_stealthed") then
			StealthMultColour(inst)
		else
			DefaultMultColour(inst)
		end
	end
	
	inst:DoPeriodicTask(0, RackStealth)
end

AddPrefabPostInit("woby_rack_swap_fx", WobyRackPostInit)

local function SaddleShadowPostInit(inst)
	local CS = 
	{
		r = 0.4, 
		g = 0.4, 
		b = 0.6, 
		a = 0.5,
	}
	
	local function StealthMultColour(inst)
		if inst.fx then
			for i, fx in ipairs(inst.fx) do
				if fx.AnimState then
					fx.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
				end
			end
		end
	end
	
	local function DefaultMultColour(inst)
		if inst.fx then
			for i, fx in ipairs(inst.fx) do
				if fx.AnimState then
					fx.AnimState:SetMultColour(1, 1, 1, 1)
				end
			end
		end
	end
	
	local function SaddleStealth(inst)
		local parent = inst.entity:GetParent()
		
		if parent:HasTag("mimicmosa_stealthed") then
			StealthMultColour(inst)
		else
			DefaultMultColour(inst)
		end
	end

	inst:DoPeriodicTask(0, SaddleStealth)
end

AddPrefabPostInit("saddle_shadow_fx", SaddleShadowPostInit)

-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
-- Correct animations for new ocean creatures inside Scale-o-Matic.
local function TrophyScaleFishPostInit(inst)	
	local function SetFish(inst, item_data)
		if item_data then
			if item_data.prefab == "kyno_jellyfish" then
				inst.AnimState:SetBank("trophyscale_fish_kyno_jellyfish")
				inst.AnimState:HideSymbol("eel_head")
			elseif item_data.prefab == "kyno_jellyfish_rainbow" then
				inst.AnimState:SetBank("trophyscale_fish_kyno_jellyfish_rainbow")
				inst.AnimState:HideSymbol("eel_head")
			elseif item_data.prefab == "wobster_monkeyisland_land" then
				inst.AnimState:SetBank("trophyscale_fish_wobster_monkeyisland")
				-- inst.AnimState:ClearOverrideBuild("lobster_build")
				inst.AnimState:AddOverrideBuild("kyno_lobster_monkeyisland")
				inst.AnimState:OverrideSymbol("claw_type1a", "kyno_lobster_monkeyisland", "claw_type3a")
				inst.AnimState:OverrideSymbol("claw_type2b", "kyno_lobster_monkeyisland", "claw_type3b")
				inst.AnimState:HideSymbol("claw_type2a")
				
				inst:DoTaskInTime(1, function(inst)
					inst.AnimState:OverrideSymbol("claw_type2b", "kyno_lobster_monkeyisland", "claw_type3b")
				end)
			else
				inst.AnimState:SetBank("scale_o_matic")
			end

			if item_data.prefab == "kyno_jellyfish_rainbow" then
				local light = SpawnPrefab("kyno_jellyfish_rainbow_light")
				light.components.spell:SetTarget(inst)
				
				if light:IsValid() then
					if not light.components.spell.target then
						light:Remove()
					else
						light.components.spell:StartSpell()
						light:StopUpdatingComponent(light.components.spell)
					end
				end
			else
				if inst.wormlight then
					inst.wormlight.components.spell:OnFinish()
				end
			end
		end
	end

	local function OnNewTrophy(inst, data_old_and_new)
		local data_new = data_old_and_new.new
		SetFish(inst, data_new)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	local _OnLoad = inst.OnLoad
	
	inst.OnLoad = function(inst, ...)
		if inst.components.trophyscale ~= nil then
			local item_data = inst.components.trophyscale:GetItemData()
			SetFish(inst, item_data)
		end

		if _OnLoad ~= nil then
			_OnLoad(inst, ...)
		end
	end
	
	inst:ListenForEvent("onnewtrophy", OnNewTrophy)
end

AddPrefabPostInit("trophyscale_fish", TrophyScaleFishPostInit)

AddComponentPostInit("spell", function(self)
	local _OnSave = self.OnSave

	function self:OnSave(...)
		local ret = {_OnSave(self, ...)}

		if self.target ~= nil and self.target.components.trophyscale then
			return ret[1], { self.target.GUID }
		end

		return unpack(ret)
	end
end)

-- Some hacks for trap component since it does not support water creatures.
-- We basically remove the fish from scene and spawn its inventory prefab.
AddComponentPostInit("trap", function(self)
	local _DoTriggerOn = self.DoTriggerOn
	local _Harvest = self.Harvest
	local _OnSave = self.OnSave
	local _OnLoad = self.OnLoad

	function self:DoTriggerOn(target)
		if self.inst:HasTag("smalloceanfish_trap") and target ~= nil and target:HasTag("smalloceanfish") and not target:HasTag("partiallyhooked") then
			self.target = target
			self.captured_fish = target
			
			self.issprung = true

			local loot_prefab = TUNING.HOF_OCEANTRAP_PREFAB_INDEX[target.prefab] or (target.prefab .. "_inv")
			self.lootprefabs = { loot_prefab }
			
			if self.bait ~= nil then
				if self.bait:IsValid() then
					self.bait:Remove()
				end
				
				if self.RemoveBait ~= nil then
					self:RemoveBait()
				end
				
				self.bait = nil
			end

			if self.captured_fish ~= nil and self.captured_fish:IsValid() then
				self.captured_fish:RemoveFromScene()
			end
			
			self:StopUpdating()
			self.inst:PushEvent("springtrap")

			return
		end

		_DoTriggerOn(self, target)
	end

	function self:Harvest(doer)
		if self.inst:HasTag("smalloceanfish_trap") and self.captured_fish ~= nil then
			local fish = self.captured_fish
			local pos = self.inst:GetPosition()
		
			local loot_prefab = TUNING.HOF_OCEANTRAP_PREFAB_INDEX[fish.prefab] or (fish.prefab .. "_inv")
			local loot = SpawnPrefab(loot_prefab)

			if loot ~= nil then
				loot.Transform:SetPosition(pos:Get())
				
				if doer ~= nil and doer.components.inventory ~= nil then
					doer.components.inventory:GiveItem(loot)
				end
			end

			if fish:IsValid() then
				fish:Remove()
			end

			self.captured_fish = nil
			self.target = nil
			self.lootprefabs = nil
		end

		_Harvest(self, doer)
    end

	function self:OnSave()
		local data, refs = _OnSave ~= nil and _OnSave(self) or {}, {}

		if self.inst:HasTag("smalloceanfish_trap") then
			if self.captured_fish ~= nil and self.captured_fish:IsValid() then
				data.captured_fish_prefab = self.captured_fish.prefab
			end

			if self.lootprefabs ~= nil and next(self.lootprefabs) ~= nil then
				data.loot = self.lootprefabs
			end

			if self.issprung then
				data.issprung = true
			end
		end

		return data, refs
	end

	function self:OnLoad(data)
		if _OnLoad ~= nil then
			_OnLoad(self, data)
		end
		
		if self.inst:HasTag("smalloceanfish_trap") and data ~= nil then
			if data.loot ~= nil then
				self.lootprefabs = type(data.loot) == "table" and data.loot or { data.loot }
			end

			if data.captured_fish_prefab ~= nil then
				local fish = SpawnPrefab(data.captured_fish_prefab)
				
				if fish ~= nil then
					fish:RemoveFromScene()
					self.captured_fish = fish
				end
			end

			if data.issprung then
				self.issprung = true
				self.inst:PushEvent("springtrap")
			end
		end
	end
end)

-- Extra distance for Fish Hatchery.
-- Why these morons at klei didn't add a self.containerdistance?
AddComponentPostInit("container", function(self)
	local _OnUpdate = self.OnUpdate

	function self:OnUpdate(dt)
		if self.opencount == 0 then
			self.inst:StopUpdatingComponent(self)
			return
		end

		for opener, _ in pairs(self.openlist) do
			if self.inst ~= nil and self.inst:HasTag("fishhatchery") then
				local old_distance = _G.CONTAINER_AUTOCLOSE_DISTANCE
				_G.CONTAINER_AUTOCLOSE_DISTANCE = 6

				_OnUpdate(self, dt)
				_G.CONTAINER_AUTOCLOSE_DISTANCE = old_distance
				
				return
			end
		end

		return _OnUpdate(self, dt)
	end
end)

-- Get Anniversary Cheer when cooking.
local function GetBaseFoodPrefab(prefab)
	local spice_pos = prefab:find("_spice_")
	
	if spice_pos then
		return prefab:sub(1, spice_pos - 1)
	end
	
	return prefab
end

AddComponentPostInit("stewer", function(self)
	local _Harvest = self.Harvest

	self.Harvest = function(self, harvester, ...)
		if not self.done then
			return _Harvest(self, harvester, ...)
		end

		local product_prefab = self.product
		local loot_captured = nil
		
		if harvester and harvester.components.inventory then
			local _GiveItem = harvester.components.inventory.GiveItem
			
			harvester.components.inventory.GiveItem = function(inv, item, ...)
				loot_captured = item
				return _GiveItem(inv, item, ...)
			end

			local result = _Harvest(self, harvester, ...)
			
            harvester.components.inventory.GiveItem = _GiveItem

			if result and loot_captured then
				local base_loot = GetBaseFoodPrefab(loot_captured.prefab) -- Blocks spiced foods.
				
				if not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[base_loot] and _G.IsSpecialEventActive(_G.SPECIAL_EVENTS.HOFBIRTHDAY)
				and harvester:HasTag("cheer_rewardable") --[[math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE]] then
					inv = harvester.components.inventory
					local cheer = SpawnPrefab("kyno_hofbirthday_cheer")
					
					if inv then
						inv:GiveItem(cheer, nil, self.inst:GetPosition())
					else
						_G.LaunchAt(cheer, self.inst, nil, 1, 1)
					end
				end
			end

			return result
		end

		local result = _Harvest(self, harvester, ...)
		
		if result and product_prefab then
			local loot = SpawnPrefab(product_prefab)

			if loot and not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[loot.prefab] and 
			_G.IsSpecialEventActive(_G.SPECIAL_EVENTS.HOFBIRTHDAY) and math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE then
				local cheer = SpawnPrefab("kyno_hofbirthday_cheer")
				_G.LaunchAt(cheer, self.inst, nil, 1, 1)
			end
		end

		return result
	end
end)

-- Makes icons appear for containers that are integrated to player's inventory.
AddClassPostConstruct("widgets/invslot", function(self)
	if self.owner == _G.ThePlayer and self.container ~= nil and self.container.GetWidget ~= nil then
		local widget = self.container:GetWidget()
		local bgoverride = widget.slotbg ~= nil and widget.slotbg[self.num] or nil

		if bgoverride ~= nil then
			self.bgimage:SetTexture(bgoverride.atlas or "images/hud.xml", bgoverride.image or "inv_slot.tex")
		end
	end
end)

-- Cool effect for enchanted items.
AddClassPostConstruct("widgets/itemtile", function(self)
	local UIAnim = require("widgets/uianim")
	
	local function _StartUpdating(self, flag)
		if next(self.updatingflags) == nil then
			self:StartUpdating()
		end
		
		self.updatingflags[flag] = true
	end

	local function _StopUpdating(self, flag)
		self.updatingflags[flag] = nil
        
		if next(self.updatingflags) == nil then
			self:StopUpdating()
		end
	end
	
	function self:StartUpdatingEnchanted()
		self.updateenchanteddelay = 0
		_StartUpdating(self, "enchanted")
	end
	
	function self:StopUpdatingEnchanted()
		_StopUpdating(self, "enchanted")
		self.updateenchanteddelay = nil
	end
	
	function self:StartUpdatingShadow2()
		self.updateshadow2delay = 0
		_StartUpdating(self, "shadow2")
	end
	
	function self:StopUpdatingShadow2()
		_StopUpdating(self, "shadow2")
		self.updateshadow2delay = nil
	end
	
	local _OnUpdate = self.OnUpdate
	
	function self:OnUpdate(dt)
		if _OnUpdate then
			_OnUpdate(self, dt)
		end

		if self.updatingflags and self.updatingflags.enchanted then
			self.updateenchanteddelay = (self.updateenchanteddelay or 0) + dt
			
			if self.updateenchanteddelay > 0.2 then
				self.updateenchanteddelay = 0

				self:CheckEnchantedFX()
			end
		end
		
		if self.updatingflags and self.updatingflags.shadow2 then
			self.updateshadow2delay = (self.updateshadow2delay or 0) + dt
			
			if self.updateshadow2delay > 0.2 then
				self.updateshadow2delay = 0

				self:CheckShadow2FX()
			end
		end
	end
	
	function self:CheckEnchantedFX()
		if self.item:HasTag("goldenapple") then
			self.enchantedfx:Show()
		else
			self.enchantedfx:Hide()
		end
	end
	
	function self:CheckShadow2FX()
		if self.item:HasTag("shadow_fooditem") then
			self.shadow2fx:Show()
		else
			self.shadow2fx:Hide()
		end
	end

	function self:ToggleEnchantedFX()
		if self.showequipenchantedfx or (self.item and self.item:HasTag("goldenapple")) then
			if self.enchantedfx == nil then
				self.enchantedfx = self.image:AddChild(UIAnim())
				self.enchantedfx:GetAnimState():SetBank("inventory_fx_enchanted")
				self.enchantedfx:GetAnimState():SetBuild("inventory_fx_enchanted")
				self.enchantedfx:GetAnimState():PlayAnimation("idle", true)
				self.enchantedfx:GetAnimState():SetTime(math.random() * self.enchantedfx:GetAnimState():GetCurrentAnimationTime())
				self.enchantedfx:SetScale(.25)
				self.enchantedfx:GetAnimState():AnimateWhilePaused(false)
				self.enchantedfx:SetClickable(false)
			end
			
			if self.item:HasTag("goldenapple") then
				self:CheckEnchantedFX()
				self:StartUpdatingEnchanted()
			else
				self:StopUpdatingEnchanted()
			end
		elseif self.enchantedfx ~= nil then
			self.enchantedfx:Kill()
			self.enchantedfx = nil
		end
	end
	
	function self:ToggleShadow2FX()
		if self.showequipshadow2fx or (self.item and self.item:HasTag("shadow_fooditem")) then
			if self.shadow2fx == nil then
				self.shadow2fx = self.image:AddChild(UIAnim())
				self.shadow2fx:GetAnimState():SetBank("inventory_fx_shadow")
				self.shadow2fx:GetAnimState():SetBuild("inventory_fx_shadow")
				self.shadow2fx:GetAnimState():PlayAnimation("idle", true)
				self.shadow2fx:GetAnimState():SetTime(math.random() * self.shadow2fx:GetAnimState():GetCurrentAnimationTime())
				self.shadow2fx:SetScale(.25)
				self.shadow2fx:GetAnimState():AnimateWhilePaused(false)
				self.shadow2fx:SetClickable(false)
			end
			
			if self.item:HasTag("shadow_fooditem") then
				self:CheckShadow2FX()
				self:StartUpdatingShadow2()
			else
				self:StopUpdatingShadow2()
			end
		elseif self.shadow2fx ~= nil then
			self.shadow2fx:Kill()
			self.shadow2fx = nil
		end
	end

	local _SetIsEquip = self.SetIsEquip
	
	function self:SetIsEquip(isequip)
		local enchantedfx = isequip and self.item:HasTag("goldenapple")
		local shadow2fx = isequip and self.item:HasTag("shadow_fooditem")

		if not self.showequipenchantedfx == enchantedfx then
			self.showequipenchantedfx = enchantedfx or nil
			self:ToggleEnchantedFX()
		end
		
		if not self.showequipshadow2fx == shadow2fx then
			self.showequipshadow2fx = shadow2fx or nil
			self:ToggleShadow2FX()
		end
		
		return _SetIsEquip(self, isequip)
	end
	
	self:ToggleEnchantedFX()
	self:ToggleShadow2FX()
end)

-- Fish Registry player extension.
local function OnLearnFish(inst, data)
	local fishregistryupdater = inst.components.fishregistryupdater
    
	if fishregistryupdater and data ~= nil and data.fish ~= nil then
		fishregistryupdater:LearnFish(data.fish)
	end
end

local function OnLearnRoe(inst, data)
	local fishregistryupdater = inst.components.fishregistryupdater
    
	if fishregistryupdater and data ~= nil and data.roe ~= nil then
		fishregistryupdater:LearnRoe(data.roe)
	end
end

AddPlayerPostInit(function(inst)
	inst:AddComponent("fishregistryupdater")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.OnLearnFish = OnLearnFish
	inst.OnLearnRoe = OnLearnRoe
	
	inst:ListenForEvent("learnfish", inst.OnLearnFish)
	inst:ListenForEvent("learnroe", inst.OnLearnRoe)
end)

-- HAHAHAHA YOU CAN'T EDIT SKILLTREE STRINGS WITH REGULAR METHODS 💀💀
AddSimPostInit(function()
	local defs = require("prefabs/skilltree_defs")
	local wormwood_defs = defs.SKILLTREE_DEFS and defs.SKILLTREE_DEFS["wormwood"]

	if wormwood_defs and wormwood_defs["wormwood_mushroomplanter_ratebonus2"] then
		wormwood_defs["wormwood_mushroomplanter_ratebonus2"].desc = STRINGS.SKILLTREE_WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2_DESC
		or "ERROR: MISSING SKILL DESCRIPTION FOR WORMWOOD_MUSHROOMPLANTER_RATEBONUS2"
	else
		print("Heap of Foods Mod - Wormwood's Skill 'wormwood_mushroomplanter_ratebonus2' not found.")
	end
end)