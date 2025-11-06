local assets =
{
	Asset("ANIM", "anim/kyno_whale_tracks.zip"),
	Asset("ANIM", "anim/kyno_whale_bubbles.zip"),
	Asset("ANIM", "anim/kyno_whale_bubbles_follow.zip"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local function GetVerb(inst)
	return "INVESTIGATE"
end

local function AddBubbleFX(inst)
	local fx = SpawnPrefab("kyno_whale_ocean_bubbles_fx")

	fx.entity:SetParent(inst.entity)
	fx.AnimState:SetTime(math.random())
	
	local offset = Vector3(math.random(-1, 1) * math.random(), 0, math.random(-1, 1) * math.random())
	fx.Transform:SetPosition(offset:Get())
end

local function OnInvestigated(inst, doer)
	if TheWorld.components.waterfowlhunter then
		TheWorld.components.waterfowlhunter:OnDirtInvestigated(inst:GetPosition(), doer)
	end
	
	inst.AnimState:PlayAnimation("bubble_pst")
	inst:ListenForEvent("animover", inst.Remove)
end

local function OnHaunt(inst, haunter)
	OnInvestigated(inst, haunter)
	return true
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:SetPhysicsRadiusOverride(6)

	inst.AnimState:SetBank("kyno_whale_tracks")
	inst.AnimState:SetBuild("kyno_whale_tracks")
	inst.AnimState:PlayAnimation("bubble_pre")
	inst.AnimState:PushAnimation("bubble_loop", true)
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)

	inst.SoundEmitter:PlaySound("hof_sounds/common/oceanhunt/bubbles_trail_loop", "bubbles_loop")
	inst.GetActivateVerb = GetVerb

	inst:AddTag("dirtpile")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.no_wet_prefix = true

	if not TheNet:IsDedicated() then
		local numbubbles = math.random(2, 4)
	
		for i = 0, numbubbles do
			AddBubbleFX(inst)
		end
	end
    
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnInvestigated
	inst.components.activatable.inactive = true
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.persists = false

	return inst
end

local function trackfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_whale_bubbles_follow")
	inst.AnimState:SetBuild("kyno_whale_bubbles_follow")
	inst.AnimState:PlayAnimation("bubblepop")
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)

	inst:AddTag("track")
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("ignorewalkableplatforms")
    
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:ListenForEvent("animover", inst.Remove)
	inst.persists = false

	return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	inst.AnimState:SetBank("kyno_whale_bubbles")
	inst.AnimState:SetBuild("kyno_whale_bubbles")
	inst.AnimState:PlayAnimation("bubble_loop", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)

	inst.persists = false

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.SoundEmitter:PlaySound("hof_sounds/common/oceanhunt/bubbles_trail_pop")

	return inst
end

return Prefab("kyno_whale_ocean_bubbles", fn, assets),
Prefab("kyno_whale_ocean_bubbles_fx", fxfn, assets),
Prefab("kyno_whale_ocean_track", trackfn, assets)