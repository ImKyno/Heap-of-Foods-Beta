local assets =
{
	Asset("ANIM", "anim/kyno_truffles.zip"),
}

local prefabs =
{
	-- "kyno_truffles_picked",
}

local function OnPicked(inst)
    if inst.growtask ~= nil then
        inst.growtask:Cancel()
        inst.growtask = nil
    end
	
    inst.AnimState:PlayAnimation("picked")
    inst.rain = 10 + math.random(10)
end

local function OnMakeEmpty(inst)
    inst.AnimState:PlayAnimation("picked")
end

local function OnRegen(inst)	
	inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_down")
end

local function DigUp(inst, chopper)
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end
	
	-- TheWorld:PushEvent("beginregrowth", inst)
	
	-- inst.components.lootdropper:SpawnLootPrefab("kyno_truffles_picked")
	inst:Remove()
end

local function CheckGrow(inst)
    if inst.components.pickable ~= nil and not inst.components.pickable.canbepicked and TheWorld.state.israining then
        inst.rain = inst.rain - 1
		
        if inst.rain <= 0 then
            inst.components.pickable:Regen()
        end
    end
end

local function OnSave(inst, data)
    if inst.rain > 0 then
        data.rain = inst.rain
    end
end

local function OnLoad(inst, data)
    if data and data.rain then
        inst.rain = data.rain or inst.rain
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local s = .8
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:SetBank("kyno_truffles")
	inst.AnimState:SetBuild("kyno_truffles")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("plant")
	inst:AddTag("renewable")
	inst:AddTag("truffles")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	-- inst:AddComponent("workable")
	-- inst.components.workable:SetWorkAction(ACTIONS.DIG)
	-- inst.components.workable:SetOnFinishCallback(DigUp)
	-- inst.components.workable:SetWorkLeft(1)

	-- inst:AddComponent("pickable")
	-- inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	-- inst.components.pickable:SetUp("kyno_truffles_picked", TUNING.KYNO_TRUFFLES_GROWTIME)
	-- inst.components.pickable.onregenfn = OnRegen
	-- inst.components.pickable.onpickedfn = OnPicked
	-- inst.components.pickable.makeemptyfn = OnMakeEmpty
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)

	return inst
end

return Prefab("kyno_truffles", fn, assets, prefabs)