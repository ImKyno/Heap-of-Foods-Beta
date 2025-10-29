local assets =
{
	Asset("ANIM", "anim/kyno_seatrap.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_seaweeds",
	"kyno_jellyfish",
	"kyno_messagebottleempty",
}

local sounds =
{
    close = "dontstarve/common/trap_close",
    rustle = "dontstarve/common/trap_rustle",
}

local function OnHarvested(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_oceantrap.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_oceantrap")
	inst.AnimState:SetBuild("kyno_oceantrap")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("trap")
	inst:AddTag("smalloceancreature_trap")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = sounds

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_oceantrap"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_OCEANTRAP_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_OCEANTRAP_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("trap")
	inst.components.trap.targettag = "smalloceancreature"
	inst.components.trap:SetOnHarvestFn(OnHarvested)
	inst.components.trap.baitsortorder = -1
	
	inst:SetStateGraph("SGoceantrap")
	
	MakeHauntableLaunchAndIgnite(inst)

	return inst
end

return Prefab("kyno_oceantrap", fn, assets, prefabs)