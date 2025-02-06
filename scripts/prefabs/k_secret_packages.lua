local assets =
{
	Asset("ANIM", "anim/hermit_bundle.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_koi",
	"kyno_grouper",
	"kyno_pierrotfish",
	"kyno_neonfish",
	"kyno_tropicalfish",
	
	"kyno_chicken2",
	"kyno_piko",
	"kyno_piko_orange",
	"kyno_sugarfly",
}

local function OnOpenPackage(inst, pos, doer)
	local fishloot = 
	{ 
		"kyno_koi",
		"kyno_grouper",
		"kyno_pierrotfish",
		"kyno_neonfish",
		"kyno_tropicalfish",
	}
	
	local mobloot =
	{
		"kyno_chicken2",
		"kyno_piko",
		"kyno_piko_orange",
		"kyno_sugarfly",
	}
	
	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
	else
		inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
	end

	if inst:HasTag("secretpackage_fish") then
		for k, v in pairs(fishloot) do
			local fish = SpawnPrefab(v)
	
			if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
			and not doer:HasTag("playerghost") then 
				doer.components.inventory:GiveItem(fish) 
			else
				fish.Transform:SetPosition(pos:Get())
				fish.components.inventoryitem:OnDropped(false, .5)
			end
		end
	else
		for k, v in pairs(mobloot) do
			local mob = SpawnPrefab(v)
	
			if doer.components.inventory and doer:HasTag("player") and not doer.components.health:IsDead() 
			and not doer:HasTag("playerghost") then 
				doer.components.inventory:GiveItem(mob) 
			else
				mob.Transform:SetPosition(pos:Get())
				mob.components.inventoryitem:OnDropped(false, .5)
			end
		end
	end
	
	inst:Remove()
end

local function packagefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("hermit_bundle")
    inst.AnimState:SetBuild("hermit_bundle")
    inst.AnimState:PlayAnimation("idle_onesize")
	
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
        
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "HERMIT_BUNDLE"
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"
	inst.components.inventoryitem.imagename = "hermit_bundle"

    inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenPackage)
	
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)

    return inst
end

local function fishpackage()
	local inst = packagefn()
	
	inst:AddTag("secretpackage_fish")
	return inst
end

local function mobpackage()
	local inst = packagefn()
	
	inst:AddTag("secretpackage_mobs")
	return inst
end

return Prefab("kyno_fishpackage", fishpackage, assets, prefabs),
Prefab("kyno_mobpackage", mobpackage, assets, prefabs)