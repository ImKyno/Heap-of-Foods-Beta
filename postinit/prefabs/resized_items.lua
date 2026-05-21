local _G = GLOBAL

-- Some items are a bit huge when dropped...
local RESIZE_ITEMS =
{
	"kyno_cucumber",
	"kyno_cucumber_cooked",
	"kyno_parznip_cooked",
}

local function ResizePostInit(inst)
	local SIZE = .75

	if inst.AnimState ~= nil then
		inst.AnimState:SetScale(SIZE, SIZE, SIZE)
	end
end

for k, v in pairs(RESIZE_ITEMS) do
	AddPrefabPostInit(v, ResizePostInit)
end