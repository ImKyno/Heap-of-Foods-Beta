local assets =
{
	Asset("ANIM", "anim/raindrop.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBuild("raindrop")
    inst.AnimState:SetBank("raindrop")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCKER")
    
	inst.entity:SetCanSleep(false)
    inst.persists = false
	
	inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("kyno_raindrop", fn, assets)