-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab
local UpvalueHacker   = require("hof_upvaluehacker")

require("hof_util")

local DF_COFFEE = GetModConfigData("COFFEEDROPRATE")

-- Use to replace loot prefabs in their LootTables.
local function ReplaceLoot(prefab, from, to)
    for i, tbl in ipairs(LootTables[prefab]) do
        if tbl[1] == from then
            tbl[1] = to
        end
    end
end

local function SharkPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if not TUNING.HOF_IS_TCP_ENABLED then
		if inst.components.lootdropper ~= nil then	
			inst.components.lootdropper:AddChanceLoot("kyno_shark_fin", 1.00)
		end
	end
end

AddPrefabPostInit("shark", SharkPostInit)

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
if TUNING.HOF_IS_TAP_ENABLED then
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

-- Dragonfly Drops Coffee Plants.
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

-- Malbatross Drops Salt Pack blueprint.
AddPrefabPostInit("malbatross", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_foodsack_blueprint", 1.00)
end)

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
	
	if inst.islunar then
		inst.components.lootdropper:SetLoot({"kyno_moon_froglegs"})
	end
end

AddPrefabPostInit("frog", FrogPostinit)
AddPrefabPostInit("lunarfrog", FrogPostinit)

-- Toadstool drops Poison Frog Legs instead.
local function ToadstoolPostInit(inst)
	ReplaceLoot(inst.prefab, "froglegs", "kyno_poison_froglegs")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 0.50)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 0.25)
	end
end

local function ToadstoolDarkPostInit(inst)
	ReplaceLoot(inst.prefab, "froglegs", "kyno_poison_froglegs")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 0.50)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 0.25)
	end
end

AddPrefabPostInit("toadstool", ToadstoolPostInit)
AddPrefabPostInit("toadstool_dark", ToadstoolDarkPostInit)

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
	"medal_bee", -- For mod compatibility: 能力勋章 Functional Medal.
}

local function PollinatorPostIint(inst)
	inst:AddTag("sugarflowerpollinator")
end

for k, v in pairs(pollinators) do
	AddPrefabPostInit(v, PollinatorPostIint)
end

local function AntlionPostInit(inst)
	local _OnGivenItem
	
	local function OnGivenItem(inst, giver, item, ...)
		if item.prefab == "lazydessert" then
			if giver ~= nil and giver:IsValid() then
				giver:PushEvent("learncookbookstats", item.prefab)
			end
		end
		
		return _OnGivenItem(inst, giver, item, ...)
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.trader ~= nil then
		_OnGivenItem = inst.components.trader.onaccept
		inst.components.trader.onaccept = OnGivenItem
	end
end

AddPrefabPostInit("antlion", AntlionPostInit)

-- Truffles make pigs happy, yay.
local function PigmanPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return
	end
	
	if inst.components.trader ~= nil then
		local _onaccept = inst.components.trader.onaccept
		
		inst.components.trader.onaccept = function(inst, giver, item, ...)
			if item and item:HasTag("truffles") then
				if giver and giver.components.leader ~= nil then
					if not (inst:HasTag("guard") or giver:HasTag("monster") or giver:HasTag("merm")) then
						giver:PushEvent("makefriend")
						giver.components.leader:AddFollower(inst)
						
						-- Pigs befriended with truffles will follow for longer times.
						inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
						inst.components.follower.maxfollowtime = giver:HasTag("polite")
						and TUNING.KYNO_TRUFFLES_PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
						or TUNING.KYNO_TRUFFLES_PIG_LOYALTY_MAXTIME
					end
				end
			end
			
			if _onaccept then
				_onaccept(inst, giver, item, ...)
			end
		end
	end
end

AddPrefabPostInit("pigman", PigmanPostInit)

--[[
local function WormBossPostInit(inst)
	local _GenerateLoot = UpvalueHacker.GetUpvalue(_G.Prefabs.worm_boss
end

AddPrefabPostInit("worm_boss", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    -- Pegamos o arquivo original
    local prefab_fn = require("prefabs/worm_boss")

    -- Pegamos a função GenerateLoot
    local GenerateLoot = UpvalueHacker.GetUpvalue(prefab_fn, "GenerateLoot")

    if GenerateLoot then
        -- Pegamos a tabela interna de loot
        local loottable = UpvalueHacker.GetUpvalue(GenerateLoot, "loottable")

        if loottable and loottable.boneshard then
            -- Remove o item original
            loottable.boneshard = nil
        end

        -- Adiciona sua prefab customizada no lugar
        loottable["meu_item_custom"] = 15  -- nome da sua prefab e quantidade
    else
        print("[WormBossLootPatch] Falhou em achar GenerateLoot!")
    end
end)
]]--

-- Guaranteed Golden Apple for Wagstaff cutscene and chances afterwards.
local GOLDENAPPLE_ADDED = false

local function ScionPostInit(inst)
	if GOLDENAPPLE_ADDED then
		return
	end
	
	local WAGSTAFF_LOOT = UpvalueHacker.GetUpvalue(_G.Prefabs.alterguardian_phase4_lunarrift.fn, "LootSetupFn", "WAGSTAFF_LOOT")
    table.insert(WAGSTAFF_LOOT, "kyno_goldenapple")

	GOLDENAPPLE_ADDED = true
end

AddPrefabPostInit("alterguardian_phase4_lunarrift", ScionPostInit)

-- Leonidas remember me to not put LootTables inside postinit again, otherwise it will 
-- increase the drop by +1 each time the entity spawns.
local function ApplyLootTables()
	if _G.LootTables and _G.LootTables.lordfruitfly then
		table.insert(_G.LootTables.lordfruitfly, {"kyno_garden_sprinkler_blueprint", 1.00})
	end

	if _G.LootTables and _G.LootTables.alterguardian_phase4_lunarrift then
		table.insert(_G.LootTables.alterguardian_phase4_lunarrift, {"kyno_goldenapple", 0.10})
	end
end

AddSimPostInit(ApplyLootTables)