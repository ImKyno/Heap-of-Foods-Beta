local _G = GLOBAL

-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
-- Correct animations for new ocean creatures inside Scale-o-Matic.
local function TrophyScaleFishPostInit(inst)
	local function SetFish(inst, item_data)
		if item_data then
			if item_data.prefab == "kyno_jellyfish" then
				inst.AnimState:SetBank("trophyscale_fish_kyno_jellyfish")
				inst.AnimState:HideSymbol("eel_head")
			elseif item_data.prefab == "kyno_jellyfish_rainbow" then
				inst.AnimState:SetBank("trophyscale_fish_kyno_jellyfish_rainbow")
				inst.AnimState:HideSymbol("eel_head")
			elseif item_data.prefab == "wobster_monkeyisland_land" then
				inst.AnimState:SetBank("trophyscale_fish_wobster_monkeyisland")
				-- inst.AnimState:ClearOverrideBuild("lobster_build")
				inst.AnimState:AddOverrideBuild("kyno_lobster_monkeyisland")
				inst.AnimState:OverrideSymbol("claw_type1a", "kyno_lobster_monkeyisland", "claw_type3a")
				inst.AnimState:OverrideSymbol("claw_type2b", "kyno_lobster_monkeyisland", "claw_type3b")
				inst.AnimState:HideSymbol("claw_type2a")

				inst:DoTaskInTime(1, function(inst)
					inst.AnimState:OverrideSymbol("claw_type2b", "kyno_lobster_monkeyisland", "claw_type3b")
				end)
			else
				inst.AnimState:SetBank("scale_o_matic")
			end

			if item_data.prefab == "kyno_jellyfish_rainbow" then
				local light = _G.SpawnPrefab("kyno_jellyfish_rainbow_light")
				light.components.spell:SetTarget(inst)

				if light:IsValid() then
					if not light.components.spell.target then
						light:Remove()
					else
						light.components.spell:StartSpell()
						light:StopUpdatingComponent(light.components.spell)
					end
				end
			else
				if inst.wormlight then
					inst.wormlight.components.spell:OnFinish()
				end
			end
		end
	end

	local function OnNewTrophy(inst, data_old_and_new)
		local data_new = data_old_and_new.new
		SetFish(inst, data_new)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	local _OnLoad = inst.OnLoad

	inst.OnLoad = function(inst, ...)
		if inst.components.trophyscale ~= nil then
			local item_data = inst.components.trophyscale:GetItemData()
			SetFish(inst, item_data)
		end

		if _OnLoad ~= nil then
			_OnLoad(inst, ...)
		end
	end

	inst:ListenForEvent("onnewtrophy", OnNewTrophy)
end

AddPrefabPostInit("trophyscale_fish", TrophyScaleFishPostInit)