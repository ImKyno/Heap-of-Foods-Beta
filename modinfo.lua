name                        = "Heap of Foods"
version                     = "1.8-B"

description                 = 
[[
󰀄 Adds over +100 brand new Crock Pot dishes alongside new ingredients to use. Happy Cooking!

󰀠 Also features brand new Biomes somewhere in the Ocean!
󰀦 Complete Recipe Sheet on the Mod Page!

󰀏 Featuring the Bountiful Harvest Update:
This update focused on revamping the visuals of the farming crops as well as adding new ones! And some smaller changes and improvements in general to the mod.

Our survivors have managed to find new types of seeds out in the wild! And far, far away from the mainland, on a tropical island a new kind of bush is blooming, waiting for them to uncover it.

󰀌 Mod Version: 1.8-B
󰀧 Update: Seaside Summer (Part I)
]]

author                      = "Kyno"
api_version                 = 10
priority                    = -15 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible              = true
all_clients_require_mod     = true
client_only_mod             = false

server_filter_tags          = {"Heap of Foods", "HOF", "Cooking", "Entertainment", "Kyno"}

icon                        = "ModiconHOF.tex"
icon_atlas                  = "ModiconHOF.xml"

-- Mod Configuraton Strings and Stuff.
local names                 =
{
	general                 = "General Options",
	extras                  = "Miscellaneous Options",
	retrofitting            = "Retrofit Options",
}

local labels                =
{
	language                = "Language",
	scrapbook               = "Mod Scrapbook",
	spoilage                = "Keep Food Spoilage",
	coffeedrop              = "Coffee Plant Drop Rate",
	seasonalfoods           = "Seasonal Recipes",
	modspices               = "Chef's Spices",
	humanmeat               = "Long Pig Recipes",
	alcoholic               = "Alcoholic Restriction",
	giantspawn              = "Giants from Foods",
	coffeespeed             = "Speed Buff",
	coffeeduration          = "Speed Buff Duration",
	warlygrinder            = "Portable Grinding Mill Recipes",
	warlyrecipes            = "Chef's Specials Cookbook Page",
	buckettweak             = "Bucket-o-Poop Recipe",
	retrofit                = "Retrofit Contents",
	modtrades               = "Retrofit Trades",
}

local hovers                =
{
	general                 = "General options for the entire mod.",
	extras                  = "Miscellaneous options for the mod.",
	retrofitting            = "Retrofitting options for old worlds.",

	language                = "Choose the language for the mod.\nYou can submit your translation in our Discord.",
	scrapbook               = "Should the mod's contents be added to the Scrapbook?",
	spoilage                = "Should food spoil if it's in the Crock Pot?",
	coffeedrop              = "How many Coffee Plants Dragonfly should drop?",
	seasonalfoods           = "Should Seasonal Recipes only be cooked during Special Events?",
	modspices               = "Should Warly be able to grind Mod Spices?\nThis may cause longer loading times.",
	humanmeat               = "Should Players drop Long Pigs upon death?\nNote: If disabled, this will cause some Recipes to be uncookable.",
	alcoholic               = "Should some characters be unable to drink Alcoholic-like drinks?",
	giantspawn              = "Should Players spawn Giants when eating their special food?",
	coffeespeed             = "Should the foods give the Speed Buff when eaten?\n\This option only applies to certain foods.",
	coffeeduration          = "How long should the Speed Buff from foods last?",
	warlygrinder            = "Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
	warlyrecipes            = "Should Warly's Recipes appear on \"Chef's Specials\" instead of \"Mod Recipes\" in the Cookbook?",
	buckettweak             = "Should Bucket-o-Poop use the Bucket instead of its default recipe?",
	retrofit                = "If your world is missing the Mod Contents enable this option.\nThis option will be set as \"Updated\" once the retrofitting is finished!",
	modtrades               = "Should Pig King be able to trade items in exchange for Mod items?\This also applies to Pig Elder in Lights Out worlds.",
}

local desc                  =
{
	disabled                = "No",
	enabled                 = "Yes",

	language1               = "English",
	language2               = "Português",
	language3               = "简体中文",
	language4               = "繁體中文",
	language5               = "Polski",
	coffeedrop1             = "0",
	coffeedrop2             = "4",
	coffeedrop3             = "8",
	coffeedrop4             = "12",
	coffeedrop5             = "16",
	coffeeduration1         = "Super Fast",
	coffeeduration2         = "Fast",
	coffeeduration3         = "Default",
	coffeeduration4         = "Average",
	coffeeduration5         = "Long",
	coffeeduration6         = "Super Long",
	retrofit1               = "Updated",
	retrofit2               = "Retrofit Islands",
	retrofit3               = "Retrofit Mermhuts",
}

local deschovers            =
{
	language1               = "Localization by: Kyno",
	language2               = "Localization by: Kyno",
	language3               = "Localization by: 糖豆罐里好多颜色",
	language4               = "Localization by: Anonymous Author",
	language5               = "Localization by: Dr_Brzeszczot",
	scrapbook1              = "Default Scrapbook.",
	scrapbook2              = "Mod's contents will be added to the Scrapbook.",
	spoilage1               = "Food will spoil in Crock Pot, Portable Crock Pot, etc.",
	spoilage2               = "Food will not spoil in Crock Pot, Portable Crock Pot, etc.",
	coffeedrop1             = "Dragonfly will not Coffee Plants.",
	coffeedrop2             = "Dragonfly will drop 4 Coffee Plants.",
	coffeedrop3             = "Dragonfly will drop 8 Coffee Plants.",
	coffeedrop4             = "Dragonfly will drop 12 Coffee Plants.",
	coffeedrop5             = "Dragonfly will drop 16 Coffee Plants.",
	seasonalfoods1          = "Seasonal Recipes can be cooked without restrictions.",
	seasonalfoods2          = "Seasonal Recipes can only be cooked when Special Events are active.",
	modspices1              = "Warly can't grind any Mod Spices.",
	modspices2              = "Warly can grind all Mod Spices at the Portable Grinding Mill.",
	humanmeat1              = "Players will not drop Long Pigs upon death.",
	humanmeat2              = "Players may have a chance to drop Long Pigs upon death.",
	alcoholic1              = "All characters can drink Alcoholic-like drinks.",
	alcoholic2              = "Some characters like Webber, Wendy, etc. can't drink Alcoholic-like drinks.",
	giantspawn1             = "Players will not spawn Giants when eating certain foods.",
	giantspawn2             = "Players will spawn Giants when eating certain foods.",
	coffeespeed1            = "Foods will not give the Speed Buff when eaten.",
	coffeespeed2            = "Foods will give the Speed Buff when eaten.",
	coffeeduration1         = "Speed Buff will last for 2 Minutes.",
	coffeeduration2         = "Speed Buff will last for a Half Day.",
	coffeeduration3         = "Speed Buff will last for 1 Day.",
	coffeeduration4         = "Speed Buff will last for 1.5 Days.",
	coffeeduration5         = "Speed Buff will last for 2 Days.",
	coffeeduration6         = "Speed Buff will last for 4 Days.",
	warlygrinder1           = "Warly's Portable Grinding Mill will not have the recipes from Mealing Stone.",
	warlygrinder2           = "Warly's Portable Grinding Mill will have the recipes from Mealing Stone.",
	warlyrecipes1           = "Warly's Recipes will appear on \"Mod Recipes\" page of the Cookbook.",
	warlyrecipes2           = "Warly's Recipes will appear on \"Chef's Specials\" page of the Cookbook.",
	buckettweak1            = "Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
	buckettweak2            = "Bucket-o-Poop will use the Bucket as its crafting ingredient.",
	retrofit1               = "Your world is already updated with the Mod Contents.",
	retrofit2               = "Mod Islands will be generated during server initialization.",
	retrofit3               = "Mod Mermhuts will be generated during server initialization.",
	modtrades1              = "Certain items can't be traded in exchange for Mod items.",
	modtrades2              = "Certain items can be traded in exchange for Mod items.",
}

-- Localizations.
-- If you want to contribute with your localization please head to "scripts/strings/hof_localization.lua" for more information.

-- Brazilian Portuguese
if locale == "pt" then
	name                     = "Amontoado de Comidas"

	description                 = 
[[
󰀄 Adiciona +100 novas comidas para a Panela, além de ingredientes novos para cozinhar!

󰀠 Também acrescenta novos biomas em algum lugar do alto mar!
󰀦 Lista completa de Receitas disponível na página do Mod!

󰀏 Apresentando a atualização Colheita Farta:
Esta atualização tem como foco melhorar os visuais das plantações e adicionar novas! E também pequenos ajustes para melhorar o mod em geral.

Nossos sobreviventes conseguiram encontrar um novo tipo de semente! Além disso, em uma ilha muito longe do continente, há um novo arbusto crescendo, esperando para ser descoberto!

󰀌 Versão do Mod: 1.8-B
󰀧 Atualização: Verão à Beira-mar (Parte I)
]]

	names                       =
	{
		general                 = "Opções Gerais",
		extras                  = "Opções de Miscelânea",
		retrofitting            = "Opções de Retrocomp.",
	}

	labels                      =
	{
		language                = "Linguagem",
		scrapbook               = "Scrapbook do Mod",
		spoilage                = "Deteorização da Comida",
		coffeedrop              = "Taxa de Drop da Planta de Café",
		seasonalfoods           = "Receitas Sazonais",
		modspices               = "Temperos do Chef", 
		humanmeat               = "Receitas de Carne Humana",
		alcoholic               = "Restrição Alcoólica",
		giantspawn              = "Spawn de Gigantes das Comidas",
		coffeespeed             = "Efeito de Velocidade",
		coffeeduration          = "Duração do Efeito de Velocidade",
		warlygrinder            = "Receitas do Moinho de Moagem",
		warlyrecipes            = "Página Especiais do Chef",
		buckettweak             = "Receita do Balde de Cocô",
		retrofit                = "Fazer Retro. de Conteúdos",
		modtrades               = "Retro. de Trocas",
	}

	hovers                      =
	{
		general                 = "Opções Gerais do Mod.",
		food                    = "Opções de Comidas e Ingredientes.",
		extras                  = "Opções de Miscelânea do Mod.",
		retrofitting            = "Opções de Retrocompatibilidade para mundos antigos.",
	
		language                = "Escolha a Linguagem do Mod.\nVocê pode enviar sua localização em nosso Discord.",
		scrapbook               = "Permitir que os conteúdos do Mod sejam adicionados ao Scrapbook?",
		spoilage                = "Permitir que as comidas estraguem se estiverem na Panela?",
		coffeedrop              = "Quantas Plantas de Café a Libélula deve deixar cair?",
		seasonalfoods           = "Permitir que as Receitas Sazonais sejam cozinhadas somente em Eventos Especiais?",
		modspices               = "Permitir que o Warly consiga fazer Temperos do Mod?\nIsso pode vir a causar um maior tempo de carregamento.",
		humanmeat               = "Permitir que Jogadores deixem cair Carne Humana quando morrem?\nNota: Se desabilitado, pode impedir certas comidas de serem feitas.",
		alcoholic               = "Permitir que alguns personagens sejam impedidos de beber bebidas alcoólicas?",
		giantspawn              = "Permitir que Gigantes apareçam se Jogadores comerem suas comidas especiais?",
		coffeespeed             = "Permitir que as comidas proporcionem Efeito de Velocidade?\n\Isto só se aplica à certas comidas.",
		coffeeduration          = "O quão longo deve ser o Efeito de Velocidade das comidas?",
		warlygrinder            = "Permitir que o Moinho de Moagem do Warly tenha as receitas da Pedra de Preparação?",
		warlyrecipes            = "Permitir que as Receitas do Warly apareçam na página \"Especiais do Chefe\" ao invés de \"Receitas do Mod\" no Livro de Receitas?",
		buckettweak             = "Permitir que o Balde de Cocô use o Balde ao invés de seus ingredientes padrões?",
		retrofit                = "Se seu mundo está faltando algum conteúdo ative esta opção.\nEsta opção irá ficar como \"Atualizado\ assim que a retrocompatibilidade for finalizada!",
		modtrades               = "Permitir que o Rei Porco aceite certos itens em troca de itens do Mod?\nIsso também se aplica ao Porco Ancião em mundos Lights Out.",
	}

	desc                        =
	{
		disabled                = "Não",
		enabled                 = "Sim",

		language1               = "English",
		language2               = "Português",
		language3               = "简体中文",
		language4               = "繁體中文",
		language5               = "Polski",
		coffeedrop1             = "0",
		coffeedrop2             = "4",
		coffeedrop3             = "8",
		coffeedrop4             = "12",
		coffeedrop5             = "16",
		coffeeduration1         = "Super Rápido",
		coffeeduration2         = "Rápido",
		coffeeduration3         = "Padrão",
		coffeeduration4         = "Médio",
		coffeeduration5         = "Longo",
		coffeeduration6         = "Super Longo",
		retrofit1               = "Atualizado",
		retrofit2               = "Retro. de Ilhas",
		retrofit3               = "Retro. de Mermhuts",
	}

	deschovers                  =
	{
		language1               = "Localização por: Kyno",
		language2               = "Localização por: Kyno",
		language3               = "Localização por: 糖豆罐里好多颜色",
		language4               = "Localização por: Autor Anônimo",
		language5               = "Localização por: Dr_Brzeszczot",
		scrapbook1              = "Scrapbook Padrão.",
		scrapbook2              = "Os conteúdos do Mod serão adicionados ao Scrapbook.",
		spoilage1               = "As comidas estragarão na Panela, Panela Portátil, etc.",
		spoilage2               = "As comidas não estragarão na Panela, Panela Portátil, etc.",
		coffeedrop1             = "A Libélula não deixará cair nenhuma Planta de Café",
		coffeedrop2             = "A Libélula deixará cair 4 Plantas de Café",
		coffeedrop3             = "A Libélula deixará cair 8 Plantas de Café",
		coffeedrop4             = "A Libélula deixará cair 12 Plantas de Café",
		coffeedrop5             = "A Libélula deixará cair 16 Plantas de Café",
		seasonalfoods1          = "Receitas Sazonais podem ser cozinhadas sem nenhuma restrição.",
		seasonalfoods2          = "Receitas Sazonais só podem ser cozinhadas durante Eventos Especiais.",
		modspices1              = "Warly não irá conseguir fazer nenhum Tempero do Mod.",
		modspices2              = "Warly poderá fazer qualquer Tempero do Mod no Moinho de Moagem Portátil.",
		humanmeat1              = "Jogadores não deixarão cair Carne Humana quando morrem.",
		humanmeat2              = "Jogadores podem ter a chance de deixar cair Carne Humana quando morrem.",
		alcoholic1              = "Todos os personagens podem beber bebidas alcoólicas.",
		alcoholic2              = "Alguns personagens como Webber, Wendy, etc. Não poderão beber bebidas alcoólicas.",
		giantspawn1             = "Jogadores não irão spawnar Gigantes quando comem certas comidas.",
		giantspawn2             = "Jogadores irão spawnar Gigantes quando comem certas comidas.",
		coffeespeed1            = "As comidas não irão proporcionar o Efeito de Velocidade quando ingeridas.",
		coffeespeed2            = "As comidas irão proporcionar o Efeito de Velocidade quando ingeridas.",
		coffeeduration1         = "O Efeito de Velocidade irá durar por 2 minutos.",
		coffeeduration2         = "O Efeito de Velocidade irá durar por meio dia.",
		coffeeduration3         = "O Efeito de Velocidade irá durar 1 dia.",
		coffeeduration4         = "O Efeito de Velocidade irá durar 1 dia e meio.",
		coffeeduration5         = "O Efeito de Velocidade irá durar 2 dias.",
		coffeeduration6         = "O Efeito de Velocidade irá durar 4 dias.",
		warlygrinder1           = "O Moinho de Moagem do Warly não terá as receitas da Pedra de Preparação.",
		warlygrinder2           = "O Moinho de Moagem do Warly terá as receitas da Pedra de Preparação.",
		warlyrecipes1           = "As Receitas do Warly irão aparecer na página \"Receitas do Mod\" no Livro de Receitas.",
		warlyrecipes2           = "As Receitas do Warly irão aparecer na página \"Especiais do Chefe\" no Livro de Receitas.",
		buckettweak1            = "O Balde de Cocô não irá usar o Balde. (Ingredientes padrão).",
		buckettweak2            = "O Balde de Cocô irá usar o Balde como parte de seu ingrediente.",
		retrofit1               = "Seu mundo já está atualizado com os conteúdos do Mod.",
		retrofit2               = "As Ilhas do Mod serão geradas durante a inicialização do servidor.",
		retrofit3               = "As Mermhuts do Mod serão geradas durante a inicialização do servidor.",
		modtrades1              = "Não será possível fazer trocas por itens do Mod.",
		modtrades2              = "Será possível fazer trocas por itens do Mod.",
	}
end

-- Simplified Chinese.
if locale == "zh" or locale == "zhr" then
	name                        = "Heap of Foods (更多料理)"

	description                 = 
[[
󰀄 新增 100 多道全新的烹饪锅料理和几种新食材。祝您烹饪愉快！

󰀠 还在海洋的某处添加了全新的生物群落！
󰀦 Mod创意工坊的介绍页面上有完整食谱表！

󰀏 丰收更新:
这次更新的重点是改造农作物的视觉效果，并添加新的农作物！还有一些小的改动和改进。

我们的幸存者设法在野外找到了新型种子！在远离大陆的热带岛屿上，一种新的灌木丛正在绽放，等待着他们去发掘。

󰀌 Mod版本: 1.8-B
󰀧 Update: Seaside Summer (Part I)
]]

	names                       =
	{
		general                 = "一般选项",
		extras                  = "其他选项",
		retrofitting            = "改造选项",
	}

	labels                      =
	{
		language                = "语言",
		scrapbook               = "Mod图鉴",
		spoilage                = "防止食物腐败",
		coffeedrop              = "咖啡丛掉落数量",
		seasonalfoods           = "季节性食谱",
		modspices               = "厨师香料",
		humanmeat               = "人肉食谱",
		alcoholic               = "酒精限制",
		giantspawn              = "特殊Boss料理",
		coffeespeed             = "移速Buff",
		coffeeduration          = "移速Buff持续时间",
		warlygrinder            = "便携式研磨器食谱",
		warlyrecipes            = "沃利的特色食谱页面",
		buckettweak             = "便便桶配方",
		retrofit                = "改造内容",
		modtrades               = "贸易转型",
	}

	hovers                      =
	{
		general                 = "Mod的一般选项。",
		food                    = "食物和配料选项。",
		extras                  = "Mod的其他选项。",
		retrofitting            = "为旧世界提供向后兼容选项。",
	
		language                = "选择Mod语言。\n你可以在我们的Discord提供你的翻译。",
		scrapbook               = "Mod的内容是否添加到图鉴？",
		spoilage                = "料理在烹饪锅中是否变质？",
		coffeedrop              = "龙蝇掉落多少数量的咖啡丛？",
		seasonalfoods           = "季节性的料理是否在特殊活动下才能烹饪？",
		modspices               = "沃利可以研磨Mod的香料吗？\n这可能会导致游戏加载时间延长。",
		humanmeat               = "玩家死亡时是否掉落人肉？\n注意：如果禁用，可能会导致无法制作某些料理。",
		alcoholic               = "是否应该禁止某些角色饮酒？",
		giantspawn              = "如果玩家吃了含boss掉落物的特殊料理，boss是否应该出现？",
		coffeespeed             = "料理是否提供移速Buff？\n该项仅作用于特定料理",
		coffeeduration          = "料理提供的移速Buff可以持续多久？",
		warlygrinder            = "沃利的便携式研磨器是否可以拥有碾磨石的功能？",
		warlyrecipes            = "在烹饪指南中，沃利的Mod特色料理是否应该出现在\"大厨特色菜\"分页，而不是\"模组食谱\"分页？",
		buckettweak             = "便便桶是否用于挤奶而不是默认功能？",
		retrofit                = "如果你的世界缺少Mod内容，请启用此选项。\n改造完成后，该选项将被设置为 \"已更新\"！",
		modtrades               = "猪王是否应该能够用某些物品来交换 Mod 物品？\这也适用于熄灯世界中的猪长老。"
	}

	desc                        =
	{
		disabled                = "否",
		enabled                 = "是",

		language1               = "English",
		language2               = "Português",
		language3               = "简体中文",
		language4               = "繁體中文",
		language5               = "Polski",
		coffeedrop1             = "0",
		coffeedrop2             = "4",
		coffeedrop3             = "8",
		coffeedrop4             = "12",
		coffeedrop5             = "16",
		coffeeduration1         = "超级短",
		coffeeduration2         = "短",
		coffeeduration3         = "默认",
		coffeeduration4         = "平均",
		coffeeduration5         = "长",
		coffeeduration6         = "非常长",
		retrofit1               = "已更新",
		retrofit2               = "Mod岛屿",
		retrofit3               = "Mod物品",
	}

	deschovers                  =
	{
		language1               = "翻译由: Kyno",
		language2               = "翻译由: Kyno",
		language3               = "翻译由: 糖豆罐里好多颜色",
		language4               = "翻译由: 匿名作者",
		language5               = "翻译由: Dr_Brzeszczot",
		scrapbook1              = "默认图鉴。",
		scrapbook2              = "Mod的内容将添加到图鉴",
		spoilage1               = "料理在烹饪锅、便携式烹饪锅等锅中会变质。",
		spoilage2               = "料理在烹饪锅、便携式烹饪锅等锅中不会变质。",
		coffeedrop1             = "龙蝇不会掉落咖啡丛。",
		coffeedrop2             = "龙蝇会掉4株落咖啡丛。",
		coffeedrop3             = "龙蝇会掉8株落咖啡丛。",
		coffeedrop4             = "龙蝇会掉12株落咖啡丛。",
		coffeedrop5             = "龙蝇会掉16株落咖啡丛。",
		seasonalfoods1          = "季节性料理烹饪不受任何限制",
		seasonalfoods2          = "季节性料理只能在特殊活动开启时烹制。",
		modspices1              = "沃利不能研磨任何Mod的香料。",
		modspices2              = "沃利可以在便携式研磨器上研磨所有Mod的香料。",
		humanmeat1              = "玩家死亡后不会掉落人肉。",
		humanmeat2              = "玩家死亡后小概率会掉落人肉。",
		alcoholic1              = "所有角色都能饮酒。",
		alcoholic2              = "一些角色，比如韦伯，温蒂等。不能饮酒。",
		giantspawn1             = "玩家在食用某些料理时不会产生Boss。",
		giantspawn2             = "玩家在食用某些料理时会产生Boss。",
		coffeespeed1            = "料理食用后不会提高移速Buff。",
		coffeespeed2            = "料理食用后会提高移速Buff。",
		coffeeduration1         = "移速Buff会持续2分钟。",
		coffeeduration2         = "移速Buff会持续半天。",
		coffeeduration3         = "移速Buff会持续一天。",
		coffeeduration4         = "移速Buff会持续1.5天。",
		coffeeduration5         = "移速Buff会持续2天。",
		coffeeduration6         = "移速Buff会持续4天",
		warlygrinder1           = "沃利的便携式研磨器不会拥有碾磨石的功能。",
		warlygrinder2           = "沃利的便携式研磨器会拥有碾磨石的功能。",
		warlyrecipes1           = "在烹饪指南中，沃利的Mod特色料理会出现在\"模组食谱\"分页。",
		warlyrecipes2           = "在烹饪指南中，沃利的Mod特色料理会出现在\"大厨特色菜\"分页。",
		buckettweak1            = "便便桶使用默认功能。",
		buckettweak2            = "便便桶不使用默认功能，可用于挤奶。",
		retrofit1               = "你的世界已更新了Mod的内容。",
		retrofit2               = "Mod的岛屿会在服务器初始化期间生成。",
		retrofit3               = "Mod的物品会在服务器初始化期间生成。",
		modtrades1              = "某些物品不能用 Mod 物品进行交易。",
		modtrades2              = "某些物品可以用 Mod 物品进行交易。",
	}
end

local options               =
{
	none                    = {{description = "", data = false}},
	toggle                  = {{description = desc.disabled, data = false}, {description = desc.enabled, data = true}},
	
	language                = {{description = desc.language1,       hover = deschovers.language1,       data = false},         {description = desc.language2,       hover = deschovers.language2,       data = "pt"}, {description = desc.language3,       hover = deschovers.language3,       data = "zh"}, {description = desc.language5,       hover = deschovers.language5,       data = "pl"}}, 
	scrapbook               = {{description = desc.disabled,        hover = deschovers.scrapbook1,      data = false},         {description = desc.enabled,         hover = deschovers.scrapbook2,      data = true}},
	spoilage                = {{description = desc.disabled,        hover = deschovers.spoilage1,       data = false},         {description = desc.enabled,         hover = deschovers.spoilage2,       data = true}},
	coffeedrop              = {{description = desc.coffeedrop1,     hover = deschovers.coffeedrop1,     data = 0},             {description = desc.coffeedrop2,     hover = deschovers.coffeedrop2,     data = 4},    {description = desc.coffeedrop3,     hover = deschovers.coffeedrop3,     data = 8},    {description = desc.coffeedrop4,     hover = deschovers.coffeedrop4,     data = 12},  {description = desc.coffeedrop5,     hover = deschovers.coffeedrop5,     data = 16}},
	seasonalfoods           = {{description = desc.disabled,        hover = deschovers.seasonalfoods1,  data = true},          {description = desc.enabled,         hover = deschovers.seasonalfoods2,  data = false}},
	modspices               = {{description = desc.disabled,        hover = deschovers.modspices1,      data = false},         {description = desc.enabled,         hover = deschovers.modspices2,      data = true}},
	humanmeat               = {{description = desc.disabled,        hover = deschovers.humanmeat1,      data = false},         {description = desc.enabled,         hover = deschovers.humanmeat2,      data = true}},
	alcoholic               = {{description = desc.disabled,        hover = deschovers.alcoholic1,      data = false},         {description = desc.enabled,         hover = deschovers.alcoholic2,      data = true}},
	giantspawn              = {{description = desc.disabled,        hover = deschovers.giantspawn1,     data = false},         {description = desc.enabled,         hover = deschovers.giantspawn2,     data = true}},
	coffeespeed             = {{description = desc.disabled,        hover = deschovers.coffeespeed1,    data = false},         {description = desc.enabled,         hover = deschovers.coffeespeed2,    data = true}},
	coffeeduration          = {{description = desc.coffeeduration1, hover = deschovers.coffeeduration1, data = 120},           {description = desc.coffeeduration2, hover = deschovers.coffeeduration2, data = 240},  {description = desc.coffeeduration3, hover = deschovers.coffeeduration3, data = 480},  {description = desc.coffeeduration4, hover = deschovers.coffeeduration4, data = 640}, {description = desc.coffeeduration5, hover = deschovers.coffeeduration5, data = 960}, {description = desc.coffeeduration6, hover = deschovers.coffeeduration6, data = 1920}}, 
	warlygrinder            = {{description = desc.disabled,        hover = deschovers.warlygrinder1,   data = false},         {description = desc.enabled,         hover = deschovers.warlygrinder2,   data = true}},
	warlyrecipes            = {{description = desc.disabled,        hover = deschovers.warlyrecipes1,   data = false},         {description = desc.enabled,         hover = deschovers.warlyrecipes2,   data = true}},
	buckettweak             = {{description = desc.disabled,        hover = deschovers.buckettweak1,    data = false},         {description = desc.enabled,         hover = deschovers.buckettweak2,    data = true}},
	retrofit                = {{description = desc.retrofit1,       hover = deschovers.retrofit1,       data = 0},             {description = desc.retrofit2,       hover = deschovers.retrofit2,       data = 1},    {description = desc.retrofit3,       hover = deschovers.retrofit3,       data = 2}},
	modtrades               = {{description = desc.disabled,        hover = deschovers.modtrades1,      data = false},         {description = desc.enabled,         hover = deschovers.modtrades2,      data = true}},
}

configuration_options       =
{
	{name                   = "LANGUAGE",         label = labels.language,       hover = hovers.language,       options = options.language,       default = false},
	
	{name                   = names.general,                                     hover = hovers.general,        options = options.none,           default = false},
	{name                   = "SEASONALFOOD",     label = labels.seasonalfoods,  hover = hovers.seasonalfoods,  options = options.seasonalfoods,  default = false},
 -- {name                   = "MODSPICES",        label = labels.modspices,      hover = hovers.modspices,      options = options.modspices,      default = true},
	{name                   = "HUMANMEAT",        label = labels.humanmeat,      hover = hovers.humanmeat,      options = options.humanmeat,      default = true},
	{name                   = "COFFEEDROPRATE",   label = labels.coffeedrop,     hover = hovers.coffeedrop,     options = options.coffeedrop,     default = 4},
	{name                   = "ALCOHOLICDRINKS",  label = labels.alcoholic,      hover = hovers.alcoholic,      options = options.alcoholic,      default = true},
	{name                   = "GIANTSPAWNING",    label = labels.giantspawn,     hover = hovers.giantspawn,     options = options.giantspawn,     default = true},
	{name                   = "COFFEESPEED",      label = labels.coffeespeed,    hover = hovers.coffeespeed,    options = options.coffeespeed,    default = true},
	{name                   = "COFFEEDURATION",   label = labels.coffeeduration, hover = hovers.coffeeduration, options = options.coffeeduration, default = 480},
	
	{name                   = names.extras,                                      hover = hovers.extras,         options = options.none,           default = false},
	{name                   = "SCRAPBOOK",        label = labels.scrapbook,      hover = hovers.scrapbook,      options = options.scrapbook,      default = true},
	{name                   = "KEEPFOOD",         label = labels.spoilage,       hover = hovers.spoilage,       options = options.spoilage,       default = false},
	{name                   = "WARLYMEALGRINDER", label = labels.warlygrinder,   hover = hovers.warlygrinder,   options = options.warlygrinder,   default = false},
	{name                   = "WARLYRECIPES",     label = labels.warlyrecipes,   hover = hovers.warlyrecipes,   options = options.warlyrecipes,   default = true},
	{name                   = "FERTILIZERTWEAK",  label = labels.buckettweak,    hover = hovers.buckettweak,    options = options.buckettweak,    default = false},
	
	{name                   = names.retrofitting,                                hover = hovers.retrofitting,   options = options.none,           default = false},
	{name                   = "RETROFIT",         label = labels.retrofit,       hover = hovers.retrofit,       options = options.retrofit,       default = 0},
	{name                   = "MODTRADES",        label = labels.modtrades,      hover = hovers.modtrades,      options = options.modtrades,      default = false},
}