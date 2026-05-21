local _G = GLOBAL

-- For Installing the new Cookware on the Fire Pits.
local function FirePitPostInit(inst)
	local function GetFirepit(inst)
		if not inst.firepit or not inst.firepit:IsValid() or not inst.firepit.components.fueled then
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = _G.TheSim:FindEntities(x, y, z, 0.01)
			
			inst.firepit = nil

			for k, v in pairs(ents) do
				if v.prefab == "firepit" then
					inst.firepit = v
					break
				end
			end
		end

		return inst.firepit
	end

	local function ApplyHanger(inst)
		local firepit = GetFirepit(inst)

		if firepit then
			firepit:AddTag("firepit_has_hanger")
			firepit:AddTag("firepit_with_cookware")

			firepit.components.cookwareinstaller.enabled = false
			firepit.hascookware = true
			firepit.hashanger = true
		end
	end

	local function RemoveCookware(inst)
		local firepit = GetFirepit(inst)

		if firepit then
			firepit:RemoveTag("firepit_has_hanger")
			firepit:RemoveTag("firepit_has_grill")
			firepit:RemoveTag("firepit_has_oven")
			firepit:RemoveTag("firepit_with_cookware")

			if firepit.components.burnable ~= nil then
				firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
			end

			if firepit.components.cookwareinstaller ~= nil then
				firepit.components.cookwareinstaller.enabled = true
			end

			firepit.hascookware = false
			firepit.hashanger = false
			firepit.hasgrill = false
			firepit.hasoven = false
		end
	end

	local function ChangeGrillFireFX(inst)
		local firepit = GetFirepit(inst)

		if firepit then
			firepit:AddTag("firepit_has_grill")
			firepit:AddTag("firepit_with_cookware")

			if firepit.components.burnable ~= nil then
				firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
			end

			if firepit.components.cookwareinstaller ~= nil then
				firepit.components.cookwareinstaller.enabled = false
			end

			firepit.hascookware = true
			firepit.hasgrill = true
		end
	end

	local function ChangeOvenFireFX(inst)
		local firepit = GetFirepit(inst)

		if firepit then
			firepit:AddTag("firepit_has_oven")
			firepit:AddTag("firepit_with_cookware")

			if firepit.components.burnable ~= nil then
				firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
			end

			if firepit.components.cookwareinstaller ~= nil then
				firepit.components.cookwareinstaller.enabled = false
			end

			firepit.hascookware = true
			firepit.hasoven = true
		end
	end

	local function TestItem(inst, item, giver)
		if item.components.inventoryitem and item:HasTag("firepit_installer") then
			return true
		else
			giver:PushEvent("firepitinstallfail")
		end
	end

	local function OnGetItemFromPlayer(inst, giver, item)
		if item.components.inventoryitem ~= nil and item:HasTag("pot_hanger_installer") then
			_G.SpawnPrefab("kyno_cookware_hanger").Transform:SetPosition(inst.Transform:GetWorldPosition())

			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/pot_hanger")

			if inst.components.cookwareinstaller ~= nil then
				inst.components.cookwareinstaller.enabled = false
			end

			ApplyHanger(inst)
		end

		if item.components.inventoryitem ~= nil and item:HasTag("grill_big_installer") then
			_G.SpawnPrefab("kyno_cookware_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())

			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_big")

			if inst.components.cookwareinstaller ~= nil then
				inst.components.cookwareinstaller.enabled = false
			end

			ChangeGrillFireFX(inst)
		end

		if item.components.inventoryitem ~= nil and item:HasTag("grill_small_installer") then
			_G.SpawnPrefab("kyno_cookware_small_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())

			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_small")

			if inst.components.cookwareinstaller ~= nil then
				inst.components.cookwareinstaller.enabled = false
			end

			ChangeGrillFireFX(inst)
		end

		if item.components.inventoryitem ~= nil and item:HasTag("oven_installer") then
			local oven = _G.SpawnPrefab("kyno_cookware_oven")
			oven.Transform:SetPosition(inst.Transform:GetWorldPosition())
			oven.AnimState:PlayAnimation("place")

			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/oven")

			if inst.components.cookwareinstaller ~= nil then
				inst.components.cookwareinstaller.enabled = false
			end

			ChangeOvenFireFX(inst)
		end
	end

	local function OnSave(inst, data)
		local firepit = GetFirepit(inst)

		data.queued_charcoal = inst.queued_charcoal or nil
		data.hashanger = firepit.hashanger or nil
		data.haspot = firepit.haspot or nil
		data.hasgrill = firepit.hasgrill or nil
		data.hasoven = firepit.hasoven or nil
		data.hascookware = firepit.hascookware or nil
	end

	local function OnLoad(inst, data)
		local firepit = GetFirepit(inst)

		if data ~= nil and data.queued_charcoal then
			inst.queued_charcoal = true
		end

		if data ~= nil and data.hascookware then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_with_cookware")

				if firepit.components.cookwareinstaller ~= nil then
					firepit.components.cookwareinstaller.enabled = false
				end

				firepit.hascookware = true
			end)
		end

		if data ~= nil and data.hashanger then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_hanger")
				firepit:AddTag("firepit_with_cookware")

				if firepit.components.cookwareinstaller ~= nil then
					firepit.components.cookwareinstaller.enabled = false
				end

				firepit.hascookware = true
				firepit.hashanger = true
			end)
		end

		if data ~= nil and data.haspot then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_pot")
				firepit:AddTag("firepit_with_cookware")

				if firepit.components.burnable ~= nil then
					firepit.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
				end

				if firepit.components.cookwareinstaller ~= nil then
					firepit.components.cookwareinstaller.enabled = false
				end

				firepit.hascookware = true
				firepit.hashanger = true
				firepit.haspot = true
			end)
		end

		if data ~= nil and data.hasgrill then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_grill")
				firepit:AddTag("firepit_with_cookware")

				if firepit.components.burnable ~= nil then
					firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
				end

				if firepit.components.cookwareinstaller ~= nil then
					firepit.components.cookwareinstaller.enabled = false
				end

				firepit.hascookware = true
				firepit.hasgrill = true
			end)
		end

		if data ~= nil and data.hasoven then
			inst:DoTaskInTime(1, function()
				firepit:AddTag("firepit_has_oven")
				firepit:AddTag("firepit_with_cookware")

				if firepit.components.burnable ~= nil then
					firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
				end

				if firepit.components.cookwareinstaller ~= nil then
					firepit.components.cookwareinstaller.enabled = false
				end

				firepit.hascookware = true
				firepit.hasoven = true
			end)
		end

		if data ~= nil and data.hascookware == false then
			inst:DoTaskInTime(1, function()
				local firepit = GetFirepit(inst)

				if firepit then
					firepit:RemoveTag("firepit_has_hanger")
					firepit:RemoveTag("firepit_has_grill")
					firepit:RemoveTag("firepit_has_oven")
					firepit:RemoveTag("firepit_with_cookware")

					if firepit.components.burnable ~= nil then
						firepit.components.burnable:OverrideBurnFXBuild("campfire_fire")
					end

					if firepit.components.cookwareinstaller ~= nil then
						firepit.components.cookwareinstaller.enabled = true
					end

					firepit.hascookware = false
					firepit.hashanger = false
					firepit.hasgrill = false
					firepit.hasoven = false
				end
			end)
		end
	end

	inst:AddTag("cookware_installable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.burnable ~= nil then
		if inst:HasTag("firepit_has_grill") then
			inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		elseif inst:HasTag("firepit_has_oven") then
			inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		elseif inst:HasTag("firepit_has_pot") then
			inst.components.burnable:OverrideBurnFXBuild("quagmire_pot_fire")
		end
	end

	inst:AddComponent("cookwareinstaller")
	inst.components.cookwareinstaller:SetAcceptTest(TestItem)
	inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end

AddPrefabPostInit("firepit", FirePitPostInit)