local SapHealer = Class(function(self, inst)
    self.inst = inst
end)

function SapHealer:Heal(target)
    if target:HasTag("sap_healable") and target:HasTag("sap_healable_bucket") then
		local pos = target:GetPosition()
		local tree = SpawnPrefab("kyno_sugartree_sapped")
		
		if tree.components.pickable then
			tree.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
			tree.components.pickable:MakeEmpty()
		end
		
		SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
		tree.Transform:SetPosition(pos:Get())
		target:Remove()
		
	else
		local pos = target:GetPosition()
		local tree = SpawnPrefab("kyno_sugartree")
		
		tree.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
		
		SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
		tree.Transform:SetPosition(pos:Get())
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
