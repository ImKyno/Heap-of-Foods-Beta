local assets =
{
	Asset("ANIM", "anim/coffeebush.zip"),
		
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_coffeebeans",
	"dug_kyno_coffeebush",
	
	"twigs",
}

local SEASON_BASEREGENTIME_TUNING_LOOKUP =
{
	[SEASONS.SPRING] = "KYNO_COFFEEBUSH_GROWTIME_SPRING",
	[SEASONS.SUMMER] = "KYNO_COFFEEBUSH_GROWTIME_SUMMER",
}

local function OnSeasonChange(inst, season)
	local tuning = SEASON_BASEREGENTIME_TUNING_LOOKUP[season] or "KYNO_COFFEEBUSH_GROWTIME"
	inst.components.pickable.baseregentime = TUNING[tuning]
	
	if season == SEASONS.SUMMER then
		if inst.components.pickable:IsBarren() or inst.components.pickable:CanBeFertilized() then
			local delay = 5 + math.random() * 10
			
			inst:DoTaskInTime(delay, function()
				if inst:IsValid() and inst.components.pickable ~= nil then
					local fertilizer = SpawnPrefab("ash")
			
					inst.components.pickable:Fertilize(fertilizer)
					fertilizer:Remove()
				end
			end)
		end
		
		inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
	end
end

local function OnMakeEmpty(inst)
	if inst.components.pickable then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("empty")
	else
		inst.AnimState:PlayAnimation("empty")
	end
end

local function OnMakeBarren(inst)
	if TheWorld.state.issummer then
		inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
		inst.components.pickable:MakeEmpty()
		return
	end
	
	if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
		inst.AnimState:PlayAnimation("empty_to_dead")
		inst.AnimState:PushAnimation("idle_dead", false)
	else
		inst.AnimState:PlayAnimation("idle_dead")
    end
end

local function PickAnim(inst)
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

local function OnShake(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("shake")
	else
		inst.AnimState:PlayAnimation("shake_empty")
	end
	
	inst.AnimState:PushAnimation(PickAnim(inst), false)
end

local function PickBerries(inst)
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

local function OnPicked(inst, picker)
	if TheWorld.state.issummer then
		inst.components.pickable:MakeEmpty()
		inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
	end

	PickBerries(inst)
end

local function OnMakeFull(inst)
	inst.AnimState:PlayAnimation(PickAnim(inst))
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function OnDigUp(inst, worker, numberries)
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

local function OnDig(inst, worker)
	OnDigUp(inst, worker, 1)
end

local function OnTransplant(inst)
	inst.AnimState:PushAnimation("idle_dead")
	inst.components.pickable:MakeBarren()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_coffeebush.tex")
	
	-- inst.AnimState:SetScale(1.2, 1.2, 1.2)
	
	MakeSmallObstaclePhysics(inst, .1)
	
	inst.AnimState:SetBank("coffeebush")
	inst.AnimState:SetBuild("coffeebush")
	inst.AnimState:PlayAnimation("berriesmost", false)
	
	inst:AddTag("bush")
	inst:AddTag("plant")
	inst:AddTag("renewable")
	inst:AddTag("lunarplant_target")
	inst:AddTag("kyno_coffeebush")
	inst:AddTag("volcanicplant")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("kyno_coffeebeans", TUNING.KYNO_COFFEEBUSH_GROWTIME)
	inst.components.pickable.max_cycles = TUNING.KYNO_COFFEEBUSH_CYCLES + math.random(2)
	inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = OnMakeEmpty
    inst.components.pickable.makebarrenfn = OnMakeBarren
    inst.components.pickable.makefullfn = OnMakeFull
    inst.components.pickable.ontransplantfn = OnTransplant
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_COFFEEBUSH_WORKLEFT)
	inst.components.workable:SetOnFinishCallback(OnDig)
	
	inst:WatchWorldState("season", OnSeasonChange)
	OnSeasonChange(inst, TheWorld.state.season)

	MakeSnowCovered(inst)
	MakeNoGrowInWinter(inst)
	MakeWaxablePlant(inst)

	return inst
end

return Prefab("kyno_coffeebush", fn, assets, prefabs)