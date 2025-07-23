local assets =
{
    Asset("ANIM", "anim/smoke_plants.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = .85
	inst.AnimState:SetScale(s, s, s)

    inst.AnimState:SetBank("smoke_out")
    inst.AnimState:SetBuild("smoke_plants")
    inst.AnimState:PlayAnimation("smoke_loop", true)
    -- inst.AnimState:SetFinalOffset(2)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("kyno_smoketrail", fn, assets)