-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab

-- Rockjaws Drops Shark Fin.
AddPrefabPostInit("shark", function(inst)
    if _G.TheWorld.ismastersim and not _G.KnownModIndex:IsModEnabled("workshop-2174681153") then
        inst.components.lootdropper:AddChanceLoot("kyno_shark_fin", 1.00)
    end
end)

-- Cookie Cutters Drops Mussel.
AddPrefabPostInit("cookiecutter", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("kyno_mussel", 0.50)
end)

-- Beefalos Drops Bean Bugs.
AddPrefabPostInit("beefalo", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 1.00)
    inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 0.50)
end)

AddPrefabPostInit("babybeefalo", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 0.10)
end)

-- Catcoon Drops Gummy Slug
AddPrefabPostInit("catcoon", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("kyno_gummybug", 0.35)
end)

-- Some Birds Spawns Roe Periodically.
AddPrefabPostInit("puffin", function(inst)
    if inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetPrefab("kyno_roe")
        inst.components.periodicspawner:SetDensityInRange(20, 2)
        inst.components.periodicspawner:SetMinimumSpacing(8)
    end
end)

AddPrefabPostInit("canary", function(inst)
    if inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetPrefab("kyno_roe")
        inst.components.periodicspawner:SetDensityInRange(20, 2)
        inst.components.periodicspawner:SetMinimumSpacing(8)
    end
end)

-- If T.A.P is enabled, make sure Cormorant Spawns Roe too.
if _G.KnownModIndex:IsModEnabled("workshop-2428854303") then
    AddPrefabPostInit("cormorant", function(inst)
        if inst.components.periodicspawner ~= nil then
            inst.components.periodicspawner:SetPrefab("kyno_roe")
            inst.components.periodicspawner:SetDensityInRange(20, 2)
            inst.components.periodicspawner:SetMinimumSpacing(8)
        end
    end)
end

-- Kingfisher drops Tropical Kois periodically.
AddPrefabPostInit("kingfisher", function(inst)
	if inst.components.periodicspawner ~= nil then
		inst.components.periodicspawner:SetPrefab("kyno_koi")
		inst.components.periodicspawner:SetDensityInRange(20, 2)
		inst.components.periodicspawner:SetMinimumSpacing(15)
	end
end)

-- Dragonfly Drops Coffee Plants.
local DF_COFFEE = GetModConfigData("HOF_COFFEEDROPRATE")
if DF_COFFEE == 1 then
    AddPrefabPostInit("dragonfly", function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
    end)
elseif DF_COFFEE == 2 then
    AddPrefabPostInit("dragonfly", function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
    end)
elseif DF_COFFEE == 3 then
    AddPrefabPostInit("dragonfly", function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
    end)
elseif DF_COFFEE == 4 then
    AddPrefabPostInit("dragonfly", function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
        inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
    end)
end

-- It's Cursed. Players Have a Chance to Drop Long Pig. Except WX-78, Wurt, Wortox and Wormwood.
local HUMANMEATY = GetModConfigData("HOF_HUMANMEAT")
if HUMANMEATY == 1 then
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
			if math.random() < 0.50 then
				SpawnPrefab("kyno_humanmeat").Transform:SetPosition(inst.Transform:GetWorldPosition())
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

-- Splumonkeys and Splumonkey Pods drops Bananas.
--[[
AddPrefabPostInit("monkey", function(inst)
    _G.SetSharedLootTable('monkey',
    {
        {"smallmeat",     1.0},
        {"cave_banana",   1.0},
        {"beardhair",     1.0},
        {"nightmarefuel", 0.5},
        -- 50% when in Nightmare.
        {"kyno_banana",   0.5},
    })

    local MONKEYLOOT = {"smallmeat", "cave_banana"}

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetLoot(MONKEYLOOT)
    inst.components.lootdropper:AddChanceLoot("kyno_banana", 0.20)
end)

AddPrefabPostInit("monkeybarrel", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("kyno_banana", 1.00)
end)
]]--

-- Birds transforms into Pigeons when landing on Serenity Archipelago.
local function SerenityBirdPostinit(inst)
	inst:DoTaskInTime(1/30, function(inst)

    local TileAtPosition = _G.TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
        if TileAtPosition == WORLD_TILES.QUAGMIRE_PARKFIELD or TileAtPosition == WORLD_TILES.QUAGMIRE_CITYSTONE then

            inst.AnimState:SetBuild("quagmire_pigeon_build")

            inst:SetPrefabName("quagmire_pigeon")
            inst.nameoverride = "quagmire_pigeon"
            inst.trappedbuild = "quagmire_pigeon_build"
			inst.sounds =
			{
				takeoff = "dontstarve/birds/takeoff_quagmire_pigeon",
				chirp = "dontstarve/birds/chirp_quagmire_pigeon",
				flyin = "dontstarve/birds/flyin",
			}

            if not _G.TheWorld.ismastersim then
                return inst
            end

            inst.components.inventoryitem.onpickupfn = function(inst, doer)
                inst:Remove()
                local bird = SpawnPrefab("quagmire_pigeon")
                doer.components.inventory:GiveItem(bird)
                return true
            end
        end
    end)
end

AddPrefabPostInit("crow", SerenityBirdPostinit)
AddPrefabPostInit("robin", SerenityBirdPostinit)
AddPrefabPostInit("robin_winter", SerenityBirdPostinit)
AddPrefabPostInit("puffin", SerenityBirdPostinit)

-- Birds transforms into Kingfisher and Toucans when landing on Termagant Island.
local function MeadowBirdPostinit(inst)
	inst:DoTaskInTime(1/30, function(inst)

    local TileAtPosition = _G.TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
        if TileAtPosition == WORLD_TILES.MONKEY_GROUND or TileAtPosition == WORLD_TILES.HOF_TIDALMARSH then

            inst.AnimState:SetBuild("toucan_build")

            inst:SetPrefabName("toucan")
            inst.nameoverride = "toucan"
            inst.trappedbuild = "toucan_build"
			inst.sounds =
			{
				takeoff = "hof_sounds/creatures/toucan/take_off",
				chirp = "hof_sounds/creatures/toucan/chirp",
				flyin = "dontstarve/birds/flyin",
			}

            if not _G.TheWorld.ismastersim then
                return inst
            end

            inst.components.inventoryitem.onpickupfn = function(inst, doer)
                inst:Remove()
                local bird = SpawnPrefab("toucan")
                doer.components.inventory:GiveItem(bird)
                return true
            end
        elseif TileAtPosition == WORLD_TILES.HOF_FIELDS then
			inst.AnimState:SetBuild("kingfisher_build")

            inst:SetPrefabName("kingfisher")
            inst.nameoverride = "kingfisher"
            inst.trappedbuild = "kingfisher_build"
			inst.sounds =
			{
				takeoff = "hof_sounds/creatures/kingfisher/take_off",
				chirp = "hof_sounds/creatures/kingfisher/chirp",
				flyin = "dontstarve/birds/flyin",
			}

            if not _G.TheWorld.ismastersim then
                return inst
            end

            inst.components.inventoryitem.onpickupfn = function(inst, doer)
                inst:Remove()
                local bird = SpawnPrefab("kingfisher")
                doer.components.inventory:GiveItem(bird)
                return true
            end
		end
    end)
end

AddPrefabPostInit("crow", MeadowBirdPostinit)
AddPrefabPostInit("robin", MeadowBirdPostinit)
AddPrefabPostInit("robin_winter", MeadowBirdPostinit)
AddPrefabPostInit("puffin", MeadowBirdPostinit)

-- Animals that can be killed with the Slaughter Tools.
local slaughterable_animals =
{
    "koalefant_winter",
    "koalefant_summer",
    "beefalo",
    "spat",
    "lightninggoat",
}

for k,v in pairs(slaughterable_animals) do
    AddPrefabPostInit(v, function(inst)
        inst:RemoveTag("slaughterable")

        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst:AddTag("slaughterable")
    end)
end

-- Crab King and its claws Drops Crab Meat instead of Meat.
-- Update this if Klei updates their counterparts!
AddPrefabPostInit("crabking", function(inst)
    _G.SetSharedLootTable("hof_crabking",
    {
        {"chesspiece_crabking_sketch",  1.00},
        {"trident_blueprint",           1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"kyno_crabmeat",               1.00},
        {"singingshell_octave5",        1.00},
        {"singingshell_octave5",        1.00},
        {"singingshell_octave5",        1.00},
        {"singingshell_octave5",        1.00},
        {"singingshell_octave5",        0.50},
        {"singingshell_octave5",        0.25},
        {"singingshell_octave4",        1.00},
        {"singingshell_octave4",        1.00},
        {"singingshell_octave4",        1.00},
        {"singingshell_octave4",        0.50},
        {"singingshell_octave4",        0.25},
        {"singingshell_octave3",        1.00},
        {"singingshell_octave3",        1.00},
        {"singingshell_octave3",        0.50},
        {"barnacle",                    1.00},
        {"barnacle",                    1.00},
        {"barnacle",                    1.00},
        {"barnacle",                    0.25},
        {"barnacle",                    0.25},
        {"barnacle",                    0.25},
        {"barnacle",                    0.25},
    })

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable("hof_crabking")
end)

AddPrefabPostInit("crabking_claw", function(inst)
    _G.SetSharedLootTable("hof_crabking_claw",
    {
        {"kyno_crabmeat",               1.00},
    })

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable("hof_crabking_claw")
end)

-- Bee Queen drops the blueprint for the Honey Deposit.
AddPrefabPostInit("beequeen", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.lootdropper:AddChanceLoot("kyno_antchest_blueprint", 1.00)
end)

-- Grumble Bees, Killer Bees and Bees drops Nectar. Bees only during the Spring.
AddPrefabPostInit("beeguard", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod", 0.20)
end)

AddPrefabPostInit("killerbee", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod", 1.00)
end)

AddPrefabPostInit("bee", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if TheWorld.state.isspring then
		inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod", 0.50)
	end
end)

-- "Fix" players trying to milk frozen animals.
local freezable_fix_animals =
{
	"beefalo",
	"koalefant_summer",
	"koalefant_winter",
	"lightninggoat",
}

local function FreezablePostinit(inst)
	local function OnFreeze(inst)
		inst:AddTag("is_frozen")
	end

	local function OnThaw(inst)
		inst:AddTag("is_thawing")
	end

	local function OnUnfreeze(inst)
		inst:RemoveTag("is_frozen")
		inst:RemoveTag("is_thawing")
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:ListenForEvent("onthaw", OnThaw)
	inst:ListenForEvent("freeze", OnFreeze)
	inst:ListenForEvent("unfreeze", OnUnfreeze)
end

for k, v in pairs(freezable_fix_animals) do
	AddPrefabPostInit(v, FreezablePostinit)
end

-- Animals that can be milked with the Bucket.
local function MilkableBeefaloPostinit(inst)
	local function OnMilked(inst, milker)
		local kick_chance

		if inst:HasTag("domesticated") then
			kick_chance = 0
		elseif milker:HasTag("beefalo") then
			kick_chance = 10
		else
			kick_chance = 70
		end

		if math.random(100) <= kick_chance and milker.components.combat and not inst:HasTag("sleeping")
		and not inst:HasTag("is_frozen") and not inst:HasTag("is_thawing") then
			inst.AnimState:PlayAnimation("atk", false)
			inst.SoundEmitter:PlaySound("dontstarve/beefalo/angry")
			milker.components.combat:GetAttacked(inst, TUNING.MILKABLE_NORMAL_DAMAGE)
			milker:PushEvent("kick")
		elseif inst:HasTag("domesticated") then
			if not inst:HasTag("sleeping") then
				inst.AnimState:PlayAnimation("bellow", false)
				inst.SoundEmitter:PlaySound("dontstarve/beefalo/grunt")
			end
		else
			if not inst:HasTag("sleeping") then
				inst.AnimState:PlayAnimation("bellow", false)
				inst.SoundEmitter:PlaySound("dontstarve/beefalo/grunt")
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("milkableanimal")
	inst.components.milkableanimal:SetUp("kyno_milk_beefalo")
	inst.components.milkableanimal.onmilkedfn = OnMilked
end

local function MilkableKoalefantPostinit(inst)
	local function OnMilked(inst, milker)
		local kick_chance

		if milker:HasTag("beefalo") then
			kick_chance = 10
		else
			kick_chance = 70
		end

		if math.random(100) <= kick_chance and milker.components.combat and not inst:HasTag("sleeping")
		and not inst:HasTag("is_frozen") and not inst:HasTag("is_thawing") then
			inst.AnimState:PlayAnimation("atk", false)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")
			milker.components.combat:GetAttacked(inst, TUNING.MILKABLE_KOALEFANT_DAMAGE)
			milker:PushEvent("kick")
		else
			if not inst:HasTag("sleeping") then
				inst.AnimState:PlayAnimation("bellow", false)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/grunt")
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("milkableanimal")
	inst.components.milkableanimal:SetUp("kyno_milk_koalefant")
	inst.components.milkableanimal.onmilkedfn = OnMilked
end

local function MilkableVoltGoatPostinit(inst)
	local function OnMilked(inst, milker)
		local kick_chance

		if milker:HasTag("beefalo") then
			kick_chance = 10
		else
			kick_chance = 70
		end

		if math.random(100) <= kick_chance and milker.components.combat and not inst:HasTag("sleeping")
		and not inst:HasTag("is_frozen") and not inst:HasTag("is_thawing") then
			inst.AnimState:PlayAnimation("taunt", false)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/taunt")
			milker.components.combat:GetAttacked(inst, TUNING.MILKABLE_LIGHTNINGGOAT_DAMAGE)
			milker:PushEvent("kick")
		else
			if not inst:HasTag("sleeping") then
				inst.AnimState:PlayAnimation("bleet", false)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/bleet")
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("milkableanimal")
	inst.components.milkableanimal:SetUp("goatmilk")
	inst.components.milkableanimal.onmilkedfn = OnMilked
end

AddPrefabPostInit("beefalo", MilkableBeefaloPostinit)
AddPrefabPostInit("koalefant_summer", MilkableKoalefantPostinit)
AddPrefabPostInit("koalefant_winter", MilkableKoalefantPostinit)
AddPrefabPostInit("lightninggoat", MilkableVoltGoatPostinit)

-- For the frog immunity buff.
local function FrogPostinit(inst)
	local RESTARGET_MUST_TAGS = {"_combat", "_health"}
	local RETARGET_CANT_TAGS = {"merm", "frogimmunity"}

	local function Retarget(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy)
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
		RESTARGET_MUST_TAGS, RETARGET_CANT_TAGS)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.combat:SetRetargetFunction(3, Retarget)
end

AddPrefabPostInit("frog", FrogPostinit)

-- Toadstool drops Poison Frog Legs instead of normal Frog Legs.
-- Update this if Klei updates their counterparts!
AddPrefabPostInit("toadstool", function(inst)
    _G.SetSharedLootTable("hof_toadstool",
    {
        {"kyno_poison_froglegs",    	1.00},
		{"meat",          				1.00},
		{"meat",          				1.00},
		{"meat",          				1.00},
		{"meat",          				0.50},
		{"meat",          				0.25},

		{"shroom_skin",   				1.00},
		{"chesspiece_toadstool_sketch", 1.00},

		{"red_cap",       				1.00},
		{"red_cap",       				0.33},
		{"red_cap",       				0.33},

		{"blue_cap",     	 			1.00},
		{"blue_cap",      				0.33},
		{"blue_cap",      				0.33},

		{"green_cap",     				1.00},
		{"green_cap",     				0.33},
		{"green_cap",     				0.33},
    })

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable("hof_toadstool")
end)

AddPrefabPostInit("toadstool_dark", function(inst)
    _G.SetSharedLootTable("hof_toadstool_dark",
    {
        {"kyno_poison_froglegs",        1.00},
		{"meat",          				1.00},
		{"meat",          				1.00},
		{"meat",          				1.00},
		{"meat",          				0.50},
		{"meat",          				0.25},

		{"shroom_skin",   				1.00},
		{"shroom_skin",   				1.00},
		{"chesspiece_toadstool_sketch", 1.00},

		{"red_cap",      				1.00},
		{"red_cap",       				0.33},
		{"red_cap",       				0.33},

		{"blue_cap",      				1.00},
		{"blue_cap",      				0.33},
		{"blue_cap",      				0.33},

		{"green_cap",     				1.00},
		{"green_cap",     				0.33},
		{"green_cap",     				0.33},

		{"mushroom_light2_blueprint", 	1.00},
		{"sleepbomb_blueprint", 		1.00},
    })

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable("hof_toadstool_dark")
end)