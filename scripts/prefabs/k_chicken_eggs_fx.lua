local assets =
{
	Asset("ANIM", "anim/kyno_chicken_eggs_large.zip"),
	Asset("ANIM", "anim/slingshotammo_slow_fx.zip"),
}

local function AnimName(inst, anim, overridelevel)
	return string.format("slow_%s_%s_%d", anim, inst._size, overridelevel or inst._level)
end

local function StartFX(inst, target, delay)
	if inst._inittask and target and target:IsValid() then
		inst._inittask:Cancel()
		
		if delay then
			inst._inittask = inst:DoTaskInTime(delay, StartFX, target)
		else
			inst._inittask = nil
			inst._size = (target:HasTag("smallcreature") and "small") or (target:HasAnyTag("largecreature") and "large") or "med"

			inst.AnimState:PlayAnimation(AnimName(inst, "pre", 1))
			inst.AnimState:PushAnimation(AnimName(inst, "loop"))
		end
	end
end

local function SetFXLevel(inst, level)
	if not inst.killed and inst._level ~= level then
		inst._level = level
		
		if not inst._inittask then
			inst.AnimState:PlayAnimation(AnimName(inst, "loop"), true)
			inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
		end
	end
end

local function KillFX(inst)
	if inst._inittask then
		inst:Remove()
	elseif not inst.killed then
		inst.killed = true
		inst.AnimState:PlayAnimation(AnimName(inst, "pst"))
		inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), inst.Remove)
	end
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_chicken_eggs_large")
	inst.AnimState:SetBuild("kyno_chicken_eggs_large")
	inst.AnimState:PlayAnimation("used")
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:ListenForEvent("animover", inst.Remove)
	
	return inst
end

local function slowfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("slingshotammo_slow_fx")
	inst.AnimState:SetBuild("slingshotammo_slow_fx")
	inst.AnimState:SetFinalOffset(7)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst._level = 1
	inst._inittask = inst:DoTaskInTime(0, inst.Remove)
	inst.StartFX = StartFX
	inst.SetFXLevel = SetFXLevel
	inst.KillFX = KillFX

	inst.persists = false

	return inst
end

return Prefab("kyno_chicken_egg_fx", fxfn, assets),
Prefab("kyno_chicken_egg_slow_fx", slowfn, assets)