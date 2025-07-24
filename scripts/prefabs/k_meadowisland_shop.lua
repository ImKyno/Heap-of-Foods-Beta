local assets =
{	
    Asset("ANIM", "anim/kyno_meadowisland_shop.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_mermcart.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big",
	"small_puff",
	
	"kyno_meadowisland_mermcart",
	"kyno_meadowisland_trader",
	"kyno_smoketrail",
}

local function StartSpawning(inst)
	if not TheWorld.state.isday and inst.components.childspawner ~= nil then
		inst.components.childspawner:StartSpawning()
	end
end

local function StopSpawning(inst)
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:StopSpawning()
	end
end

local function OnSpawned(inst, child)
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
	if TheWorld.state.isday and inst.components.childspawner ~= nil and inst.components.childspawner:CountChildrenOutside() >= 1 
	and child.components.combat.target == nil then
		StopSpawning(inst)
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

local function OnSeasonChange(inst, season)
	return TheWorld.state.season
end

local function SetHouseArt(inst, season)
	local season = OnSeasonChange(inst)
	
	if TheWorld.state.isday then
		inst.AnimState:PlayAnimation("idle_"..season or "idle", true)
	else
		inst.AnimState:PlayAnimation("lit_"..season or "lit", true)
	end
end

local function SetWagonArt(inst, season)
	local season = OnSeasonChange(inst)

	local fx = SpawnPrefab("small_puff")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx.Transform:SetScale(1.7, 1.7, 1.7)
	
	inst.AnimState:PlayAnimation("idle_"..season or "empty", true)
end

local function SetChimneyFX(inst)
	if not inst.smoketrail then
		inst.smoketrail = SpawnPrefab("kyno_smoketrail")
		inst.smoketrail.persists = false
		inst.smoketrail.entity:SetParent(inst.entity)

		inst.smoketrail.entity:AddFollower()
		inst.smoketrail.Follower:FollowSymbol(inst.GUID, "chimney", 0, 0, 0, true)
	end
end

local function OnIsDay(inst, isday)
	local season = OnSeasonChange(inst)
	
    if TheWorld.state.isday then
        StopSpawning(inst)
		inst.Light:Enable(false)
		inst.AnimState:PlayAnimation("idle_"..season or "idle", true)
    else
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("lit_"..season or "lit", true)
		inst.components.childspawner:ReleaseAllChildren()
		StartSpawning(inst)
	end
end

local function mainfn(oldshop, symbol, offset)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(2.8)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_shop.tex")
	minimap:SetPriority(2)
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_meadowisland_shop")
    inst.AnimState:SetBuild("kyno_meadowisland_shop")
    --inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
    inst:AddTag("sammyhouse")
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("pointofinterest")
        inst.components.pointofinterest:SetHeight(60)
    end
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "kyno_meadowisland_trader"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(10)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(1)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	inst:WatchWorldState("season", SetHouseArt)
	SetHouseArt(inst, TheWorld.state.season)
	
	inst:WatchWorldState("isday", OnIsDay)
	OnIsDay(inst, TheWorld.state.isday)
	-- StartSpawning(inst)
	
	-- inst:DoTaskInTime(0, SetChimneyFX)
	
	-- Doing this for old worlds, new setpiece comes with the cart already.
	if oldshop then
		inst:DoTaskInTime(0, function(inst)
			inst.mermcart = SpawnPrefab("kyno_meadowisland_mermcart")
			inst.mermcart:AddTag("descartablewagon")
			inst.mermcart.persists = false
    
			local x, y, z = inst.Transform:GetWorldPosition()

			local theta = -3 -- -3
			local radius = 4 -- 4
			local x = x + radius * math.cos(theta)
			local z = z - radius * math.sin(theta)

			inst.mermcart.Transform:SetPosition(x, 0, z)
		end)
	end
	
	return inst
end

local function cartfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermcart.tex")
	minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("kyno_meadowisland_mermcart")
    inst.AnimState:SetBuild("kyno_meadowisland_mermcart")
	
	inst:AddTag("sammywagon")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	if inst:HasTag("descartablewagon") then
		inst.persists = false
	end
	
	inst:AddComponent("inspectable")
	
	inst:WatchWorldState("season", SetWagonArt)
	SetWagonArt(inst, TheWorld.state.season)
	
	return inst
end

local function shop1fn()
	local inst = mainfn(true)
	return inst
end

local function shop2fn()
	local inst = mainfn(false)
	
	inst:SetPrefabNameOverride("kyno_meadowisland_shop")
	
	return inst
end

return Prefab("kyno_meadowisland_shop", shop1fn, assets, prefabs),
Prefab("kyno_meadowisland_sammyhouse", shop2fn, assets, prefabs),
Prefab("kyno_meadowisland_mermcart", cartfn, assets, prefabs)