-- Everything below here belongs to the Accomplishments Mod.
local _G           = GLOBAL
local modName      = "Heap of Foods"
local categoryName = "Hof"

local strings = 
{
    HOF =
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
		
		DRINKPIRATERUM_TITLE = "Cannon Barrage",
		DRINKPIRATERUM_DESC = "Drink the Pirate's Rum and uncover its mystery.",
		
		DRINKTEQUILA_TITLE = "Shifting Tempo",
		DRINKTEQUILA_DESC = "Drink the Twisted Tequila and get yourself lost in time!",
		
		DRINKCOFFEE_TITLE = "Faster Than The Light",
		DRINKCOFFEE_DESC = "Drink a Coffee and become faster than everything else. Speedy!",
		
		PIGELDER_TITLE = "Tranquil Merchant",
		PIGELDER_DESC = "Strike a deal with the Pig Elder and unclose new trades.",
    },
}

_G.STRINGS.ACCOMPLISHMENTS.UI.CATEGORY[string.upper(categoryName)] = _G.FirstToUpper(categoryName)
for k,v in pairs(strings) do
    _G.STRINGS.ACCOMPLISHMENTS[k] = v
end