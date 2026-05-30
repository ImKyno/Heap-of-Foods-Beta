
local values = {}

local function RegisterPrefab(prefab, pigcoinvalue)
	if prefab == nil or type(pigcoinvalue) ~= "table" then
		return
	end

	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Pig Coin Economy: Registering:", prefab)
	end

	values[prefab] =
	{
		pigcoinvalue[1] or 0,
		pigcoinvalue[2] or 0,
		pigcoinvalue[3] or 0,
	}
end

local function UnregisterPrefab(prefab)
	values[prefab] = nil
end

-- This is for prepared food files with multiple recipes.
local function RegisterRecipes(recipes)
	if recipes == nil then
		return
	end

	for prefab, data in pairs(recipes) do
		if data.pigcoinvalue ~= nil then
			RegisterPrefab(prefab, data.pigcoinvalue)
		end
	end
end

local function PrefabHasValue(item)
	local result = item ~= nil and item.prefab ~= nil and values[item.prefab] ~= nil

	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Pig Coin Economy: HasValue:", item and item.prefab, result)
	end

	return result
end

local function GetPrefabValue(item)
	if item == nil or item.prefab == nil then
		return nil
	end

	return values[item.prefab]
end

local function GetValueByPrefab(prefab)
	return values[prefab]
end

local function LaunchItem(item, angle)
	local speed = math.random() * 4 + 2
	angle = (angle + math.random() * 60 - 30) * DEGREES

	item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function GiveCoins(inst, giver, item)
	local value = GetPrefabValue(item)

	if value == nil then
		return false
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	y = 4.5

	local angle

	if giver ~= nil and giver:IsValid() then
		angle = 180 - giver:GetAngleToPoint(x, 0, z)
	else
		local down = TheCamera:GetDownVec()
		angle = math.atan2(down.z, down.x) / DEGREES
		giver = nil
	end

	local toss_anim = math.random() < 0.50 and "toss1" or "toss2"

	for i = 1, value[1] do
		local coin = SpawnPrefab("kyno_pigcoin1")

		if coin ~= nil then
			coin.AnimState:PlayAnimation(toss_anim)
			coin.Transform:SetPosition(x, y, z)
			
			LaunchItem(coin, angle)
			coin:PushEvent("oncointossed")
		end
	end

	for i = 1, value[2] do
		local coin = SpawnPrefab("kyno_pigcoin2")

		if coin ~= nil then
			coin.AnimState:PlayAnimation(toss_anim)
			coin.Transform:SetPosition(x, y, z)

			LaunchItem(coin, angle)
			coin:PushEvent("oncointossed")
		end
	end

	for i = 1, value[3] do
		local coin = SpawnPrefab("kyno_pigcoin3")

		if coin ~= nil then
			coin.AnimState:PlayAnimation(toss_anim)
			coin.Transform:SetPosition(x, y, z)

			LaunchItem(coin, angle)
			coin:PushEvent("oncointossed")
		end
	end

	return true
end

global("PigCoinEconomyAddPrefab")
function PigCoinEconomyAddPrefab(prefab, pigcoinvalue)
	RegisterPrefab(prefab, pigcoinvalue)
end

global("PigCoinEconomyRemovePrefab")
function PigCoinEconomyRemovePrefab(prefab)
	UnregisterPrefab(prefab)
end

global("PigCoinEconomyGetPrefabValue")
function PigCoinEconomyGetPrefabValue(prefab)
	return GetValueByPrefab(prefab)
end

return 
{
	RegisterPrefab   = RegisterPrefab,
	UnregisterPrefab = UnregisterPrefab,
	RegisterRecipes  = RegisterRecipes,
	PrefabHasValue   = PrefabHasValue,
	GetPrefabValue   = GetPrefabValue,
	GetValueByPrefab = GetValueByPrefab,
	GiveCoins        = GiveCoins,
}