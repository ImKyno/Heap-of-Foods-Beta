local brain = require("brains/chesterbrain")

local assets =
{
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ANIM", "anim/ui_chest_3x3.zip"),

	Asset("ANIM", "anim/kyno_packimbaggims.zip"),
	Asset("ANIM", "anim/kyno_packimbaggims_build.zip"),
	Asset("ANIM", "anim/kyno_packimbaggims_fat_build.zip"),
	Asset("ANIM", "anim/kyno_packimbaggims_fire_build.zip"),
	
	Asset("ANIM", "anim/kyno_packimbaggims_feathers.zip"),
	Asset("ANIM", "anim/kyno_packimbaggims_feathers_fire.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"kyno_packimbaggims_fishbone",
	"kyno_packimbaggims_feathers",
	"kyno_packimbaggims_feathers_fat",
	"kyno_packimbaggims_feathers_fire",

	"globalmapiconunderfog",
}

local normalsounds    =
{
	close             = "hof_sounds/creatures/packimbaggims/close",
	death             = "hof_sounds/creatures/packimbaggims/death",
	hurt              = "hof_sounds/creatures/packimbaggims/hit",
	land              = "hof_sounds/creatures/packimbaggims/land",
	open              = "hof_sounds/creatures/packimbaggims/open",
	swallow           = "hof_sounds/creatures/packimbaggims/swallow",
	transform         = "hof_sounds/creatures/packimbaggims/transform",
	trasnform_stretch = "hof_sounds/creatures/packimbaggims/transform_stretch",
	transform_pop     = "hof_sounds/creatures/packimbaggims/transformation_pop",
	fly               = "hof_sounds/creatures/packimbaggims/fly",
	fly_sleep         = "hof_sounds/creatures/packimbaggims/fly",
	sleep             = "hof_sounds/creatures/packimbaggims/sleep",
	bounce            = "hof_sounds/creatures/packimbaggims/bounce",

	fat_death_spin    = "hof_sounds/creatures/packimbaggims/fat/death_spin",
	fat_land_empty    = "hof_sounds/creatures/packimbaggims/fat/land_empty",
	fat_land_full     = "hof_sounds/creatures/packimbaggims/fat/land_full",
}

local fatsounds       =
{
	close             = "hof_sounds/creatures/packimbaggims/close",
	death             = "hof_sounds/creatures/packimbaggims/fat/death",
	hurt              = "hof_sounds/creatures/packimbaggims/fat/hit",
	land              = "hof_sounds/creatures/packimbaggims/land",
	open              = "hof_sounds/creatures/packimbaggims/fat/open",
	swallow           = "hof_sounds/creatures/packimbaggims/fat/swallow",
	transform         = "hof_sounds/creatures/packimbaggims/transform",
	trasnform_stretch = "hof_sounds/creatures/packimbaggims/trasnform_stretch",
	transform_pop     = "hof_sounds/creatures/packimbaggims/trasformation_pop",
	fly               = "hof_sounds/creatures/packimbaggims/fly",
	fly_sleep         = "hof_sounds/creatures/packimbaggims/fly",
	sleep             = "hof_sounds/creatures/packimbaggims/sleep",
	bounce            = "hof_sounds/creatures/packimbaggims/bounce",
	
	fat_death_spin    = "hof_sounds/creatures/packimbaggims/fat/death_spin",
	fat_land_empty    = "hof_sounds/creatures/packimbaggims/fat/land_empty",
	fat_land_full     = "hof_sounds/creatures/packimbaggims/fat/land_full",
}

local WAKE_TO_FOLLOW_DISTANCE = 14
local SLEEP_NEAR_LEADER_DISTANCE = 7

local function ShouldWakeUp(inst)
	return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
	return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") 
	and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) and not TheWorld.state.isfullmoon
end

local function ShouldKeepTarget()
	return false
end

local function OnOpen(inst)
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("open")
	end
end

local function OnClose(inst)
	if not inst.components.health:IsDead() and inst.sg.currentstate.name ~= "transition" then
		inst.sg:GoToState("close")		
	end
end

local function OnStopFollowing(inst)
	inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
	inst:AddTag("companion")
end

local function TryEatContents(inst)
	local dideat = false
	local container = inst.components.container

	if container:IsOpen() then
		return false
	end 

	if inst.PackimState == "FIRE" then
		for i = 1, container:GetNumSlots() do
			local item = container:GetItemInSlot(i)
			
			if item ~= nil and not item:HasTag("irreplaceable") then
				local replacement = nil
				
				if item.components.cookable ~= nil then
					replacement = item.components.cookable:Cook(inst, inst)
				elseif item:HasTag("charcoal_source") then
					replacement = SpawnPrefab("charcoal")
				elseif item.components.burnable ~= nil then
					replacement = SpawnPrefab("ash")
				end
				
				if replacement ~= nil then
					local stacksize = 1
					
					if item.components.stackable ~= nil then
						stacksize = item.components.stackable:StackSize()
					end
					
					if replacement.components.stackable ~= nil then
						replacement.components.stackable:SetStackSize(stacksize)
					end
					
					container:RemoveItemBySlot(i)
					
					item:Remove()
					container:GiveItem(replacement, i)
				end
			end
		end
		
		return false
	end

	local loot = {}
	
	if #loot > 0 then
		inst.components.lootdropper:SetLoot(loot)

		inst:DoTaskInTime(60 * FRAMES, function(inst)
			inst.components.lootdropper:DropLoot()
			inst.components.lootdropper:SetLoot({})
		end)
	end

	return dideat
end

local function MorphFatPackim(inst, noconsume)
	local container = inst.components.container
	inst.forceclosed = true
	
	container:Close()
	inst.forceclosed = false
	
	if not noconsume then
		local container = inst.components.container
		
		for i = 1, container:GetNumSlots() do
			container:RemoveItem(container:GetItemInSlot(i)):Remove()
		end
	end

	local old_SetNumSlots = container.SetNumSlots
	
	function container:SetNumSlots(numslots)
		self.numslots = numslots
	end

	inst.components.container:WidgetSetup("packimbaggimsfat")

	container.SetNumSlots = old_SetNumSlots

	inst.PackimState = "FAT"
	inst._isfatpackim:set(true)

	inst.AnimState:SetBuild("kyno_packimbaggims_fat_build")
    
	inst.MiniMapEntity:SetIcon("kyno_packimbaggims_fat.tex")
    inst.components.maprevealable:SetIcon("kyno_packimbaggims_fat.tex")

	inst:RemoveTag("fireimmune")

	inst.sounds = fatsounds

	local fx = SpawnPrefab("kyno_packimbaggims_feathers_fat")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function MorphFirePackim(inst, noconsume)
	local container = inst.components.container
	inst.forceclosed = true
	
	container:Close()
	inst.forceclosed = false

	if not noconsume then
		local container = inst.components.container
		
		for i = 1, container:GetNumSlots() do
			container:RemoveItem(container:GetItemInSlot(i)):Remove()
		end
	end

	local old_SetNumSlots = container.SetNumSlots
	
	function container:SetNumSlots(numslots)
		self.numslots = numslots
	end

	inst.components.container:WidgetSetup("packimbaggims")

	container.SetNumSlots = old_SetNumSlots

	inst.PackimState = "FIRE"
	inst._isfatpackim:set(false)

	inst.AnimState:SetBuild("kyno_packimbaggims_fire_build")
	
	inst.MiniMapEntity:SetIcon("kyno_packimbaggims_fire.tex")
	inst.components.maprevealable:SetIcon("kyno_packimbaggims_fire.tex")

	inst:AddTag("fireimmune")

	inst.sounds = normalsounds

	local fx = SpawnPrefab("kyno_packimbaggims_feathers_fire")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function MorphNormalPackim(inst, noconsume)
	local container = inst.components.container
	inst.forceclosed = true
	
	inst.components.container:Close()
	inst.forceclosed = false

	local oldnumslots = container:GetNumSlots()
	local newnumslots = 9

	local overflowitems = {}

	if oldnumslots > newnumslots then
		local diff = oldnumslots - newnumslots
		
		for i = newnumslots + 1, oldnumslots, 1 do
			overflowitems[#overflowitems + 1] = container:RemoveItemBySlot(i)
		end
	end

	local old_SetNumSlots = container.SetNumSlots
	
	function container:SetNumSlots(numslots)
		self.numslots = numslots
	end

	inst.components.container:WidgetSetup("packimbaggims")

	container.SetNumSlots = old_SetNumSlots

	for i = 1, #overflowitems, 1  do
		local item = overflowitems[i]
		
		overflowitems[i] = nil
		container:GiveItem(item, nil, nil, true)
	end

	inst.PackimState = "NORMAL"
	inst._isfatpackim:set(false)

	inst.AnimState:SetBuild("kyno_packimbaggims_build")
	
	inst.MiniMapEntity:SetIcon("kyno_packimbaggims.tex")
	inst.components.maprevealable:SetIcon("kyno_packimbaggims.tex")

	inst:RemoveTag("fireimmune")

	inst.sounds = normalsounds

	local fx = SpawnPrefab("kyno_packimbaggims_feathers")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function CanMorph(inst, dideat)
	local canFat = true
	local canFire = true

	if dideat and inst.PackimState ~= "NORMAL" then
		return false, false
	end

    local container = inst.components.container

	for i = 1, container:GetNumSlots() do
		local item = container:GetItemInSlot(i)
		
		if item == nil then
			return false, false
		end

		-- Heavy Fish for Fat Packim and Scorched Sunfish for Fire Packim.
		canFat = canFat and item ~= nil and item:HasTag("oceanfish") and item.components.weighable ~= nil and item.components.weighable:GetWeight() >= 150
		canFire = canFire and item ~= nil and item:HasTag("packimbaggims_fire_valid") or item.prefab == "oceanfish_small_8_inv"
		
		if not (canFire or canFat) then
			return false, false
		end
	end

	return canFat, canFire
end

local function CheckForMorph(inst)
    local dideat = TryEatContents(inst)

    if inst.forceclosed then
		return
	end

	inst.canFat, inst.canFire = CanMorph(inst, dideat)

	if inst.canFat or inst.canFire then
		inst.sg:GoToState("transform", true)
	elseif dideat then
		inst.sg:GoToState("swallow")
	end
end

local function DoMorph(inst, fn, noconsume)
	fn(inst, noconsume)
end

MorphPackimBaggims = function(inst, noconsume)
	if inst.canFat then
		MorphFatPackim(inst, noconsume)
	elseif inst.canFire then
		MorphFirePackim(inst, noconsume)
	else
		MorphNormalPackim(inst, noconsume)
	end
	
	inst.canFat = false
	inst.canFire = false
end

local function OnSave(inst, data)
	data.PackimState = inst.PackimState
end

local function OnPreLoad(inst, data)
	if data == nil then
		return
	elseif data.PackimState == "FAT" then
		MorphFatPackim(inst, true)
	elseif data.PackimState == "FIRE" then
		MorphFirePackim(inst, true)
	end
end

local function OnIsFatPackimDirty(inst)
	if inst._isfatpackim:value() ~= inst._clientfatmorphed then
		inst._clientfatmorphed = inst._isfatpackim:value()

		inst.replica.container:WidgetSetup(inst._clientfatmorphed and "packimbaggimsfat" or nil)
	end
end

local function OnHaunt(inst)
	if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
		inst.components.hauntable.panic = true
		inst.components.hauntable.panictimer = TUNING.HAUNT_PANIC_TIME_SMALL
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
		
		return true
	end
	
	return false
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_packimbaggims.tex")
    minimap:SetCanUseCache(false)
	
	inst.DynamicShadow:SetSize(2, 1.5)
	inst.Transform:SetSixFaced()
	
	MakeFlyingGiantCharacterPhysics(inst, 75, .5)

	inst.AnimState:SetBank("kyno_packimbaggims")
	inst.AnimState:SetBuild("kyno_packimbaggims_build")
	
	inst:AddTag("companion")
	inst:AddTag("character")
	inst:AddTag("scarytoprey")
	inst:AddTag("packimbaggims")
	inst:AddTag("flying")
	inst:AddTag("cattoy")
	inst:AddTag("notraptrigger")
	inst:AddTag("noauradamage")
	inst:AddTag("ignorewalkableplatformdrowning")

	inst._isfatpackim = net_bool(inst.GUID, "_isfatpackim", "onisfatpackimdirty")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst._clientfatmorphed = false
		inst:ListenForEvent("onisfatpackimdirty", OnIsFatPackimDirty)
		
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("packimbaggims")
		end
		
		return inst
	end
	
	inst.sounds = normalsounds
    
	-- inst:AddComponent("cooker")
	inst:AddComponent("knownlocations")
	inst:AddComponent("follower")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	
	inst:AddComponent("maprevealable")
	inst.components.maprevealable:SetIconPrefab("globalmapiconunderfog")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper.forcewortoxsouls = true

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chester_body"
	inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_PACKIMBAGGIMS_HEALTH)
	inst.components.health:StartRegen(TUNING.KYNO_PACKIMBAGGIMS_REGEN_AMOUNT, TUNING.KYNO_PACKIMBAGGIMS_REGEN_PERIOD)

    inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_PACKIMBAGGIMS_WALKSPEED
	inst.components.locomotor:SetAllowPlatformHopping(false)
	inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("packimbaggims")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	
	inst:SetStateGraph("SGpackimbaggims")
	inst.sg:GoToState("idle")

	inst:SetBrain(brain)

	inst.PackimState = "NORMAL"
	inst.MorphPackimBaggims = MorphPackimBaggims
	inst.CheckForMorph = CheckForMorph
	inst:ListenForEvent("onclose", CheckForMorph)
	
	inst:ListenForEvent("stopfollowing", OnStopFollowing)
	inst:ListenForEvent("startfollowing", OnStartFollowing)
	
	inst.OnSave = OnSave
	inst.OnPreLoad = OnPreLoad

	MakeHauntableDropFirstItem(inst)
	AddHauntableCustomReaction(inst, OnHaunt, false, false, true)
	MakeSmallBurnableCharacter(inst, "PACKIM_BODY", Vector3(100, 50, 0.5))
	
    return inst
end

local function fxfn(bank, build, scale)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(scale or 1, scale or 1, scale or 1)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("transform")

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false

	return inst
end

local function fxnormal()
	return fxfn("kyno_packimbaggims_feathers", "kyno_packimbaggims_feathers", .5)
end

local function fxfat()
	return fxfn("kyno_packimbaggims_feathers", "kyno_packimbaggims_feathers", .5)
end

local function fxfire()
	return fxfn("kyno_packimbaggims_feathers_fire", "kyno_packimbaggims_feathers_fire")
end

return Prefab("kyno_packimbaggims", fn, assets, prefabs),
Prefab("kyno_packimbaggims_feathers", fxnormal, assets, prefabs),
Prefab("kyno_packimbaggims_feathers_fat", fxfat, assets, prefabs),
Prefab("kyno_packimbaggims_feathers_fire", fxfire, assets, prefabs)