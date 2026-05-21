local _G = GLOBAL

-- New fish that can be stored inside Tin Fishin' Bin.
local function EelPostInit(inst)
	inst:AddTag("fish_box_valid")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("eel",     EelPostInit)
AddPrefabPostInit("pondeel", EelPostInit)