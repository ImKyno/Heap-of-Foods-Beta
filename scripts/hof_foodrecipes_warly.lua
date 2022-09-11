local kyno_warly_foods =
{
	musselbouillabaise =
	{
		test = function(cooker, names, tags) return (names.kyno_mussel and names.kyno_mussel >= 3) and tags.veggie and not tags.inedible 
		and not tags.sweetener and not names.kyno_mussel_cooked end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 37.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	sweetpotatosouffle =
	{
		test = function(cooker, names, tags) return (names.kyno_sweetpotato and names.kyno_sweetpotato >= 2) and tags.egg and tags.egg >= 2
		and not names.kyno_sweetpotato_cooked and not (names.potato or names.potato_cooked) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		secondaryfoodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 50,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	gorge_meat_stew =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 3) and names.kyno_spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 200,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	gorge_cheeseburger =
	{
		test = function(cooker, names, tags) return names.gorge_bread and tags.meat and (names.foliage or names.kyno_foliage_cooked)
		and (tags.dairy or names.cheese_yellow or names.cheese_white or names.cheese_koalefant) and not names.kyno_bacon and not names.kyno_bacon_cooked end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 50,
		hunger = 100,
		sanity = 30,
		cooktime = 1.2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	gorge_pizza =
	{
		test = function(cooker, names, tags) return tags.meat and names.kyno_flour and tags.dairy and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 40,
		hunger = 150,
		sanity = 20,
		cooktime = 2.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	gorge_meat_wellington =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and names.gorge_bread and tags.veggie end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 150,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	gorge_trifle =
	{
		test = function(cooker, names, tags) return tags.fruit and names.kyno_flour and (tags.dairy and tags.dairy >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 37.5,
		sanity = 60,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	bubbletea = 
	{
		test = function(cooker, names, tags) return names.kyno_piko and (tags.sweetener and tags.sweetener >= 2) and 
		tags.frozen and not tags.meat and not tags.egg and not tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		health = 20,
		hunger = 12.5,
		sanity = 33,
		cooktime = 0.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		prefabs = { "buff_sleepresistance" },
        oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
        oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
				(eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled()) and
					not (eater.components.health ~= nil and eater.components.health:IsDead()) and
					not eater:HasTag("playerghost") then
                if eater.components.grogginess ~= nil then
                    eater.components.grogginess:ResetGrogginess()
                end
                if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() then
                    eater.components.debuffable:AddDebuff("shroomsleepresist", "buff_sleepresistance")
                end
            end
        end,
	},
	
	frenchonionsoup = 
	{
		test = function(cooker, names, tags) return ((names.onion or 0) + (names.onion_cooked or 0) >= 2) and (tags.veggie and tags.veggie >= 3) and (names.foliage or names.kyno_foliage_cooked) end,
		priority = 5,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
	},
	
	jellybean_sanity =
	{
		test = function(cooker, names, tags) return names.royal_jelly and ((names.green_cap or 0) + (names.green_cap_cooked or 0) >= 3) 
		and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 0, 
		sanity = 5,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RESANITY,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
        prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
            end
        end,
	},
	
	jellybean_hunger =
	{
		test = function(cooker, names, tags) return names.royal_jelly and names.butter and tags.sweetener and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 5, 
		sanity = 0,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
        prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
            end
        end,
	},
	
	jellybean_super =
	{
		test = function(cooker, names, tags) return (names.royal_jelly and names.royal_jelly  >= 2) and (names.dragonfruit or names.dragonfruit_cooked)
		and (names.pomegranate or names.pomegranate_cooked) and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 2, 
		sanity = 2,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHEALTH,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
        prefabs = { "kyno_superregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_superregenbuff", "kyno_superregenbuff")
            end
        end,
	},
}

for k, recipe in pairs(kyno_warly_foods) do
	recipe.name = k
	recipe.weight = 1
	recipe.cookbook_category = "portablecookpot"
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_warly_foods