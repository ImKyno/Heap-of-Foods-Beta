local _G = GLOBAL

local function FeatherPencilPostInit(inst)
	inst:AddTag("drawingpencil")
end

AddPrefabPostInit("featherpencil", FeatherPencilPostInit)