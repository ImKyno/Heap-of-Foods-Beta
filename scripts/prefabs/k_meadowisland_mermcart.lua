local assets =
{	
	Asset("ANIM", "anim/kyno_meadowisland_mermcart.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big",
	"small_puff",
}

local EMPTY_PREFAB = "EMPTY"
local RUMMAGE_SOUND_NAME = "rummage"

local function SquidTest()
	if TUNING.SQUID_TEST_RADIUS > 0 then
		return true
	end
end

local SQUID_ENABLED = SquidTest() or nil

local LOOT =
{
	CRITTERS =
	{
		{ weight = 4, prefab = "kyno_piko",        target = false, state = "look",   tuning = "KYNO_PIKO_ENABLED",        season = nil }, -- 57.14%
		{ weight = 1, prefab = "kyno_piko_orange", target = false, state = "look",   tuning = "KYNO_PIKO_ORANGE_ENABLED", season = nil }, -- 14.29%
		{ weight = 2, prefab = "mole",             target = false, state = "peek",   tuning = "MOLE_ENABLED",             season = nil }, -- 28.57%
		{ weight = 2, prefab = "squid",            target = true,  state = "attack", tuning = SQUID_ENABLED,              season = nil }, -- 28.57%
	},
	
	ITEMS =
	{
		{ weight = 8, prefab = "wagpunk_bits", season = "winter" }, -- 25%
		{ weight = 4, prefab = EMPTY_PREFAB,   season = nil }, -- 12.5%
		{ weight = 4, prefab = "rocks",        season = nil }, -- 12.5%
		{ weight = 4, prefab = "log",          season = nil }, -- 12.5%
		{ weight = 2, prefab = "boards",       season = nil }, -- 6.25%
		{ weight = 2, prefab = "potato",       season = nil }, -- 6.25%
		{ weight = 1, prefab = "transistor",   season = nil }, -- 3.125%
		{ weight = 1, prefab = "trinket_6",    season = nil }, -- 3.125%
		{ weight = 1, prefab = "blueprint",    season = nil }, -- 3.125%
		{ weight = 1, prefab = "gears",        season = nil }, -- 3.125%
	},
}

local WEIGHTED_CRITTER_TABLE = {}
local WEIGHTED_ITEM_TABLE = {}

for _, critter in ipairs(LOOT.CRITTERS) do
	WEIGHTED_CRITTER_TABLE[critter] = critter.weight

	if critter.prefab ~= EMPTY_PREFAB then
		table.insert(prefabs, critter.prefab)
	end
end

for _, item in ipairs(LOOT.ITEMS) do
	WEIGHTED_ITEM_TABLE[item] = item.weight

	if item.prefab ~= EMPTY_PREFAB then
		table.insert(prefabs, item.prefab)
	end
end

local function IsCorrectSeason(loot)
	if loot.season == nil then
		return true
	end
	
	return TheWorld.state.season == loot.season
end


local function SpawnWagonLoot(inst, picker, nopickup)
	if math.random() <= TUNING.KYNO_MERMCART_CRITTER_CHANCE then
		local choice = weighted_random_choice(WEIGHTED_CRITTER_TABLE)
		local enabled = choice.tuning and TUNING[choice.tuning]
        
		if (enabled == nil or enabled) and choice.prefab ~= nil and choice.prefab ~= EMPTY_PREFAB and IsCorrectSeason(choice) then
			local critter = SpawnPrefab(choice.prefab)
			local attackplayer = not (critter:HasTag("spider") and picker:HasOneOfTags("spiderwhisperer", "spiderdisguise"))
			
			inst.components.lootdropper:FlingItem(critter)
			
			if attackplayer and choice.target and critter.components.combat ~= nil then
                critter.components.combat:SetTarget(picker)
            end
			
			if choice.state ~= nil and (not choice.target or attackplayer) then
				critter.sg:GoToState(choice.state, picker)
			end
		end
	end

	local choice = weighted_random_choice(WEIGHTED_ITEM_TABLE)

	if choice.prefab ~= nil and choice.prefab ~= EMPTY_PREFAB and IsCorrectSeason(choice) then
		local item = SpawnPrefab(choice.prefab)
		
		if item.components.perishable ~= nil then
			item.components.perishable:SetPercent(TUNING.KYNO_MERMCART_PERISHABLE_PERCENT)
		end
		
		if not nopickup and picker.components.inventory ~= nil then
			picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
		else
			inst.components.lootdropper:FlingItem(item)
		end
	end
end

local function OnPicked(inst, picker)
	if inst.on_cooldown then
		if picker ~= nil and picker.components.talker ~= nil then
			picker.components.talker:Say("MONKEY")
		end
        
		return
	end

	SpawnWagonLoot(inst, picker)

	inst.uses_left = inst.uses_left - 1

	if inst.uses_left <= 0 then
		inst.on_cooldown = true
        
		inst.components.timer:StartTimer("wagon_cooldown", TUNING.KYNO_MERMCART_COOLDOWN)
		-- inst.AnimState:PlayAnimation("cooldown_idle")
		-- inst.components.pickable:MakeEmpty()
    end
end

local function StartPickingLoot(inst)
	if inst._pickingtask ~= nil then
		inst._pickingtask:Cancel()
		inst._pickingtask = nil
	end
	
	inst._pickingloop = true
    inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_sml", "rummage")
end

local function StopPickingLoot(inst, nosound)
	if inst._pickingtask ~= nil then
		inst._pickingtask:Cancel()
		inst._pickingtask = nil

		return
	end
	
	inst._pickingloop = nil
	inst.SoundEmitter:KillSound(RUMMAGE_SOUND_NAME)
	
	if not nosound then
		inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_pst", nil, 0.3)
	end
end

local function StartPicking(inst, doer)
	if inst._pickingtask == nil then
		inst._pickingtask = inst:DoTaskInTime(0.2, StartPickingLoot)
	end

	inst._pickers = inst._pickers or {}

	if inst._pickers[doer] ~= nil then
		return
	end

	local pickingstate = doer.sg.currentstate.name

	local cb = function(doer, data)
		if not (data and data.statename == pickingstate) then
			inst:StopPicking(doer)
		end
	end

	inst._pickers[doer] = cb

	inst:ListenForEvent("newstate", cb, doer)
	inst:ListenForEvent("onremove", cb, doer)
end

local function StopPicking(inst, doer, nosound)
	local cb = inst._pickers and inst._pickers[doer] or nil
	
	if cb == nil then
		return
	end

	inst:RemoveEventCallback("newstate", cb, doer)
	inst:RemoveEventCallback("onremove", cb, doer)
	
	inst._pickers[doer] = nil

	if next(inst._pickers) == nil then
		inst._pickers = nil
		inst:StopPickingLoot(nosound)
    end
end

local function OnRegen(inst)
	-- inst.AnimState:PlayAnimation("idle")
end

local function OnMakeEmpty(inst)

end

local function OnTimerDone(inst, data)
	if data.name == "wagon_cooldown" then
		inst.on_cooldown = false
        
		inst.uses_left = TUNING.KYNO_MERMCART_USES
		-- inst.components.pickable:Regen()
		-- inst.AnimState:PlayAnimation("idle")
	end
end

local function OnSave(inst, data)
    data.uses_left = inst.uses_left
    data.on_cooldown = inst.on_cooldown

    if inst.components.timer:TimerExists("wagon_cooldown") then
        data.cooldown_timer = inst.components.timer:GetTimeLeft("wagon_cooldown")
    end
end

local function OnLoad(inst, data)
    if data then
        inst.uses_left = data.uses_left or TUNING.KYNO_MERMCART_USES
        inst.on_cooldown = data.on_cooldown or false

        if inst.on_cooldown then
            -- inst.components.pickable:MakeEmpty()
            -- inst.AnimState:PlayAnimation("cooldown_idle")
			print("YESSS")

            if data.cooldown_timer then
				print("YESSS AGAIN")
                inst.components.timer:StartTimer("wagon_cooldown", data.cooldown_timer)
            else
				print("NOOOO")
                inst.components.timer:StartTimer("wagon_cooldown", WAGON_COOLDOWN_TIMER)
            end
        else
			print("NOOOO AGAIN")
            -- inst.components.pickable:Regen()
            -- inst.AnimState:PlayAnimation("idle")
        end
    end
end

local function OnSeasonChange(inst, season)
	return TheWorld.state.season
end

local function SetWagonArt(inst, season)
	local season = OnSeasonChange(inst)

	local fx = SpawnPrefab("small_puff")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx.Transform:SetScale(1.7, 1.7, 1.7)
	
	inst.AnimState:PlayAnimation("idle_"..season or "empty", true)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_mermcart.tex")
	minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("kyno_meadowisland_mermcart")
    inst.AnimState:SetBuild("kyno_meadowisland_mermcart")
	inst.AnimState:PlayAnimation("empty")
	
	inst:AddTag("sammywagon")
	inst:AddTag("pickable_rummage_str")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.on_cooldown = false
	inst.uses_left = TUNING.KYNO_MERMCART_USES
	inst.StartPickingLoot = StartPickingLoot
	inst.StopPickingLoot = StopPickingLoot
	inst.SpawnWagonLoot = SpawnWagonLoot
	inst.StartPicking = StartPicking
	inst.StopPicking = StopPicking

	inst:AddComponent("timer")
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "qol1/wagstaff_ruins/rummagepile_sml"
    inst.components.pickable:SetUp(nil, 0)
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.makeemptyfn = OnMakeEmpty
	
	inst:WatchWorldState("season", SetWagonArt)
	SetWagonArt(inst, TheWorld.state.season)
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("startlongaction", inst.StartPicking)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("kyno_meadowisland_mermcart", fn, assets, prefabs)