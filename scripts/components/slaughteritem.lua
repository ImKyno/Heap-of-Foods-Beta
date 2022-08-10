local SlaughterItem = Class(function(self, inst)
    self.inst = inst
end)

function SlaughterItem:Slaughter(doer, target)
	if doer.killer_task then
		doer.killer_task:Cancel()
		doer.killer_task = nil
	end
	
	--[[
	if doer:HasTag("animal_butcher") then -- Extra Meat if Wigfrid kills the target.
		if target.components.lootdropper then
			target.components.lootdropper:AddChanceLoot("meat", 1)
		end
	end
	]]--
	
	target.components.health.invincible = false
	target.components.health:Kill()
	
	--[[
	for i, allkillers in ipairs(AllPlayers) do
		allkillers:AddTag("animal_killer")
		allkillers.killer_task = allkillers:DoTaskInTime(100, function(allkillers)
			allkillers:RemoveTag("animal_killer")
		end)
	end
	]]--
end

return SlaughterItem