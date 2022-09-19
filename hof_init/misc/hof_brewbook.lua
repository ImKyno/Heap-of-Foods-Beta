-- Common Dependencies.
local _G                    = GLOBAL
local require               = _G.require
local cooking               = require("cooking")
local brewing               = require("hof_brewing")
local CookbookData          = require("cookbookdata")
local BrewbookPopupScreen 	= require("screens/brewbookpopupscreen")

-- Adds the new widget/screen the Brewbook.
AddPopup("BREWBOOK")

_G.POPUPS.BREWBOOK.fn = function(inst, show)
	if inst.HUD then
		if not show then
			inst.HUD:CloseBrewbookScreen()
		elseif not inst.HUD:OpenBrewbookScreen() then
			_G.POPUPS.BREWBOOK:Close(inst)
		end
	end
end

AddClassPostConstruct("screens/playerhud", function(playerhud)
	playerhud.CloseBrewbookScreen = function(self)
		if self.brewbookscreen then
			if self.brewbookscreen.inst:IsValid() then
				_G.TheFrontEnd:PopScreen(self.brewbookscreen)
			end
			
			self.brewbookscreen = nil			
		end
	end
	
	playerhud.OpenBrewbookScreen = function(self)
		self:CloseBrewbookScreen()
		self.brewbookscreen = BrewbookPopupScreen(self.owner)
		self:OpenScreenUnderPause(self.brewbookscreen)
		
		return true
	end
end)

-- After game update (Rev. 522362), Klei changed how the Cookbook works, fixing its bugs. That broke our Brewbook,
-- making the recipes of the products cooked impossible to be unlocked and registered. So make sure to update this
-- function and its counterparts (components, prefabs, etc) whenever if it gets changed, otherwise it will not work.
local _IsValidEntry = CookbookData.IsValidEntry
CookbookData.IsValidEntry = function(self, product)
    local ret = false
    if _IsValidEntry ~= nil then ret = _IsValidEntry(self, product) end
    
    for brewer, recipes in pairs(brewing.brewbook_recipes) do
        if recipes[product] ~= nil then
            return true
        end
    end

	-- print("#### Changed CookbookData:IsValidEntry to fix the Brewbook. ####")
    return ret
end