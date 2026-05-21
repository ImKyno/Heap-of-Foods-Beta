local _G = GLOBAL

-- Strident Trident Tweak for new ocean plants.
local function TridentPostInit(inst)
	local INITIAL_LAUNCH_HEIGHT = 0.1
	local SPEED = 8

	local function launch_away(inst, position)
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

		local px, py, pz = position:Get()
		local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
		local sina, cosa = math.sin(angle), math.cos(angle)
		inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
	end

	local function DoWaterExplosionEffectNew(inst, affected_entity, owner, position)
		if affected_entity.components.health then
			local ae_combat = affected_entity.components.combat

			if ae_combat then
				ae_combat:GetAttacked(owner, TUNING.TRIDENT.SPELL.DAMAGE, inst)
			else
				affected_entity.components.health:DoDelta(-TUNING.TRIDENT.SPELL.DAMAGE, nil, inst.prefab, nil, owner)
			end
		elseif affected_entity.components.oceanfishable ~= nil then
			if affected_entity.components.weighable ~= nil then
				affected_entity.components.weighable:SetPlayerAsOwner(owner)
			end

			local projectile = affected_entity.components.oceanfishable:MakeProjectile()
			local ae_cp = projectile.components.complexprojectile

			if ae_cp then
				ae_cp:SetHorizontalSpeed(16)
				ae_cp:SetGravity(-30)
				ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
				ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

				local v_position = affected_entity:GetPosition()
				local launch_position = v_position + (v_position - position):Normalize() * SPEED
				ae_cp:Launch(launch_position, projectile)
			else
				launch_away(projectile, position)
			end
		elseif affected_entity.prefab == "bullkelp_plant" or affected_entity.prefab == "kyno_lotus_ocean" or
		affected_entity.prefab == "kyno_seaweeds_ocean" or affected_entity.prefab == "kyno_taroroot_ocean" or
		affected_entity.prefab == "kyno_waterycress_ocean" then
			local ae_x, ae_y, ae_z = affected_entity.Transform:GetWorldPosition()

			if affected_entity.components.pickable and affected_entity.components.pickable:CanBePicked() then
				local product = affected_entity.components.pickable.product
				local loot = _G.SpawnPrefab(product)
				if loot ~= nil then
					loot.Transform:SetPosition(ae_x, ae_y, ae_z)

					if loot.components.inventoryitem ~= nil then
						loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
					end

					if loot.components.stackable ~= nil and affected_entity.components.pickable.numtoharvest > 1 then
						loot.components.stackable:SetStackSize(affected_entity.components.pickable.numtoharvest)
					end

					launch_away(loot, position)
				end
			end

			if affected_entity.prefab == "bullkelp_plant" then
				local uprooted_kelp_plant = _G.SpawnPrefab("bullkelp_root")

				if uprooted_kelp_plant ~= nil then
					uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_kelp_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end
			end

			if affected_entity.prefab == "kyno_lotus_ocean" then
				local uprooted_lotus_plant = _G.SpawnPrefab("kyno_lotus_root")

				if uprooted_lotus_plant ~= nil then
					uprooted_lotus_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_lotus_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end
			end

			if affected_entity.prefab == "kyno_seaweeds_ocean" then
				local uprooted_seaweeds_plant = _G.SpawnPrefab("kyno_seaweeds_root")

				if uprooted_seaweeds_plant ~= nil then
					uprooted_seaweeds_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_seaweeds_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end
			end

			if affected_entity.prefab == "kyno_taroroot_ocean" then
				local uprooted_taroroot_plant = _G.SpawnPrefab("kyno_taroroot_root")

				if uprooted_taroroot_plant ~= nil then
					uprooted_taroroot_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_taroroot_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end
			end

			if affected_entity.prefab == "kyno_waterycress_ocean" then
				local uprooted_waterycress_plant = _G.SpawnPrefab("kyno_waterycress_root")

				if uprooted_waterycress_plant ~= nil then
					uprooted_waterycress_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_waterycress_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end
			end

			affected_entity:Remove()
		elseif affected_entity.components.inventoryitem ~= nil then
			launch_away(affected_entity, position)
			affected_entity.components.inventoryitem:SetLanded(false, true)
		elseif affected_entity.waveactive then
			affected_entity:DoSplash()
		elseif affected_entity.components.workable ~= nil 
		and affected_entity.components.workable:GetWorkAction() == _G.ACTIONS.MINE then
			affected_entity.components.workable:WorkedBy(owner, TUNING.TRIDENT.SPELL.MINES)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.DoWaterExplosionEffect = DoWaterExplosionEffectNew
end

AddPrefabPostInit("trident", TridentPostInit)