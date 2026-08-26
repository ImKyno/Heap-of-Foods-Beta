local _G = GLOBAL

local INIT_POSTINIT_MODS =
{
	"shinyloots",
	"apparelsoverload",
	"notenoughturfs",
	"dehydrated",
	"cherryforest",
	"islandadventures",
}

for _, v in pairs(INIT_POSTINIT_MODS) do
	modimport("postinit/mods/"..v)
end