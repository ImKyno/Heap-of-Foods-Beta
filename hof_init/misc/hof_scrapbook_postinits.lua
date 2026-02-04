local _G = GLOBAL
_G.setmetatable(env, {__index = function(t, k) return _G.rawget(_G, k) end})

require("util")
require("strings")
require("constants")

local ScrapbookData     = require("screens/redux/scrapbookdata")
local ScrapbookScreen   = require("screens/redux/scrapbookscreen")
local Screen            = require("widgets/screen")
local Subscreener       = require("screens/redux/subscreener")
local TextButton        = require("widgets/textbutton")
local ImageButton       = require("widgets/imagebutton")
local Menu              = require("widgets/menu")
local Grid              = require("widgets/grid")
local Text              = require("widgets/text")
local Image             = require("widgets/image")
local Widget            = require("widgets/widget")
local ScrollableList    = require("widgets/scrollablelist")
local PopupDialogScreen = require("screens/redux/popupdialog")
local OnlineStatus      = require("widgets/onlinestatus")
local TEMPLATES         = require("widgets/redux/templates")
local TrueScrollArea    = require("widgets/truescrollarea")
local UIAnim            = require("widgets/uianim")

local PANEL_WIDTH       = 1000
local PANEL_HEIGHT      = 530
local SEARCH_BOX_HEIGHT = 40
local SEARCH_BOX_WIDTH  = 300

local FILLER            = "zzzzzzz"
local UNKNOWN           = "unknown"

local UK_TINT           = { 0.5, 0.5, 0.5, 1 }

local function GetPeriodString(period)
	local days = math.floor(period / 60  / 8 * 100) / 100

	if days < 1 then
		local minutes = math.floor(period / 60 * 100) / 100

		if minutes < 1 then
			return subfmt(STRINGS.SCRAPBOOK.DATA_TIME, { time = period, txt = STRINGS.SCRAPBOOK.DATA_SECONDS })
		end

		return subfmt(STRINGS.SCRAPBOOK.DATA_TIME, { time = minutes, txt = (minutes <= 1 and STRINGS.SCRAPBOOK.DATA_MINUTE or STRINGS.SCRAPBOOK.DATA_MINUTES) })
	else
		return subfmt(STRINGS.SCRAPBOOK.DATA_TIME, { time = days, txt = (days <= 1 and STRINGS.SCRAPBOOK.DATA_DAY or STRINGS.SCRAPBOOK.DATA_DAYS) })
	end
end

local function GetSegsString(segs)
	local days = math.floor(segs / 16 * 100) / 100

	if days < 1 then
		return subfmt(STRINGS.SCRAPBOOK.DATA_TIME, { time = segs, txt = (math.abs(segs) <= 1 and STRINGS.SCRAPBOOK.DATA_SEG or STRINGS.SCRAPBOOK.DATA_SEGS) })
	else
		return subfmt(STRINGS.SCRAPBOOK.DATA_TIME, { time = days, txt = (math.abs(days) <= 1 and STRINGS.SCRAPBOOK.DATA_DAY or STRINGS.SCRAPBOOK.DATA_DAYS) })
	end
end

local DESCRIPTION_STATUS_LOOKUP =
{
	ARCHIVE_COOKPOT      = "EMPTY",
	ARCHIVE_RUNE_STATUE  = "LINE_1",
	ARCHIVE_SWITCH       = "GEMS",
	ATRIUM_GATE          = "OFF",
	ATRIUM_LIGHT         = "OFF",
	ATRIUM_RUBBLE        = "LINE_1",
	BLUEPRINT            = "COMMON",
	CAVE_EXIT            = "OPEN",
	COOKPOT              = "EMPTY",
	FIRESUPPRESSOR       = "OFF",
	MOLE                 = "ABOVEGROUND",
	MUSHROOM_FARM        = "EMPTY",
	MUSHROOM_LIGHT       = "OFF",
	MUSHROOM_LIGHT2      = "OFF",
	NIGHTMARE_TIMEPIECE  = "WARN",
	SANITYROCK           = "INACTIVE",
	SCULPTINGTABLE       = "EMPTY",
	SCULPTURE_BISHOPBODY = "UNCOVERED",
	SCULPTURE_KNIGHTBODY = "UNCOVERED",
	SCULPTURE_ROOKBODY   = "UNCOVERED",
	STAGEHAND            = "HIDING",
	STAGEUSHER           = "SITTING",
	TELEBASE             = "VALID",
	WORM                 = "WORM",
}

local FUELTYPE_SUBICON_LOOKUP = 
{
	[FUELTYPE.BURNABLE]   = "icon_fuel_burnable.tex",
	[FUELTYPE.CAVE] 	  = "icon_fuel_cavelight.tex",
	[FUELTYPE.CHEMICAL]   = "icon_fuel_chemical.tex",
	[FUELTYPE.NIGHTMARE]  = "icon_fuel_nightmare.tex",
	[FUELTYPE.WORMLIGHT]  = "icon_fuel_wormlight.tex",
	
	-- HoF FUELTYPES.
	[FUELTYPE.FISHFOOD]   = "icon_fuel_fishfood.tex",
	[FUELTYPE.ANIMALFOOD] = "icon_fuel_animalfood.tex",
}

local FUELTYPE_SUBICONS = table.getkeys(FUELTYPE_SUBICON_LOOKUP)

local function Hof_AddData(self, data, makeentry, makesubentry, makesubiconentry)
	if data.brewer then
		makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_BREWER)
	end
	
	if data.openable then
		makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_OPENABLE)
	end

	if data.sliceable then
		makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_SLICEABLE)
	end
	
	if data.slaughterable then
		makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_SLAUGHTERABLE)
	end
	
	if data.milkable then
		makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_MILKABLE)
	end
	
	if data.fishfarmable then
		makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_FISHFARMABLE)
	end
	
	if data.fishfarm then
		makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_FISHFARM)
	end
end

-- Modified PopulateInfoPanel for our needs.
local function Hof_PopulateInfoPanel(self, entry, ...)
	local data = self:GetData(entry)

	self.PRNG = PRNG_Uniform(hash((data and data.name or "") .. ThePlayer.userid))

	local page = Widget("page")
	
	if data then 
		TheScrapbookPartitions:SetViewedInScrapbook(data.prefab)
	end
	
	self:updatemenubuttonflashes()

	page.entry = entry

	page:SetPosition(-PANEL_WIDTH / 4 - 20,0)

	local sub_root = Widget("text_root")

	local width = PANEL_WIDTH / 2 -40

	local left = 0
	local height = 0
	local title_space = 5
	local section_space = 22

	local applytexturesize = function(widget, w, h, tex, source)
		local suffix = "_square"
		local ratio = w/h
		
		if ratio > 5 then
			suffix = "_thin"
		elseif ratio > 1 then
			suffix = "_wide"
		elseif ratio < 0.75 then
			suffix = "_tall"
		end

		local materials = 
		{
			"scrap",
			"scrap2",
		}
		
		if not tex then
			tex = materials[math.ceil(self.PRNG:Rand() * #materials)]..suffix.. ".tex"
		end
		
		if not source then
			source = "images/scrapbook.xml"
		end

		widget:SetTexture(source, tex, tex)
		widget:ScaleToSize(w,h)
	end

	local setattachmentdetils = function (widget,w,h, shortblock)
		local choice = self.PRNG:Rand()

		if choice < 0.4 and not shortblock then
			local mat = "corner.tex"
			
			if self.PRNG:Rand() < 0.5 then
				mat = "corner2.tex"
			end
			
			local tape1 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape1:SetScale(0.5)
			tape1:SetClickable(false)
			tape1:SetPosition(-w / 2 + 15, -h / 2 + 15)
			tape1:SetRotation(0)

			local tape2 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape2:SetScale(0.5)
			tape2:SetClickable(false)
			tape2:SetPosition(-w / 2 + 15, h / 2 - 15)
			tape2:SetRotation(90)

			local tape3 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape3:SetScale(0.5)
			tape3:SetClickable(false)
			tape3:SetPosition(w / 2 - 15, h / 2 - 15)
			tape3:SetRotation(180)

			local tape4 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape4:SetScale(0.5)
			tape4:SetClickable(false)
			tape4:SetPosition(w / 2 - 15, - h / 2 + 15)
			tape4:SetRotation(270)
		elseif choice < 0.7 then
			local tape1 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(self.PRNG:Rand()*2).."_centre.tex"))
			tape1:SetScale(0.5)
			tape1:SetClickable(false)
			tape1:SetPosition(0, h / 2)
			tape1:SetRotation(self.PRNG:Rand() * 3 - 1.5)
		elseif choice < 0.8 then
			local diagonal = false
			local right = true
			
			if shortblock then
				if self.PRNG:Rand() < 0.3 then
					diagonal = true
					
					if self.PRNG:Rand() < 0.5 then
						right = false
					end
				end
			end
			
			if (self.PRNG:Rand() < 0.5 and not shortblock) or (diagonal == true and right == false) then
				local tape1 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(self.PRNG:Rand() * 2).."_corner.tex"))
				tape1:SetScale(0.5)
				tape1:SetClickable(false)
				tape1:SetPosition(-w / 2 + 5, -h / 2 + 5)
				local rotation = -45
				tape1:SetRotation(rotation)
			end

			if not diagonal or right then
				local tape2 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(self.PRNG:Rand() * 2).."_corner.tex"))
				tape2:SetScale(0.5)
				tape2:SetClickable(false)
				tape2:SetPosition(-w / 2 + 5, h / 2 - 5)
				local rotation = 45
				tape2:SetRotation(rotation)
			end

			if not diagonal or right == false then
				local tape3 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(self.PRNG:Rand() * 2).."_corner.tex"))
				tape3:SetScale(0.5)
				tape3:SetClickable(false)
				tape3:SetPosition(w / 2 - 5, h / 2 - 5)
				local rotation = 90 +45
				tape3:SetRotation(rotation)
			end

			if (self.PRNG:Rand() < 0.5 and not shortblock) or (diagonal == true and right == true) then
				local tape4 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(self.PRNG:Rand() * 2).."_corner.tex"))
				tape4:SetScale(0.5)
				tape4:SetClickable(false)
				tape4:SetPosition(w/2-5,-h/2+5)
				local rotation = -90 - 45
				tape4:SetRotation(rotation)
			end
		else
			local ropechoice = math.ceil(self.PRNG:Rand() * 3)
			local rope = widget:AddChild(Image("images/scrapbook.xml", "rope".. ropechoice.."_corner.tex"))
			rope:SetScale(0.5)
			rope:SetClickable(false)
			
			if ropechoice == 1 then
				rope:SetPosition(-w / 2 + 5, h / 2 - 10)
			elseif ropechoice == 3 then
				rope:SetPosition(-w / 2 + 5, h / 2 - 13)
			else
				rope:SetPosition(-w / 2 + 13, h / 2 - 16)
			end
		end
	end

	local settextblock = function (height, data) -- font, size, str, color,leftmargin,rightmargin, leftoffset, ignoreheightchange, widget
		assert(data.font and data.size and data.str and data.color, "Missing String Data")
		
		local targetwidget = data.widget and data.widget or sub_root
		local txt = targetwidget:AddChild(Text(data.font, data.size, data.str, data.color))
		txt:SetHAlign(ANCHOR_LEFT)
		txt:SetVAlign(ANCHOR_TOP)
		
		local subwidth = data.width or width
		local adjustedwidth = subwidth - (data.leftmargin and data.leftmargin or 0) - (data.rightmargin and data.rightmargin or 0)
		txt:SetMultilineTruncatedString(data.str, 100, adjustedwidth)
		
		local x, y = txt:GetRegionSize()
		local adjustedleft = left + (data.leftmargin and data.leftmargin or 0) + (data.leftoffset and data.leftoffset or 0)
		txt:SetPosition(adjustedleft + (0.5 * x) , height - (0.5 * y))
		
		if not data.ignoreheightchange then
			height = height - y - section_space
		end

		return height, txt
	end

	local setimageblock = function(height, data) -- source, tex, w,h,rotation,leftoffset, ignoreheightchange, widget)
		assert(data.source and data.tex, "Missing Image Data")
		
		local targetwidget = data.widget and data.widget or sub_root
		local img = targetwidget:AddChild(Image(data.source, data.tex))
		
		if data.w and data.h then
			applytexturesize(img, w, h, data.source, data.tex)
		end
		
		if data.rotation then
			img:SetRotation(data.rotation)
		end
		
		local x, y = img:GetSize()
		local truewidth = calculteRotatedWidth(data.rotation and data.rotation or 0, x, y)
		local trueheight = calculteRotatedHeight(data.rotation and data.rotation or 0, x, y)
		local adjustedoffset = data.leftoffset and data.leftoffset or  0
		
		img:SetPosition(left + truewidth + adjustedoffset, height - (0.5 * trueheight))
		img:SetClickable(false)
		
		if not data.ignoreheightchange then
			height = height - trueheight - section_space
		end

		return height, img
	end

	local setcustomblock = function(height,data)
		local panel = sub_root:AddChild(Widget("custompanel"))
		local bg
		
		height, bg = setimageblock(height,{ignoreheightchange = true, widget = panel, source = "images/scrapbook.xml", tex = "scrap_square.tex"})

		local shade = 0.8 + self.PRNG:Rand() * 0.2
		bg:SetTint(shade,shade,shade,1)

		local MARGIN = data.margin and data.margin or 15
		local textblock
		
		height, textblock = settextblock(height, { 
				str = data.str, 
				width = data.width or nil, 
				font = data.font or CHATFONT, 
				size = data.size or 15, 
				color = data.fontcolor or UICOLOURS.BLACK, 
				leftmargin = MARGIN + 50, 
				rightmargin =MARGIN + 50, 
				leftoffset = -width / 2, 
				ignoreheightchange = true, 
				widget = panel
			})
			
		local pos_t = textblock:GetPosition()
		textblock:SetPosition(0, 0)

		local w, h = textblock:GetRegionSize()
		local boxwidth = w + (MARGIN * 2)
		local widthdiff = 0
		
		if data.minwidth and boxwidth < data.minwidth then
			widthdiff = data.minwidth - boxwidth
			boxwidth = data.minwidth
		end

		applytexturesize(bg, boxwidth, h + (MARGIN * 2))

		local angle =  data.norotation and 0 or self.PRNG:Rand() * 3 - 1.5
		panel:SetRotation(angle)

		pos_t = textblock:GetPosition()
		bg:SetPosition(0,0)

		local attachments = panel:AddChild(Widget("attachments"))
		attachments:SetPosition(0,0)
 		setattachmentdetils(attachments, boxwidth, h + (MARGIN * 2), data.shortblock)
		local newheight = calculteRotatedHeight(angle, boxwidth, h + (MARGIN * 2))

		panel:SetPosition( boxwidth / 2 + (data.leftoffset or 0), height - (newheight / 2) - (data.topoffset or 0))
		
		if not data.ignoreheightchange then
			height = height - newheight - section_space
		end
		
		return height, panel, newheight
	end
	
	local cattitle
	
	if data and data.subcat then
		local subcat = STRINGS.SCRAPBOOK.SUBCATS[string.upper(data.subcat)]
		height, cattitle = settextblock(height, {font = HEADERFONT, size = 25, str = subcat.."/  ", color = UICOLOURS.GOLD, ignoreheightchange = true})
	end

	local title
	local leftoffset = 0
	
	if cattitle then
		leftoffset = cattitle:GetRegionSize()
	end

	local name = data ~= nil and STRINGS.NAMES[string.upper(data.name)] or ""

	height, title = settextblock(height, {font = HEADERFONT, size = 25, str = name, color = UICOLOURS.WHITE, leftoffset = leftoffset})
	height = height  - 10
	
	local rotation = (self.PRNG:Rand() * 5)- 2.5

	local CUSTOM_SIZE = Vector3(150, 250, 0)
	local CUSTOM_ANIMOFFSET = Vector3(0, -40, 0)
	local CUSTOM_INDENT = 40 + (self.PRNG:Rand() * 25)

	local STAT_PANEL_WIDTH = 220
	local STAT_PANEL_INDENT = 30
	local STAT_GAP_SMALL = 5
	local STAT_ICONSIZE = 32

	local stats, statsheight

	local statwidget = sub_root:AddChild(Widget("statswidget"))
	local statbg = statwidget:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))
	local statsheight = 0
	statsheight = statsheight - STAT_PANEL_INDENT

	local showstats = false
	local makeentry = function(tex,text)
		showstats = true
		
		if tex then
			local icon = statwidget:AddChild(Image(GetScrapbookIconAtlas(tex) or GetScrapbookIconAtlas("cactus.tex"), tex))
			icon:ScaleToSize(STAT_ICONSIZE, STAT_ICONSIZE)
			icon:SetPosition(STAT_PANEL_INDENT + (STAT_ICONSIZE / 2), statsheight - STAT_ICONSIZE / 2)
		end
		
		local txt = statwidget:AddChild(Text(HEADERFONT, 18, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT + STAT_ICONSIZE + STAT_GAP_SMALL + (tw / 2), statsheight -(STAT_ICONSIZE / 2) -2)
		txt:SetHAlign(ANCHOR_LEFT)
		statsheight = statsheight - STAT_ICONSIZE - STAT_GAP_SMALL
	end
	
	local makesubentry = function(text)
		showstats = true
		
		local txt = statwidget:AddChild(Text(HEADERFONT, 12, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT + STAT_ICONSIZE + STAT_GAP_SMALL + (tw / 2), statsheight + STAT_GAP_SMALL)
		statsheight = statsheight - STAT_GAP_SMALL
	end

	local makesubiconentry = function(tex,subwidth,text)
		showstats = true
		
		local icon = statwidget:AddChild(Image(GetScrapbookIconAtlas(tex) or GetScrapbookIconAtlas("cactus.tex"), tex))
		icon:ScaleToSize(STAT_ICONSIZE,STAT_ICONSIZE)
		icon:SetPosition(STAT_PANEL_INDENT + subwidth + (STAT_ICONSIZE / 2), statsheight + STAT_GAP_SMALL + (STAT_ICONSIZE / 2))
		
		local txt = statwidget:AddChild(Text(HEADERFONT, 18, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT + subwidth + STAT_ICONSIZE + (tw / 2), statsheight + STAT_GAP_SMALL + (STAT_ICONSIZE / 2)- 2) --+ STAT_GAP_SMALL
		subwidth = subwidth + STAT_ICONSIZE+ tw
		
		return subwidth
	end

	local makelistentry = function(textures, texts, iconsize, maxgap)
		local x = 75
		local addedtext = false

		statsheight = statsheight - 5

		for i, iconname in ipairs(textures) do
			local tex = iconname .. ".tex"
			local icon = statwidget:AddChild(Image(GetScrapbookIconAtlas(tex) or GetInventoryItemAtlas(tex), tex))
			icon:ScaleToSize(iconsize, iconsize)
			icon:SetPosition(x, statsheight)

			if texts ~= nil and texts[i] ~= nil then
				addedtext = true

				local txt = statwidget:AddChild(Text(HEADERFONT, 13, texts[i], UICOLOURS.BLACK))
				txt:SetPosition(x, statsheight - iconsize)
			end

			x =  x + math.min((140 / #textures), maxgap or math.huge)
		end

		statsheight = statsheight - iconsize - STAT_GAP_SMALL * (addedtext and 3 or 0)
	end

	if data then
		if data.health then
			makeentry("icon_health.tex", tostring(checknumber(data.health) and math.floor(data.health) or data.health))
		end

		if data.damage then
			makeentry("icon_damage.tex", tostring(checknumber(data.damage) and math.floor(data.damage) or data.damage))
			
			if data.planardamage then
				makesubentry("+"..math.floor(data.planardamage) .. STRINGS.SCRAPBOOK.DATA_PLANAR_DAMAGE)
			end
		end

		if data.sanityaura then
			local sanitystr = ""
			
			if data.sanityaura >= TUNING.SANITYAURA_HUGE then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSHIGH
			elseif data.sanityaura >= TUNING.SANITYAURA_MED then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSMED
			elseif data.sanityaura > 0 then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSSMALL
			elseif data.sanityaura == 0 then
				sanitystr = nil
			elseif data.sanityaura < 0 and data.sanityaura > -TUNING.SANITYAURA_MED then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGSMALL
			elseif data.sanityaura > -TUNING.SANITYAURA_HUGE then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGMED
			else
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGHIGH
			end
			
			if sanitystr then
				makeentry("icon_sanity.tex", sanitystr)
			end
		end

		if data.type == "item" or data.type == "food" then
			if data.stacksize then
				makeentry("icon_stack.tex",data.stacksize..STRINGS.SCRAPBOOK.DATA_STACK)
			end
		end

		local showfood = true
		
		if data.hungervalue and data.hungervalue == 0 and
			data.healthvalue and data.healthvalue == 0 and
			data.sanityvalue and data.sanityvalue == 0 then
			showfood = false
		end

		--[[
		if data.foodtype == FOODTYPE.ELEMENTAL or data.foodtype == FOODTYPE.ROUGHAGE or data.foodtype == FOODTYPE.HORRIBLE then
			showfood = false
		end
		]]--

		if showfood and data.foodtype then
			local str = STRINGS.SCRAPBOOK.FOODTYPE[data.foodtype]
			
			makeentry("icon_food.tex", str)
			
			if not table.contains(FOODGROUP.OMNI.types, data.foodtype) then
				makesubentry(STRINGS.SCRAPBOOK.DATA_NON_PLAYER_FOOD)
				statsheight = statsheight - (STAT_GAP_SMALL * 2)
			end
		end

		if showfood and
			data.hungervalue ~= nil and
			data.healthvalue ~= nil and
			data.sanityvalue ~= nil then
			
			local icons = 
			{
				"icon_hunger",
				"icon_health",
				"icon_sanity",
			}

			local texts = 
			{
				(data.hungervalue > 0 and "+" or "")..(data.hungervalue % 1 > 0 and string.format("%.1f", data.hungervalue) or math.floor(data.hungervalue)),
				(data.healthvalue > 0 and "+" or "")..(data.healthvalue % 1 > 0 and string.format("%.1f", data.healthvalue) or math.floor(data.healthvalue)),
				(data.sanityvalue > 0 and "+" or "")..(data.sanityvalue % 1 > 0 and string.format("%.1f", data.sanityvalue) or math.floor(data.sanityvalue)),
			}

			makelistentry(icons, texts, STAT_ICONSIZE - 10)
		end

		if data.weapondamage then
			makeentry("icon_damage.tex", tostring(checknumber(data.weapondamage) and math.floor(data.weapondamage) or data.weapondamage))
			
			if data.planardamage then
				makesubentry("+"..tostring(checknumber(data.planardamage) and math.floor(data.planardamage) or data.planardamage).. STRINGS.SCRAPBOOK.DATA_PLANAR_DAMAGE)
			end

			if data.areadamage then
				statsheight = statsheight - STAT_GAP_SMALL -2
				makesubentry("+"..math.floor(data.areadamage) .. STRINGS.SCRAPBOOK.DATA_SPLASHDAMAGE)
			end

			if data.weaponrange then
				statsheight = statsheight - STAT_GAP_SMALL -2
				makesubentry("+"..math.floor(data.weaponrange) .. STRINGS.SCRAPBOOK.DATA_RANGE)
			end
		end

		if data.finiteuses then
			makeentry("icon_uses.tex", math.floor(data.finiteuses)..STRINGS.SCRAPBOOK.DATA_USES)
		end

		if data.toolactions then
			local actions = ""

			for i, act in ipairs(data.toolactions) do
				local string = STRINGS.ACTIONS[act]

				if type(string) == "table" and string.GENERIC then
					string = string.GENERIC
				end

				actions = actions .. string.upper(string or act)

				if i ~= #data.toolactions then
					actions = actions .. ", "
				end
			end

			makesubentry(actions)
		end

		if data.armor then
			makeentry("icon_armor.tex", math.floor(data.armor))
		end

		if data.absorb_percent then
			makesubentry(STRINGS.SCRAPBOOK.DATA_ARMOR_ABSORB..(data.absorb_percent * 100).. "%")
		end

		if data.armor_planardefense then
			if data.absorb_percent then
				statsheight = statsheight - STAT_GAP_SMALL -2
			end
			
			makesubentry("+"..data.armor_planardefense ..STRINGS.SCRAPBOOK.DATA_PLANAR_DEFENSE)
		end

		if data.forgerepairable then
			makeentry("icon_wrench.tex", STRINGS.SCRAPBOOK.DATA_NOBREAK)
			makesubentry(STRINGS.SCRAPBOOK.DATA_REPAIRABLE)

			makelistentry(data.forgerepairable, nil, STAT_ICONSIZE / 1.5, 30)
		end

		if data.repairitems then
			makeentry("icon_wrench.tex", STRINGS.SCRAPBOOK.DATA_REPAIRABLE)
			makelistentry(data.repairitems, nil, STAT_ICONSIZE / 1.5, 30)
		end

		if data.waterproofer then
			makeentry("icon_wetness.tex", STRINGS.SCRAPBOOK.DATA_WETNESS ..(data.waterproofer * 100) .. "%")
		end

		if data.insulator then
			local icon = "icon_cold.tex"
			
			if data.insulator_type and data.insulator_type == SEASONS.SUMMER then
				icon = "icon_heat.tex"
			end
			
			makeentry(icon, data.insulator..STRINGS.SCRAPBOOK.DATA_INSULATION)
		end

		if data.dapperness and data.dapperness ~= 0 then
			local dir = data.dapperness < 0 and "" or "+"
			makeentry("icon_sanity.tex", string.format("%s%.2f%s", dir, data.dapperness * 60, STRINGS.SCRAPBOOK.DATA_PERMIN ))
		end

		-- FUEL + FUEL TYPES
		if data.fueledrate ~= nil and data.fueledmax  ~= nil and data.fueledtype1 ~= nil then
			local icon = data.fueledtype1 == FUELTYPE.USAGE and "icon_clothing.tex" or "icon_needfuel.tex"

			data.fueledrate = data.fueledrate == 0 and 1 or data.fueledrate

			local time = data.fueledmax/data.fueledrate
			local time_str = data.fueleduses and (math.floor(time)..STRINGS.SCRAPBOOK.DATA_USES) or GetPeriodString(time)

			if not table.contains(FUELTYPE_SUBICONS, data.fueledtype1) then
				makeentry(icon, time_str)
			else
				local subicon1 = FUELTYPE_SUBICON_LOOKUP[data.fueledtype1]
				local subicon2 = data.fueledtype2 ~= nil and FUELTYPE_SUBICON_LOOKUP[data.fueledtype2] or nil

				if subicon1 ~= nil then
					makeentry(icon, "")

					local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL + (subicon2 and STAT_ICONSIZE / 3 or 0)

					makesubiconentry(subicon1, subwidth, time_str)
				end

				local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL - STAT_ICONSIZE/4

				if data.fueledtype2 ~= nil and data.fueledtype2 ~= FUELTYPE.USAGE then
					if subicon2 ~= nil then
						makesubiconentry(subicon2, subwidth, "")
					end
				end
			end
		end

		if data.fueltype ~= nil and data.fuelvalue ~= nil then
			local time_str = GetPeriodString(data.fuelvalue)

			if not table.contains(FUELTYPE_SUBICONS, data.fueltype) then
				makeentry("icon_fuel.tex", time_str)
			else
				local icon = FUELTYPE_SUBICON_LOOKUP[data.fueltype]

				if icon then
					makeentry("icon_fuel.tex", "")

					local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL

					subwidth = makesubiconentry(icon, subwidth, time_str)
				end
			end
		end

		if data.sewable then
			makeentry("icon_sewingkit.tex", STRINGS.SCRAPBOOK.DATA_SEWABLE )
		end

		if data.perishable then
			makeentry("icon_spoil.tex", GetPeriodString(data.perishable))
		end

		if data.notes then
			if data.notes.shadow_aligned then
				makeentry("icon_shadowaligned.tex", STRINGS.SCRAPBOOK.NOTE_SHADOW_ALIGNED)
			end
			
			if data.notes.lunar_aligned then
				makeentry("icon_moonaligned.tex", STRINGS.SCRAPBOOK.NOTE_LUNAR_ALIGNED)
			end
		end

		if data.lightbattery then
			makeentry("icon_lightbattery.tex", STRINGS.SCRAPBOOK.DATA_LIGHTBATTERY)
		end

		if data.float_range and data.float_accuracy then
			makeentry("icon_bobber.tex", STRINGS.SCRAPBOOK.DATA_FLOAT_RANGE ..data.float_range)
			makesubentry(STRINGS.SCRAPBOOK.DATA_FLOAT_ACCURACY..data.float_accuracy)
		end

		if data.lure_charm and data.lure_dist and data.lure_radius then
			makeentry("icon_lure.tex", STRINGS.SCRAPBOOK.DATA_LURE_RADIUS ..data.lure_radius)
			makesubentry(STRINGS.SCRAPBOOK.DATA_LURE_CHARM..data.lure_charm)
			
			statsheight = statsheight - STAT_GAP_SMALL -2
			makesubentry(STRINGS.SCRAPBOOK.DATA_LURE_DIST..data.lure_dist)
		end

		if data.oar_force and data.oar_velocity then
			makeentry("icon_oar.tex", STRINGS.SCRAPBOOK.DATA_OAR_VELOCITY.. data.oar_velocity)
			makesubentry(STRINGS.SCRAPBOOK.DATA_OAR_FORCE.. data.oar_force)
		end

		if data.workable then
			if data.workable == ACTIONS.HAMMER.id then
				makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_WORKABLE_HAMMER)
			end
			
			if data.workable == ACTIONS.CHOP.id then
				makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_WORKABLE_CHOP)
			end
			
			if data.workable == ACTIONS.DIG.id then
				makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_WORKABLE_DIG)
			end
			
			if data.workable == ACTIONS.MINE.id then
				makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_WORKABLE_MINE)
			end
		end
		
		Hof_AddData(self, data, makeentry, makesubentry, makesubiconentry)
		
		if data.fishable then
			makeentry("icon_uses.tex", STRINGS.SCRAPBOOK.DATA_FISHABLE)
		end
		
		if data.pickable then
			makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_PICKABLE)
		end
		
		if data.harvestable then
			makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_HARVESTABLE)
		end
		
		if data.stewer then
			makeentry("icon_action.tex", STRINGS.SCRAPBOOK.DATA_STEWER)
		end
		
		if data.activatable then
			makeentry("icon_action.tex", string.upper(STRINGS.ACTIONS.ACTIVATE[data.activatable]))
		end
		
		if data.burnable then
			makeentry("icon_burnable.tex", STRINGS.SCRAPBOOK.DATA_BURNABLE)
		end

		if data.snowmandecor then
			makeentry("icon_snowmandeco.tex", STRINGS.SCRAPBOOK.DATA_SNOWMANDECO)
		end
	end

	statsheight = statsheight - (STAT_PANEL_INDENT - STAT_GAP_SMALL)

	applytexturesize(statbg,STAT_PANEL_WIDTH, math.abs(statsheight))

	local attachments = statwidget:AddChild(Widget("attachments"))
	attachments:SetPosition(STAT_PANEL_WIDTH / 2, -math.abs(statsheight) / 2)
	statbg:SetPosition(STAT_PANEL_WIDTH / 2, -math.abs(statsheight) / 2)
	setattachmentdetils(attachments, STAT_PANEL_WIDTH, math.abs(statsheight))

	local photostack = sub_root:AddChild(Widget("photostack"))
	local photo = photostack:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))

	photo:SetClickable(false)
	local BUFFER = 35
	local ACTUAL_X = CUSTOM_SIZE.x
	local ACTUAL_Y = CUSTOM_SIZE.y
	local offsety = 0
	local offsetx = 0
	local animal = nil

	if data then
		animal = photostack:AddChild(UIAnim())
		local animstate = animal:GetAnimState()

		animstate:SetBuild(data.build)
		animstate:SetBank(data.bank)
		animstate:SetPercent(data.anim or "", data.animpercent or self.PRNG:Rand())

		if data.facing then
			animal:SetFacing(data.facing)
			animstate:MakeFacingDirty()
		end

		if data.alpha or data.multcolour then
			local r, g, b = unpack(data.multcolour or {1, 1, 1})
			animstate:SetMultColour(r, g, b, data.alpha or 1)
		end

		if data.overridebuild then
			if type(data.overridebuild) == "table" then
				for k, v in pairs(data.overridebuild) do
					animstate:AddOverrideBuild(v)
				end
			else
				animstate:AddOverrideBuild(data.overridebuild)
			end
		end

		animstate:Hide("snow")
		animstate:Hide("mouseover")

		if data.hide then
			for i, hide in ipairs(data.hide) do
				animstate:Hide(hide)
			end
		end

		if data.hidesymbol then
			for i, hide in ipairs(data.hidesymbol) do
				animstate:HideSymbol(hide)
			end
		end

		if data.overridesymbol then
			if type(data.overridesymbol[1]) ~= "table" then
				animstate:OverrideSymbol(data.overridesymbol[1], data.overridesymbol[2], data.overridesymbol[3])

				if data.overridesymbol[4] then
					animstate:SetSymbolMultColour(data.overridesymbol[1], 1, 1, 1, tonumber(data.overridesymbol[4]))
				end
			else
				for i, set in ipairs(data.overridesymbol) do
					animstate:OverrideSymbol(set[1], set[2], set[3])

					if set[4] then
						animstate:SetSymbolMultColour(set[1], 1, 1, 1, tonumber(set[4]))
					end
				end
			end
		end

		if data.symbolcolours then
			for i, set in ipairs(data.symbolcolours) do
				animstate:SetSymbolMultColour(set[1], set[2], set[3], set[4], set[5])
			end
		end

		if data.usepointfiltering then
			animstate:UsePointFiltering(true)
		end

		local x1, y1, x2, y2 = animstate:GetVisualBB()
		local ax, ay = animal:GetBoundingBoxSize()

		if data.bb_x_extra or data.bb_y_extra then
			ax, ay = ax + data.bb_x_extra or 0, ay + data.bb_y_extra or 0
		end

		local SCALE = CUSTOM_SIZE.x/ax

		if ay * SCALE >= ACTUAL_Y then
			SCALE = ACTUAL_Y/ay
			ACTUAL_X = ax * SCALE
		else
			ACTUAL_Y = ay * SCALE
		end

		SCALE = SCALE * (data.scale or 1)

		animal:SetScale(math.min(0.5, SCALE))
		offsety = ACTUAL_Y / 2 -(y2 * SCALE)
		offsetx = ACTUAL_X / 2 -(x2 * SCALE)

		if data.floater ~= nil then
			local size, vert_offset, xscale, yscale = unpack(data.floater)

			local floater = animal:AddChild(UIAnim())
			local floater_animstate = floater:GetAnimState()

			floater_animstate:SetBuild("float_fx")
			floater_animstate:SetBank("float_front")
			floater_animstate:SetPercent("idle_front_" .. size, self.PRNG:Rand())
			floater_animstate:SetFloatParams(-0.05, 1.0, 0)

			floater:SetPosition(0, tonumber(vert_offset), 0)
			floater:SetScale(tonumber(xscale) - .05, tonumber(yscale) - .05)
			floater:SetClickable(false)
		end
	else
		animal = photostack:AddChild(Image("images/scrapbook.xml", "icon_empty.tex"))
		ACTUAL_X = CUSTOM_SIZE.x
		ACTUAL_Y = CUSTOM_SIZE.x/379*375
		animal:ScaleToSize(ACTUAL_X,ACTUAL_Y)
		offsetx = 0
		offsety = 0
	end

	local extraoffsetbgx = data and data.animoffsetbgx or 0
	local extraoffsetbgy = data and data.animoffsetbgy or 0

	local BG_X = (ACTUAL_X + BUFFER + extraoffsetbgx)
	local BG_Y = (ACTUAL_Y + BUFFER + extraoffsetbgy)

	applytexturesize(photo,BG_X, BG_Y)
	setattachmentdetils(photostack, BG_X, BG_Y)

	animal:SetClickable(false)

	CUSTOM_ANIMOFFSET = Vector3(offsetx, -offsety,0)
	local extraoffsetx = data and data.animoffsetx or 0
	local extraoffsety = data and data.animoffsety or 0

	local posx =(CUSTOM_ANIMOFFSET.x + extraoffsetx) * (data and data.scale and data.scale * .5 or 1)
	local posy =(CUSTOM_ANIMOFFSET.y + extraoffsety) * (data and data.scale and data.scale or 1)

	animal:SetPosition(posx,posy)

	if data and data.knownlevel == 1 then
		animal:GetAnimState():SetSaturation(0)
		photo:SetTint(unpack(UK_TINT))
	end

	self.animal = animal

	photostack:SetRotation(rotation)

	local ROT_X = ACTUAL_X + extraoffsetbgx
	local ROT_Y = ACTUAL_Y + extraoffsetbgy

	local rotheight = calculteRotatedHeight(rotation, ROT_X, ROT_Y)
	local rotwidth = calculteRotatedWidth(rotation, ROT_X, ROT_Y)

	if statwidget then
		local pos_s = statwidget:GetPosition()
		statwidget:SetPosition(rotwidth + CUSTOM_INDENT + 30, height)
	end
	
	if not showstats or (data and data.knownlevel < 2) then
		statwidget:Hide()
	end

	height = height - 20
	photostack:SetPosition(left + (rotwidth / 2) + CUSTOM_INDENT, height - (0.5 * rotheight))

	local finalheight = ((rotheight + 20 > math.abs(statsheight)) or (data and data.knownlevel < 2) ) and rotheight + 20 or math.abs(statsheight)

	height = height - finalheight - section_space

	if data and data.knownlevel == 1 then
		local inspectbody
		height, inspectbody = setcustomblock(height,{str = STRINGS.SCRAPBOOK.DATA_NEEDS_INVESTIGATION, minwidth = width - 100, leftoffset = 40, shortblock = true})
	end
	
	if not data then
		local inspectbody
		height, inspectbody = setcustomblock(height,{str = " \n \n \n \n \n ", minwidth = width - 100, leftoffset = 40, })
	end

	local specialinfo = data and (data.specialinfo and STRINGS.SCRAPBOOK.SPECIALINFO[data.specialinfo] or STRINGS.SCRAPBOOK.SPECIALINFO[string.upper(data.prefab)])

	if specialinfo and data.knownlevel > 1 then
		local body
		local shortblock = string.len(specialinfo) < 110
		height, body = setcustomblock(height, {str = specialinfo, minwidth = width-100, leftoffset = 40, shortblock = shortblock})
	end

	self.depsbuttons = {}
	self.character_pannel_first = nil

	local DEPS_COLS = 9

	if data and data.deps and #data.deps > 0 then
		local idx = 1
		local row = 1
		local cols = DEPS_COLS
		local gaps = 7
		local imagesize = 32
		local imagebuffer = 5
		local depstoshow = shallowcopy(data.deps)

		table.sort(depstoshow, function(a, b)
			local a = self:GetData(a)
			local b = self:GetData(b)

			local a_name = STRINGS.NAMES[string.upper(a.name)] or FILLER
			local b_name = STRINGS.NAMES[string.upper(b.name)] or FILLER
			
			if a.subcat then a_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(a.subcat)] .. a_name end
			if b.subcat then b_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(b.subcat)] .. b_name end

			if a.knownlevel == 0 or b.knownlevel == 0 then
				return a.knownlevel > b.knownlevel
			end

			if not a_name or not b_name then
				return false
			end

			if a_name == b_name and a.entry and b.entry then
				return a.entry < b.entry
			end

			return stringidsorter(a_name, b_name)
		end)

		local dep_imgsize = imagesize - imagebuffer
		local needs_img_types = { "item", "food" }

		for i, dep in ipairs(depstoshow)do
			local xidx = i%cols
			
			if xidx == 0 then
				xidx = cols
			end

			local depdata = self:GetData(dep)

			if depdata ~= nil then
				local tex = depdata.tex
				local atlas = GetScrapbookIconAtlas(tex)
				local button = sub_root:AddChild(ImageButton(atlas or GetScrapbookIconAtlas("cactus.tex"), atlas ~= nil and tex or "cactus.tex" ))

				local frame = sub_root:AddChild(Image("images/skilltree.xml", "frame.tex" ))
				frame:ScaleToSize(imagesize + 13, imagesize + 13)
				frame:SetPosition(75 + ((imagesize + gaps) * (xidx - 1)), height -imagesize / 2 - ((row - 1) * (imagesize + gaps)))
				frame:Hide()

				button.ignore_standard_scaling = true
				button.scale_on_focus = true
				button.clickoffset = Vector3(0, 0, 0)
				button:SetFocusScale(1.12, 1.12, 1.12)
				button:SetPosition(75 + ((imagesize + gaps) * (xidx - 1)), height - imagesize / 2 - ((row - 1) * (imagesize + gaps)))
				button:ForceImageSize(imagesize + 2, imagesize + 2)
				button:SetOnClick(function()
					self.detailsroot:KillAllChildren()
					self.details = nil
					self.details = self.detailsroot:AddChild(self:PopulateInfoPanel(dep))
					self:DoFocusHookups()
					
					if TheInput:ControllerAttached() then
						self.details:SetFocus()
					end
				end)

				if depdata.knownlevel == 1 then
					button:SetImageNormalColour(unpack(UK_TINT))
					button:SetImageFocusColour(unpack(UK_TINT))
				end
				
				local buttonimg
				
				if depdata.knownlevel == 0 then
					button:SetTextures(GetScrapbookIconAtlas("unknown.tex"), "unknown.tex")
					button:SetOnClick(function() end)
				elseif table.contains(needs_img_types, depdata.type) then
					button:SetTextures("images/scrapbook.xml", "inv_item_background.tex")

					atlas = GetInventoryItemAtlas(tex)

					local img = button:AddChild(Image(atlas, tex))
					img:ScaleToSize(dep_imgsize, dep_imgsize)

					if depdata.knownlevel == 1 then
						img:SetTint(unpack(UK_TINT))
					end
					
					buttonimg = img
				end

				button:SetOnGainFocus(function()
					if TheInput:ControllerAttached() then
						frame:Show()
					end
					
					if buttonimg and depdata.knownlevel ~= 0 then
						buttonimg:ScaleToSize(dep_imgsize*button.focus_scale[1], dep_imgsize * button.focus_scale[2])
					end
				end)

				button:SetOnLoseFocus(function()
					if TheInput:ControllerAttached() then
						frame:Hide()
					end
					
					if buttonimg and depdata.knownlevel ~= 0 then
						buttonimg:ScaleToSize(dep_imgsize*button.normal_scale[1], dep_imgsize * button.normal_scale[2])
					end
				end)

				table.insert(self.depsbuttons, button)
			end

			if xidx == cols and i < #depstoshow then
				row = row + 1
			end
		end

		height = height - ((imagesize + gaps) * row) - section_space
	end

	if #self.depsbuttons > 0 then
		for i,button in ipairs(self.depsbuttons) do
			if i > DEPS_COLS then
				button:SetFocusChangeDir(MOVE_UP, function(button) return self.depsbuttons[i-DEPS_COLS] end)
			end
			
			if i%DEPS_COLS ~= 1 then
				button:SetFocusChangeDir(MOVE_LEFT, function(button) return self.depsbuttons[i-1] end)
			end
			
			if i%DEPS_COLS ~= 0 then
				button:SetFocusChangeDir(MOVE_RIGHT, function(button) return self.depsbuttons[i+1] end)
			end
			
			if i+DEPS_COLS <= #self.depsbuttons then
				button:SetFocusChangeDir(MOVE_DOWN, function(button) return self.depsbuttons[i+DEPS_COLS] end)
			else
				button:SetFocusChangeDir(MOVE_DOWN, function(button)
					if TheInput:ControllerAttached() and self.character_pannel_first ~= nil then
						local x, y, z = self.character_pannel_first:GetPositionXYZ()
						local scrollpos = (math.abs(y) / math.abs(self.scroll_area.maximum_height)) * self.scroll_area.scroll_pos_end
						self.scroll_area.target_scroll_pos = scrollpos
					end

					return  self.character_pannel_first
				end)
			end
		end
	end

	if data then
		if STRINGS.RECIPE_DESC[string.upper(data.prefab)] then
			local STAT_PANEL_WIDTH = width -40
			local STAT_PANEL_INDENT = 20
			local STAT_GAP_SMALL = 5
			local STAT_ICONSIZE = 40

			local recipewidget, recipeheight
			local recipewidget = sub_root:AddChild(Widget("statswidget"))
			local recipebg = recipewidget:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))
			local recipeheight = 0

			recipeheight = recipeheight - STAT_PANEL_INDENT

			local atlas, tex

			for cat, recdata in pairs(CRAFTING_FILTERS) do
				local breakout = false
				
				if recdata.recipes then
					if type(recdata.recipes) == "function" then
						recdata.recipes = recdata.recipes()
					end

					for idx, recipe in ipairs(recdata.recipes) do
						if recipe == data.prefab then
							atlas = recdata.atlas()
							tex = recdata.image
							
							breakout = true
							break
						end

						--[[
						local recipedata = AllRecipes[recipe]

						if recipe == data.prefab or (recipedata ~= nil and recipedata.product == data.prefab) then
							atlas = recipedata.filteratlas or recdata.atlas()
							tex = recipedata.filterimage or recdata.image

							breakout = true
							break
						end
						]]--
					end
				end
				
				if breakout then
					break
				end
			end
			
			if type(tex) == "function" then
				tex = tex(data.craftingprefab and {prefab = data.craftingprefab} or nil)
			end

			local makerecipeentry = function(tex, text)
				local icon = recipewidget:AddChild(Image(atlas, tex))
				icon:ScaleToSize(STAT_ICONSIZE,STAT_ICONSIZE)
				icon:SetPosition(STAT_PANEL_INDENT + (STAT_ICONSIZE / 2), recipeheight - STAT_ICONSIZE / 2)
				
				local txt = recipewidget:AddChild(Text(CHATFONT, 15, text, UICOLOURS.BLACK))
				txt:SetMultilineTruncatedString(text, 100, STAT_PANEL_WIDTH - (STAT_PANEL_INDENT * 2) - STAT_ICONSIZE - STAT_GAP_SMALL)
				
				local tw, th = txt:GetRegionSize()
				txt:SetPosition(STAT_PANEL_INDENT + STAT_ICONSIZE + STAT_GAP_SMALL + (tw / 2), recipeheight - STAT_ICONSIZE / 2)
				txt:SetHAlign(ANCHOR_LEFT)
				recipeheight = recipeheight - STAT_ICONSIZE - STAT_GAP_SMALL
			end

			local makerecipesubentry = function(text)
				local txt = recipewidget:AddChild(Text(CHATFONT, 15, text, UICOLOURS.BLACK))
				local tw, th = txt:GetRegionSize()
				
				txt:SetPosition(STAT_PANEL_WIDTH / 2, recipeheight - (th / 2) - STAT_GAP_SMALL)
				recipeheight = recipeheight - STAT_GAP_SMALL - th
			end

			local maketextentry = function(text)
				local txt = recipewidget:AddChild(Text(HEADERFONT, 15, text, UICOLOURS.BLACK))
				local tw, th = txt:GetRegionSize()
				
				txt:SetPosition(STAT_PANEL_WIDTH / 2, recipeheight - (th / 2) - STAT_GAP_SMALL)
				recipeheight = recipeheight - STAT_GAP_SMALL - th
			end

			maketextentry(STRINGS.SCRAPBOOK.DATA_CRAFTING)
			makerecipeentry(tex, STRINGS.RECIPE_DESC[string.upper(data.prefab)])
			-- makerecipesubentry(STRINGS.RECIPE_DESC[string.upper(data.prefab)])

			recipeheight = recipeheight - (STAT_PANEL_INDENT - STAT_GAP_SMALL)

			applytexturesize(recipebg, STAT_PANEL_WIDTH, math.abs(recipeheight))

			local attachments = recipewidget:AddChild(Widget("attachments"))
			attachments:SetPosition(STAT_PANEL_WIDTH / 2, -math.abs(recipeheight) / 2)
			recipebg:SetPosition(STAT_PANEL_WIDTH / 2, -math.abs(recipeheight) / 2)
			setattachmentdetils(attachments, STAT_PANEL_WIDTH, math.abs(recipeheight))

			recipewidget:SetPosition(STAT_PANEL_INDENT, height)

			local rotation = (self.PRNG:Rand() * 5) -2.5
			recipewidget:SetRotation(rotation)

			local rotheight = calculteRotatedHeight(rotation,STAT_PANEL_WIDTH, math.abs(recipeheight))
			height = height - math.abs(rotheight) - (section_space * 2)
		end
	end
	
	if data then
		local character_panels = {}
		local viewed_characters = {}

		for i, char in ipairs(DST_CHARACTERLIST) do
			if TheScrapbookPartitions:WasInspectedByCharacter(data.prefab, char) then
				table.insert(viewed_characters, char)
			end
		end

		local entry_upper = string.upper(data.speechname or data.prefab)

		if data.knownlevel > 1 and STRINGS.CHARACTERS.GENERIC.DESCRIBE[entry_upper] and #viewed_characters > 0 then
			local row = 1
			local valid_index = 1
			local buttonorder = {}
			
			for i, char in ipairs(viewed_characters)do
				local xidx = valid_index%9

				if xidx == 0 then
					xidx = 9
				end

				if char ~= "wonkey" then
					local body = nil
					local descstr = ""
					local descchar = string.upper(char)
					
					if char == "wilson" then
						descchar = "GENERIC"
					end

					local objstr = ""
					
					if char ~= "wes" then
						objstr = STRINGS.CHARACTERS[descchar].DESCRIBE[entry_upper]
					end

					if not objstr then
						objstr = STRINGS.CHARACTERS.GENERIC.DESCRIBE[entry_upper]
					end

					if type(objstr) == "table" then
						if #objstr > 0 then
							objstr = objstr[math.floor(self.PRNG:Rand() * #objstr) + 1]
						elseif DESCRIPTION_STATUS_LOOKUP[entry_upper] ~= nil then
							objstr = objstr[DESCRIPTION_STATUS_LOOKUP[entry_upper]]
						elseif entry_upper == "ABIGAIL" then
							objstr = objstr["LEVEL1"][1]
						elseif entry_upper == "FLOWER" and data.prefab == "flower_rose" then
							objstr = objstr["ROSE"]
						else
							objstr = objstr["GENERIC"]
						end
					end

					if objstr and objstr:find("only_used_by_") then
						objstr = nil
					end

					if objstr then
						descstr = descstr.. objstr
						descstr = descstr.. " - "..STRINGS.CHARACTER_NAMES[char]
						height, body = setcustomblock(height, {str = descstr, minwidth = width-100, leftoffset = 40, ignoreheightchange = true, shortblock = true})
					end
					
					character_panels[char] = body
					
					if body then
						body.id = i
						body:Hide()

						local button = sub_root:AddChild(ImageButton("images/crafting_menu_avatars.xml", "avatar_".. char ..".tex"))
						button._panel = character_panels[char]
						button:ForceImageSize(50, 50)
						
						character_panels[char].facebutton = button
						
						button.ignore_standard_scaling = true
						button.scale_on_focus = true
						button:SetOnClick(function()
							for t, subchar in ipairs(DST_CHARACTERLIST) do
								if character_panels[subchar] then
									character_panels[subchar].facebutton:ForceImageSize(50, 50)
									character_panels[subchar]:Hide()
								end
							end
							
							character_panels[char].facebutton:ForceImageSize(65,65)
							character_panels[char]:Show()

							self.current_panel = i
						end)
						
						button:SetPosition(((width/(#DST_CHARACTERLIST / 2)) * xidx), height - 40 -((row) * 50))
						valid_index = valid_index + 1

						table.insert(buttonorder, button)
					end
				end

				if xidx == 9 and valid_index< #DST_CHARACTERLIST then
					row = row + 1
				end

				self.character_pannel_first = buttonorder[1]
			end

			if #buttonorder > 0 then
				for i, button in ipairs(buttonorder) do
					button:SetFocusChangeDir(MOVE_UP, function(button)
						if TheInput:ControllerAttached() and self.depsbuttons[1] ~= nil then
							local x, y, z = self.depsbuttons[1]:GetPositionXYZ()
							local scrollpos = (math.abs(y) / math.abs(self.scroll_area.maximum_height)) * self.scroll_area.scroll_pos_end
							self.scroll_area.target_scroll_pos = scrollpos
						end

						return self.depsbuttons[1]
					end)

					if i ~= 1 then
						button:SetFocusChangeDir(MOVE_LEFT, function(button) return buttonorder[i - 1] end)
					end
					
					if i ~= #buttonorder then
						button:SetFocusChangeDir(MOVE_RIGHT, function(button) return buttonorder[i + 1] end)
					end
				end
			end

			local this_character_panel = character_panels[ThePlayer and TheScrapbookPartitions:WasInspectedByCharacter(data.prefab, ThePlayer.prefab) and ThePlayer.prefab or nil] or (self.character_pannel_first and self.character_pannel_first._panel) or nil

			if this_character_panel then
				this_character_panel.facebutton:ForceImageSize(65, 65)
				this_character_panel:Show()
				self.current_panel = this_character_panel.id
			end
		end

		self.character_panels = character_panels
		self.character_panels_total = #viewed_characters
	end

	height = height - 200
	height = math.abs(height)

	local max_visible_height = PANEL_HEIGHT -60
	local padding = 5

	local top = math.min(height, max_visible_height) / 2 - padding

	local scissor_data = {x = 0, y = -max_visible_height / 2, width = width, height = max_visible_height}
	local context = {widget = sub_root, offset = {x = 0, y = top}, size = {w = width, height = height + padding} }
	local scrollbar = { scroll_per_click = 20 * 3 }
	self.scroll_area = page:AddChild(TrueScrollArea(context, scissor_data, scrollbar))

	if height < (PANEL_HEIGHT - 60) then
		self.scroll_area:SetPosition(0,(((PANEL_HEIGHT - 60) / 2) - (height / 2)))
	end

	page.focus_forward = self.scroll_area
	
	if self.depsbuttons then
		self.scroll_area.focus_forward = self.depsbuttons[1]
	end

	if self.debugentry ~= nil and data ~= nil then
		local msg = string.format("DEBUG - Entry:\n%s\n%s.fla", tostring(page.entry or "???"), tostring(data.build or "???"))

		self.debugentry.entry = page.entry
		self.debugentry.build = data.build
		self.debugentry:SetText(msg)

		local w, h = self.debugentry.text:GetRegionSize()
		self.debugentry:SetPosition(-w * 2 - 5, h * 2 + 5)
	end
	
	self.scroll_area.maximum_height = height
	return page
end

function ScrapbookScreen:PopulateInfoPanel(entry, ...)
	local rets = {Hof_PopulateInfoPanel(self, entry, ...)}
	return unpack(rets)
end