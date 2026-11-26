local Image       = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Widget      = require("widgets/widget")
local Text        = require("widgets/text")
local TEMPLATES   = require("widgets/redux/templates")

local BG_ATLAS    = "images/hof_contributors.xml"

local BADGES =
{
	"ARTIST",
	"BETATESTER",
	"CONTENTCREATOR",
	"DEVELOPER",
	"DONATOR",
	"SUPPORTER",
	"GUIDECREATOR",
	"SECRET",
	"LOC",
	"WIKIWRITER",
}

local function AddImage(parent, texture, x, y, atlas, scale_x, scale_y)
	local image = parent:AddChild(Image(atlas or BG_ATLAS, texture..".tex"))

	image:SetPosition(x or 0, y or 0)
	image:SetScale(scale_x or 1, scale_y or 1, 1)

	return image
end

local ContributorsGlossaryWidget = Class(Widget, function(self)
	Widget._ctor(self, "ContributorsGlossaryWidget")

	self.root = self:AddChild(Widget("root"))

	local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))

	black.image:SetVRegPoint(ANCHOR_MIDDLE)
	black.image:SetHRegPoint(ANCHOR_MIDDLE)
	black.image:SetVAnchor(ANCHOR_MIDDLE)
	black.image:SetHAnchor(ANCHOR_MIDDLE)
	black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
	black.image:SetTint(0, 0, 0, .5)

	black:SetHelpTextMessage("")
	black:MoveToBack()

	self:BuildBackground()
	self:BuildBadgeList()
end)

function ContributorsGlossaryWidget:BuildBackground()
	self.background_root = self.root:AddChild(Widget("background_root"))

	AddImage(self.background_root, "background_glossary", 0, 40, nil, 1.00, 1.00)

	local title = self.background_root:AddChild(Text(HEADERFONT, 40, STRINGS.CONTRIBUTORS.GLOSSARY, UICOLOURS.BLACK))

	title:SetPosition(0, 285)
	title:SetScale(1.10, 1.10)

	AddImage(self.background_root, "line_break", 0,  245, nil,  0.80,  0.80)
	AddImage(self.background_root, "line_long",  0,  210, nil,  0.90,  0.90)
	AddImage(self.background_root, "line_long",  0, -210, nil, -0.90, -0.90)
end

function ContributorsGlossaryWidget:BuildBadgeList()
	self.list_root = self.root:AddChild(Widget("list_root"))
	self.list_root:SetPosition(0, 0)

	local cell_width = 440
	local cell_height = 90

	local badges = {}

	for _, key in ipairs(BADGES) do
		local name = STRINGS.CONTRIBUTORS.BADGES[key]

		if name ~= nil then
			table.insert(badges,
			{
				key         = key,
				name        = name,
				description = STRINGS.CONTRIBUTORS.BADGES[key.."_DESC"] or "",
				rarity      = STRINGS.CONTRIBUTORS.BADGES[key.."_RARITY"] or "",
				texture     = key == "LOC" and "badge_translator" or "badge_"..key:lower(),
			})
		end
	end

	local function ScrollWidgetsCtor(context, index)
		local widget = Widget("badge_entry_"..index)

		widget.background = widget:AddChild(Image(BG_ATLAS, "background_badge.tex"))
		widget.background:SetScale(0.43, 0.40)

		widget.icon = widget:AddChild(Image("images/global.xml", "square.tex"))
		widget.icon:SetPosition(-160, 0)
		widget.icon:SetScale(0.40)

		widget.name = widget:AddChild(Text(HEADERFONT, 18, "", UICOLOURS.BLACK))
		widget.name:SetPosition(0, 26)
		widget.name:SetHAlign(ANCHOR_MIDDLE)
		widget.name:SetVAlign(ANCHOR_MIDDLE)

		widget.separator = widget:AddChild(Image(BG_ATLAS, "separator.tex"))
		widget.separator:SetPosition(0, 15)
		widget.separator:SetScale(0.50, 0.60)

		widget.rarity = widget:AddChild(Text(HEADERFONT, 15, "", UICOLOURS.BLACK))
		widget.rarity:SetPosition(0, 5)
		widget.rarity:SetHAlign(ANCHOR_MIDDLE)
		widget.rarity:SetVAlign(ANCHOR_MIDDLE)

		widget.description = widget:AddChild(Text(HEADERFONT, 13, "", UICOLOURS.BLACK))
		widget.description:SetPosition(0, -25)
		widget.description:SetRegionSize(250, 36)
		widget.description:SetHAlign(ANCHOR_MIDDLE)
		widget.description:SetVAlign(ANCHOR_TOP)
		widget.description:EnableWordWrap(true)
		widget.description:EnableWhitespaceWrap(true)

		return widget
	end

	local function ScrollWidgetSetData(context, widget, data, index)
		if data ~= nil then
			widget.icon:SetTexture(BG_ATLAS, data.texture..".tex")
			widget.name:SetString(data.name)
			widget.rarity:SetString(STRINGS.CONTRIBUTORS.BADGES.TITLE_RARITY.." - "..data.rarity)
			widget.description:SetMultilineTruncatedString(data.description, 2, 250, nil, false)

			widget:Show()
		else
			widget:Hide()
		end
	end

	self.badge_grid = TEMPLATES.ScrollingGrid(badges,
	{
		context = {},

		widget_width = cell_width,
		widget_height = cell_height,

		force_peek = true,
		num_visible_rows = 4,
		num_columns = 1,

		item_ctor_fn = ScrollWidgetsCtor,
		apply_fn = ScrollWidgetSetData,

		scrollbar_offset = 20,
		scrollbar_height_offset = -40,
	})

	self.badge_grid.up_button:SetTextures(BG_ATLAS, "arrow_scroll_up_hover.tex")
	self.badge_grid.up_button:SetScale(0.50)

	self.badge_grid.down_button:SetTextures(BG_ATLAS, "arrow_scroll_down_hover.tex")
	self.badge_grid.down_button:SetScale(0.50)

	self.badge_grid.scroll_bar_line:SetTexture(BG_ATLAS, "scroll_bar.tex")
	self.badge_grid.scroll_bar_line:SetScale(0.96)

	self.badge_grid.position_marker:SetTextures(BG_ATLAS, "scroll_bar_handle.tex")
	self.badge_grid.position_marker.image:SetTexture(BG_ATLAS, "scroll_bar_handle.tex")
	self.badge_grid.position_marker:SetScale(0.60)

	self.list_root:AddChild(self.badge_grid)
	self.badge_grid:SetPosition(0, 0)
	self.badge_grid:SetScale(1, 1)

	self.badge_grid:SetItemsData(badges)
	self.badge_grid:RefreshView()
end

return ContributorsGlossaryWidget