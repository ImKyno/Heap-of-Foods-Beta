local _G      = GLOBAL
local require = _G.require

-- Cool effect for enchanted items.
AddClassPostConstruct("widgets/itemtile", function(self)
	local UIAnim = require("widgets/uianim")

	local function _StartUpdating(self, flag)
		if next(self.updatingflags) == nil then
			self:StartUpdating()
		end

		self.updatingflags[flag] = true
	end

	local function _StopUpdating(self, flag)
		self.updatingflags[flag] = nil

		if next(self.updatingflags) == nil then
			self:StopUpdating()
		end
	end

	function self:StartUpdatingEnchanted()
		self.updateenchanteddelay = 0
		_StartUpdating(self, "enchanted")
	end

	function self:StopUpdatingEnchanted()
		_StopUpdating(self, "enchanted")
		self.updateenchanteddelay = nil
	end

	function self:StartUpdatingShadow2()
		self.updateshadow2delay = 0
		_StartUpdating(self, "shadow2")
	end

	function self:StopUpdatingShadow2()
		_StopUpdating(self, "shadow2")
		self.updateshadow2delay = nil
	end

	local _OnUpdate = self.OnUpdate

	function self:OnUpdate(dt)
		if _OnUpdate then
			_OnUpdate(self, dt)
		end

		if self.updatingflags and self.updatingflags.enchanted then
			self.updateenchanteddelay = (self.updateenchanteddelay or 0) + dt

			if self.updateenchanteddelay > 0.2 then
				self.updateenchanteddelay = 0

				self:CheckEnchantedFX()
			end
		end

		if self.updatingflags and self.updatingflags.shadow2 then
			self.updateshadow2delay = (self.updateshadow2delay or 0) + dt

			if self.updateshadow2delay > 0.2 then
				self.updateshadow2delay = 0

				self:CheckShadow2FX()
			end
		end
	end

	function self:CheckEnchantedFX()
		if self.item:HasTag("goldenapple") then
			self.enchantedfx:Show()
		else
			self.enchantedfx:Hide()
		end
	end

	function self:CheckShadow2FX()
		if self.item:HasTag("shadow_fooditem") then
			self.shadow2fx:Show()
		else
			self.shadow2fx:Hide()
		end
	end

	function self:ToggleEnchantedFX()
		if self.showequipenchantedfx or (self.item and self.item:HasTag("goldenapple")) then
			if self.enchantedfx == nil then
				self.enchantedfx = self.image:AddChild(UIAnim())
				self.enchantedfx:GetAnimState():SetBank("inventory_fx_enchanted")
				self.enchantedfx:GetAnimState():SetBuild("inventory_fx_enchanted")
				self.enchantedfx:GetAnimState():PlayAnimation("idle", true)
				self.enchantedfx:GetAnimState():SetTime(math.random() * self.enchantedfx:GetAnimState():GetCurrentAnimationTime())
				self.enchantedfx:SetScale(.25)
				self.enchantedfx:GetAnimState():AnimateWhilePaused(false)
				self.enchantedfx:SetClickable(false)
			end

			if self.item:HasTag("goldenapple") then
				self:CheckEnchantedFX()
				self:StartUpdatingEnchanted()
			else
				self:StopUpdatingEnchanted()
			end
		elseif self.enchantedfx ~= nil then
			self.enchantedfx:Kill()
			self.enchantedfx = nil
		end
	end

	function self:ToggleShadow2FX()
		if self.showequipshadow2fx or (self.item and self.item:HasTag("shadow_fooditem")) then
			if self.shadow2fx == nil then
				self.shadow2fx = self.image:AddChild(UIAnim())
				self.shadow2fx:GetAnimState():SetBank("inventory_fx_shadow")
				self.shadow2fx:GetAnimState():SetBuild("inventory_fx_shadow")
				self.shadow2fx:GetAnimState():PlayAnimation("idle", true)
				self.shadow2fx:GetAnimState():SetTime(math.random() * self.shadow2fx:GetAnimState():GetCurrentAnimationTime())
				self.shadow2fx:SetScale(.25)
				self.shadow2fx:GetAnimState():AnimateWhilePaused(false)
				self.shadow2fx:SetClickable(false)
			end

			if self.item:HasTag("shadow_fooditem") then
				self:CheckShadow2FX()
				self:StartUpdatingShadow2()
			else
				self:StopUpdatingShadow2()
			end
		elseif self.shadow2fx ~= nil then
			self.shadow2fx:Kill()
			self.shadow2fx = nil
		end
	end

	local _SetIsEquip = self.SetIsEquip

	function self:SetIsEquip(isequip)
		local enchantedfx = isequip and self.item:HasTag("goldenapple")
		local shadow2fx = isequip and self.item:HasTag("shadow_fooditem")

		if not self.showequipenchantedfx == enchantedfx then
			self.showequipenchantedfx = enchantedfx or nil
			self:ToggleEnchantedFX()
		end

		if not self.showequipshadow2fx == shadow2fx then
			self.showequipshadow2fx = shadow2fx or nil
			self:ToggleShadow2FX()
		end

		return _SetIsEquip(self, isequip)
	end

	self:ToggleEnchantedFX()
	self:ToggleShadow2FX()
end)