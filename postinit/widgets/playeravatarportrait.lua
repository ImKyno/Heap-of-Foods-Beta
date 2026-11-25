local _G = GLOBAL

AddClassPostConstruct("widgets/redux/playeravatarportrait", function(self)
	function self:SetCustomSkins(prefabname, base_skin, clothing_names, skip_change_emote, skinmode)
		self.lobbycharacter = prefabname
		self.badge:Hide()

		self.puppet:SetSkins(prefabname, base_skin, clothing_names, skip_change_emote, skinmode)
		self.puppet_root:Show()
	end
end)