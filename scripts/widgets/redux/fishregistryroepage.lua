local Image                         = require("widgets/image")
local ImageButton                   = require("widgets/imagebutton")
local Text                          = require("widgets/text")
local UIAnim                        = require("widgets/uianim")
local Widget                        = require("widgets/widget")
local TEMPLATES                     = require("widgets/redux/templates")

local FISHREGISTRY_ROE_DEFS         = require("hof_fishregistrydefs").FISHREGISTRY_ROE_DEFS
local ROE_SORT_ORDER                = require("hof_fishregistrydefs").ROE_SORT_ORDER

local FISHREGISTRY_ATLAS            = "images/hof_fishregistry.xml"

local FishRegistryRoePage = Class(Widget, function(self, parent_widget)
	Widget._ctor(self, "FishRegistryRoePage")

	self.parent_widget = parent_widget
	
	self.root = self:AddChild(Widget("root"))
	-- self.backdrop = self.root:AddChild(Image(FISHREGISTRY_ATLAS, "backdrop.tex"))

	self.roe_grid = self.root:AddChild(self:BuildRoeScrollGrid())
	self.roe_grid:SetPosition(-15, 0)

	local roe_grid_data = {}
	
	for _, roe in ipairs(ROE_SORT_ORDER) do
		local def = FISHREGISTRY_ROE_DEFS[roe]
		
		if def then
			table.insert(roe_grid_data, { roe = roe, def = def })
		end
	end

	self.roe_grid:SetItemsData(roe_grid_data)
	self.parent_default_focus = self.roe_grid
end)

local function MakeDetailsLine(root, x, y, scale, image_override)
	local value_title_line = root:AddChild(Image(FISHREGISTRY_ATLAS, image_override or "details_line.tex"))
	
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
	
	return value_title_line
end

local function SetDetailsLine(list, visible)
	for _, v in ipairs(list) do
		if visible then
			v:Show()
		else
			v:Hide()
		end
	end
end

function FishRegistryRoePage:BuildRoeScrollGrid()
	local row_w           = 160
	local row_h           = 230
	local row_spacing     = 2
	
	local item_size       = 48
	local width_label     = 100
	local height          = 25
	
	local font            = HEADERFONT
	local font_size       = 15

	local roe_icon_size   = 64
	local small_icon_size = 24
	local icon_spacing    = 26

	local function ScrollWidgetsCtor(context, index)
		local w = Widget("roe-cell-"..index)
		w.cell_root = w:AddChild(Image(FISHREGISTRY_ATLAS, "fish_entry.tex"))
		
		w.focus_forward = w.cell_root

		w.cell_root.ongainfocusfn = function()
			self.roe_grid:OnWidgetFocus(w)
		end
		
		w.roe_seperator = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "fish_entry_seperator.tex"))
		w.roe_seperator:SetPosition(0, 75)
		
		w.roe_label = w.cell_root:AddChild(Text(font, font_size))
		w.roe_label:SetPosition(0, 93)
		w.roe_label:SetHAlign(ANCHOR_MIDDLE)
		w.roe_label:SetVAlign(ANCHOR_MIDDLE)
		
		w.roe_image = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "missing.tex"))
		w.roe_image:SetPosition(0, 40)
		w.roe_image:ScaleToSize(110, 110)
		w.roe_image:Hide()

		w.sep_top = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "details_line.tex"))
		w.sep_top:SetPosition(0, 6)
		w.sep_top:SetScale(0.4)

		w.roe_time_title = w.cell_root:AddChild(Text(HEADERFONT, 16, STRINGS.FISHREGISTRY.ROE_TIME, PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
		w.roe_time_title:SetPosition(0, -12)

		w.roe_time_text = w.cell_root:AddChild(Text(HEADERFONT, 20, nil, PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN))
		w.roe_time_text:SetPosition(0, -30)

		w.sep_bottom = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "details_line.tex"))
		w.sep_bottom:SetPosition(0, -50)
		w.sep_bottom:SetScale(0.4)

		w.baby_time_title = w.cell_root:AddChild(Text(HEADERFONT, 16, STRINGS.FISHREGISTRY.BABY_TIME, PLANTREGISTRYUICOLOURS.LOCKEDBROWN))
		w.baby_time_title:SetPosition(0, -68)

		w.baby_time_text = w.cell_root:AddChild(Text(HEADERFONT, 20, nil, PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN))
		w.baby_time_text:SetPosition(0, -85)

		w.locked_icon = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "locked.tex"))
		w.locked_icon:SetScale(0.5)
		w.locked_icon:SetPosition(0, -10)

		return w
	end

	local function ScrollWidgetSetData(context, widget, data, index)
		if not data then
			widget.cell_root:Hide()
			return
		end
		
		widget.cell_root:Show()
		widget.data = data
		
		widget.detail_lines =
		{
			widget.sep_top,
			widget.sep_bottom,
			
			widget.roe_time_text,
			widget.baby_time_text,

			widget.roe_time_title,
			widget.baby_time_title,
		}

		local roe_label_str = TheFishRegistry:KnowsRoe(data.roe)
		and STRINGS.NAMES[data.def.name] or STRINGS.FISHREGISTRY.MYSTERY_ROE
		
		widget.roe_label:SetMultilineTruncatedString(roe_label_str, 2, width_label)
		widget.roe_label:SetColour(roe_label_str == STRINGS.FISHREGISTRY.MYSTERY_ROE and PLANTREGISTRYUICOLOURS.LOCKEDBROWN or PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)

		if TheFishRegistry:KnowsRoe(data.roe) then
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_active.tex", "fish_entry_focus.tex")
			widget.locked_icon:Hide()
			
			if data.def.atlas and data.def.image then
				widget.roe_image:Show()
			
				local atlas = data.def.atlas or GetInventoryItemAtlas(data.def.image)
				widget.roe_image:SetTexture(atlas, data.def.image..".tex")
			
				-- If no custom string is found, it will automatically calculate roe and baby times.
				widget.roe_time_text:SetString(data.def.roe_string or FishRegistryGetRoeTimeString(data.def.roe_time))
				widget.baby_time_text:SetString(data.def.baby_string or FishRegistryGetBabyTimeString(data.def.baby_time))
			else
				widget.roe_image:Hide()
			end

			SetDetailsLine(widget.detail_lines, true)
		else
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry.tex")
			
			widget.roe_image:Hide()
			widget.locked_icon:Show()

			SetDetailsLine(widget.detail_lines, false)
		end
	end

	local grid = TEMPLATES.ScrollingGrid(
		{},
		{
			context                 = {},
			widget_width            = row_w + row_spacing,
			widget_height           = row_h + row_spacing,
			
			force_peek              = true,
			num_visible_rows        = 2,
			num_columns             = 5,
			
			item_ctor_fn            = ScrollWidgetsCtor,
			apply_fn                = ScrollWidgetSetData,
			
			scrollbar_offset        = 15,
			scrollbar_height_offset = -60,
			
			peek_percent            = 30 / (row_h + row_spacing),
			end_offset              = math.abs(1 - 5 / (row_h + row_spacing)),
        }
    )

	grid.up_button:SetTextures(FISHREGISTRY_ATLAS, "fishregistry_recipe_scroll_arrow.tex")
	grid.up_button:SetScale(0.5)

	grid.down_button:SetTextures(FISHREGISTRY_ATLAS, "fishregistry_recipe_scroll_arrow.tex")
	grid.down_button:SetScale(-0.5)

	grid.scroll_bar_line:SetTexture(FISHREGISTRY_ATLAS, "fishregistry_recipe_scroll_bar.tex")
	grid.scroll_bar_line:SetScale(.8)

	grid.position_marker:SetTextures(FISHREGISTRY_ATLAS, "fishregistry_recipe_scroll_handle.tex")
	grid.position_marker.image:SetTexture(FISHREGISTRY_ATLAS, "fishregistry_recipe_scroll_handle.tex")
	grid.position_marker:SetScale(.6)

	return grid
end

return FishRegistryRoePage