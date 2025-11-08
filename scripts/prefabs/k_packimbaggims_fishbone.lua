local assets =
{
	Asset("ANIM", "anim/kyno_packimbaggims_fishbone.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local SPAWN_DIST = TUNING.KYNO_PACKIMBAGGIMS_SPAWN_DIST

local function PackimDead(inst)
	inst.AnimState:PlayAnimation("dead", true)
	inst.components.inventoryitem:ChangeImageName("kyno_packimbaggims_fishbone_dead")
end

local function PackimDeadWater(inst)
	inst.AnimState:PlayAnimation("dead_water", true)
	inst.components.inventoryitem:ChangeImageName("kyno_packimbaggims_fishbone_dead")
end

local function PackimLive(inst)
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.components.inventoryitem:ChangeImageName("kyno_packimbaggims_fishbone")
end

local function PackimLiveWater(inst)
	inst.AnimState:PlayAnimation("idle_water", true)
	inst.components.inventoryitem:ChangeImageName("kyno_packimbaggims_fishbone")
end

local function NoHoles(pt)
	return not TheWorld.Map:IsPointNearHole(pt)
end

local function GetSpawnPoint(pt)
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, SPAWN_DIST, 12, true, true, NoHoles, true)
	local offset_water = FindSwimmableOffset(pt, math.random() * TWOPI, SPAWN_DIST, 12, true, true, NoHoles, true)
	
	if offset ~= nil or offset_water ~= nil then
		offset.x = offset.x + pt.x
		offset.z = offset.z + pt.z
		return offset
	end
end

local function SpawnPackim(inst)
	local pt = inst:GetPosition()
	local spawn_pt = GetSpawnPoint(pt)
	
	if spawn_pt ~= nil then
		local packim = SpawnPrefab("kyno_packimbaggims")
		
		if packim ~= nil then
			packim.Physics:Teleport(spawn_pt:Get())
			packim:FacePoint(pt:Get())

			return packim
		end
	end
end

local StartRespawn

local function StopRespawn(inst)
	if inst.respawntask then
		inst.respawntask:Cancel()
		inst.respawntask = nil
		inst.respawntime = nil
	end
end

local function RebindPackim(inst, packim)
	packim = packim or TheSim:FindFirstEntityWithTag("packimbaggims")
	
	if packim then
		PackimLive(inst)
		
		inst:ListenForEvent("death", function()
			StartRespawn(inst, TUNING.KYNO_PACKIMBAGGIMS_RESPAWN_TIME)
		end, packim)

		if packim.components.follower.leader ~= inst then
			packim.components.follower:SetLeader(inst)
		end
		
		return true
	end
end

local function RespawnPackim(inst)
	StopRespawn(inst)
	RebindPackim(inst, TheSim:FindFirstEntityWithTag("packimbaggims") or SpawnPackim(inst))
end

function StartRespawn(inst, time)
	StopRespawn(inst)

	local time = time or 0
	
	inst.respawntask = inst:DoTaskInTime(time, RespawnPackim)
	inst.respawntime = GetTime() + time
	
	if time > 0 then
		PackimDead(inst)
	end
end

local function FixPackim(inst)
	inst.fixtask = nil

	if not RebindPackim(inst) then
		PackimDead(inst)

		if inst.components.inventoryitem.owner then
			local time_remaining = inst.respawntime ~= nil and math.max(0, inst.respawntime - GetTime()) or 0
			StartRespawn(inst, time_remaining)
		end
	end
end

local function OnPutInInventory(inst)
	if not inst.fixtask then
		inst.fixtask = inst:DoTaskInTime(1, FixPackim)
	end
end

local function OnSave(inst, data)
	if inst.respawntime ~= nil then
		local time = GetTime()
		
		if inst.respawntime > time then
			data.respawntimeremaining = inst.respawntime - time
		end
	end
end

local function OnLoad(inst, data)
	if data == nil then
		return
	end

	if data.respawntimeremaining ~= nil then
		inst.respawntime = data.respawntimeremaining + GetTime()
		
		if data.respawntimeremaining > 0 then
			PackimDead(inst, true)
		end
	end
end

local function OnDropped(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local packim = TheSim:FindFirstEntityWithTag("packimbaggims")

	if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
		if packim then
			PackimLive(inst)
		else
			PackimDead(inst)
		end
	else
		if packim then
			PackimLiveWater(inst)
		else
			PackimDeadWater(inst)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
		
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_packimbaggims_fishbone.tex")
	inst.MiniMapEntity:SetPriority(7)

	inst:AddTag("packimbaggims_fishbone")
	inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")
	inst:AddTag("dead_fish_item")

	inst.AnimState:SetBank("kyno_packimbaggims_fishbone")
	inst.AnimState:SetBuild("kyno_packimbaggims_fishbone")
	inst.AnimState:PlayAnimation("dead", true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("leader")
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem:ChangeImageName("kyno_packimbaggims_fishbone_dead")
	
	inst.fixtask = inst:DoTaskInTime(1, FixPackim)
	
	inst:ListenForEvent("ondropped", OnDropped)

	inst.OnLoad = OnLoad
	inst.OnSave = OnSave
	
	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_packimbaggims_fishbone", fn, assets)