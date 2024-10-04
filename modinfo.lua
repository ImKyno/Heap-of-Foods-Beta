name                        = "Heap of Foods (Beta)"
version                     = "8.3-A"

description                 = 
[[
󰀄 Adds over +100 brand new Crock Pot dishes alongside new ingredients to use. Happy Cooking!

󰀠 Also features brand new Biomes somewhere in the Ocean!
󰀦 Complete Recipe Sheet on the Mod Page!

󰀏 Featuring the Bountiful Harvest Update:
This update focused on revamping the visuals of the farming crops as well as adding new ones! And some smaller changes and improvements in general to the mod.

Our survivors have managed to find new types of seeds out in the wild! And far, far away from the mainland, on a tropical island a new kind of bush is blooming, waiting for them to uncover it.

󰀌 Mod Version: 8.3-A
󰀧 Update: Bountiful Harvest
]]

author                      = "Kyno"
api_version                 = 10
priority                    = -15

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
	humanmeat               = "Long Pig Recipes",
	alcoholic               = "Alcoholic Restriction",
	giantspawn              = "Giants from Foods",
	coffeespeed             = "Speed Buff",
	coffeeduration          = "Speed Buff Duration",
	warlygrinder            = "Portable Grinding Mill Recipes",
	buckettweak             = "Bucket-o-Poop Recipe",
	retrofit                = "Retrofit Contents",
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
	humanmeat               = "Should Players drop Long Pigs upon death?\nNote: If disabled, this will cause some Recipes to be uncookable.",
	alcoholic               = "Should some characters be unable to drink Alcoholic-like drinks?",
	giantspawn              = "Should Players spawn Giants when eating their special food?",
	coffeespeed             = "Should the foods give the Speed Buff when eaten?\n\This option only applies to certain foods.",
	coffeeduration          = "How long should the Speed Buff from foods last?",
	warlygrinder            = "Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
	buckettweak             = "Should Bucket-o-Poop use the Bucket instead of its default recipe?",
	retrofit                = "If your world is missing the Mod Contents enable this option.\nThis option will be set as \"Updated\" once the retrofitting is finished!",
	
}

local desc                  =
{
	disabled                = "No",
	enabled                 = "Yes",

	language1               = "English",
	language2               = "Português (BR)",
	language3               = "简体中文 (Simplified Chinese)",
	language4               = "繁體中文 (Traditional Chinese)",
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
	retrofit3               = "Retrofit Prefabs",
}

local deschovers            =
{
	language1               = "Localization by: Kyno",
	language2               = "Localization by: Kyno",
	language3               = "Localization by: Anonymous Author",
	language4               = "Localization by: Anonymous Author",
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
	buckettweak1            = "Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
	buckettweak2            = "Bucket-o-Poop will use the Bucket as its crafting ingredient.",
	retrofit1               = "Your world is already updated with the Mod Contents.",
	retrofit2               = "Mod Islands will be generated during server initialization.",
	retrofit3               = "Mod Prefabs will be generated during server initialization.",
}

-- Localizations.
-- If you want to contribute with your localization please head to "scripts/strings/hof_localization.lua" for more information.
if locale == "pt" then
	name                        = "Amontoado de Comidas"

	description                 = 
[[
󰀄 Adiciona +100 novas comidas para a Panela, além de ingredientes novos para cozinhar!

󰀠 Também acrescenta novos biomas em algum lugar do alto mar!
󰀦 Lista completa de Receitas disponível na página do Mod!

󰀏 Apresentando a atualização Colheita Farta:
Esta atualização tem como foco melhorar os visuais das plantações e adicionar novas! E também pequenos ajustes para melhorar o mod em geral.

Nossos sobreviventes conseguiram encontrar um novo tipo de semente! Além disso, em uma ilha muito longe do continente, há um novo arbusto crescendo, esperando para ser descoberto!

󰀌 Versão do Mod: 8.3-A
󰀧 Atualização: Colheita Farta
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
		humanmeat               = "Receitas de Carne Humana",
		alcoholic               = "Restrição Alcoólica",
		giantspawn              = "Spawn de Gigantes das Comidas",
		coffeespeed             = "Efeito de Velocidade",
		coffeeduration          = "Duração do Efeito de Velocidade",
		warlygrinder            = "Receitas do Moinho de Moagem",
		buckettweak             = "Receita do Balde de Cocô",
		retrofit                = "Fazer Retro. de Conteúdos",
	}

	hovers                      =
	{
		general                 = "Opções Gerais do Mod.",
		food                    = "Opções de Comidas e Ingredientes.",
		extras                  = "Opções de Miscelânea do Mod.",
		retrofitting            = "Opções de Retrocompatibilidade para mundos antigos.",
	
		language                = "Escolha a Linguagem do Mod.\nVocê pode enviar sua localização em nosso Discord.",
		scrapbook               = "Os conteúdos do Mod devem ser adicionados ao Scrapbook?",
		spoilage                = "As comidas devem estragar se estiverem na Panela?",
		coffeedrop              = "Quantas Plantas de Café a Libélula deve deixar cair?",
		seasonalfoods           = "As Receitas Sazonais devem ser cozinhadas somente em Eventos Especiais?",
		humanmeat               = "Os Jogadores devem deixar cair Carne Humana quando morrem?\nNota: Se desabilitado, pode impedir de certas comidas de serem feitas.",
		alcoholic               = "Alguns personagens devem ser impedidos de beber bebidas alcoólicas?",
		giantspawn              = "Gigantes devem spawnar se Jogadores comerem suas comidas especiais?",
		coffeespeed             = "As comidas devem proporcionar o Efeito de Velocidade?\n\Isto só se aplica à certas comidas.",
		coffeeduration          = "O quão longo deve ser o Efeito de Velocidade das comidas?",
		warlygrinder            = "O Moinho de Moagem do Warly deve ter as receitas da Pedra de Preparação?",
		buckettweak             = "O Balde de Cocô deve usar o Balde invés de seus ingredientes padrões?",
		retrofit                = "Se seu mundo está faltando algum conteúdo ative esta opção.\nEsta opção irá ficar como \"Atualizado\ assim que a retrocompatibilidade for finalizada!",
	
	}

	desc                        =
	{
		disabled                = "Não",
		enabled                 = "Sim",

		language1               = "Inglês",
		language2               = "Português (BR)",
		language3               = "简体中文 (Chinês Simplificado)",
		language4               = "繁體中文 (Chinês Traditional)",
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
		retrofit3               = "Retro. de Prefabs",
	}

	deschovers                  =
	{
		language1               = "Localização por: Kyno",
		language2               = "Localização por: Kyno",
		language3               = "Localização por: Autor Anônimo",
		language4               = "Localização por: Autor Anônimo",
		scrapbook1              = "Scrapbook Padrão;",
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
		buckettweak1            = "O Balde de Cocô não irá usar o Balde. (Ingredientes padrão).",
		buckettweak2            = "O Balde de Cocô irá usar o Balde como parte de seu ingrediente.",
		retrofit1               = "Seu mundo já está atualizado com os conteúdos do Mod.",
		retrofit2               = "As Ilhas do Mod serão geradas durante a inicialização do servidor.",
		retrofit3               = "As Prefabs do Mod serão geradas durante a inicialização do servidor.",
	}
end

local options               =
{
	none                    = {{description = "", data = false}},
	toggle                  = {{description = desc.disabled, data = false}, {description = desc.enabled, data = true}},
	
	language                = {{description = desc.language1,       hover = deschovers.language1,       data = false},         {description = desc.language2,       hover = deschovers.language2,       data = "pt"}}, 
	scrapbook               = {{description = desc.disabled,        hover = deschovers.scrapbook1,      data = false},         {description = desc.enabled,         hover = deschovers.scrapbook2,      data = true}},
	spoilage                = {{description = desc.disabled,        hover = deschovers.spoilage1,       data = false},         {description = desc.enabled,         hover = deschovers.spoilage2,       data = true}},
	coffeedrop              = {{description = desc.coffeedrop1,     hover = deschovers.coffeedrop1,     data = 0},             {description = desc.coffeedrop2,     hover = deschovers.coffeedrop2,     data = 4},   {description = desc.coffeedrop3,     hover = deschovers.coffeedrop3,     data = 8},   {description = desc.coffeedrop4,     hover = deschovers.coffeedrop4,     data = 12},  {description = desc.coffeedrop5,     hover = deschovers.coffeedrop5,     data = 16}},
	seasonalfoods           = {{description = desc.disabled,        hover = deschovers.seasonalfoods1,  data = false},         {description = desc.enabled,         hover = deschovers.seasonalfoods2,  data = true}},
	humanmeat               = {{description = desc.disabled,        hover = deschovers.humanmeat1,      data = false},         {description = desc.enabled,         hover = deschovers.humanmeat2,      data = true}},
	alcoholic               = {{description = desc.disabled,        hover = deschovers.alcoholic1,      data = false},         {description = desc.enabled,         hover = deschovers.alcoholic2,      data = true}},
	giantspawn              = {{description = desc.disabled,        hover = deschovers.giantspawn1,     data = false},         {description = desc.enabled,         hover = deschovers.giantspawn2,     data = true}},
	coffeespeed             = {{description = desc.disabled,        hover = deschovers.coffeespeed1,    data = false},         {description = desc.enabled,         hover = deschovers.coffeespeed2,    data = true}},
	coffeeduration          = {{description = desc.coffeeduration1, hover = deschovers.coffeeduration1, data = 120},           {description = desc.coffeeduration2, hover = deschovers.coffeeduration2, data = 240}, {description = desc.coffeeduration3, hover = deschovers.coffeeduration3, data = 480}, {description = desc.coffeeduration4, hover = deschovers.coffeeduration4, data = 640}, {description = desc.coffeeduration5, hover = deschovers.coffeeduration5, data = 960}, {description = desc.coffeeduration6, hover = deschovers.coffeeduration6, data = 1920}}, 
	warlygrinder            = {{description = desc.disabled,        hover = deschovers.warlygrinder1,   data = false},         {description = desc.enabled,         hover = deschovers.warlygrinder2,   data = true}},
	buckettweak             = {{description = desc.disabled,        hover = deschovers.buckettweak1,    data = false},         {description = desc.enabled,         hover = deschovers.buckettweak2,    data = true}},
	retrofit                = {{description = desc.retrofit1,       hover = deschovers.retrofit1,       data = 0},             {description = desc.retrofit2,       hover = deschovers.retrofit2,       data = 1},   {description = desc.retrofit3,       hover = deschovers.retrofit3,       data = 2}},
}

configuration_options       =
{
	{name                   = "LANGUAGE",         label = labels.language,       hover = hovers.language,       options = options.language,       default = false},
	
	{name                   = names.general,                                     hover = hovers.general,        options = options.none,           default = false},
	{name                   = "SEASONALFOOD",     label = labels.seasonalfoods,  hover = hovers.seasonalfoods,  options = options.seasonalfoods,  default = false},
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
	{name                   = "FERTILIZERTWEAK",  label = labels.buckettweak,    hover = hovers.buckettweak,    options = options.buckettweak,    default = false},
	
	{name                   = names.retrofitting,                                hover = hovers.retrofitting,   options = options.none,           default = false},
	{name                   = "RETROFIT",         label = labels.retrofit,       hover = hovers.retrofit,       options = options.retrofit,       default = 0},
}