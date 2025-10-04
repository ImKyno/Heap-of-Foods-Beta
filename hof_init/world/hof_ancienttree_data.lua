local _G               = GLOBAL
local require          = _G.require
local ancienttree_defs = require("prefabs/ancienttree_defs")
local TREE_DEFS        = ancienttree_defs.TREE_DEFS
local WORLD_TILES      = _G.WORLD_TILES

AddSimPostInit(function()
	TREE_DEFS.nightvision.GROW_CONSTRAINT.TILE[WORLD_TILES.HOF_TIDALMARSH] = true
	TREE_DEFS.gem.GROW_CONSTRAINT.TILE[WORLD_TILES.QUAGMIRE_CITYSTONE] = true
end)