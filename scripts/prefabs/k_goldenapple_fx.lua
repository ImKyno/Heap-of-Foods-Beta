-- Same as Shiny Loot FX.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=3371086303
local assets =
{
	Asset("ANIM", "anim/lavaarena_item_pickup_fx.zip"),
}

local BLINK_COLOUR = { .4, .4, .4, 0 }
local BLINK_SPEED  = .02
local FADE_SPEED   = .004
local HOLD_BLINK   = .1

local function DoPst(inst)
	inst.AnimState:PlayAnimation("pst")
	inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)
end

local function UpdateFadout(inst, object)
	if inst.blink > FADE_SPEED then
		local c = inst.blink - FADE_SPEED

		object.AnimState:SetAddColour(BLINK_COLOUR[1] * c, BLINK_COLOUR[2] * c, BLINK_COLOUR[3] * c, 0)
		object.AnimState:SetLightOverride(c)
		inst.AnimState:SetLightOverride(c)

		if c * 3 < HOLD_BLINK and inst.blink * 3 >= HOLD_BLINK then
			object.AnimState:ClearBloomEffectHandle()
		end

		inst.blink = c
	end
end

local function KillFX(inst)
	if inst._killing ~= nil then
		return
	end

	inst._killing = true

	local parent = inst.entity:GetParent()
	
	if parent ~= nil then
		if inst.blinktask ~= nil then
			inst.blinktask:Cancel()
			inst.blinktask = inst:DoPeriodicTask(0, UpdateFadout, nil, parent)
			inst.blink = math.max(0, 1 - inst.blink)
			inst.blink = 1 - inst.blink * inst.blink
		end
	end

	if inst.animtask ~= nil then
		inst.animtask:Cancel()
		inst.animtask = nil

		if inst.blinktask ~= nil then
			inst:DoTaskInTime(2, inst.Remove)
		else
			inst:Remove()
		end

	elseif not inst.AnimState:IsCurrentAnimation("pre") then
		if inst.AnimState:GetCurrentAnimationFrame() == 0 then
			DoPst(inst)
		else
			inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime(), DoPst)
		end
	end
end

local function OnPreOver(inst)
	inst:RemoveEventCallback("animover", OnPreOver)
	inst.AnimState:PlayAnimation("loop", true)
end

local function OnStartAnim(inst)
	inst.animtask = nil
	inst:Show()

	inst:ListenForEvent("animover", OnPreOver)
	inst.AnimState:PlayAnimation("pre")
end

local function OnRemoveEntity(inst)
	if inst.blinktask ~= nil then
		local parent = inst.entity:GetParent()

		if parent ~= nil then
			parent.AnimState:SetAddColour(0, 0, 0, 0)
			parent.AnimState:SetLightOverride(0)
			parent.AnimState:ClearBloomEffectHandle()

			parent._shinyfx = nil
		end
	end
end

local function UpdateBlink(inst, object)
	if inst.blink > HOLD_BLINK then
		inst.blink = math.max(HOLD_BLINK, inst.blink - BLINK_SPEED)

		local c = math.max(0, 1 - inst.blink)
		c = 1 - c * c

		object.AnimState:SetAddColour(BLINK_COLOUR[1] * c, BLINK_COLOUR[2] * c, BLINK_COLOUR[3] * c, 0)
		object.AnimState:SetLightOverride(c)
		inst.AnimState:SetLightOverride(c)
	end
end

local function AttachTo(inst, object) --, sound, duration)
	inst.entity:SetParent(object.entity)
	inst.Transform:SetPosition(0, 0, 0)

	-- inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")

	-- inst.killtask = inst:DoTaskInTime(duration, KillFX)

	object.AnimState:SetAddColour(unpack(BLINK_COLOUR))
	object.AnimState:SetLightOverride(1)
	object.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	inst.blink = 1
	inst.blinktask = inst:DoPeriodicTask(0, UpdateBlink, nil, object)

	inst:ListenForEvent("onremove", inst._topocket, object)

	--[[
	if ThePlayer ~= nil and ThePlayer:IsValid() then
		inst:ListenForEvent("itemget", inst._topocket, ThePlayer)
	end
	]]--
end

local SCALE_MIN = .55
local SCALE_MAX = .65

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	inst.AnimState:SetBank("lavaarena_item_pickup_fx")
	inst.AnimState:SetBuild("lavaarena_item_pickup_fx")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetLightOverride(1)

	local scale = GetRandomMinMax(SCALE_MIN, SCALE_MAX)
	inst.AnimState:SetScale(math.random() < .5 and -scale or scale, scale)

	inst:AddTag("FX")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	inst:Hide()

	inst.AttachTo = AttachTo
	inst.OnRemoveEntity = OnRemoveEntity
	inst.KillFX = KillFX

	inst.animtask = inst:DoTaskInTime(1 + math.random(), OnStartAnim)

	inst._topocket = function()
		local object = inst.entity:GetParent()

		if object == nil or not object:IsValid() or object:HasTag("INLIMBO") then
			inst:Remove()
		end
	end

	inst.persists = false

	return inst
end

return Prefab("kyno_goldenapple_fx", fn, assets)