local assets =
{
	Asset("ANIM", "anim/kyno_octopusking.zip"),
	
	-- Anniversary Event.
	Asset("ANIM", "anim/kyno_hofbirthday_octopusking.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"goldnugget",
	"kyno_octopusking_treasurechest",
}

local function StartTrading(inst)
	if not inst.components.trader.enabled then
		inst.components.trader:Enable()

		if inst.sleepfn then
			inst.AnimState:PlayAnimation("sleep_pst")
			inst:RemoveEventCallback("animover", inst.sleepfn)
			inst.sleepfn = nil
		end

		inst.AnimState:PushAnimation("idle", true)
	end

	inst.sleeping = false
end

local function FinishedTrading(inst)
	if not inst:HasTag("octopuskingtrader_nighttrader") then
		inst.components.trader:Disable()

		if inst.AnimState:IsCurrentAnimation("sleep_loop") or inst.happy then
			return
		end

		inst.AnimState:PlayAnimation("sleep_pre")

		if inst.sleepfn then
			inst:RemoveEventCallback("animover", inst.sleepfn)
			inst.sleepfn = nil
		end

		inst.sleepfn = function(inst)
			inst.AnimState:PlayAnimation("sleep_loop")
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/octopusking/sleep")
		end

		inst:ListenForEvent("animover", inst.sleepfn)
		inst.sleeping = true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	local istrinket = item:HasTag("trinket") or item:HasTag("hof_trinket")
	or string.sub(item.prefab, 1, 7) == "trinket"
	
	local itemprefab = item.prefab
	local itemprefab_loot = TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot[itemprefab]
	local tradefor = item.components.tradable.tradefor
	
	inst.components.trader:Disable()

	inst.AnimState:PlayAnimation("happy")
	inst.AnimState:PushAnimation("grabchest")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:DoTaskInTime(13  * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/octopusking/happy") end)
	inst:DoTaskInTime(53  * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/emerge_med") end)
	inst:DoTaskInTime(71  * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/submerge_med") end)
	inst:DoTaskInTime(78  * FRAMES, function(inst) inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small") end)
	inst:DoTaskInTime(109 * FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("hof_sounds/creatures/water_movement/emerge_med")

		local angle
		local spawnangle
		local x, y, z = inst.Transform:GetWorldPosition()

		if giver ~= nil and giver:IsValid() then
			angle = (210 - math.random() * 60 - giver:GetAngleToPoint(x, 0, z)) * DEGREES
			spawnangle = (130 - giver:GetAngleToPoint(x, 0, z)) * DEGREES
		else
			local down = TheCamera:GetDownVec()
			
			angle = math.atan2(down.z, down.x) + (math.random() * 60 - 30) * DEGREES
			spawnangle = math.atan2(down.z, down.x) + -50 * DEGREES
			giver = nil
        end
		
		local function IsOverBoat(x, z)
			local ents = TheSim:FindEntities(x, 0, z, 3, { "boat" })
			return #ents > 0
		end

		local function FindSafeWaterSpot(inst, baseangle)
			local ox, oy, oz = inst.Transform:GetWorldPosition()
			local maxtries = 8
			local radius = 3
			
			for i = 1, maxtries do
				local ang = baseangle + (i - 1) * (PI / 4)
				local tx = ox + radius * math.cos(ang)
				local tz = oz + radius * math.sin(ang)
				
				if not IsOverBoat(tx, tz) and TheWorld.Map:IsOceanAtPoint(tx, 0, tz) then
					return Vector3(tx, 0, tz)
				end
			end
			
			return Vector3(ox + 2 * math.cos(baseangle), 0, oz + 2 * math.sin(baseangle))
		end

		local chest = SpawnPrefab("kyno_octopusking_treasurechest")
		local safept = FindSafeWaterSpot(inst, spawnangle)
		
		chest.Transform:SetPosition(safept:Get())

		local sp = math.random() * 3 + 2
		chest.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 9, sp * math.sin(angle))

		if chest.components.inventoryitem ~= nil then
			chest.components.inventoryitem:SetLanded(false, true)
		end
		
		chest.AnimState:PlayAnimation("air_loop", true)
		
		chest:ListenForEvent("on_landed", function()
			chest.AnimState:PlayAnimation("land")
			chest.AnimState:PushAnimation("closed", true)
			chest.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
		end)

		if istrinket then
			for i = 1, (item.components.tradable.octopusvalue or item.components.tradable.octopusvalue * 3) do
				local loot = SpawnPrefab("goldnugget")
				chest.components.container:GiveItem(loot, nil, nil, true, false)
			end
		else
			local single = SpawnPrefab("goldnugget")
			chest.components.container:GiveItem(single, nil, nil, true, false)

			if itemprefab_loot then
				if type(itemprefab_loot) == "table" then
					local prefab = itemprefab_loot.prefab or itemprefab_loot[1]
					local amount = itemprefab_loot.amount or itemprefab_loot[2] or 1
					
					for i = 1, amount do
						local goodreward = SpawnPrefab(prefab)
			
						if goodreward then
							chest.components.container:GiveItem(goodreward, nil, nil, true, false)
						end
					end
				else
					local goodreward = SpawnPrefab(itemprefab_loot)
					chest.components.container:GiveItem(goodreward, nil, nil, true, false)
				end
			else
				local octopusvalue = math.min(item.components.tradable.octopusvalue or 0, 2)
				
				for i = 1, octopusvalue do
					local randomloot = TUNING.OCTOPUSKING_OCEAN_LOOT.randomchestloot
					local loot = SpawnPrefab(randomloot[math.random(1, #randomloot)])
					chest.components.container:GiveItem(loot, nil, nil, true, false)
				end
			end
		end
        
		if tradefor ~= nil then
			for _, v in pairs(tradefor) do
				local item = SpawnPrefab(v)
				
				if item ~= nil then
					chest.components.container:GiveItem(item, nil, nil, true, false)
				end
			end
		end
	end)

	inst.happy = true
	
	if inst.endhappytask then
		inst.endhappytask:Cancel()
	end
	
	inst.endhappytask = inst:DoTaskInTime(5, function(inst)
		inst.happy = false
		inst.endhappytask = nil
		
		if TheWorld.state.isnight and not inst:HasTag("octopuskingtrader_nighttrader") then
			FinishedTrading(inst)
		else
			inst.components.trader:Enable()
		end
	end)
end

local function OnRefuseItem(inst, giver, item)
	inst.SoundEmitter:PlaySound("hof_sounds/creatures/octopusking/reject")
	
	inst.AnimState:PlayAnimation("unimpressed")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.happy = false
end

local function OnSave(inst, data)
	if not inst.components.trader.enabled then
		data.sleeping = true
	end
end

local function OnLoad(inst,data)
	if data ~= nil and data.sleeping then
		FinishedTrading(inst)
	end
end

local function AcceptTest(inst, item, giver)
	local itemprefab = item.prefab
	
	return ((item.components.tradable.octopusvalue and item.components.tradable.octopusvalue > 0) 
	or TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot[itemprefab] ~= nil or string.sub(itemprefab, 1, 7) == "trinket")
end

local function StartDay(inst)
	StartTrading(inst)
end

local function OnHaunt(inst, haunter)
	if inst.components.trader and inst.components.trader.enabled then
		OnRefuseItem(inst)
		return true
	end
	
	return false
end

local function OnWorldInit(inst)
	-- Anniversary Event.
	if IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) then
		inst.AnimState:OverrideSymbol("octo_hat", "kyno_hofbirthday_octopusking", "octo_hat")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(10, 5)
    
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_octopusking_ocean.tex")
    minimap:SetPriority(5)

    MakeWaterObstaclePhysics(inst, 2, 1, 1)
	inst:SetPhysicsRadiusOverride(3)
    
	inst.AnimState:SetBank("kyno_octopusking")
	inst.AnimState:SetBuild("kyno_octopusking")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("trader")
	inst:AddTag("character")
	inst:AddTag("octopuskingtrader")
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("pointofinterest")
		inst.components.pointofinterest:SetHeight(60)
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(AcceptTest)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	
	inst:DoTaskInTime(0, OnWorldInit)
	
	-- Don't sleep on Lights Out worlds.
	inst:ListenForEvent("clocksegschanged", function(world, data)
		inst.segs = data

		if inst.segs["night"] + inst.segs["dusk"] >= 16 then
			inst:AddTag("octopuskingtrader_nighttrader")
		end
	end, TheWorld)
	
	inst:WatchWorldState("startday", StartDay)

	inst:WatchWorldState("startnight", function()
		if inst:HasTag("octopuskingtrader_nighttrader") then
			StartDay(inst)
		else
			FinishedTrading(inst)
		end
	end)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_octopusking_ocean", fn, assets, prefabs)