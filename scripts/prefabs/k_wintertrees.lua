require("prefabs/winter_ornaments")

local QueueGifting

local statedata        =
{
	{
		name           = "empty",
		idleanim       = "idle",
		loot           = function(inst) return {inst.seedprefab, "boards", "poop"} end,
		burntloot      = function(inst) return {"boards", "poop"} end,
		burntanim      = "burnt",
		burnfxlevel    = 3,
	},
	
    {
		name           = "sapling",
		idleanim       = "idle_sapling",
		burntanim      = "burnt",
		workleft       = 1,
		workaction     = "HAMMER",
		growsound      = "dontstarve/wilson/plant_tree",
		loot           = function(inst)
			local seeds = math.min(inst.maxseeds or 1, 1)
			local items = {"boards", "poop"}
			
			for i = 1, seeds do
				table.insert(items, inst.seedprefab)
			end
			
			return items
		end,
		burntloot      = function(inst) return {"ash", "boards", "poop"} end,
		burnfxlevel    = 3,
    },
	
    {
		name           = "short",
		idleanim       = "idle_short",
		sway1anim      = "sway1_loop_short",
		sway2anim      = "sway2_loop_short",
		hitanim        = "chop_short",
		breakrightanim = "fallright_short",
		breakleftanim  = "fallleft_short",
		burntbreakanim = "chop_burnt_short",
		burntanim      = "burnt_short",
		growanim       = "grow_sapling_to_short",
		growsound      = "dontstarve/forest/treeGrow",
		workleft       = TUNING.WINTER_TREE_CHOP_SMALL,
		workaction     = "CHOP",
		loot           = function(inst) return {inst.logprefab, "boards", "poop"} end,
		burntloot      = function(inst) return {"charcoal", "boards", "poop"} end,
		burnfxlevel    = 4,
		burntree       = true,
		shelter        = true,
    },
	
	{
		name           = "normal",
		idleanim       = "idle_normal",
		sway1anim      = "sway1_loop_normal",
		sway2anim      = "sway2_loop_normal",
		hitanim        = "chop_normal",
		breakrightanim = "fallright_normal",
		breakleftanim  = "fallleft_normal",
		burntbreakanim = "chop_burnt_normal",
		burntanim      = "burnt_normal",
		growanim       = "grow_short_to_normal",
		growsound      = "dontstarve/forest/treeGrow",
		workleft       = TUNING.WINTER_TREE_CHOP_NORMAL,
		workaction     = "CHOP",
		loot           = function(inst)
			local seeds = math.min(inst.maxseeds or 1, 1)
			local items = {inst.logprefab, inst.logprefab, "boards", "poop"}
			
			for i = 1, seeds do
				table.insert(items, inst.seedprefab)
			end
			
			return items
		end,
		burntloot      = function(inst) return {"charcoal", "boards", "poop"} end,
		burnfxlevel    = 4,
		burntree       = true,
		shelter        = true,
	},
	
	{
		name           = "tall",
		idleanim       = "idle_tall",
		sway1anim      = "sway1_loop_tall",
		sway2anim      = "sway2_loop_tall",
		hitanim        = "chop_tall",
		breakrightanim = "fallright_tall",
		breakleftanim  = "fallleft_tall",
		burntbreakanim = "chop_burnt_tall",
		burntanim      = "burnt_tall",
		growanim       = "grow_normal_to_tall",
		growsound      = "dontstarve/forest/treeGrow",
		workleft       = TUNING.WINTER_TREE_CHOP_TALL,
		workaction     = "CHOP",
		loot           = function(inst)
			local seeds = math.min(inst.maxseeds or 2, 2)
			local items = {inst.logprefab, inst.logprefab, inst.logprefab, "boards", "poop"}
			
			for i = 1, seeds do
				table.insert(items, inst.seedprefab)
			end
			
			return items
		end,
		burntloot      = function(inst)
			local seeds = math.min(inst.maxseeds or 1, 1)
			local items = {"charcoal", "charcoal", "boards", "poop"}
			
			for i = 1, seeds do
				table.insert(items, inst.seedprefab)
			end
			
			return items
		end,
		burnfxlevel   = 4,
		burntree      = true,
		shelter       = true,
	},
}

local function PushSway(inst)
	if inst.statedata.sway1anim ~= nil then
		inst.AnimState:PushAnimation(math.random() > .5 and inst.statedata.sway1anim or inst.statedata.sway2anim, true)
	else
		inst.AnimState:PushAnimation(inst.statedata.idleanim, false)
	end
end

local function PlaySway(inst)
	if inst.OnPlayAnim ~= nil then
		inst:OnPlayAnim()
	end
	
	if inst.statedata.sway1anim ~= nil then
		inst.AnimState:PlayAnimation(math.random() > .5 and inst.statedata.sway1anim or inst.statedata.sway2anim, true)
	else
		inst.AnimState:PlayAnimation(inst.statedata.idleanim, false)
	end
end

local function PlayAnim(inst, anim)
	if inst.OnPlayAnim ~= nil then
		inst:OnPlayAnim()
	end
	
	inst.AnimState:PlayAnimation(anim)
end

local LIGHT_STR =
{
	{ radius = 3.25, falloff = .85, intensity = 0.75 },
}

local function IsLightOn(inst)
	return inst.Light:IsEnabled()
end

local function UpdateLights(inst, light)
	local was_on = IsLightOn(inst)
	local batteries = inst.forceoff ~= true and inst.components.container:FindItems( function(item) return item:HasTag("lightbattery") end ) or {}

	local lightcolour = Vector3(0, 0, 0)
	local num_lights_on = 0
    
	for i, v in ipairs(batteries) do
		if v.ornamentlighton then
			lightcolour = lightcolour + Vector3(v.Light:GetColour())
			num_lights_on = num_lights_on + 1
		end
	end

	if light ~= nil then
		local slot = inst.components.container:GetItemSlot(light)
		
		if slot ~= nil then
			inst.AnimState:OverrideSymbol("plain"..slot, light.winter_ornament_build or "winter_ornaments", 
			light.winter_ornamentid..(light.ornamentlighton and "_on" or "_off"))
		end
	end

	if num_lights_on == 0 then
		if was_on then
			inst.Light:Enable(false)
			inst.AnimState:ClearBloomEffectHandle()
			inst.AnimState:SetLightOverride(0)
		end
	else
		if not was_on then
			inst.Light:Enable(true)
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			inst.AnimState:SetLightOverride(0.2)
		end

		inst.Light:SetRadius(LIGHT_STR[1].radius)
		inst.Light:SetFalloff(LIGHT_STR[1].falloff)
		inst.Light:SetIntensity(LIGHT_STR[1].intensity)

		lightcolour:Normalize()
		inst.Light:SetColour(lightcolour.x, lightcolour.y, lightcolour.z)
    end
end

local function DoTreeWind(inst)
	for _, v in pairs(inst.ornamentfx) do
		v:DoTreeWind()
	end
	
	inst.windtask = inst:DoTaskInTime(6 + math.random() * 4, DoTreeWind)
end

local function StartTreeWind(inst)
	if inst.windtask == nil then
		inst.windtask = inst:DoTaskInTime(6 + math.random() * 4, DoTreeWind)
	end
end

local function StopTreeWind(inst)
	if inst.windtask then
		inst.windtask:Cancel()
		inst.windtask = nil
	end
end

local function RemoveDecor(inst, data)
	inst.AnimState:ClearOverrideSymbol("plain"..data.slot)
	
	if inst.ornamentfx and inst.ornamentfx[data.slot] then
		inst.ornamentfx[data.slot]:Remove()
		inst.ornamentfx[data.slot] = nil
		
		if next(inst.ornamentfx) == nil then
			StopTreeWind(inst)
		end
	end
	
	UpdateLights(inst)
end

local function AttachFxToSlot(inst, slot, fx)
	fx:AttachToParent(inst)
	fx.Follower:FollowSymbol(inst.GUID, "plain"..slot)
	
	if inst.SortDecor then
		inst:SortDecor(fx, slot)
	end
	
	return fx
end

local function AddDecor(inst, data)
	if data and data.slot and data.item and not inst:HasTag("burnt") then
		if inst.ornamentfx and inst.ornamentfx[data.slot] then
			inst.ornamentfx[data.slot]:Remove()
			inst.ornamentfx[data.slot] = nil
		end

		if data.item:HasTag("hermithouse_ornament") then
			inst.AnimState:ClearOverrideSymbol("plain"..data.slot)

			if inst.ornamentfx == nil then
				inst.ornamentfx = {}
			elseif inst.ornamentfx[data.slot] then
				inst.ornamentfx[data.slot]:Remove()
			end
			
			inst.ornamentfx[data.slot] = AttachFxToSlot(inst, data.slot, data.item:CloneAsFx())

			StartTreeWind(inst)
			UpdateLights(inst)
		else
			if inst.ornamentfx and inst.ornamentfx[data.slot] then
				inst.ornamentfx[data.slot]:Remove()
				inst.ornamentfx[data.slot] = nil
				
				if next(inst.ornamentfx) == nil then
					StopTreeWind(inst)
				end
			end
			
			if data.item.winter_ornamentid then
				if data.item.ornamentlighton ~= nil then
					UpdateLights(inst, data.item)
				else
					inst.AnimState:OverrideSymbol("plain"..data.slot, data.item.winter_ornament_build or "winter_ornaments", data.item.winter_ornamentid)
				end
			end
		end
	end
end

local function RefreshDecor(inst, item)
	local slot = inst.components.container:GetItemSlot(item)
	
	if slot and inst.ornamentfx[slot] then
		inst.ornamentfx[slot]:Remove()
		inst.ornamentfx[slot] = AttachFxToSlot(inst, slot, item:CloneAsFx())
	end
end

local GIFTING_PLAYER_RADIUS_SQ = 25 * 25

local function NobodySeesPoint(pt)
	if TheWorld.Map:IsPointNearHole(pt) then
		return false
	end
	
	for i, v in ipairs(AllPlayers) do
		if CanEntitySeePoint(v, pt.x, pt.y, pt.z) then
			return false
		end
	end
	
	return true
end

local INLIMBO_TAGS = { "INLIMBO" }

local function NoOverlap(pt)
	return NobodySeesPoint(pt) and #TheSim:FindEntities(pt.x, 0, pt.z, .75, nil, INLIMBO_TAGS) <= 0
end

local function DoGifting(inst)
	if TheWorld.state.isnight then
		local players = {}
		local x, y, z = inst.Transform:GetWorldPosition()
		
		for i, v in ipairs(AllPlayers) do
			if v:GetDistanceSqToPoint(x, y, z) < GIFTING_PLAYER_RADIUS_SQ then
				table.insert(players, v)
			end
		end

		if #players > 0 then
			local fully_decorated = inst.components.container:IsFull()
			
			for _, player in ipairs(players) do
				local loot = {}

				if player.components.wintertreegiftable ~= nil --[[and player.components.wintertreegiftable:GetDaysSinceLastGift() >= 4]] then
					player.components.wintertreegiftable:OnGiftGiven()
					
					table.insert(loot, { prefab = "winter_food".. math.random(NUM_WINTERFOOD), stack = math.random(3) + (fully_decorated and 3 or 0)})
					table.insert(loot, { prefab = not fully_decorated and GetRandomBasicWinterOrnament()
					or math.random() < 0.5 and GetRandomFancyWinterOrnament()
					or GetRandomFestivalEventWinterOrnament() })

					table.insert(loot, { prefab = weighted_random_choice(TUNING.KYNO_WINTERTREE_GIFT1) })

					if fully_decorated then
						table.insert(loot, { prefab = weighted_random_choice(TUNING.KYNO_WINTERTREE_GIFT2) })
						-- Some festive foods.
						table.insert(loot, { prefab = weighted_random_choice(TUNING.KYNO_WINTERTREE_GIFT3) })
					else
						table.insert(loot, { prefab = PickRandomTrinket() })
					end
				else
					table.insert(loot, { prefab = "winter_food".. math.random(NUM_WINTERFOOD), stack = math.random(3) })
					table.insert(loot, { prefab = "charcoal" })
				end

				local items = {}
				
				for i, v in ipairs(loot) do
					local item = SpawnPrefab(v.prefab)
					
					if item ~= nil then
						if item.components.stackable ~= nil then
							item.components.stackable:SetStackSize(math.max(1, v.stack or 1))
						end
						
						table.insert(items, item)
					end
				end
				
				if #items > 0 then
					local gift = SpawnPrefab("gift")
					gift.components.unwrappable:WrapItems(items)
					
					for i, v in ipairs(items) do
						v:Remove()
					end
					
					local pos = inst:GetPosition()
					local radius = inst:GetPhysicsRadius(0) + .7 + math.random() * .5
					local theta = inst:GetAngleToPoint(player.Transform:GetWorldPosition()) * DEGREES
					local offset =
						FindWalkableOffset(pos, theta, radius, 8, false, true, NoOverlap) or
						FindWalkableOffset(pos, theta, radius + .5, 8, false, true, NoOverlap) or
						FindWalkableOffset(pos, theta, radius, 8, false, true, NobodySeesPoint) or
						FindWalkableOffset(pos, theta, radius + .5, 8, false, true, NobodySeesPoint)
					if offset ~= nil then
						gift.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
					else
						inst.components.lootdropper:FlingItem(gift)
					end
				end

				if inst.forceoff then
					inst:DoTaskInTime(1, function()
						inst.forceoff = false 
					end, inst)
				end

				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
				inst.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")

				return true
			end
		end
	end
end

local function TryGifting(inst)
	inst.giftingtask = nil

	if TheWorld.state.isnight and inst.components.container ~= nil and not inst.components.container:IsEmpty() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local players_near = {}
		
		for i, v in ipairs(AllPlayers) do
			if v:GetDistanceSqToPoint(x, y, z) < GIFTING_PLAYER_RADIUS_SQ then
				table.insert(players_near, v)
			end
		end

		local all_players_sleeping = true
		
		if #players_near > 0 then
			for i, v in ipairs(players_near) do
				if not v:HasTag("sleeping") then
					all_players_sleeping = false
					break
				end
			end

			if all_players_sleeping then
				local tree_is_visible = false
				
				for i, v in ipairs(players_near) do
					if CanEntitySeePoint(v, x, y, z) then
						tree_is_visible = true
						break
					end
				end

				if tree_is_visible then
					local batteries = inst.components.container:FindItems(function(item) 
						return item:HasTag("lightbattery") 
					end)
					
					if #batteries > 0 then
						inst.forceoff = true
						UpdateLights(inst)
						inst.giftingtask = inst:DoTaskInTime(.2, TryGifting, inst)
						
						return
					end
				else
					if DoGifting(inst) then
						return
					end
				end
			end
		end

		inst.forceoff = false
		QueueGifting(inst)
    end
end

QueueGifting = function(inst)
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and TheWorld.state.isnight and inst.components.container ~= nil and 
	not inst.components.container:IsEmpty() and inst.giftingtask == nil then
		inst.giftingtask = inst:DoTaskInTime(2, TryGifting, inst)
	end
end

local function DoErode(inst)
	inst:DoTaskInTime(1, ErodeAway)
end

local SLOT_HEIGHTS = { 5.8, 4.3, 4.6, 3.1, 3.2, 2.1, 1.5, 1.7 }

local function SetGrowth(inst)
	if inst.components.burnable == nil then
		return
	end
	
	local new_size = inst.components.growable.stage
	inst.statedata = statedata[new_size]
	PlaySway(inst)

	inst.components.workable:SetWorkAction(ACTIONS[inst.statedata.workaction])
	inst.components.workable:SetWorkLeft(inst.statedata.workleft)
	
	inst.components.burnable:SetFXLevel(inst.statedata.burnfxlevel)
	inst.components.burnable:SetBurnTime(inst.statedata.burntree and TUNING.TREE_BURN_TIME or 20)

	if inst.canshelter and inst.statedata.shelter then
		inst:AddTag("shelter")
	end

	if new_size >= #statedata then
		inst.components.container.canbeopened = true
		inst.components.growable:StopGrowing()

		inst:WatchWorldState("isnight", QueueGifting)
	end
end

local function DoGrow(inst)
	if inst.statedata.growanim ~= nil then
		PlayAnim(inst, inst.statedata.growanim)
	end
	
	if inst.statedata.growsound ~= nil then
		inst.SoundEmitter:PlaySound(inst.statedata.growsound)
	end

	PushSway(inst)
end

local GROWTH_STAGES =
{
	{
		time = function(inst) return 0 end,
		fn = SetGrowth,
		growfn = function() end,
	},
	
	{
		time = function(inst) return GetRandomWithVariance(TUNING.WINTER_TREE_GROW_TIME[2].base, TUNING.WINTER_TREE_GROW_TIME[2].random) end,
		fn = SetGrowth,
		growfn = DoGrow,
	},
	
	{
		time = function(inst) return GetRandomWithVariance(TUNING.WINTER_TREE_GROW_TIME[3].base, TUNING.WINTER_TREE_GROW_TIME[3].random) end,
		fn = SetGrowth,
		growfn = DoGrow,
	},
	
	{
		time = function(inst) return GetRandomWithVariance(TUNING.WINTER_TREE_GROW_TIME[4].base, TUNING.WINTER_TREE_GROW_TIME[4].random) end,
		fn = SetGrowth,
		growfn = DoGrow,
	},
	
	{
		time = function(inst) return GetRandomWithVariance(TUNING.WINTER_TREE_GROW_TIME[5].base, TUNING.WINTER_TREE_GROW_TIME[5].random) end,
		fn = SetGrowth,
		growfn = DoGrow,
	},
}

local function LootSetupFn(lootdropper)
	lootdropper:SetLoot(lootdropper.inst:HasTag("burnt") 
	and lootdropper.inst.statedata.burntloot(lootdropper.inst) or lootdropper.inst.statedata.loot(lootdropper.inst))
end

local function OnWorked(inst, worker, workleft)
	if workleft > 0 then
		if inst.statedata.hitanim ~= nil then
			PlayAnim(inst, inst.statedata.hitanim)
			PushSway(inst)
			
			if not inst.components.container:IsEmpty() then
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
			end
			
			if not (worker ~= nil and worker:HasTag("playerghost")) then
				inst.SoundEmitter:PlaySound(worker ~= nil and worker:HasTag("beaver") and "dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
			end
			
			if inst.OnChop ~= nil then
				inst:OnChop(worker, workleft)
			end
		end
	elseif inst:HasTag("burnt") then
		inst.components.lootdropper:DropLoot()

		if inst.statedata.burntbreakanim ~= nil then
			PlayAnim(inst, inst.statedata.burntbreakanim)
			inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
			
			if not (worker ~= nil and worker:HasTag("playerghost")) then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
			end

			inst.persists = false
			inst:AddTag("NOCLICK")
			inst:DoTaskInTime(1.5, ErodeAway)
		else
			local fx = SpawnPrefab("collapse_small")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			fx:SetMaterial("wood")
			
			inst:Remove()
		end
	else
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("wood")

		inst.components.lootdropper:DropLoot()
		
		if inst.components.container ~= nil then
			inst.components.container:DropEverything()
			inst.components.container:Close()
			inst.components.container.canbeopened = false
		end

		if inst.statedata.breakrightanim ~= nil then
			inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

			if inst.components.growable ~= nil then
				inst.components.growable:StopGrowing()
			end

			local worker_is_to_right = worker and ((worker:GetPosition() - inst:GetPosition()):Dot(TheCamera:GetRightVec()) > 0) or (math.random() > 0.5)
			
			PlayAnim(inst, worker_is_to_right and inst.statedata.breakleftanim or inst.statedata.breakrightanim)

			inst:ListenForEvent("animover", inst.Remove)
			inst.persists = false
		else
			inst:Remove()
		end
	end
end

local function GetStatus(inst)
	return (inst:HasTag("burnt") and "BURNT")
	or (inst:HasTag("fire") and "BURNING")
	or (inst.components.growable.stage == #statedata and "CANDECORATE")
	or "YOUNG"
end

local function OnBurnt(inst)
	DefaultBurntStructureFn(inst)

	if inst.canshelter then
		inst:RemoveTag("shelter")
	end

	if inst.components.growable ~= nil then
		inst.components.growable:StopGrowing()
	end

	PlayAnim(inst, inst.statedata.burntanim)
end

local function OnLoadPostPass(inst, ents, data)
	inst.statedata = statedata[inst.components.growable.stage]

	if data ~= nil and data.burnt then
		inst.components.burnable.onburnt(inst)
	else
		PlaySway(inst)
		inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

		QueueGifting(inst)
	end
end

local function OnEntityWake(inst)
	if inst.giftingtask ~= nil then
		inst.giftingtask:Cancel()
		inst.giftingtask = nil
	end

	QueueGifting(inst)
	
	if inst.ornamentfx and next(inst.ornamentfx) then
		StartWind(inst)
	end
end

local function OnEntitySleep(inst)
	if inst.giftingtask ~= nil then
		inst.giftingtask:Cancel()
		inst.giftingtask = nil
	end
	
	StopTreeWind(inst)
end

local function TeaTree_Postinit(inst)
	inst.AnimState:Hide("mouseover")
	
	inst.AnimState:OverrideSymbol("swap_leaves", "teatree_build", "swap_leaves")
	inst.AnimState:OverrideSymbol("mouseover", "tree_leaf_trunk_build", "toggle_mouseover")
	inst.AnimState:OverrideSymbol("sapling_deciduous", "kyno_meadowisland_tree_sapling", "sapling")
end

local function KokonutTree_Postinit(inst)
	inst.AnimState:AddOverrideBuild("kyno_kokonut")
end

local function SugarTree_Postinit(inst)
	inst.AnimState:Hide("mouseover")
	
	inst.AnimState:AddOverrideBuild("sugartree_winter_build")

	inst.AnimState:OverrideSymbol("mouseover", "quagmire_tree_cotton_trunk_build", "toggle_mouseover")
	inst.AnimState:OverrideSymbol("sapling_deciduous", "kyno_serenityisland_sapling", "sapling")
end

local function TeaTree_OnChop(inst, worker)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("green_leaves_chop").Transform:SetPosition(x, (inst.components.growable.stage == 4 and y - .3 or y) + math.random() * 2, z)
	
	local VEC_CHANCE = .33
	local RANDOM_CHANCE = .50

	if inst.components.growable ~= nil and inst.components.growable.stage == 5 then
		if math.random() < TUNING.KYNO_MEADOWISLAND_TREE_DROP_CHANCE then
			local item_to_drop = math.random() < RANDOM_CHANCE and "kyno_tealeaf" or "kyno_twiggynuts"
			local item = SpawnPrefab(item_to_drop)
			
			if math.random() < VEC_CHANCE then 
				LaunchAt(item, inst, worker, .5, 4, 1.3, 5)
			else
				LaunchAt(item, inst, nil, .5, 4, 1.1, 5)
			end
		
			item.components.inventoryitem:SetLanded(true)
		end
	end
end

local function KokonutTree_OnChop(inst, worker)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("pine_needles_chop").Transform:SetPosition(x, (inst.components.growable.stage == 4 and y - .3 or y) + math.random() * 2, z)
	
	if inst.components.growable ~= nil and inst.components.growable.stage == 5 then
		if math.random() <= TUNING.KYNO_KOKONUTTREE_KOKONUT_CHANCE then
			local coconut = SpawnPrefab("kyno_kokonut")
			local rad = worker:GetPosition():Dist(inst:GetPosition())
			local vec = (worker:GetPosition() - inst:GetPosition()):Normalize()
			local offset = Vector3(vec.x * rad, 4, vec.z * rad)

			coconut.Transform:SetPosition((inst:GetPosition() + offset):Get())
			coconut.components.inventoryitem:SetLanded(true)
		end
	end
end

local trees = {}

local function AddHofWinterTree(treetype)
	local assets =
	{
		Asset("ANIM", "anim/wintertree_build.zip"),
		Asset("ANIM", "anim/"..treetype.build..".zip"),
		Asset("ANIM", "anim/"..treetype.bank..".zip"),
	}
	
	if treetype.extrabuilds ~= nil then
		for i, v in ipairs(treetype.extrabuilds) do
			table.insert(assets, Asset("ANIM", "anim/"..v..".zip"))
		end
	end

	local prefabs =
	{
		"charcoal",
		"ash",
		"collapse_small",
		"gift",
	}
	
	table.insert(prefabs, treetype.seedprefab)
	table.insert(prefabs, treetype.logprefab)
	
	for i, v in ipairs(GetAllWinterOrnamentPrefabs()) do
		table.insert(prefabs, v)
	end
	
	for i = 1, NUM_WINTERFOOD do
		table.insert(prefabs, "winter_food"..i)
	end
	
	if treetype.extraprefabs ~= nil then
		for i, v in ipairs(treetype.extraprefabs) do
			table.insert(prefabs, v)
		end
	end
	
	for k, v in pairs(TUNING.KYNO_WINTERTREE_GIFT1) do
		table.insert(prefabs, k)
	end
	
	for k, v in pairs(TUNING.KYNO_WINTERTREE_GIFT2) do
		if TUNING.KYNO_WINTERTREE_GIFT1[k] == nil then
			table.insert(prefabs, k)
		end
	end
	
	for k, v in pairs(TUNING.KYNO_WINTERTREE_GIFT3) do
		table.insert(prefabs, k)
	end

	local function OnSave(inst, data)
		if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
			data.burnt = true
		end

		data.previousgiftday = inst.previousgiftday

		if treetype.onsave ~= nil then
			treetype.onsave(inst, data)
		end
	end

	local function OnLoad(inst, data)
		if data ~= nil then
			inst.previousgiftday = data.previousgiftday
		end

		if treetype.onload ~= nil then
			treetype.onload(inst, data)
		end
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddLight()
		inst.entity:AddNetwork()
		
		inst.Light:Enable(false)

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon(treetype.minimapicon..".tex")
		minimap:SetPriority(-1)
		
		MakeObstaclePhysics(inst, .5)
		
		inst.AnimState:SetScale(treetype.scale or 1, treetype.scale or 1, treetype.scale or 1)

		inst.AnimState:SetBank(treetype.bank)
		inst.AnimState:SetBuild(treetype.build)
		inst.AnimState:AddOverrideBuild("wintertree_build")
		inst.AnimState:PlayAnimation("idle")

		inst:AddTag("winter_tree")
		inst:AddTag("decoratable")
		inst:AddTag("structure")
		inst:AddTag("event_trigger")
		
		MakeSnowCoveredPristine(inst)

		inst:SetPrefabNameOverride("winter_tree")

		if treetype.common_postinit ~= nil then
			treetype.common_postinit(inst)
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) 
				if not inst:HasTag("burnt") then
					inst.replica.container:WidgetSetup("winter_tree_hof") 
				end
			end
			
			return inst
		end

		inst.OnPlayAnim = treetype.onplayanim
		inst.OnChop = treetype.onchop
		inst.SortDecor = treetype.sortdecorfn

		inst.statedata = statedata[1]
		inst.seedprefab = treetype.seedprefab
		inst.logprefab = treetype.logprefab
		inst.canshelter = treetype.shelter
		inst.maxseeds = treetype.maxseeds
		
		inst:AddComponent("timer")

		inst:AddComponent("growable")
		inst.components.growable.stages = GROWTH_STAGES
		inst.components.growable:SetStage(1)
		inst.components.growable.magicgrowable = true

		inst:AddComponent("simplemagicgrower")
		inst.components.simplemagicgrower:SetLastStage(#inst.components.growable.stages)

		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLootSetupFn(LootSetupFn)

		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = GetStatus

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(1)
		inst.components.workable:SetOnWorkCallback(OnWorked)

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("winter_tree_hof")
		inst.components.container.canbeopened = false
		
		if treetype.master_postinit ~= nil then
			treetype.master_postinit(inst)
		end
		
		MakeHauntableWork(inst)
		MakeSnowCovered(inst)
		MakeMediumBurnable(inst, nil, nil, true)
		MakeMediumPropagator(inst)
		inst.components.burnable:SetOnBurntFn(OnBurnt)

		inst:ListenForEvent("itemget", AddDecor)
		inst:ListenForEvent("itemlose", RemoveDecor)
		inst:ListenForEvent("updatelight", UpdateLights)
		inst.RefreshDecor = RefreshDecor

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		inst.OnLoadPostPass = OnLoadPostPass

		return inst
	end

	table.insert(trees, Prefab(treetype.name, fn, assets, prefabs))
end

for i, v in ipairs({
	{
		name            = "kyno_winter_meadowisland_tree",
		minimapicon     = "kyno_winter_meadowisland_tree",
		bank            = "wintertree_deciduous",
		build           = "teatree_trunk_build",
		
		seedprefab      = "kyno_oaktree_pod",
		logprefab       = "driftwood_log",
		
		extrabuilds     =
		{
			"teatree_build",
			"kyno_meadowisland_tree_sapling",
		},
		
		extraprefabs    =
		{
			"green_leaves",
			"green_leaves_chop",
            
			"kyno_twiggynuts",
			"kyno_tealeaf",
		},
		
		shelter         = true,
		
		common_postinit = TeaTree_Postinit,
		onchop = TeaTree_OnChop,
			
		sortdecorfn     = function(inst, fx, slot)
			fx.AnimState:SetFinalOffset((slot <= 1 and 5) or (slot <= 3 and 3) or (slot <= 4 and 4) or (slot <= 6 and 2) or 1)
		end,
	},
	
	{
		name            = "kyno_winter_kokonuttree",
		minimapicon     = "kyno_winter_kokonuttree",
		bank            = "kokonuttree_winter",
		build           = "kokonuttree_winter_build",
		
		seedprefab      = "kyno_kokonut",
		logprefab       = "log",
		
		maxseeds        = 1,
		
		extrabuilds     =
		{
			"kyno_kokonut",
		},
		
		extraprefabs    =
		{
			"pine_needles_chop",
		},
		
		shelter         = true,
		
		common_postinit = KokonutTree_Postinit,
		onchop          = KokonutTree_OnChop,
		
		sortdecorfn     = function(inst, fx, slot)
			fx.AnimState:SetFinalOffset((slot <= 2 and -1) or (slot <= 4 and 3) or (slot <= 5 and 2) or 1)
		end,
	},
	
	{
		name            = "kyno_winter_sugartree",
		minimapicon     = "kyno_winter_sugartree",
		bank            = "wintertree_deciduous",
		build           = "quagmire_tree_cotton_trunk_build",
		
		seedprefab      = "kyno_sugartree_bud",
		logprefab       = "log",
		
		extrabuilds     =
		{
			"sugartree_winter_build",
			"kyno_serenityisland_sapling",
		},
		
		extraprefabs    =
		{
			"kyno_sap",
		},
		
		shelter         = true,
		
		common_postinit = SugarTree_Postinit,
			
		sortdecorfn     = function(inst, fx, slot)
			fx.AnimState:SetFinalOffset((slot <= 1 and 5) or (slot <= 3 and 3) or (slot <= 4 and 4) or (slot <= 6 and 2) or 1)
		end,
	},
	
}) do
	AddHofWinterTree(v)
end

return unpack(trees)