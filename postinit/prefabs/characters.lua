local _G               = GLOBAL
local require          = _G.require
local WortoxSoulCommon = require("prefabs/wortox_soul_common")

local HOF_HUMANMEAT = GetModConfigData("HUMANMEAT")
local HOF_ALCOHOLICDRINKS = GetModConfigData("ALCOHOLICDRINKS")

local function WilsonPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_steak_frites", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("wine_dragonfruit", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WillowPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("feijoada",       TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_pepper", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WolfgangPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_potato_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_potato",    TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WendyPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("icedtea",   TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_fig", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WX78PostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("bowlofgears", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WickerbottomPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("tea",      TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teagreen", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WoodiePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_sliders", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("beer",          TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WaxwellPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_crab_roll", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("caviar",          TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WesPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("sharkfinsoup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("tartarsauce",  TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WathgrithrPostInit(inst)
	inst:AddTag("animal_butcher")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_pot_roast", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mead",            TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WebberPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("cottoncandy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise",  TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WinonaPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("coffee",  TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("paleale", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WortoxPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("pomegranatepie",    TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_pomegranate", TUNING.AFFINITY_15_CALORIES_HUGE)
	end

	if inst.components.eater ~= nil then
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.PREPAREDSOUL, FOODGROUP.OMNI })
	end

	inst:ListenForEvent("murdered", function(inst, data)
		if inst:HasTag("soulharvester") then
			WortoxSoulCommon.GiveSouls(inst, data.stackmult or 1, inst:GetPosition())
		end
	end)
end

local function WormwoodPostInit(inst)
	inst:AddTag("PREPAREDPOOP_eater")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gummy_cake",    TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_kokonut", TUNING.AFFINITY_15_CALORIES_HUGE)
	end

	if inst.components.eater ~= nil then
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI, FOODTYPE.PREPAREDPOOP })
	end
end

local function WarlyPostInit(inst)
	if TUNING.HOF_WARLYSPICES then
		if TUNING.HOF_DEBUG_MODE then
			print("Heap of Foods Mod - Added spicemaker tag to Warly.")
		end

		inst:AddTag("spicemaker")
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.eater ~= nil then
		inst.components.eater:SetPrefersEatingTag("warly_caneat") -- New tag that allows Warly to eat stuff.
	end
end

local function WurtPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		-- Wurt had too many favorite foods. This is to keep her in line with others.
		-- These will now only negate the negative stats...
		inst.components.foodaffinity:AddPrefabAffinity("duriansplit",   1.33)
		inst.components.foodaffinity:AddPrefabAffinity("duriansoup",    1.33)
		inst.components.foodaffinity:AddPrefabAffinity("wine_durian",   1.33)

		inst.components.foodaffinity:AddPrefabAffinity("durianchicken", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_durian",  TUNING.AFFINITY_15_CALORIES_HUGE)
	end

	if inst.components.locomotor ~= nil then
		inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.HOF_TIDALMARSH, true)
	end
end

local function WalterPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("smores",             TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise_chicken", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WandaPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_candy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("nukacola",    TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

local function WonkeyPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("kyno_banana",       TUNING.AFFINITY_15_CALORIES_SMALL)

		inst.components.foodaffinity:AddPrefabAffinity("banana_pudding",    TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_banana",      TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_cave_banana", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end

AddPrefabPostInit("wilson",       WilsonPostInit)
AddPrefabPostInit("willow",       WillowPostInit)
AddPrefabPostInit("wolfgang",     WolfgangPostInit)
AddPrefabPostInit("wendy",        WendyPostInit)
AddPrefabPostInit("wx78",         WX78PostInit)
AddPrefabPostInit("wickerbottom", WickerbottomPostInit)
AddPrefabPostInit("woodie",       WoodiePostInit)
AddPrefabPostInit("waxwell",      WaxwellPostInit)
AddPrefabPostInit("wes",          WesPostInit)
AddPrefabPostInit("wathgrithr",   WathgrithrPostInit)
AddPrefabPostInit("webber",       WebberPostInit)
AddPrefabPostInit("winona",       WinonaPostInit)
AddPrefabPostInit("wortox",       WortoxPostInit)
AddPrefabPostInit("wormwood",     WormwoodPostInit)
AddPrefabPostInit("warly",        WarlyPostInit)
AddPrefabPostInit("wurt",         WurtPostInit)
AddPrefabPostInit("walter",       WalterPostInit)
AddPrefabPostInit("wanda",        WandaPostInit)
AddPrefabPostInit("wonkey",       WonkeyPostInit)

-- Players Have a Chance to Drop Long Pig. Except WX-78, Webber, Wurt, Wortox and Wormwood.
if HOF_HUMANMEAT then
	local HUMAN_CHARACTERS =
	{
		"wilson",
		"willow",
		"wolfgang",
		"wendy",
		"wickerbottom",
		"woodie",
		"waxwell",
		"wes",
		"wathgrithr",
		"winona",
		"warly",
		"walter",
		"wanda",
	}

	local function HumanMeatPostInit(inst)
		local function OnDeathHumanMeat(inst)
			if math.random() < TUNING.KYNO_HUMANMEAT_PLAYER_DROP_CHANCE then
				local x, y, z = inst.Transform:GetWorldPosition()
				local humanmeat = _G.SpawnPrefab("kyno_humanmeat")

				if humanmeat ~= nil then
					if humanmeat.Physics ~= nil then
						local speed = 1 + math.random()
						local angle = math.random() * 1 * PI

						humanmeat.Physics:Teleport(x, y + 1, z)
						humanmeat.Physics:SetVel(speed * math.cos(angle), speed * 0.5, speed * math.sin(angle))
					else
						humanmeat.Transform:SetPosition(x, y, z)
					end
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:ListenForEvent("death", OnDeathHumanMeat)
	end

	for k, v in pairs(HUMAN_CHARACTERS) do
		AddPrefabPostInit(v, HumanMeatPostInit)
	end
end

-- This will prevent some characters from drinking Alcoholic-like drinks.
if HOF_ALCOHOLICDRINKS then
	local RESTRICTED_CHARACTERS =
	{
		"wendy",
		"webber",
		"wurt",
		"walter",
		"wilba", -- What? Yeah, modded characters be like.
	}

	local function AlcoholicDrinkerPostInit(inst)
		inst:AddTag("no_alcoholic_drinker")
	end

	for k, v in pairs(RESTRICTED_CHARACTERS) do
		AddPrefabPostInit(v, AlcoholicDrinkerPostInit)
	end
end