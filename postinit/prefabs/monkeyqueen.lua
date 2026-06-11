local _G = GLOBAL

local MONKEYQUEEN_BRIBES =
{
	"bananapop",
	"frozenbananadaiquiri",
	"bananajuice",
}

-- Some NPCs changes hat during Anniversary Event.
local function MonkeyQueenPostInit(inst)
	local function OnWorldInit(inst)
		if _G.IsSpecialEventActive(_G.SPECIAL_EVENTS.HOFBIRTHDAY) then
			inst.AnimState:AddOverrideBuild("kyno_hofbirthday_monkey_queen")
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:DoTaskInTime(0, OnWorldInit)
end

local function MonkeyQueenBribesPostInit(inst)
	inst:AddTag("monkeyqueenbribe")
end

AddPrefabPostInit("monkeyqueen", MonkeyQueenPostInit)

for k, v in pairs(MONKEYQUEEN_BRIBES) do
	AddPrefabPostInit(v, MonkeyQueenBribesPostInit)
end