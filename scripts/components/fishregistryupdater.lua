local function onplayeractivated(inst)
	local self = inst.components.fishregistryupdater
	
	if not TheNet:IsDedicated() and inst == ThePlayer then
		self.fishregistry = TheFishRegistry
		self.fishregistry.save_enabled = true
	end
end

local FishRegistryUpdater = Class(function(self, inst)
	self.inst = inst

	self.fishregistry = require("hof_fishregistrydata")()
	inst:ListenForEvent("playeractivated", onplayeractivated)
end)

function FishRegistryUpdater:LearnFish(fish)
	if fish then
		local updated = self.fishregistry:LearnFish(fish)
		
		if TheFocalPoint.entity:GetParent() == self.inst then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		end

		if updated and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
			SendModRPCToClient(GetClientModRPC("FishRegistry", "LearnFish"), self.inst.userid, fish)
		end
	end
end

function FishRegistryUpdater:LearnRoe(roe)
	if roe then
		local updated = self.fishregistry:LearnRoe(roe)
		
		if TheFocalPoint.entity:GetParent() == self.inst then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		end

		if updated and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
			SendModRPCToClient(GetClientModRPC("FishRegistry", "LearnRoe"), self.inst.userid, roe)
		end
	end
end

return FishRegistryUpdater