-- Everything below here belongs to the Accomplishments Mod.
local _G           = GLOBAL
local modName      = "Heap of Foods"
local Image        = require("widgets/image")
local categoryName = "Hof"

require("stringutil")
require("achievements/achievements_" .. string.lower(categoryName))

print(modName, categoryName, _G.KAACHIEVEMENT.CATEGORIES[categoryName])

if _G.KAACHIEVEMENT.CATEGORIES[categoryName] == nil then
    table.insert(_G.KAACHIEVEMENT.CATEGORIES, categoryName)
end

print(modName, string.format("Trying to load category \"%s\"", categoryName))

require("achievements/achievements_" .. string.lower(categoryName))

_G.TheKaAchievementLoader:ImportEntries(categoryName)

AddClassPostConstruct("screens/kaachievementspopup", function(self)
    local button_bar = self.achievements.button_bar

    for k,button in pairs(button_bar.children) do
        if button.category == categoryName then
            if button.overlay_image then
                button:RemoveChild(button.overlay_image)
                button.overlay_image = nil
            end

            button.overlay_image = button:AddChild(
                Image("images/achievementsimages/hof_achievements_buttons.xml",
                      string.format("achievements_buttons_%s.tex", string.lower(button.category))))
            button.overlay_image:SetScale(1.5)
            break
        end
    end
end)

print(modName, "Loaded modmain.lua")