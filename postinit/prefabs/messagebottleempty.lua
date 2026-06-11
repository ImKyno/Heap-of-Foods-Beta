local _G = GLOBAL

-- Action for storing Souls inside bottles. (Only Wortox).
local function MessageBottleEmptyPostInit(inst)
	inst:AddTag("soul_storage")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("messagebottleempty", MessageBottleEmptyPostInit)