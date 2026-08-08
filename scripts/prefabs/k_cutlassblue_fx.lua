local assets =
{
	Asset("ANIM", "anim/kyno_bluecutlass_fx.zip"),
	Asset("ANIM", "anim/kyno_bluecutlass_crackleandpop.zip"),
}

local MAXRANGE           = 3
local NO_TAGS_NO_PLAYERS = { "INLIMBO", "cutlassblue", "notarget", "noattack", "invisible", "wall", "player", "companion" }
local NO_TAGS            = { "INLIMBO", "cutlassblue", "notarget", "noattack", "invisible", "wall", "playerghost" }
local COMBAT_TARGET_TAGS = { "_combat" }

local function OnUpdateFlock(inst)
	if inst.target ~= nil and inst.target:IsValid() then
		inst.Transform:SetPosition(inst.target.Transform:GetWorldPosition())
	end

	inst.range = inst.range + TUNING.KYNO_CUTLASSBLUE_FLOCK_RANGE

	local x, y, z = inst.Transform:GetWorldPosition()

	for i, v in ipairs(TheSim:FindEntities(x, y, z, inst.range + 3, COMBAT_TARGET_TAGS, 
	inst.canhitplayers and NO_TAGS or NO_TAGS_NO_PLAYERS)) do
		if not inst.ignore[v] and v:IsValid() and v.entity:IsVisible() and v.components.combat ~= nil
		and not (v.components.inventory ~= nil and v.components.inventory:EquipHasTag("cutlassblue")) then
			local range = inst.range + v:GetPhysicsRadius(0)

			if v:GetDistanceSqToPoint(x, y, z) < range * range then
				if inst.owner ~= nil and not inst.owner:IsValid() then
					inst.owner = nil
				end

				if inst.owner ~= nil then
					if inst.owner.components.combat ~= nil and inst.owner.components.combat:CanTarget(v)
					and not inst.owner.components.combat:IsAlly(v) then
						inst.ignore[v] = true
						v.components.combat:GetAttacked(v.components.follower
						and v.components.follower:GetLeader() == inst.owner and inst or inst.owner, inst.damage, nil, nil, inst.spdmg)
					end
				elseif v.components.combat:CanBeAttacked() then
					local isally = false

					if not inst.canhitplayers then
						local leader = v.components.follower ~= nil and v.components.follower:GetLeader() or nil

						isally = leader ~= nil and leader:HasTag("player") and not (v.components.combat ~= nil
						and v.components.combat.target ~= nil and v.components.combat.target:HasTag("player"))
					end

					if not isally then
						inst.ignore[v] = true
						v.components.combat:GetAttacked(inst, inst.damage, nil, nil, inst.spdmg)
					end
				end
			end
		end
	end

	if inst.range >= MAXRANGE then
		inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateFlock)
	end
end

local function SetFXTarget(inst, owner, target)
	inst.Transform:SetPosition(target.Transform:GetWorldPosition())

	inst.owner = owner
	inst.target = target

	inst.canhitplayers = not owner:HasTag("player") or TheNet:GetPVPEnabled()

	inst.ignore[owner] = true
	inst.ignore[target] = true -- This means that the target doesn't receive damage, only the entities around it.
end

local function fn(planardamage)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetScale(.8, .8, .8)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("kyno_bluecutlass_crackleandpop")
	inst.AnimState:SetBuild("kyno_bluecutlass_crackleandpop")
	inst.AnimState:PlayAnimation("pop")

	inst:AddTag("FX")
	inst:AddTag("thorny")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddOnUpdateFn(OnUpdateFlock)

	inst:ListenForEvent("animover", inst.Remove)

	inst.persists = false

	inst.damage = TUNING.KYNO_CUTLASSBLUE_FLOCK_DAMAGE
	inst.spdmg = planardamage and { planar = TUNING.KYNO_CUTLASSBLUE_FLOCK_DAMAGE_PLANAR } or nil
	inst.range = TUNING.KYNO_CUTLASSBLUE_FLOCK_RANGE

	inst.ignore = {}
	inst.canhitplayers = true
	inst.SetFXTarget = SetFXTarget

	return inst
end

return Prefab("kyno_cutlassblue_fx", fn, assets)