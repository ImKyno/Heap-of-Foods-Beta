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

AddPrefabPostInit("robin_winter", function(inst)
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

-- Theorically Tea Cool Down and Turns into Iced Tea.
AddPrefabPostInit("tea", function(inst)
    if inst.components.perishable ~= nil then
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "icedtea"
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
    local longpig_characters = {
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
			if math.random() < 0.90 then
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

-- Pig King Trades Some Items.
local function BushTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "dug_kyno_spotbush" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "dug_kyno_spotbush" }
    end
end

local function WheatTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "dug_kyno_wildwheat" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "dug_kyno_wildwheat" }
    end
end

local function SweetTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_sweetpotato_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_sweetpotato_seeds" }
    end
end

local function RadishTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_radish_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_radish_seeds" }
    end
end

local function FennelTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_fennel_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_fennel_seeds" }
    end
end

local function AloeTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_aloe_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_aloe_seeds" }
    end
end

local function LimpetTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_limpets" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_limpets" }
    end
end

local function TaroTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_taroroot" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_taroroot" }
    end
end

local function LotusTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_lotus_flower" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_lotus_flower" }
    end
end

local function CressTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_waterycress" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_waterycress" }
    end
end

local function CucumberTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_cucumber_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_cucumber_seeds" }
    end
end

local function WeedTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_seaweeds_root" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_seaweeds_root" }
    end
end

local function ParsnipTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_parznip_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_parznip_seeds" }
    end
end

local function TurnipTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_turnip_seeds" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_turnip_seeds" }
    end
end

local function KokonutTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_kokonut" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_kokonut" }
    end
end

local function BananaTrader(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_banana" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_banana" }
    end
end

AddPrefabPostInit("dug_berrybush", 			BushTrader)
AddPrefabPostInit("dug_berrybush2", 		BushTrader)
AddPrefabPostInit("dug_berrybush_juicy", 	BushTrader)
AddPrefabPostInit("dug_grass", 				WheatTrader)
AddPrefabPostInit("potato_seeds", 			SweetTrader)
AddPrefabPostInit("carrot_seeds", 			RadishTrader)
AddPrefabPostInit("durian_seeds", 			FennelTrader)
AddPrefabPostInit("asparagus_seeds", 		AloeTrader)
AddPrefabPostInit("cutlichen", 				LimpetTrader)
AddPrefabPostInit("eggplant", 				TaroTrader)
AddPrefabPostInit("butterfly", 				LotusTrader)
AddPrefabPostInit("succulent_picked", 		CressTrader)
AddPrefabPostInit("watermelon_seeds", 		CucumberTrader)
AddPrefabPostInit("kelp", 					WeedTrader)
AddPrefabPostInit("pumpkin_seeds", 			ParsnipTrader)
AddPrefabPostInit("garlic_seeds", 			TurnipTrader)
AddPrefabPostInit("pomegranate_seeds",		KokonutTrader)
AddPrefabPostInit("cave_banana",            BananaTrader)

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

-- Splumonkeys and Splumonkey Pods drops Bananas.
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

-- Just to make sure Deerclops drown if it spawns on water.
AddPrefabPostInit("deerclops", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("drownable")
end)

-- Nuts drops from Twiggy Trees.
AddPrefabPostInit("twiggytree", function(inst)
    if inst.components.workable ~= nil then
        local onfinish_old_t = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(function(inst, chopper)
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper:AddChanceLoot("kyno_twiggynuts", 0.50)
            end
            if onfinish_old_t ~= nil then
                onfinish_old_t(inst, chopper)
            end
        end)
    end
end)

-- Strident Trident Tweak for new ocean plants.
local function StridentTridentPostinit(inst)
	local INITIAL_LAUNCH_HEIGHT = 0.1
    local SPEED = 8

    local function launch_away(inst, position)
        local ix, iy, iz = inst.Transform:GetWorldPosition()
        inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

        local px, py, pz = position:Get()
        local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
        local sina, cosa = math.sin(angle), math.cos(angle)
        inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
    end

    local function DoWaterExplosionEffectNew(inst, affected_entity, owner, position)
        if affected_entity.components.health then
            local ae_combat = affected_entity.components.combat
            if ae_combat then
                ae_combat:GetAttacked(owner, TUNING.TRIDENT.SPELL.DAMAGE, inst)
            else
                affected_entity.components.health:DoDelta(-TUNING.TRIDENT.SPELL.DAMAGE, nil, inst.prefab, nil, owner)
            end
        elseif affected_entity.components.oceanfishable ~= nil then
            if affected_entity.components.weighable ~= nil then
                affected_entity.components.weighable:SetPlayerAsOwner(owner)
            end

            local projectile = affected_entity.components.oceanfishable:MakeProjectile()

            local ae_cp = projectile.components.complexprojectile
            if ae_cp then
                ae_cp:SetHorizontalSpeed(16)
                ae_cp:SetGravity(-30)
                ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
                ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

                local v_position = affected_entity:GetPosition()
                local launch_position = v_position + (v_position - position):Normalize() * SPEED
                ae_cp:Launch(launch_position, projectile)
            else
                launch_away(projectile, position)
            end
        elseif affected_entity.prefab == "bullkelp_plant" or affected_entity.prefab == "kyno_lotus_ocean" or
        affected_entity.prefab == "kyno_seaweeds_ocean" or affected_entity.prefab == "kyno_taroroot_ocean" or
        affected_entity.prefab == "kyno_waterycress_ocean" then
            local ae_x, ae_y, ae_z = affected_entity.Transform:GetWorldPosition()

            if affected_entity.components.pickable and affected_entity.components.pickable:CanBePicked() then
                local product = affected_entity.components.pickable.product
                local loot = SpawnPrefab(product)
                if loot ~= nil then
                    loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                    end
                    if loot.components.stackable ~= nil
                            and affected_entity.components.pickable.numtoharvest > 1 then
                        loot.components.stackable:SetStackSize(affected_entity.components.pickable.numtoharvest)
                    end
                    launch_away(loot, position)
                end
            end

            if affected_entity.prefab == "bullkelp_plant" then
                local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
                if uprooted_kelp_plant ~= nil then
                    uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                    launch_away(uprooted_kelp_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
                end
            end
            if affected_entity.prefab == "kyno_lotus_ocean" then
                local uprooted_lotus_plant = SpawnPrefab("kyno_lotus_flower")
                if uprooted_lotus_plant ~= nil then
                    uprooted_lotus_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                    launch_away(uprooted_lotus_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
                end
            end
            if affected_entity.prefab == "kyno_seaweeds_ocean" then
                local uprooted_seaweeds_plant = SpawnPrefab("kyno_seaweeds_root")
                if uprooted_seaweeds_plant ~= nil then
                    uprooted_seaweeds_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                    launch_away(uprooted_seaweeds_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
                end
            end
            if affected_entity.prefab == "kyno_taroroot_ocean" then
                local uprooted_taroroot_plant = SpawnPrefab("kyno_taroroot")
                if uprooted_taroroot_plant ~= nil then
                    uprooted_taroroot_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                    launch_away(uprooted_taroroot_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
                end
            end
            if affected_entity.prefab == "kyno_waterycress_ocean" then
                local uprooted_waterycress_plant = SpawnPrefab("kyno_waterycress")
                if uprooted_waterycress_plant ~= nil then
                    uprooted_waterycress_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                    launch_away(uprooted_waterycress_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
                end
            end

            affected_entity:Remove()
        elseif affected_entity.components.inventoryitem ~= nil then
            launch_away(affected_entity, position)
            affected_entity.components.inventoryitem:SetLanded(false, true)
        elseif affected_entity.waveactive then
            affected_entity:DoSplash()
        elseif affected_entity.components.workable ~= nil and affected_entity.components.workable:GetWorkAction() == ACTIONS.MINE then
            affected_entity.components.workable:WorkedBy(owner, TUNING.TRIDENT.SPELL.MINES)
        end
    end

    if not _G.TheWorld.ismastersim then
        return
    end

    inst.DoWaterExplosionEffect = DoWaterExplosionEffectNew
end

AddPrefabPostInit("trident", StridentTridentPostinit)

-- Crows transforms into Pigeons when landing on Pink Park Turf.
local function SerenityCrowPostinit(inst)
	inst:DoTaskInTime(1/30, function(inst)

    local TileAtPosition = _G.TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
        if TileAtPosition == WORLD_TILES.HOF_PINKPARK or TileAtPosition == WORLD_TILES.HOF_STONECITY then

            inst.AnimState:SetBuild("quagmire_pigeon_build")

            inst:SetPrefabName("quagmire_pigeon")
            inst.nameoverride = "quagmire_pigeon"
            inst.trappedbuild = "quagmire_pigeon_build"

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

AddPrefabPostInit("crow", SerenityCrowPostinit)

-- Animals that can be killed with the Slaughter Tools.
local slaughterable_animals = {
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

-- Colour Cubes and Music for the Serenitea Archipelago.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=2625422345
--[[
local SERENITY_CC = GetModConfigData("serenity_cc")
if SERENITY_CC == 1 then
    local function MakeSerenityArea(inst)
        _G.TheWorld:PushEvent("overridecolourcube", resolvefilepath("images/colourcubesimages/quagmire_cc.tex"))
    end

    local function RemoveSerenityArea(inst)
        _G.TheWorld:PushEvent("overridecolourcube", nil)
    end

    AddPrefabPostInit("world", function(inst)
        inst:DoTaskInTime(0, function(inst)
            if _G.TheWorld.topology then
                for i, node in ipairs(_G.TheWorld.topology.nodes) do
                    if table.contains(node.tags, "serenityarea") then
                        if node.area_emitter == nil then
                            if node.area == nil then
                                node.area = 1
                            end
                        end
                    end
                end
            end
        end)
    end)

    AddComponentPostInit("playervision", function(self)
        self.inst:DoTaskInTime(0, function()
            self.canchange = true
            self.inst:ListenForEvent("changearea", function(inst, area)
                if self.canchange then
                    if area and area.tags and table.contains(area.tags, "serenityarea") then
                        MakeSerenityArea(self.inst)
                    else
                        RemoveSerenityArea(self.inst)
                    end
                end
            end)

            self.inst:DoTaskInTime(0, function()
                local node, node_index = _G.TheWorld.Map:FindVisualNodeAtPoint(self.inst.Transform:GetWorldPosition())
                if node_index then
                    self.inst:PushEvent("changearea", node and {
                        id = _G.TheWorld.topology.ids[node_index],
                        type = node.type,
                        center = node.cent,
                        poly = node.poly,
                        tags = node.tags,
                    }
                    or nil)
                end
            end)
        end)
    end)
end
]]--

-- Retrofitting Stuff for old worlds.
require("hof_settings")
local SERENITYISLAND = GetModConfigData("HOF_SERENITYISLAND")

local function RetrofitSerenityIsland()
    local node_indices = {}
    for k, v in ipairs(_G.TheWorld.topology.ids) do
        if string.find(v, "Serenity Archipelago") then
            table.insert(node_indices, k)
        end
    end
    if #node_indices == 0 then
        return false
    end

    local tags = {"serenityarea"}
    for k, v in ipairs(node_indices) do
        if _G.TheWorld.topology.nodes[v].tags == nil then
            _G.TheWorld.topology.nodes[v].tags = {}
        end
        for i, tag in ipairs(tags) do
            if not table.contains(_G.TheWorld.topology.nodes[v].tags, tag) then
                table.insert(_G.TheWorld.topology.nodes[v].tags, tag)
            end
        end
    end
    for i, node in ipairs(_G.TheWorld.topology.nodes) do
        if table.contains(node.tags, "serenityarea") then
            _G.TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
    end

    return true
end

AddComponentPostInit("retrofitforestmap_anr", function(self)
    oldonpostinit = self.OnPostInit

    function self:OnPostInit(...)
        if SERENITYISLAND == 1 then
            local success = RetrofitSerenityIsland()
            if success then
                _G.ChangeFoodConfigs("HOF_SERENITYISLAND", 0)
                self.requiresreset = true
            end
        end

        return oldonpostinit(self, ...)
    end
end)

-- For Installing the new Cookware on the Fire Pits.
local function FirePitCookwarePostinit(inst)
	local function GetFirepit(inst)
        if not inst.firepit or not inst.firepit:IsValid() or not inst.firepit.components.fueled then
            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = _G.TheSim:FindEntities(x,y,z, 0.01)
            inst.firepit = nil
            for k,v in pairs(ents) do
                if v.prefab == 'firepit' then
                    inst.firepit = v
                    break
                end
            end
        end
        return inst.firepit
    end

    local function ChangeGrillFireFX(inst)
    local firepit = GetFirepit(inst)
        if firepit then
            firepit:AddTag("firepit_has_grill")
            firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
        end
    end

    local function ChangeOvenFireFX(inst)
    local firepit = GetFirepit(inst)
        if firepit then
            firepit:AddTag("firepit_has_oven")
            firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
        end
    end

    local function TestItem(inst, item, giver)
        -- Hanger / Cookingpot / Large Cookingpot / Syrup Pot / Grill / Large Grill.
        if item.components.inventoryitem and item:HasTag("firepit_installer") then
            return true -- Install the contents.
        else
            giver.components.talker:Say(GetString(giver, "ANNOUNCE_FIREPITINSTALL_FAIL"))
        end
    end

    local function OnGetItemFromPlayer(inst, giver, item)
        -- Hanger / Cookingpot / Large Cookingpot / Syrup Pot.
        if item.components.inventoryitem ~= nil and item:HasTag("pot_hanger_installer") then
            SpawnPrefab("kyno_cookware_hanger").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/pot_hanger")
            inst.components.trader.enabled = false -- Don't accept new items!
        end
        -- Grill / Large Grill.
        if item.components.inventoryitem ~= nil and item:HasTag("grill_big_installer") then
            SpawnPrefab("kyno_cookware_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_big")
            inst.components.trader.enabled = false
            ChangeGrillFireFX(inst)
        end
        if item.components.inventoryitem ~= nil and item:HasTag("grill_small_installer") then
            SpawnPrefab("kyno_cookware_small_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_small")
            inst.components.trader.enabled = false
            ChangeGrillFireFX(inst)
        end
        -- Oven / Small Casserole Dish / Large Casserole Dish.
        if item.components.inventoryitem ~= nil and item:HasTag("oven_installer") then
            SpawnPrefab("kyno_cookware_oven").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/oven")
            inst.components.trader.enabled = false
            ChangeOvenFireFX(inst) -- Yeah, the same.
        end
    end

    inst:AddTag("serenity_installable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst:HasTag("firepit_has_grill") then
        inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
    end

    if inst:HasTag("firepit_has_oven") then
        inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
    end

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
end

AddPrefabPostInit("firepit", FirePitCookwarePostinit)

-- Small fix for the natural spawning Mushroom Stump.
local mushstumps = {
    "kyno_mushstump_natural",
    "kyno_mushstump_cave",
}

for k,v in pairs(mushstumps) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("mushroom_stump_natural")
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

-- Small fix for the Watery Crate and Freshwater Fishing Rod.
AddPrefabPostInit("kyno_watery_crate", function(inst)
    inst:AddTag("not_serenity_crate")
end)

-- Animals that can be milked with the Bucket.
local milkable_animals = {
    "koalefant_winter",
    "koalefant_summer",
    "beefalo",
    "deer",
    "spat",
}
for k,v in pairs(milkable_animals) do
    AddPrefabPostInit(v, function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("milkable2")
        -- Beefalo.
        if inst.prefab == "beefalo" then
            inst.components.milkable2:SetUp("kyno_milk_beefalo")
        end
        -- Koalefants.
        if inst.prefab == "koalefant_summer" or "koalefant_winter" then
            inst.components.milkable2:SetUp("kyno_milk_koalefant")
        end
        -- No-Eyed Deer.
        if inst.prefab == "deer" then
            inst.components.milkable2:SetUp("kyno_milk_deer")
        end
        -- Ewecus.
        if inst.prefab == "spat" then
            inst.components.milkable2:SetUp("kyno_milk_spat")
        end
    end)
end

-- Make Banana Bushes give our Bananas instead.
AddPrefabPostInit("bananabush", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.pickable then
        inst.components.pickable:SetUp("kyno_banana")
    end
end)

-- Monkey Queen also accepts our Bananas!
local new_bananas = {
    "kyno_banana",
    "kyno_banana_cooked",
}

for k,v in pairs(new_bananas) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("monkeyqueenbribe")
    end)
end

-- Make Sugarfly spawn on the Serenity Archipelago.
AddPrefabPostInit("forest", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("sugarflyspawner")
end)