-- This is from Cannibalism Mod. All credits goes to them.
do
	local ver = "1.0"
	local anim_ondry_food, anim_ondone_food

	-- local t = mods.add_meatrack
	-- if t == nil or t.ver < ver then 
		-- t = {
			anim_ondry_food={}
			anim_ondone_food={}
			-- ver = ver,
		-- }
		-- mods.add_meatrack = t
		AddPrefabPostInit("meatrack", function(inst)
		if inst.components.dryer ~= nil then
			local old_onstartdrying = inst.components.dryer.onstartdrying
			inst.components.dryer:SetStartDryingFn(function(inst, ingredient, ...)
				local data = ingredient and anim_ondry_food[ingredient]
				if data ~= nil then
					inst.AnimState:PlayAnimation("drying_pre")
					inst.AnimState:PushAnimation("drying_loop", true)
					inst.AnimState:OverrideSymbol("swap_dried", data.build, data.folder)
						return
					end
				return old_onstartdrying(inst, ingredient, ...)
				end)
			end
			if inst.components.dryer ~= nil then
			local old_ondonedrying = inst.components.dryer.ondonedrying
			inst.components.dryer:SetDoneDryingFn(function(inst, prod, ...)
				local data = prod and anim_ondone_food[prod]
				if data ~= nil then
					inst.AnimState:PlayAnimation("drying_pst")
					inst.AnimState:PushAnimation("idle_full", false)
					inst.AnimState:OverrideSymbol("swap_dried", data.build, data.folder)
					return
				end
				return old_ondonedrying(inst, prod, ...)
			end)
				end
		end)
		-- Pearl's Drying Rack
		AddPrefabPostInit("meatrack_hermit", function(inst)
		if inst.components.dryer ~= nil then
			local old_onstartdrying = inst.components.dryer.onstartdrying
			inst.components.dryer:SetStartDryingFn(function(inst, ingredient, ...)
				local data = ingredient and anim_ondry_food[ingredient]
				if data ~= nil then
					inst.AnimState:PlayAnimation("drying_pre")
					inst.AnimState:PushAnimation("drying_loop", true)
					inst.AnimState:OverrideSymbol("swap_dried", data.build, data.folder)
						return
					end
				return old_onstartdrying(inst, ingredient, ...)
				end)
			end
			if inst.components.dryer ~= nil then
			local old_ondonedrying = inst.components.dryer.ondonedrying
			inst.components.dryer:SetDoneDryingFn(function(inst, prod, ...)
				local data = prod and anim_ondone_food[prod]
				if data ~= nil then
					inst.AnimState:PlayAnimation("drying_pst")
					inst.AnimState:PushAnimation("idle_full", false)
					inst.AnimState:OverrideSymbol("swap_dried", data.build, data.folder)
					return
				end
				return old_ondonedrying(inst, prod, ...)
			end)
				end
		end)
		-- Will show correctly all additional meat in lureplant.
		AddStategraphPostInit("lureplant",function(sg)
			local old_fn = sg.states.showbait.onenter
			sg.states.showbait.onenter = function(inst, playanim)
				old_fn(inst, playanim)
				local data = inst.lure and (anim_ondry_food[inst.lure.prefab] or anim_ondone_food[inst.lure.prefab])
				if data then
					inst.AnimState:OverrideSymbol("swap_dried", data.build, data.folder)
				end
			end
		end)

	anim_ondry_food = anim_ondry_food 
	anim_ondone_food = anim_ondone_food

	local my_build_name 	= "kyno_humanmeat"
	local my_build_name2 	= "kyno_seaweeds"
	local my_build_name3    = "kyno_meatrack_food"

	anim_ondry_food["kyno_humanmeat"] 			= {build = my_build_name,  folder = "humanmeat"}
	anim_ondone_food["kyno_humanmeat_dried"] 	= {build = my_build_name,  folder = "humanmeat_dried"}
	
	anim_ondry_food["kyno_seaweeds"] 			= {build = my_build_name2, folder = "seaweed"}
	anim_ondone_food["kyno_seaweeds_dried"] 	= {build = my_build_name2, folder = "seaweed_dried"}
end