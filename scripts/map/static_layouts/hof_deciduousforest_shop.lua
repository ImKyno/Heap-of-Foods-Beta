return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 10,
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
      imageheight = 512,
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
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        1, 1, 4, 1, 4, 2, 1, 1, 1, 1,
        1, 1, 4, 4, 4, 2, 3, 1, 1, 1,
        1, 1, 2, 2, 2, 2, 3, 3, 1, 1,
        1, 1, 1, 4, 4, 2, 2, 2, 1, 1,
        1, 1, 4, 4, 2, 2, 3, 3, 1, 1,
        1, 1, 1, 4, 4, 2, 3, 3, 1, 1,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 0, 0
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
          type = "slow_farmplot",
          shape = "rectangle",
          x = 480,
          y = 295,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.savedrotation.rotation"] = "180",
            ["scenario"] = "random_farmplot"
          }
        },
        {
          name = "",
          type = "slow_farmplot",
          shape = "rectangle",
          x = 408,
          y = 223,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.savedrotation.rotation"] = "90",
            ["scenario"] = "random_farmplot"
          }
        },
        {
          name = "",
          type = "slow_farmplot",
          shape = "rectangle",
          x = 415,
          y = 287,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.savedrotation.rotation"] = "140",
            ["scenario"] = "random_farmplot"
          }
        },
        {
          name = "",
          type = "scarecrow",
          shape = "rectangle",
          x = 459,
          y = 242,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "catcoonden",
          shape = "rectangle",
          x = 287,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_deciduousforest_shop",
          shape = "rectangle",
          x = 288,
          y = 351,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 227,
          y = 232,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 287,
          y = 169,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 187,
          y = 175,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 177,
          y = 368,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 153,
          y = 478,
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
          y = 339,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 307,
          y = 459,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 197,
          y = 469,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "red_mushroom",
          shape = "rectangle",
          x = 307,
          y = 244,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "red_mushroom",
          shape = "rectangle",
          x = 158,
          y = 232,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "green_mushroom",
          shape = "rectangle",
          x = 406,
          y = 171,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "green_mushroom",
          shape = "rectangle",
          x = 485,
          y = 216,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "blue_mushroom",
          shape = "rectangle",
          x = 252,
          y = 378,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "blue_mushroom",
          shape = "rectangle",
          x = 169,
          y = 429,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 231,
          y = 479,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 257,
          y = 479,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 282,
          y = 479,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fertilizer",
          shape = "rectangle",
          x = 472,
          y = 263,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "random_damage"
          }
        },
        {
          name = "",
          type = "shovel",
          shape = "rectangle",
          x = 445,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "random_damage"
          }
        },
        {
          name = "",
          type = "mushroom_farm",
          shape = "rectangle",
          x = 438,
          y = 437,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "mushroom_farm_random"
          }
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 401,
          y = 437,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 477,
          y = 437,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 438,
          y = 476,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 438,
          y = 400,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 472,
          y = 407,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 407,
          y = 407,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 407,
          y = 470,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 472,
          y = 470,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trinket_4",
          shape = "rectangle",
          x = 389,
          y = 313,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 463,
          y = 173,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 396,
          y = 504,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 503,
          y = 501,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 507,
          y = 398,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 544,
          y = 231,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 411,
          y = 107,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 241,
          y = 104,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 95,
          y = 231,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 91,
          y = 413,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 157,
          y = 551,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 345,
          y = 539,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 556,
          y = 425,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 457,
          y = 551,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 518,
          y = 119,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "meatrack",
          shape = "rectangle",
          x = 224,
          y = 416,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "meatrack_random"
          }
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 327,
          y = 79,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 97,
          y = 113,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 560,
          y = 555,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 231,
          y = 560,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 80,
          y = 500,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_fruittree_placeholder",
          shape = "rectangle",
          x = 224,
          y = 416,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_bananatree",
          shape = "rectangle",
          x = 234,
          y = 352,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 307,
          y = 181,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 258,
          y = 246,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 191,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 161,
          y = 165,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
