local assets =
{
    Asset("ANIM", "anim/cavein_dust_fx.zip"),
}

local function OnInit(inst)
	inst.SoundEmitter:PlaySound("aqol/new_test/cloth")
end

local function OnRemove(inst)
	if inst.Follower ~= nil then
		inst.Follower:StopFollowing()
	end
	
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("cavein_dust_fx")
	inst.AnimState:SetBuild("cavein_dust_fx")
	inst.AnimState:PlayAnimation("dust_low", true)
	inst.AnimState:SetFinalOffset(3)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:DoTaskInTime(0, OnInit)
	inst:DoTaskInTime(45 * FRAMES, OnRemove)

	return inst
end

local function whitefx()
	local inst = fn()
	
	inst.AnimState:SetMultColour(1.3, 1.3, 1.3, 0.5)
	
	return inst
end

local function pinkfx()
	local inst = fn()
	
	inst.AnimState:SetMultColour(0.85, 0.35, 0.75, 0.5)

	return inst
end

local function orangefx()
	local inst = fn()
	
	inst.AnimState:SetMultColour(1, 0.50, 0.15, 0.5)
	
	return inst
end

local function brownfx()
	local inst = fn()
	
	inst.AnimState:SetMultColour(0.35, 0.20, 0.10, 0.5)
	
	return inst
end

return Prefab("kyno_hofbirthday_cake_fx_white", whitefx, assets),
Prefab("kyno_hofbirthday_cake_fx_pink", pinkfx, assets),
Prefab("kyno_hofbirthday_cake_fx_orange", orangefx, assets),
Prefab("kyno_hofbirthday_cake_fx_brown", brownfx, assets)