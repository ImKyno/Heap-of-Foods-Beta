--[[-------------------------------------------------------------------------------------------------------------------------------------------------
	
	[ Creating a Localization for Mod strings ]
	
	* To start your localization create a new folder inside "scripts/strings" named "localization_{your language ID}"
	You can see the supported IDs below, so lets say you want to create a localization for Portuguese, your file name
	should be "localization_pt" and so on.
	
	* After that, simply copy the three original files "hof_strings.lua", "hof_strings_loadingtips.lua" and "hof_strings_scrapbook.lua"
	to your localization folder to start translating them. 
	Note: you don't need to add the language ID to their names.
	
	* ALL STRINGS of "hof_strings.lua" can be translated.
	* ALL STRINGS of "hof_strings_scrapbook.lua" can be translated.
	* For "hof_strings_loadingtips.lua" only the strings after "TIPS_HOF, "TIPS_HOF_XXXX" can be translated.
	
	e.g:                                                          -- String to Translate:
	Original String:   AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE", "You can get Coffee Bushes after defeating the Dragonfly.")
	Translated String: AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE", "Você pode conseguir Plantas de Café ao Derrotar a Libélula.")
	
	* Some strings may have "\n" or "\n\n" that means a line break markdown.
	* Some strings may have \"Text\" that means that text has quotation marks.
	
	-------------------------------------------------------------------------------------------------------------------------------------------------
	
	[ Creating a Localization for modinfo.lua ]
	
	* To start your localization for modinfo open the "modinfo.lua" file, you gonna need to copy some things to start.
	
	* What can you translate from modinfo: 
	- Mod Name
	- Mod Description (Version, Update)
	- Mod Configurations (Labels, Hovers, Options)
	
	* You'll need to create a if statement with your language ID. There's an example there to get you started.
	e.g:
	if locale == "pt" then
		-- Your localization code.
	end
	
	* Tables that can be translated:
	- names
	- labels 
	- hovers 
	- desc
	- deschovers
	
	* Make sure your localization follows ALL the original strings. If one of them is missing, you might run into a crash.
	* DO NOT translate the tables of "options" and "configuration_options".
	
	-------------------------------------------------------------------------------------------------------------------------------------------------
	
	[ Final Considerations ]
	
	If you run into a problem, have any inquiries or just need help, please join our Discord and head to the dedicated channel
	exclusive to talk about translations #hof-translations. Otherwise you can also send me a private message on Discord, it
	might take a while for me to reply you, but I'll do as soon as I can. 
	
	For submitting your localization, send me a private message on Discord with all the changes ready to go. They'll be added 
	to the mod accordingly, with proper credits to the authors in-game and Workshop Page.
	
	Discord Server Invite: https://discord.gg/apcsWvWtYz
	My Discord: kynoox_

	Happy translating!

--]]-------------------------------------------------------------------------------------------------------------------------------------------------

local _G               = GLOBAL
local require          = _G.require

local MOD_LANGUAGE     = "en"
local MOD_LANGUAGE_IDS = 
{
	"de",  -- Deutsch
	"en",  -- English
	"es",  -- Español
	"fr",  -- Français
	"it",  -- Italiano
	"ko",  -- 한국어
	"mex", -- Español Mexicano
	"pl",  -- Polski
	"pt",  -- Português Brasileiro
	"ru",  -- русский
	"tr",  -- Türkçe
	"zh",  -- 简体中文
	"zht", -- 繁體中文
}

-- Copied from Klei.
local function DoTranslateStringTable(base, tbl)
    for k,v in pairs(tbl) do
        local path = base.."."..k
		
        if type(v) == "table" then
            DoTranslateStringTable(path, v)
        else
            local str
			
            if LanguageTranslator.use_longest_locs then
                str = LanguageTranslator:GetLongestTranslatedString(path)
            else
                str = LanguageTranslator:GetTranslatedString(path)
            end

            if str and str ~= "" then
                tbl[k] = str
            end
        end
    end
end

-- (Helper function) Recursive function to process table structure.
local function LinearizeTable(base, src, dst)
    _G.assert(dst ~= src)
	
    for k,v in pairs(src) do
        local path = base.."."..k
		
        if type(v) == "table" then
            LinearizeTable(path, v, dst)
        else
            dst[path] = v
        end
    end
end