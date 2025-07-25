return {
  version = "1.1",
  luaversion = "2.1",
  orientation = "orthogonal",
  width = 7,
  height = 7,
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
      imagewidth = 212,
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
      width = 7,
      height = 7,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0,
        0, 0, 2, 2, 2, 0, 0,
        0, 0, 2, 7, 2, 2, 0,
        0, 2, 2, 2, 7, 2, 0,
        0, 2, 7, 2, 2, 2, 0,
        0, 2, 2, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0
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
          type = "kyno_meadowisland_mermcart",
          shape = "rectangle",
          x = 288,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 314,
          y = 231,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_wildwheat",
          shape = "rectangle",
          x = 307,
          y = 248,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 287,
          y = 220,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_wildwheat",
          shape = "rectangle",
          x = 312,
          y = 213,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_meadowisland_sammyhouse",
          shape = "rectangle",
          x = 223,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 180,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "4",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "fertilizer",
          shape = "rectangle",
          x = 102,
          y = 227,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "random_damage"
          }
        },
        {
          name = "",
          type = "plantregistryhat",
          shape = "rectangle",
          x = 133,
          y = 227,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lightning_rod",
          shape = "rectangle",
          x = 222,
          y = 227,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 160,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "4",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 141,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "2",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 141,
          y = 286,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "4",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 160,
          y = 286,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "2",
            ["data.is_oversized"] = "true",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 180,
          y = 286,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "2",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 198,
          y = 182,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "mandrake_planted",
          shape = "rectangle",
          x = 196,
          y = 134,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 249,
          y = 132,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 266,
          y = 222,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 318,
          y = 199,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_hoe",
          shape = "rectangle",
          x = 101,
          y = 227,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "random_damage"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 160,
          y = 266,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "2",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 141,
          y = 266,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "2",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 180,
          y = 266,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "4",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "cookingrecipecard",
          shape = "rectangle",
          x = 289,
          y = 128,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.c"] = "cookpot",
            ["data.r"] = "gorge_carrot_cake"
          }
        }
      }
    }
  }
}
