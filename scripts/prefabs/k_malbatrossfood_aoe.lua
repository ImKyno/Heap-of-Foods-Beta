require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/malbatross_chum.zip"),
}

local prefabs =
{
	"kyno_malbatross_chumpiece",
}

local DURATION = 20
local CHUM_PIECE_SPAWN_RADIUS = 3
local CHUM_PIECE_SPAWN_FREQUENCY = 0.5
local MAX_CHUM_PIECES = 7
local FISH_SPAWN_ATTEMPTS = 5
local MALBATROSS_TIMERNAME2 = "malbatross_timetospawn2"
local FISHABLE_TAGS = {"malbatross"}

local function DoDisperse(inst)
	inst.SoundEmitter:KillSound("spore_loop")
	inst.persists = false
	
	inst:RemoveTag("malbatross_chum")
	inst:DoTaskInTime(2, inst.Remove)

	inst.AnimState:PlayAnimation("malbatross_chum_base_pst")
end

local function OnTimerDone(inst, data)
	if data.name == "disperse" then
		DoDisperse(inst)
	end
end

local function OnRemove(inst)
	for k, v in pairs(inst._chumpieces) do
		if k:IsValid() then
			k:Remove()
		end
	end
end

local function OnDeath(inst)
	local SPAWN_TIME = TUNING.MALBATROSS_SPAWNDELAY_BASE + TUNING.MALBATROSS_SPAWNDELAY_RANDOM

	if TheWorld ~= nil then
		TheWorld.components.timer:StartTimer(MALBATROSS_TIMERNAME2, SPAWN_TIME)
	end
end

local function SpawnMalbatross(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local the_malbatross = TheSim:FindFirstEntityWithTag("malbatross")
	
	if not the_malbatross then
		if TheWorld.components.timer:TimerExists(MALBATROSS_TIMERNAME2) then
			return false
		else
			local malbatross = SpawnPrefab("malbatross")
			malbatross.Transform:SetPosition(inst.Transform:GetWorldPosition())
			malbatross.sg:GoToState("arrive")
			malbatross:ListenForEvent("death", OnDeath) -- Run a false timer to prevent more spawns for a while...
			return true
		end
	else
		inst._spawn_malbatross_task = nil
	end
end

local function OnPieceRemoved(piece)
	local chum_aoe = piece._source
    
	if chum_aoe ~= nil then
		chum_aoe._chumpieces[piece] = nil
		chum_aoe._num_chumpieces = chum_aoe._num_chumpieces - 1

		if chum_aoe.persists then
			chum_aoe:_spawn_chum_piece_fn()
		end
	end
end

local function SpawnChumPieces(inst)
	if inst._num_chumpieces < MAX_CHUM_PIECES then
		local x, y, z = inst.Transform:GetWorldPosition()
		local theta = math.random() * TWOPI
		local offset = math.random() * CHUM_PIECE_SPAWN_RADIUS
		local spawnx, spawnz = x + math.cos(theta) * offset, z + math.sin(theta) * offset
		
		if TheWorld.Map:IsOceanAtPoint(spawnx, 0, spawnz, false) then
			local piece = SpawnPrefab("kyno_malbatross_chumpiece")

			piece.Transform:SetPosition(spawnx, 0, spawnz)
			piece._source = inst
			inst._chumpieces[piece] = true
			inst._num_chumpieces = inst._num_chumpieces + 1

			piece:ListenForEvent("onremove", OnPieceRemoved)
		end
	end
end

local function OnLoad(inst, data)
	if data ~= nil then
		if inst._spawn_malbatross_task_task ~= nil then
			inst._spawn_malbatross_task:Cancel()
			inst._spawn_malbatross_task = nil
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("malbatross_chum")
	inst.AnimState:SetBuild("malbatross_chum")
	inst.AnimState:PlayAnimation("malbatross_chum_base_pre")
	inst.AnimState:PushAnimation("malbatross_chum_base_idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset(3)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("malbatross_chum")

	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "spore_loop")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst._spawn_chum_piece_fn = SpawnChumPieces

	inst._chumpieces = {}
	inst._num_chumpieces = 0
	
	inst:DoPeriodicTask(CHUM_PIECE_SPAWN_FREQUENCY, SpawnChumPieces)

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("disperse", DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("onremove", OnRemove)
	
	inst._spawn_malbatross_task = inst:DoTaskInTime(5 + math.random() * 2, SpawnMalbatross)
	
	inst.OnLoad = OnLoad

	return inst
end

local function chumpiecefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:AddComponent("edible")
	inst.components.edible.secondaryfoodtype = FOODTYPE.MEAT

	return inst
end

return Prefab("kyno_malbatross_aoe", fn, assets, prefabs),
Prefab("kyno_malbatross_chumpiece", chumpiecefn)