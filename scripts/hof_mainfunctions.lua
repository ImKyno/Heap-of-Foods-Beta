function ChangeFoodConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2334209327", false)
	-- local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2334209327", false) -- Heap of Foods Workshop.
	if configs ~= nil then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2334209327", configs, false)
	-- KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2334209327", configs, false)
end

local function TogglePickable(pickable, isspring)
    if isspring then
        pickable:Pause()
    else
        pickable:Resume()
    end
end

function MakeNoGrowInSpring(inst)
    inst.components.pickable:WatchWorldState("isspring", TogglePickable)
    TogglePickable(inst.components.pickable, TheWorld.state.isspring)
end

function IsSerenityBiome(inst)
	if inst ~= nil and inst:IsValid() and TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition()) then
		local node = TheWorld.Map:FindNodeAtPoint(inst.Transform:GetWorldPosition())
		return node and node.tags and table.contains(node.tags, "serenityarea")
	end
	
	return false
end

function IsSerenityBiomeAtPoint(x, y, z)
	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		local node = TheWorld.Map:FindNodeAtPoint(x, y, z)
		return node and node.tags and table.contains(node.tags, "serenityarea")
	end
	
	return false
end

local function GetRandomPosition(caster, teleportee, target_in_ocean)
	if target_in_ocean then
		local pt = TheWorld.Map:FindRandomPointInOcean(20)
		
		if pt ~= nil then
			return pt
		end

		local from_pt = teleportee:GetPosition()
		local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
		
		if offset ~= nil then
			return from_pt + offset
		end
			
		return teleportee:GetPosition()
	else
		local centers = {}

		for i, node in ipairs(TheWorld.topology.nodes) do
			if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
				table.insert(centers, {x = node.x, z = node.y})
			end
		end
				
		if #centers > 0 then
			local pos = centers[math.random(#centers)]
			return Point(pos.x, 0, pos.z)
		else
			return eater:GetPosition()
		end
	end
end

local function TeleportEnd(teleportee, locpos, loctarget, eater)
	if loctarget ~= nil and loctarget:IsValid() and loctarget.onteleto ~= nil then
		loctarget:onteleto()
	end

	local teleportfx = SpawnPrefab("explode_reskin")
	teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())

	if teleportee.components.talker ~= nil then
		teleportee.components.talker:Say(GetString(teleportee, "ANNOUNCE_TOWNPORTALTELEPORT"))
	end

	if teleportee:HasTag("player") then
		teleportee.sg.statemem.teleport_task = nil
		teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
	else
		teleportee:Show()
		
		if teleportee.DynamicShadow ~= nil then
			teleportee.DynamicShadow:Enable(true)
		end
		
		if teleportee.components.health ~= nil then
			teleportee.components.health:SetInvincible(false)
		end
		
		teleportee:PushEvent("teleported")
	end
end

local function TeleportContinue(teleportee, locpos, loctarget, eater)
	if teleportee.Physics ~= nil then
		teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
	else
		teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
	end

	if teleportee:HasTag("player") then
		teleportee:SnapCamera()
		teleportee:ScreenFade(true, 1)
		teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, TeleportEnd, locpos, loctarget)
	else
		TeleportEnd(teleportee, locpos, loctarget)
	end
end

local function TeleportStart(teleportee, eater, caster, loctarget, target_in_ocean)
	local ground = TheWorld

	local locpos = teleportee.components.teleportedoverride ~= nil and teleportee.components.teleportedoverride:GetDestPosition()
	or loctarget == nil and GetRandomPosition(eater, teleportee, target_in_ocean)
	or loctarget.teletopos ~= nil and loctarget:teletopos()
	or loctarget:GetPosition()

	if teleportee.components.locomotor ~= nil then
		teleportee.components.locomotor:StopMoving()
	end

	local teleportfx = SpawnPrefab("explode_reskin")
	teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())

	local isplayer = teleportee:HasTag("player")
	
	if isplayer then
		teleportee.sg:GoToState("forcetele")
	else
		if teleportee.components.health ~= nil then
			teleportee.components.health:SetInvincible(true)
		end
		
		if teleportee.DynamicShadow ~= nil then
			teleportee.DynamicShadow:Enable(false)
		end
		
		teleportee:Hide()
	end

	if isplayer then
		teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3, TeleportContinue, locpos, loctarget)
	else
		TeleportContinue(teleportee, locpos, loctarget)
	end
end

local TELEPORT_MUST_TAGS = { "locomotor" }
local TELEPORT_CANT_TAGS = { "playerghost", "INLIMBO" }

function OnFoodTeleport(inst, eater)
	local caster = inst.components.inventoryitem.owner or eater
	
	if eater == nil then
		eater = caster
	end

	local x, y, z = eater.Transform:GetWorldPosition()
	local target_in_ocean = eater.components.locomotor ~= nil and eater.components.locomotor:IsAquatic()
	local loctarget = eater.components.minigame_participator ~= nil and eater.components.minigame_participator:GetMinigame()
	or eater.components.teleportedoverride ~= nil and eater.components.teleportedoverride:GetDestTarget()
	or eater.components.hitchable ~= nil and eater:HasTag("hitched") and eater.components.hitchable.hitched or nil

	if eater:HasTag("player") then
		TeleportStart(eater, inst, caster, loctarget, target_in_ocean)
	end
end

function OnFoodNaughtiness(inst, eater)
	SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
	local function KrampusSpawnPoint(pt)
		if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
			pt = FindNearbyLand(pt, 1) or pt
		end
				
		local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 15, 12, true)
		
		if offset ~= nil then
			offset.x = offset.x + pt.x
			offset.z = offset.z + pt.z
			return offset
		end
	end
			
	local spawn_pt = KrampusSpawnPoint(eater:GetPosition())
	
	if spawn_pt ~= nil then
		local krampus = SpawnPrefab("krampus")
		krampus.Physics:Teleport(spawn_pt:Get())
	end
end