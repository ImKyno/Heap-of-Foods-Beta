-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local WORLD_TILES     = _G.WORLD_TILES

local SERENITY_CC     = GetModConfigData("SERENITY_CC") or false
local MEADOW_CC       = GetModConfigData("MEADOW_CC") or false

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
			night     = nil, --resolvefilepath("images/colourcubesimages/serenity_cc.tex"), -- Too dark!
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
			night     = nil, --resolvefilepath("images/colourcubesimages/meadow_night_cc.tex"), -- Too dark!
		},
	},
}

local function ApplyIslandColourCube(self, island)
	if not island or not island.colourcubes then
		return
	end

	local phase = _G.TheWorld.state.phase
	local colourcubes = island.colourcubes[phase] or island.colourcubes.day

	if colourcubes then
		_G.TheWorld:PushEvent("overridecolourcube", colourcubes)
	else
		print("Heap of Foods  Warning - ColourCubes nil for island:", island.name, "Clock Phase:", phase)
	end
end

local function RemoveIslandEffects()
	_G.TheWorld:PushEvent("overridecolourcube", nil)
end

local function IsValidTile(tile)
	return tile 
	and tile ~= WORLD_TILES.OCEAN_BRINEPOOL
	and tile ~= WORLD_TILES.OCEAN_SWELL
	and tile ~= WORLD_TILES.OCEAN_ROUGH
	and tile ~= WORLD_TILES.OCEAN_HAZARDOUS
	and tile ~= WORLD_TILES.OCEAN_WATERLOG
end

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
				if island.config_key == true then
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