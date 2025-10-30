require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/cartography_desk.zip"),
}

local prefabs =
{
	"corn_cooked",
	"bowlofpopcorn",
	"collapse_small",
}

local MACHINE_STATES = 
{
	ON = "_on",
	OFF = "_off",
}

local SECTION_STATUS = 
{
	[0] = "OUT",
	[1] = "LOW",
	[2] = "NORMAL",
	[3] = "HIGH",
}

local POPCORN_INTERVAL = 10
local ITEM_PREFAB = "bowlofpopcorn"
local SOUND_LOOP = "dontstarve_DLC001/common/machine_melting"

local function OnHammred(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	inst.components.lootdropper:DropLoot()
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("metal")

	inst:Remove()
end

local function OnOpen(inst) 
	-- inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function OnClose(inst)
	-- inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
end

local function StopWorking(inst)
	if inst._pop_task ~= nil then
		inst._pop_task:Cancel()
		inst._pop_task = nil
	end
	
	inst.AnimState:PlayAnimation("idle")
	-- inst.SoundEmitter:KillSound("working_loop")
end

local function ProducePopcorn(inst)
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil or container == nil then
		-- print("Popcorn Machine - Missing components!")
		StopWorking(inst)
		return
	end

	if fueled:IsEmpty() then
		-- print("Popcorn Machine - Out of fuel, stopping.")
		StopWorking(inst)
		return
	end

	local item = container:GetItemInSlot(1)

	if item ~= nil then
		if item.prefab == ITEM_PREFAB and item.components.stackable ~= nil then
			local size = item.components.stackable:StackSize()
			local maxsize = item.components.stackable.maxsize

            -- print(string.format("Popcorn Machine - Current stack: %d/%d", size, maxsize))

			if size < maxsize then
				item.components.stackable:SetStackSize(size + 1)
				inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
				fueled:DoDelta(-1)
                
				-- print("Popcorn Machine - Added popcorn to existing stack.")
                return
            else
				-- print("Popcorn Machine - Stack full, stopping production.")
				StopWorking(inst)
				return
			end
		else
			-- print("[POPCORN MACHINE] Item in slot is not popcorn, stopping.")
			StopWorking(inst)
			return
		end
	end

	local popcorn = SpawnPrefab(ITEM_PREFAB)
	
	if popcorn ~= nil then
		local pos = Vector3(inst.Transform:GetWorldPosition())
		popcorn.Transform:SetPosition(pos.x, pos.y, pos.z)

		local success = container:GiveItem(popcorn, nil, pos)
		
		if success then
			-- print("Popcorn Machine - Produced first popcorn successfully!")
            
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
			fueled:DoDelta(-1)
		else
			-- print("Popcorn Machine - Failed to GiveItem (container invalid?)")
			
			popcorn:Remove()
			StopWorking(inst)
		end
	else
		-- print("Popcorn Machine - Failed to spawn popcorn prefab!")
	end
end

local function StartWorking(inst)
	if inst._pop_task == nil then
		-- inst.AnimState:PlayAnimation("place") -- on anim
		inst.AnimState:PushAnimation("idle")
		
		-- inst.SoundEmitter:PlaySound(SOUND_LOOP, "working_loop")
		inst._pop_task = inst:DoPeriodicTask(POPCORN_INTERVAL, ProducePopcorn)
	end
end

local function OnAddFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	inst.components.fueled:StartConsuming()
	
	if inst._pop_task == nil then
		StartWorking(inst)
	end
end

local function OnFuelEmpty(inst)
	StopWorking(inst)
end

local function GetStatus(inst)
	return SECTION_STATUS[inst.components.fueled:GetCurrentSection()]
end

local function OnBuilt(inst)

end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("cartographydesk.png")

	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("cartography_desk")
	inst.AnimState:SetBuild("cartography_desk")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("popcornmachine")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("popcornmachine")
		end
        
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("popcornmachine")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("fueled")
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled.maxfuel = TUNING.KYNO_POPCORN_MACHINE_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_POPCORN_MACHINE_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_POPCORN_MACHINE_SECTIONS)
	inst.components.fueled.accepting = true
	inst.components.fueled:StartConsuming()
	
	inst._pop_task = nil

	if not inst.components.fueled:IsEmpty() then
		StartWorking(inst)
	end

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammred)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeSnowCovered(inst)

	return inst
end

return Prefab("kyno_popcorn_machine", fn, assets, prefabs),
MakePlacer("kyno_popcorn_machine_placer", "cartography_desk", "cartography_desk", "idle")