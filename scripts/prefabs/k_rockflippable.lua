
local assets =
{
	Asset("ANIM", "anim/rock_flipping.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_beanbugs",
	"kyno_gummybug",
}

local function SetLoot(inst)
    local ground = TheWorld
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
    
    if tile == GROUND.SAVANNA then
    	inst.components.lootdropper:AddRandomLoot("kyno_beanbugs", 	 15)
	    inst.components.lootdropper:AddRandomLoot("rocks", 			  5)
	    inst.components.lootdropper:AddRandomLoot("flint", 			  5) 
	    inst.components.lootdropper:AddRandomLoot("cutgrass", 		  3) 
		inst.components.lootdropper:AddRandomLoot("nitre", 		      3)
		inst.components.lootdropper:AddRandomLoot("kyno_gummybug",    1)		
    elseif tile == GROUND.DECIDUOUS then
	    inst.components.lootdropper:AddRandomLoot("kyno_gummybug",   15)
	    inst.components.lootdropper:AddRandomLoot("rocks", 		      5) 
	    inst.components.lootdropper:AddRandomLoot("flint",            5)
	    inst.components.lootdropper:AddRandomLoot("acorn",            3)
		inst.components.lootdropper:AddRandomLoot("kyno_beanbugs", 	  1)
		inst.components.lootdropper:AddRandomLoot("mole",            .1)		
    elseif tile == GROUND.ROCKY then
	    inst.components.lootdropper:AddRandomLoot("kyno_beanbugs",    5)
	    inst.components.lootdropper:AddRandomLoot("kyno_gummybug",    5)
	    inst.components.lootdropper:AddRandomLoot("rocks",            5)
	    inst.components.lootdropper:AddRandomLoot("flint",            5)
	    inst.components.lootdropper:AddRandomLoot("goldnugget",       3)
		inst.components.lootdropper:AddRandomLoot("spider",           1)
	elseif tile == GROUND.UNDERROCK then
		inst.components.lootdropper:AddRandomLoot("bat",             10)
		inst.components.lootdropper:AddRandomLoot("snurtle",          8)
		inst.components.lootdropper:AddRandomLoot("slurtle",          8)
		inst.components.lootdropper:AddRandomLoot("rocks",            6)
		inst.components.lootdropper:AddRandomLoot("kyno_beanbugs",    4)
	    inst.components.lootdropper:AddRandomLoot("kyno_gummybug",    4)
	    inst.components.lootdropper:AddRandomLoot("flint",            3)
	    inst.components.lootdropper:AddRandomLoot("nitre",            3)
	    inst.components.lootdropper:AddRandomLoot("goldnugget",       1)  
	else
	    inst.components.lootdropper:AddRandomLoot("rocks",            8)
	    inst.components.lootdropper:AddRandomLoot("flint",            8)
	    inst.components.lootdropper:AddRandomLoot("nitre",            8)
		inst.components.lootdropper:AddRandomLoot("rocks",            6)
		inst.components.lootdropper:AddRandomLoot("kyno_beanbugs",    2)
	    inst.components.lootdropper:AddRandomLoot("kyno_gummybug",    2)
	    inst.components.lootdropper:AddRandomLoot("goldnugget",       1)     
    end
end

local function ontransplantfn(inst)
	inst.components.pickable:MakeBarren()
end

local function makeemptyfn(inst)
	-- Do Something.
end

local function makebarrenfn(inst)
	-- Do Something.
end

local function DoWobble(inst)
	if inst.AnimState:IsCurrentAnimation("idle") then
		inst.AnimState:PlayAnimation("wobble")
		inst.AnimState:PushAnimation("idle")
	end
end

local function DoWobbleTest(inst)
	if math.random() < 0.5 then
		DoWobble(inst)
	end
end

local function onpickedfn(inst, picker)
	inst.AnimState:PlayAnimation("flip_over", false)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	
	inst.flipped = true
end

local function getregentimefn(inst)
	if inst.components.pickable then
		local num_cycles_passed = math.min(inst.components.pickable.max_cycles - inst.components.pickable.cycles_left, 0)
		return TUNING.KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME + TUNING.KYNO_FLIPPABLE_ROCK_REPOPULATE_INCREASE * num_cycles_passed + math.random() 
		* TUNING.KYNO_FLIPPABLE_ROCK_REPOPULATE_VARIANCE
	else
		return TUNING.KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME
	end
end

local function makefullfn(inst)
	if inst.components.pickable then
        inst.AnimState:PlayAnimation("flip_close")
    end
	
	inst.AnimState:PushAnimation("idle")
    inst:DoTaskInTime(0,function() SetLoot(inst) end)
	
	inst.flipped = false
end

local function OnWorked(inst, worker, workleft)
	local pt = Point(inst.Transform:GetWorldPosition())
	SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
	
	inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
	inst.components.lootdropper:SpawnLootPrefab("rocks")

	if math.random() < 0.3 then
		inst.components.lootdropper:SpawnLootPrefab("rocks")
	end

	if inst.components.pickable.canbepicked then
		inst.components.lootdropper:DropLoot()
	end

	TheWorld:PushEvent("beginregrowth", inst)
	inst:Remove()
end

local function OnEntitySleep(inst)
	if inst.fliptask then
		inst.fliptask:Cancel()
		inst.fliptask = nil
	end
end

local function OnEntityWake(inst)
	if inst.fliptask then
		inst.fliptask:Cancel()
	end
	inst.fliptask = inst:DoPeriodicTask(10 + (math.random() * 10), function() DoWobbleTest(inst) end)
end

local function OnSave(inst, data)
	if inst.flipped then
		data.flipped = true
	end
end

local function OnLoad(inst, data)
	if data and data.makebarren then
		makebarrenfn(inst)
		inst.components.pickable:MakeBarren()
	end
	if data and data.flipped then
		inst.flipped = true
		inst.AnimState:PlayAnimation("idle_flipped")
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rockflippable.tex")
	
	MakeObstaclePhysics(inst, .1)

	inst.AnimState:SetBank("flipping_rock")
	inst.AnimState:SetBuild("rock_flipping")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("rock")
	inst:AddTag("flippable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable:SetUp(nil, TUNING.KYNO_FLIPPABLE_GROWTIME)
	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.ontransplantfn = ontransplantfn
	inst.components.pickable.max_cycles = TUNING.KYNO_FLIPPABLE_ROCK_CYCLES + math.random(2)
	inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
	inst.components.pickable.quickpick = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_FLIPPABLE_WORKLEFT)
	inst.components.workable:SetOnFinishCallback(OnWorked)

	inst:AddComponent("lootdropper")
    inst.components.lootdropper.numrandomloot = 1
    inst.components.lootdropper.chancerandomloot = 1.0
	inst.components.lootdropper.alwaysinfront = true
    
	inst:DoTaskInTime(0, function() SetLoot(inst) end)
	inst.fliptask = inst:DoPeriodicTask(10 + (math.random() * 10), function() DoWobbleTest(inst) end)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	AddToRegrowthManager(inst)

	return inst
end

return Prefab("kyno_rockflippable", fn, assets, prefabs),
Prefab("kyno_rockflippable_cave", fn, assets, prefabs)