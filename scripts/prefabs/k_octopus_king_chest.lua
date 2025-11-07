local assets =
{
	Asset("ANIM", "anim/kyno_octopusking_chest.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"collapse_small",
}

local DAMAGE_SCALE = 0.5

local function OnOpen(inst) 
	inst.AnimState:PlayAnimation("open")
	inst.AnimState:PushAnimation("opened", true)

	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function OnClose(inst)
	inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

	if not inst.components.container:IsEmpty() then
		inst.AnimState:PushAnimation("closed", true)
	else
		inst.AnimState:PushAnimation("sink", false)
		
		inst.components.container:DestroyContents()
		inst.components.container.canbeopened = false

		inst:DoTaskInTime(96 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
		end)

		inst:ListenForEvent("animqueueover", inst.Remove)
	end
end

local function InWaterCheck(inst)
	if TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition()) 
	and not TheWorld.Map:GetPlatformAtPoint(inst.Transform:GetWorldPosition()) then
		return true
	end

	inst.components.container:DropEverything()
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	inst:Remove()
	
	return false
end

local function ChangeToWaterChestPhysics(inst)
	MakeWaterObstaclePhysics(inst, .5, 1, 1)
	inst.no_wet_prefix = true
end

local function OnLanded(inst, data)
	if InWaterCheck(inst) then
		ChangeToWaterChestPhysics(inst)
	end
end

local function OnCollide(inst, data)
	local boat_physics = data.other.components.boatphysics

	if boat_physics ~= nil then
		local hit_velocity = math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity
		
		if hit_velocity >= 0.7 then
			inst.AnimState:PushAnimation("sink", false)
			
			inst.components.container:DropEverything()
			inst.components.container.canbeopened = false
                    
			inst:DoTaskInTime(96 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
			end)
        
			inst:ListenForEvent("animqueueover", inst.Remove)
        end
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:SetDeploySmartRadius(0.5)
	
	ChangeToWaterChestPhysics(inst)
	MakeInventoryPhysics(inst)
	
	inst:SetPhysicsRadiusOverride(1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_octopusking_treasurechest.tex")

	inst.AnimState:SetBank("kyno_octopusking_chest")
	inst.AnimState:SetBuild("kyno_octopusking_chest")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("chest")
	inst:AddTag("octopustraderchest")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("octopustraderchest")
		end
		
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("octopustraderchest")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetSinks(false)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	if not POPULATING then
		inst:DoTaskInTime(0, InWaterCheck)
	end

	inst:ListenForEvent("on_landed", OnLanded)
	inst:ListenForEvent("on_collide", OnCollide)
	
	inst.OnLoadPostPass = InWaterCheck
	
	AddHauntableDropItemOrWork(inst)

	return inst
end

return Prefab("kyno_octopusking_treasurechest", fn, assets, prefabs)