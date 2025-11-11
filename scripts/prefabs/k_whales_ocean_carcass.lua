local whale_blue_assets =
{
	Asset("ANIM", "anim/kyno_whale_carcass.zip"),
	Asset("ANIM", "anim/kyno_whale_blue_carcass_build.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}
local whale_white_assets = 
{
	Asset("ANIM", "anim/kyno_whale_carcass.zip"),
	Asset("ANIM", "anim/kyno_whale_white_carcass_build.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"fishmeat",
	"boneshard",
}

local whale_blue_sounds = 
{
	stinks    = "hof_sounds/creatures/whale_blue_carcass/stinks",
	bloated1  = "hof_sounds/creatures/whale_blue_carcass/bloated1",
	bloated2  = "hof_sounds/creatures/whale_blue_carcass/bloated2",
	explosion = "hof_sounds/creatures/whale_blue_carcass/explosion",
	hit       = "hof_sounds/creatures/whale_blue_carcass/hit",
}

local whale_white_sounds = 
{
	stinks    = "hof_sounds/creatures/whale_white_carcass/stinks",
	bloated1  = "hof_sounds/creatures/whale_white_carcass/bloated1",
	bloated2  = "hof_sounds/creatures/whale_white_carcass/bloated2",
	explosion = "hof_sounds/creatures/whale_white_carcass/explosion",
	hit       = "hof_sounds/creatures/whale_white_carcass/hit",
}

local function PlaySingleStinkSound(inst)
	inst.SoundEmitter:PlaySound(inst.sounds.stinks)
end

local function PlayStinkSounds(inst, delay)
	delay = delay or 20 * FRAMES

	inst.soundtask1 = inst:DoPeriodicTask(2.434, PlaySingleStinkSound, delay)
	inst.soundtask2 = inst:DoPeriodicTask(2.434, PlaySingleStinkSound, delay + 18 * FRAMES)
	inst.soundtask3 = inst:DoPeriodicTask(2.434, PlaySingleStinkSound, delay + 48 * FRAMES)
end

local function KillStinkSounds(inst)
	if inst.soundtask1 ~= nil then
		inst.soundtask1:Cancel()
		inst.soundtask1 = nil
	end
	
	if inst.soundtask2 ~= nil then
		inst.soundtask2:Cancel()
		inst.soundtask2 = nil
	end
	
	if inst.soundtask3 ~= nil then
		inst.soundtask3:Cancel()
		inst.soundtask3 = nil
	end
end

local function OnHit(inst, worker, workleft)
	KillStinkSounds(inst)
	
	inst.SoundEmitter:PlaySound(inst.sounds.hit)
	
	inst.AnimState:PlayAnimation("idle_trans2_3")
	inst.AnimState:PushAnimation("idle_bloat3",true)
	
	PlayStinkSounds(inst)
end

local function OnWorked(inst, worker)
	inst.components.growable:DoGrowth()
end

local function SpawnCarcassEnemy(inst)
	local px, py, pz = inst.Transform:GetWorldPosition()
	local witness = FindClosestPlayerInRange(px, py, pz, 20, true)
		
	if witness then
		SpawnWhaleCarcassEnemies(inst, witness)
	end
	
	inst:Remove()
end

local function DoBurst(inst)
	if inst.persists then
		inst.persists = false
		
		inst.AnimState:PlayAnimation("explode", false)
		inst.SoundEmitter:PlaySound(inst.sounds.explosion)

		inst:DoTaskInTime(57 * FRAMES, function (inst)
			inst.components.explosivecorpse:OnBurnt()
		end)

		inst:DoTaskInTime(58 * FRAMES, function(inst)
			local i = 1
			
			for ii = 1, i + 1 do
				inst.components.lootdropper.speed = 3 + (math.random() * 8)
				
				local loot = GetRandomItem(TUNING.HOF_WHALE_LOOT[i])
				local newprefab = inst.components.lootdropper:SpawnLootPrefab(loot)
				
				if newprefab then
					local vx, vy, vz = newprefab.Physics:GetVelocity()
					newprefab.Physics:SetVel(vx, 20 + (math.random() * 5), vz)
				end
			end
		end)
		
		inst:DoTaskInTime(60 * FRAMES, function(inst)
			local i = 2
			
			for ii = 1, i + 1 do
				inst.components.lootdropper.speed = 4 + (math.random() * 8)
				
				local loot = GetRandomItem(TUNING.HOF_WHALE_LOOT[i])
				local newprefab = inst.components.lootdropper:SpawnLootPrefab(loot)
				
				if newprefab then
					local vx, vy, vz = newprefab.Physics:GetVelocity()
					newprefab.Physics:SetVel(vx, 25 + (math.random() * 5), vz)
				end
			end
		end)
		
		inst:DoTaskInTime(63 * FRAMES, function(inst)
			local i = 3
			
			for ii = 1, i + 1 do
				inst.components.lootdropper.speed = 6 + (math.random() * 8)
				
				local loot = GetRandomItem(TUNING.HOF_WHALE_LOOT[i])
				local newprefab = inst.components.lootdropper:SpawnLootPrefab(loot)
				
				if newprefab then
					local vx, vy, vz = newprefab.Physics:GetVelocity()
					newprefab.Physics:SetVel(vx, 30 + (math.random() * 5), vz)
				end
			end

			inst.components.lootdropper:DropLoot()
		end)

		inst:ListenForEvent("animqueueover", SpawnCarcassEnemy)
	end
end

local growth_stages = 
{
	{
		name = "bloat1",
		time = function(inst) return GetRandomWithVariance(TUNING.KYNO_WHALE_ROT_TIME[1].base, TUNING.KYNO_WHALE_ROT_TIME[1].random) end,
		fn = function (inst)
			inst.AnimState:PlayAnimation("idle_pre")
			inst.AnimState:PushAnimation("idle_bloat1", true)
			inst.components.workable:SetWorkable(false)
		end,
	},
	
    {
		name = "bloat2",
		time = function(inst) return GetRandomWithVariance(TUNING.KYNO_WHALE_ROT_TIME[1].base, TUNING.KYNO_WHALE_ROT_TIME[1].random) end,
		fn = function (inst)
			inst.AnimState:PlayAnimation("idle_trans1_2")
			inst.SoundEmitter:PlaySound(inst.sounds.bloated1)
			inst.AnimState:PushAnimation("idle_bloat2", true)
			inst.components.workable:SetWorkable(false)
		end,
	},
	
	{
		name = "bloat3",
		time = function(inst) return GetRandomWithVariance(TUNING.KYNO_WHALE_ROT_TIME[2].base, TUNING.KYNO_WHALE_ROT_TIME[2].random) end,
		fn = function (inst)
			inst.AnimState:PlayAnimation("idle_trans2_3")
			inst.SoundEmitter:PlaySound(inst.sounds.bloated2)
			inst.AnimState:PushAnimation("idle_bloat3", true)
			PlayStinkSounds(inst)
			inst.components.workable:SetWorkable(true)
		end,
	},
	
	{
		name = "explode",
		time = function(inst) return GetRandomWithVariance(TUNING.KYNO_WHALE_ROT_TIME[2].base, TUNING.KYNO_WHALE_ROT_TIME[2].random) end,
		fn = function (inst)
			inst.components.workable:SetWorkable(false)
			KillStinkSounds(inst)

			inst.readytoburst = true
			
			if not inst:IsAsleep() then
				DoBurst(inst)
			end
		end,
	},
}

local function OnEntityWake(inst)
	if inst.readytoburst then
		inst:DoTaskInTime(1, DoBurst)
	end
end

local COLLISION_DAMAGE_SCALE = 0.5

local function OnCollide(inst, data)
	local boat_physics = data.other.components.boatphysics

	if boat_physics ~= nil then
		local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * COLLISION_DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
		
		if inst.components.workable:CanBeWorked() then
			inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.WHALE_BLUE_EXPLOSION_HACKS)
		end
	end
end

local function common(build, minimap_icon)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon(minimap_icon)
	minimap:SetPriority(5)

	MakeWaterObstaclePhysics(inst, 1.3, 2, 0.75)

	inst.AnimState:SetBank("kyno_whale_carcass")
	inst.AnimState:SetBuild(build)
	
	inst:AddTag("wet")
	inst:AddTag("whale_carcass")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_WHALE_OCEAN_CARCASS"

	inst:AddComponent("growable")
	inst.components.growable.springgrowth = false
	inst.components.growable.growoffscreen = true
	inst.components.growable.stages = growth_stages
	inst.components.growable:StartGrowing()

	inst:AddComponent("explosivecorpse")
	inst.components.explosivecorpse.lightonexplode = false

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	inst.components.workable:SetWorkable(false)

	inst:ListenForEvent("on_collide", OnCollide)
	inst:ListenForEvent("entitywake", OnEntityWake)

	return inst
end

local function whale_blue()
	local inst = common("kyno_whale_blue_carcass_build", "kyno_whale_blue_ocean_carcass.tex")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = whale_blue_sounds

	inst.components.lootdropper:SetLoot(TUNING.HOF_WHALE_BLUE_LOOT)
	
	inst.components.explosivecorpse.explosivedamage = TUNING.KYNO_WHALE_BLUE_EXPLOSION_DAMAGE

	inst.components.growable:SetStage(1)
	inst.components.growable:StartGrowing()

	inst.components.workable:SetWorkLeft(TUNING.KYNO_WHALE_BLUE_EXPLOSION_CHOPS)
	inst.components.workable:SetWorkable(false)

	return inst
end

local function whale_white()
	local inst = common("kyno_whale_white_carcass_build", "kyno_whale_white_ocean_carcass.tex")

	inst.Transform:SetScale(1.25, 1.25, 1.25)

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = whale_white_sounds

	inst.components.lootdropper:SetLoot(TUNING.HOF_WHALE_WHITE_LOOT)
	
	inst.components.explosivecorpse.explosivedamage = TUNING.KYNO_WHALE_WHITE_EXPLOSION_DAMAGE

	inst.components.growable:SetStage(1)
	inst.components.growable:StartGrowing()

	inst.components.workable:SetWorkLeft(TUNING.KYNO_WHALE_WHITE_EXPLOSION_CHOPS)
	inst.components.workable:SetWorkable(false)

	return inst
end

return Prefab("kyno_whale_blue_ocean_carcass", whale_blue, whale_blue_assets, prefabs),
Prefab("kyno_whale_white_ocean_carcass", whale_white, whale_white_assets, prefabs)