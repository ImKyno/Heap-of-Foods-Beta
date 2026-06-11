local _G = GLOBAL

-- Nuts drops from Twiggy Trees.
local function TwiggyTreePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.workable ~= nil then
		local onfinish_old = inst.components.workable.onfinish

		inst.components.workable:SetOnFinishCallback(function(inst, chopper)
			if inst.components.lootdropper ~= nil then
				inst.components.lootdropper:AddChanceLoot("kyno_twiggynuts", 0.25)
			end

			if onfinish_old ~= nil then
				onfinish_old(inst, chopper)
			end
		end)
	end
end

AddPrefabPostInit("twiggytree", TwiggyTreePostInit)