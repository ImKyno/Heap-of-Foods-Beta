-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local TIPS_HOF      = STRINGS.UI.LOADING_SCREEN_OTHER_TIPS

-- New Loading Tips and Lore.
local LOADINGTIPS   =
{
	COFFEE1         = "击败龙蝇后，你可以获得咖啡植物。或者，如果你觉得龙蝇太难对付了，不妨去喷气孔区域转转，也能收获几株！",
	COFFEE2         = "咖啡植物在夏季不需要施肥。它们甚至会自己施肥！",
	COFFEE3         = "咖啡植物只能种植在沙漠或喷气孔区域地皮上。",
	WEEDS           = "耕地里长出的杂草可以喂鸟来换取对应的种子。",
	WALRY           = "沃利拥有独家食谱。",
	JELLYBEANS      = "\"某些糖豆使人精力充沛，让我身体的感觉超级棒！\" -W",
	INGREDIENTS     = "游戏中的新食材都可以在烹饪锅中烹饪。即使有些食材看起来很奇怪...",
	WX78            = "\"WX-78想用齿轮做一道菜。如果我们有一些不用的，我或许能帮他一把。\" -W",
	HUMANMEAT       = "每当玩家死亡时，有几率掉落一个奇怪的烹饪食材...",
	SALT            = "盐可以用来恢复食物的变质时间。再也不会失去那道甜美的菜肴了！",
	OLDMOD          = "Heap Of Foods 的第一个版本名为食物包，后因错误而停用。后来，它被重新制作成了这个全新的Mod。",
	KYNOFOOD        = "Kyno最喜欢的是焦糖方糕和舔舔糖。",
	WHEAT           = "野生小麦可以在碾磨石上磨成面粉。",
	FLOUR           = "你可以用面粉制做一个简单的面包。然而，除了面包，面粉还有很多其他用途。",
	WORMWOOD        = "\"沃姆伍德说他用...和盐做了一道美食。但是我才不要吃那个，我的天啊！\" -W",
	PIGKING         = "猪王现在可以换取新物品。例如，用草丛换取小麦丛，用浆果丛换取斑点灌木丛。",
	SERENITYISLAND  = "\"我在海里看到了一片粉红色的陆地！或许我的伙伴们会和我一起去探索它...\" -W",
	PIGELDER        = "你可以用各种料理与猪长老交易换取特殊的物品。",
	CRABTRAP        = "\"那些卵石蟹好像避开了我所有设置的陷阱！或许某种特殊的陷阱可以代替它们？\" -W",
	SAPTREE         = "你可以用采集工具来收集糖木树的树液, 每三天收集一次。",
	RUINEDSAPTREE   = "小心，长时间未收集的糖木树会生病。反而，会产生变质的树液！",
	PIGELDERFOODS   = "\"我听说那个粉红色小岛上陌生的猪人想要某种食物... 跟焦糖或龙虾有关的东西。\" -W",
	SALTPOND        = "你可以在宁静岛上的盐池里钓到不同种类的鱼。试试吧！",
	SALTRACK        = "盐架可安装在盐池上，每四天生产一次盐晶。",
	SPOTTYSHRUB     = "整个宁静群岛都能找到斑点灌木。它们可以用铲子带回家。",
	SWEETFLOWER     = "甜花可作为甜味剂在烹饪锅中使用。",
	LIMPETROCK      = "你只能在宁静群岛的螃蟹采石场或海滨岛的海滩上找到帽贝岩！",
	CHICKEN         = "\"我在想这些鸡能不能给我一些蛋。可能我需要一些种子来引诱它们！\" -W",
	SYRUPPOT        = "在糖浆锅中制作的糖浆，将在普通烹饪锅中烹饪时获得四单位，而不是一单位。",
	COOKWARE        = "糖浆锅、烹饪锅、烤架和烤箱的烹饪速度比普通陶锅快。每种都有独特的加成效果！",
	COOKWARE_PIT    = "要使用特殊炊具站进行烹饪，你需要先将它安装在火坑上。",
	COOKWARE_FIRE   = "特殊炊具站只有在火坑的火足够旺时才能烹饪食物。",
	COOKWARE_OLDPOT = "猪长老可能需要你的帮助来修复他的旧锅。",
	SPEED_DURATION  = "你可以在模组配置中更改食物带来的速度buff持续时间。",
	WATERY_CRATE    = "\"昨天出海时，我看到一个奇怪的箱子在海上漂着，如果再遇到的话，我应该去查看下。\" -W",
	SERENITYCRATE   = "在宁静岛上钓到的水箱会在七天后在同一位置重新出现。",
	WATERY_CRATE2   = "水箱总是会产生海藻和额外的战利品。继续摧毁它们，看看还能发现什么！",
	TUNACAN         = "\"金枪鱼罐头\"永远不会变质，除非你打开它。",
	CANNED_SOURCE   = "你可以从水箱和沉箱中获得罐头和饮料。祝你寻宝愉快！",
	CRABKING_LOOT   = "没有蟹肉了？帝王蟹就是一个可靠的来源。",
	REGROWTH        = "植物、树木等模组实体。如果在世界上的数量较少，它们会随着时间的推移而重新生长。",
	BOTTLE_SOUL     = "沃托克斯可以将灵魂储存在空瓶子里，以供日后食用...",
	BOTTLE_SOUL2    = "每个幸存者都可以将灵魂装在瓶子里，但只有沃托克斯可以释放灵魂。",
	SOULSTEW        = "如果沃托克斯吃了灵魂炖汤，他将获得食物的全部收益，而不像他吃其他食物那样只有一半的收益。",
	MYSTERYMEAT     = "\"你听说了吗？有一个水箱里有奇怪的东西 我们应该找找看，也许...\" -W",
	KEGANDJAR       = "精酿桶和罐头瓶可以用来制作特殊食谱。但花费的时间很长。",
	ANTIDOTE        = "你的糖木树感染了？别担心，它们是可以治愈的！你只需对它们使用腐烂解毒剂就可以了！",
	MILKABLEANIMALS = "一些动物，比如皮弗娄牛和考拉象，可以用空水桶挤奶。不过要小心！",
	FORTUNECOOKIE   = "\"你真的相信幸运饼干能告诉你的运气吗? 嗯? W-那我呢?! I-我不相信，我发誓！\" -W",
	PINEAPPLEBUSH   = "除了夏季，菠萝丛在其他季节都需要很长的生长时间。",
	BREWBOOK        = "用精酿桶或罐头瓶制作的食物不会出现在食谱中。相反，你可以在酿造手册上查看它们！",
	PIKOS           = "注意异食松鼠！这些小动物喜欢偷东西。",
	TIDALPOOL       = "潮汐池中有各种鱼类，四季皆可垂钓！请务必带上你的淡水钓竿！",
	GROUPER         = "在沼泽的池塘里可以钓到紫色石斑鱼。",
	MEADOWISLAND    = "\"环游世界，我几乎能够探索一切... 除了一个长满茶树的奇怪小岛\" -W",
	INFESTTREE      = "茶树可能会受到异食松鼠的侵扰。但你捕获这些小家伙的机会大大增加！",
	COOKWAREBONUS   = "特殊炊具站在烹饪时有小概率会多出一份食物。我们一起祈祷美味的佳肴不要带来双倍的麻烦！",
	POISONBUNWICH   = "毒蛙腿三明治烹饪难度很高，但它食用后带来一份奇特的效果：一整天青蛙都会与你和平相处！",
	TWISTEDTEQUILE  = "\"昨晚在派对上，我喝了一种酒，好像叫龙舌兰，对吧？让我头晕目眩。结果第二天，我发现自己到了另一个地方\" -W",
	WATERCUP        = "想要摆脱你的debuff？喝杯水，补充水分！",
	NUKACOLA        = "\"看到那瓶... \"核子可乐\ 是这个名字吧？我认为是沃托克斯在他旅行中从另一个空间带回来的。\" -W",
	NUKACOLA2       = "核子可乐的独特口味是由17种水果精华组合而成的，这些水果精华相互配合造就了可乐的经典口味。消除口渴！",
	SUGARBOMBS      = "甜麦炮弹是含糖量达到每日推荐量的一种麦片，在第一次大战之后保存了25年。不过，这也导致大部分甜麦炮弹受到了辐射。",
	LUNARSOUP       = "\"喝下月牙汤，我无所畏惧！\" -W",
	SPRINKLER       = "厌倦了手动浇灌庄稼？那今天就为自己建造一个花园洒水器，告别手工劳动！",
	NUKASHINE       = "路易斯（Lewis）创建 Nukashine 的初衷是为了给他的核子可乐收藏提供一个地方，但它的流行意味着朱迪-洛厄尔（Judy Lowell）和 Eta Psi 将会介入。",
	ITEMSLICER      = "肉块和一些硬质水果可以用砍刀切片。",
	ITEMSLICER_GOLD = "黄金砍刀用途广泛，切削速度比普通砍刀更快。",
	SAMMY1          = "萨米可以在海滨岛上找到，他出售各种稀有物品和原料，这些东西在外面可不容易找到。",
	SAMMY2          = "萨米的货物会随着季节和特殊世界事件的变化而变化。请务必定期查看他的小店，看看他有什么可供挑选的。",
	SAMMY3          = "打败了果蝇之王后，你该去看看萨米了。他会给那些证明自己值得的人奖励一些奇妙的物品！",
	JAWSBREAKER     = "鲨鱼舔舔糖可用于引诱岩石大白鲨和一角鲸，并能瞬间将其击杀。但切勿在自己附近使用。",
	METALBUCKET     = "什么比水桶更好？一个结实的金属水桶，在挤奶时不会破裂！",
	LUNARTEQUILA    = "感觉有点儿迷迷糊糊？何不来一杯启明龙舌兰酒，让你的心灵敞开，接纳真相？",
	MIMICMONSA      = "如果你想悄悄地躲过危险的敌人，就酿造一杯“潜行鸡尾酒”，这样没有人会注意到你！",
	RUMMAGEWAGON    = "“我前几天看到萨米在翻他的小推车寻找什么东西。我想他可能在和别人交易。也许我应该看看他在里面存了什么……” -W",
	RUMMAGEWAGON2   = "“这不是抢劫，我发誓！萨米把一堆有用的破烂扔掉了，我们本可以用上！快看看我从他的小推车里得到的东西！” -W",
	SLAUGHTERHEAT   = "小心！当同类动物在附近时，屠宰其中一只可能会激怒其他动物进行攻击。",
	SLAUGHTERFLEE   = "当某些动物看到你用屠宰工具屠宰它们的同类时，它们可能会受到惊吓逃跑。",
	BOOKGARDENING1  = "薇克巴顿的《园艺学精通版》可以种植任何类型的植物，甚至一些你平时无法种植的特殊树木！",
	BOOKGARDENING2  = "薇克巴顿的《园艺学精通版》有机会将农场植物培育成超大形态！",
	FARMPLOT        = "如果新的耕作系统对你来说太复杂，不用担心！萨米会帮你，他正在出售一些旧的蓝图，会对你有帮助。",
	TRUFFLES1       = "与松露相关的物品可用于与猪人成为朋友，使它们更长时间保持忠诚。",
	TRUFFLES2       = "与松露相关的物品可与猪王交易，以轻松获得一些金块。",
	GOLDENAPPLE     = "魔法金苹果是稀有物品，在世界中至少击败一次天体后裔后即可获得。它们会以生命为代价给予多种积极效果。",
}

for k, v in pairs(LOADINGTIPS) do
	AddLoadingTip(TIPS_HOF, "TIPS_HOF_"..k, v)
end

SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")

SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})