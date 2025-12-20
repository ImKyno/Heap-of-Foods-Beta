local FISH_REGISTRY_DEFS = {}

FISH_REGISTRY_DEFS.pondfish = 
{
	name           = "PONDFISH",

	bank           = "fish",
	build          = "fish",
	anim           = "idle", -- flop_pst
	
	scale          = 0.25,
	xpos           = -5,
	ypos           = 40,

	phases         = { "day", "dusk", "night" },
	moonphases     = { "new", "quarter", "half", "threequarter", "full" },
	seasons        = { "autumn", "winter", "spring", "summer" },
	worlds         = { "forest", "cave" },
}

FISH_REGISTRY_DEFS.pondeel = 
{
	name           = "PONDEEL",

	bank           = "eel",
	build          = "eel",
	anim           = "idle",
	
	scale          = 0.25,
	xpos           = -5,
	ypos           = 40,

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
	
	scale          = 0.12,
	xpos           = 15,
	ypos           = 45,

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
