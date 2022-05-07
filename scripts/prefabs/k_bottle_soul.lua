local assets =
{
	Asset("ANIM", "anim/kyno_bottle_soul.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
    "wortox_soul",
}    

local function OnLanded(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
		inst.AnimState:PlayAnimation("idle_empty_water")
	else
		inst.AnimState:PlayAnimation("idle_empty")
	end
end

local function OnInventory(inst, owner)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner:HasTag("soulstealer") then
		inst.components.unwrappable.canbeunwrapped = true
	else
		inst.components.unwrappable.canbeunwrapped = false
	end
end

local function OnGround(inst)
	inst.components.unwrappable.canbeunwrapped = false
end

local function OnOpenBottle(inst, pos, doer)
	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn")
	else
		inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn")
	end

	local soul = SpawnPrefab("wortox_soul")
	local bottle = SpawnPrefab("messagebottleempty")
	
	if doer.components.inventory and doer:HasTag("player") and doer:HasTag("soulstealer") 
	and not doer.components.health:IsDead() and not doer:HasTag("playerghost") then 
		doer.components.inventory:GiveItem(soul)
		doer.components.inventory:GiveItem(bottle)
	else
		soul.Transform:SetPosition(pos:Get())
		soul.components.inventoryitem:OnDropped(true)
		
		bottle.Transform:SetPosition(pos:Get())
		bottle.components.inventoryitem:OnDropped(false, .5)
	end
	
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("kyno_bottle_soul")
    inst.AnimState:SetBuild("kyno_bottle_soul")
    inst.AnimState:PlayAnimation("idle_empty")
	
	inst:AddTag("bottled_soul")
    
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
        
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bottle_soul"

    inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnOpenBottle)
	inst.components.unwrappable.canbeunwrapped = false
	
	inst:ListenForEvent("on_landed", OnLanded)
	inst:ListenForEvent("onputininventory", OnInventory)
	inst:ListenForEvent("ondropped", OnGround)

    return inst
end

return Prefab("kyno_bottle_soul", fn, assets, prefabs)