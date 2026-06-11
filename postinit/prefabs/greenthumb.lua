local _G = GLOBAL

local GREENTHUMB_VALID_PREFABS =
{
    "blue_mushroom",
    "bullkelp_plant",
    "carrot_planted",
    "cave_fern",
    "flower",
    "flower_evil",
    "green_mushroom",
    "lichen",
    "mushroom_farm",
    "oceanvine",
    "planted_flower",
    "red_mushroom",
    "stalker_fern",
    "succulent_plant",
}

local function GreenThumbPostInit(inst)
    inst:AddTag("greenthumb_valid")
end

for k, v in pairs(GREENTHUMB_VALID_PREFABS) do
    AddPrefabPostInit(v, GreenThumbPostInit)
end