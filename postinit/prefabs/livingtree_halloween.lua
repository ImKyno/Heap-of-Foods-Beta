local _G = GLOBAL

-- Allows Wickerbottom's book to grow some plants.
local function LivingTreeHalloween(inst)
	inst:AddTag("livingtree_halloween")
end

AddPrefabPostInit("livingtree_halloween", LivingTreeHalloween)