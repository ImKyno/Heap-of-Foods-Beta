-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab

require("hof_mainfunctions")
require("hof_upvaluehacker")

-- Use to replace loot prefabs in their LootTables.
local function ReplaceLoot(prefab, from, to)
    for i, tbl in ipairs(LootTables[prefab]) do
        if tbl[1] == from then
            tbl[1] = to
        end
    end
end

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

-- Prime Mate has very small chance of dropping Pirate's Rum
AddPrefabPostInit("prime_mate", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:AddChanceLoot("piraterum", 0.05)
end)

-- Lord of the Fruit Flies drops Garden Sprinkler blueprint.
AddPrefabPostInit("lordfruitfly", function(inst)
	if _G.LootTables and _G.LootTables.lordfruitfly then
		table.insert(_G.LootTables.lordfruitfly, {"kyno_garden_sprinkler_blueprint", 1.00})
	end
end)

-- Dragonfly Drops Coffee Plants.
local DF_COFFEE = GetModConfigData("COFFEEDROPRATE")
AddPrefabPostInit("dragonfly", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.lootdropper ~= nil then
		for _ = 1, DF_COFFEE do
			inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		end
	end
end)

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

-- Bee Queen drops the blueprint for the Honey Deposit.
AddPrefabPostInit("beequeen", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.lootdropper:AddChanceLoot("kyno_antchest_blueprint", 1.00)
	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         1.00)
	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         1.00)
	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         0.33)
	inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         0.33)
end)

-- Bees drops Nectar based on how much flowers they have pollinated.
-- They can pollinate up to 5 flowers, so: 20%, 40%, 60%, 80%, 100% chance for each flower pollinated.
AddStategraphPostInit("bee", function(sg)
    local _death_onenter = sg.states["death"].onenter

    sg.states["death"].onenter = function(inst, ...)
        if inst.components.pollinator and inst.components.lootdropper then
            inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod", 0.2 * #inst.components.pollinator.flowers)
        end

        _death_onenter(inst, ...)
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

-- For the Noxious Froggle Bunwich effect.
local function FrogPostinit(inst)
	local RETARGET_MUST_TAGS = {"_combat", "_health"}
	local RETARGET_CANT_TAGS = {"merm", "frogimmunity"}
	local LUNAR_RETARGET_CANT_TAGS = {"merm", "lunar_aligned", "frogimmunity"}

	local function Retarget(inst)
    if not inst.components.health:IsDead() and not (inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep()) then
		local target_dist = inst.islunar and TUNING.LUNARFROG_TARGET_DIST or TUNING.FROG_TARGET_DIST
        local cant_tags   = inst.islunar and LUNAR_RETARGET_CANT_TAGS or RETARGET_CANT_TAGS
	
        return FindEntity(inst, target_dist, function(guy)
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil and inst.hof_oldretarget
            end
        end,
		
			RETARGET_MUST_TAGS, cant_tags)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.combat ~= nil then
		inst.hof_oldretarget = inst.components.combat.targetfn
		inst.components.combat:SetRetargetFunction(3, Retarget)
	end
end

AddPrefabPostInit("frog", FrogPostinit)
AddPrefabPostInit("lunarfrog", FrogPostinit)

-- Toadstool drops Poison Frog Legs instead.
AddPrefabPostInit("toadstool", function(inst) ReplaceLoot(inst.prefab, "froglegs", "kyno_poison_froglegs") end)
AddPrefabPostInit("toadstool_dark", function(inst) ReplaceLoot(inst.prefab, "froglegs", "kyno_poison_froglegs") end)

-- Crab King and its claws drop Crab King Meat instead.
AddPrefabPostInit("crabking", function(inst) ReplaceLoot(inst.prefab, "meat", "kyno_crabkingmeat") end)
AddPrefabPostInit("crabking_claw", function(inst) ReplaceLoot(inst.prefab, "meat", "kyno_crabkingmeat") end)

-- Crab Guards and Crab Knights drop Crab Meat instead.
AddPrefabPostInit("crabking_mob", function(inst) ReplaceLoot(inst.prefab, "meat", "kyno_crabmeat") end)
AddPrefabPostInit("crabking_mob_knight", function(inst) ReplaceLoot(inst.prefab, "meat", "kyno_crabmeat") end)

-- Pollinators will also target Sugar Flowers as well.
local pollinators = 
{
	"bee",
	"butterfly",
}

local function PollinatorPostIint(inst)
	inst:AddTag("sugarflowerpollinator")
end

for k, v in pairs(pollinators) do
	AddPrefabPostInit(v, PollinatorPostIint)
end