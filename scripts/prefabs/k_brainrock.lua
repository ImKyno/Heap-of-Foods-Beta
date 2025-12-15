local assets =
{
	Asset("ANIM", "anim/kyno_brainrock_rock.zip"),
	Asset("ANIM", "anim/kyno_brainrock_coral.zip"),
	Asset("ANIM", "anim/kyno_brainrock_larvae.zip"),
	Asset("ANIM", "anim/kyno_brainrock_nubbin.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_brainrock_coral",
	"kyno_brainrock_larvae",
	"kyno_brainrock_nubbin",
	
	"rocks",
}

local CORAL_STATE = 
{
	FULL = "_full",
	PICKED = "_picked",
	GLOW = "_glow",
}

local min_rad = 2.5
local max_rad = 3
local min_falloff = 0.8
local max_falloff = 0.7
local min_intensity = 0.8
local max_intensity = 0.7

local function PulseLight(inst)
	local s = GetSineVal(0.05, true, inst)
	local rad = Lerp(min_rad, max_rad, s)
	local intentsity = Lerp(min_intensity, max_intensity, s)
	local falloff = Lerp(min_falloff, max_falloff, s)
	
	inst.Light:SetFalloff(falloff)
	inst.Light:SetIntensity(intentsity)
	inst.Light:SetRadius(rad)
end

local function TurnOn(inst, time)
	inst.Light:Enable(true)

	local s = GetSineVal(0.05, true, inst, time)
	local rad = Lerp(min_rad, max_rad, s)
	local intentsity = Lerp(min_intensity, max_intensity, s)
	local falloff = Lerp(min_falloff, max_falloff, s)

	local startpulse = function()
		inst.light_pulse = inst:DoPeriodicTask(0.1, PulseLight)
	end

	inst.components.lighttweener:StartTween(inst.Light, rad, intentsity, falloff, nil, time, startpulse)
end

local function TurnOff(inst, time)
	if inst.light_pulse ~= nil then
		inst.light_pulse:Cancel()
		inst.light_pulse = nil
	end

	local lightoff = function()
		inst.Light:Enable(false)
	end

	inst.components.lighttweener:StartTween(inst.Light, 0, 0, nil, nil, time, lightoff)
end

local function OnPhase(inst, phase)
	local picked = inst.coralstate == CORAL_STATE.PICKED

	if not picked then
		if phase ~= "day" and inst.coralstate ~= CORAL_STATE.GLOW then
			TurnOn(inst, 5)
			
			inst.coralstate = CORAL_STATE.GLOW
            
			inst.AnimState:PlayAnimation("glow_pre")
			inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
		elseif phase == "day" and inst.coralstate == CORAL_STATE.GLOW then
			TurnOff(inst, 5)
			
			inst.coralstate = CORAL_STATE.FULL
			
			inst.AnimState:PushAnimation("glow_pst", false)
			inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
		end
	end
end

local function GetRegenTime(inst)
	if inst.components.pickable ~= nil then
		return TUNING.KYNO_BRAINROCK_ROCK_REGROW
	end
end

local function MakeFull(inst)
	local picked = inst.coralstate == CORAL_STATE.PICKED
	
	inst.coralstate = CORAL_STATE.FULL
	
	inst.AnimState:PlayAnimation("regrow")
	inst.AnimState:PushAnimation("idle"..inst.coralstate, true)

	if not TheWorld.state.isday and not picked then
		TurnOn(inst, 5)
		
		inst.coralstate = CORAL_STATE.GLOW
		
		inst.AnimState:PlayAnimation("glow_pre")
		inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
	end
end

local function OnPicked(inst, picker)
	if inst.components.pickable ~= nil then
		if inst.coralstate == CORAL_STATE.GLOW then
			TurnOff(inst, 1)
		end
		
		inst.coralstate = CORAL_STATE.PICKED

		inst.AnimState:PlayAnimation("picked")
		inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
    end
end

local function MakeEmpty(inst)
	inst.coralstate = CORAL_STATE.PICKED
	inst.AnimState:PlayAnimation("idle_picked", true)
end

local function OnRegen(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

local function OnHammered(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.components.lootdropper:DropLoot()
	
	if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end
	
	inst:Remove()
end

local function OnHit(inst)
	inst.AnimState:PlayAnimation("hit"..inst.coralstate)
	inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
end

local function SanityAura(inst, observer)
	return inst.coralstate == CORAL_STATE.GLOW and TUNING.SANITYAURA_SMALL or 0
end

local function GrowSprout(inst)
	local sprout = SpawnPrefab("kyno_brainrock_rock")
	sprout.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
	sprout.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local fx = SpawnPrefab("ocean_splash_med1")
	fx.Transform:SetPosition(sprout.Transform:GetWorldPosition())
	
	inst:Remove()
end

local function OnSave(inst, data)
	data.coralstate = inst.coralstate
end

local function OnLoad(inst, data)
	inst.coralstate = data and data.coralstate or CORAL_STATE.FULL

	if inst.coralstate == CORAL_STATE.GLOW then
		inst.AnimState:PlayAnimation("glow_pre")
		inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
		
		TurnOn(inst, 0)
	elseif inst.coralstate == CORAL_STATE.PICKED then
		inst.AnimState:PushAnimation("idle"..inst.coralstate, true)
	end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
	local boat_physics = data.other.components.boatphysics

	if boat_physics ~= nil then
		local hit_velocity = math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5
		
		if hit_velocity >= 1.5 then
			inst.components.workable:WorkedBy(data.other, math.floor(hit_velocity) * TUNING.KYNO_BRAINROCK_ROCK_MINE)
		end
	end
end

local function OnPreLoad(inst, data)
	WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_BRAINROCK_ROCK_GROWTIME)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetColour(210/255, 247/255, 228/255)
	inst.Light:Enable(false)
	inst.Light:SetIntensity(0)
	inst.Light:SetFalloff(0.7)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_brainrock_rock.tex")

	MakeWaterObstaclePhysics(inst, 0.5, 1, 0.85)
	inst:SetPhysicsRadiusOverride(1)

	inst.AnimState:SetBank("kyno_brainrock_rock")
	inst.AnimState:SetBuild("kyno_brainrock_rock")
	inst.AnimState:PlayAnimation("idle_full", true)

	inst:AddTag("plant")
	inst:AddTag("donotautopick")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lighttweener")
	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = SanityAura
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks", "rocks", "rocks", "kyno_brainrock_larvae"})
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_BRAINROCK_ROCK_GROWTIME, true)
	inst.components.pickable:SetUp("kyno_brainrock_coral", TUNING.KYNO_BRAINROCK_ROCK_GROWTIME)
	inst.components.pickable.GetRegenTime = GetRegenTime
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.makeemptyfn = MakeEmpty
	inst.components.pickable.makefullfn = MakeFull

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

    inst.coralstate = CORAL_STATE.FULL

	inst:WatchWorldState("phase", OnPhase)
	inst:ListenForEvent("on_collide", OnCollide)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad

    return inst
end

local function metterfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

	inst.AnimState:SetBank("kyno_brainrock_coral")
	inst.AnimState:SetBuild("kyno_brainrock_coral")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("meat")
	inst:AddTag("brainmetter")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_brainrock_coral"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BRAINROCK_CORAL_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BRAINROCK_CORAL_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BRAINROCK_CORAL_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function larvaefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_brainrock_larvae")
	inst.AnimState:SetBuild("kyno_brainrock_larvae")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("molebait")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_brainrock_larvae"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = MATERIALS.STONE
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH

	MakeHauntableLaunch(inst)
	
	return inst
end

local function sproutfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_brainrock_sprout.tex")

	MakeWaterObstaclePhysics(inst, 0.5, 1, 0.85)
	inst:SetPhysicsRadiusOverride(3)
	
	MakeInventoryFloatable(inst, "med", 0.1, {1.2, 1, 1.2})
	inst.components.floater:SetIsObstacle()
	inst.components.floater.bob_percent = 0

	inst.AnimState:SetBank("kyno_brainrock_nubbin")
	inst.AnimState:SetBuild("kyno_brainrock_nubbin")
	inst.AnimState:PlayAnimation("misc")

	inst:AddTag("plant")
	inst:AddTag("brainsprout")
	
	inst:SetPrefabNameOverride("KYNO_BRAINROCK_NUBBIN")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
	
	inst:DoTaskInTime(land_time, function(inst)
		inst.components.floater:OnLandedServer()
	end)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_brainrock_sprout_timer", TUNING.KYNO_BRAINROCK_ROCK_SPROUT_GROWTIME)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks", "rocks", "rocks", "kyno_brainrock_nubbin"})
	inst.components.lootdropper.spawn_loot_inside_prefab = true
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_BRAINROCK_ROCK_MINE)

	inst:ListenForEvent("on_collide", OnCollide)
	
	inst:ListenForEvent("timerdone", function(inst, data)
		if data.name == "kyno_brainrock_sprout_timer" then
			GrowSprout(inst)
		end
	end)

    return inst
end

return Prefab("kyno_brainrock_rock", fn, assets, prefabs),
Prefab("kyno_brainrock_coral", metterfn, assets, prefabs),
Prefab("kyno_brainrock_larvae", larvaefn, assets, prefabs),
Prefab("kyno_brainrock_sprout", sproutfn, assets, prefabs)