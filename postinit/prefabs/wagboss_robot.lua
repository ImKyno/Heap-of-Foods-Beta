local _G      = GLOBAL
local require = _G.require

local function WagBossRobotPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_opalpreciousapple", 1.00)
	end
end

AddPrefabPostInit("wagboss_robot", WagBossRobotPostInit)