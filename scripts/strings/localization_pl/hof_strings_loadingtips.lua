-- Wspólne zależności.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local TIPS_HOF      = STRINGS.UI.LOADING_SCREEN_OTHER_TIPS

-- Nowe wskazówki i lore na ekranie ładowania.
STRINGS.HOF_LOADINGTIPS =
{
	COFFEE          = "Po pokonaniu Smoczego Muchy możesz zdobyć krzewy kawy.",
	WEEDS           = "Możesz sadzić chwasty, używając ich własnych produktów, dając je najpierw ptakowi.",
	WALRY           = "Warly ma unikalne przepisy robione tylko przez niego.",
	JELLYBEANS      = "\"Wydaje się, że żarłoczne Żelki sprawiają, że moje ciało czuje się super!\" -W",
	INGREDIENTS     = "W Crock Pocie dostępne są nowe składniki z podstawowej gry. Nawet najdziwniejsze z nich...",
	WX78            = "\"WX-78 chce zrobić danie z trybików. Jeśli mamy kilka z nich, które nie są potrzebne, może powinienem mu pomóc.\" -W",
	HUMANMEAT       = "Istnieje mała szansa, że po śmierci gracza może on upuścić podejrzany składnik do gotowania...",
	SALT            = "Sól może być użyta do wydłużenia czasu psucia się przygotowanego jedzenia. Nigdy więcej nie stracisz tego pysznego dania!",
	OLDMOD          = "Pierwsza wersja Heap Of Foods nazywała się The Foods Pack i została porzucona z powodu błędów. Później została przerobiona na ten nowy mod.",
	KYNOFOOD        = "Caramel Cube and Jawsbreaker are Kyno's favourite dishes.",
	WHEAT           = "Dziki pszenica może być mielona na Kamieniu do Mielenia, aby wytworzyć mąkę.",
	FLOUR           = "Mąkę można używać do robienia prostych bochenków chleba. Istnieje jednak wiele innych zastosowań mąki poza chlebami.",
	WORMWOOD        = "\"Wormwood powiedział, że zrobił danie z... i soli. Nie zamierzam tego jeść, Mon dieu!\" -W",
	PIGKING         = "Król Świń wymienia różnorodne nowe przedmioty. Na przykład, Trawa dla Tuftów Dziczy i Krzewy Jagodowe dla Krzewów Plamych.",
	SERENITYISLAND  = "\"Jestem pewien, że widziałem kawałek różowej wyspy na oceanie! Może moi towarzysze dołączą do mnie w poszukiwaniach...\" -W",
	PIGELDER        = "Starszy Świniak wymienia różnorodne ekskluzywne przedmioty w zamian za jedzenie.",
	CRABTRAP        = "\"Te kraby kamienne zdają się unikać wszystkich moich pułapek! Może specjalna pułapka będzie skuteczna?\" -W",
	SAPTREE         = "Możesz zbierać Słodki Syrop z Drzew Sugarwood za pomocą Zestawu do Zbierania Drzew. Wytwarzają one słodki sok co trzy dni.",
	RUINEDSAPTREE   = "Uważaj, jeśli Drzewa Sugarwood są nasycone sokiem, a nie zbierasz go, może zepsuć się, wytwarzając Zniszczony Sok!",
	PIGELDERFOODS   = "\"Słyszałem, że ten dziwny Świniak na różowej wyspie, chce jakiegoś jedzenia... Coś z karmelami lub wobstami.\" -W",
	SALTPOND        = "Możesz łowić inny rodzaj ryb w Słonych Stawach Archipelagu Spokoju. Spróbuj!",
	SALTRACK        = "Sólna Półka może być zainstalowana na Słonym Stawie, aby produkować Kryształy Sólne co cztery dni.",
	SPOTTYSHRUB     = "Krzewy Plamy można znaleźć na całym Archipelagu Spokoju. Można je zabrać do domu za pomocą Łopaty.",
	SWEETFLOWER     = "Słodki Kwiat może być użyty w Crock Pocie jako opcja słodzenia.",
	LIMPETROCK      = "The only place that you will find Limpet Rocks, is the Crab Quarry of Serenity Archipelago or the beach of Seaside Island!",
	CHICKEN         = "\"Zastanawiam się, czy te Kury mogłyby dawać mi jajka. Potrzebuję nasion, żeby je pobudzić!\" -W",
	SYRUPPOT        = "Syrop przygotowany w Garnku do Syropu daje trzy jednostki zamiast jednej, gdy gotujesz go w zwykłym Crock Pocie.",
	COOKWARE        = "Garnki do Syropu, Garnki do Gotowania, Grille i Piece gotują jedzenie szybciej niż zwykły Crock Pot. Mają też małą szansę na podwójną porcję!",
	COOKWARE_PIT    = "Aby gotować przy użyciu specjalnych stacji kuchennych, musisz najpierw zainstalować je na Ognisku.",
	COOKWARE_FIRE   = "Specjalne stacje kuchenne będą gotować jedzenie tylko wtedy gdy poziom ognia w ognisku pod nimi będzie wystarczająco wysoki.",
	COOKWARE_OLDPOT = "Starszy Świniak może potrzebować Twojej pomocy, aby naprawić swój Stary Garnek.",
	SPEED_DURATION  = "Możesz zmienić, jak długo trwa bonus szybkości z jedzenia w konfiguracji moda.",
	WATERY_CRATE    = "\"Wczoraj, kiedy żeglowałem, widziałem dziwną skrzynkę dryfującą po oceanie, powinienem ją sprawdzić, jeśli znowu ją znajdę.\" -W",
	SERENITYCRATE   = "Wodne Skrzynie łowione na Archipelagu Spokoju pojawią się ponownie w tym samym miejscu po siedmiu dniach.",
	WATERY_CRATE2   = "Wodne Skrzynie zawsze zawierają Wodorosty i dodatkowe łupy. Zniszcz je, aby sprawdzić, co możesz znaleźć!",
	TUNACAN         = "\"Tuna 'Ballphin Free' nigdy się nie psuje, chyba że ją otworzysz.\"",
	CANNED_SOURCE   = "Możesz znaleźć jedzenie i napoje w puszkach w Wodnych Skrzyniach i Zatopionych Skarbach. Szczęśliwego polowania na skarby!",
	CRABKING_LOOT   = "Brakuje Ci Krabowego Mięsa? Król Krabów może być niezawodnym źródłem.",
	REGROWTH        = "Jednostki moda, takie jak rośliny, drzewa itp., będą odrastać w czasie, jeśli będzie ich za mało w świecie.",
	BOTTLE_SOUL     = "Wortox może przechowywać Dusze w Pustych Butelkach na późniejsze posiłki...",
	BOTTLE_SOUL2    = "Każdy ocalały może nosić Duszę w Butelce w swoim ekwipunku, ale tylko Wortox może uwolnić Duszę.",
	SOULSTEW        = "Jeśli Wortox zje Zupę Dusz, otrzyma pełne statystyki z jedzenia zamiast połowy, jak w przypadku innych pokarmów.",
	MYSTERYMEAT     = "\"Słyszałeś? Coś dziwnego jest w jednej z Wodnych Skrzyń. Powinniśmy to znaleźć, może...\" -W",
	KEGANDJAR       = "Drewniany Keg i Słoik na Konfitury mogą być używane do produkcji specjalnych przepisów. Trwa to dłużej niż inne przepisy.",
	ANTIDOTE        = "Twoje Drzewa Sugarwood zostały zniszczone? Nie martw się, można je wyleczyć! Wystarczy użyć Ziołowego Antidotum i voila!",
	MILKABLEANIMALS = "Niektóre zwierzęta, takie jak Beefalo i Koalefanty, można doić za pomocą wiadra. Uważaj jednak!",
	FORTUNECOOKIE   = "\"Czy naprawdę wierzysz, że te głupie ciasteczka przewidują twoje szczęście? Huh? C-co ze mną?! Ja w to nie wierzę, przysięgam!\" -W",
	PINEAPPLEBUSH   = "Krzewy Ananasów rosną dłużej w każdej porze roku oprócz lata.",
	BREWBOOK        = "Przepisy robione w Drewnianym Kegu lub Słoiku na Konfitury nie pojawią się w Książce Przepisów. Zamiast tego, możesz je zobaczyć w Książce Warzenia!",
	PIKOS           = "Uważaj na Pikos! Te małe stworzenia uwielbiają kraść jedzenie z łatwych celów.",
	TIDALPOOL       = "Tidal Pool oferuje ryby, które można łowić przez cały rok! Pamiętaj, by zabrać wędkę do słodkiej wody!",
	GROUPER         = "Fioletowe Grupers można łowić w stawach w Bagnach.",
	MEADOWISLAND    = "\"Żeglując dookoła świata, udało mi się odkryć prawie wszystko... z wyjątkiem dziwnej wyspy pełnej Palmowych Drzew.\" -W",
	INFESTTREE      = "Drzewa Herbaciane mogą zostać zainfekowane przez Pikosy, zwiększając twoje źródła tych małych stworzeń!",
	COOKWAREBONUS   = "Specjalne stacje kuchenne mają małą szansę na dodanie dodatkowej porcji jedzenia podczas gotowania. Trzymaj kciuki, żeby to była podwójna porcja!",
	POISONBUNWICH   = "Trujące Froggle Bunwich może być trudne do ugotowania, ale ma ciekawą cechę: żaby będą wobec ciebie spokojne przez cały dzień!",
	TWISTEDTEQUILE  = "\"W zeszłą noc, na imprezie, kiedy piłem ten napój, myślę, że to było Tequila, prawda? To coś tak mnie odurzyło, że następnego dnia znalazłem się w innym miejscu!\" -W",
	WATERCUP        = "Chcesz pozbyć się swoich debuffów? Wypij Kubek Wody i bądź nawodniony!",
	NUKACOLA        = "\"Zobacz tę butelkę... 'Nuka-Cola', to chyba jej nazwa, prawda? Myślę, że Wortox przywiózł to z innego wymiaru, podczas jednej ze swoich podróży.\" -W",
	NUKACOLA2       = "Unikalny smak Nuka-Coli to wynik połączenia siedemnastu esencji owocowych, zrównoważonych w celu podkreślenia klasycznego smaku coli. Zaspokój pragnienie!",
	SUGARBOMBS      = "Paczka słodkich płatków śniadaniowych, zawierająca 100% zalecanej dziennej dawki cukru. Sugar Bombs przetrwały 25 lat po Wielkiej Wojnie. Niestety, przez to większość z nich została lekko napromieniowana.",	
	LUNARSOUP       = "\"Nie boję się niczego, gdy ta Księżycowa Zupa ląduje w moim brzuchu!\" -W",	
	SPRINKLER       = "Zmęczony ręcznym podlewaniem upraw? Zbuduj sobie Ogrodowy Zraszacz i pożegnaj się z tą uciążliwą pracą!",	
	NUKASHINE       = "Lewis stworzył Nukashine, aby zarobić na magazyn dla swojej kolekcji Nuka-Coli. Jego popularność sprawiła jednak, że prezes oddziału Judy Lowell oraz członkowie bractwa Eta Psi zaczęli brać w tym udział.",	
	ITEMSLICER      = "Meat Chunks and some hard fruits can be sliced using a Cleaver.",
	ITEMSLICER_GOLD = "The Grand Cleaver has unlimited uses and can slice items quicker than a regular Cleaver.",
	SAMMY1          = "Sammy can be found on the Seaside Island selling an array of rare items and ingredients that you can't find so easily out there.",
	SAMMY2          = "Sammy's wares changes throughout the seasons and during special world occasions. Make sure to check his inventory every now and then to see what he has to offer.",
	JAWSBREAKER     = "Jawsbreaker can be used to lure Rockjaws and Gnarwails, killing them instantly. But don't use it too close to yourself.",
	METALBUCKET     = "What's better than a Bucket? A sturdy metal bucket that will not break when milking animals!",
	LUNARTEQUILA    = "Feeling a bit on your moon side? Why not drink an Enlightened Tequila to open your mind to the truth?",
	MIMICMONSA      = "If you want to sneak past dangerous foes, brew a Sneakmosa and no one and nothing will ever notice you!",
}

function SetupHofLoadingTips()
    for k, v in pairs(STRINGS.HOF_LOADINGTIPS) do
        AddLoadingTip(TIPS_HOF, "TIPS_HOF_"..k, v)
    end

    local WeightStart =
    {
        CONTROLS        = 1,
        SURVIVAL        = 1,
        LORE            = 1,
        LOADING_SCREEN  = 1,
        OTHER           = 4,
    }

    SetLoadingTipCategoryWeights(WEIGHT_START, WeightStart)

    local WeightEnd =
    {
        CONTROLS        = 1,
        SURVIVAL        = 1,
        LORE            = 1,
        LOADING_SCREEN  = 1,
        OTHER           = 4,
    }

    SetLoadingTipCategoryWeights(WEIGHT_END, WeightEnd)

    SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")
    _G.TheLoadingTips = require("loadingtipsdata")()

    local TheLoadingTips             = _G.TheLoadingTips
    TheLoadingTips.loadingtipweights = TheLoadingTips:CalculateLoadingTipWeights()
    TheLoadingTips.categoryweights   = TheLoadingTips:CalculateCategoryWeights()

    _G.TheLoadingTips:Load()
end

SetupHofLoadingTips()