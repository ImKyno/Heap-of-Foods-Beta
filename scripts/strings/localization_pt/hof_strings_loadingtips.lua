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
	COFFEE1         = "Você pode obter Plantas de Café após derrotar a Libélula. Ou, se isso for muito assustador, uma pequena viagem ao bioma Fumarola te trará algumas!",
	COFFEE2         = "Plantas de Café não precisam ser fertilizadas durante o Verão. Elas até se fertilizam sozinhas!",
	COFFEE3         = "Plantas de Café só podem ser plantadas em Turfs de Areia ou Fumarola.",
	WEEDS           = "Você pode plantar Ervas usando seus próprios produtos, dando-os primeiro a um pássaro.",
	WALRY           = "Warly tem receitas exclusivas feitas apenas por ele.",
	JELLYBEANS      = "\"Parece que as Jujubas Vigorosas me fazem sentir super bem!\" -W",
	INGREDIENTS     = "Existem novos ingredientes do jogo base disponíveis para serem usados na Panela de Barro. Até os mais estranhos...",
	WX78            = "\"WX-78 quer fazer um prato com Engrenagens. Se tivermos algumas sem uso, talvez eu deva ajudá-lo.\" -W",
	HUMANMEAT       = "Há uma pequena chance de que, quando um Jogador morre, ele possa deixar um ingrediente suspeito para cozinhar...",
	SALT            = "O sal pode ser usado para restaurar o tempo de deterioração de um alimento preparado. Nunca mais perca aquele prato delicioso!",
	OLDMOD          = "A primeira versão de Heap Of Foods era chamada The Foods Pack, foi descontinuada devido a erros. Mais tarde, foi recriada neste novo mod.",
	KYNOFOOD        = "Cubo de Caramelo e Quebra-queixo são os pratos favoritos do Kyno.",
	WHEAT           = "O Trigo pode ser moído na Pedra de Moer para produzir Farinha.",
	FLOUR           = "Você pode usar Farinha para fazer um Simples Pão. No entanto, existem muitos outros usos para Farinha além de pães.",
	WORMWOOD        = "\"Wormwood disse que fez um prato de... e Sal. Eu não vou comer isso, Mon dieu!\" -W",
	PIGKING         = "O Rei Porco troca uma variedade de novos itens. Por exemplo, Tufts de Grama por Tufts de Trigo, e Arbustos de Frutas por Arbustos Folhosos.",
	SERENITYISLAND  = "\"Tenho certeza de que vi um pedaço de terra rosada no oceano! Talvez meus companheiros se juntem a mim na busca...\" -W",
	PIGELDER        = "O Porco Ancião troca uma variedade de itens exclusivos em troca de alimentos.",
	CRABTRAP        = "\"Esses caranguejos de pedra parecem evitar todas as minhas armadilhas! Talvez algum tipo de armadilha especial funcione?\" -W",
	SAPTREE         = "Você pode extrair Savia das Árvores Açucaradas usando o Kit de Extração de Árvores, fazendo com que produzam uma Seiva doce a cada três dias.",
	RUINEDSAPTREE   = "Cuidado! Árvores Açucaradsa Extraídas com Seiva transbordando e não colhidas podem estragar. Produzindo Seiva Arruinada em vez disso!",
	PIGELDERFOODS   = "\"Ouvi dizer que aquele porco estranho na ilha rosada quer algum tipo de comida... Algo relacionado a Caramelos ou Lagostas.\" -W",
	SALTPOND        = "Você pode pescar diferentes tipos de peixes nas Poças de Sal do Arquipélago da Serenidade. Experimente!",
	SALTRACK        = "O Varal de Sal pode ser instalado na Poça de Sal para produzir Cristais de Sal a cada quatro dias.",
	SPOTTYSHRUB     = "Arbustos Folhosos podem ser encontrados por todo o Arquipélago da Serenidade. E podem ser levados para casa usando uma Pá.",
	SWEETFLOWER     = "A Flor Doce pode ser usada na Panela de Barro como opção de adoçante.",
	LIMPETROCK      = "O único lugar onde você encontrará Rochas de Lapa é na Pedreira de Caranguejos do Arquipélago da Serenidade ou na praia da Ilha Beira-mar!",
	CHICKEN         = "\"Me pergunto se essas Galinhas poderiam me dar alguns ovos. Preciso de algumas sementes para estimulá-las!\" -W",
	SYRUPPOT        = "O Xarope feito na Panela de Xarope dará três unidades em vez de uma, quando feito em uma Panela de Barro normal.",
	COOKWARE        = "Panelas de Xarope, Panela de Cozinhar, Grelhas e Fornos cozinham os alimentos mais rápido que uma Panela de Barro normal. Cada uma tem um benefício exclusivo.",
	COOKWARE_PIT    = "Para cozinhar usando as estações especiais de Cozinha, você precisa instalá-las acima de uma Fogueira primeiro.",
	COOKWARE_FIRE   = "As estações de Cozinha especiais só cozinharão os alimentos se o nível de fogo da Fogueira abaixo delas for alto o suficiente.",
	COOKWARE_OLDPOT = "O Porco Ancião pode precisar da sua ajuda para reparar sua Panela Antiga.",
	SPEED_DURATION  = "Você pode alterar quanto tempo o Bônus de Velocidade dos alimentos durará na Configuração do Mod.",
	WATERY_CRATE    = "\"Ontem, enquanto navegava, vi uma caixa estranha flutuando no oceano. Devo verificar se encontrar outra.\" -W",
	SERENITYCRATE   = "Caixas Aquáticas pescadas no Arquipélago da Serenidade reaparecerão no mesmo local após sete dias.",
	WATERY_CRATE2   = "Caixas Aquáticas sempre renderão uma Alga Marinha e saques extras. Continue destruindo-as para ver o que você encontra!",
	TUNACAN         = "O Atum 'Ballphin Free' nunca estragará, a menos que seja aberto.",
	CANNED_SOURCE   = "Você pode obter Comidas e Bebidas Enlatadas de Caixas Aquáticas e Baús Afundados. Boa caça ao tesouro!",
	CRABKING_LOOT   = "Sem Carne de Caranguejo? O Rei Caranguejo pode ser uma fonte confiável.",
	REGROWTH        = "Entidades do Mod, como Plantas, Árvores, etc., irão crescer novamente com o tempo se houver poucas delas no mundo.",
	BOTTLE_SOUL     = "Wortox pode armazenar Almas em Garrafas Vazias para refeições futuras...",
	BOTTLE_SOUL2    = "Todo sobrevivente pode carregar a Alma em uma Garrafa no inventário, mas apenas Wortox pode Liberar a Alma.",
	SOULSTEW        = "Se Wortox comer o Ensopado de Alma, ele ganhará todas as estatísticas do alimento em vez de metade, como acontece com outros alimentos.",
	MYSTERYMEAT     = "\"Você ouviu? Há algo estranho dentro de uma das Caixas Aquáticas. Devemos procurar, talvez...\" -W",
	KEGANDJAR       = "O Barril de Madeira e a Jarra de Conservas podem ser usados para produzir receitas especiais. Eles demoram mais para produzir do que outras receitas.",
	ANTIDOTE        = "Suas Árvore Açucaradas foram arruinadas? Não se preocupe, elas podem ser curadas! Basta usar o Antídoto Açucarado nelas e voilà!",
	MILKABLEANIMALS = "Alguns animais, como Beefalos e Koalefants, podem ser ordenhados usando um Balde. Mas cuidado para não levar um chute!",
	FORTUNECOOKIE   = "\"Você realmente acredita que esses biscoitos idiotas dizem sua sorte? E eu? Eu não acredito neles, juro!\" -W",
	PINEAPPLEBUSH   = "Arbustos de Abacaxi demoram mais para crescer em todas as estações, exceto no verão.",
	BREWBOOK        = "Receitas feitas no Barril de Madeira ou Jarra de Conservas não aparecerão no Livro de Receitas. Em vez disso, você pode visualizá-las no Livro de Bebidas!",
	PIKOS           = "Cuidado com os Esquilos! Essas pequenas criaturas gostam de roubar comida de presas fáceis.",
	TIDALPOOL       = "A Poça da Maré tem uma variedade de peixes que podem ser pescados durante todas as estações! Certifique-se de trazer sua Vara de Pesca de Água Doce!",
	GROUPER         = "Garoupas Roxas podem ser pescadas nos lagos encontrados nos Pântanos.",
	MEADOWISLAND    = "\"Viajando pelo mundo, consegui explorar quase tudo... Exceto por uma ilha estranha cheia de Palmeiras.\" -W",
	INFESTTREE      = "Árvores de Chá podem ser infestadas por Pikos. Aumentando suas chances de conseguir essas pequenas criaturas!",
	POISONBUNWICH   = "O Sanduíche de Sapo Nocivo pode ser difícil de cozinhar, mas tem uma peculiaridade interessante: os sapos serão passivos com você durante todo o dia!",
	TWISTEDTEQUILE  = "\"Na festa de ontem à noite, quando bebi aquela bebida, acho que se chama Tequila, certo? Aquela coisa me deixou tão tonto que no dia seguinte me encontrei em outro lugar!\" -W",
	WATERCUP        = "Quer se livrar dos seus efeitos negativos? Beba um Copo de Água e se mantenha hidratado!",
	NUKACOLA        = "\"Vê aquela garrafa de... Nuka-Cola, esse é o nome, certo? Acho que Wortox trouxe essa coisa de outra dimensão, em uma de suas viagens.\" -W",
	NUKACOLA2       = "O sabor único da Nuka-Cola é resultado da combinação de dezessete essências de frutas, equilibradas para realçar o sabor clássico da cola. Mate a sede!",
	SUGARBOMBS      = "Um pacote de cereais açucarados que contém 100% da quantidade diária recomendada de açúcar. As Sugar Bombs foram preservadas por 25 anos após a Grande Guerra. No entanto, isso também causou um pouco de radiação em muitas delas.",
	LUNARSOUP       = "\"Não temo nada quando essa Sopa Lunar desce pela minha barriga!\" -W",
	SPRINKLER       = "Cansado de regar suas plantações manualmente? Construa um Aspersor de Jardim hoje e diga adeus ao trabalho manual!",
	NUKASHINE       = "Lewis criou originalmente o Nukashine para poder ter um armazém para sua coleção de Nuka-Cola, mas sua popularidade fez com que a presidente do capítulo Judy Lowell e membros da fraternidade Eta Psi se envolvessem.",
	ITEMSLICER      = "Pedaços de carne e algumas frutas duras podem ser fatiados usando um Cutelo.",
	ITEMSLICER_GOLD = "O Grande Sublime tem usos ilimitados e pode fatiar itens mais rápido que um Cutelo normal.",
	SAMMY1          = "Sammy pode ser encontrado na Ilha Beira-mar vendendo uma variedade de itens raros e ingredientes que não são fáceis de encontrar por aí.",
	SAMMY2          = "Os produtos de Sammy mudam ao longo das estações e durante ocasiões especiais no mundo. Certifique-se de verificar seu inventário de vez em quando para ver o que ele oferece.",
	SAMMY3          = "Após derrotar o Lord of the Fruit Flies, você deveria falar com o Sammy. Ele recompensará aqueles que se mostrarem dignos com alguns itens curiosos!",
	JAWSBREAKER     = "Quebra-queixo pode ser usado para atrair Rockjaws e Gnarwails, matando-os instantaneamente. Mas não use muito perto de você.",
	METALBUCKET     = "O que é melhor que um Balde? Um balde de metal resistente que não quebra ao ordenhar animais!",
	LUNARTEQUILA    = "Se sentindo um pouco lunar? Por que não beber uma Tequila Iluminada para abrir sua mente para a verdade?",
	MIMICMONSA      = "Se quiser passar despercebido por inimigos perigosos, prepare um Sneakmosa e ninguém, nada, jamais vai notar você!",
	RUMMAGEWAGON    = "\"Vi Sammy outro dia revirando sua Carroça em busca de algo. Acho que ele estava negociando com alguém. Talvez eu deva ver o que ele guarda lá dentro...\" -W",
	RUMMAGEWAGON2   = "\"Não é roubo, juro! Sammy está jogando fora um monte de coisas úteis que poderíamos usar! Veja tudo o que eu peguei da sua Carroça!\" -W.",
	SLAUGHTERHEAT   = "Cuidado! Alguns animais atacarão se você matar um da mesma espécie quando houver outros por perto.",
	SLAUGHTERFLEE   = "Alguns animais podem fugir quando veem você matar um de sua espécie com as Ferramentas de Abate.",
	BOOKGARDENING1  = "O livro de Wickerbottom, Horticultura, Masterizada, pode cultivar qualquer tipo de planta, até algumas árvores especiais que normalmente você não consegue!",
	BOOKGARDENING2  = "O livro de Wickerbottom, Horticultura, Masterizada, tem chance de cultivar plantas de fazenda em uma forma Gigante!",
	FARMPLOT        = "Se o novo sistema de agricultura for muito complicado para você, não se preocupe! O Sammy tá contigo, ele está vendendo alguns antigos projetos de hortas que vão ajudar.",
	TRUFFLES1       = "Itens relacionados a Trufas podem ser usados para fazer amizade com Porcos, tornando-os leais por mais tempo.",
	TRUFFLES2       = "Itens relacionados a Trufas podem ser trocados com o Rei Porco por algumas Pepitas de Ouro.",
	GOLDENAPPLE     = "Maçãs Douradas Encantadas são itens raros que podem ser obtidas após o Celestial Scion ter sido derrotado pelo menos uma vez no mundo. Elas concedem múltiplos efeitos positivos ao custo de sua vida.",
}

for k, v in pairs(LOADINGTIPS) do
	AddLoadingTip(TIPS_HOF, "TIPS_HOF_"..k, v)
end

SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")

SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})