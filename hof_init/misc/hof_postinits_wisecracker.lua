-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

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

AddComponentPostInit("wisecracker", function(self)
	self.inst:ListenForEvent("firepitinstallfail", FirepitInstallFail)
	self.inst:ListenForEvent("cookwareinstallfail", CookwareInstallFail)
	self.inst:ListenForEvent("pothangerinstallfail", PotHangerInstallFail)
	self.inst:ListenForEvent("casseroleinstallfail", CasseroleInstallFail)
	self.inst:ListenForEvent("treeinstallfail", TreeInstallFail)
	self.inst:ListenForEvent("serenityislandshopfail", SerenityIslandShopFail)
	self.inst:ListenForEvent("saphealerused", SapHealerUsed)
	self.inst:ListenForEvent("slaughtertoolsused", SlaughterToolsUsed)
	self.inst:ListenForEvent("rummagewagonempty", RummageWagonEmpty)
	self.inst:ListenForEvent("drankcanneddrink", DrankCannedDrink)
	self.inst:ListenForEvent("oceanhuntlosttrail", OceanHuntLostTrail)
	self.inst:ListenForEvent("oceanhuntbeastnearby", OceanHuntBeastNearby)
	self.inst:ListenForEvent("hofbirthdaycakecomplete", BirthdayCakeComplete)
	self.inst:ListenForEvent("fishregistryresearchfish", FishRegistryFishResearched)
	self.inst:ListenForEvent("fishregistryresearchroe", FishRegistryRoeResearched)
end)