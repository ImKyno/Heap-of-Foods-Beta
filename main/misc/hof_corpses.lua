local _G          = GLOBAL
local require     = _G.require
local Vector3     = _G.Vector3
local corpse_defs = require("prefabs/corpses_defs")

-- Wild Chicken Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_chicken2",
	bank = "chicken",
	build = "chicken",
	sg = "SGchickenwild",

	faces = corpse_defs.FACES.FOUR,
	tags = { "smallcreaturecorpse" },

	firesymbol = "body",
	makeburnablefn = _G.MakeSmallBurnableCorpse,
	burntime = TUNING.SMALL_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1, .75},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,
})

-- Coop Chicken Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_chicken_coop",
	bank = "chicken",
	build = "chicken",
	sg = "SGchickencoop",

	faces = corpse_defs.FACES.FOUR,
	tags = { "smallcreaturecorpse" },

	firesymbol = "body",
	makeburnablefn = _G.MakeSmallBurnableCorpse,
	burntime = TUNING.SMALL_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1, .75},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,

	common_postinit = function(inst)
		inst:AddTag("_named")
	end,

	master_postinit = function(inst)
		inst:RemoveTag("_named")
		inst:AddComponent("named")
	end,
})

-- Piko Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_piko",
	bank = "squirrel",
	build = "squirrel_build",
	sg = "SGmeadowsquirrel",

	faces = corpse_defs.FACES.FOUR,
	tags = { "smallcreaturecorpse" },

	firesymbol = "chest",
	makeburnablefn = _G.MakeSmallBurnableCorpse,
	burntime = TUNING.SMALL_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1, .75},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,
})

-- Orange Piko Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_piko_orange",
	bank = "squirrel",
	build = "orange_squirrel_build",
	sg = "SGmeadowsquirrel",

	faces = corpse_defs.FACES.FOUR,
	tags = { "smallcreaturecorpse" },

	firesymbol = "chest",
	makeburnablefn = _G.MakeSmallBurnableCorpse,
	burntime = TUNING.SMALL_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1, .75},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,
})

-- Elder Mandrake Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_eldermandrake",
	bank = "elderdrake",
	build = "elderdrake_build",
	sg = "SGeldermandrake",

	faces = corpse_defs.FACES.FOUR,

	firesymbol = "torso",
	makeburnablefn = _G.MakeMediumBurnableCorpse,
	burntime = TUNING.MED_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1.5, .75},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,
})

-- Fishermerm Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_meadowisland_mermfisher",
	bank = "pigman",
	build = "merm_fisherman_build",
	sg = "SGmeadowmermfisher",

	faces = corpse_defs.FACES.FOUR,
	tags = { "wet" },

	firesymbol = "pig_torso",
	makeburnablefn = _G.MakeMediumBurnableCorpse,
	burntime = TUNING.MED_BURNTIME,

	fireoffset = Vector3(0, 0, 0),
	shadowsize = {1.5, .75},

	sanityaurafn = function(inst, observer)
		if observer:HasTag("playermerm") then -- Noo! Merm friend!
			return -TUNING.SANITYAURA_LARGE
		end

		return -TUNING.SANITYAURA_MED
	end,

	use_inventory_physics = true,
})

-- Packim Baggims Corpse
table.insert(corpse_defs.CORPSE_DEFS,
{
	creature = "kyno_packimbaggims",
	bank = "kyno_packimbaggims",
	build = "kyno_packimbaggims_build",
	sg = "SGpackimbaggims",

	faces = corpse_defs.FACES.SIX,

	firesymbol = "PACKIM_BODY",
	makeburnablefn = _G.MakeSmallBurnableCorpse,
	burntime = TUNING.SMALL_BURNTIME,

	fireoffset = Vector3(100, 50, 0.5),
	shadowsize = {2, 1.5},

	sanityaura = -TUNING.SANITYAURA_MED,
	use_inventory_physics = true,
})