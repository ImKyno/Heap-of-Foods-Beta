-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab
local UpvalueHacker   = require("hof_upvaluehacker")

require("hof_util")

AddPrefabPostInit("forest", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("sugarflyspawner")
    inst:AddComponent("retrofitforestmap_hof")
	
	-- Let the players know they have force retrofit option enabled.
    --[[
	inst:DoTaskInTime(10, function()
		if TUNING.HOF_RETROFIT_FORCE then
			_G.TheNet:Announce("WARNING! You have \"Force Retrofit\" Option enabled!")
			_G.TheNet:Announce("This option can't be disabled automatically by the server.")
			_G.TheNet:Announce("After finishing the Retrofiting process, please head back to the Main Menu to disable it.")
		end
	end)
    ]]--
end)

AddPrefabPostInit("cave", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("retrofitforestmap_hof")
end)

-- Pig King Trades Some Items.
local MOD_TRADES = GetModConfigData("MODTRADES")
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

local function TidalTrader(inst)
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

local function FieldsTrader(inst)
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

local function RiceTrader(inst)
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

local function SweetflyTrader(inst)
	if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_sweetfly" }
    else
        inst.components.tradable.goldvalue = 1
        inst.components.tradable.tradefor = { "kyno_sweetfly" }
    end
end

local function FlowerTrader(inst)
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

local function SalmonTrader(inst)
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

local function SugarwoodTrader(inst)
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

local function PineappleTrader(inst)
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

local function TropicalTrader(inst)
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

local function KoiTrader(inst)
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

local function NeonTrader(inst)
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

local function PierrotTrader(inst)
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

local function EggTrader(inst)
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
	AddPrefabPostInit("dug_berrybush",          BushTrader)
	AddPrefabPostInit("dug_berrybush2",         BushTrader)
	AddPrefabPostInit("dug_berrybush_juicy",    BushTrader)
	AddPrefabPostInit("dug_grass",              WheatTrader)
	AddPrefabPostInit("potato_seeds",           SweetTrader)
	AddPrefabPostInit("carrot_seeds",           RadishTrader)
	AddPrefabPostInit("durian_seeds",           FennelTrader)
	AddPrefabPostInit("asparagus_seeds",        AloeTrader)
	AddPrefabPostInit("cutlichen",              LimpetTrader)
	AddPrefabPostInit("eggplant",               TaroTrader)
	AddPrefabPostInit("butterfly",              LotusTrader)
	AddPrefabPostInit("succulent_picked",       CressTrader)
	AddPrefabPostInit("watermelon_seeds",       CucumberTrader)
	AddPrefabPostInit("kelp",                   WeedTrader)
	AddPrefabPostInit("pumpkin_seeds",          ParsnipTrader)
	AddPrefabPostInit("garlic_seeds",           TurnipTrader)
	AddPrefabPostInit("pomegranate_seeds",      KokonutTrader)
	AddPrefabPostInit("cave_banana",            BananaTrader)
	AddPrefabPostInit("turf_marsh",             TidalTrader)
	AddPrefabPostInit("turf_grass",             FieldsTrader)
	AddPrefabPostInit("onion_seeds",            RiceTrader)
	AddPrefabPostInit("moonbutterfly",          SweetflyTrader)
	AddPrefabPostInit("petals",                 FlowerTrader)
	AddPrefabPostInit("pondeel",                SalmonTrader)
	AddPrefabPostInit("acorn",                  SugarwoodTrader)
	AddPrefabPostInit("dragonfruit",            PineappleTrader)
	AddPrefabPostInit("oceanfish_medium_8_inv", TropicalTrader)
	AddPrefabPostInit("oceanfish_medium_7_inv", KoiTrader)
	AddPrefabPostInit("oceanfish_medium_4_inv", NeonTrader)
	AddPrefabPostInit("oceanfish_medium_5_inv", PierrotTrader)
	AddPrefabPostInit("bird_egg",               EggTrader)
end

-- Nuts drops from Twiggy Trees.
AddPrefabPostInit("twiggytree", function(inst)
    if inst.components.workable ~= nil then
        local onfinish_old_t = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(function(inst, chopper)
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper:AddChanceLoot("kyno_twiggynuts", 0.25)
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

-- For Installing the new Cookware on the Fire Pits.
local function FirePitCookwarePostinit(inst)
	local function GetFirepit(inst)
        if not inst.firepit or not inst.firepit:IsValid() or not inst.firepit.components.fueled then
            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = _G.TheSim:FindEntities(x,y,z, 0.01)
            inst.firepit = nil
            for k,v in pairs(ents) do
                if v.prefab == "firepit" then
                    inst.firepit = v
                    break
                end
            end
        end
		
        return inst.firepit
    end

	local function ApplyHanger(inst)
		local firepit = GetFirepit(inst)
		
        if firepit then
			firepit:AddTag("firepit_has_hanger")
			firepit:AddTag("firepit_with_cookware")
			firepit.components.cookwareinstaller.enabled = false
			firepit.hascookware = true
			firepit.hashanger = true
		end
	end
	
	local function RemoveCookware(inst)
		local firepit = GetFirepit(inst)
		
		if firepit then
			firepit:RemoveTag("firepit_has_hanger")
			firepit:RemoveTag("firepit_has_grill")
			firepit:RemoveTag("firepit_has_oven")
			firepit:RemoveTag("firepit_with_cookware")
			firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
			firepit.components.cookwareinstaller.enabled = true
			firepit.hascookware = false
			firepit.hashanger = false
			firepit.hasgrill = false
			firepit.hasoven = false
		end
	end

    local function ChangeGrillFireFX(inst)
		local firepit = GetFirepit(inst)
		
        if firepit then
            firepit:AddTag("firepit_has_grill")
			firepit:AddTag("firepit_with_cookware")
            firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
			firepit.components.cookwareinstaller.enabled = false
			firepit.hascookware = true
			firepit.hasgrill = true
        end
    end

    local function ChangeOvenFireFX(inst)
		local firepit = GetFirepit(inst)
		
        if firepit then
            firepit:AddTag("firepit_has_oven")
			firepit:AddTag("firepit_with_cookware")
            firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
			firepit.components.cookwareinstaller.enabled = false
			firepit.hascookware = true
			firepit.hasoven = true
        end
    end

    local function TestItem(inst, item, giver)
        if item.components.inventoryitem and item:HasTag("firepit_installer") then
            return true
        else
            giver.components.talker:Say(GetString(giver, "ANNOUNCE_FIREPITINSTALL_FAIL"))
        end
    end

    local function OnGetItemFromPlayer(inst, giver, item)
        if item.components.inventoryitem ~= nil and item:HasTag("pot_hanger_installer") then
            SpawnPrefab("kyno_cookware_hanger").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/pot_hanger")

            inst.components.cookwareinstaller.enabled = false
			ApplyHanger(inst)
        end

        if item.components.inventoryitem ~= nil and item:HasTag("grill_big_installer") then
            SpawnPrefab("kyno_cookware_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_big")

            inst.components.cookwareinstaller.enabled = false
            ChangeGrillFireFX(inst)
        end

        if item.components.inventoryitem ~= nil and item:HasTag("grill_small_installer") then
            SpawnPrefab("kyno_cookware_small_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_small")

            inst.components.cookwareinstaller.enabled = false
            ChangeGrillFireFX(inst)
        end

        if item.components.inventoryitem ~= nil and item:HasTag("oven_installer") then
            local oven = SpawnPrefab("kyno_cookware_oven")
			oven.Transform:SetPosition(inst.Transform:GetWorldPosition())
			oven.AnimState:PlayAnimation("place")
			
            inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/oven")

            inst.components.cookwareinstaller.enabled = false
            ChangeOvenFireFX(inst)
        end
    end

	local function OnSave(inst, data)
		local firepit = GetFirepit(inst)

		data.queued_charcoal = inst.queued_charcoal or nil
		data.hashanger = firepit.hashanger or nil
		data.haspot = firepit.haspot or nil
		data.hasgrill = firepit.hasgrill or nil
		data.hasoven = firepit.hasoven or nil
		data.hascookware = firepit.hascookware or nil
	end

	local function OnLoad(inst, data)
		local firepit = GetFirepit(inst)

		if data ~= nil and data.queued_charcoal then
			inst.queued_charcoal = true
		end

		if data ~= nil and data.hascookware then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_with_cookware")
				firepit.components.cookwareinstaller.enabled = false
				firepit.hascookware = true
			end)
		end

		if data ~= nil and data.hashanger then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_hanger")
				firepit:AddTag("firepit_with_cookware")
				firepit.components.cookwareinstaller.enabled = false
				firepit.hascookware = true
				firepit.hashanger = true
			end)
		end
		
		if data ~= nil and data.haspot then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_pot")
				firepit:AddTag("firepit_with_cookware")
				firepit.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
				firepit.components.cookwareinstaller.enabled = false
				firepit.hascookware = true
				firepit.hashanger = true
				firepit.haspot = true
			end)
		end

		if data ~= nil and data.hasgrill then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_grill")
				firepit:AddTag("firepit_with_cookware")
				firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
				firepit.components.cookwareinstaller.enabled = false
				firepit.hascookware = true
				firepit.hasgrill = true
			end)
		end

		if data ~= nil and data.hasoven then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_oven")
				firepit:AddTag("firepit_with_cookware")
				firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
				firepit.components.cookwareinstaller.enabled = false
				firepit.hascookware = true
				firepit.hasoven = true
			end)
		end
		
		if data ~= nil and data.hascookware == false then
			inst:DoTaskInTime(1, function()
				local firepit = GetFirepit(inst)
		
				if firepit then
					firepit:RemoveTag("firepit_has_hanger")
					firepit:RemoveTag("firepit_has_grill")
					firepit:RemoveTag("firepit_has_oven")
					firepit:RemoveTag("firepit_with_cookware")
					firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
					firepit.components.cookwareinstaller.enabled = true
					firepit.hascookware = false
					firepit.hashanger = false
					firepit.hasgrill = false
					firepit.hasoven = false
				end
			end)
		end
	end

    inst:AddTag("cookware_installable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst:HasTag("firepit_has_grill") then
        inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
	elseif inst:HasTag("firepit_has_oven") then
        inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
	elseif inst:HasTag("firepit_has_pot") then
		inst.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
	end

    inst:AddComponent("cookwareinstaller")
    inst.components.cookwareinstaller:SetAcceptTest(TestItem)
    inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
end

AddPrefabPostInit("firepit", FirePitCookwarePostinit)

-- Make Banana Bushes give our Bananas instead.
AddPrefabPostInit("bananabush", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.pickable then
        inst.components.pickable:SetUp("kyno_banana")
    end
end)

-- Purple Grouper can be caught on Swamp ponds.
AddPrefabPostInit("pond_mos", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.fishable ~= nil then
		inst.components.fishable:AddFish("kyno_grouper")
	end
end)

-- For trading turfs with the Elder.
local function TurfTrader(inst)
	if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inventoryitem ~= nil and not inst.components.tradable then
        inst:AddComponent("tradable")
	end
end

AddPrefabPostInit("turf_road",      TurfTrader)
AddPrefabPostInit("turf_deciduous", TurfTrader)

-- Setup the container for the Potato Sack.
local function PotatoSackPostinit(inst)
	local function OnHammered(inst, worker)
		if inst:HasTag("fire") and inst.components.burnable then
			inst.components.burnable:Extinguish()
		end

		inst.components.lootdropper:DropLoot()

		if inst.components.container then
			inst.components.container:DropEverything()
		end

		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
		inst:Remove()
	end

	local function OnOpen(inst)
		if not inst:HasTag("burnt") then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
		end
	end

	local function OnClose(inst, doer)
		if not inst:HasTag("burnt") then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
		end
	end

	local function OnHit(inst, worker)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle_full")

			if inst.components.container then
				inst.components.container:DropEverything()
				inst.components.container:Close()
			end
		end
	end

	local function OnPickup(inst)
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.components.container:Close()
		end
	end
	
	inst.scrapbook_proxy = "potatosack2" -- Fix for missing Scrapbook CRAFTING_FILTER.

	if not _G.TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("potatosack") end
        return inst
    end

	if inst.components.workable ~= nil then
		inst.components.workable:SetOnFinishCallback(OnHammered)
		inst.components.workable:SetOnWorkCallback(OnHit)
	end

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

	inst:AddComponent("container")
    inst.components.container:WidgetSetup("potatosack")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:ListenForEvent("onputininventory", OnPickup)
end

AddPrefabPostInit("potatosack", PotatoSackPostinit)

-- Items that can go inside the Potato Sack.
local potatosack_items =
{
	"potato",
	"potato_cooked",

	"sweetpotato",
	"sweetpotato_cooked",

	"kyno_sweetpotato",
	"kyno_sweetpotato_cooked",

	"potato_seeds",
	"sweetpotato_seeds",
	"kyno_sweetpotato_seeds",
}

local function PotatoSackItemsPostinit(inst)
	inst:AddTag("potatosack_valid")
end

for k, v in pairs(potatosack_items) do
	AddPrefabPostInit(v, PotatoSackItemsPostinit)
end

-- Include the Brewing Recipe Card to the Tumbleweed.
-- I'm not sure if this is the best way to do it, I'll change it later, maybe...
local function TumbleweedPostinit(inst)
	local function OnInitBrewingCard(inst)
		if math.random() < TUNING.KYNO_BREWINGRECIPECARD_CHANCE then
			table.insert(inst.loot, "kyno_brewingrecipecard")
			table.insert(inst.lootaggro, false)
		end
	end

	if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0, OnInitBrewingCard)
end

AddPrefabPostInit("tumbleweed", TumbleweedPostinit)

-- Allows Wickerbottom's book to grow some plants.
local function MarbleShrubPostInit(inst)
	inst:AddTag("marbletree")
end

AddPrefabPostInit("marbleshrub", MarbleShrubPostInit)

local function LivingTreeHalloween(inst)
	inst:AddTag("livingtree_halloween")
end

AddPrefabPostInit("livingtree_halloween", LivingTreeHalloween)

local function PlantNormalPostInit(inst)
	inst:AddTag("plant")
end

AddPrefabPostInit("plant_normal", PlantNormalPostInit)

-- Immunity to Sporeclouds.
local function SporecloudPostInit(inst)
	local AURA_EXCLUDE_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.sporecloud.fn, "AURA_EXCLUDE_TAGS")
    table.insert(AURA_EXCLUDE_TAGS, "sporecloudimmune")
end

AddPrefabPostInit("sporecloud", SporecloudPostInit)

local weeds =
{
	"weed_firenettle",
	"weed_forgetmelots",
	"weed_tillweed",
}

for k, v in pairs(weeds) do
	AddPrefabPostInit(v, function(inst)
		inst.entity:AddSoundEmitter()
	end)
end

-- Add Swordfish to Vitreoasis.
local function GrottoPoolBigPostInit(inst)
	inst:AddTag("pond")
	
	local function GetFish(inst)
		return _G.TheWorld.state.iswinter and "kyno_swordfish_blue" or nil
	end

	if not _G.TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("fishable")
	inst.components.fishable:SetGetFishFn(GetFish)
	inst.components.fishable.maxfish = TUNING.KYNO_GROTTO_POOL_MAX_FISH
	inst.components.fishable:SetRespawnTime(TUNING.KYNO_SWORDFISH_BLUE_REGROW_TIME)
end

AddPrefabPostInit("grotto_pool_big", GrottoPoolBigPostInit)

-- Anything with "fireproof" tag will be ignored by Ice Flingomatic.
local FireDetector = require("components/firedetector")

local FIRESUPRESSOR_IGNORE_TAGS = {"fireproof"}
local NOTAGS_FIRESUPPRESSOR = UpvalueHacker.GetUpvalue(FireDetector.ActivateEmergencyMode, "OnDetectEmergencyTargets", "NOTAGS")

for k, v in pairs(FIRESUPRESSOR_IGNORE_TAGS) do
    table.insert(NOTAGS_FIRESUPPRESSOR, v)
end

-- New birds will spawn when landing on these turfs.
AddClassPostConstruct("components/birdspawner", function(self)
	local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

	BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD] = {"quagmire_pigeon"}
	BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE] = {"quagmire_pigeon"}

	BIRD_TYPES[WORLD_TILES.MONKEY_GROUND]      = {"toucan"}
	BIRD_TYPES[WORLD_TILES.HOF_TIDALMARSH]     = {"toucan"}
	BIRD_TYPES[WORLD_TILES.HOF_FIELDS]         = {"kingfisher"}
end)

-- Spawns Mist in static layouts, not using game's function because its too dense.
AddSimPostInit(function()
	if not _G.TheWorld or not _G.TheWorld.topology or not _G.TheWorld.topology.nodes then
		return
	end

	for i, node in ipairs(_G.TheWorld.topology.nodes) do
		if node.tags and table.contains(node.tags, "LowMist") then
			if node.area == nil then
				node.area = 1
			end

			if not _G.TheNet:IsDedicated() then
				local mist = _G.SpawnPrefab("mist")
				mist.Transform:SetPosition(node.cent[1], 0, node.cent[2])
				mist.components.emitter.area_emitter = CreateAreaEmitter(node.poly, node.cent)

				local ext = ResetextentsForPoly(node.poly)
				mist.entity:SetAABB(ext.radius, 2)

				local density = math.ceil(node.area / 4) / 31

				if table.contains(node.tags, "LowMist") then
					density = density * 0.2 -- 20% from total density.
				end

				mist.components.emitter.density_factor = density
				mist.components.emitter:Emit()
			end
		end
	end
end)