local WAXED_PLANTS = require("prefabs/waxed_plant_common")
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

ASSETS = 
{
    Asset("SCRIPT", "scripts/prefabs/waxed_plant_common.lua")
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
}

local function CreateWaxedSpottyShrub(name)
    return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab      = "kyno_spotbush",
        bank        = "quagmire_spiceshrub",
        build       = "quagmire_spiceshrub",
        minimapicon = "quagmire_spotspice_shrub",
        anim        = "idle",
        action      = "DIG",
        physics     = {MakeSmallObstaclePhysics, 0.1},
        animset     = SPOTBUSH_ANIMSET,
        getanim_fn  = SpotBush_GetAnimFn,
        assets      = ASSETS,
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

local ret = 
{
    CreateWaxedSpottyShrub("kyno_spotbush"),
	
	CreateWaxedTreeSapling("kyno_kokonuttree_sapling", "kyno_kokonut", "planted"),
	CreateWaxedTreeSapling("kyno_meadowisland_tree_sapling", "kyno_meadowisland_tree_sapling", "planted"),
	CreateWaxedTreeSapling("kyno_sugartree_sapling", "kyno_serenityisland_sapling", "planted"),
	
    WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab        = "kyno_wildwheat",
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
    }),
}

return unpack(ret)