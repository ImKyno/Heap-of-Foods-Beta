-- Just for warding off bats for now, but we can expand in the future!
local MUST_TAGS = {"bat"}
local CANT_TAGS = {"INLIMBO", "FX", "player", "companion"}

local function OnPanic(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.KYNO_PANICBUFF_RADIUS, MUST_TAGS, CANT_TAGS)

	for _, bat in ipairs(ents) do
		if bat.components.hauntable ~= nil and bat.components.hauntable.panicable then
			bat.components.hauntable:Panic(TUNING.KYNO_PANICBUFF_PANIC_TIME)
		end

		if bat.components.combat ~= nil then
			bat.components.combat:GiveUp()
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PANICBUFF_START"))
	end

	if not target:HasTag("batfriendly") then
		target:AddTag("batfriendly")
	end

	inst._panictask = inst:DoPeriodicTask(TUNING.KYNO_PANICBUFF_TICK_PERIOD, function()
		OnPanic(inst)
	end)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target:HasTag("batfriendly") then
		target:RemoveTag("batfriendly")
	end

	if inst._panictask ~= nil then
		inst._panictask:Cancel()
		inst._panictask = nil
	end

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PANICBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_panicbuff")
	inst.components.timer:StartTimer("kyno_panicbuff", TUNING.KYNO_HEALINGBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PANICBUFF_START"))
	end

	if target:HasTag("batfriendly") then
		target:RemoveTag("batfriendly")
		target:AddTag("batfriendly")
	else
		target:AddTag("batfriendly")
	end

	if inst._panictask ~= nil then
		inst._panictask:Cancel()
		inst._panictask = nil
	end

	inst._panictask = inst:DoPeriodicTask(TUNING.KYNO_PANICBUFF_TICK_PERIOD, function()
		OnPanic(inst)
	end)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_panicbuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		return
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_panicbuff", TUNING.KYNO_PANICBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_panicbuff", fn)