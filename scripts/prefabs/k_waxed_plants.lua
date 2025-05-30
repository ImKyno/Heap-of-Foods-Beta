local WAXED_PLANTS = require("prefabs/waxed_plant_common")
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

ASSETS = 
{
    Asset("SCRIPT", "scripts/prefabs/waxed_plant_common.lua"),
	
	Asset("ANIM", "anim/quagmire_spiceshrub.zip"),
	Asset("ANIM", "anim/coffeebush.zip"),
	Asset("ANIM", "anim/kyno_pineapplebush.zip"),
	
	Asset("ANIM", "anim/kyno_wheat.zip"),
	Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass1.zip"),
	
	Asset("ANIM", "anim/tree_leaf_short.zip"),
    Asset("ANIM", "anim/tree_leaf_normal.zip"),
    Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/teatree_trunk_build.zip"),
    Asset("ANIM", "anim/teatree_build.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_tree_sapling.zip"),
	
	Asset("ANIM", "anim/kokonuttree_short.zip"),
	Asset("ANIM", "anim/kokonuttree_normal.zip"),
	Asset("ANIM", "anim/kokonuttree_tall.zip"),
	Asset("ANIM", "anim/kokonuttree_build.zip"),
	Asset("ANIM", "anim/kyno_kokonut.zip"),	
}

local function Plantable_GetAnimFn(inst)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        return "idle"
    end

    if (inst.components.pickable ~= nil and inst.components.pickable:IsBarren()) or 
	(inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
        return "dead"
    end

    return "picked"
end

local function SpotBush_GetAnimFn(inst)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        return "idle"
    end

    return "empty"
end

local function Tree_MultColorFn()
    return .5 + math.random() * .5
end

local function Tree_Minimap_CommonPostInit(inst)
    inst.MiniMapEntity:SetPriority(-1)
end

local SPOTBUSH_ANIMSET = 
{
	idle   = { anim = "idle"  },
    picked = { anim = "empty" },
	dead   = { anim = "empty" },
}

local function CreateWaxedSpottyShrub(name)
    return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab        = "kyno_spotbush",
		inventoryitem = "dug_kyno_spotbush",
        bank          = "quagmire_spiceshrub",
        build         = "quagmire_spiceshrub",
        minimapicon   = "quagmire_spotspice_shrub",
        anim          = "idle",
        action        = "DIG",
        physics       = {MakeSmallObstaclePhysics, 0.1},
        animset       = SPOTBUSH_ANIMSET,
        getanim_fn    = SpotBush_GetAnimFn,
        assets        = ASSETS,
		deployspacing = DEPLOYSPACING.MEDIUM,
    }) 
end

local WHEAT_ANIMSET = 
{
    idle   = { anim = "idle"      },
    picked = { anim = "picked"    },
    dead   = { anim = "idle_dead" },
}

local function Grass_MultColorFn()
    return 0.75 + math.random() * 0.25
end

local function CreateWaxedWildWheat(name)
	return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab        = "kyno_wildwheat",
		inventoryitem = "dug_kyno_wildwheat",
        bank          = "kyno_wheat",
        build         = "kyno_wheat",
        minimapicon   = "kyno_wildwheat",
        anim          = "idle",
        action        = "DIG",
        animset       = WHEAT_ANIMSET,
        getanim_fn    = Plantable_GetAnimFn,
        multcolor     = Grass_MultColorFn,
        assets        = ASSETS,
        deployspacing = DEPLOYSPACING.MEDIUM,
    })
end

local function TreeSapling_GetAnimFn(inst)
    return inst.prefab
end

local function CreateWaxedTreeSapling(name, _build, _anim, deployspacing)
    local animset = { [name.."_sapling"] = { anim = _anim } }

    return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab        = name.."_sapling",
        bank          = _build,
        build         = _build,
        anim          = _anim,
        action        = "DIG",
        animset       = animset,
        getanim_fn    = TreeSapling_GetAnimFn,
        assets        = ASSETS,
        deployspacing = deployspacing,
    })
end

local PINEAPPLE_HIDDEN = { "pineapple" }

local PINEAPPLE_ANIMSET = 
{
    idle         = { anim = "idle" },
    picked       = { anim = "idle", hidesymbols = PINEAPPLE_HIDDEN},
    dead         = { anim = "dead" },
}

local function CreateWaxedPineappleBush(name)
    return WAXED_PLANTS.CreateWaxedPlant({
        prefab      = "kyno_pineapplebush",
        bank        = "kyno_pineapplebush",
        build       = "kyno_pineapplebush",
        minimapicon = "kyno_pineapplebush",
        anim        = "idle",
        physics     = {MakeSmallObstaclePhysics, 0.1},
        animset     = PINEAPPLE_ANIMSET,
        getanim_fn  = Plantable_GetAnimFn,
        assets      = ASSETS,
    }) 
end

local COFFEEBUSH_TYPES  = { "berries", "berriesmore", "berriesmost" }
local COFFEEBUSH_HIDDEN = { "berries", "berriesmore" }

local COFFEEBUSH_ANIMSET = 
{
    idle         = { anim = "idle", hidesymbols = COFFEEBUSH_HIDDEN},
    picked       = { anim = "idle", hidesymbols = COFFEEBUSH_TYPES},
    dead         = { anim = "idle_dead" },
}

local function CreateWaxedCoffeeBush(name)
	return WAXED_PLANTS.CreateWaxedPlant({
		prefab        = "kyno_coffeebush",
		inventoryitem = "dug_kyno_coffeebush",
		bank          = "coffeebush",
		build         = "coffeebush",
		minimapicon   = "kyno_coffeebush",
		anim          = "idle",
		action        = "DIG",
		physics       = {MakeSmallObstaclePhysics, 0.1},
		animset       = COFFEEBUSH_ANIMSET,
		getanim_fn    = Plantable_GetAnimFn,
		assets        = ASSETS,
		deployspacing = DEPLOYSPACING.MEDIUM,
	})
end

local MEADOWISLANDTREE_ANIMSET_LIST = 
{
    "sway1_loop", "sway2_loop", "burnt", "stump"
}

local MEADOWISLANDTREE_LEAVES_BUILD = 
{
    normal = "tree_leaf_green_build",
    barren = "nil",
}

local MEADOWISLANDTREE_ANIMSET = {}

for _, anim in ipairs(MEADOWISLANDTREE_ANIMSET_LIST) do
    if anim == "burnt" then
        local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
        
        local minimapicon = "kyno_meadowisland_tree_burnt.tex"

        MEADOWISLANDTREE_ANIMSET[short]  = {anim = short,  minimap = minimapicon, stump = anim == "stump"}
        MEADOWISLANDTREE_ANIMSET[normal] = {anim = normal, minimap = minimapicon, stump = anim == "stump"}
        MEADOWISLANDTREE_ANIMSET[tall]   = {anim = tall,   minimap = minimapicon, stump = anim == "stump"}
		
	elseif anim == "stump" then
		local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
		
		local minimapicon = "kyno_meadowisland_tree_stump.tex"
		
		MEADOWISLANDTREE_ANIMSET[short]  = {anim = short,  minimap = minimapicon, stump = anim == "stump"}
        MEADOWISLANDTREE_ANIMSET[normal] = {anim = normal, minimap = minimapicon, stump = anim == "stump"}
        MEADOWISLANDTREE_ANIMSET[tall]   = {anim = tall,   minimap = minimapicon, stump = anim == "stump"}

    else
        for name, overridebuild in pairs(MEADOWISLANDTREE_LEAVES_BUILD) do
            local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
        
            local minimapicon = "kyno_meadowisland_tree.tex"

            local short_key, normal_key, tall_key = name.."_"..short, name.."_"..normal, name.."_"..tall
            local overridedata = overridebuild ~= "nil" and { "swap_leaves", overridebuild, "swap_leaves" } or nil
    
            MEADOWISLANDTREE_ANIMSET[short_key]  = {anim = short,  minimap = minimapicon, overridesymbol = overridedata}
            MEADOWISLANDTREE_ANIMSET[normal_key] = {anim = normal, minimap = minimapicon, overridesymbol = overridedata}
            MEADOWISLANDTREE_ANIMSET[tall_key]   = {anim = tall,   minimap = minimapicon, overridesymbol = overridedata}
        end
    end
end

local function MeadowIslandTree_GetAnimFn(inst)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        return inst.anims.burnt
    end

    if inst:HasTag("stump") then
        return inst.anims.stump
    end

    local sway = inst.AnimState:IsCurrentAnimation(inst.anims.sway2) and inst.anims.sway2 or inst.anims.sway1

    return inst.build .."_".. sway
end

local function MeadowIslandTree_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)

    inst.AnimState:Hide("mouseover")
end

local ret = 
{
    CreateWaxedSpottyShrub("kyno_spotbush"),
	CreateWaxedWildWheat("kyno_wildwheat"),
	CreateWaxedPineappleBush("kyno_pineapplebush"),
	CreateWaxedCoffeeBush("kyno_coffeebush"),
	
	CreateWaxedTreeSapling("kyno_kokonuttree_sapling", "kyno_kokonut", "planted"),
	CreateWaxedTreeSapling("kyno_meadowisland_tree_sapling", "kyno_meadowisland_tree_sapling", "planted"),
	CreateWaxedTreeSapling("kyno_sugartree_sapling", "kyno_serenityisland_sapling", "planted"),
	
	WAXED_PLANTS.CreateWaxedPlant({
        prefab          = "kyno_meadowisland_tree",
        bank            = "tree_leaf",
        build           = "teatree_trunk_build",
        anim            = "sway1_loop_tall",
        action          = "CHOP",
        physics         = {MakeObstaclePhysics, .25},
        animset         = MEADOWISLANDTREE_ANIMSET,
        getanim_fn      = MeadowIslandTree_GetAnimFn,
        common_postinit = MeadowIslandTree_CommonPostInit,
        multcolor       = Tree_MultColorFn,
        assets          = ASSETS,
    }),
}

return unpack(ret)