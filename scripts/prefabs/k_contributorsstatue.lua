local assets =
{
	Asset("ANIM", "anim/kyno_dailyrecipe_sign.zip"),
}

local function OnActivate(inst, doer)
	if doer ~= nil and doer:HasTag("player") then
		doer:ShowPopUp(POPUPS.CONTRIBUTORS, true)
	end

	if inst.components.activatable ~= nil then
		inst.components.activatable.inactive = true
	end
end

local function GetVerb()
	return "DAILYRECIPE" -- "See" verb.
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dailyrecipe_sign.tex")

	MakeObstaclePhysics(inst, .4)

	inst.AnimState:SetBank("kyno_dailyrecipe_sign")
	inst.AnimState:SetBuild("kyno_dailyrecipe_sign")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")

	inst.GetActivateVerb = GetVerb

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.quickaction = true

	MakeSnowCovered(inst)
	SetLunarHailBuildupAmountSmall(inst)

	return inst
end

return Prefab("kyno_contributorsstatue", fn, assets)