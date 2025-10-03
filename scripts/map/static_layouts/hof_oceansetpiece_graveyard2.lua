return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 5,
  height = 5,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../../../Don't Starve Mod Tools/mod_tools/Tiled/dont_starve/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../../../Don't Starve Mod Tools/mod_tools/Tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 384,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "kyno_ocean_wreck",
          shape = "rectangle",
          x = 80,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_ocean_wreck",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_seaweeds_ocean",
          shape = "rectangle",
          x = 232,
          y = 228,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_seaweeds_ocean",
          shape = "rectangle",
          x = 93,
          y = 93,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_swordfish_spawner",
          shape = "rectangle",
          x = 189,
          y = 159,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "seastack",
          shape = "rectangle",
          x = 134,
          y = 287,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "seastack",
          shape = "rectangle",
          x = 284,
          y = 94,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "seastack",
          shape = "rectangle",
          x = 38,
          y = 198,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "seastack",
          shape = "rectangle",
          x = 182,
          y = 38,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "sunkenchest",
          shape = "rectangle",
          x = 166,
          y = 92,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "sunkenchest_curiosities"
          }
        },
        {
          name = "",
          type = "sunkenchest",
          shape = "rectangle",
          x = 84,
          y = 167,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "sunkenchest_fallout"
          }
        }
      }
    }
  }
}
