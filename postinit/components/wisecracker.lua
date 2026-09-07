local _G      = GLOBAL
local STRINGS = _G.STRINGS

local function FirepitInstallFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_FIREPITINSTALL_FAIL"))
	end
end

local function CookwareInstallFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_COOKWAREINSTALLER_FAIL"))
	end
end

local function PotHangerInstallFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_POTHANGER_FAIL"))
	end
end

local function CasseroleInstallFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_FIREPITINSTALL_FAIL"))
	end
end

local function TreeInstallFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_TREE_TOOSMALL_FAIL"))
	end
end

local function SerenityIslandShopFail(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_SERENITYISLAND_SHOP_FAIL"))
	end
end

local function SapHealerUsed(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_SAPHEALER_USED"))
	end
end

local function SlaughterToolsUsed(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_SLAUGHTERTOOLS_USED"))
	end
end

local function RummageWagonEmpty(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_RUMMAGE_WAGON_EMPTY"))
	end
end

local function DrankCannedDrink(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
end

local function OceanHuntLostTrail(inst, data)
	if inst.components.talker ~= nil then
		if data.washedaway then
			inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_LOST_TRAIL_RAIN"))
		else
			inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_LOST_TRAIL"))
		end
	end
end

local function OceanHuntBeastNearby(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HUNT_BEAST_NEARBY"))
	end
end

local function BirthdayCakeComplete(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_HOFBIRTHDAY_CAKECOMPLETE"))
	end
end

local function FishRegistryFishResearched(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_FISH_RESEARCHED"))
	end
end

local function FishRegistryRoeResearched(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_ROE_RESEARCHED"))
	end
end

local function DailyRecipeEaten(inst, data)
	if inst.components.talker ~= nil then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_DAILYRECIPE_EATEN"))
	end
end

local function ScannedByWX78(inst, data)
	if inst.components.talker ~= nil then
		inst:DoTaskInTime(3.5, function()
			inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_SCANNED_BY_WX78"))
		end)
	end
end

local function WX78StartRain(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_MOISTURE_IMMUNE"))
	end
end

local function WX78BrewerStart(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_BREWER_START"))
	end
end

local function WX78BrewerPause(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_BREWER_PAUSE"))
	end
end

local function WX78BrewerResume(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_BREWER_RESUME"))
	end
end

local function WX78BrewerCancel(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_BREWER_CANCEL"))
	end
end

local function WX78BrewerDone(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		inst.components.talker:Say(_G.GetString(inst, "ANNOUNCE_KYNO_WX78_BREWER_DONE"))
	end
end

local function WX78ScanCharacter(inst, data)
	if inst.components.talker ~= nil and inst.prefab == "wx78" then
		local target = data ~= nil and data.target or nil

		if target ~= nil then
			local character_name = STRINGS.CHARACTERS[target.prefab] ~= nil
			and STRINGS.CHARACTERS[target.prefab].NAME or target.prefab

			character_name = string.upper(character_name)

			inst:DoTaskInTime(1, function()
				inst.components.talker:Say(string.format(_G.GetString(inst, "ANNOUNCE_KYNO_SCANNING_CHARACTER"), character_name))
			end)
		end
	end
end

AddComponentPostInit("wisecracker", function(self)
	self.inst:ListenForEvent("firepitinstallfail",       FirepitInstallFail)
	self.inst:ListenForEvent("cookwareinstallfail",      CookwareInstallFail)
	self.inst:ListenForEvent("pothangerinstallfail",     PotHangerInstallFail)
	self.inst:ListenForEvent("casseroleinstallfail",     CasseroleInstallFail)
	self.inst:ListenForEvent("treeinstallfail",          TreeInstallFail)
	self.inst:ListenForEvent("serenityislandshopfail",   SerenityIslandShopFail)
	self.inst:ListenForEvent("saphealerused",            SapHealerUsed)
	self.inst:ListenForEvent("slaughtertoolsused",       SlaughterToolsUsed)
	self.inst:ListenForEvent("rummagewagonempty",        RummageWagonEmpty)
	self.inst:ListenForEvent("drankcanneddrink",         DrankCannedDrink)
	self.inst:ListenForEvent("oceanhuntlosttrail",       OceanHuntLostTrail)
	self.inst:ListenForEvent("oceanhuntbeastnearby",     OceanHuntBeastNearby)
	self.inst:ListenForEvent("hofbirthdaycakecomplete",  BirthdayCakeComplete)
	self.inst:ListenForEvent("fishregistryresearchfish", FishRegistryFishResearched)
	self.inst:ListenForEvent("fishregistryresearchroe",  FishRegistryRoeResearched)
	self.inst:ListenForEvent("dailyrecipeeaten",         DailyRecipeEaten)
	self.inst:ListenForEvent("scannedbywx78",            ScannedByWX78)
	self.inst:ListenForEvent("wx78startrain",            WX78StartRain)
	self.inst:ListenForEvent("wx78brewer_start",         WX78BrewerStart)
	self.inst:ListenForEvent("wx78brewer_pause",         WX78BrewerPause)
	self.inst:ListenForEvent("wx78brewer_resume",        WX78BrewerResume)
	self.inst:ListenForEvent("wx78brewer_cancel",        WX78BrewerCancel)
	self.inst:ListenForEvent("wx78brewer_done",          WX78BrewerDone)
	self.inst:ListenForEvent("wx78scan_character",       WX78ScanCharacter)
end)