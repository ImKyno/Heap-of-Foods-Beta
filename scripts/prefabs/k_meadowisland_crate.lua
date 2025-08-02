require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/kyno_meadowisland_crate.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small",
	"boards",
	"rope",
	"cutreeds",
	"goldnugget",
	"mandrake",
	"trinket_4",
	"trinket_11",
	"trinket_13",
	"trinket_26",
	
	"kyno_oil",
	"kyno_banana",
	"kyno_tunacan",
	"kyno_tomatocan",
	"kyno_beancan",
	"kyno_meatcan",
	"kyno_sodacan",
	"kyno_cokecan",
	"kyno_energycan",
}

local names = {"idle1", "idle2", "idle3", "idle4", "idle5", "idle6", "idle7", "idle8", "idle9", "idle10"}

local function OnHammered(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	
	local pt = worker and worker:GetPosition() or nil
	
	inst.components.lootdropper:SpawnLootPrefab("boards")
	inst.components.lootdropper:DropLoot()

	if not inst:HasTag("not_meadow_crate") then
		if not inst.components.timer:TimerExists("replenish_crate") then
			inst.components.timer:StartTimer("replenish_crate", TUNING.KYNO_ISLANDCRATE_GROWTIME)
		end
		
		inst:Hide() -- Hide from now on.
		inst:SetPhysicsRadiusOverride(nil)
		inst.Physics:SetActive(false)
		
		if inst.MiniMapEntity then
			inst.MiniMapEntity:SetIcon("")
		end
	else
		inst:Remove()
	end
end

local function OnTimerDone(inst, data)
    if data.name == "replenish_crate" then
        inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
		
		local crate = SpawnPrefab("kyno_meadowisland_crate")
		crate.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		inst:Remove() -- Remove the last crate.
    end
end

local function OnWorkedInventory(inst, worker)
    local loot = {}
	
    if inst.sunkeninventory ~= nil then
        for k,v in pairs(inst.sunkeninventory) do
            local pref = SpawnPrefab(v.prefab)
            pref:SetPersistData(v.data, {})
            table.insert(loot, pref)
        end
    end
	
    OnHammered(inst, worker, loot)
end

local function OnIgnite(inst)
	if inst.components.timer:TimerExists("replenish_crate") then
		inst.components.timer:StopTimer("replenish_crate")
	end

    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
end

local function OnBurnt(inst, worker)
	local pt = worker and worker:GetPosition() or nil
	
	if inst.components.pickable ~= nil then
		inst.components.pickable.canbepicked = false
	end
	
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	
    inst:Remove()
end

local function OnSave(inst, data)
	data.anim = inst.animname
	
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname, true)
    end
	
	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_crate.tex")
	
	inst:SetPhysicsRadiusOverride(.7)
	MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.AnimState:SetBank("kyno_meadowisland_crate")
    inst.AnimState:SetBuild("kyno_meadowisland_crate")
	
	inst:AddTag("blocker")
	inst:AddTag("meadow_crate")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("timer")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	local rarity = 
	{
		verylow 	= 64,
		low			= 32,
		med			= 16,
		high		= 8,
		veryhigh	= 4,
		extreme		= 1,
		easteregg	= .1,
    }
	
	inst.components.lootdropper:AddRandomLoot("boards",      		 rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("cutreeds",            rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("rope",                rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("goldnugget",          rarity.verylow)
	inst.components.lootdropper:AddRandomLoot("kyno_tunacan",            rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_tomatocan",          rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_meatcan",            rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_beancan",            rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_sodacan",            rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_cokecan",            rarity.med)
	inst.components.lootdropper:AddRandomLoot("kyno_energycan",          rarity.med)
	inst.components.lootdropper:AddRandomLoot("trinket_4",              rarity.high)
	inst.components.lootdropper:AddRandomLoot("trinket_11",             rarity.high)
	inst.components.lootdropper:AddRandomLoot("trinket_13",             rarity.high)
	inst.components.lootdropper:AddRandomLoot("trinket_26",             rarity.high)
	inst.components.lootdropper:AddRandomLoot("kyno_oil",           rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("kyno_banana",        rarity.veryhigh)
	inst.components.lootdropper:AddRandomLoot("mandrake", 	         rarity.extreme)
	
	inst.components.lootdropper.numrandomloot = 1
	
	if math.random() < 0.05 then
		inst.components.lootdropper:AddChanceLoot("kyno_mysterymeat", 		   1.00)
	end
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst.sunkeninventory = {}
	
	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
	MakeSmallPropagator(inst)
	
	AddToRegrowthManager(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("kyno_meadowisland_crate", fn, assets, prefabs)