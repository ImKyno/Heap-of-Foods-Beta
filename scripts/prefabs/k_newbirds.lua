local prefabs = {}

local function MakeBird(data)
	local brain = require("brains/birdbrain")
	local nightbrain = require("brains/nightbirdbrain")

	local function ShouldSleepDay(inst)
		return NocturnalSleepTest(inst) and not inst.sg:HasStateTag("flight")
	end

	local function ShouldSleepNight(inst)
		return DefaultSleepTest(inst) and not inst.sg:HasStateTag("flight")
	end

	local function OnAttacked(inst, data)
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 30, { "bird" })
		local num_friends = 0
		local maxnum = 5

		for k, v in pairs(ents) do
			if v ~= inst then
				v:PushEvent("gohome")
				num_friends = num_friends + 1
			end

			if num_friends > maxnum then
				return
			end
		end
	end

	local function OnTrapped(inst, data)
		if data ~= nil and data.trapper ~= nil and data.trapper.settrapsymbols ~= nil then
			data.trapper.settrapsymbols(inst.trappedbuild)
		end
	end

	local function OnPutInInventory(inst)
		inst.sg:GoToState("idle")
	end

	local function OnDropped(inst)
		inst.sg:GoToState("stunned")
	end

	local function ChooseItem()
		local MERCY_ITEMS =
		{
			"flint",
			"flint",
			"flint",
			"twigs",
			"twigs",
			"cutgrass",
		}

		return MERCY_ITEMS[math.random(#MERCY_ITEMS)]
	end

	local function ChooseSeeds()
		return not TheWorld.state.iswinter and "seeds" or nil
	end

	local function SpawnPrefabChooser(inst)
		if TheWorld.state.cycles <= 3 then
			return ChooseSeeds()
		end

		local x, y, z = inst.Transform:GetWorldPosition()
		local players = FindPlayersInRange(x, y, z, 20, true)

		local oldestplayer = -1

		for i, player in ipairs(players) do
			if player.components.age ~= nil then
				local playerage = player.components.age:GetAgeInDays()

				if playerage >= 3 then
					return ChooseSeeds()
				elseif playerage > oldestplayer then
					oldestplayer = playerage
				end
			end
		end

		return oldestplayer >= 0 and math.random() < .35 - oldestplayer * .1 and ChooseItem() or ChooseSeeds()
	end

	local assets =
	{
		Asset("ANIM", "anim/crow.zip"),

		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

		Asset("SOUND", "sound/birds.fsb"),

	}

	local bird_prefabs = {}

	if data.bank ~= nil then
		table.insert(assets, Asset("ANIM", "anim/"..data.bank..".zip"))
	end

	if data.build then
		table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))
	else
		table.insert(assets, Asset("ANIM", "anim/"..data.name.."_build.zip"))
	end

	if data.water_bank ~= nil then
		table.insert(assets, Asset("ANIM", "anim/"..data.water_bank..".zip"))
	end

	if data.feather_name ~= nil then
		table.insert(bird_prefabs, data.feather_name)
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddLightWatcher()
		inst.entity:AddPhysics()
		inst.entity:AddNetwork()

		local shadow = inst.entity:AddDynamicShadow()
		shadow:SetSize(1, .75)
		shadow:Enable(false)

		inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:ClearCollisionMask()

		if data.water_bank ~= nil then
			inst.Physics:CollidesWith(COLLISION.GROUND)
		else
			inst.Physics:CollidesWith(COLLISION.WORLD)
		end

		inst.Physics:SetMass(1)
		inst.Physics:SetSphere(1)

		inst.Transform:SetTwoFaced()

		if data.water_bank ~= nil then
			MakeInventoryFloatable(inst)
		end

		inst.AnimState:SetBank(data.bank or "crow")
		inst.AnimState:SetBuild(data.build or data.name.."_build")
		inst.AnimState:PlayAnimation("idle")

		inst:AddTag(data.name)
		inst:AddTag("bird")
		inst:AddTag("cookable")
		inst:AddTag("smallcreature")
		inst:AddTag("likewateroffducksback")

		if data.nightbird then
			inst:AddTag("nightbird")
		end

		MakeFeedableSmallLivestockPristine(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		if data.water_bank ~= nil then
			inst.flyawaydistance = TUNING.WATERBIRD_SEE_THREAT_DISTANCE
		else
			inst.flyawaydistance = TUNING.BIRD_SEE_THREAT_DISTANCE
		end

		inst.sounds = data.sounds
		inst.trappedbuild = data.build or data.name.."_build"
		inst.lunar_mutation_chance = TUNING.BIRD_PRERIFT_MUTATION_SPAWN_CHANCE
		inst.gestalt_possession_chance = TUNING.BIRD_RIFT_POSSESSION_SPAWN_CHANCE

		inst:AddComponent("occupier")
		inst:AddComponent("inspectable")

		inst:AddComponent("locomotor")
		inst.components.locomotor:EnableGroundSpeedMultiplier(false)
		inst.components.locomotor:SetTriggersCreep(false)

		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })

		inst:AddComponent("sleeper")
		inst.components.sleeper:SetSleepTest(data.nightbird and ShouldSleepDay or ShouldSleepNight)

		inst:AddComponent("hauntable")
		inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.nobounce = true
		inst.components.inventoryitem.canbepickedup = false
		inst.components.inventoryitem.canbepickedupalive = true

		if data.water_bank == nil then
			inst.components.inventoryitem:SetSinks(true)
		end

		inst:AddComponent("combat")
		inst.components.combat.hiteffectsymbol = "crow_body"

		inst:AddComponent("cookable")
		inst.components.cookable.product = data.cookable

		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(TUNING.BIRD_HEALTH)
		inst.components.health.murdersound = "dontstarve/wilson/hit_animal"

		if data.periodicspawner ~= nil then
			inst:AddComponent("periodicspawner")
			inst.components.periodicspawner:SetPrefab(data.periodicspawner)
			inst.components.periodicspawner:SetDensityInRange(20, 2)
			inst.components.periodicspawner:SetMinimumSpacing(8)
		end

		inst:AddComponent("lootdropper")
		
		if data.custom_loot ~= nil then
			CustomLoot(inst, bird_prefabs)
		else
			if data.feather_name ~= nil then
				inst.components.lootdropper:AddRandomLoot(data.feather_name, 1)
			end

			inst.components.lootdropper:AddRandomLoot(data.loot, 1)
			inst.components.lootdropper.numrandomloot = 1
		end

		inst:SetStateGraph("SGbird")
		inst:SetBrain(data.nightbird and nightbrain or brain)

		inst:ListenForEvent("ontrapped", OnTrapped)
		inst:ListenForEvent("attacked", OnAttacked)

		if data.water_bank ~= nil then
			inst:ListenForEvent("floater_startfloating", function(inst)
				inst.AnimState:SetBank(data.water_bank)
			end)

			inst:ListenForEvent("floater_stopfloating", function(inst)
				inst.AnimState:SetBank(data.bank or "crow")
			end)
		end

		local birdspawner = TheWorld.components.birdspawner

		if birdspawner ~= nil then
			inst:ListenForEvent("onremove", birdspawner.StopTrackingFn)
			inst:ListenForEvent("enterlimbo", birdspawner.StopTrackingFn)
			birdspawner:StartTracking(inst)
		end

		MakeSmallBurnableCharacter(inst, "crow_body")
		MakeTinyFreezableCharacter(inst, "crow_body")
		MakeFeedableSmallLivestock(inst, TUNING.BIRD_PERISH_TIME, OnPutInInventory, OnDropped)

		return inst
	end

	return Prefab(data.name, fn, assets, bird_prefabs)
end

local birds =
{
	{
		name            = "quagmire_pigeon",
		water_bank      = nil,
		feather_name    = "feather_robin_winter",
		loot            = "kyno_bacon",
		cookable        = "kyno_bacon_cooked",
		sounds          =
		{
			takeoff     = "dontstarve//birds/takeoff_quagmire_pigeon",
			chirp       = "dontstarve//birds/chirp_quagmire_pigeon",
			flyin       = "dontstarve/birds/flyin",
		},
	},
	{
		name            = "toucan",
		water_bank      = nil,
		feather_name    = "feather_crow",
		loot            = "smallmeat",
		cookable        = "cookedsmallmeat",
		sounds          =
		{
			takeoff     = "hof_sounds/creatures/toucan/take_off",
			chirp       = "hof_sounds/creatures/toucan/chirp",
			flyin       = "dontstarve/birds/flyin",
		},
	},
	{
		name            = "toucan_chubby",
		water_bank      = nil,
		feather_name    = "feather_crow",
		loot            = "smallmeat",
		cookable        = "cookedsmallmeat",
		sounds          =
		{
			takeoff     = "hof_sounds/creatures/toucan/take_off",
			chirp       = "hof_sounds/creatures/toucan/chirp",
			flyin       = "dontstarve/birds/flyin",
		},
	},
	{
		name            = "kingfisher",
		water_bank      = nil,
		feather_name    = "feather_robin_winter",
		loot            = "smallmeat",
		cookable        = "cookedsmallmeat",
		periodicspawner = "kyno_koi",
		sounds          =
		{
			takeoff     = "hof_sounds/creatures/kingfisher/take_off",
			chirp       = "hof_sounds/creatures/kingfisher/chirp",
			flyin       = "dontstarve/birds/flyin",
		},
	},

	-- Yeah the name of this one is inconsistent, but will be like this for new birds.
	-- Since I also want to make a Bird Wildlife Mod in the future...
	{
		name            = "kyno_bird_robin_night",
		water_bank      = nil,
		feather_name    = "feather_crow",
		loot            = "smallmeat",
		cookable        = "cookedsmallmeat",
		nightbird       = true,
		sounds          =
		{
			takeoff     = "hof_sounds/creatures/robin_night/take_off",
			chirp       = "hof_sounds/creatures/robin_night/chirp",
			flyin       = "dontstarve/birds/flyin",
		},
	},
	{
		name            = "kyno_bird_robin_winter_night",
		water_bank      = nil,
		feather_name    = "feather_crow",
		loot            = "smallmeat",
		cookable        = "cookedsmallmeat",
		nightbird       = true,
		sounds          =
		{
			takeoff     = "hof_sounds/creatures/robin_winter_night/take_off",
			chirp       = "hof_sounds/creatures/robin_winter_night/chirp",
			flyin       = "dontstarve/birds/flyin",
		},
	},
}

for i, v in ipairs(birds) do
	table.insert(prefabs, MakeBird(v))
end

return unpack(prefabs)