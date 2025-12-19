local FISH_REGISTRY_DEFS = {}

FISH_REGISTRY_DEFS.pondfish = 
{
	name           = "PONDFISH",

	bank           = "fish",
	build          = "fish",
	anim           = "idle", -- flop_pst
	
	scale          = 0.3,
	xpos           = -4,
	ypos           = 30,

	phases         = { "day", "dusk", "night" },
	moonphases     = { "new", "quarter", "half", "threequarter", "full" },
	seasons        = { "autumn", "winter", "spring", "summer" },
	worlds         = { "forest", "cave" },
}

FISH_REGISTRY_DEFS.pondeel = 
{
	name           = "PONDEEL",

	atlas          = "images/inventoryimages2.xml",
	image          = "pondeel.tex",

	phases         = { "day", "dusk", "night" },
	moonphases     = { "new", "quarter", "half", "threequarter", "full" },
	seasons        = { "autumn", "winter", "spring", "summer" },
	worlds         = { "cave" },
}

FISH_REGISTRY_DEFS.kyno_swordfish_blue =
{
	name           = "KYNO_SWORDFISH_BLUE",

	bank           = "kyno_swordfish_blue",
	build          = "kyno_swordfish_blue",
	anim           = "idle",
	
	scale          = 0.15,
	xpos           = 0,
	ypos           = 30,

	phases         = { "day", "dusk", "night" },
	moonphases     = { "new", "quarter", "half", "threequarter", "full" },
	seasons        = { "winter" },
	worlds         = { "cave" },
}

for fish, data in pairs(FISH_REGISTRY_DEFS) do
	if data.name == nil then
		data.name = string.upper(fish)
	end
end

setmetatable(FISH_REGISTRY_DEFS, 
{
	__newindex = function(t, k, v)
		v.modded = true
		rawset(t, k, v)
	end,
})

local FISH_SORT_ORDER =
{
	"pondfish",
	"pondeel",
	"kyno_swordfish_blue",
}

return 
{
	FISH_REGISTRY_DEFS = FISH_REGISTRY_DEFS,
	FISH_SORT_ORDER    = FISH_SORT_ORDER,
}
