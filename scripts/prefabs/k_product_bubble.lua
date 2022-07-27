local assets = 
{
	Asset("ANIM", "anim/kyno_product_bubble.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
}

local s = 1.5

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

    inst.AnimState:SetBank("kyno_product_bubble")
    inst.AnimState:SetBuild("kyno_product_bubble")
    inst.AnimState:PlayAnimation("idle", false)
	
	inst:AddTag("NOCLICK")
    inst:AddTag("DECOR")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst.persists = false

    return inst
end

return Prefab("kyno_product_bubble", fn, assets)