-- This belongs to Accomplishments Mod.
local modName = "Heap-of-Foods"
local _G = GLOBAL

Assets =
{
    -- For individual achievements.
    Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    -- For achievements category.
    Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),

    -- For candidate cards.
    Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

modimport("hof_init/strings/hof_strings")
modimport("achievementsmain")

print(modName, "Loaded modclientmain.lua")