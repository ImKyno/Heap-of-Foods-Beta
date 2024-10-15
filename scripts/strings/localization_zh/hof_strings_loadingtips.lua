-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS

-- New Loading Tips and Lore.
local TIPS_LORE 	= LOADING_SCREEN_LORE_TIPS
local TIPS_SURVIVAL = LOADING_SCREEN_SURVIVAL_TIPS
local TIPS_HOF 		= STRINGS.UI.LOADING_SCREEN_OTHER_TIPS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local HOF_CATEGORY 	= _G.LOADING_SCREEN_TIP_CATEGORIES

-- Our Tips.
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE", 			"在击败龙蝇后可以获得咖啡丛。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WEEDS",  			"耕地里长出的杂草可以喂鸟来换取对应的种子。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WALRY",  			"沃利拥有独家食谱。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_JELLYBEANS",      "\"某些糖豆使人精力充沛，让我身体的感觉超级棒！\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INGREDIENTS",   	"游戏中的新食材都可以在烹饪锅中烹饪。即使有些食材看起来很奇怪...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WX78",          	"\"WX-78想用齿轮做一道菜。如果我们有一些不用的，我或许能帮他一把。\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_HUMANMEAT",     	"每当玩家死亡时，有几率掉落一个奇怪的烹饪食材...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALT",          	"盐可以用来恢复食物的变质时间。再也不会失去那道甜美的菜肴了！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_OLDMOD",        	"Heap Of Foods 的第一个版本名为食物包，后因错误而停用。后来，它被重新制作成了这个全新的Mod。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CARAMELCUBE",   	"焦糖方块是Kyno最喜欢的一道菜。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WHEAT",         	"野生小麦可以在碾磨石上磨成面粉。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FLOUR",         	"你可以用面粉制做一个简单的面包。然而，除了面包，面粉还有很多其他用途。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WORMWOOD",      	"\"沃姆伍德说他用...和盐做了一道美食。但是我才不要吃那个，我的天啊！\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGKING",       	"猪王现在可以换取新物品。例如，用草丛换取小麦丛，用浆果丛换取斑点灌木丛。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYISLAND",	"\"我在海里看到了一片粉红色的陆地！或许我的伙伴们会和我一起去探索它...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDER", 		"你可以用各种料理与猪长老交易换取特殊的物品。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABTRAP", 		"\"那些卵石蟹好像避开了我所有设置的陷阱！或许某种特殊的陷阱可以代替它们？\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAPTREE",			"你可以用采集工具来收集糖木树的树液, 每三天收集一次。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_RUINEDSAPTREE",	"小心，长时间未收集的糖木树会生病。反而，会产生变质的树液！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDERFOODS",	"\"我听说那个粉红色小岛上陌生的猪人想要某种食物... 跟焦糖或龙虾有关的东西。\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTPOND",		"你可以在宁静岛上的盐池里钓到不同种类的鱼。试试吧！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTRACK", 		"盐架可安装在盐池上，每四天生产一次盐晶。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPOTTYSHRUB",		"整个宁静群岛都能找到斑点灌木。它们可以用铲子带回家。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SWEETFLOWER",		"甜花可作为甜味剂在烹饪锅中使用。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LIMPETROCK", 		"只有在宁静群岛的卵石蟹附近才能找到帽贝岩！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CHICKEN",			"\"我在想这些鸡能不能给我一些蛋。可能我需要一些种子来引诱它们！\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SYRUPPOT", 		"用糖浆烹饪锅制作糖浆时，会给三份，相反，普通烹饪锅会给一份。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE",		"糖浆烹饪锅、烹饪锅、烧烤炉和烤箱比普通烹饪锅烹饪食物的速度更快。而且它们还能小概率地做出双份食物！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_PIT", 	"要使用特殊炊具站进行烹饪，你需要先将它安装在火坑上。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_FIRE",	"特殊炊具站只有在火坑的火足够旺时才能烹饪食物。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_OLDPOT", "猪长老可能需要你的帮助来修复他的旧锅。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPEED_DURATION",  "你可以在模组配置中更改食物带来的速度buff持续时间。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE",	"\"昨天出海时，我看到一个奇怪的箱子在海上漂着，如果再遇到的话，我应该去查看下。\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYCRATE",	"在宁静岛上钓到的水箱会在七天后在同一位置重新出现。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE2",	"水箱总是会产生海藻和额外的战利品。继续摧毁它们，看看还能发现什么！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN",			"\"金枪鱼罐头\"永远不会变质，除非你打开它。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CANNED_SOURCE",	"你可以从水箱和沉箱中获得罐头和饮料。祝你寻宝愉快！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN_HERMIT",	"如果你完成了寄居蟹奶奶的任务，她可能会给你特别奖励。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABKING_LOOT",	"没有蟹肉了？帝王蟹就是一个可靠的来源。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_REGROWTH",		"植物、树木等模组实体。如果在世界上的数量较少，它们会随着时间的推移而重新生长。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL",		"沃托克斯可以将灵魂储存在空瓶子里，以供日后食用...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL2",	"每个幸存者都可以将灵魂装在瓶子里，但只有沃托克斯可以释放灵魂。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SOULSTEW",		"如果沃托克斯吃了灵魂炖汤，他将获得食物的全部收益，而不像他吃其他食物那样只有一半的收益。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MYSTERYMEAT",		"\"你听说了吗？有一个水箱里有奇怪的东西 我们应该找找看，也许...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_KEGANDJAR",       "精酿桶和罐头瓶可以用来制作特殊食谱。但花费的时间很长。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ANTIDOTE",        "你的糖木树感染了？别担心，它们是可以治愈的！你只需对它们使用腐烂解毒剂就可以了！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MILKABLEANIMALS", "一些动物，比如皮弗娄牛和考拉象，可以用空水桶挤奶。不过要小心！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FORTUNECOOKIE",   "\"你真的相信幸运饼干能告诉你的运气吗? 嗯? W-那我呢?! I-我不相信，我发誓！\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PINEAPPLEBUSH",   "除了夏季，菠萝丛在其他季节都需要很长的生长时间。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BREWBOOK",        "用精酿桶或罐头瓶制作的食物不会出现在食谱中。相反，你可以在酿造手册上查看它们！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIKOS",           "注意异食松鼠！这些小动物喜欢偷东西。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TIDALPOOL",       "潮汐池中有各种鱼类，四季皆可垂钓！请务必带上你的淡水钓竿！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_GROUPER",         "在沼泽的池塘里可以钓到紫色石斑鱼。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MEADOWISLAND",    "\"环游世界，我几乎能够探索一切... 除了一个长满茶树的奇怪小岛\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INFESTTREE",      "茶树可能会受到异食松鼠的侵扰。但你捕获这些小家伙的机会大大增加！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWAREBONUS",   "特殊炊具站在烹饪时有小概率会多出一份食物。我们一起祈祷美味的佳肴不要带来双倍的麻烦！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_POISONBUNWICH",   "毒蛙腿三明治烹饪难度很高，但它食用后带来一份奇特的效果：一整天青蛙都会与你和平相处！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TWISTEDTEQUILE",  "\"昨晚在派对上，我喝了一种酒，好像叫龙舌兰，对吧？让我头晕目眩。结果第二天，我发现自己到了另一个地方\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERCUP",        "想要摆脱你的debuff？喝杯水，补充水分！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA",        "\"看到那瓶... \"核子可乐\", 是这个名字吧？我认为是沃托克斯在他旅行中从另一个空间带回来的。\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA2",       "核子可乐的独特口味是由17种水果精华组合而成的，这些水果精华相互配合造就了可乐的经典口味。消除口渴！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SUGARBOMBS",      "甜麦炮弹是含糖量达到每日推荐量的一种麦片，在第一次大战之后保存了25年。不过，这也导致大部分甜麦炮弹受到了辐射。")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LUNARSOUP",       "\"喝下月牙汤，我无所畏惧！\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPRINKLER",       "厌倦了手动浇灌庄稼？那今天就为自己建造一个花园洒水器，告别手工劳动！")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKASHINE",       "路易斯（Lewis）创建 Nukashine 的初衷是为了给他的核子可乐收藏提供一个地方，但它的流行意味着朱迪-洛厄尔（Judy Lowell）和 Eta Psi 将会介入。")

-- We want that our custom tips appears more often.
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})

-- Custom Icons for Loading Tips.
SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")