return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 8,
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
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 4, 1, 4, 2, 1, 1, 1,
        1, 4, 4, 4, 2, 3, 1, 1,
        1, 2, 2, 2, 2, 3, 3, 1,
        1, 1, 4, 4, 2, 2, 2, 1,
        1, 4, 4, 2, 2, 3, 3, 1,
        1, 1, 4, 4, 2, 3, 3, 1,
        1, 1, 1, 1, 1, 1, 1, 1
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
          x = 416,
          y = 231,
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
          x = 344,
          y = 159,
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
          x = 351,
          y = 223,
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
          x = 395,
          y = 178,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "catcoonden",
          shape = "rectangle",
          x = 223,
          y = 161,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_deciduousforest_shop",
          shape = "rectangle",
          x = 224,
          y = 287,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 163,
          y = 168,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 223,
          y = 105,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 123,
          y = 111,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 113,
          y = 304,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 89,
          y = 414,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 138,
          y = 275,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 243,
          y = 395,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 133,
          y = 405,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "red_mushroom",
          shape = "rectangle",
          x = 243,
          y = 180,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "red_mushroom",
          shape = "rectangle",
          x = 94,
          y = 168,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "green_mushroom",
          shape = "rectangle",
          x = 342,
          y = 107,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "green_mushroom",
          shape = "rectangle",
          x = 421,
          y = 152,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "blue_mushroom",
          shape = "rectangle",
          x = 188,
          y = 314,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "blue_mushroom",
          shape = "rectangle",
          x = 105,
          y = 365,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 167,
          y = 415,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 193,
          y = 415,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "berrybush2",
          shape = "rectangle",
          x = 218,
          y = 415,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fertilizer",
          shape = "rectangle",
          x = 408,
          y = 199,
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
          x = 381,
          y = 161,
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
          x = 374,
          y = 373,
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
          x = 337,
          y = 373,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 413,
          y = 373,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 374,
          y = 412,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 374,
          y = 336,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 408,
          y = 343,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 343,
          y = 343,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 343,
          y = 406,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_truffles_ground",
          shape = "rectangle",
          x = 408,
          y = 406,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trinket_4",
          shape = "rectangle",
          x = 325,
          y = 249,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "deciduoustree_tall",
          shape = "rectangle",
          x = 399,
          y = 109,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 332,
          y = 440,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 439,
          y = 437,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 443,
          y = 334,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 480,
          y = 167,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 347,
          y = 43,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 177,
          y = 40,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 31,
          y = 167,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 27,
          y = 349,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 93,
          y = 487,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 281,
          y = 475,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 492,
          y = 361,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 393,
          y = 487,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower",
          shape = "rectangle",
          x = 454,
          y = 55,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "meatrack",
          shape = "rectangle",
          x = 160,
          y = 352,
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
          x = 263,
          y = 15,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 33,
          y = 49,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 496,
          y = 491,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 167,
          y = 496,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_radish_ground",
          shape = "rectangle",
          x = 16,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_fruittree_placeholder",
          shape = "rectangle",
          x = 160,
          y = 352,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "kyno_bananatree",
          shape = "rectangle",
          x = 170,
          y = 288,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 243,
          y = 117,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 194,
          y = 182,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 127,
          y = 161,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 97,
          y = 101,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
