--[[
-- This belongs to Accomplishments Mod.
local _G = GLOBAL
local modName = "Heap-of-Foods"

local trophy_mod_name = "workshop-2843097516" -- DO NOT MODIFY. Must check if the Accomplishments Mod exists.
local enabled_in_mim  = (_G.TheNet:GetServerGameMode() == "") and _G.KnownModIndex.IsMiMEnabled and _G.KnownModIndex:IsMiMEnabled(trophy_mod_name)
local enabled_in_game = (_G.TheNet:GetServerGameMode() ~= "") and _G.KnownModIndex:IsModEnabled(trophy_mod_name)
if not (enabled_in_mim or enabled_in_game) then return end

local categories =
{
    "Hof",
}

-- Register all the new categories.
_G.KAACHIEVEMENT.CATEGORIES = _G.KAACHIEVEMENT.CATEGORIES or {}
for i,v in ipairs(categories) do
    _G.require("achievements/achievements_" .. string.lower(v))
    table.insert(_G.KAACHIEVEMENT.CATEGORIES, v)
end

print(modName, "Loaded achievementsmain.lua")
]]--