local _G           = GLOBAL
local require      = _G.require
local modName      = "Heap-of-Foods"
local categoryName = "Hof"

local categories =
{
    "Hof",
}

--[[
-- Accomplishments Assets.
Assets =
{
    Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),
}
]]--

-- Register each new category.
for _,categoryName in ipairs(categories) do
    require("achievements/achievements_" .. string.lower(categoryName))

    _G.TheKaAchievementLoader:RegisterCategory(categoryName)

    _G.KAACHIEVEMENT.EXTRA_BUTTON_IMAGE_PATH[categoryName] = _G.resolvefilepath("images/achievementsimages/hof_achievements_buttons.xml")
    _G.KAACHIEVEMENT.EXTRA_TROPHY_IMAGE_PATH[categoryName] = _G.resolvefilepath("images/achievementsimages/hof_achievements_images.xml")
end

-- Strings for UI.
local stringTables =
{
    fancyNames =
    {
        en  = "Culinary",
        br  = "Culinária",
        kr  = "Culinary",
        zh  = "Culinary",
        zht = "Culinary",
    },
    trophyStrings =
    {
        en =
        {
            SERENITYBIOME_TITLE = "Serenity Rocks",
            SERENITYBIOME_DESC = "Discover the Serenity Archipelago for the first time.",

            SEASIDEBIOME_TITLE = "Over The Seas",
            SEASIDEBIOME_DESC = "Discover the Seaside Island for the first time.",

            EATFOODS_TITLE = "Overencumbered Mouth",
            EATFOODS_DESC = "Eat a total of 2000 foods of any type.",
            EATFOODS_LABEL = "Eaten",

            HOFCOOKBOOK_TITLE = "Pandemonium Kitchen",
            HOFCOOKBOOK_DESC = "Cook every new dish possible.",
            HOFCOOKBOOK_LABEL = "Cooked",

            HOFBREWBOOK_TITLE = "The Brewmaster",
            HOFBREWBOOK_DESC = "Brew every beverage possible.",
            HOFBREWBOOK_LABEL = "Brewed",

            WARLYHOF1_TITLE = "Extremely Delightful Taste",
            WARLYHOF1_DESC = "As Warly, eat every new dish available in the menu.",
            WARLYHOF1_LABEL = "Eaten",

            WARLYHOF2_TITLE = "Ultimate Chef's Hour",
            WARLYHOF2_DESC = "As Warly, cook every of the new exclusive dishes.",
            WARLYHOF2_LABEL = "Cooked",

            CRAFTHOFBOOKS_TITLE = "Culinary Master",
            CRAFTHOFBOOKS_DESC = "Craft for yourself a brand new Cookbook and a Brewbook.",
            CRAFTHOFBOOKS_LABEL = "Crafted",

            HONEYDEPOSIT_TITLE = "Bottomless Honey Storage",
            HONEYDEPOSIT_DESC = "Build a Honey Deposit for an endless supply of honey.",

            CARAMELCUBE_TITLE = "Caramelized",
            CARAMELCUBE_DESC = "Eat a Caramel Cube. Kyno's favourite dish.",

            DRINKALCOHOLIC_TITLE = "Biv's Drinking Game",
            DRINKALCOHOLIC_DESC = "Drink an alcoholic beverage. Drink in moderation!",

            -- DRINKPIRATERUM_TITLE = "Cannon Barrage",
            -- DRINKPIRATERUM_DESC = "Drink the Pirate's Rum and uncover its mystery.",

            -- DRINKTEQUILA_TITLE = "Shifting Tempo",
            -- DRINKTEQUILA_DESC = "Drink the Twisted Tequila and get yourself lost in time!",

            DRINKCOFFEE_TITLE = "Faster Than The Light",
            DRINKCOFFEE_DESC = "Drink a Coffee and become faster than everything else. Speedy!",

            PIGELDER_TITLE = "Tranquil Merchant",
            PIGELDER_DESC = "Strike a deal with the Pig Elder and unclose new trades.",

            GRINDER_TITLE = "Mealing My Way In",
            GRINDER_DESC = "Grind an ingredient at the Mealing Stone.",

            FLAYANIMAL_TITLE = "The Slaughter",
            FLAYANIMAL_DESC = "Kill a poor animal using the Slaughter Tools.",

            CATCHPEBBLE_TITLE = "Crabby'ing my Boots",
            CATCHPEBBLE_DESC = "Catch an elusive Pebble Crab using the Crab Trap.",
        },

        br =
        {
            SERENITYBIOME_TITLE = "Rochas Serenas",
            SERENITYBIOME_DESC = "Descubra o Arquipélago Sereno pela primeira vez.",

            SEASIDEBIOME_TITLE = "Além Dos Mares",
            SEASIDEBIOME_DESC = "Descubra a Ilha Beira-mar pela primeira vez.",

            EATFOODS_TITLE = "Boca Cheia",
            EATFOODS_DESC = "Coma um total de 2000 comidas de quaisquer tipo.",
            EATFOODS_LABEL = "Comido",

            HOFCOOKBOOK_TITLE = "Cozinha Pandemônio",
            HOFCOOKBOOK_DESC = "Cozinhe todos os novos pratos possíveis.",
            HOFCOOKBOOK_LABEL = "Cozinhado",

            HOFBREWBOOK_TITLE = "Mestre Fermentador",
            HOFBREWBOOK_DESC = "Fermente todas bebidas possíveis.",
            HOFBREWBOOK_LABEL = "Fermentado",

            WARLYHOF1_TITLE = "Sabores Extremamente Deliciosos",
            WARLYHOF1_DESC = "Como Warly, deguste todos os novos pratos disponíveis no menu.",
            WARLYHOF1_LABEL = "Degustado",

            WARLYHOF2_TITLE = "Hora Suprema do Chef",
            WARLYHOF2_DESC = "Como Warly, cozinhe todos seus novos pratos exclusivos.",
            WARLYHOF2_LABEL = "Cozinhado",

            CRAFTHOFBOOKS_TITLE = "Mestre Culinário",
            CRAFTHOFBOOKS_DESC = "Crie para você, um Livro de Receitas e um Livro de Fermentação totalmente novos.",
            CRAFTHOFBOOKS_LABEL = "Criado",

            HONEYDEPOSIT_TITLE = "Armazém de Mel Sem Fim",
            HONEYDEPOSIT_DESC = "Construa um Depósito de Mel para um armazém sem limite de mel.",

            CARAMELCUBE_TITLE = "Caramelizado",
            CARAMELCUBE_DESC = "Coma um Cubo de Caramelo. O prato favorito do Kyno.",

            DRINKALCOHOLIC_TITLE = "Jogo de Bebidas do Biv",
            DRINKALCOHOLIC_DESC = "Beba uma bebida alcoólica. Beba com moderação!",

            -- DRINKPIRATERUM_TITLE = "Barragem de Canhão",
            -- DRINKPIRATERUM_DESC = "Beba um Rum de Pirata e descubra o segredo por trás dele.",

            -- DRINKTEQUILA_TITLE = "Mudança de Tempo",
            -- DRINKTEQUILA_DESC = "Beba uma Tequila Retorcida e se perca através do tempo-espaço.",

            DRINKCOFFEE_TITLE = "Veloz Como a Luz",
            DRINKCOFFEE_DESC = "Beba um Café e se torne mais rápido do que todos. Que velocidade!",

            PIGELDER_TITLE = "Mercante Tranquilo",
            PIGELDER_DESC = "Faça uma negociação com o Porco Ancião e abra novas possíveis trocas.",

            GRINDER_TITLE = "Preparo Necessário",
            GRINDER_DESC = "Prepare um ingrediente na Pedra de Preparação.",

            FLAYANIMAL_TITLE = "Bem-vindo ao Abatedouro",
            FLAYANIMAL_DESC = "Mate um pobre animal indefeso usando a Ferramentas de Abate.",

            CATCHPEBBLE_TITLE = "Carangueijando",
            CATCHPEBBLE_DESC = "Capture um Carangueijo utilizando uma armadilha.",
        },

        kr =
        {
            SERENITYBIOME_TITLE = "Serenity Rocks",
            SERENITYBIOME_DESC = "Discover the Serenity Archipelago for the first time.",

            SEASIDEBIOME_TITLE = "Over The Seas",
            SEASIDEBIOME_DESC = "Discover the Seaside Island for the first time.",

            EATFOODS_TITLE = "Overencumbered Mouth",
            EATFOODS_DESC = "Eat a total of 2000 foods of any type.",
            EATFOODS_LABEL = "Eaten",

            HOFCOOKBOOK_TITLE = "Pandemonium Kitchen",
            HOFCOOKBOOK_DESC = "Cook every new dish possible.",
            HOFCOOKBOOK_LABEL = "Cooked",

            HOFBREWBOOK_TITLE = "The Brewmaster",
            HOFBREWBOOK_DESC = "Brew every beverage possible.",
            HOFBREWBOOK_LABEL = "Brewed",

            WARLYHOF1_TITLE = "Extremely Delightful Taste",
            WARLYHOF1_DESC = "As Warly, eat every new dish available in the menu.",
            WARLYHOF1_LABEL = "Eaten",

            WARLYHOF2_TITLE = "Ultimate Chef's Hour",
            WARLYHOF2_DESC = "As Warly, cook every of the new exclusive dishes.",
            WARLYHOF2_LABEL = "Cooked",

            CRAFTHOFBOOKS_TITLE = "Culinary Master",
            CRAFTHOFBOOKS_DESC = "Craft for yourself a brand new Cookbook and a Brewbook.",
            CRAFTHOFBOOKS_LABEL = "Crafted",

            HONEYDEPOSIT_TITLE = "Bottomless Honey Storage",
            HONEYDEPOSIT_DESC = "Build a Honey Deposit for an endless supply of honey.",

            CARAMELCUBE_TITLE = "Caramelized",
            CARAMELCUBE_DESC = "Eat a Caramel Cube. Kyno's favourite dish.",

            DRINKALCOHOLIC_TITLE = "Biv's Drinking Game",
            DRINKALCOHOLIC_DESC = "Drink an alcoholic beverage. Drink in moderation!",

            -- DRINKPIRATERUM_TITLE = "Cannon Barrage",
            -- DRINKPIRATERUM_DESC = "Drink the Pirate's Rum and uncover its mystery.",

            -- DRINKTEQUILA_TITLE = "Shifting Tempo",
            -- DRINKTEQUILA_DESC = "Drink the Twisted Tequila and get yourself lost in time!",

            DRINKCOFFEE_TITLE = "Faster Than The Light",
            DRINKCOFFEE_DESC = "Drink a Coffee and become faster than everything else. Speedy!",

            PIGELDER_TITLE = "Tranquil Merchant",
            PIGELDER_DESC = "Strike a deal with the Pig Elder and unclose new trades.",

            GRINDER_TITLE = "Mealing My Way In",
            GRINDER_DESC = "Grind an ingredient at the Mealing Stone.",

            FLAYANIMAL_TITLE = "The Slaughter",
            FLAYANIMAL_DESC = "Kill a poor animal using the Slaughter Tools.",

            CATCHPEBBLE_TITLE = "Crabby'ing my Boots",
            CATCHPEBBLE_DESC = "Catch an elusive Pebble Crab using the Crab Trap.",
        },

        zh =
        {
            SERENITYBIOME_TITLE = "Serenity Rocks",
            SERENITYBIOME_DESC = "Discover the Serenity Archipelago for the first time.",

            SEASIDEBIOME_TITLE = "Over The Seas",
            SEASIDEBIOME_DESC = "Discover the Seaside Island for the first time.",

            EATFOODS_TITLE = "Overencumbered Mouth",
            EATFOODS_DESC = "Eat a total of 2000 foods of any type.",
            EATFOODS_LABEL = "Eaten",

            HOFCOOKBOOK_TITLE = "Pandemonium Kitchen",
            HOFCOOKBOOK_DESC = "Cook every new dish possible.",
            HOFCOOKBOOK_LABEL = "Cooked",

            HOFBREWBOOK_TITLE = "The Brewmaster",
            HOFBREWBOOK_DESC = "Brew every beverage possible.",
            HOFBREWBOOK_LABEL = "Brewed",

            WARLYHOF1_TITLE = "Extremely Delightful Taste",
            WARLYHOF1_DESC = "As Warly, eat every new dish available in the menu.",
            WARLYHOF1_LABEL = "Eaten",

            WARLYHOF2_TITLE = "Ultimate Chef's Hour",
            WARLYHOF2_DESC = "As Warly, cook every of the new exclusive dishes.",
            WARLYHOF2_LABEL = "Cooked",

            CRAFTHOFBOOKS_TITLE = "Culinary Master",
            CRAFTHOFBOOKS_DESC = "Craft for yourself a brand new Cookbook and a Brewbook.",
            CRAFTHOFBOOKS_LABEL = "Crafted",

            HONEYDEPOSIT_TITLE = "Bottomless Honey Storage",
            HONEYDEPOSIT_DESC = "Build a Honey Deposit for an endless supply of honey.",

            CARAMELCUBE_TITLE = "Caramelized",
            CARAMELCUBE_DESC = "Eat a Caramel Cube. Kyno's favourite dish.",

            DRINKALCOHOLIC_TITLE = "Biv's Drinking Game",
            DRINKALCOHOLIC_DESC = "Drink an alcoholic beverage. Drink in moderation!",

            -- DRINKPIRATERUM_TITLE = "Cannon Barrage",
            -- DRINKPIRATERUM_DESC = "Drink the Pirate's Rum and uncover its mystery.",

            -- DRINKTEQUILA_TITLE = "Shifting Tempo",
            -- DRINKTEQUILA_DESC = "Drink the Twisted Tequila and get yourself lost in time!",

            DRINKCOFFEE_TITLE = "Faster Than The Light",
            DRINKCOFFEE_DESC = "Drink a Coffee and become faster than everything else. Speedy!",

            PIGELDER_TITLE = "Tranquil Merchant",
            PIGELDER_DESC = "Strike a deal with the Pig Elder and unclose new trades.",

            GRINDER_TITLE = "Mealing My Way In",
            GRINDER_DESC = "Grind an ingredient at the Mealing Stone.",

            FLAYANIMAL_TITLE = "The Slaughter",
            FLAYANIMAL_DESC = "Kill a poor animal using the Slaughter Tools.",

            CATCHPEBBLE_TITLE = "Crabby'ing my Boots",
            CATCHPEBBLE_DESC = "Catch an elusive Pebble Crab using the Crab Trap.",
        },

        zht =
        {
            SERENITYBIOME_TITLE = "Serenity Rocks",
            SERENITYBIOME_DESC = "Discover the Serenity Archipelago for the first time.",

            SEASIDEBIOME_TITLE = "Over The Seas",
            SEASIDEBIOME_DESC = "Discover the Seaside Island for the first time.",

            EATFOODS_TITLE = "Overencumbered Mouth",
            EATFOODS_DESC = "Eat a total of 2000 foods of any type.",
            EATFOODS_LABEL = "Eaten",

            HOFCOOKBOOK_TITLE = "Pandemonium Kitchen",
            HOFCOOKBOOK_DESC = "Cook every new dish possible.",
            HOFCOOKBOOK_LABEL = "Cooked",

            HOFBREWBOOK_TITLE = "The Brewmaster",
            HOFBREWBOOK_DESC = "Brew every beverage possible.",
            HOFBREWBOOK_LABEL = "Brewed",

            WARLYHOF1_TITLE = "Extremely Delightful Taste",
            WARLYHOF1_DESC = "As Warly, eat every new dish available in the menu.",
            WARLYHOF1_LABEL = "Eaten",

            WARLYHOF2_TITLE = "Ultimate Chef's Hour",
            WARLYHOF2_DESC = "As Warly, cook every of the new exclusive dishes.",
            WARLYHOF2_LABEL = "Cooked",

            CRAFTHOFBOOKS_TITLE = "Culinary Master",
            CRAFTHOFBOOKS_DESC = "Craft for yourself a brand new Cookbook and a Brewbook.",
            CRAFTHOFBOOKS_LABEL = "Crafted",

            HONEYDEPOSIT_TITLE = "Bottomless Honey Storage",
            HONEYDEPOSIT_DESC = "Build a Honey Deposit for an endless supply of honey.",

            CARAMELCUBE_TITLE = "Caramelized",
            CARAMELCUBE_DESC = "Eat a Caramel Cube. Kyno's favourite dish.",

            DRINKALCOHOLIC_TITLE = "Biv's Drinking Game",
            DRINKALCOHOLIC_DESC = "Drink an alcoholic beverage. Drink in moderation!",

            -- DRINKPIRATERUM_TITLE = "Cannon Barrage",
            -- DRINKPIRATERUM_DESC = "Drink the Pirate's Rum and uncover its mystery.",

            -- DRINKTEQUILA_TITLE = "Shifting Tempo",
            -- DRINKTEQUILA_DESC = "Drink the Twisted Tequila and get yourself lost in time!",

            DRINKCOFFEE_TITLE = "Faster Than The Light",
            DRINKCOFFEE_DESC = "Drink a Coffee and become faster than everything else. Speedy!",

            PIGELDER_TITLE = "Tranquil Merchant",
            PIGELDER_DESC = "Strike a deal with the Pig Elder and unclose new trades.",

            GRINDER_TITLE = "Mealing My Way In",
            GRINDER_DESC = "Grind an ingredient at the Mealing Stone.",

            FLAYANIMAL_TITLE = "The Slaughter",
            FLAYANIMAL_DESC = "Kill a poor animal using the Slaughter Tools.",

            CATCHPEBBLE_TITLE = "Crabby'ing my Boots",
            CATCHPEBBLE_DESC = "Catch an elusive Pebble Crab using the Crab Trap.",
        }
    }
}

-- Register the strings.
_G.KaRegisterTrophyStrings(categoryName, stringTables)

print(modName, "Loaded achievementsmain.lua")