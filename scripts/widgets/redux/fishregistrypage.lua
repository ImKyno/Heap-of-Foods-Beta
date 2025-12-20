local Image              = require("widgets/image")
local ImageButton        = require("widgets/imagebutton")
local Text               = require("widgets/text")
local UIAnim             = require("widgets/uianim")
local Widget             = require("widgets/widget")
local TEMPLATES          = require("widgets/redux/templates")

local FISH_REGISTRY_DEFS = require("prefabs/k_fish_registry_defs").FISH_REGISTRY_DEFS
local FISH_SORT_ORDER    = require("prefabs/k_fish_registry_defs").FISH_SORT_ORDER

local FISHREGISTRY_ATLAS = "images/fishregistryimages/hof_fishregistryimages.xml"

-- TUNING instead of local function in case someone wants to add their modded fish.
TUNING.FISHREGISTRY_PHASE_IDS       = { "day", "dusk", "night"                                       }
TUNING.FISHREGISTRY_MOONPHASE_IDS   = { "new", "quarter", "half", "threequarter", "full", "glassed"  }
TUNING.FISHREGISTRY_SEASON_IDS      = { "autumn", "winter", "spring", "summer"                       }
TUNING.FISHREGISTRY_WORLD_IDS       = { "forest", "cave"                                             }

TUNING.FISHREGISTRY_PHASE_ICONS     =
{
	day                             = { atlas = FISHREGISTRY_ATLAS, image = "phase_day.tex"          },
	dusk                            = { atlas = FISHREGISTRY_ATLAS, image = "phase_dusk.tex"         },
	night                           = { atlas = FISHREGISTRY_ATLAS, image = "phase_night.tex"        },
}

TUNING.FISHREGISTRY_MOONPHASE_ICONS =
{
	new                             = { atlas = FISHREGISTRY_ATLAS, image = "moon_new.tex"           },
	quarter                         = { atlas = FISHREGISTRY_ATLAS, image = "moon_quarter.tex"       },
	half                            = { atlas = FISHREGISTRY_ATLAS, image = "moon_half.tex"          },
	threequarter                    = { atlas = FISHREGISTRY_ATLAS, image = "moon_three_quarter.tex" },
	full                            = { atlas = FISHREGISTRY_ATLAS, image = "moon_full.tex"          },
	glassed                         = { atlas = FISHREGISTRY_ATLAS, image = "moon_glassed.tex"       },
}

TUNING.FISHREGISTRY_SEASON_ICONS    =
{
	autumn                          = { atlas = FISHREGISTRY_ATLAS, image = "season_autumn.tex"      },
	winter                          = { atlas = FISHREGISTRY_ATLAS, image = "season_winter.tex"      },
	spring                          = { atlas = FISHREGISTRY_ATLAS, image = "season_spring.tex"      },
	summer                          = { atlas = FISHREGISTRY_ATLAS, image = "season_summer.tex"      },
}

TUNING.FISHREGISTRY_WORLD_ICONS     =
{
	forest                          = { atlas = FISHREGISTRY_ATLAS, image = "world_forest.tex"       },
	cave                            = { atlas = FISHREGISTRY_ATLAS, image = "world_cave.tex",        },
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
		
		w.fish_label = w.cell_root:AddChild(Text(font, font_size))
		w.fish_label:SetPosition(0, 93)
		w.fish_label:SetHAlign(ANCHOR_MIDDLE)
		w.fish_label:SetVAlign(ANCHOR_MIDDLE)

		w.fish_anim = w.cell_root:AddChild(UIAnim())
		w.fish_anim:Hide()
		
		w.phase_line  = MakeDetailsLine(w.cell_root, 0, 25, 0.4)
		w.moon_line   = MakeDetailsLine(w.cell_root, 0, -5, 0.4)
		w.season_line = MakeDetailsLine(w.cell_root, 0, -40, 0.4)
		w.world_line  = MakeDetailsLine(w.cell_root, 0, -74, 0.4)

		w.detail_lines = { w.phase_line, w.moon_line, w.season_line, w.world_line }

		local function CreateIcons(root, icon_map, list, icon_type)
			local icons = {}
    
			for i, id in ipairs(list) do
				local icondef = icon_map[id]
				
				if icondef then
					local img = root:AddChild(Image(icondef.atlas, icondef.image))
					
					img:ScaleToSize(small_icon_size, small_icon_size)
					img:Hide()
					
					local key = string.upper(icon_type.."_"..id)
					
					if STRINGS.FISHREGISTRY[key] then
						img:SetHoverText(STRINGS.FISHREGISTRY[key], { offset_y = 35 })
					end
					
					table.insert(icons, {id = id, img = img})
				end
			end
			
			return icons
		end
		
		w.phase_root = w.cell_root:AddChild(Widget("phases"))
		w.phase_root:SetPosition(0, 12)
		w.phase_icons = CreateIcons(w.phase_root, TUNING.FISHREGISTRY_PHASE_ICONS, TUNING.FISHREGISTRY_PHASE_IDS, "phase")

		w.moon_root = w.cell_root:AddChild(Widget("moonphases"))
		w.moon_root:SetPosition(0, -22)
		w.moon_icons = CreateIcons(w.moon_root, TUNING.FISHREGISTRY_MOONPHASE_ICONS, TUNING.FISHREGISTRY_MOONPHASE_IDS, "moonphase")

		w.season_root = w.cell_root:AddChild(Widget("seasons"))
		w.season_root:SetPosition(0, -57)
		w.season_icons = CreateIcons(w.season_root, TUNING.FISHREGISTRY_SEASON_ICONS, TUNING.FISHREGISTRY_SEASON_IDS, "season")

		w.world_root = w.cell_root:AddChild(Widget("worlds"))
		w.world_root:SetPosition(0, -92)
		w.world_icons = CreateIcons(w.world_root, TUNING.FISHREGISTRY_WORLD_ICONS, TUNING.FISHREGISTRY_WORLD_IDS, "world")

		w.locked_icon = w.cell_root:AddChild(Image(FISHREGISTRY_ATLAS, "locked.tex"))
		w.locked_icon:SetScale(0.5)
		w.locked_icon:SetPosition(0, -10)

		return w
	end
	
	local function UpdateIcons(icons, list)
		for i, icon in ipairs(icons) do
			icon.img:Hide()
		end

		if not list or #list == 0 then
			return
		end

		local count = #list
		local spacing = 26
		local start_x = -(count - 1) * spacing * 0.5

		for i, id in ipairs(list) do
			for _, icon in ipairs(icons) do
				if icon.id == id then
					icon.img:SetPosition(start_x + (i - 1) * spacing, 0)
					icon.img:Show()
				end
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

		local fish_label_str = TheFishRegistry:KnowsFish(data.fish)
		and STRINGS.NAMES[data.def.name] or STRINGS.FISHREGISTRY.MYSTERY_FISH
		
		widget.fish_label:SetMultilineTruncatedString(fish_label_str, 2, width_label)
		widget.fish_label:SetColour(fish_label_str == STRINGS.FISHREGISTRY.MYSTERY_FISH and PLANTREGISTRYUICOLOURS.LOCKEDBROWN or PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)

		if TheFishRegistry:KnowsFish(data.fish) then
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry_active.tex", "fish_entry_focus.tex")
			widget.locked_icon:Hide()
			
			if data.def.bank and data.def.build and data.def.anim then
				widget.fish_anim:Show()
                
				widget.fish_anim:SetScale(data.def.scale)
				widget.fish_anim:SetPosition(data.def.xpos, data.def.ypos)
				
				widget.fish_anim:GetAnimState():SetBank(data.def.bank)
				widget.fish_anim:GetAnimState():SetBuild(data.def.build)
				widget.fish_anim:GetAnimState():SetBankAndPlayAnimation(data.def.bank, data.def.anim, false)
				widget.fish_anim:GetAnimState():Pause()
			else
				widget.fish_anim:Hide()
			end

			UpdateIcons(widget.phase_icons,  data.def.phases)
			UpdateIcons(widget.moon_icons,   data.def.moonphases)
			UpdateIcons(widget.season_icons, data.def.seasons)
			UpdateIcons(widget.world_icons,  data.def.worlds)

			SetDetailsLine(widget.detail_lines, true)
		else
			widget.cell_root:SetTexture(FISHREGISTRY_ATLAS, "fish_entry.tex")
			
			widget.fish_anim:Hide()
			widget.locked_icon:Show()

			UpdateIcons(widget.phase_icons,  nil)
			UpdateIcons(widget.moon_icons,   nil)
			UpdateIcons(widget.season_icons, nil)
			UpdateIcons(widget.world_icons,  nil)

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

return FishRegistryPage