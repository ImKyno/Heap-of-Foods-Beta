local _G = GLOBAL

local CUSTOM_FLOWERS =
{
	[150] = true,
	[151] = true,
}

local function DecorFlowerVasePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.vase ~= nil then
		local _onupdateflowerfn = inst.components.vase.onupdateflowerfn

		inst.components.vase:SetOnUpdateFlowerFn(function(inst, flowerid, fresh)
			if flowerid and CUSTOM_FLOWERS[flowerid] then
				if flowerid then
					inst.AnimState:ShowSymbol("swap_flower")
					inst.AnimState:OverrideSymbol("swap_flower", "swap_flower_sugartree_petals",
					string.format("f%d%s", flowerid, fresh and "" or "_wilt"))
				else
					inst.AnimState:HideSymbol("swap_flower")
				end

				if inst.prefab == "decor_flowervase" then
					if not (inst:IsAsleep()) then
						inst.AnimState:PlayAnimation("hit")
						inst.AnimState:PushAnimation("idle", false)
					end

					if inst.RefreshImage then
						inst:RefreshImage()
					end
				end
			elseif _onupdateflowerfn then
				_onupdateflowerfn(inst, flowerid, fresh)
			end
		end)
	end
end

AddPrefabPostInit("decor_flowervase", DecorFlowerVasePostInit)
AddPrefabPostInit("vaultrelic_vase", DecorFlowerVasePostInit)