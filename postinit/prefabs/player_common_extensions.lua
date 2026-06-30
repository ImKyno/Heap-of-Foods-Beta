-- All of this just to play a cool animation when reviving.
-- All of this just because Klei hardcoded the entire ressurrection system.
-- ALL OF THIS JUST BECAUSE IT LOOKS COOL, RIGHT?
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/hof_upvaluehacker")
local ex_fns        = require("prefabs/player_common_extensions")

local CommonActualRez     = UpvalueHacker.GetUpvalue(ex_fns.OnRespawnFromGhost, "DoActualRez", "CommonActualRez")
local DoMoveToRezSource   = UpvalueHacker.GetUpvalue(ex_fns.OnRespawnFromGhost, "DoMoveToRezSource")
local DoMoveToRezPosition = UpvalueHacker.GetUpvalue(ex_fns.OnRespawnFromGhost, "DoMoveToRezPosition")

local _DoActualRez = UpvalueHacker.GetUpvalue(ex_fns.OnRespawnFromGhost, "DoActualRez")
local function DoActualRez(inst, source, item, ...)
	if source == nil or not source:HasTag("foodreviver") then
		return _DoActualRez(inst, source, item, ...)
	end

	local x, y, z = (source or inst).Transform:GetWorldPosition()

	if x and y and z then
		local diefx = SpawnPrefab("die_fx")

		if diefx then
			diefx.Transform:SetPosition(x, y, z)
		end
	end

	inst.AnimState:Hide("HAT")
	inst.AnimState:Hide("HAIR_HAT")
	inst.AnimState:Show("HAIR_NOHAT")
	inst.AnimState:Show("HAIR")
	inst.AnimState:Show("HEAD")
	inst.AnimState:Hide("HEAD_HAT")
	inst.AnimState:Hide("HEAD_HAT_NOHELM")
	inst.AnimState:Hide("HEAD_HAT_HELM")

	inst:Show()
	inst:SetStateGraph("SGwilson")

	inst.Physics:Teleport(x, y, z)
	inst.player_classified:SetGhostMode(false)

	inst.DynamicShadow:Enable(true)
	inst.AnimState:SetBank("wilson")
	inst.ApplySkinOverrides(inst)
	inst.components.bloomer:PopBloom("playerghostbloom")
	inst.AnimState:SetLightOverride(0)

	source:PushEvent("activateresurrection", inst)
	inst.sg:GoToState("gravestone_rebirth", source)

	inst.Light:SetIntensity(.8)
	inst.Light:SetRadius(.5)
	inst.Light:SetFalloff(.65)
	inst.Light:SetColour(255 / 255, 255 / 255, 236 / 255)
	inst.Light:Enable(false)

	MakeCharacterPhysics(inst, 75, .5)
	inst.Physics:Stop()

	CommonActualRez(inst)

	inst:RemoveTag("playerghost")
	inst.Network:RemoveUserFlag(USERFLAGS.IS_GHOST)

	inst:PushEvent("ms_respawnedfromghost")
end

UpvalueHacker.SetUpvalue(DoMoveToRezPosition, DoActualRez, "DoActualRez")
UpvalueHacker.HideFn(DoActualRez, _DoActualRez)

local _OnRespawnFromGhost = ex_fns.OnRespawnFromGhost
function ex_fns.OnRespawnFromGhost(inst, data, ...)
	if not inst:HasTag("playerghost") or data == nil or data.source == nil or not data.source:HasTag("foodreviver") then
		return _OnRespawnFromGhost(inst, data, ...)
	end

	inst:AddTag("reviving")

	inst.deathclientobj = nil
	inst.deathcause = nil
	inst.deathpkname = nil
	inst.deathbypet = nil

	inst:ShowHUD(false)

	if inst.components.playercontroller ~= nil then
		inst.components.playercontroller:Enable(false)
	end

	if inst.components.talker ~= nil then
		inst.components.talker:ShutUp()
	end

	inst.sg:AddStateTag("busy")
	inst:DoTaskInTime(9 * FRAMES, DoMoveToRezSource, data.source, 51 * FRAMES)

	local source = data.source
	inst.rezsource = (source ~= nil and source:GetBasicDisplayName()) or STRINGS.NAMES.SHENANIGANS
end

UpvalueHacker.HideFn(ex_fns.OnRespawnFromGhost, _OnRespawnFromGhost)