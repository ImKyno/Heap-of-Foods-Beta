local assets =
{
	Asset("ANIM", "anim/quagmire_mermcart.zip"),
	
    Asset("ANIM", "anim/kyno_meadowisland_shop.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_crate.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big",
    "merm",
    "boards",
    "rocks",
	
	"kyno_meadowisland_mermcart",
}

local loot =
{
    "boards",
    "rocks",
}

--[[
local function StartSpawning(inst)
    if not inst:HasTag("burnt") and not TheWorld.state.iswinter and not TheWorld.state.isday and inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if not inst:HasTag("burnt") and inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
        if TheWorld.state.isday and inst.components.childspawner ~= nil and 
		inst.components.childspawner:CountChildrenOutside() >= 1 and child.components.combat.target == nil then
            StopSpawning(inst)
        end
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end
]]--

local function OnIsDay(inst, isday, iswinter)
    if TheWorld.state.isday then
        -- StopSpawning(inst)
		inst.Light:Enable(false)
		inst.AnimState:PlayAnimation("idle", true)
    else
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("lit", true)
		-- inst.components.childspawner:ReleaseAllChildren()
		-- StartSpawning(inst)
	end
end

local function OnBuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
    inst.AnimState:PlayAnimation("idle")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(2)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermhut.tex")
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_meadowisland_shop")
    inst.AnimState:SetBuild("kyno_meadowisland_shop")
    inst.AnimState:PlayAnimation("idle", true)  

	inst:AddTag("structure")
    inst:AddTag("sammyhouse")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")

	--[[
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "kyno_meadowisland_vendor"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(1)
	]]--

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	inst:WatchWorldState("isday", OnIsDay)
	-- StartSpawning(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	inst:DoTaskInTime(0, function(inst)
		inst.mermcart = SpawnPrefab("kyno_meadowisland_mermcart")
    
		local x, y, z = inst.Transform:GetWorldPosition()

		local theta = 2 -- math.random() * TWOPI
		local radius = 4
		local x = x + radius * math.cos(theta)
		local z = z - radius * math.sin(theta)

		inst.mermcart.Transform:SetPosition(x, 0, z)
	end)
	
	return inst
end

local function cartfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("kyno_meadowisland_crate")
    inst.AnimState:SetBuild("kyno_meadowisland_crate")
    inst.AnimState:PlayAnimation("idle6", true)
	
	inst.persists = false
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	return inst
end

return Prefab("kyno_meadowisland_shop", fn, assets, prefabs),
Prefab("kyno_meadowisland_mermcart", cartfn, assets, prefabs)