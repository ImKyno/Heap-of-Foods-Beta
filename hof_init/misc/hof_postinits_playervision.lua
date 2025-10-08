local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local WORLD_TILES     = _G.WORLD_TILES

local SERENITY_CC     = GetModConfigData("SERENITY_CC") or 0
local MEADOW_CC       = GetModConfigData("MEADOW_CC") or 0

local ISLANDS         = 
{
	{
		name          = "SerenityIsland",
		prefabs       = { "serenity_cc_marker" },
		radius        = 30,
		ignore_ocean  = true,
		config_key    = SERENITY_CC,
		
		colourcubes   = 
		{
			day       = resolvefilepath("images/colourcubesimages/serenity_cc.tex"),
			dusk      = resolvefilepath("images/colourcubesimages/serenity_cc.tex"),
			night     = nil, -- Too dark!
		},
	},
	{
		name          = "MeadowIsland",
		prefabs       = { "meadow_cc_marker" },
		radius        = 40,
		ignore_ocean  = true,
		config_key    = MEADOW_CC,
		
		colourcubes   = 
		{
			day       = resolvefilepath("images/colourcubesimages/meadow_day_cc.tex"),
			dusk      = resolvefilepath("images/colourcubesimages/meadow_dusk_cc.tex"),
			night     = nil,
		},
	},
}

local function ApplyIslandColourCube(self, island)
	if not island or not island.colourcubes then 
		return 
	end

	local phase = _G.TheWorld.state.phase
	local cc = island.colourcubes[phase] or island.colourcubes.day

	if cc then
		_G.TheWorld:PushEvent("overridecolourcube", cc)
	else
		if TUNING.HOF_DEBUG_MODE then
			print("Heap of Foods Mod - Warning! ColourCube is nil for Island:", island.name, "World Phase:", phase)
		end
	end
end

local function RemoveIslandEffects()
	_G.TheWorld:PushEvent("overridecolourcube", nil)
end

local function IsValidTile(tile)
	return tile
	and tile ~= WORLD_TILES.OCEAN_SWELL
	and tile ~= WORLD_TILES.OCEAN_ROUGH
	and tile ~= WORLD_TILES.OCEAN_HAZARDOUS
	and tile ~= WORLD_TILES.OCEAN_WATERLOG
end

-- Marker Mode.
if SERENITY_CC == 1 or MEADOW_CC == 1 then
	AddComponentPostInit("playervision", function(self)
		self.inst:DoTaskInTime(0.5, function()
			local current_island = nil
			local watchers = {}

			local function StopWatching()
				for k, fn in pairs(watchers) do
					self.inst:StopWatchingWorldState(k, fn)
				end
				
				watchers = {}
				current_island = nil
				RemoveIslandEffects()
			end

			local function StartWatching(island)
				StopWatching()
				current_island = island

				local function Update()
					ApplyIslandColourCube(self, current_island)
				end

				watchers.isday = function(_, v) if v then Update() end end
				watchers.isdusk = function(_, v) if v then Update() end end
				watchers.isnight = function(_, v) if v then Update() end end

				self.inst:WatchWorldState("isday", watchers.isday)
				self.inst:WatchWorldState("isdusk", watchers.isdusk)
				self.inst:WatchWorldState("isnight", watchers.isnight)

				Update()
			end

			local function CheckIslands()
				local x, _, z = self.inst.Transform:GetWorldPosition()
				local found_island = nil

				for _, island in ipairs(ISLANDS) do
					if island.config_key == 1 then
						local ents = _G.TheSim:FindEntities(x, 0, z, island.radius, island.prefabs)
						
						if #ents > 0 then
							if island.ignore_ocean then
								local tile = _G.TheWorld.Map:GetTileAtPoint(x, 0, z)
								
								if IsValidTile(tile) then
									found_island = island
									break
								end
							else
								found_island = island
								break
							end
						end
					end
				end

				if found_island and current_island ~= found_island then
					StartWatching(found_island)
				elseif not found_island and current_island then
					StopWatching()
				end
			end

			self.inst:DoPeriodicTask(0.5, CheckIslands)
			CheckIslands()
		end)
	end)
end

-- Static Mode.
if SERENITY_CC == 2 or MEADOW_CC == 2 then
	AddComponentPostInit("playervision", function(self)
		self.inst:DoTaskInTime(0, function()
			self.canchange = true

			local current_island = nil
			local watchers = {}

			local function RemoveWatchers()
				for k, fn in pairs(watchers) do
					self.inst:StopWatchingWorldState(k, fn)
				end
				
				watchers = {}
			end

			local function ApplyColourCubeForPhase(island)
				if not island or not island.colourcubes then 
					return 
				end
				
				local phase = _G.TheWorld.state.phase
				local cc = island.colourcubes[phase] or island.colourcubes.day
                
				if cc then
					_G.TheWorld:PushEvent("overridecolourcube", cc)
				else
					_G.TheWorld:PushEvent("overridecolourcube", nil)
				end
			end

			local function StartWatching(island)
				RemoveWatchers()
				current_island = island

				local function Update()
					ApplyColourCubeForPhase(current_island)
				end

				watchers.isday = function(_, v) if v then Update() end end
				watchers.isdusk = function(_, v) if v then Update() end end
				watchers.isnight = function(_, v) if v then Update() end end

				self.inst:WatchWorldState("isday", watchers.isday)
				self.inst:WatchWorldState("isdusk", watchers.isdusk)
				self.inst:WatchWorldState("isnight", watchers.isnight)

				Update()
			end

			local function StopWatching()
				RemoveWatchers()
				current_island = nil
				
				_G.TheWorld:PushEvent("overridecolourcube", nil)
            end

			self.inst:ListenForEvent("changearea", function(inst, area)
				if not self.canchange then 
					return 
				end

				if area and area.tags then
					if SERENITY_CC == 2 and table.contains(area.tags, "SerenityArea") then
						StartWatching(ISLANDS[1]) -- SerenityIsland
					elseif MEADOW_CC == 2 and table.contains(area.tags, "MeadowArea") then
						StartWatching(ISLANDS[2]) -- MeadowIsland
					else
						StopWatching()
					end
				else
					StopWatching()
				end
			end)

			self.inst:DoTaskInTime(1, function()
				local node, node_index = _G.TheWorld.Map:FindVisualNodeAtPoint(self.inst.Transform:GetWorldPosition())
                
				if node_index then
					self.inst:PushEvent("changearea", node and {
						id     = _G.TheWorld.topology.ids[node_index],
						type   = node.type,
						center = node.cent,
						poly   = node.poly,
						tags   = node.tags,
					} or nil)
				end
			end)
		end)
	end)
end