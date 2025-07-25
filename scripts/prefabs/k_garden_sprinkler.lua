-- Garden Sprinkler from TAP.
require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/garden_sprinkler.zip"),
	Asset("ANIM", "anim/sprinkler_fx.zip"),
	Asset("ANIM", "anim/sprinkler_placement.zip"),
	Asset("ANIM", "anim/sprinkler_meter.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local projectile_assets =
{
	Asset("ANIM", "anim/firefighter_projectile.zip"),
}

local prefabs =
{
	"kyno_raindrop",
	"kyno_water_spray",
}

local function SpawnDrop(inst)
	local drop = SpawnPrefab("kyno_raindrop")
	local pt = Vector3(inst.Transform:GetWorldPosition())
	
	local angle = math.random() * 2 * PI
	local dist = math.random() * 5
	local offset = Vector3(dist * math.cos(angle), 0, -dist * math.sin(angle))
	
	drop.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)	
	drop.Transform:SetScale(0.5, 0.5, 0.5)
end

local function TurnOn(inst)
	inst:AddTag("shelter")
	
	inst.on = true
	inst.components.fueled:StartConsuming()
	
	if not inst.waterSpray then
		inst.waterSpray = SpawnPrefab("kyno_water_spray")
		local follower = inst.waterSpray.entity:AddFollower()
		follower:FollowSymbol(inst.GUID, "top", 0, -100, 0)
	end
	
	inst.droptask = inst:DoPeriodicTask(0.2, function() 
		SpawnDrop(inst) 
		SpawnDrop(inst) 
	end)

	inst.spraytask = inst:DoPeriodicTask(0.2, function()
		if inst.components.machine:IsOn() then
			inst.UpdateSpray(inst)
		end
	end)
	
	inst.sg:GoToState("turn_on")
end

local function TurnOff(inst)
	inst:RemoveTag("shelter")
	
	inst.on = false
	inst.components.fueled:StopConsuming()

	if inst.waterSpray then
		inst.waterSpray:Remove()
		inst.waterSpray = nil
	end

	if inst.droptask then
		inst.droptask:Cancel()
		inst.droptask = nil
	end

	if inst.spraytask then
		inst.spraytask:Cancel()
		inst.spraytask = nil
	end

	if inst.moisture_targets then
		for GUID, i in pairs(inst.moisture_targets)do
			i.components.moisture.moisture_sources[inst.GUID] = nil
		end
	end
	
	inst.sg:GoToState("turn_off")
end

local function OnFuelEmpty(inst)
	inst.components.machine:TurnOff()
end

local function OnFuelSectionChange(old, new, inst)
	local fuelAnim = 0
	
	if inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.01 then fuelAnim = "0"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.1 then fuelAnim = "1"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.2 then fuelAnim = "2"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.3 then fuelAnim = "3" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.4 then fuelAnim = "4" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.5 then fuelAnim = "5" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.6 then fuelAnim = "6" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.7 then fuelAnim = "7" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.8 then fuelAnim = "8" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.9 then fuelAnim = "9" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 1 then fuelAnim = "10" 
	end 
		
	if inst then 
		inst.AnimState:OverrideSymbol("swap_meter", "sprinkler_meter", fuelAnim) 
	end
end

local function ontakefuelfn(inst)
	inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/refuel")
	
	local fuelAnim = 0
	if inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.01 then fuelAnim = "0"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.1 then fuelAnim = "1"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.2 then fuelAnim = "2"
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.3 then fuelAnim = "3" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.4 then fuelAnim = "4" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.5 then fuelAnim = "5" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.6 then fuelAnim = "6" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.7 then fuelAnim = "7" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.8 then fuelAnim = "8" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.9 then fuelAnim = "9" 
		elseif inst and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 1 then fuelAnim = "10" 
	end 
	
	if inst then 
		inst.AnimState:OverrideSymbol("swap_meter", "sprinkler_meter", fuelAnim) 
	end
end

local function CanInteract(inst)
	return true
end

local function GetStatus(inst, viewer)
	if inst.on then
		return "ON"
	else
		return "OFF"
	end
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("firesuppressor_idle")
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end

    data.on = inst.on
end

local function OnLoad(inst, data)
	if data and data.burnt and inst.components.burnable and inst.components.burnable.onburnt then
        inst.components.burnable.onburnt(inst)
    end

    inst.on = data.on and data.on or false
end

local function OnLoadPostPass(inst, newents, data)
	-- Ehm what the sigma?
end

local function UpdateSpray(inst)
	OnFuelSectionChange(inst)
	
    local x, y, z = inst.Transform:GetWorldPosition()
	local GARDENING_CANT_TAGS = { "pickable", "stump", "barren", "INLIMBO" } -- "withered",
	local ents = TheSim:FindEntities(x, y, z, 8, nil, GARDENING_CANT_TAGS)

	if not inst.moisture_targets then
		inst.moisture_targets = {}
	end
	
	inst.moisture_targets_old = {}
	
	for GUID, v in pairs(inst.moisture_targets) do
    	inst.moisture_targets_old[GUID] = v
	end
	
    inst.moisture_targets = {} 

    for k, v in pairs(ents) do
		if v.components.moisture ~= nil and v.components.inventory ~= nil and not v.components.inventory:IsWaterproof() then
			v.components.moisture:DoDelta(0.1)		
		end
		
		if v.components.burnable and not (v.components.inventoryitem and v.components.inventoryitem.owner) then
			v.components.burnable:Extinguish()
		end		
		
		if v.components.crop and v.components.crop.task then
			v.components.crop.growthpercent = v.components.crop.growthpercent + (0.001)
		end		

		--[[
		if not (inst.components.growable.targettime == nil and inst.components.growable.pausedremaining == nil) then 
		if v.components.growable ~= nil and v.components.growable:IsGrowing() then
			v.components.growable:ExtendGrowTime(-0.2)
		end
		]]--
	
		if v then
			local a, b, c = v.Transform:GetWorldPosition()
			if inst.components.wateryprotection then
				inst.components.wateryprotection:SpreadProtectionAtPoint(a, b, c, 1)
			end
		end	

		if v.components.witherable and v.components.witherable:IsWithered() then
			v.components.witherable:ForceRejuvenate()
		end	
	end
end

local function OnDeplete(inst)
	-- Ehm what the sigma?
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("hit")
		end
	end
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_impact")
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst.SoundEmitter:KillSound("idleloop")
	
	TurnOff(inst, true)
	inst:Remove()
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_off")
	
	inst.SoundEmitter:PlaySound("hof_sounds/common/sprinkler/place")
end

local PLACER_SCALE = 1.5

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("sprinkler_placement")
            inst.helper.AnimState:SetBuild("sprinkler_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
			
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)

            inst.helper.entity:SetParent(inst.entity)
        end
		
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()	
	minimap:SetIcon("kyno_garden_sprinkler.tex")
	minimap:SetPriority(5)

	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("garden_sprinkler")
	inst.AnimState:SetBuild("garden_sprinkler")
	inst.AnimState:PlayAnimation("idle_off")
	inst.AnimState:OverrideSymbol("swap_meter", "sprinkler_meter", "10")
	
	inst:AddTag("structure")
	inst:AddTag("firesupressor")
	inst:AddTag("gardensprinkler")
	inst:AddTag("tornado_immune") -- THANKS LEONIDAS
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end
	
	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end	
	
	inst.on = false
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled.ontakefuelfn = ontakefuelfn
	inst.components.fueled:InitializeFuelLevel(350)
	inst.components.fueled:SetSections(10)
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled.bonusmult = 5
	inst.components.fueled.accepting = true
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("wateryprotection")
	inst.components.wateryprotection.extinguishheatpercent = -3
	inst.components.wateryprotection.temperaturereduction = 0
	inst.components.wateryprotection.witherprotectiontime = 60
	inst.components.wateryprotection.addwetness = 1
	inst.components.wateryprotection.protection_dist = 4
	inst.components.wateryprotection:AddIgnoreTag("player")
	inst.components.wateryprotection.onspreadprotectionfn = OnDeplete
	
	inst:SetStateGraph("SGgardensprinkler")

	inst.moisturizing = 2
	inst.UpdateSpray = UpdateSpray
	inst.waterSpray = nil

	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass
    inst.OnEntitySleep = OnEntitySleep

	MakeSnowCovered(inst, .01)
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

local function placerfn(inst)
    local placer2 = CreateEntity()

    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("garden_sprinkler")
    placer2.AnimState:SetBuild("garden_sprinkler")
    placer2.AnimState:PlayAnimation("idle_off")
	placer2.AnimState:OverrideSymbol("swap_meter", "sprinkler_meter", "10")
	placer2.AnimState:Hide("snow")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)
end

return Prefab("kyno_garden_sprinkler", fn, assets, prefabs),
MakePlacer("kyno_garden_sprinkler_placer", "sprinkler_placement", "sprinkler_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placerfn)