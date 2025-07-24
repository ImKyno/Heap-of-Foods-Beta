-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab
local cooking         = require("cooking")
local UpvalueHacker   = require("hof_upvaluehacker")

require("hof_debugcommands")

local HOF_HUMANMEAT = GetModConfigData("HUMANMEAT")
local HOF_KEEPFOOD  = GetModConfigData("KEEPFOOD")

-- Favorite Mod Foods.
AddPrefabPostInit("wilson", function(inst)
    inst:AddTag("wislanhealer")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("caviar", TUNING.AFFINITY_15_CALORIES_HUGE)
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
	
    inst.GetFertilizerKey = GetFertilizerKey

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("coffeefertilizer2")

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

-- Prevent Food From Spoiling In Stations.
if HOF_KEEPFOOD then
    local cooking_stations = {
        "cookpot",
        "portablecookpot",
        "archive_cookpot",
        "kyno_cookware_syrup",
        "kyno_cookware_small",
        "kyno_cookware_big",
        "kyno_cookware_elder",
        "kyno_cookware_small_grill",
        "kyno_cookware_grill",
        "kyno_cookware_oven_small_casserole",
        "kyno_cookware_oven_casserole",
    }

    for k,v in pairs(cooking_stations) do
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
			if math.random() < .33 then
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

	local function RegisterNetListeners(inst)
		if _G.TheWorld.ismastersim then
			inst:ListenForEvent("learnrecipecard", OnLearnRecipeCard, inst.entity:GetParent())
			inst:ListenForEvent("saltfood", OnSaltFood, inst.entity:GetParent())
			inst:ListenForEvent("playnukashine", OnPlayNukashine, inst.entity:GetParent())
			inst:ListenForEvent("stopnukashine", OnStopNukashine, inst.entity:GetParent())
			inst:ListenForEvent("piraterum", OnPirateRum, inst.entity:GetParent())
			inst:ListenForEvent("bottlecap", OnBottleCap, inst.entity:GetParent())
		end

		inst:ListenForEvent("action.learnrecipecard", OnLearnRecipeCardEvent)
		inst:ListenForEvent("action.salt", OnSaltFoodEvent)
		inst:ListenForEvent("buff.playnukashine", OnPlayNukashineEvent)
		inst:ListenForEvent("buff.stopnukashine", OnStopNukashineEvent)
		inst:ListenForEvent("buff.piraterum", OnPirateRumEvent)
		inst:ListenForEvent("buff.bottlecap", OnBottleCapEvent)
	end
	
	inst.learnrecipecardevent = net_event(inst.GUID, "action.learnrecipecard")
	inst.saltfoodevent = net_event(inst.GUID, "action.salt")
	inst.playnukashineevent = net_event(inst.GUID, "buff.playnukashine")
	inst.stopnukashineevent = net_event(inst.GUID, "buff.stopnukashine")
	inst.piraterumevent = net_event(inst.GUID, "buff.piraterum")
	inst.bottlecapevent = net_event(inst.GUID, "buff.bottlecap")

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