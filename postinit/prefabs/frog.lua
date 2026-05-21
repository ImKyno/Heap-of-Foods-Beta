local _G = GLOBAL

-- For the Noxious Froggle Bunwich effect.
local function FrogPostInit(inst)
	local RETARGET_MUST_TAGS       = {"_combat", "_health"}
	local RETARGET_CANT_TAGS       = {"merm", "frogimmunity"}
	local LUNAR_RETARGET_CANT_TAGS = {"merm", "lunar_aligned", "frogimmunity"}

	local function Retarget(inst)
	if not inst.components.health:IsDead() and not (inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep()) then
		local target_dist = inst.islunar and TUNING.LUNARFROG_TARGET_DIST or TUNING.FROG_TARGET_DIST
		local cant_tags   = inst.islunar and LUNAR_RETARGET_CANT_TAGS or RETARGET_CANT_TAGS

		return FindEntity(inst, target_dist, function(guy)
			if not guy.components.health:IsDead() then
				return guy.components.inventory ~= nil and inst.hof_oldretarget
			end
		end,

			RETARGET_MUST_TAGS, cant_tags)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.combat ~= nil then
		inst.hof_oldretarget = inst.components.combat.targetfn
		inst.components.combat:SetRetargetFunction(3, Retarget)
	end

	if inst.islunar then
		inst.components.lootdropper:SetLoot({"kyno_moon_froglegs"})
	end
end

AddPrefabPostInit("frog",      FrogPostInit)
AddPrefabPostInit("lunarfrog", FrogPostInit)