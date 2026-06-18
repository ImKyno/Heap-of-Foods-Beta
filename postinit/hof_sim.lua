local _G               = GLOBAL
local require          = _G.require
local WORLD_TILES      = _G.WORLD_TILES

local ancienttree_defs = require("prefabs/ancienttree_defs")
local TREE_DEFS        = ancienttree_defs.TREE_DEFS

-- Spawns Mist in static layouts, not using game's function because its too dense.
local function WorldSimPostInit()
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

	-- Apply our Special Events.
	if TUNING.HOF_SPECIAL_EVENTS_BIRTHDAY == true then
		_G.ApplyExtraEvent(_G.SPECIAL_EVENTS.HOFBIRTHDAY)
	end
end

-- HAHAHAHA YOU CAN'T EDIT SKILLTREE STRINGS WITH REGULAR METHODS 💀💀
local function SkillTreeSimPostInit()
	local defs = require("prefabs/skilltree_defs")
	local wormwood_defs = defs.SKILLTREE_DEFS and defs.SKILLTREE_DEFS["wormwood"]

	if wormwood_defs and wormwood_defs["wormwood_mushroomplanter_ratebonus2"] then
		wormwood_defs["wormwood_mushroomplanter_ratebonus2"].desc = _G.STRINGS.SKILLTREE_WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2_DESC
		or "ERROR: MISSING SKILL DESCRIPTION FOR WORMWOOD_MUSHROOMPLANTER_RATEBONUS2"
	else
		print("Heap of Foods Mod - Wormwood's Skill 'wormwood_mushroomplanter_ratebonus2' not found.")
	end
end

-- Leonidas remember me to not put LootTables inside postinit again, otherwise it will 
-- increase the drop by +1 each time the entity spawns.
local function LootTableSimPostInit()
	if _G.LootTables and _G.LootTables.lordfruitfly then
		table.insert(_G.LootTables.lordfruitfly, {"kyno_garden_sprinkler_blueprint", 1.00})
	end

	if _G.LootTables and _G.LootTables.alterguardian_phase4_lunarrift then
		table.insert(_G.LootTables.alterguardian_phase4_lunarrift, {"kyno_goldenapple", 1.00})
	end
end

-- Ancient Trees can grow on these turfs too.
local function AncientTreeSimPostInit()
	if WORLD_TILES.HOF_TIDALMARSH ~= nil then
		TREE_DEFS.nightvision.GROW_CONSTRAINT.TILE[WORLD_TILES.HOF_TIDALMARSH] = true
	end

	if WORLD_TILES.QUAGMIRE_CITYSTONE ~= nil then
		TREE_DEFS.gem.GROW_CONSTRAINT.TILE[WORLD_TILES.QUAGMIRE_CITYSTONE] = true
	end
end

AddSimPostInit(WorldSimPostInit)
AddSimPostInit(SkillTreeSimPostInit)
AddSimPostInit(LootTableSimPostInit)
AddSimPostInit(AncientTreeSimPostInit)