local function GrowTree(inst)
	local tree = SpawnPrefab(inst.growprefab)
	
	if tree ~= nil then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
		tree.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
		
		inst:Remove()
	end
end

local function StopGrowing(inst)
	inst.components.timer:StopTimer("grow")
end

StartGrowing = function(inst)
	if not inst.components.timer:TimerExists("grow") then
		local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
		inst.components.timer:StartTimer("grow", growtime)
	end
end

local function OnTimerDone(inst, data)
    if data.name == "grow" then
        GrowTree(inst)
    end
end

local function DigUp(inst, digger)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function MakeSapling(data)
	local assets = 
	{
		Asset("ANIM", "anim/"..(data.build or data.name)..".zip"),
	}
	
	local function fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
	
		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation("planted")
		
		inst:AddTag("cattoy")
		
		if data.firerpoof ~= nil then
			inst:AddTag("firerpoof_sapling")
		end
	
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
	
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.growprefab = data.growprefab
		inst.StartGrowing = StartGrowing
		
		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		StartGrowing(inst)
		
		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = data.nameoverride or "PINECONE"
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot(data.loot or {"twigs"})
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(DigUp)
		inst.components.workable:SetWorkLeft(1)
		
		if data.fireproof ~= nil then
			MakeHauntableWork(inst)
		else
			MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
			inst:ListenForEvent("onignite", StopGrowing)
			inst:ListenForEvent("onextinguish", StartGrowing)
			MakeSmallPropagator(inst)
			
			MakeHauntableIgnite(inst)
		end
		
		MakeWaxablePlant(inst)
		
		return inst
	end
	
	return Prefab(data.name, fn, assets)
end

local saplings =
{
	-- Tea Tree
	{
		name       = "kyno_meadowisland_tree_sapling",
		growprefab = "kyno_meadowisland_tree_short",
		bank       = "kyno_meadowisland_tree_sapling",
		build      = "kyno_meadowisland_tree_sapling",
		tags       = {"meadowisland_tree_sapling", "meadowisland_tree"},
		scale      = .75,
	},
	
	-- Sugar Tree
	{
		name       = "kyno_sugartree_sapling",
		growprefab = "kyno_sugartree_short",
		bank       = "kyno_serenityisland_sapling",
		build      = "kyno_serenityisland_sapling",
		tags       = {"kyno_sugartree_sapling", "sugartree"},
		scale      = .75,
	},
	
	-- Palm Tree
	{
		name       = "kyno_kokonuttree_sapling",
		growprefab = "kyno_kokonuttree_short",
		bank       = "kyno_kokonut",
		build      = "kyno_kokonut",
		tags       = {"kokonuttree_sapling", "kokonuttree"},
	},
}

local prefabs = {}
for i, v in ipairs(saplings) do
	table.insert(prefabs, MakeSapling(v))
end

return unpack(prefabs)