local _G = GLOBAL

-- Pig King Trades Some Items.
local MOD_TRADES = GetModConfigData("MODTRADES")

local function BushTraderPostInit(inst)
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

local function WheatTraderPostInit(inst)
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

local function SweetTraderPostInit(inst)
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

local function RadishTraderPostInit(inst)
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

local function FennelTraderPostInit(inst)
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

local function AloeTraderPostInit(inst)
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

local function LimpetTraderPostInit(inst)
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

local function TaroTraderPostInit(inst)
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

local function LotusTraderPostInit(inst)
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

local function CressTraderPostInit(inst)
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

local function CucumberTraderPostInit(inst)
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

local function WeedTraderPostInit(inst)
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

local function ParsnipTraderPostInit(inst)
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

local function TurnipTraderPostInit(inst)
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

local function KokonutTraderPostInit(inst)
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

local function BananaTraderPostInit(inst)
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

local function TidalTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "turf_tidalmarsh" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "turf_tidalmarsh" }
	end
end

local function FieldsTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "turf_fields" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "turf_fields" }
	end
end

local function RiceTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_rice_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_rice_seeds" }
	end
end

local function SweetflyTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugarfly" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugarfly" }
	end
end

local function FlowerTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugartree_petals" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugartree_petals" }
	end
end

local function SalmonTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_salmonfish" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_salmonfish" }
	end
end

local function SugarwoodTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugartree_bud" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sugartree_bud" }
	end
end

local function PineappleTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_pineapple" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_pineapple" }
	end
end

local function TropicalTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_tropicalfish" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_tropicalfish" }
	end
end

local function KoiTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_koi" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_koi" }
	end
end

local function NeonTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_neonfish" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_neonfish" }
	end
end

local function PierrotTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_pierrotfish" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_pierrotfish" }
	end
end

local function EggTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_chicken_egg" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_chicken_egg" }
	end
end

if MOD_TRADES then
	AddPrefabPostInit("dug_berrybush",          BushTraderPostInit)
	AddPrefabPostInit("dug_berrybush2",         BushTraderPostInit)
	AddPrefabPostInit("dug_berrybush_juicy",    BushTraderPostInit)
	AddPrefabPostInit("dug_grass",              WheatTraderPostInit)
	AddPrefabPostInit("potato_seeds",           SweetTraderPostInit)
	AddPrefabPostInit("carrot_seeds",           RadishTraderPostInit)
	AddPrefabPostInit("durian_seeds",           FennelTraderPostInit)
	AddPrefabPostInit("asparagus_seeds",        AloeTraderPostInit)
	AddPrefabPostInit("cutlichen",              LimpetTraderPostInit)
	AddPrefabPostInit("eggplant",               TaroTraderPostInit)
	AddPrefabPostInit("butterfly",              LotusTraderPostInit)
	AddPrefabPostInit("succulent_picked",       CressTraderPostInit)
	AddPrefabPostInit("watermelon_seeds",       CucumberTraderPostInit)
	AddPrefabPostInit("kelp",                   WeedTraderPostInit)
	AddPrefabPostInit("pumpkin_seeds",          ParsnipTraderPostInit)
	AddPrefabPostInit("garlic_seeds",           TurnipTraderPostInit)
	AddPrefabPostInit("pomegranate_seeds",      KokonutTraderPostInit)
	AddPrefabPostInit("cave_banana",            BananaTraderPostInit)
	AddPrefabPostInit("turf_marsh",             TidalTraderPostInit)
	AddPrefabPostInit("turf_grass",             FieldsTraderPostInit)
	AddPrefabPostInit("onion_seeds",            RiceTraderPostInit)
	AddPrefabPostInit("moonbutterfly",          SweetflyTraderPostInit)
	AddPrefabPostInit("petals",                 FlowerTraderPostInit)
	AddPrefabPostInit("pondeel",                SalmonTraderPostInit)
	AddPrefabPostInit("acorn",                  SugarwoodTraderPostInit)
	AddPrefabPostInit("dragonfruit",            PineappleTraderPostInit)
	AddPrefabPostInit("oceanfish_medium_8_inv", TropicalTraderPostInit)
	AddPrefabPostInit("oceanfish_medium_7_inv", KoiTraderPostInit)
	AddPrefabPostInit("oceanfish_medium_4_inv", NeonTraderPostInit)
	AddPrefabPostInit("oceanfish_medium_5_inv", PierrotTraderPostInit)
	AddPrefabPostInit("bird_egg",               EggTraderPostInit)
end