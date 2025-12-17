require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_hofbirthday_cake.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"bird_egg",
	"lighterfire",

	"butter_beefalo",
	"kyno_flour",
	"kyno_milk_beefalo",
	"kyno_salt",

	"kyno_hofbirthday_cakefire",
	"kyno_hofbirthday_cake_fx_fireworks",
	"kyno_hofbirthday_cake_fx_sparkle",
	"kyno_hofbirthday_cake_fx_streamer",
	"kyno_hofbirthday_cake_fx_white",
	
	"kyno_hofbirthday_cake_slice1",
	"kyno_hofbirthday_cake_slice2",
	"kyno_hofbirthday_cake_slice3",
	"kyno_hofbirthday_cheer",
}

SetSharedLootTable("kyno_hofbirthday_cake",
{
	{"bird_egg",               1.00},
	{"bird_egg",               1.00},
	{"bird_egg",               1.00},
	{"bird_egg",               1.00},
	{"bird_egg",               1.00},
	
	{"butter_beefalo",         1.00},
	
	{"kyno_flour",             1.00},
	{"kyno_flour",             1.00},
	{"kyno_flour",             1.00},
	{"kyno_flour",             1.00},
	{"kyno_flour",             1.00},
	
	{"kyno_hofbirthday_cheer", 1.00},
	
    {"kyno_milk_beefalo",      1.00},
	{"kyno_milk_beefalo",      1.00},
	{"kyno_milk_beefalo",      1.00},
	{"kyno_milk_beefalo",      1.00},
	{"kyno_milk_beefalo",      1.00},
	
	{"kyno_salt",              1.00},
	{"kyno_salt",              1.00},
	{"kyno_salt",              1.00},
	{"kyno_salt",              1.00},
	{"kyno_salt",              1.00},
})

local function SanityAura(inst, observer)
	return TUNING.SANITYAURA_MED
end

local function RefreshCandles(inst)
	local candle_symbols =
	{
		"candle1",
		"candle2",
		"candle3",
		"candle4",
		"candle5",
	}

	if not inst._candles then
		inst._candles = {}
	end

	local uses = inst.components.finiteuses:GetUses()
	local should_have_candles = uses > 20

	for i, sym in ipairs(candle_symbols) do
		local candle = inst._candles[i]

		if should_have_candles then
			if not candle or not candle:IsValid() then
				candle = SpawnPrefab("kyno_hofbirthday_cakefire")
				
				if candle.Follower == nil then
					candle.entity:AddFollower()
				end
				
				candle.Follower:FollowSymbol(inst.GUID, sym, 0, 0, 0, true)
				inst._candles[i] = candle
				
				inst:DoTaskInTime(0, function()
					inst.Light:Enable(true)
				end)
			end
		else
			if candle and candle:IsValid() then
				if candle.Follower ~= nil then
					candle.Follower:StopFollowing()
				end
				
				candle:Remove()
				inst._candles[i] = nil
				
				inst:DoTaskInTime(0, function()
					inst.Light:Enable(false)
				end)
			end
		end
	end
end

local function RemoveCandles(inst)
	if inst._candles then
		for i, candle in ipairs(inst._candles) do
			if candle and candle:IsValid() then
				if candle.Follower ~= nil then
					candle.Follower:StopFollowing()
				end
				
				candle:Remove()
			end
			
			inst._candles[i] = nil
		end
	end
end

local function UpdateCakeAppearance(inst)
	local uses = inst.components.finiteuses:GetUses()
	local anim = "idle_full"

	if uses <= 10 then
		anim = "idle_low"
	elseif uses <= 20 then
		anim = "idle_med"
	end

	inst.AnimState:PlayAnimation(anim, true)
	RefreshCandles(inst)
end

-- Cake Slice changes based on how many uses are left.
local function GetCakeSliceProduct(inst)
	local uses = inst.components.finiteuses:GetUses()

	if uses > 20 then
		return "kyno_hofbirthday_cake_slice1"
	elseif uses > 10 then
		return "kyno_hofbirthday_cake_slice2"
	else
		return "kyno_hofbirthday_cake_slice3"
	end
end

local function OnCakeSliced(inst)	
	inst.components.finiteuses:Use(1)
	inst.SoundEmitter:PlaySound("aqol/new_test/cloth")
	
	UpdateCakeAppearance(inst)
end

local function LaunchFireworks(inst)
	local fireworks = SpawnPrefab("kyno_hofbirthday_cake_fx_fireworks")
	fireworks.Follower:FollowSymbol(inst.GUID, "plate", 0, 400, 0, true)
	
	inst.SoundEmitter:PlaySound("yotd2024/startingpillar/launch_fireworks")
end

local function PlayerAnnounceCakeDone(inst)
	inst:PushEvent("hofbirthdaycakecomplete")
end

local function OnBuilt(inst, data)	
	local fx = SpawnPrefab("kyno_hofbirthday_cake_fx_white")
	fx.Follower:FollowSymbol(inst.GUID, "level3", 0, 0, 0, true)
	
	local sparkle = SpawnPrefab("kyno_hofbirthday_cake_fx_sparkle")
	sparkle.Follower:FollowSymbol(inst.GUID, "sparkle_bottom", 0, 0, 0, true)
	
	local streamer = SpawnPrefab("kyno_hofbirthday_cake_fx_streamer")
	streamer.Follower:FollowSymbol(inst.GUID, "level2", 0, 0, 0, true)
	
	LaunchFireworks(inst)
	inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/friendship_music/10")
	
	-- Launch Fireworks again.
	inst:DoTaskInTime(3, function()
		LaunchFireworks(inst)
	end)
	
	UpdateCakeAppearance(inst)
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRangeSq(x, y, z, 10 * 10, true)
	
	for _, player in ipairs(players) do
		PlayerAnnounceCakeDone(player)
	end
end

local function OnFinished(inst, worker)
	RemoveCandles(inst)

	local fx = SpawnPrefab("beefalo_transform_fx")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst:Remove()
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)
	UpdateCakeAppearance(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.8)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetRadius(3)
	inst.Light:Enable(false)
	inst.Light:SetColour(197/255, 197/255, 10/255)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_hofbirthday_cake.tex")

	MakeObstaclePhysics(inst, 1.2)

	inst.AnimState:SetBank("kyno_hofbirthday_cake")
	inst.AnimState:SetBuild("kyno_hofbirthday_cake")
	inst.AnimState:PlayAnimation("idle_full", true)

	inst:AddTag("structure")
	inst:AddTag("anniversarycake")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("sliceable_world")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._candles = {}

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("kyno_hofbirthday_cake")
	inst.components.lootdropper.spawn_loot_inside_prefab = true
	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = SanityAura
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.HOFBIRTHDAY_CAKE_USES)
	inst.components.finiteuses:SetUses(TUNING.HOFBIRTHDAY_CAKE_USES)
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("sliceable")
	inst.components.sliceable:SetWorldSlice(true)
	inst.components.sliceable:SetProductFn(GetCakeSliceProduct)
	inst.components.sliceable:SetOnWorldSliceFn(OnCakeSliced)
	inst.components.sliceable:SetSliceSize(1)
	
	inst:DoTaskInTime(0, RefreshCandles)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("onremove", RemoveCandles)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_hofbirthday_cake", fn, assets, prefabs),
MakePlacer("kyno_hofbirthday_cake_placer", "kyno_hofbirthday_cake", "kyno_hofbirthday_cake", "idle_full")