local _G = GLOBAL

local function BlueprintPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.is_rare then
		inst.build = "blueprint_rare02" -- This is used within SGwilson, sent from an event in fishingrod.lua
	end
end

AddPrefabPostInit("blueprint", BlueprintPostInit)