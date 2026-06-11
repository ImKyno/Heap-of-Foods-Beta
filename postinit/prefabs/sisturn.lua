local _G = GLOBAL

local function SisturnPostInit(inst)
	local FLOWER_LAYERS =
	{
		"flower1_roof",
		"flower2_roof",
		"flower1",
		"flower2",
	}

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.UpdateFlowerDecor then
		local _UpdateFlowerDecor = inst.UpdateFlowerDecor

		inst.UpdateFlowerDecor = function(inst, ...)
			_UpdateFlowerDecor(inst, ...)

			if not inst:HasTag("burnt") then
				for slot, layer in ipairs(FLOWER_LAYERS) do
					local item = inst.components.container ~= nil and inst.components.container.slots[slot]

					if item and item.prefab == "kyno_sugartree_petals" then
						local skin_build = inst:GetSkinBuild()

						if not skin_build then
							inst.AnimState:OverrideSymbol("flowers_0" .. slot, "kyno_sisturn_build", "flowers_sugar")
						else
							inst.AnimState:OverrideSkinSymbol("flowers_0" .. slot, "kyno_sisturn_build", "flowers_sugar")
						end
					end
				end
			end
		end
	end
end

AddPrefabPostInit("sisturn", SisturnPostInit)