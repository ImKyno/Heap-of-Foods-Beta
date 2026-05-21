local _G = GLOBAL

require("stategraphs/commonstates")

AddStategraphPostInit("shark", function(sg)
	local _eat_pre = sg.states["eat_pre"].ontimeout

	sg.states["eat_pre"].ontimeout = function(inst)
		_eat_pre(inst)

		local targetpt = _G.Vector3(inst.Transform:GetWorldPosition())

		if inst.foodtoeat and inst.foodtoeat:IsValid() then
			targetpt = _G.Vector3(inst.foodtoeat.Transform:GetWorldPosition())
		end

		inst.Transform:SetPosition(targetpt.x, 0, targetpt.z)
		inst.sg:GoToState("eat_pst2")
	end
end)