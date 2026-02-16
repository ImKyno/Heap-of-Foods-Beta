local COOK_ROBOT_DEFS       = {}
local SPAWNPOINT_NAME       = "spawnpoint"
local SPAWNPOINT_LOCAL_NAME = "spawnpoint_local"

local function GetSpawnPoint(inst)
	local local_pos = inst.components.knownlocations:GetLocation(SPAWNPOINT_LOCAL_NAME)
	
	if local_pos ~= nil then
		local platform = inst:GetCurrentPlatform()
		
		if platform ~= nil then
			return Vector3(platform.entity:LocalToWorldSpace(local_pos:Get()))
		end
	end
	
	return inst.components.knownlocations:GetLocation(SPAWNPOINT_NAME) or inst:GetPosition()
end

local function UpdateSpawnPoint(inst, dont_overwrite)
	if dont_overwrite and (inst.components.knownlocations == nil or inst.components.knownlocations:GetLocation(SPAWNPOINT_NAME) ~= nil) then
		return
	end
	
	if inst.brain ~= nil then
		inst.brain:UnignoreItem()
	end

	if inst:IsOnPassablePoint() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local pos = Vector3(x, 0, z)

		local platform = inst:GetCurrentPlatform()

		if platform ~= nil then
			local local_pos = Vector3(platform.entity:WorldToLocalSpace(x, 0, z))
			inst.components.knownlocations:RememberLocation(SPAWNPOINT_LOCAL_NAME, local_pos, dont_overwrite)
		else
			inst.components.knownlocations:ForgetLocation(SPAWNPOINT_LOCAL_NAME)
		end

		if x == 0 and z == 0 then
			inst._originx:set_local(0)
		end
		
		inst._originx:set(x)
		inst._originz:set(z)

		inst.components.knownlocations:RememberLocation(SPAWNPOINT_NAME, pos, dont_overwrite)
	end
end

local function UpdateSpawnPointOnLoad(inst)
	local x, y, z
	local pos = inst.components.knownlocations:GetLocation(SPAWNPOINT_NAME)
	
	if pos then
		x, y, z = pos:Get()
	else
		x, y, z = inst.Transform:GetWorldPosition()
	end

	if x == 0 and z == 0 then
		inst._originx:set_local(0)
	end
	
	inst._originx:set(x)
	inst._originz:set(z)

	return pos ~= nil
end

local function ClearSpawnPoint(inst)
	inst.components.knownlocations:ForgetLocation(SPAWNPOINT_NAME)
	inst.components.knownlocations:ForgetLocation(SPAWNPOINT_LOCAL_NAME)
end

local CONTAINER_MUST_ONEOF_TAGS = { "cook_robot_storage_valid" }
local CONTAINER_CANT_TAGS       = { "portablestorage", "mastercookware", "mermonly", "FX", "NOCLICK", "DECOR", "INLIMBO" }
local ALLOWED_CONTAINER_TYPES   = { "chest", "pack", "cooker", "brewer" }

local function FindNearestContainer(inst, item_prefab)
	local x, y, z = COOK_ROBOT_DEFS.GetSpawnPoint(inst):Get()
	local ents = TheSim:FindEntities(x, y, z, TUNING.KYNO_COOK_ROBOT_WORK_RADIUS, nil, CONTAINER_CANT_TAGS, CONTAINER_MUST_ONEOF_TAGS)

	local nearest = nil
	local bestdist = math.huge
	local platform = inst:GetCurrentPlatform()

	for _, ent in ipairs(ents) do
		if ent.components.container ~= nil 
		and table.contains(ALLOWED_CONTAINER_TYPES, ent.components.container.type) 
		and ent:IsOnPassablePoint() and ent:GetCurrentPlatform() == platform then
			if item_prefab == nil or ent.components.container:Has(item_prefab, 1) then
				local distsq = inst:GetDistanceSqToInst(ent)
				
				if distsq < bestdist then
					bestdist = distsq
					nearest = ent
				end
			end
		end
	end

	return nearest
end

local COOKER_MUST_ONEOF_TAGS = { "cook_robot_cooker_valid" }
local COOKER_CANT_TAGS       = { "cook_robot_reserved", "portablestorage", "mastercookware", "mermonly", "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function FindNearestCooker(inst, cooker_prefab)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.KYNO_COOK_ROBOT_WORK_RADIUS, nil, COOKER_CANT_TAGS, COOKER_MUST_ONEOF_TAGS)

	local nearest = nil
	local bestdist = math.huge
	local platform = inst:GetCurrentPlatform()

	for _, ent in ipairs(ents) do
		if ent.components.container ~= nil and ent:IsOnPassablePoint() and ent:GetCurrentPlatform() == platform then
			local distsq = inst:GetDistanceSqToInst(ent)
			
			if distsq < bestdist then
				bestdist = distsq
				nearest = ent
			end
		end
	end

	return nearest
end

local function FindAllCookers(inst, cooker_prefab)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.KYNO_COOK_ROBOT_WORK_RADIUS, nil, COOKER_CANT_TAGS, COOKER_MUST_ONEOF_TAGS)
	
	local platform = inst:GetCurrentPlatform()
	local cookers = {}

	for _, ent in ipairs(ents) do
		if ent.components.container ~= nil and ent:IsOnPassablePoint() and ent:GetCurrentPlatform() == platform and 
		(cooker_prefab == nil or ent.prefab == cooker_prefab) then
			table.insert(cookers, ent)
		end
	end

	return cookers
end

local function FindNearestAvailableCooker(inst, is_available_fn, cooker_prefab)
	local cookers = COOK_ROBOT_DEFS.FindAllCookers(inst, cooker_prefab)

	local nearest = nil
	local bestdist = math.huge

	for _, cooker in ipairs(cookers) do
		if is_available_fn == nil or is_available_fn(inst, cooker) then
			local distsq = inst:GetDistanceSqToInst(cooker)

			if distsq < bestdist then
				bestdist = distsq
				nearest = cooker
			end
		end
	end

	return nearest
end

local function FindContainerWithItem(inst, item)
	return FindNearestContainer(inst, item.prefab)
end

COOK_ROBOT_DEFS =
{
	GetSpawnPoint              = GetSpawnPoint,
	UpdateSpawnPoint           = UpdateSpawnPoint,
	UpdateSpawnPointOnLoad     = UpdateSpawnPointOnLoad,
	ClearSpawnPoint            = ClearSpawnPoint,
	FindNearestContainer       = FindNearestContainer,
	FindNearestCooker          = FindNearestCooker,
	FindAllCookers             = FindAllCookers,
	FindNearestAvailableCooker = FindNearestAvailableCooker,
	FindContainerWithItem      = FindContainerWithItem,
	
	-- Mod accessibility. Variables are not guaranteed to exist below here but are here in case they stay around.
	-- If these are used outside of this common file move them up and guarantee they exist.
	CONTAINER_MUST_ONEOF_TAGS  = CONTAINER_MUST_ONEOF_TAGS,
	CONTAINER_CANT_TAGS        = CONTAINER_CANT_TAGS,
	ALLOWED_CONTAINER_TYPES    = ALLOWED_CONTAINER_TYPES,
	
	COOKER_MUST_ONEOF_TAGS     = COOKER_MUST_ONEOF_TAGS,
	COOKER_CANT_TAGS           = COOKER_CANT_TAGS,
}

return COOK_ROBOT_DEFS