require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/ant_chest.zip"),
	Asset("ANIM", "anim/ant_chest_nectar_build.zip"),
	Asset("ANIM", "anim/ant_chest_honey_build.zip"),
	Asset("ANIM", "anim/ui_antchest_honeycomb.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs = 
{
	"honey",
	"kyno_nectar_pod",
}

local function TestItemInside(inst, item, slot)
	return item.prefab == "honey" or item.prefab == "kyno_nectar_pod"
end

local function OnOpen(inst) 
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("waterlogged1/common/use_figjam")
	end
end

local function OnClose(inst, doer)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("waterlogged1/common/use_figjam")
	end
end

local function OnHammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	
	if inst.components.container then 
		inst.components.container:DropEverything() 
	end
	
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
		inst.SoundEmitter:PlaySound("waterlogged1/common/use_figjam")
		
		if inst.components.container then 
			inst.components.container:DropEverything() 
			inst.components.container:Close()
		end
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("close")
	inst.AnimState:PushAnimation("closed", true)
	inst.SoundEmitter:PlaySound("hof_sounds/common/antchest/place")
end

local function OnBurnt(inst)
	DefaultBurntStructureFn(inst)
	inst:DoTaskInTime(1.2, inst.Remove)
end

local function RefreshAntChestBuild(inst, minimap)
    local containsHoney = inst.components.container:Has("honey", 1)
	local containsNectar = inst.components.container:Has("kyno_nectar_pod", 1)
	local containsHoneyItem = inst.components.container:HasItemWithTag("honeyed", 1)
	
    if containsHoney then
        inst.AnimState:SetBuild("ant_chest_honey_build")
        minimap:SetIcon("kyno_antchest_honey.tex")
		inst.Light:Enable(true)
		
    elseif containsNectar then
		inst.AnimState:SetBuild("ant_chest_nectar_build")
		minimap:SetIcon("kyno_antchest_nectar.tex")
		inst.Light:Enable(false)
	
	elseif containsHoneyItem then
		inst.AnimState:SetBuild("ant_chest_honey_build")
        minimap:SetIcon("kyno_antchest_honey.tex")
		inst.Light:Enable(true)
		
	else 
        inst.AnimState:SetBuild("ant_chest")
        minimap:SetIcon("kyno_antchest_empty.tex")
		inst.Light:Enable(false)
    end
end

local function OnSave(inst, data)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		data.burnt = true
	end
	
	if inst.honeyWasLoaded then
		data.honeyWasLoaded = inst.honeyWasLoaded
	end
end

local function OnLoad(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local light = inst.entity:AddLight()
	light:SetFalloff(.9)
	light:SetIntensity(.5)
	light:SetRadius(.9)
	light:SetColour(185/255, 185/255, 20/255)
	light:Enable(false)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_antchest_empty.tex")
	
	inst.AnimState:SetBank("ant_chest")
	inst.AnimState:SetBuild("ant_chest")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("chest")
	inst:AddTag("structure")
	inst:AddTag("antchest")
	inst:AddTag("cook_robot_storage_valid")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if not inst:HasTag("burnt") then
				inst.replica.container:WidgetSetup("honeydeposit") 
			end
		end
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_ANTCHEST_PERISH_MULT)
	
	inst:AddComponent("container")
    inst.components.container:WidgetSetup("honeydeposit")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeMediumBurnable(inst, nil, nil, true)
	inst.components.burnable.onburnt = OnBurnt
    MakeLargePropagator(inst)
	
	AddHauntableDropItemOrWork(inst)
   
	inst:ListenForEvent("onbuilt", OnBuilt)
    inst:ListenForEvent("itemget", function() RefreshAntChestBuild(inst, minimap) end)
	inst:ListenForEvent("itemlose", function() RefreshAntChestBuild(inst, minimap) end)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_antchest", fn, assets, prefabs),
MakePlacer("kyno_antchest_placer", "ant_chest", "ant_chest", "closed")