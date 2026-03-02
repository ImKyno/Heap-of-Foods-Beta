local HOF_TEA_DEFS =
{
	{
		name = "aloe",
		
		healthvalue = TUNING.KYNO_HERMITCRAB_ALOETEA_HEALTH,
		
		temperaturedelta = TUNING.HERMITCRABTEA_COLD_BONUS_TEMP / 2,
		temperatureduration = TUNING.HERMITCRABTEA_TEMP_TIME,
	},
	
	{
		name = "sugartree_petals",
		buff = "hermitcrabtea_sugartree_petals_buff",
		
		sanityvalue = TUNING.KYNO_HERMITCRAB_SUGARFLOWER_SANITY,
	},
}

local HOF_BUFF_DEFS =
{
	{
		name = "aloe",
		duration = TUNING.KYNO_HERMITCRAB_ALOETEA_DURATION,

		onattachedfn = function(inst, target)
			
		end,

		onextendedfn = function(inst, target)

		end,
		
		ondetachedfn = function(inst)

		end,
	},
	
	{
		name = "sugartree_petals",
		duration = TUNING.KYNO_HERMITCRAB_SUGARFLOWERTEA_DURATION,
        
		onattachedfn = function(inst, target)
			if target.components.sanity ~= nil then
				target.components.sanity.neg_aura_modifiers:SetModifier(inst, TUNING.KYNO_HERMITCRAB_SUGARFLOWERTEA_SANITY_MOD)
			end
		end,

		onextendedfn = function(inst, target)
			if target.components.sanity ~= nil then
				target.components.sanity.neg_aura_modifiers:SetModifier(inst, TUNING.KYNO_HERMITCRAB_SUGARFLOWERTEA_SANITY_MOD)
			end
		end,

		ondetachedfn = function(inst, target)
			if target.components.sanity ~= nil then
				target.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
			end
		end,
	},
}

return 
{
	teas  = HOF_TEA_DEFS,
	buffs = HOF_BUFF_DEFS,
}