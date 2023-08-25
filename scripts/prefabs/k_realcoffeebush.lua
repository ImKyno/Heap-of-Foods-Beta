local function makeemptyfn(inst)
    if inst.components.pickable then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("empty")
	else
		inst.AnimState:PlayAnimation("empty")
	end
end

local function makebarrenfn(inst)
    if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
        inst.AnimState:PlayAnimation("empty_to_dead")
        inst.AnimState:PushAnimation("idle_dead", false)
    else
        inst.AnimState:PlayAnimation("idle_dead")
    end
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			local percent = 0
			if inst.components.pickable then
				percent = inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
			end
			if percent >= .9 then
				return "berriesmost"
			elseif percent >= .33 then
				return "berriesmore"
			else
				return "berries"
			end
		else
			if inst.components.pickable:IsBarren() then
				return "idle_dead"
			else
				return "idle"
			end
		end
	end

	return "idle"
end

local function shake(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("shake")
	else
		inst.AnimState:PlayAnimation("shake_empty")
	end
	inst.AnimState:PushAnimation(pickanim(inst), false)
end

local function pickberries(inst)
	if inst.components.pickable then
		local old_percent = (inst.components.pickable.cycles_left + 1) / inst.components.pickable.max_cycles or 1

		if old_percent >= .9 then
			inst.AnimState:PlayAnimation("berriesmost_picked")
		elseif old_percent >= .33 then
			inst.AnimState:PlayAnimation("berriesmore_picked")
		else
			inst.AnimState:PlayAnimation("berries_picked")
		end

		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle")
		end
	end	
end

local function onpickedfn(inst, picker)
    pickberries(inst)
end

local function getregentimefn_normal(inst)
    if inst.components.pickable == nil then
        return TUNING.KYNO_COFFEEBUSH_GROWTIME
    end

    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.KYNO_COFFEEBUSH_GROWTIME
    + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
    + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

local function makefullfn(inst)
    inst.AnimState:PlayAnimation(pickanim(inst))
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        if inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end

			inst.components.lootdropper:SpawnLootPrefab("dug_kyno_coffeebush")
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end

local function ontransplantfn(inst)
    inst.AnimState:PushAnimation("idle_dead")
    inst.components.pickable:MakeBarren()
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

local function createbush(name, inspectname, berryname, master_postinit)
    local assets =
    {
		Asset("ANIM", "anim/coffeebush.zip"),
		
		Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
		Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
    }

    local prefabs =
    {
        berryname,
        "dug_"..name,
        "twigs",
		"kyno_coffeebeans",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("kyno_coffeebush.tex")

        MakeSmallObstaclePhysics(inst, .1)

        inst.AnimState:SetBank("coffeebush")
        inst.AnimState:SetBuild("coffeebush")
        inst.AnimState:PlayAnimation("berriesmost", false)
		
		inst:AddTag("kyno_coffeebush")
        inst:AddTag("plant")
        inst:AddTag("renewable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
		
		inst:AddComponent("lootdropper")

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.makefullfn = makefullfn
        inst.components.pickable.ontransplantfn = ontransplantfn

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(TUNING.KYNO_COFFEEBUSH_WORKLEFT)

        inst:AddComponent("inspectable")
        if name ~= inspectname then
            inst.components.inspectable.nameoverride = inspectname
        end
		
        MakeSnowCovered(inst)
		MakeNoGrowInWinter(inst)
		-- MakeNoGrowInSpring(inst)
		
        master_postinit(inst)
		
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function normal_postinit(inst)
    inst.components.pickable:SetUp("kyno_coffeebeans", TUNING.KYNO_COFFEEBUSH_GROWTIME)
    inst.components.pickable.getregentimefn = getregentimefn_normal
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

    inst.components.workable:SetOnFinishCallback(dig_up_normal)
end

return createbush("kyno_coffeebush", "kyno_coffeebush", "kyno_coffeebeans", normal_postinit)