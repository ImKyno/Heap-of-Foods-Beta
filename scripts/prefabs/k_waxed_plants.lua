local WAXED_PLANTS = require("prefabs/waxed_plant_common")

ASSETS = 
{
	Asset("SCRIPT", "scripts/prefabs/waxed_plant_common.lua"),
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

local function CoffeeBush_GetAnimFn(inst)
	if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
		local percent = 0
			
		if inst.components.pickable ~= nil then
			percent = inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
		end
			
		if percent >= .9 then
			return "berriesmost"
		elseif percent >= .33 then
			return "berriesmore"
		else
			return "berries"
		end
	end
	
    if (inst.components.pickable ~= nil and inst.components.pickable:IsBarren()) or 
	(inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
        return "idle_dead"
    end
	
	return "picked"
end

local function SpotBush_GetAnimFn(inst)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        return "idle"
    end
	
	if (inst.components.pickable ~= nil and inst.components.pickable:IsBarren()) or 
	(inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
        return "empty"
    end

    return "empty"
end

local function Tree_Minimap_CommonPostInit(inst)
    inst.MiniMapEntity:SetPriority(-1)
end

local function Tree_MultColorFn()
    return .5 + math.random() * .5
end

local function PikoTree_MultColorFn()
	return .7 
end

local function Grass_MultColorFn()
    return 0.75 + math.random() * 0.25
end

local function Tree_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)

    inst.AnimState:Hide("mouseover")
end

local COFFEE_TYPES  = { "berries", "berriesmore", "berriesmost" }
local COFFEE_HIDDEN = { "berries", "berriesmore" }

local COFFEEBUSH_ANIMSET = 
{
	berriesmost  = { anim = "berriesmost" },
	berriesmore  = { anim = "berriesmore" },
	berries      = { anim = "berries" },
	picked       = { anim = "idle" },
    dead         = { anim = "idle_dead" },
}

local SPOTBUSH_ANIMSET = 
{
	idle   = { anim = "idle"  },
    picked = { anim = "empty" },
	empty  = { anim = "empty" },
}

local WHEAT_ANIMSET = 
{
    idle   = { anim = "idle"      },
    picked = { anim = "picked"    },
    dead   = { anim = "idle_dead" },
}

local function TreeSapling_GetAnimFn(inst)
    return inst.prefab
end

local function CreateWaxedTreeSapling(name, _build, _anim, deployspacing)
    local animset = { [name] = { anim = _anim } }

    return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab        = name,
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

local MEADOWISLANDTREE_ANIMSET_LIST = 
{
	"sway1_loop", "sway2_loop", "burnt", "stump",
}

local MEADOWISLANDTREE_LEAVES_BUILD = 
{
    normal = "teatree_build",
	barren = "nil",
}

local MEADOWISLANDTREE_ANIMSET = {}

for _, anim in ipairs(MEADOWISLANDTREE_ANIMSET_LIST) do
    if anim == "burnt" or anim == "stump" then
        local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
        
        local minimapicon = "kyno_meadowisland_tree_"..anim..".tex"

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

local function MeadowIslandTree_CommonPostInit(inst)
	Tree_Minimap_CommonPostInit(inst)
	
	inst.AnimState:AddOverrideBuild("teatree_trunk_build")
	
	inst.AnimState:Hide("mouseover")
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

local KOKONUTTREE_ANIMSET_LIST = 
{
	"sway1_loop", "sway2_loop", "burnt", "stump",
}

local KOKONUTTREE_ANIMSET = {}

for _, anim in ipairs(KOKONUTTREE_ANIMSET_LIST) do
	if anim == "burnt" or anim == "stump" then
		local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
		
		local minimapicon = "kyno_kokonuttree_"..anim..".tex"

		KOKONUTTREE_ANIMSET[short]  = {anim = short,  minimap = minimapicon, stump = anim == "stump"}
		KOKONUTTREE_ANIMSET[normal] = {anim = normal, minimap = minimapicon, stump = anim == "stump"}
		KOKONUTTREE_ANIMSET[tall]   = {anim = tall,   minimap = minimapicon, stump = anim == "stump"}
	else
		local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
		
		local minimapicon = "kyno_kokonuttree.tex"
		
		KOKONUTTREE_ANIMSET[short]  = {anim = short,  minimap = minimapicon}
		KOKONUTTREE_ANIMSET[normal] = {anim = normal, minimap = minimapicon}
		KOKONUTTREE_ANIMSET[tall]   = {anim = tall,   minimap = minimapicon}
	end
end

local function KokonutTree_GetAnimFn(inst)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        return inst.anims.burnt
    end

    if inst:HasTag("stump") then
        return inst.anims.stump
    end

    local sway = inst.AnimState:IsCurrentAnimation(inst.anims.sway2) and inst.anims.sway2 or inst.anims.sway1

    return sway
end

-- Piko Trees alre always tall size.
local PIKOTREE_ANIMSET_LIST = 
{
	"sway1_loop", "sway2_loop",
}

local PIKOTREE_ANIMSET = {}

for _, anim in ipairs(PIKOTREE_ANIMSET_LIST) do
    if anim == "sway1_loop" or anim == "sway2_loop" then
        local tall = anim.."_tall"
        
        local minimapicon = "kyno_meadowisland_tree.tex"

        PIKOTREE_ANIMSET[tall] = {anim = tall,   minimap = minimapicon, stump = anim == "stump"}
    else
        for name, overridebuild in pairs(MEADOWISLANDTREE_LEAVES_BUILD) do
            local tall = anim.."_tall"
        
            local minimapicon = "kyno_meadowisland_tree.tex"

            local tall_key = name.."_"..tall
            local overridedata = overridebuild ~= "nil" and { "swap_leaves", overridebuild, "swap_leaves" } or nil
    
            PIKOTREE_ANIMSET[tall_key] = {anim = tall,   minimap = minimapicon, overridesymbol = overridedata}
        end
    end
end

local function PikoTree_GetAnimFn(inst)
    return "sway1_loop_tall" and "sway1_loop_tall" or "sway2_loop_tall"
end

-- Sugarwood Trees were made in the dumbest and worst way possible by me LMAO.
local SUGARTREE_ANIMSET = 
{
	sway1_loop = { anim = "sway1_loop", hidesymbols = { "swap_tapper", "sap" } },
	sway2_loop = { anim = "sway2_loop", hidesymbols = { "swap_tapper", "sap" } },
	stump      = { anim = "stump",      hidesymbols = { "swap_tapper", "sap" } },
}

local function SugarTree_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")

    inst.AnimState:Hide("mouseover")
end

local SUGARTREE_TAPPED_ANIMSET =
{
	sway1_loop = { anim = "sway1_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow" } },
	sway2_loop = { anim = "sway2_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow" } },
	picked     = { anim = "sway1_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty" }, hidesymbols = { "sap" } },
	empty      = { anim = "sway2_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty" }, hidesymbols = { "sap" } },
	stump      = { anim = "stump", hidesymbols = {"swap_tapper", "sap" } },
}

local function SugarTreeTapped_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:AddOverrideBuild("quagmire_sapbucket")

    inst.AnimState:Hide("mouseover")
end

local SUGARTREE_RUINED_ANIMSET =
{
	sway1_loop = { anim = "sway1_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled" }, hidesymbols = { "sap" } },
	sway2_loop = { anim = "sway2_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled" }, hidesymbols = { "sap" } },
	picked     = { anim = "sway1_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty" }, hidesymbols = { "sap" } },
	empty      = { anim = "sway2_loop", overridesymbol = { "swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty" }, hidesymbols = { "sap" } },
	stump      = { anim = "stump", hidesymbols = {"swap_tapper", "sap" } },
}

local function SugarTreeRuined_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:AddOverrideBuild("quagmire_sapbucket")
	
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")

    inst.AnimState:Hide("mouseover")
end

local SUGARTREE_RUINED2_ANIMSET = 
{
	sway1_loop = { anim = "sway1_loop", hidesymbols = { "swap_tapper", "sap" } },
	sway2_loop = { anim = "sway2_loop", hidesymbols = { "swap_tapper", "sap" } },
	stump      = { anim = "stump",      hidesymbols = { "swap_tapper", "sap" } },
}

local function SugarTreeRuined2_CommonPostInit(inst)
    Tree_Minimap_CommonPostInit(inst)
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")

    inst.AnimState:Hide("mouseover")
end

local SUGARTREE_BURNT_ANIMSET =
{
	burnt = { anim = "burnt" },
}

local function SugarTreeBurnt_CommonPostInit(inst)
	Tree_Minimap_CommonPostInit(inst)
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:Hide("mouseover")
end

local function SugarTree_GetAnimFn(inst) 
    if inst:HasTag("stump") then
        return "stump"
    end
	
	if inst:HasTag("burnt") then
		return "burnt"
	end
	
	if inst.sapped == false or nil then
        return "picked" and "picked" or "empty"
    end
	
    return "sway1_loop" and "sway1_loop" or "sway2_loop"
end

local function MushStump_CommonPostInit(inst)
	local s = .8
	inst.AnimState:SetScale(s, s, s)
end

local function CreateWaxedMushStump(name)
    return WAXED_PLANTS.CreateWaxedPlant(
	{
        prefab          = name,
        bank            = "kyno_mushroomstump",
        build           = "kyno_mushroomstump",
        anim            = "idle",
		minimapicon2    = "kyno_mushroomstump",
        action          = "DIG",
		physics         = {MakeObstaclePhysics, .5},
        animset         = SPOTBUSH_ANIMSET,
        getanim_fn      = SpotBush_GetAnimFn,
		common_postinit = MushStump_CommonPostInit,
        assets          = ASSETS,
    })
end

local ret = 
{	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_coffeebush",
		bank            = "coffeebush",
		build           = "coffeebush",
		anim            = "idle",
		minimapicon2    = "kyno_coffeebush",
		action          = "DIG",
		physics         = {MakeObstaclePhysics, .1},
		animset         = COFFEEBUSH_ANIMSET,
		getanim_fn      = CoffeeBush_GetAnimFn,
		assets          = ASSETS,
		deployspacing   = DEPLOYSPACING.MEDIUM,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant(
	{
		prefab        = "kyno_spotbush",
		bank          = "quagmire_spiceshrub",
		build         = "quagmire_spiceshrub",
		anim          = "idle",
		minimapicon   = "quagmire_spotspice_shrub", -- Using original .png icon.
		action        = "DIG",
		physics       = {MakeSmallObstaclePhysics, .1},
		animset       = SPOTBUSH_ANIMSET,
		getanim_fn    = SpotBush_GetAnimFn,
		assets        = ASSETS,
		deployspacing = DEPLOYSPACING.MEDIUM,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant(
	{
		prefab        = "kyno_wildwheat",
		bank          = "kyno_wheat",
		build         = "kyno_wheat",
		anim          = "idle",
		minimapicon2  = "kyno_wildwheat",
		action        = "DIG",
		animset       = WHEAT_ANIMSET,
		getanim_fn    = Plantable_GetAnimFn,
		multcolor     = Grass_MultColorFn,
		assets        = ASSETS,
		deployspacing = DEPLOYSPACING.MEDIUM,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant({
        prefab          = "kyno_meadowisland_tree",
        bank            = "tree_leaf",
		build           = "teatree_build",
        anim            = "sway1_loop_tall",
        action          = "CHOP",
        physics         = {MakeObstaclePhysics, .25},
        animset         = MEADOWISLANDTREE_ANIMSET,
        getanim_fn      = MeadowIslandTree_GetAnimFn,
        common_postinit = MeadowIslandTree_CommonPostInit,
        multcolor       = Tree_MultColorFn,
        assets          = ASSETS,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant({
        prefab          = "kyno_meadowisland_pikotree",
        bank            = "tree_leaf",
		build           = "teatree_build",
        anim            = "sway1_loop_tall",
        action          = "CHOP",
        physics         = {MakeObstaclePhysics, .25},
        animset         = PIKOTREE_ANIMSET,
        getanim_fn      = PikoTree_GetAnimFn,
        common_postinit = MeadowIslandTree_CommonPostInit,
        multcolor       = PikoTree_MultColorFn,
        assets          = ASSETS,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant({
        prefab          = "kyno_kokonuttree",
        bank            = "kokonuttree",
		build           = "kokonuttree_build",
        anim            = "sway1_loop_tall",
        action          = "CHOP",
        physics         = {MakeObstaclePhysics, .25},
        animset         = KOKONUTTREE_ANIMSET,
        getanim_fn      = KokonutTree_GetAnimFn,
        common_postinit = Tree_CommonPostInit,
        multcolor       = Tree_MultColorFn,
        assets          = ASSETS,
    }),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_short",
		bank            = "quagmire_tree_cotton_short",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_normal",
		bank            = "quagmire_tree_cotton_normal",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_short_stump",
		bank            = "quagmire_tree_cotton_short",
		build           = "quagmire_tree_cotton_build",
		anim            = "stump",
		minimapicon2    = "kyno_sugartree_stump",
		action          = "DIG",
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_normal_stump",
		bank            = "quagmire_tree_cotton_normal",
		build           = "quagmire_tree_cotton_build",
		anim            = "stump",
		minimapicon2    = "kyno_sugartree_stump",
		action          = "DIG",
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_stump",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "stump",
		minimapicon2    = "kyno_sugartree_stump",
		action          = "DIG",
		animset         = SUGARTREE_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTree_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_stump_ruined",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "stump",
		minimapicon2    = "kyno_sugartree_stump_ruined",
		action          = "DIG",
		animset         = SUGARTREE_RUINED2_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeRuined2_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_short_burnt",
		bank            = "quagmire_tree_cotton_short",
		build           = "quagmire_tree_cotton_trunk_build",
		anim            = "burnt",
		minimapicon2    = "kyno_sugartree_burnt",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_BURNT_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeBurnt_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_normal_burnt",
		bank            = "quagmire_tree_cotton_normal",
		build           = "quagmire_tree_cotton_trunk_build",
		anim            = "burnt",
		minimapicon2    = "kyno_sugartree_burnt",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_BURNT_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeBurnt_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_burnt",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_trunk_build",
		anim            = "burnt",
		minimapicon2    = "kyno_sugartree_burnt",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_BURNT_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeBurnt_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_sapped",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree_tapped",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_TAPPED_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeTapped_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_ruined",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree_tapped_ruined",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_RUINED_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeRuined_CommonPostInit,
		assets          = ASSETS,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab          = "kyno_sugartree_ruined2",
		bank            = "quagmire_tree_cotton_tall",
		build           = "quagmire_tree_cotton_build",
		anim            = "sway1_loop",
		minimapicon2    = "kyno_sugartree_ruined",
		action          = "CHOP",
		physics         = {MakeObstaclePhysics, .25},
		animset         = SUGARTREE_RUINED2_ANIMSET,
		getanim_fn      = SugarTree_GetAnimFn,
		common_postinit = SugarTreeRuined2_CommonPostInit,
		assets          = ASSETS,
	}),
	
	-- OMG YOU'RE SO STUPID WHY DO WE HAVE 3 OF THE SAME PREFAB??
	CreateWaxedMushStump("kyno_mushstump"),
	CreateWaxedMushStump("kyno_mushstump_natural"),
	CreateWaxedMushStump("kyno_mushstump_cave"),
	
	CreateWaxedTreeSapling("kyno_kokonuttree_sapling", "kyno_kokonut", "planted"),
	CreateWaxedTreeSapling("kyno_meadowisland_tree_sapling", "kyno_meadowisland_tree_sapling", "planted"),
	CreateWaxedTreeSapling("kyno_sugartree_sapling", "kyno_serenityisland_sapling", "planted"),
}

return unpack(ret)