local _G = GLOBAL

-- Bees drops Nectar based on how much flowers they have pollinated.
-- They can pollinate up to 5 flowers, so: 20%, 40%, 60%, 80%, 100% chance for each flower pollinated.
AddStategraphPostInit("bee", function(sg)
	local _death_onenter = sg.states["death"].onenter

	sg.states["death"].onenter = function(inst, ...)
		if inst.components.pollinator ~= nil and inst.components.lootdropper ~= nil then
			inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod", 0.20 * #inst.components.pollinator.flowers)
		end

		_death_onenter(inst, ...)
	end
end)