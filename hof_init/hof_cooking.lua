------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Crock Pot Ingredients.
AddIngredientValues({"slurtle_shellpieces"}, 	{inedible=1, 					  shell=1})
AddIngredientValues({"rabbit"}, 				{rabbit=1})
AddIngredientValues({"firenettles"}, 			{veggie=0.5})
AddIngredientValues({"foliage"}, 				{veggie=0.5}, 						  true)
AddIngredientValues({"succulent_picked"}, 		{veggie=0.5})
AddIngredientValues({"robin_winter"}, 			{robin_winter=1})
AddIngredientValues({"petals"}, 				{veggie=0.5})
AddIngredientValues({"gears"}, 					{gears=1})
AddIngredientValues({"rocks"}, 					{rocks=1, 		elemental=1,   inedible=1})
AddIngredientValues({"poop"}, 					{poop=1, 		glermz=1})
AddIngredientValues({"guano"}, 					{poop=1, 		glermz=1})
AddIngredientValues({"glommerfuel"}, 			{poop=1, 		glermz=1})
AddIngredientValues({"deerclops_eyeball"},      {inedible=1, 	boss=1})
AddIngredientValues({"kyno_coffeebeans"}, 		{seeds=1, 		fruit=0.5}, 		  true)
AddIngredientValues({"kyno_shark_fin"}, 		{fish=1})
AddIngredientValues({"kyno_roe"}, 				{meat=0.5, 		roe=1}, 			  true)
AddIngredientValues({"kyno_mussel"}, 			{fish=0.5, 		mussel=1}, 		  	  true)
AddIngredientValues({"kyno_beanbugs"}, 			{bug=1, 		veggie=0.5}, 		  true)
AddIngredientValues({"kyno_gummybug"}, 			{bug=1, 		veggie=0.5}, 		  true)
AddIngredientValues({"kyno_humanmeat"}, 		{meat=1, 		monster=1}, 	true, true)
AddIngredientValues({"kyno_syrup"}, 			{sweetener=1, 	syrup=1})
AddIngredientValues({"kyno_flour"}, 			{inedible=1, 	flour=1})
AddIngredientValues({"kyno_spotspice"},			{spotspice=1})
AddIngredientValues({"kyno_bacon"}, 			{meat=0.5, 		bacon=1}, 			  true)
AddIngredientValues({"gorge_bread"}, 			{bread=1})
AddIngredientValues({"kyno_white_cap"}, 		{veggie=0.5, 	mushroom=1},		  true)
AddIngredientValues({"kyno_foliage"}, 			{veggie=0.5}, 						  true) -- This is a false Foliage. We just need it because Cooked Foliage icon doesn't display without it.
AddIngredientValues({"kyno_sap"}, 				{inedible=1, 	sap=1})
AddIngredientValues({"kyno_aloe"}, 				{veggie=1}, 						  true)
AddIngredientValues({"kyno_radish"}, 			{veggie=1}, 						  true)
AddIngredientValues({"kyno_fennel"}, 			{veggie=1}, 						  true)
AddIngredientValues({"kyno_sweetpotato"}, 		{veggie=1}, 						  true)
AddIngredientValues({"kyno_lotus_flower"}, 		{veggie=1}, 						  true)
AddIngredientValues({"kyno_seaweeds"}, 			{veggie=1}, 					true, true)
AddIngredientValues({"kyno_limpets"}, 			{fish=0.5}, 						  true)
AddIngredientValues({"kyno_taroroot"}, 			{veggie=1},                           true)
AddIngredientValues({"kyno_cucumber"}, 			{veggie=1})
AddIngredientValues({"kyno_waterycress"}, 		{veggie=1})
AddIngredientValues({"kyno_salt"}, 				{inedible=1})
AddIngredientValues({"kyno_parznip"}, 			{veggie=1},                           true)
AddIngredientValues({"kyno_parznip_eaten"}, 	{veggie=1},                           true)
AddIngredientValues({"kyno_turnip"}, 			{veggie=1},                           true)
AddIngredientValues({"kyno_banana"}, 			{fruit=1},                            true)
AddIngredientValues({"kyno_kokonut_halved"}, 	{fruit=1})
AddIngredientValues({"kyno_kokonut_cooked"}, 	{fruit=1})
AddIngredientValues({"kyno_twiggynuts"}, 		{seeds=1, 		fruit=0.5})
AddIngredientValues({"kyno_grouper"},			{fish=1,		meat=1},			  true)
AddIngredientValues({"kyno_neonfish"},			{fish=1,		meat=1},			  true)
AddIngredientValues({"kyno_koi"},			    {fish=1,		meat=1},			  true)
AddIngredientValues({"kyno_tropicalfish"},		{fish=0.5,		meat=0.5},			  true)
AddIngredientValues({"kyno_pierrotfish"},		{fish=0.5,		meat=0.5},			  true)
AddIngredientValues({"kyno_salmonfish"},		{fish=0.5, 		meat=0.5},			  true)
AddIngredientValues({"kyno_sugartree_petals"},	{sweetener=1})
AddIngredientValues({"kyno_crabmeat"},			{meat=0.5,		crab=1},			  true)
AddIngredientValues({"kyno_chicken_egg"},		{egg=1}, 							  true)
AddIngredientValues({"kyno_bottle_soul"},		{soul=1})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Icons For Cookbook.
local cookbook_icons = {
	"kyno_coffeebeans_cooked.tex",
	"kyno_coffeebeans.tex",
	"kyno_shark_fin.tex",
	"ecp_shark_fin.tex",
	"kyno_roe_cooked.tex",
	"kyno_roe.tex",
	"kyno_mussel_cooked.tex",
	"kyno_mussel.tex",
	"kyno_beanbugs_cooked.tex",
	"kyno_beanbugs.tex",
	"kyno_gummybug_cooked.tex",
	"kyno_gummybug.tex",
	"kyno_humanmeat_cooked.tex",
	"kyno_humanmeat.tex",
	"kyno_humanmeat_dried.tex",
	"kyno_syrup.tex",
	"kyno_flour.tex",
	"kyno_spotspice.tex",
	"kyno_bacon_cooked.tex",
	"kyno_bacon.tex",
	"gorge_bread.tex",
	"kyno_white_cap_cooked.tex",
	"kyno_white_cap.tex",
	"kyno_foliage_cooked.tex",
	"kyno_foliage.tex",
	"kyno_sap.tex",
	"kyno_aloe_cooked.tex",
	"kyno_aloe.tex",
	"kyno_radish_cooked.tex",
	"kyno_radish.tex",
	"kyno_fennel_cooked.tex",
	"kyno_fennel.tex",
	"kyno_sweetpotato_cooked.tex",
	"kyno_sweetpotato.tex",
	"kyno_lotus_flower_cooked.tex",
	"kyno_lotus_flower.tex",
	"kyno_seaweeds_cooked.tex",
	"kyno_seaweeds.tex",
	"kyno_seaweeds_dried.tex",
	"kyno_limpets_cooked.tex",
	"kyno_limpets.tex",
	"kyno_taroroot_cooked.tex",
	"kyno_taroroot.tex",
	"kyno_cucumber.tex",
	"kyno_waterycress.tex",
	"kyno_salt.tex",
	"kyno_parznip_cooked.tex",
	"kyno_parznip.tex",
	"kyno_parznip_eaten.tex",
	"kyno_turnip_cooked.tex",
	"kyno_turnip.tex",
	"kyno_banana_cooked.tex",
	"kyno_banana.tex",
	"kyno_kokonut_cooked.tex",
	"kyno_kokonut_halved.tex",
	"kyno_twiggynuts.tex",
	"kyno_neonfish_cooked.tex",
	"kyno_neonfish.tex",
	"kyno_grouper_cooked.tex",
	"kyno_grouper.tex",
	"kyno_pierrotfish_cooked.tex",
	"kyno_pierrotfish.tex",
	"kyno_koi_cooked.tex",
	"kyno_koi.tex",
	"kyno_salmonfish_cooked.tex",
	"kyno_salmonfish.tex",
	"kyno_tropicalfish.tex",
	"kyno_sugartree_petals.tex",
	"kyno_crabmeat_cooked.tex",
	"kyno_crabmeat.tex",
	"kyno_chicken_egg_cooked.tex",
	"kyno_chicken_egg.tex",
	"kyno_bottle_soul.tex",
}

for k,v in pairs(cookbook_icons) do
	RegisterInventoryItemAtlas("images/inventoryimages/hof_inventoryimages.xml", v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------