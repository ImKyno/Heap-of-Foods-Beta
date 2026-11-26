local LegacyEntities = require("hof_legacyentities")

local LegacyEntity = Class(function(self, inst)
	self.inst = inst

	self.islegacy = false
	self.loaded = false
end)

function LegacyEntity:Check(creator)
	if self.loaded or self.islegacy then
		return true
	end

	local userid = type(creator) == "string" and creator or creator ~= nil and creator.userid

	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - LegacyEntity: Creator", creator)
		print("Heap of Foods Mod - LegacyEntity: UserID", userid)
	end

	if LegacyEntities("isallowed", userid) then
		print("Heap of Foods Mod - LegacyEntity: Spawn Authorized.")

		return true
	end

	print("Heap of Foods Mod - LegacyEntity: you are trying to spawn a legacy entity without authorization!")
	print("Heap of Foods Mod - LegacyEntity: Spawn Denied.")

	self.inst:Remove()

	return false
end

function LegacyEntity:OnSave()
	if self.islegacy then
		return { islegacy = true }
	end
end

function LegacyEntity:OnLoad(data)
	self.loaded = true
	self.islegacy = true
end

return LegacyEntity