local Button                     = require("widgets/button")
local Image                      = require("widgets/image")
local ImageButton                = require("widgets/imagebutton")
local Widget                     = require("widgets/widget")
local Text                       = require("widgets/text")
local TextButton                 = require("widgets/textbutton")
local Puppet                     = require("widgets/skinspuppet")
local TEMPLATES                  = require("widgets/redux/templates")
local PlayerAvatarPortrait       = require("widgets/redux/playeravatarportrait")
local ContributorsGlossaryWidget = require("widgets/redux/contributorsglossarywidget")

local BG_ATLAS                   = "images/hof_contributors.xml"
local ICON_ATLAS                 = "images/hof_contributors_icons.xml"

local CONTRIBUTORS               = {}

require("util")

for i, data in ipairs(require("tools/website/hof_contributors")) do
	CONTRIBUTORS[i] = data
end

table.sort(CONTRIBUTORS, function(a, b)
	return string.lower(a.name) < string.lower(b.name)
end)

local function AddImage(parent, texture, x, y, atlas, scale_x, scale_y)
	local image = parent:AddChild(Image(atlas or BG_ATLAS, texture..".tex"))

	image:SetPosition(x or 0, y or 0)
	image:SetScale(scale_x or 1, scale_y or 1, 1)

	return image
end

local ContributorsWidget = Class(Widget, function(self, parent)
	Widget._ctor(self, "ContributorsWidget")

	self.root = self:AddChild(Widget("root"))
	self.root:SetScale(1, 1)

	self.selected_contributor = nil

	self.search_text = ""
	self.filtered_contributors = CONTRIBUTORS

	self:BuildBackground()
	self:BuildContributorList()
	self:BuildDetailsPanel()

	if CONTRIBUTORS[1] ~= nil then
		self:SelectContributor(CONTRIBUTORS[1], self.contributor_grid.items[1].cell_root)
	end
end)

function ContributorsWidget:BuildBackground()
	self.background_root = self.root:AddChild(Widget("background_root"))

	AddImage(self.background_root, "background", 0, 30, nil, 1.20, 1.20)
	AddImage(self.background_root, "line_break", -190, 260, nil, 0.70, 0.70)

	local title = self.background_root:AddChild(Text(HEADERFONT, 40, STRINGS.CONTRIBUTORS.TITLE, UICOLOURS.BLACK))

	title:SetPosition(-190, 285)
	title:SetScale(1.10, 1.10)

	local description1 = self.background_root:AddChild(Text(HEADERFONT, 20, "", UICOLOURS.BLACK))

	description1:SetPosition(-190, 225)
	description1:SetRegionSize(430, 45)
	description1:SetHAlign(ANCHOR_MIDDLE)
	description1:SetVAlign(ANCHOR_MIDDLE)
	description1:EnableWordWrap(true)
	description1:EnableWhitespaceWrap(true)
	description1:SetMultilineTruncatedString(STRINGS.CONTRIBUTORS.DESCRIPTION1, 2, 430, nil, false)

	self.search_box = self.background_root:AddChild(self:MakeSearchBox(320, 40))
	self.search_box:SetPosition(-190, 190)
	self.search_box:SetScale(0.85, 0.85)

	local hyperlink = self.background_root:AddChild(TextButton("images/ui.xml", "blank.tex", "blank.tex", "blank.tex", "blank.tex"))

	hyperlink:SetPosition(-190, -232) -- 182
	hyperlink:SetScale(1, 1)
	hyperlink:SetFont(HEADERFONT)
	hyperlink:SetText(STRINGS.CONTRIBUTORS.HYPERLINK)
	hyperlink:SetTextColour(UICOLOURS.BLACK)
	hyperlink:SetTextFocusColour(UICOLOURS.BLACK)
	hyperlink:SetTextSize(20)

	local function UpdateButtonSize()
		local width, height = hyperlink.text:GetRegionSize()
		hyperlink.image:SetSize(width * 0.98, height)
	end

	UpdateButtonSize()

	hyperlink:SetOnGainFocus(function()
		hyperlink.text:SetSize(21)
		UpdateButtonSize()
	end)

	hyperlink:SetOnLoseFocus(function()
		hyperlink.text:SetSize(20)
		UpdateButtonSize()
	end)

	hyperlink:SetOnClick(function()
		VisitURL("https://heap-of-foods.com/contributors", false)
	end)

	self.glossary_button = self.background_root:AddChild(ImageButton(BG_ATLAS, "glossary.tex"))
	self.glossary_button:SetPosition(-415, 290)
	self.glossary_button:SetScale(0.50, 0.50)
	self.glossary_button:SetHoverText(STRINGS.CONTRIBUTORS.GLOSSARY)

	self.glossary_button:SetOnClick(function()
		if self.glossary_widget == nil then
			self.glossary_widget = self.root:AddChild(ContributorsGlossaryWidget())
		end

		self.glossary_widget:Show()
	end)

	self.details_background = self.background_root:AddChild(Image(BG_ATLAS, "background_card.tex"))
	self.details_background:SetPosition(240, 30)
	self.details_background:SetScale(0.75, 0.75)
end

function ContributorsWidget:MakeSearchBox(box_width, box_height)
	local searchbox = Widget("search")

	-- searchbox:SetHoverText(STRINGS.CONTRIBUTORS.SEARCH, { offset_y = 30, attach_to_parent = self })

	searchbox.textbox_root = searchbox:AddChild(TEMPLATES.StandardSingleLineTextEntry(nil, box_width, box_height))
	searchbox.textbox = searchbox.textbox_root.textbox

	local bg = searchbox.textbox_root.textbox_bg
	bg:SetTexture(BG_ATLAS, "searchbox.tex")

	searchbox.textbox:SetTextLengthLimit(200)
	searchbox.textbox:SetForceEdit(true)
	searchbox.textbox:EnableWordWrap(false)
	searchbox.textbox:EnableScrollEditWindow(true)
	searchbox.textbox:SetHelpTextEdit("")
	searchbox.textbox:SetHelpTextApply(STRINGS.CONTRIBUTORS.SEARCH)
	searchbox.textbox:SetTextPrompt(STRINGS.CONTRIBUTORS.SEARCH, UICOLOURS.GREY)
	searchbox.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)

	searchbox.textbox.OnTextInputted = function()
		self:SetContributorSearch(searchbox.textbox:GetString())
	end

	local _OnRawKey = searchbox.textbox.OnRawKey

	searchbox.textbox.OnRawKey = function(textbox, key, down)
		if down and key == KEY_ESCAPE then
			textbox:SetString("")
			self:SetContributorSearch("")

			return true
		end

		if _OnRawKey ~= nil then
			return _OnRawKey(textbox, key, down)
		end
	end

	searchbox.textbox:SetFocusedImage(bg, BG_ATLAS, "searchbox.tex", "searchbox_hover.tex", "searchbox.tex")

	searchbox:SetOnGainFocus(function()
		searchbox.textbox:OnGainFocus()
		searchbox.textbox.prompt:SetColour(unpack(UICOLOURS.BLACK))
	end)

	searchbox:SetOnLoseFocus(function()
		searchbox.textbox:OnLoseFocus()
		searchbox.textbox.prompt:SetColour(unpack(UICOLOURS.GREY))
	end)

	searchbox.focus_forward = searchbox.textbox

	return searchbox
end

function ContributorsWidget:SetContributorSearch(search_text)
	search_text = string.lower(TrimString(search_text))

	self.search_text = search_text
	self.filtered_contributors = {}

	for _, data in ipairs(CONTRIBUTORS) do
		if search_text == "" or string.find(string.lower(data.name), search_text, 1, true) ~= nil then
			table.insert(self.filtered_contributors, data)
		end
	end

	self.contributor_grid:SetItemsData(self.filtered_contributors)
	self.contributor_grid:RefreshView()

	if #self.filtered_contributors == 0 then
		self.contributor_grid:Hide()
		self.no_results_msg:Show()
	else
		self.contributor_grid:Show()
		self.no_results_msg:Hide()
	end
end

function ContributorsWidget:BuildContributorList()
	self.list_root = self.root:AddChild(Widget("list_root"))
	self.list_root:SetPosition(-190, -20)
	self.list_root:SetScale(0.80, 0.80)

	local cell_width = 90
	local cell_height = 90

	local function ScrollWidgetsCtor(context, index)
		local widget = Widget("contributor_cell_" .. index)

		local initial_data = CONTRIBUTORS[1]

		widget.cell_root = widget:AddChild(ImageButton(ICON_ATLAS, initial_data ~= nil and initial_data.icon))
		widget.cell_root:SetScale(0.80, 0.80)

		widget.focus_forward = widget.cell_root

		widget.cell_root.ongainfocusfn = function()
			self.contributor_grid:OnWidgetFocus(widget)

			widget.cell_root.text:SetScale(1.10, 1.10)
		end

		widget.cell_root.onlosefocusfn = function()
			if widget.data == self.selected_contributor then
				widget.cell_root.text:SetScale(1.10, 1.10)
			else
				widget.cell_root.text:SetScale(0.90, 0.90)
			end
		end

		widget.cell_root:SetOnClick(function()
			if widget.data ~= nil then
				self:SelectContributor(widget.data, widget.cell_root)
			end
		end)

		return widget
	end

	local function ScrollWidgetSetData(context, widget, data, index)
		widget.data = data

		if data ~= nil then
			widget.cell_root:Show()
			widget.cell_root:Enable()

			widget.cell_root:SetTextures(ICON_ATLAS, data.icon)
			widget.cell_root:SetText("")
			widget.cell_root:SetHoverText(data.name, { offset_y = 60 })

			if data == self.selected_contributor then
				widget.cell_root:Select()
				widget.cell_root.text:SetScale(1.10, 1.10)
			else
				widget.cell_root:Unselect()
				widget.cell_root.text:SetScale(0.90, 0.90)
			end
		else
			widget.cell_root:Hide()
			widget.cell_root:Disable()
		end
	end

	self.contributor_grid = TEMPLATES.ScrollingGrid({},
		{
			context = {},

			widget_width = cell_width,
			widget_height = cell_height,

			force_peek = true,
			num_visible_rows = 5,
			num_columns = 5,

			item_ctor_fn = ScrollWidgetsCtor,
			apply_fn = ScrollWidgetSetData,

			scrollbar_offset = 20,
			scrollbar_height_offset = -60,
		}
	)

	self.contributor_grid.up_button:SetTextures(BG_ATLAS, "arrow_scroll_up_hover.tex")
	self.contributor_grid.up_button:SetScale(0.5)

	self.contributor_grid.down_button:SetTextures(BG_ATLAS, "arrow_scroll_down_hover.tex")
	self.contributor_grid.down_button:SetScale(0.5)

	self.contributor_grid.scroll_bar_line:SetTexture(BG_ATLAS, "scroll_bar.tex")
	self.contributor_grid.scroll_bar_line:SetScale(.96)

	self.contributor_grid.position_marker:SetTextures(BG_ATLAS, "scroll_bar_handle.tex")
	self.contributor_grid.position_marker.image:SetTexture(BG_ATLAS, "scroll_bar_handle.tex")
	self.contributor_grid.position_marker:SetScale(.6)

	self.list_root:AddChild(self.contributor_grid)
	self.contributor_grid:SetScale(1, 1)

	self.no_results_msg = self.list_root:AddChild(Text(HEADERFONT, 24, STRINGS.CONTRIBUTORS.NO_RESULTS, UICOLOURS.BLACK))

	self.no_results_msg:SetPosition(0, 0)
	self.no_results_msg:SetRegionSize(430, 50)
	self.no_results_msg:SetHAlign(ANCHOR_MIDDLE)
	self.no_results_msg:SetVAlign(ANCHOR_MIDDLE)
	self.no_results_msg:Hide()

	AddImage(self.list_root, "line_long", 0,  235, nil,  0.90,  0.90)
	AddImage(self.list_root, "line_long", 0, -237, nil, -0.90, -0.90)

	self.contributor_grid:SetItemsData(self.filtered_contributors)
	self.contributor_grid:RefreshView()
end

function ContributorsWidget:BuildDetailsPanel()
	self.details_decor_root = self.root:AddChild(Widget("details_decor_root"))
	self.details_decor_root:SetPosition(240, 30)

	self.details_root = self.root:AddChild(Widget("details_root"))
	self.details_root:SetPosition(240, 30)
end

function ContributorsWidget:SelectContributor(data, button)
	if data == nil then
		return
	end

	self.selected_contributor = data

	if self.contributor_grid ~= nil then
		self.contributor_grid:RefreshView()
	end

	self:PopulateContributorDetails(data)
end

function ContributorsWidget:PopulateContributorDetails(data)
	self.details_decor_root:KillAllChildren()
	self.details_root:KillAllChildren()

	local has_special_badges = data.specialbadges ~= nil

	AddImage(self.details_decor_root, "line_break", 0,  215, nil, 0.80, 0.80)

	if has_special_badges then
		AddImage(self.details_decor_root, "line_short", 0,  -25, nil, 0.80, 0.80)
		AddImage(self.details_decor_root, "line_short", 0, -100, nil, 0.80, 0.80)
		AddImage(self.details_decor_root, "line_short", 0, -170, nil, 0.80, 0.80)
	else
		AddImage(self.details_decor_root, "line_short", 0,  -90, nil, 0.80, 0.80)
		AddImage(self.details_decor_root, "line_short", 0, -170, nil, 0.80, 0.80)
	end

	local name = self.details_root:AddChild(Text(HEADERFONT, 40, data.name, UICOLOURS.BLACK))

	name:SetPosition(0, 240)
	name:SetScale(1.10, 1.10)

	self:BuildContributorPortrait(data)
	self:BuildContributorBadges(data)
	self:BuildContributorSpecialBadges(data)
	self:BuildFavoriteFoods(data)
end

function ContributorsWidget:BuildContributorPortrait(data)
	local config = data.puppet or {}

	local has_special_badges = data.specialbadges ~= nil

	self.puppet_root = self.details_root:AddChild(Widget("puppet_root"))

	self.portrait = self.puppet_root:AddChild(PlayerAvatarPortrait())
	self.portrait:SetScale(has_special_badges and 0.90 or 1.15, has_special_badges and 0.90 or 1.15)
	self.portrait:SetPosition(0, has_special_badges and 95 or 65)

	self.portrait:HideHoverText()
	self.portrait:AlwaysHideRankBadge()

	self.portrait:SetCustomSkins(config.prefab or "wilson", config.base_skin or (config.prefab or "wilson").."_none",
	config.clothing or { body = nil, hand = nil, legs = nil, feet = nil }, true, config.skinmode, config.monkey_curse)

	if config.prefab == "wagstaff" then
		self.portrait.puppet.animstate:OverrideSymbol("face", "wagstaff_face_swap", "face")
		self.portrait.puppet.animstate:OverrideSymbol("swap_hat", "hat_gogglesnormal", "swap_hat")
	end

	if config.portrait ~= nil then
		self.portrait:SetBackground(config.portrait)
	else
		self.portrait:ClearBackground()
	end

	self.puppet_emotes = config.emotes or {}
	self.puppet_emote_interval = config.emote_interval or { 15, 30 }

	if #self.puppet_emotes > 0 then
		local emote = self.puppet_emotes[math.random(#self.puppet_emotes)]
		self.portrait.puppet:DoEmote(emote, false, true)

		self.puppet_emote_timer = math.random(self.puppet_emote_interval[1], self.puppet_emote_interval[2])
	else
		self.puppet_emote_timer = nil
	end

	self:StartUpdating()
end

function ContributorsWidget:BuildContributorBadges(data)
	if data.badges == nil then
		return
	end

	local has_special_badges = data.specialbadges ~= nil

	local badge_root = self.details_root:AddChild(Widget("badge_root"))
	badge_root:SetScale(has_special_badges and 0.70 or 0.80, has_special_badges and 0.70 or 0.80)

	local badge_name = self.details_root:AddChild(Text(HEADERFONT, has_special_badges and 20 or 20, STRINGS.CONTRIBUTORS.BADGES.TITLE, UICOLOURS.BLACK))
	badge_name:SetPosition(0, has_special_badges and -12 or -76)

	local spacing = has_special_badges and 55 or 60
	local count = #data.badges
	local start_x = -((count - 1) * spacing) / 2

	for i, badge in ipairs(data.badges) do
		local atlas = type(badge) == "table" and badge.atlas or BG_ATLAS
		local name = type(badge) == "table" and badge.name or badge

		local is_translator = name:match("^loc_") ~= nil
		local texture = type(badge) == "table" and badge.texture or (is_translator and "badge_translator" or "badge_"..name)

		if texture ~= nil then
			local image = badge_root:AddChild(Image(atlas, texture:match("%.tex$") and texture or texture..".tex"))

			image:SetPosition(start_x + (i - 1) * spacing, has_special_badges and -70 or -150)
			image:SetScale(has_special_badges and 0.45 or 0.50, has_special_badges and 0.45 or 0.50)

			local hover = STRINGS.CONTRIBUTORS.BADGES[string.upper(name)] or name
			image:SetHoverText(hover)
		end
	end
end

function ContributorsWidget:BuildContributorSpecialBadges(data)
	if data.specialbadges == nil then
		return
	end

	local badge_root = self.details_root:AddChild(Widget("special_badge_root"))
	badge_root:SetScale(0.70, 0.70)

	local badge_name = self.details_root:AddChild(Text(HEADERFONT, 20, STRINGS.CONTRIBUTORS.BADGES.TITLE_SPECIAL, UICOLOURS.BLACK))
	badge_name:SetPosition(0, -87)

	local spacing = 55
	local count = #data.specialbadges
	local start_x = -((count - 1) * spacing) / 2

	for i, badge in ipairs(data.specialbadges) do
		local atlas = type(badge) == "table" and badge.atlas or BG_ATLAS
		local name = type(badge) == "table" and badge.name or badge

		local is_translator = name:match("^loc_") ~= nil
		local texture = type(badge) == "table" and badge.texture or (is_translator and "badge_translator" or "badge_"..name)

		if texture ~= nil then
			local image = badge_root:AddChild(Image(atlas, texture:match("%.tex$") and texture or texture..".tex"))

			image:SetPosition(start_x + (i - 1) * spacing, -177)
			image:SetScale(0.45, 0.45)

			local hover = STRINGS.CONTRIBUTORS.BADGES[string.upper(name)] or name
			image:SetHoverText(hover)
		end
	end
end

function ContributorsWidget:BuildFavoriteFoods(data)
	if data.favoritefoods == nil then
		return
	end

	local has_special_badges = data.specialbadges ~= nil

	local food_root = self.details_root:AddChild(Widget("food_root"))
	food_root:SetScale(has_special_badges and 0.80 or 0.80, has_special_badges and 0.80 or 0.80)

	local food_name = self.details_root:AddChild(Text(HEADERFONT, 20, STRINGS.CONTRIBUTORS.FAVORITEFOODS, UICOLOURS.BLACK))

	food_name:SetPosition(0, has_special_badges and -160 or -160)
	food_name:SetScale(1.10, 1.10)

	local spacing = 67 -- DO NOT...
	local count = #data.favoritefoods
	local start_x = -((count - 1) * spacing) / 2

	for i, food in ipairs(data.favoritefoods) do
		local atlas
		local texture

		if type(food) == "table" then
			atlas = food.atlas
			texture = food.texture
		else
			texture = food..".tex"
			atlas = GetInventoryItemAtlas(texture, true)
		end

		if atlas ~= nil and texture ~= nil then
			local image = food_root:AddChild(Image(atlas, texture))

			image:SetPosition(start_x + (i - 1) * spacing, -295)
			image:SetScale(0.80, 0.80)

			local name = texture:gsub("%.tex$", "")
			image:SetHoverText(STRINGS.NAMES[string.upper(name)] or name)
		end
	end
end

function ContributorsWidget:OnUpdate(dt)
	if self.portrait == nil or self.portrait.puppet == nil then
		return
	end

	local puppet = self.portrait.puppet

	self.portrait:EmoteUpdate(dt)

	if self.puppet_emote_timer ~= nil then
		self.puppet_emote_timer = self.puppet_emote_timer - dt

		if self.puppet_emote_timer <= 0 then
			if puppet.animstate:IsCurrentAnimation("idle_loop") then
				local emote = self.puppet_emotes[math.random(#self.puppet_emotes)]
				puppet:DoEmote(emote, false, true)
			end

			self.puppet_emote_timer = math.random(self.puppet_emote_interval[1], self.puppet_emote_interval[2])
		end
	end
end

return ContributorsWidget