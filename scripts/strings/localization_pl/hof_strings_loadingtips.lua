-- Wspólne zależności.
local _G            = GLOBAL
local require       = _G.require
local STRINGS       = _G.STRINGS

-- Nowe wskazówki i lore na ekranie ładowania.
local TIPS_LORE     = LOADING_SCREEN_LORE_TIPS
local TIPS_SURVIVAL = LOADING_SCREEN_SURVIVAL_TIPS
local TIPS_HOF      = STRINGS.UI.LOADING_SCREEN_OTHER_TIPS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END
local HOF_CATEGORY  = _G.LOADING_SCREEN_TIP_CATEGORIES

-- Nasze wskazówki.
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COFFEE",          "Po pokonaniu Smoczego Muchy możesz zdobyć krzewy kawy.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WEEDS",           "Możesz sadzić chwasty, używając ich własnych produktów, dając je najpierw ptakowi.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WALRY",           "Warly ma unikalne przepisy robione tylko przez niego.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_JELLYBEANS",      "\"Wydaje się, że żarłoczne Żelki sprawiają, że moje ciało czuje się super!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INGREDIENTS",     "W Crock Pocie dostępne są nowe składniki z podstawowej gry. Nawet najdziwniejsze z nich...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WX78",            "\"WX-78 chce zrobić danie z trybików. Jeśli mamy kilka z nich, które nie są potrzebne, może powinienem mu pomóc.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_HUMANMEAT",       "Istnieje mała szansa, że po śmierci gracza może on upuścić podejrzany składnik do gotowania...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALT",            "Sól może być użyta do wydłużenia czasu psucia się przygotowanego jedzenia. Nigdy więcej nie stracisz tego pysznego dania!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_OLDMOD",          "Pierwsza wersja Heap Of Foods nazywała się The Foods Pack i została porzucona z powodu błędów. Później została przerobiona na ten nowy mod.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CARAMELCUBE",     "Kostka karmelowa to ulubione danie Kyno.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WHEAT",           "Dziki pszenica może być mielona na Kamieniu do Mielenia, aby wytworzyć mąkę.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FLOUR",           "Mąkę można używać do robienia prostych bochenków chleba. Istnieje jednak wiele innych zastosowań mąki poza chlebami.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WORMWOOD",        "\"Wormwood powiedział, że zrobił danie z... i soli. Nie zamierzam tego jeść, Mon dieu!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGKING",         "Król Świń wymienia różnorodne nowe przedmioty. Na przykład, Trawa dla Tuftów Dziczy i Krzewy Jagodowe dla Krzewów Plamych.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYISLAND",  "\"Jestem pewien, że widziałem kawałek różowej wyspy na oceanie! Może moi towarzysze dołączą do mnie w poszukiwaniach...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDER",        "Starszy Świniak wymienia różnorodne ekskluzywne przedmioty w zamian za jedzenie.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABTRAP",        "\"Te kraby kamienne zdają się unikać wszystkich moich pułapek! Może specjalna pułapka będzie skuteczna?\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAPTREE",         "Możesz zbierać Słodki Syrop z Drzew Sugarwood za pomocą Zestawu do Zbierania Drzew. Wytwarzają one słodki sok co trzy dni.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_RUINEDSAPTREE",   "Uważaj, jeśli Drzewa Sugarwood są nasycone sokiem, a nie zbierasz go, może zepsuć się, wytwarzając Zniszczony Sok!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIGELDERFOODS",   "\"Słyszałem, że ten dziwny Świniak na różowej wyspie, chce jakiegoś jedzenia... Coś z karmelami lub wobstami.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTPOND",        "Możesz łowić inny rodzaj ryb w Słonych Stawach Archipelagu Spokoju. Spróbuj!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SALTRACK",        "Sólna Półka może być zainstalowana na Słonym Stawie, aby produkować Kryształy Sólne co cztery dni.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPOTTYSHRUB",     "Krzewy Plamy można znaleźć na całym Archipelagu Spokoju. Można je zabrać do domu za pomocą Łopaty.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SWEETFLOWER",     "Słodki Kwiat może być użyty w Crock Pocie jako opcja słodzenia.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LIMPETROCK",      "Jedyne miejsce, w którym znajdziesz Kamienie Limpet, to Kamieniołom Krabów w Archipelagu Spokoju!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CHICKEN",         "\"Zastanawiam się, czy te Kury mogłyby dawać mi jajka. Potrzebuję nasion, żeby je pobudzić!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SYRUPPOT",        "Syrop przygotowany w Garnku do Syropu daje trzy jednostki zamiast jednej, gdy gotujesz go w zwykłym Crock Pocie.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE",        "Garnki do Syropu, Garnki do Gotowania, Grille i Piece gotują jedzenie szybciej niż zwykły Crock Pot. Mają też małą szansę na podwójną porcję!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_PIT",    "Aby gotować przy użyciu specjalnych stacji kuchennych, musisz najpierw zainstalować je na Ognisku.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_FIRE",   "Specjalne stacje kuchenne będą gotować jedzenie tylko wtedy gdy poziom ognia w ognisku pod nimi będzie wystarczająco wysoki.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWARE_OLDPOT", "Starszy Świniak może potrzebować Twojej pomocy, aby naprawić swój Stary Garnek.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPEED_DURATION",  "Możesz zmienić, jak długo trwa bonus szybkości z jedzenia w konfiguracji moda.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE",    "\"Wczoraj, kiedy żeglowałem, widziałem dziwną skrzynkę dryfującą po oceanie, powinienem ją sprawdzić, jeśli znowu ją znajdę.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SERENITYCRATE",   "Wodne Skrzynie łowione na Archipelagu Spokoju pojawią się ponownie w tym samym miejscu po siedmiu dniach.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERY_CRATE2",   "Wodne Skrzynie zawsze zawierają Wodorosty i dodatkowe łupy. Zniszcz je, aby sprawdzić, co możesz znaleźć!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TUNACAN",         "\"Tuna 'Ballphin Free' nigdy się nie psuje, chyba że ją otworzysz.\"")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CANNED_SOURCE",   "Możesz znaleźć jedzenie i napoje w puszkach w Wodnych Skrzyniach i Zatopionych Skarbach. Szczęśliwego polowania na skarby!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_CRABKING_LOOT",   "Brakuje Ci Krabowego Mięsa? Król Krabów może być niezawodnym źródłem.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_REGROWTH",        "Jednostki moda, takie jak rośliny, drzewa itp., będą odrastać w czasie, jeśli będzie ich za mało w świecie.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL",     "Wortox może przechowywać Dusze w Pustych Butelkach na późniejsze posiłki...")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BOTTLE_SOUL2",    "Każdy ocalały może nosić Duszę w Butelce w swoim ekwipunku, ale tylko Wortox może uwolnić Duszę.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SOULSTEW",        "Jeśli Wortox zje Zupę Dusz, otrzyma pełne statystyki z jedzenia zamiast połowy, jak w przypadku innych pokarmów.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MYSTERYMEAT",     "\"Słyszałeś? Coś dziwnego jest w jednej z Wodnych Skrzyń. Powinniśmy to znaleźć, może...\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_KEGANDJAR",       "Drewniany Keg i Słoik na Konfitury mogą być używane do produkcji specjalnych przepisów. Trwa to dłużej niż inne przepisy.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ANTIDOTE",        "Twoje Drzewa Sugarwood zostały zniszczone? Nie martw się, można je wyleczyć! Wystarczy użyć Ziołowego Antidotum i voila!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MILKABLEANIMALS", "Niektóre zwierzęta, takie jak Beefalo i Koalefanty, można doić za pomocą wiadra. Uważaj jednak!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_FORTUNECOOKIE",   "\"Czy naprawdę wierzysz, że te głupie ciasteczka przewidują twoje szczęście? Huh? C-co ze mną?! Ja w to nie wierzę, przysięgam!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PINEAPPLEBUSH",   "Krzewy Ananasów rosną dłużej w każdej porze roku oprócz lata.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_BREWBOOK",        "Przepisy robione w Drewnianym Kegu lub Słoiku na Konfitury nie pojawią się w Książce Przepisów. Zamiast tego, możesz je zobaczyć w Książce Warzenia!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_PIKOS",           "Uważaj na Pikos! Te małe stworzenia uwielbiają kraść jedzenie z łatwych celów.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TIDALPOOL",       "Tidal Pool oferuje ryby, które można łowić przez cały rok! Pamiętaj, by zabrać wędkę do słodkiej wody!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_GROUPER",         "Fioletowe Grupers można łowić w stawach w Bagnach.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MEADOWISLAND",    "\"Żeglując dookoła świata, udało mi się odkryć prawie wszystko... z wyjątkiem dziwnej wyspy pełnej Palmowych Drzew.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_INFESTTREE",      "Drzewa Herbaciane mogą zostać zainfekowane przez Pikosy, zwiększając twoje źródła tych małych stworzeń!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_COOKWAREBONUS",   "Specjalne stacje kuchenne mają małą szansę na dodanie dodatkowej porcji jedzenia podczas gotowania. Trzymaj kciuki, żeby to była podwójna porcja!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_POISONBUNWICH",   "Trujące Froggle Bunwich może być trudne do ugotowania, ale ma ciekawą cechę: żaby będą wobec ciebie spokojne przez cały dzień!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_TWISTEDTEQUILE",  "\"W zeszłą noc, na imprezie, kiedy piłem ten napój, myślę, że to było Tequila, prawda? To coś tak mnie odurzyło, że następnego dnia znalazłem się w innym miejscu!\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_WATERCUP",        "Chcesz pozbyć się swoich debuffów? Wypij Kubek Wody i bądź nawodniony!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA",        "\"Zobacz tę butelkę... 'Nuka-Cola', to chyba jej nazwa, prawda? Myślę, że Wortox przywiózł to z innego wymiaru, podczas jednej ze swoich podróży.\" -W")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKACOLA2",       "Unikalny smak Nuka-Coli to wynik połączenia siedemnastu esencji owocowych, zrównoważonych w celu podkreślenia klasycznego smaku coli. Zaspokój pragnienie!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SUGARBOMBS",      "Paczka słodkich płatków śniadaniowych, zawierająca 100% zalecanej dziennej dawki cukru. Sugar Bombs przetrwały 25 lat po Wielkiej Wojnie. Niestety, przez to większość z nich została lekko napromieniowana.")	
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LUNARSOUP",       "\"Nie boję się niczego, gdy ta Księżycowa Zupa ląduje w moim brzuchu!\" -W")	
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SPRINKLER",       "Zmęczony ręcznym podlewaniem upraw? Zbuduj sobie Ogrodowy Zraszacz i pożegnaj się z tą uciążliwą pracą!")	
AddLoadingTip(TIPS_HOF, "TIPS_HOF_NUKASHINE",       "Lewis stworzył Nukashine, aby zarobić na magazyn dla swojej kolekcji Nuka-Coli. Jego popularność sprawiła jednak, że prezes oddziału Judy Lowell oraz członkowie bractwa Eta Psi zaczęli brać w tym udział.")	
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ITEMSLICER",      "Meat Chunks and some hard fruits can be sliced using a Cleaver.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_ITEMSLICER_GOLD", "The Grand Cleaver has unlimited uses and can slice items quicker than a regular Cleaver.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAMMY1",          "Sammy can be found on the Seaside Island selling an array of rare items and ingredients that you can't find so easily out there.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_SAMMY2",          "Sammy's wares changes throughout the seasons and during special world occasions. Make sure to check his inventory every now and then to see what he has to offer.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_JAWSBREAKER",     "Jawsbreaker can be used to lure Rockjaws and Gnarwails, killing them instantly. But don't use it too close to yourself.")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_METALBUCKET",     "What's better than a Bucket? A sturdy metal bucket that will not break when milking animals!")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_LUNARTEQUILA",    "Feeling a bit on your moon side? Why not drink an Enlightened Tequila to open your mind to the truth?")
AddLoadingTip(TIPS_HOF, "TIPS_HOF_MIMICMONSA",      "If you want to sneak past dangerous foes, brew a Sneakmosa and no one and nothing will ever notice you!")

-- Chcemy, aby nasze niestandardowe wskazówki pojawiały się częściej.	
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})	
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})	

-- Niestandardowe ikony dla wskazówek ładowania.	
SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")