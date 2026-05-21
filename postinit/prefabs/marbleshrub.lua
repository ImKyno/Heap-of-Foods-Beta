local _G = GLOBAL

-- Allows Wickerbottom's book to grow some plants.
local function MarbleShrubPostInit(inst)
	inst:AddTag("marbletree")
end

AddPrefabPostInit("marbleshrub", MarbleShrubPostInit)