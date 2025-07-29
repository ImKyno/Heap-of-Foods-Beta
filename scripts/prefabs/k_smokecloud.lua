local assets =
{
    Asset("ANIM", "anim/fx_book_rain.zip"),
}

local s = .60

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	inst.AnimState:SetMultColour(1, 1, 1, .7)

    inst.AnimState:SetBank("fx_book_rain")
    inst.AnimState:SetBuild("fx_book_rain")
    inst.AnimState:PlayAnimation("play_fx", false)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("kyno_smokecloud", fn, assets)