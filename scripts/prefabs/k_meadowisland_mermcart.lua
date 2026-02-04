local assets =
{	
	Asset("ANIM", "anim/kyno_meadowisland_mermcart.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"small_puff",
}

local EMPTY_PREFAB = "EMPTY"
local SWEETPOTATO_OVERSIZED = "kyno_sweetpotato_oversized" -- Too large!
local RUMMAGE_SOUND_NAME = "rummage"

local function SquidTest()
	if TUNING.SQUID_TEST_RADIUS > 0 then
		return true
	end
end

local function PenguinTest()
	if TUNING.PENGUINS_MAX_COLONIES > 0 then
		return true
	end
end

local SQUID_ENABLED = SquidTest() or nil
local PENGUIN_ENABLED = PenguinTest() or nil

-- OMG SLURPERS DON'T HAVE A PROPER WORLDSETTINGS TUNING AAAAAHHHH 💀💀
local LOOT =
{
	CRITTERS =
	{
		{ weight = 4, prefab = "penguin",          targetplayer = true,  state = "attack",    tuning = PENGUIN_ENABLED,            season = "winter" }, -- 57.14%
		{ weight = 4, prefab = "frog",             targetplayer = true,  state = "attack",    tuning = "FROG_POND_ENABLED",        season = "spring" }, -- 57.14%
		{ weight = 4, prefab = "slurper",          targetplayer = true,  state = "headslurp", tuning = nil,                        season = "summer" }, -- 57.14%
		{ weight = 4, prefab = "kyno_piko",        targetplayer = false, state = "look",      tuning = "KYNO_PIKO_ENABLED",        season = nil      }, -- 57.14%
		{ weight = 2, prefab = "mole",             targetplayer = false, state = "peek",      tuning = "MOLE_ENABLED",             season = nil      }, -- 28.57%
		{ weight = 2, prefab = "squid",            targetplayer = true,  state = "attack",    tuning = SQUID_ENABLED,              season = nil      }, -- 28.57%
		{ weight = 2, prefab = "kyno_chicken2",    targetplayer = false, state = "honk",      tuning = "KYNO_CHICKEN_ENABLED",     season = nil      }, -- 28.57%
		{ weight = 1, prefab = "kyno_piko_orange", targetplayer = false, state = "look",      tuning = "KYNO_PIKO_ORANGE_ENABLED", season = nil      }, -- 14.29%
	},
	
	ITEMS =
	{
		-- AUTUMN
		{ weight = 8, prefab = "corn_seeds",             amount = {3, 9},     season = "autumn" }, -- 25%
		{ weight = 8, prefab = "eggplant_seeds",         amount = {3, 9},     season = "autumn" },
		{ weight = 8, prefab = "potato_seeds",           amount = {3, 9},     season = "autumn" },
		{ weight = 8, prefab = "kyno_turnip_seeds",      amount = {3, 9},     season = "autumn" },
		{ weight = 8, prefab = "kyno_parznip_seeds",     amount = {3, 9},     season = "autumn" },
		{ weight = 4, prefab = "manrabbit_tail",         amount = {1, 3},     season = "autumn" }, -- 12.5%
		{ weight = 4, prefab = "pigskin",                amount = {1, 3},     season = "autumn" },
		{ weight = 4, prefab = "beefalowool",            amount = {1, 5},     season = "autumn" },
		{ weight = 2, prefab = "steelwool",              amount = {1, 3},     season = "autumn" }, -- 6.25%
		{ weight = 2, prefab = "tentaclespots",          amount = {1, 3},     season = "autumn" },
		{ weight = 2, prefab = "gears",                  amount = {1, 3},     season = "autumn" },
		{ weight = 1, prefab = "furtuft",                amount = {1, 15},    season = "autumn" }, -- 3.125%
		{ weight = 1, prefab = "potato_oversized",       amount = 1,          season = "autumn" },         
		{ weight = 1, prefab = "corn_oversized",         amount = 1,          season = "autumn" },
		
		-- WINTER
		{ weight = 8, prefab = "garlic_seeds",           amount = {3, 9},     season = "winter" },
		{ weight = 8, prefab = "pumpkin_seeds",          amount = {3, 9},     season = "winter" },
		{ weight = 8, prefab = "asparagus_seeds",        amount = {3, 9},     season = "winter" },
		{ weight = 8, prefab = "kyno_radish_seeds",      amount = {3, 9},     season = "winter" },
		{ weight = 8, prefab = "kyno_fennel_seeds",      amount = {3, 9},     season = "winter" },
		{ weight = 4, prefab = "trunkvest_summer",                            season = "winter" },
		{ weight = 4, prefab = "catcoonhat",                                  season = "winter" },
		{ weight = 2, prefab = "winterhat",                                   season = "winter" },
		{ weight = 1, prefab = "walrus_tusk",                                 season = "winter" },
		{ weight = 1, prefab = "garlic_oversized",       amount = 1,          season = "winter" },         
		{ weight = 1, prefab = "pumpkin_oversized",      amount = 1,          season = "winter" },
		
		-- SPRING
		{ weight = 8, prefab = "durian_seeds",           amount = {3, 9},     season = "spring" },
		{ weight = 8, prefab = "watermelon_seeds",       amount = {3, 9},     season = "spring" },
		{ weight = 8, prefab = "pomegranate_seeds",      amount = {3, 9},     season = "spring" },
		{ weight = 8, prefab = "kyno_aloe_seeds",        amount = {3, 9},     season = "spring" },
		{ weight = 8, prefab = "kyno_cucumber_seeds",    amount = {3, 9},     season = "spring" },
		{ weight = 4, prefab = "umbrella",                                    season = "spring" },
		{ weight = 2, prefab = "rainhat",                                     season = "spring" },
		{ weight = 1, prefab = "kyno_parznip_oversized", amount = 1,          season = "spring" },         
		{ weight = 1, prefab = "kyno_radish_oversized",  amount = 1,          season = "spring" },
		
		-- SUMMER
		{ weight = 8, prefab = "dragonfruit_seeds",      amount = {3, 9},     season = "summer" },
		{ weight = 8, prefab = "pepper_seeds",           amount = {3, 9},     season = "summer" },
		{ weight = 8, prefab = "onion_seeds",            amount = {3, 9},     season = "summer" },
		{ weight = 8, prefab = "kyno_rice_seeds",        amount = {3, 9},     season = "summer" },
		{ weight = 8, prefab = "kyno_sweetpotato_seeds", amount = {3, 9},     season = "summer" },
		{ weight = 4, prefab = "minifan",                                     season = "summer" },
		{ weight = 2, prefab = "reflectivevest",                              season = "summer" },
		{ weight = 2, prefab = "icehat",                                      season = "summer" },
		{ weight = 2, prefab = "watermelonhat",                               season = "summer" },
		{ weight = 1, prefab = "hawaiianshirt",                               season = "summer" },
		{ weight = 8, prefab = SWEETPOTATO_OVERSIZED,    amount = 1,          season = "summer" },         
		{ weight = 1, prefab = "kyno_turnip_oversized",  amount = 1,          season = "summer" },
		
		-- ALL TIMES
		{ weight = 8, prefab = "kyno_wheat",             amount = {3, 10},    season = nil },
		{ weight = 8, prefab = "kyno_flour",             amount = {3, 10},    season = nil },
		{ weight = 8, prefab = "foliage",                amount = {4, 8},     season = nil },
		{ weight = 8, prefab = "lightbulb",              amount = {4, 8},     season = nil },
		{ weight = 8, prefab = "succulent_picked",       amount = {4, 8},     season = nil },
		{ weight = 4, prefab = "marblebean",             amount = {3, 10},    season = nil },
		{ weight = 4, prefab = "slurtle_shellpieces",    amount = {3, 10},    season = nil },
		{ weight = 4, prefab = "livinglog",              amount = {3, 5},     season = nil },
		{ weight = 4, prefab = "bedroll_straw",                               season = nil },
		{ weight = 2, prefab = EMPTY_PREFAB,                                  season = nil }, -- Get nothing :steammocking:
		{ weight = 2, prefab = "bedroll_furry",                               season = nil },
		{ weight = 2, prefab = "rabbithat",                                   season = nil },
		{ weight = 2, prefab = "dug_berrybush_juicy",    amount = {2, 4},     season = nil },
		{ weight = 2, prefab = "dug_berrybush",          amount = {2, 4},     season = nil },
		{ weight = 2, prefab = "dug_berrybush2",         amount = {2, 4},     season = nil },
		{ weight = 2, prefab = "kyno_sammyhat",                               season = nil },
		{ weight = 2, prefab = "trinket_4",              amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_5",              amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_10",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_11",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_13",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_18",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_22",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_24",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_25",             amount = {1, 2},     season = nil },
		{ weight = 2, prefab = "trinket_26",             amount = {1, 2},     season = nil },
		{ weight = 1, prefab = "wormlight_lesser",       amount = {3, 5},     season = nil },
		{ weight = 1, prefab = "deer_antler1",                                season = nil },
		{ weight = 1, prefab = "deer_antler2",                                season = nil },
		{ weight = 1, prefab = "deer_antler3",                                season = nil },
		{ weight = 1, prefab = "honeycomb",              amount = {2, 4},     season = nil },
		{ weight = 1, prefab = "blueprint",                                   season = nil },
		{ weight = 1, prefab = "dug_trap_starfish",      amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "batnose",                amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "saddle_race",                                 season = nil },
		{ weight = 1, prefab = "sewing_kit",                                  season = nil },
		{ weight = 1, prefab = "wormlight",              amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "pondeel",                amount = {1, 2},     season = nil },
		
		-- COOKPOT FOODS
		{ weight = 2, prefab = "jawsbreaker",            amount = {3, 5},     season = nil },
		{ weight = 2, prefab = "gorge_caramel_cube",     amount = {3, 5},     season = nil },
		{ weight = 1, prefab = "bunnystew",              amount = {1, 5},     season = nil },
		{ weight = 1, prefab = "seafoodgumbo",           amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "watermelonicle",         amount = {1, 5},     season = nil },
		{ weight = 1, prefab = "bananapop",              amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "taffy",                  amount = {1, 5},     season = nil },
		{ weight = 1, prefab = "powcake",                amount = {1, 7},     season = nil },
		{ weight = 1, prefab = "pumpkincookie",          amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "jammypreserves",         amount = {1, 5},     season = nil },
		{ weight = 1, prefab = "fruitmedley",            amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "waffles",                amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "unagi",                  amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "sweettea",               amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "fishsticks",             amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "ceviche",                amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "veggieomlet",            amount = {1, 4},     season = nil },
		{ weight = 1, prefab = "beefalotreat",           amount = {1, 3},     season = nil },
		{ weight = 1, prefab = "mandrakesoup",           amount = 1,          season = nil },
	},
}

local WEIGHTED_CRITTER_TABLE = {}
local WEIGHTED_ITEM_TABLE = {}

for _, critter in ipairs(LOOT.CRITTERS) do
	WEIGHTED_CRITTER_TABLE[critter] = critter.weight

	if critter.prefab ~= EMPTY_PREFAB then
		table.insert(prefabs, critter.prefab)
	end
end

for _, item in ipairs(LOOT.ITEMS) do
	WEIGHTED_ITEM_TABLE[item] = item.weight

	if item.prefab ~= EMPTY_PREFAB then
		table.insert(prefabs, item.prefab)
	end
end

local function OnSeasonChange(inst, season)
	return TheWorld.state.season
end

local function SetWagonArt(inst, season)
	if inst.on_cooldown then
		inst.AnimState:PlayAnimation("empty", true)
		return
	end

	local season = OnSeasonChange(inst)

	local fx = SpawnPrefab("small_puff")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx.Transform:SetScale(1.7, 1.7, 1.7)
	
	inst.AnimState:PlayAnimation("idle_"..season or "empty", true)
end

local function IsCorrectSeason(loot)
	if loot.season == nil then
		return true
	end
	
	return TheWorld.state.season == loot.season
end

-- This is ugly as hell. from "scenarios/random_damage.lua"
local function ApplyRandomCondition(inst)
	if inst.components.health ~= nil then
		inst.components.health:DoDelta(math.random(-inst.components.health.maxhealth * .75, 0), 0, "sammywagon")
	elseif inst.components.finiteuses ~= nil then
		inst.components.finiteuses.current = math.max(math.random(inst.components.finiteuses.total * .1, inst.components.finiteuses.total * .75), 1)
	elseif inst.components.condition ~= nil then
		inst.components.condition.current = math.random(inst.components.condition.maxcondition * .1, inst.components.condition.maxcondition * .75)
	elseif inst.components.armor ~= nil then
		inst.components.armor.condition = math.random(inst.components.armor.maxcondition * .1, inst.components.armor.maxcondition * .75)
	elseif inst.components.fueled ~= nil then
		inst.components.fueled.currentfuel = math.random(inst.components.fueled.maxfuel * .1, inst.components.fueled.maxfuel * .75)
	elseif inst.components.perishable ~= nil then
		local min, max = 0.33, 1.0
				
		if TheWorld.state.season == "autumn" then
			min, max = 0.33, 1.0
		elseif TheWorld.state.season == "winter" then
			min, max = 0.66, 1.0
		elseif TheWorld.state.season == "spring" then
			min, max = 0.45, 1.0
		elseif TheWorld.state.season == "summer" then
			min, max = 0.33, 0.7
		end
				
		local freshness = math.random() * (max - min) + min
		inst.components.perishable:SetPercent(freshness)
	end
end

local function SpawnWagonLoot(inst, picker, nopickup)
	if math.random() <= TUNING.KYNO_MERMCART_CRITTER_CHANCE then
		local choice = weighted_random_choice(WEIGHTED_CRITTER_TABLE)
		local enabled = choice.tuning and TUNING[choice.tuning]
        
		if (enabled == nil or enabled) and choice.prefab ~= nil and choice.prefab ~= EMPTY_PREFAB and IsCorrectSeason(choice) then
			local critter = SpawnPrefab(choice.prefab)
			local attackplayer = not (critter:HasTag("spider") and picker:HasOneOfTags("spiderwhisperer", "spiderdisguise"))
			
			inst.components.lootdropper:FlingItem(critter)
			
			if attackplayer and choice.targetplayer and critter.components.combat ~= nil then
                critter.components.combat:SetTarget(picker)
            end
			
			if choice.state ~= nil and (not choice.targetplayer or attackplayer) then
				critter.sg:GoToState(choice.state, picker)
			end
		end
	end

	local choice = weighted_random_choice(WEIGHTED_ITEM_TABLE)

	if choice.prefab ~= nil and choice.prefab ~= EMPTY_PREFAB and IsCorrectSeason(choice) then
		local amount = 1
		
		if type(choice.amount) == "table" then
			amount = math.random(choice.amount[1], choice.amount[2])
		elseif type(choice.amount) == "number" then
			amount = choice.amount
		end

		for i = 1, amount do
			local item = SpawnPrefab(choice.prefab)

			ApplyRandomCondition(item)

			if not nopickup and picker.components.inventory ~= nil then
				picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
			else
				inst.components.lootdropper:FlingItem(item)
			end
		end
	end
end

local function OnPicked(inst, picker)
	if inst.on_cooldown then
		if picker ~= nil and picker.components.talker ~= nil then
			picker.components.talker:Say(GetString(picker, "ANNOUNCE_KYNO_RUMMAGE_WAGON_EMPTY"))
		end
        
		return
	end

	SpawnWagonLoot(inst, picker)

	inst.uses_left = inst.uses_left - 1

	if inst.uses_left <= 0 then
		inst.on_cooldown = true
        
		inst.components.timer:StartTimer("wagon_cooldown", TUNING.KYNO_MERMCART_COOLDOWN)
		inst.components.pickable:MakeEmpty()
		SetWagonArt(inst)
    end
end

local function StartPickingLoot(inst)
	if inst._pickingtask ~= nil then
		inst._pickingtask:Cancel()
		inst._pickingtask = nil
	end
	
	inst._pickingloop = true
    inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_sml", "rummage")
end

local function StopPickingLoot(inst, nosound)
	if inst._pickingtask ~= nil then
		inst._pickingtask:Cancel()
		inst._pickingtask = nil

		return
	end
	
	inst._pickingloop = nil
	inst.SoundEmitter:KillSound(RUMMAGE_SOUND_NAME)
	
	if not nosound then
		inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_pst", nil, 0.3)
	end
end

local function StartPicking(inst, doer)
	if inst._pickingtask == nil then
		inst._pickingtask = inst:DoTaskInTime(0.2, StartPickingLoot)
	end

	inst._pickers = inst._pickers or {}

	if inst._pickers[doer] ~= nil then
		return
	end

	local pickingstate = doer.sg.currentstate.name

	local cb = function(doer, data)
		if not (data and data.statename == pickingstate) then
			inst:StopPicking(doer)
		end
	end

	inst._pickers[doer] = cb

	inst:ListenForEvent("newstate", cb, doer)
	inst:ListenForEvent("onremove", cb, doer)
end

local function StopPicking(inst, doer, nosound)
	local cb = inst._pickers and inst._pickers[doer] or nil
	
	if cb == nil then
		return
	end

	inst:RemoveEventCallback("newstate", cb, doer)
	inst:RemoveEventCallback("onremove", cb, doer)
	
	inst._pickers[doer] = nil

	if next(inst._pickers) == nil then
		inst._pickers = nil
		inst:StopPickingLoot(nosound)
    end
end

local function OnRegen(inst)
	SetWagonArt(inst)
end

local function OnMakeEmpty(inst)
	SetWagonArt(inst)
end

local function OnTimerDone(inst, data)
	if data.name == "wagon_cooldown" then
		inst.on_cooldown = false
        
		inst.uses_left = TUNING.KYNO_MERMCART_USES
		inst.components.pickable:Regen()
		SetWagonArt(inst)
	end
end

local function GetStatus(inst, viewer)
	return (inst.on_cooldown and "EMPTY")
	or "GENERIC"
end

local function OnSave(inst, data)
    data.uses_left = inst.uses_left
    data.on_cooldown = inst.on_cooldown

    if inst.components.timer:TimerExists("wagon_cooldown") then
        data.cooldown_timer = inst.components.timer:GetTimeLeft("wagon_cooldown")
    end
end

local function OnLoad(inst, data)
    if data then
        inst.uses_left = data.uses_left or TUNING.KYNO_MERMCART_USES
        inst.on_cooldown = data.on_cooldown or false

        if inst.on_cooldown then
			inst.components.pickable:MakeEmpty()
            SetWagonArt(inst)

            if data.cooldown_timer then
                inst.components.timer:StartTimer("wagon_cooldown", data.cooldown_timer)
            else
                inst.components.timer:StartTimer("wagon_cooldown", WAGON_COOLDOWN_TIMER)
            end
        else
			inst.components.pickable:Regen()
            SetWagonArt(inst)
        end
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermcart.tex")
	minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("kyno_meadowisland_mermcart")
    inst.AnimState:SetBuild("kyno_meadowisland_mermcart")
	inst.AnimState:PlayAnimation("empty")
	
	inst:AddTag("sammywagon")
	inst:AddTag("donotautopick") -- Prevents Maxwell's minions from picking when its empty.
	inst:AddTag("pickable_rummage_str")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.on_cooldown = false
	inst.uses_left = TUNING.KYNO_MERMCART_USES
	inst.StartPickingLoot = StartPickingLoot
	inst.StopPickingLoot = StopPickingLoot
	inst.SpawnWagonLoot = SpawnWagonLoot
	inst.StartPicking = StartPicking
	inst.StopPicking = StopPicking

	inst:AddComponent("timer")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "qol1/wagstaff_ruins/rummagepile_sml"
    inst.components.pickable:SetUp(nil, 0)
	inst.components.pickable.onpickedfn = OnPicked
	-- inst.components.pickable.onregenfn = OnRegen
	-- inst.components.pickable.makeemptyfn = OnMakeEmpty
	
	inst:WatchWorldState("season", SetWagonArt)
	SetWagonArt(inst, TheWorld.state.season)
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("startlongaction", inst.StartPicking)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("kyno_meadowisland_mermcart", fn, assets, prefabs)