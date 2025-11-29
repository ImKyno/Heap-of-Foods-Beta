local assets =
{
	Asset("ANIM", "anim/kyno_meadowisland_sandhill.zip"),
}

local prefabs =
{
	"antliontrinket",
	"feather_crow",
	"feather_robin",
	"feather_robin_winter",
	"gears",
	"goldnugget",
	"greengem",
	"purplegem",
	"redgem",
	"rocks",
	"slurtle_shellpieces",
	"spidergland",
	"yellowgem",
	
	"kyno_kokonut",
	"kyno_piko",
	"kyno_piko_orange",
}

local StartRegen

local anims = {"low", "med", "full"}
local fullanim = anims[#anims]

local function GetVerb()
    return "DESTROY"
end

local function OnRegen(inst)
	inst.components.activatable.inactive = false

	if inst.components.workable.workleft < #anims-1 then
		inst.components.workable:SetWorkLeft(math.floor(inst.components.workable.workleft)+1)
		StartRegen(inst)
	else
		inst.targettime = nil
	end
end

StartRegen = function(inst, regentime)
	if inst.components.workable.workleft < #anims-1 then
		regentime = regentime or (TUNING.KYNO_MEADOWISLAND_SAND_REGROW + math.random() * TUNING.KYNO_MEADOWISLAND_SAND_REGROW_VARIANCE)

		if TheWorld.state.issummer then
			regentime = regentime / 2
		elseif TheWorld.state.isspring then
			regentime = regentime * 2
		end

		if inst.task then
			inst.task:Cancel()
		end

		inst.task = inst:DoTaskInTime(regentime, OnRegen, "regen")
		inst.targettime = GetTime() + regentime
	else
		if inst.task then
			inst.task:Cancel()
		end

		inst.targettime = nil
	end

	if inst.components.workable.workleft < 1 then
		inst.AnimState:PlayAnimation(anims[1])
	else
		inst.AnimState:PlayAnimation(anims[math.floor(inst.components.workable.workleft)+1])
	end
end

local function OnWorked(inst, worker, workleft, numworks)
    if workleft <= 0 then
        inst.components.activatable.inactive = true
    end

	numworks = math.min(numworks, inst.AnimState:IsCurrentAnimation("med") and 1 or 2)
	local prevworkleft = numworks + workleft
	local spawns = math.min(math.ceil(prevworkleft) - math.ceil(workleft), math.ceil(prevworkleft))

	if spawns > 0 then

		local pt = Vector3(inst.Transform:GetWorldPosition())
		local hispos = Vector3(worker.Transform:GetWorldPosition())
		local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

		if he_right then
			inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*(.5 + math.random())))
		else
			inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5 + math.random())))
		end
	end

    StartRegen(inst)
end

local function OnSave(inst, data)
	if inst.targettime then
		local time = GetTime()

		if inst.targettime > time then
			data.time = math.floor(inst.targettime - time)
		end

		data.workleft = inst.components.workable.workleft
	end
end

local function OnLoad(inst, data)
	if data and data.workleft then
		inst.components.workable.workleft = data.workleft

		if data.workleft <= 0 then
			inst.components.activatable.inactive = true
		end
	end

	if data and data.time then
		StartRegen(inst, data.time)
	end
end

local function LongUpdate(inst, dt)
    if inst.targettime then
        local time = GetTime()
        if inst.targettime > time + dt then
			local time_to_regen = inst.targettime - time - dt
			StartRegen(inst, time_to_regen)
        else
			OnRegen(inst)
        end
    end
end

local function OnWake(inst)
	if TheWorld.state.isspring and TheWorld.state.israining then
		if math.random() < TUNING.KYNO_MEADOWISLAND_SAND_DEPLETE and inst.components.workable.workleft > 0 then
			inst.components.workable.workleft = inst.components.workable.workleft - math.random(0, inst.components.workable.workleft)
			
			if inst.components.workable.workleft <= 0 then
                inst.components.activatable.inactive = true
            end
			
			StartRegen(inst)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_meadowisland_sandhill")
	inst.AnimState:SetBuild("kyno_meadowisland_sandhill")
	inst.AnimState:PlayAnimation(fullanim)

	inst:AddTag("sandhill")

	inst.GetActivateVerb = GetVerb

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(#anims-1)
	inst.components.workable:SetOnWorkCallback(OnWorked)

	inst:AddComponent("activatable")
	inst.components.activatable.inactive = false
	inst.components.activatable.OnActivate = function() inst:Remove() end

	inst:AddComponent("lootdropper")
	inst.components.lootdropper.numrandomloot = 1
	-- inst.components.lootdropper.chancerandomloot = 0.01
	inst.components.lootdropper:AddRandomLoot("purplegem",            0.001)
	inst.components.lootdropper:AddRandomLoot("greengem",             0.001)
	inst.components.lootdropper:AddRandomLoot("yellowgem",            0.001)
	inst.components.lootdropper:AddRandomLoot("gears",                0.002)
	inst.components.lootdropper:AddRandomLoot("redgem",               0.002)
	inst.components.lootdropper:AddRandomLoot("goldnugget",           0.003)
	inst.components.lootdropper:AddRandomLoot("slurtle_shellpieces",  0.02)
	inst.components.lootdropper:AddRandomLoot("spidergland",          0.02)
	inst.components.lootdropper:AddRandomLoot("antliontrinket",       0.04)
	inst.components.lootdropper:AddRandomLoot("feather_robin_winter", 0.04)
	inst.components.lootdropper:AddRandomLoot("kyno_kokonut",         0.05)
	inst.components.lootdropper:AddRandomLoot("feather_robin",        0.05)
	inst.components.lootdropper:AddRandomLoot("kyno_piko_orange",     0.05)
	inst.components.lootdropper:AddRandomLoot("kyno_piko",            0.06)
	inst.components.lootdropper:AddRandomLoot("feather_crow",         0.06)
	inst.components.lootdropper:AddRandomLoot("rocks",                0.20)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnEntityWake = OnWake
	inst.OnLongUpdate = LongUpdate

	AddToRegrowthManager(inst)

	return inst
end

return Prefab("kyno_meadowisland_sandhill", fn, assets, prefabs)