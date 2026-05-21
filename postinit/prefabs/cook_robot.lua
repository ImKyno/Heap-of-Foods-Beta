local _G = GLOBAL

-- Valid Cooking Pots and Containers for the S0US-CH3F.
local COOK_ROBOT_POTS =
{
	"cookpot",
	"archive_cookpot",
}

local COOK_ROBOT_CONTAINERS =
{
	"icebox",
	"saltbox",
	"fish_box",
	"potatosack",
	"treasurechest",
	"dragonflychest",
}

local function CookRobotPotsPostInit(inst)
	inst:AddTag("cook_robot_cooker_valid")
end

local function CookRobotContainersPostInit(inst)
	inst:AddTag("cook_robot_storage_valid")
end

for k, v in pairs(COOK_ROBOT_POTS) do
	AddPrefabPostInit(v, CookRobotPotsPostInit)
end

for k, v in pairs(COOK_ROBOT_CONTAINERS) do
	AddPrefabPostInit(v, CookRobotContainersPostInit)
end