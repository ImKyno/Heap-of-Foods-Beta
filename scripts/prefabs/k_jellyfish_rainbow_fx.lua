-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
local lightprefabs =
{
	"kyno_jellyfish_rainbow_light",
	"kyno_jellyfish_rainbow_light_fx",
}

local greaterlightprefabs =
{
	"kyno_jellyfish_rainbow_light_greater",
	"kyno_jellyfish_rainbow_light_fx_greater",
}

local function LightResume(inst, time)
	inst.fx:setprogress(1 - time / inst.components.spell.duration)
end

local function LightStart(inst)
	inst.fx:setprogress(0)
end

local function PushBloom(inst, target)
	if target.components.bloomer ~= nil then
		target.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
	elseif not target:HasTag("trophyscale_fish") then
		target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	end
end

local function PopBloom(inst, target)
	if target.components.bloomer ~= nil then
		target.components.bloomer:PopBloom(inst)
	elseif not target:HasTag("trophyscale_fish") then
		target.AnimState:ClearBloomEffectHandle()
	end
end

local function OnOwnerChange(inst)
	local newowners = {}
	local owner = inst._target
	local isrider = false
	
	while true do
		newowners[owner] = true

		local rider = owner.components.rideable and owner.components.rideable:GetRider()
		local invowner = owner.components.inventoryitem and owner.components.inventoryitem.owner

		if inst._owners[owner] then
			inst._owners[owner] = nil
		else
			if owner.components.rideable then
				inst:ListenForEvent("riderchanged", inst._onownerchange, owner)
			end
			
			if not rider and owner.components.inventoryitem then
				inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
				inst:ListenForEvent("ondropped", inst._onownerchange, owner)
			end
		end

		local nextowner = rider or invowner
        
		if not nextowner then
			break
		end
		
		isrider = rider ~= nil
		owner = nextowner
	end

	inst.fx.entity:SetParent(owner.entity)

	if inst._popbloom ~= nil and inst._popbloom ~= owner then
		PopBloom(inst, inst._popbloom)
        
		if isrider then
			PushBloom(inst, owner)
			inst._popbloom = owner
		else
			inst._popbloom = nil
		end
	end

	for k, v in pairs(inst._owners) do
		if k:IsValid() then
			if k.components.inventoryitem then
				inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
				inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
			end
			
			if k.components.rideable then
				inst:RemoveEventCallback("riderchanged", inst._riderchanged, k)
			end
		end
	end

	inst._owners = newowners
end

local function LightOnTarget(inst, target)
	if target == nil or target:HasTag("playerghost") or target:HasTag("overcharge") then
		inst:Remove()
		return
	end

	local function ForceRemove()
		inst.components.spell:OnFinish()
	end

	inst._target = target
	target.wormlight = inst
    
	inst.Follower:FollowSymbol(target.GUID, "", 0, 0, 0)
	inst:ListenForEvent("onremove", ForceRemove, target)
	inst:ListenForEvent("death", function() inst.fx:setdead() end, target)

	if target:HasTag("player") then
		inst:ListenForEvent("ms_becameghost", ForceRemove, target)
		
		if target:HasTag("electricdamageimmune") then
			inst:ListenForEvent("ms_overcharge", ForceRemove, target)
		end
		
		inst.persists = false
	else
		inst.persists = not target:HasTag("critter")
	end

	PushBloom(inst, target)
	OnOwnerChange(inst)
end

local function LightOnFinish(inst)
	local target = inst.components.spell.target
	
	if target ~= nil then
		target.wormlight = nil
        PopBloom(inst, target)

		if target.components.rideable ~= nil then
			local rider = target.components.rideable:GetRider()
			
			if rider ~= nil then
				PopBloom(inst, rider)
			end
		end
	end
end

local function LightOnRemove(inst)
	inst.fx:Remove()
end

local function commonfn(duration, fxprefab)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddFollower()

	inst:Hide()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst:AddComponent("spell")
	inst.components.spell.spellname = "kyno_rainbow_jellyfish_fx"
	inst.components.spell.duration = duration
	inst.components.spell.ontargetfn = LightOnTarget
	inst.components.spell.onstartfn = LightStart
	inst.components.spell.onfinishfn = LightOnFinish
	inst.components.spell.resumefn = LightResume
	inst.components.spell.removeonfinish = true

	inst.persists = false
	inst.fx = SpawnPrefab(fxprefab)
	inst.OnRemoveEntity = LightOnRemove

	inst._owners = {}
	inst._onownerchange = function() OnOwnerChange(inst) end

	return inst
end

local function lightfn()
	return commonfn(TUNING.KYNO_JELLYFISH_RAINBOW_LIGHT_DURATION, "kyno_jellyfish_rainbow_light_fx")
end

local function greaterlightfn()
    return commonfn(TUNING.KYNO_JELLYFISH_RAINBOW_LIGHT_GREATER_DURATION, "kyno_jellyfish_rainbow_light_fx_greater")
end

local noupdate_parents = 
{
	["trophyscale_fish"] = true,
}

local function OnUpdateLight(inst, dt)
	local frame = inst._lightdead:value() and math.ceil(inst._lightframe:value() * .9 + inst._lightmaxframe * .1) or (inst._lightframe:value() + dt)

	if frame >= inst._lightmaxframe then
		inst._lightframe:set_local(inst._lightmaxframe)
		inst._lighttask:Cancel()
		inst._lighttask = nil
	else
		local parent = inst.entity:GetParent()
		
		if parent and not noupdate_parents[parent.prefab] then
			inst._lightframe:set_local(frame)
		end
		
		inst._colourframe = inst._colourframe + dt
		
		if inst._colourframe >= 120 then
			inst._colourframe = 0
			inst._colourprev = inst._colouridx
			inst._colouridx = inst._colouridx + 1
			
			if inst._colouridx > #inst._colours then
				inst._colouridx = 1
			end
		end
		
		local lerpk = inst._colourframe / 120
		
		inst.Light:SetColour(
			inst._colours[inst._colourprev][1] * (1 - lerpk) + inst._colours[inst._colouridx][1] * lerpk,
			inst._colours[inst._colourprev][2] * (1 - lerpk) + inst._colours[inst._colouridx][2] * lerpk,
			inst._colours[inst._colourprev][3] * (1 - lerpk) + inst._colours[inst._colouridx][3] * lerpk
		)
	end

	inst.Light:SetRadius(TUNING.KYNO_JELLYFISH_RAINBOW_LIGHT_RADIUS * (1 - inst._lightframe:value() / inst._lightmaxframe))
end

local function OnLightDirty(inst)
	if inst._lighttask == nil then
		inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
	end
	
	OnUpdateLight(inst, 0)
end

local function SetProgress(inst, percent)
	inst._lightframe:set(math.max(0, math.min(inst._lightmaxframe, math.floor(percent * inst._lightmaxframe + .5))))
	OnLightDirty(inst)
end

local function SetDead(inst)
	inst._lightdead:set(true)
	inst._lightframe:set(inst._lightframe:value())
end

local function fxfn(duration)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.Light:SetRadius(0)
	inst.Light:SetIntensity(.8)
	inst.Light:SetFalloff(.5)
	inst.Light:SetColour(0, 0, 0)
	inst.Light:Enable(true)
	inst.Light:EnableClientModulation(true)

	inst._colours = 
	{
		{ 0/255,   180/255, 255/255 },
		{ 240/255, 230/255, 100/255 },
		{ 251/255, 30/255,  30/255  },
	}
	
	inst._colouridx = 1
	inst._colourprev = #inst._colours
	inst._colourframe = 0

	inst._lightmaxframe = math.floor(duration / FRAMES + .5)
	inst._lightframe = net_ushortint(inst.GUID, "kyno_jellyfish_rainbow_light_fx._lightframe", "lightdirty")
	inst._lightframe:set(inst._lightmaxframe)
	inst._lightdead = net_bool(inst.GUID, "kyno_jellyfish_rainbow_light_fx._lightdead")
	inst._lighttask = nil

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst:ListenForEvent("lightdirty", OnLightDirty)
		return inst
	end

	inst.setprogress = SetProgress
	inst.setdead = SetDead
	inst.persists = false

	return inst
end

local function lightfxfn()
    return fxfn(TUNING.KYNO_JELLYFISH_RAINBOW_LIGHT_DURATION)
end

local function greaterlightfxfn()
    return fxfn(TUNING.KYNO_JELLYFISH_RAINBOW_LIGHT_GREATER_DURATION)
end

return Prefab("kyno_jellyfish_rainbow_light", lightfn, nil, lightprefabs),
Prefab("kyno_jellyfish_rainbow_light_fx", lightfxfn),

Prefab("kyno_jellyfish_rainbow_light_greater", greaterlightfn, nil, greaterlightprefabs),
Prefab("kyno_jellyfish_rainbow_light_fx_greater", greaterlightfxfn)