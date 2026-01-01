--[[-----------------------------------------------------------------------------------------------------------------

	[ Fish Registry Public Mod API ] 
	[ This file is meant to be required by other Mods ]
	
	* Import the Fish Registry API 
		require("hof_fishregistryapi")

	* Add custom Fish 
		FishRegistryAddFish({
			name         = "cool_fish",

			bank         = "cool_fish_bank",
			build        = "cool_fish_build",
			anim         = "cool_fish_idle",

			phases       = { "day, dusk", "night" },
			moonphases   = { "new", "quarter", "half", "threequarter", "full" },
			seasons      = { "autumn", "winter", "spring", "summer" },
			worlds       = { "forest", "cave" }

			-- (OPTIONAL)
			scale        = 0.25, -- Recommended to be this or lower.
			xpos         = -5,   -- Recommended to be between -10-10.
			ypos         = 40,   -- Recommended to be between 30-60.
		})

	* Add custom Roe 
		FishRegistryAddRoe({
			name         = "cool_roe",

			atlas        = "images/cool_roe.xml",
			image        = "cool_roe.tex",

			roe_time     = 480 * 2,
			baby_time    = 480 * 4,
			
			-- (OPTIONAL)
			roe_string   = "My Roe String",       -- Both Roe and Baby time strings are calculated and set automatically.
			baby_string  = "My Offspring String", -- But you can override them using these.
		})

	* Add custom Phase, Moon Phase, Season and World 
		FishRegistryAddPhase("cool_phase", 
		{
			atlas        = "images/cool_phase.xml",
			image        = "cool_phase.tex",
		})

		FishRegistryAddMoonPhase("cool_moonphase", 
		{
			atlas        = "images/cool_moonphase.xml",
			image        = "cool_moonphase.tex",
		})

		FishRegistryAddSeason("cool_season", 
		{
			atlas        = "images/cool_season.xml",
			image        = "cool_season.tex",
		})

		FishRegistryAddWorld("cool_world", 
		{
			atlas        = "images/cool_world.xml",
			image        = "cool_world.tex",
		})
	
	* Make a Fish researchable and unlockable for the Fish Registry 

		local function GetFishKey(inst)
			return inst.prefab
		end

		local function fishresearchfn(inst)
			return inst:GetFishKey()
		end

		-- In the prefab constructor BEFORE the mastersim check
		inst:AddTag("fishresearchable")
		inst.GetFishKey = GetFishKey

		-- In the prefab constructor, AFTER the mastersim check
		inst:AddComponent("fishresearchable")
		inst.components.fishresearchable:SetResearchFn(fishresearchfn)
		
	* Make a Roe researchable and unlockable for the Fish Registry ]
	
		local function GetRoeKey(inst)
			return inst.prefab
		end

		local function roeresearchfn(inst)
			return inst:GetRoeKey()
		end

		-- In the prefab constructor BEFORE the mastersim check
		inst:AddTag("roeresearchable")
		inst.GetRoeKey = GetRoeKey

		-- In the prefab constructor, AFTER the mastersim check
		inst:AddComponent("roeresearchable")
		inst.components.roeresearchable:SetResearchFn(roeresearchfn)

	[ Final Considerations ]
	
		If you run into a problem, have any inquiries or just need help, please join our Discord and head to the dedicated channel
		exclusive to talk about the mod #hof-general. Otherwise you can also send me a private message on Discord, it
		might take a while for me to reply you, but I'll do as soon as I can.
	
		Discord Server Invite: https://discord.gg/jjNr4Vvutn
		My Discord: kynoox_

		Happy fishing!

--]]-------------------------------------------------------------------------------------------------------------------------------------------------

local FISHREGISTRY_FISH_DEFS  = require("prefabs/k_fishregistrydefs").FISHREGISTRY_FISH_DEFS
local FISH_SORT_ORDER         = require("prefabs/k_fishregistrydefs").FISH_SORT_ORDER

local FISHREGISTRY_ROE_DEFS   = require("prefabs/k_fishregistrydefs").FISHREGISTRY_ROE_DEFS
local ROE_SORT_ORDER          = require("prefabs/k_fishregistrydefs").ROE_SORT_ORDER

assert(FISHREGISTRY_FISH_DEFS, "Heap of Foods Mod - Fish Registry: Fish defs not loaded!")
assert(FISHREGISTRY_ROE_DEFS,  "Heap of Foods Mod - Fish Registry: Roe defs not loaded!")

global("FishRegistryAddFish")
function FishRegistryAddFish(def)
	assert(type(def) == "table", "Heap of Foods Mod - Fish Registry: AddFish expects a table.")
	assert(def.name, "Heap of Foods Mod - Fish Registry: Fish needs a NAME.")
	assert(def.bank and def.build and def.anim, "Heap of Foods Mod - Fish Registry: Fish needs BANK, BUILD and ANIM.")
	assert(def.phases and def.moonphases and def.seasons and def.worlds, "Heap of Foods Mod - Fish Registry: Fish needs PHASES, MOONPHASES, SEASONS and WORLDS.")

	if FISHREGISTRY_FISH_DEFS[def.name] then
		print("[FishRegistry] Fish already registered:", def.name)
		return
	end

	FISHREGISTRY_FISH_DEFS[def.name] = def
end

global("FishRegistryAddRoe")
function FishRegistryAddRoe(def)
	assert(type(def) == "table", "Heap of Foods Mod - Fish Registry: AddRoe expects a table.")
	assert(def.name, "Heap of Foods Mod - Fish Registry: Roe needs a NAME.")
	assert(def.atlas and def.image, "Heap of Foods Mod - Fish Registry: Roe needs ATLAS and IMAGE.")
	assert(def.roe_time and def.baby_time, "Heap of Foods Mod - Fish Registry: Roe needs ROE_TIME and BABY_TIME.")

	if FISHREGISTRY_ROE_DEFS[def.name] then
		print("Heap of Foods Mod - Fish Registry: Roe already registered:", def.name)
		return
	end

	def.roe_time_string  = FishRegistryGetRoeTimeString(def.roe_time)
	def.baby_time_string = FishRegistryGetBabyTimeString(def.baby_time)

	FISHREGISTRY_ROE_DEFS[def.name] = def
end

local function AddUnique(list, value)
	for _, v in ipairs(list) do
		if v == value then
			return
		end
	end
	table.insert(list, value)
end

global("FishRegistryAddPhase")
function FishRegistryAddPhase(id, icon)
	assert(type(id) == "string", "Heap of Foods Mod - Fish Registry: ID must be a string.")
	assert(type(icon) == "table", "Heap of Foods Mod - Fish Registry: ICON must be a table.")
	assert(icon.atlas and icon.image, "Heap of Foods Mod - Fish Registry: ICON needs ATLAS and IMAGE.")
	
	AddUnique(TUNING.FISHREGISTRY_PHASE_IDS, id)
	TUNING.FISHREGISTRY_PHASE_ICONS[id] = icon
end

global("FishRegistryAddMoonPhase")
function FishRegistryAddMoonPhase(id, icon)
	assert(type(id) == "string", "Heap of Foods Mod - Fish Registry: ID must be a string.")
	assert(type(icon) == "table", "Heap of Foods Mod - Fish Registry: ICON must be a table.")
	assert(icon.atlas and icon.image, "Heap of Foods Mod - Fish Registry: ICON needs ATLAS and IMAGE.")
	
	AddUnique(TUNING.FISHREGISTRY_MOONPHASE_IDS, id)
	TUNING.FISHREGISTRY_MOONPHASE_ICONS[id] = icon
end

global("FishRegistryAddSeason")
function FishRegistryAddSeason(id, icon)
	assert(type(id) == "string", "Heap of Foods Mod - Fish Registry: ID must be a string.")
	assert(type(icon) == "table", "Heap of Foods Mod - Fish Registry: ICON must be a table.")
	assert(icon.atlas and icon.image, "Heap of Foods Mod - Fish Registry: ICON needs ATLAS and IMAGE.")
	
	AddUnique(TUNING.FISHREGISTRY_SEASON_IDS, id)
	TUNING.FISHREGISTRY_SEASON_ICONS[id] = icon
end

global("FishRegistryAddWorld")
function FishRegistryAddWorld(id, icon)
	assert(type(id) == "string", "Heap of Foods Mod - Fish Registry: ID must be a string.")
	assert(type(icon) == "table", "Heap of Foods Mod - Fish Registry: ICON must be a table.")
	assert(icon.atlas and icon.image, "Heap of Foods Mod - Fish Registry: ICON needs ATLAS and IMAGE.")

	AddUnique(TUNING.FISHREGISTRY_WORLD_IDS, id)
	TUNING.FISHREGISTRY_WORLD_ICONS[id] = icon
end