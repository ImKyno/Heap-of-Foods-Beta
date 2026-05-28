local _G = GLOBAL

-- Sound listeners for clients.
local function PlayerClassifiedPostInit(inst)
	local function OnLearnRecipeCardEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		end
	end

	local function OnSaltFoodEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/common/cooking/salt_shake")
		end
	end

	local function OnPlayNukashineEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:KillSound("open_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("drink_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("nukashine_jukebox")

			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open", "open_nukashine")
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink", "drink_nukashine")
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/music/jukebox", "nukashine_jukebox")
		end
	end

	local function OnStopNukashineEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:KillSound("open_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("drink_nukashine")
			TheFocalPoint.SoundEmitter:KillSound("nukashine_jukebox")
		end
	end

	local function OnPirateRumEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh", "piraterum", 0.5)
		end
	end

	local function OnBottleCapEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink")
		end
	end

	local function OnPlayGoldenAppleEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/music/gorge_win", "goldenapple", 0.5)
		end
	end

	local function OnStopGoldenAppleEvent(inst)
		if inst._parent ~= nil and TheFocalPoint.entity:GetParent() == inst._parent then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/quagmire/transform/music/2")
		end
	end

	local function OnLearnRecipeCard(parent)
		parent.player_classified.learnrecipecardevent:push()
	end

	local function OnSaltFood(parent)
		parent.player_classified.saltfoodevent:push()
	end

	local function OnPlayNukashine(parent)
		parent.player_classified.playnukashineevent:push()
	end

	local function OnStopNukashine(parent)
		parent.player_classified.stopnukashineevent:push()
	end

	local function OnPirateRum(parent)
		parent.player_classified.piraterumevent:push()
	end

	local function OnBottleCap(parent)
		parent.player_classified.bottlecapevent:push()
	end

	local function OnPlayGoldenApple(parent)
		parent.player_classified.playgoldenappleevent:push()
	end

	local function OnStopGoldenApple(parent)
		parent.player_classified.stopgoldenappleevent:push()
	end

	local function RegisterNetListeners(inst)
		if _G.TheWorld.ismastersim then
			inst:ListenForEvent("learnrecipecard", OnLearnRecipeCard, inst.entity:GetParent())
			inst:ListenForEvent("saltfood",        OnSaltFood,        inst.entity:GetParent())
			inst:ListenForEvent("playnukashine",   OnPlayNukashine,   inst.entity:GetParent())
			inst:ListenForEvent("stopnukashine",   OnStopNukashine,   inst.entity:GetParent())
			inst:ListenForEvent("piraterum",       OnPirateRum,       inst.entity:GetParent())
			inst:ListenForEvent("bottlecap",       OnBottleCap,       inst.entity:GetParent())
			inst:ListenForEvent("playgoldenapple", OnPlayGoldenApple, inst.entity:GetParent())
			inst:ListenForEvent("stopgoldenapple", OnStopGoldenApple, inst.entity:GetParent())
		end

		inst:ListenForEvent("action.learnrecipecard", OnLearnRecipeCardEvent)
		inst:ListenForEvent("action.salt",            OnSaltFoodEvent)
		inst:ListenForEvent("buff.playnukashine",     OnPlayNukashineEvent)
		inst:ListenForEvent("buff.stopnukashine",     OnStopNukashineEvent)
		inst:ListenForEvent("buff.piraterum",         OnPirateRumEvent)
		inst:ListenForEvent("buff.bottlecap",         OnBottleCapEvent)
		inst:ListenForEvent("buff.playgoldenapple",   OnPlayGoldenAppleEvent)
		inst:ListenForEvent("buff.stopgoldenapple",   OnStopGoldenAppleEvent)
	end

	inst.learnrecipecardevent = net_event(inst.GUID, "action.learnrecipecard")
	inst.saltfoodevent        = net_event(inst.GUID, "action.salt")
	inst.playnukashineevent   = net_event(inst.GUID, "buff.playnukashine")
	inst.stopnukashineevent   = net_event(inst.GUID, "buff.stopnukashine")
	inst.piraterumevent       = net_event(inst.GUID, "buff.piraterum")
	inst.bottlecapevent       = net_event(inst.GUID, "buff.bottlecap")
	inst.playgoldenappleevent = net_event(inst.GUID, "buff.playgoldenapple")
	inst.stopgoldenappleevent = net_event(inst.GUID, "buff.stopgoldenapple")

	inst:DoStaticTaskInTime(0, RegisterNetListeners)
end

AddPrefabPostInit("player_classified", PlayerClassifiedPostInit)