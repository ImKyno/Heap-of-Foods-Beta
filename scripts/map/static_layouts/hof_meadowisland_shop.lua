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
        0, 1, 1, 1, 0,
        0, 1, 2, 1, 1,
        1, 1, 1, 2, 1,
        1, 3, 1, 1, 1,
        1, 1, 1, 0, 0
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
          x = 224,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 250,
          y = 167,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_wildwheat",
          shape = "rectangle",
          x = 243,
          y = 184,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 223,
          y = 186,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_wildwheat",
          shape = "rectangle",
          x = 248,
          y = 149,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_meadowisland_sammyhouse",
          shape = "rectangle",
          x = 159,
          y = 96,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 116,
          y = 242,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.scenario"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "fertilizer",
          shape = "rectangle",
          x = 38,
          y = 163,
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
          x = 69,
          y = 163,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lightning_rod",
          shape = "rectangle",
          x = 158,
          y = 163,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 96,
          y = 242,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 77,
          y = 242,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 77,
          y = 222,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 96,
          y = 222,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["data.is_oversized"] = "true",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 116,
          y = 222,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 134,
          y = 121,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "mandrake_planted",
          shape = "rectangle",
          x = 132,
          y = 70,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 185,
          y = 71,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 202,
          y = 191,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 254,
          y = 135,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "farm_hoe",
          shape = "rectangle",
          x = 38,
          y = 193,
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
          x = 96,
          y = 202,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 77,
          y = 202,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "farm_plant_kyno_rice",
          shape = "rectangle",
          x = 116,
          y = 202,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.growable.stage"] = "5",
            ["scenario"] = "sammy_farmplot"
          }
        },
        {
          name = "",
          type = "cookingrecipecard",
          shape = "rectangle",
          x = 225,
          y = 94,
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
