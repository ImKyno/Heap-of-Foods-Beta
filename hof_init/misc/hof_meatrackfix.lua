-- This is from Cannibalism Mod. All credits goes to them.
do
	local ver = "1.0"
	local anim_ondry_food, anim_ondone_food

	anim_ondry_food  = {}
	anim_ondone_food = {}
	
	local meatracks = {"meatrack", "meatrack_hermit"}
	
	local function MeatRackPostInit(inst)
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
	end
	
	for k, v in pairs(meatracks) do 
		AddPrefabPostInit(v, MeatRackPostInit)
	end

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

	anim_ondry_food  = anim_ondry_food 
	anim_ondone_food = anim_ondone_food

	anim_ondry_food["kyno_humanmeat"] 			= {build = "meat_rack_food",                folder = "humanmeat"}
	anim_ondone_food["kyno_humanmeat_dried"] 	= {build = "meat_rack_food",                folder = "humanmeat_dried&#032"}
	
	anim_ondry_food["kyno_seaweeds"] 			= {build = "kyno_meatrack_seaweeds",        folder = "seaweeds"}
	anim_ondone_food["kyno_seaweeds_dried"] 	= {build = "kyno_meatrack_seaweeds",        folder = "seaweeds_dried"}
	
	anim_ondry_food["red_cap"] 			        = {build = "kyno_meatrack_red_cap",         folder = "red_cap"}
	anim_ondone_food["kyno_red_cap_dried"] 	    = {build = "kyno_meatrack_red_cap",         folder = "red_cap_dried"}
	
	anim_ondry_food["green_cap"] 			    = {build = "kyno_meatrack_green_cap",       folder = "green_cap"}
	anim_ondone_food["kyno_green_cap_dried"] 	= {build = "kyno_meatrack_green_cap",       folder = "green_cap_dried"}
	
	anim_ondry_food["blue_cap"] 			    = {build = "kyno_meatrack_blue_cap",        folder = "blue_cap"}
	anim_ondone_food["kyno_blue_cap_dried"] 	= {build = "kyno_meatrack_blue_cap",        folder = "blue_cap_dried"}
	
	anim_ondry_food["moon_cap"] 			    = {build = "kyno_meatrack_moon_cap",        folder = "moon_cap"}
	anim_ondone_food["kyno_moon_cap_dried"] 	= {build = "kyno_meatrack_moon_cap",        folder = "moon_cap_dried"}
	
	anim_ondry_food["plantmeat"]                = {build = "kyno_meatrack_plantmeat",       folder = "plantmeat"}
	anim_ondone_food["kyno_plantmeat_dried"]    = {build = "kyno_meatrack_plantmeat",       folder = "plantmeat_dried"}
	
	anim_ondry_food["pigskin"]                  = {build = "kyno_meatrack_pigskin",         folder = "pigskin"}
	anim_ondone_food["kyno_pigskin_dried"]      = {build = "kyno_meatrack_pigskin",         folder = "pigskin_dried"}
	
	anim_ondry_food["kyno_crabmeat"]            = {build = "kyno_meatrack_crabmeat",        folder = "crabmeat"}
	anim_ondry_food["kyno_crabkingmeat"]        = {build = "kyno_meatrack_crabmeat",        folder = "crabkingmeat"}
	anim_ondone_food["kyno_crabmeat_dried"]     = {build = "kyno_meatrack_crabmeat",        folder = "crabmeat_dried"}
	
	anim_ondry_food["kyno_poison_froglegs"]     = {build = "kyno_meatrack_poison_froglegs", folder = "poison_froglegs"}
end