local SapHealer = Class(function(self, inst)
	self.inst = inst
end)

function SapHealer:Heal(target)
	if target:HasTag("sap_healable") and target:HasTag("sap_healable_bucket") then
		local pos = target:GetPosition()
		
		local owner = self.inst.components.inventoryitem ~= nil and 
		self.inst.components.inventoryitem.owner or self.inst.components.inventoryitem:GetGrandOwner() or nil
		
		local tree = SpawnPrefab("kyno_sugartree_sapped")
		tree.Transform:SetPosition(pos:Get())
		
		if tree.components.pickable ~= nil then
			tree.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
			tree.components.pickable:MakeEmpty()
		end
		
		SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
		
		if owner ~= nil then
			owner:PushEvent("saphealerused")
		end
		
		target:Remove()
		
		if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
			self.inst.components.stackable:Get():Remove()
		else
			self.inst:Remove()
		end
		
		return true
	else
		local pos = target:GetPosition()
		
		local owner = self.inst.components.inventoryitem ~= nil and 
		self.inst.components.inventoryitem.owner or self.inst.components.inventoryitem:GetGrandOwner() or nil
					
		local tree = SpawnPrefab("kyno_sugartree")
		tree.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
		tree.Transform:SetPosition(pos:Get())
		
		SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
		
		if owner ~= nil then
			owner:PushEvent("saphealerused")
		end
		
		target:Remove()
		
		if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
			self.inst.components.stackable:Get():Remove()
		else
			self.inst:Remove()
		end
		
		return true
	end
end

return SapHealer
