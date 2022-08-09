-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require
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
