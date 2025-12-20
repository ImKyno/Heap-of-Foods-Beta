local Image              = require("widgets/image")
local ImageButton        = require("widgets/imagebutton")
local Text               = require("widgets/text")
local UIAnim             = require("widgets/uianim")
local Widget             = require("widgets/widget")
local TEMPLATES          = require("widgets/redux/templates")

local FISH_REGISTRY_DEFS = require("prefabs/k_fish_registry_defs").FISH_REGISTRY_DEFS
local FISH_SORT_ORDER    = require("prefabs/k_fish_registry_defs").FISH_SORT_ORDER

local FISHREGISTRY_ATLAS = "images/fishregistryimages/hof_fishregistryimages.xml"

local PHASE_ICONS        =
{
	day                  = { atlas = FISHREGISTRY_ATLAS, image = "phase_day.tex"          },
	dusk                 = { atlas = FISHREGISTRY_ATLAS, image = "phase_dusk.tex"         },
	night                = { atlas = FISHREGISTRY_ATLAS, image = "phase_night.tex"        },
}

local MOONPHASE_ICONS    =
{
	new                  = { atlas = FISHREGISTRY_ATLAS, image = "moon_new.tex"           },
	quarter              = { atlas = FISHREGISTRY_ATLAS, image = "moon_quarter.tex"       },
	half                 = { atlas = FISHREGISTRY_ATLAS, image = "moon_half.tex"          },
	threequarter         = { atlas = FISHREGISTRY_ATLAS, image = "moon_three_quarter.tex" },
	full                 = { atlas = FISHREGISTRY_ATLAS, image = "moon_full.tex"          },
}

local SEASON_ICONS       =
{
	autumn               = { atlas = FISHREGISTRY_ATLAS, image = "season_autumn.tex"      },
	winter               = { atlas = FISHREGISTRY_ATLAS, image = "season_winter.tex"      },
	spring               = { atlas = FISHREGISTRY_ATLAS, image = "season_spring.tex"      },
	summer               = { atlas = FISHREGISTRY_ATLAS, image = "season_summer.tex"      },
}

local WORLD_ICONS        =
{
	forest               = { atlas = FISHREGISTRY_ATLAS, image = "world_forest.tex"       },
	cave                 = { atlas = FISHREGISTRY_ATLAS, image = "world_cave.tex",        },
}

local FishRegistryPage = Class(Widget, function(self, parent_widget)
	Widget._ctor(self, "FishRegistryPage")

	self.parent_widget = parent_widget
	
	self.root = self:AddChild(Widget("root"))
	self.backdrop = self.root:AddChild(Image(FISHREGISTRY_ATLAS, "backdrop.tex"))

	self.fish_grid = self.root:AddChild(self:BuildFishScrollGrid())
	self.fish_grid:SetPosition(-15, 0)

	local fish_grid_data = {}
	
	for _, fish in ipairs(FISH_SORT_ORDER) do
		local def = FISH_REGISTRY_DEFS[fish]
		
		if def then
			table.insert(fish_grid_data, { fish = fish, def = def })
		end
	end

	self.fish_grid:SetItemsData(fish_grid_data)
	self.parent_default_focus = self.fish_grid
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

function FishRegistryPage:BuildFishScrollGrid()
	local row_w           = 160
	local row_h           = 230
	local row_spacing     = 2
	
	local item_size       = 48
	local width_label     = 100
	local height          = 25
	
	local font            = HEADERFONT
	local font_size       = 15

	local fish_icon_size  = 64
	local small_icon_size = 24
	local icon_spacing    = 26

	local function ScrollWidgetsCtor(context, index)
		local w = Widget("fish-cell-"..index)
		w.cell_root = w:AddChild(Image(FISHREGISTRY_ATLAS, "fish_entry.tex"))
		
		w.focus_forward = w.cell_root

		w.cell_root.ongainfocusfn = function()
			self.fish_grid:OnWidgetFocus(w)
		end
		
		w.fish_seperator = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "fish_entry_seperator.tex"))
		w.fish_seperator:SetPosition(0, 75)

		local _OnGainFocus = w.cell_root.OnGainFocus
		
        function w.cell_root.OnGainFocus()
			_OnGainFocus(w.cell_root)
			
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
			
			w.fish_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			w.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_focus.tex")
			w.fish_seperator:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_seperator_focus.tex")
		end

		local _OnLoseFocus = w.cell_root.OnLoseFocus
		
		function w.cell_root.OnLoseFocus()
			_OnLoseFocus(w.cell_root)
			
			if w.data and TheFishRegistry:KnowsFish(w.data.fish) then
				w.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_active.tex")
				w.fish_seperator:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_seperator_active.tex")
				w.fish_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
			else
				w.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry.tex")
				w.fish_seperator:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_seperator.tex")
				w.fish_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			end
		end
		
		w.fish_label = w.cell_root:AddChild(Text(font, font_size))
		w.fish_label:SetPosition(0, 93)
		w.fish_label:SetHAlign(ANCHOR_MIDDLE)
		w.fish_label:SetVAlign(ANCHOR_MIDDLE)

		w.fish_anim = w.cell_root:AddChild(UIAnim())
		-- Scale and Position is defined below.

		w.phase_icons  = {}
		w.moon_icons   = {}
		w.season_icons = {}
		w.world_icons  = {}
		
		w.phase_root = w.cell_root:AddChild(Widget("phases"))
		w.phase_root:SetPosition(0, 12)
		w.phase_line = MakeDetailsLine(w.cell_root, 0, 25, 0.4)
		
		w.moon_root = w.cell_root:AddChild(Widget("moonphases"))
		w.moon_root:SetPosition(0, -22)
		w.moon_line = MakeDetailsLine(w.cell_root, 0, -5, 0.4)

		w.season_root = w.cell_root:AddChild(Widget("seasons"))
		w.season_root:SetPosition(0, -56)
		w.season_line = MakeDetailsLine(w.cell_root, 0, -40, 0.4)

		w.world_root = w.cell_root:AddChild(Widget("worlds"))
		w.world_root:SetPosition(0, -92)
		w.world_line = MakeDetailsLine(w.cell_root, 0, -74, 0.4)

		w.locked_icon = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "locked.tex"))
		w.locked_icon:SetScale(0.5)
		w.locked_icon:SetPosition(0, -10)

		return w
	end

	local function BuildIconRow(root, icons, list, icon_map)
		for i = #icons, 1, -1 do
			if icons[i] ~= nil then
				icons[i]:Kill()
				icons[i] = nil
			end
		end

		if not list or not icon_map then
			return
		end

		local count = #list
		
		if count <= 0 then
			return
		end

		local start_x = -(count - 1) * icon_spacing * 0.5

		for i, id in ipairs(list) do
			local icondef = icon_map[id]
			
			if icondef ~= nil then
				local img = root:AddChild(Image(icondef.atlas, icondef.image))
			
				img:ScaleToSize(small_icon_size, small_icon_size)
				img:SetPosition(start_x + (i - 1) * icon_spacing, 0)
				table.insert(icons, img)
			else
				print("Heap of Foods Mod - Fish Registry: Missing icon for id:", id)
			end
		end
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
			widget.phase_line,
			widget.moon_line,
			widget.season_line,
			widget.world_line,
		}

		local known = TheFishRegistry:KnowsFish(data.fish)
		
		local fish_label_str = TheFishRegistry:KnowsFish(data.fish)
		and STRINGS.NAMES[data.def.name] or STRINGS.FISHREGISTRY.MYSTERY_FISH
		
		widget.fish_label:SetMultilineTruncatedString(fish_label_str, 2, width_label)

		if fish_label_str == STRINGS.FISHREGISTRY.MYSTERY_FISH then
			widget.fish_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
		else
			widget.fish_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		end

		if known then
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_active.tex")
			
			if data.def.bank ~= nil and data.def.build ~= nil and data.def.anim ~= nil then
				widget.fish_anim:SetScale(data.def.scale)
				widget.fish_anim:SetPosition(data.def.xpos, data.def.ypos)
				
				widget.fish_anim:GetAnimState():SetBank(data.def.build)
				widget.fish_anim:GetAnimState():SetBuild(data.def.build)
				widget.fish_anim:GetAnimState():PushAnimation(data.def.anim, false)
				widget.fish_anim:GetAnimState():Pause()
				-- widget.fish_anim:GetAnimState():SetBankAndPlayAnimation(data.def.bank, data.def.anim, false)

				widget.fish_anim:Show()
			else
				print("Heap of Foods Mod - Fish Registry: Missing fish anim data for", data.fish)
				widget.fish_anim:Hide()
			end

			BuildIconRow(widget.phase_root,  widget.phase_icons,  data.def.dayphases,  PHASE_ICONS)
			BuildIconRow(widget.moon_root,   widget.moon_icons,   data.def.moonphases, MOONPHASE_ICONS)
			BuildIconRow(widget.season_root, widget.season_icons, data.def.seasons,    SEASON_ICONS)
			BuildIconRow(widget.world_root,  widget.world_icons,  data.def.worlds,     WORLD_ICONS)
			
			SetDetailsLine(widget.detail_lines, true)

			widget.locked_icon:Hide()
		else
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry.tex")
			widget.fish_anim:Hide()

			BuildIconRow(widget.phase_root,  widget.phase_icons,  nil)
			BuildIconRow(widget.moon_root,   widget.moon_icons,   nil)
			BuildIconRow(widget.season_root, widget.season_icons, nil)
			BuildIconRow(widget.world_root,  widget.world_icons,  nil)
			
			SetDetailsLine(widget.detail_lines, false)

			widget.locked_icon:Show()
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

return FishRegistryPage