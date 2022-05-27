local assets =
{
	Asset("ANIM", "anim/quagmire_rubble.zip"),
	Asset("ANIM", "anim/kyno_swamphouses.zip"),
}

local names = {"f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9"}

local function SetAnim(inst, anim)
	inst.anim = anim
	inst.AnimState:PlayAnimation("idle" .. anim)
end

local function OnSave(inst, data)
    data.anim = inst.animname
end

local function OnLoad(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function FindElder(inst)
	if not inst.elder or not inst.elder:IsValid() then
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 100)
        inst.elder = nil
        for k,v in pairs(ents) do
            if v.prefab == 'kyno_serenityisland_shop' then
                inst.elder = v
                break
            end
        end
    end
    return inst.elder
end

local function Say(inst, str)
	inst.components.talker:Chatter(str, math.random(#STRINGS[str]))
end

local function ElderSayThanks(inst)
	local pigelder = FindElder(inst)
	if pigelder then
		-- pigelder.components.talker:Say("THANKS FOR REPAIRING MY OLD POT, LITTLE GOAT!")
		Say(pigelder, "PIGELDER_TALK_REPAIRPOT")
		pigelder.components.craftingstation:LearnItem("kyno_saphealer", "kyno_saphealer_p")
	end
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item.prefab == "kyno_repairtool" then
		return true -- Accept the Item.
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item.prefab == "kyno_repairtool" then
		local pot = SpawnPrefab("kyno_cookware_elder")
		pot.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		local pot_fx = SpawnPrefab("collapse_small")
		pot_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		ElderSayThanks(inst)
		-- inst:PushEvent("elderpot_repaired")
	end
	inst:Remove()
end

local s = .75

local function rubblefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
    inst.AnimState:SetBank("quagmire_rubble")
    inst.AnimState:SetBuild("quagmire_rubble")
    
	inst:AddTag("DECOR")
    inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks"})
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
    return inst
end

local function rubble2fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1, 1.2)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_serenityisland_decor2.tex")
	
	inst.AnimState:SetBank("kyno_swamphouses")
    inst.AnimState:SetBuild("kyno_swamphouses")
    inst.AnimState:PlayAnimation("rubble")

	inst:AddTag("elderpot_rubble")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	return inst
end

return Prefab("kyno_serenityisland_decor", rubblefn, assets),
Prefab("kyno_serenityisland_decor2", rubble2fn, assets)