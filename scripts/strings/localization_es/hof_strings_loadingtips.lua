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
	COFFEE          = "Puedes conseguir arbustos de café después de derrotar a la Libélula.",
	WEEDS           = "Puedes plantar malas hierbas usando sus propios productos, dándoselos primero a un pájaro.",
	WALRY           = "Warly tiene recetas exclusivas hechas solo por él.",
	JELLYBEANS      = "\"¡Parece que los Jellybeans Apasionados hacen que mi cuerpo se sienta increíble!\" -W",
	INGREDIENTS     = "Hay nuevos ingredientes del juego base disponibles para usar en la Crock Pot. Incluso los más extraños...",
	WX78            = "\"WX-78 quiere preparar un plato con engranajes. Si tenemos algunos que no usamos, tal vez debería ayudarle.\" -W",
	HUMANMEAT       = "Existe una pequeña posibilidad de que, cuando un jugador muere, deje caer un ingrediente sospechoso para cocinar...",
	SALT            = "La sal puede usarse para restaurar el tiempo de descomposición de un alimento preparado. ¡Nunca más perderás ese delicioso plato!",
	OLDMOD          = "La primera versión de Heap Of Foods se llamaba The Foods Pack, y fue descontinuada debido a errores. Más tarde se rehizo en este nuevo mod.",
	KYNOFOOD        = "Caramel Cube y Jawsbreaker son los platos favoritos de Kyno.",
	WHEAT           = "El trigo silvestre puede molerse en la Piedra de Molienda para producir harina.",
	FLOUR           = "Puedes usar la harina para hacer un simple pan. Sin embargo, hay muchos otros usos para la harina además del pan.",
	WORMWOOD        = "\"Wormwood dijo que hizo un plato con... y sal. ¡No voy a comer eso, Mon dieu!\" -W",
	PIGKING         = "El Rey Cerdo intercambia una variedad de nuevos objetos. Por ejemplo, mechones de hierba por mechones de trigo silvestre, y arbustos de bayas por arbustos moteados.",
	SERENITYISLAND  = "\"¡Estoy seguro de haber visto un pedazo de tierra rosada en el océano! Tal vez mis compañeros se unan a mí en la búsqueda...\" -W",
	PIGELDER        = "El Anciano Cerdo intercambia una variedad de objetos exclusivos a cambio de comida.",
	CRABTRAP        = "\"¡Esos cangrejos de roca parecen evitar todas mis trampas! Tal vez una trampa especial funcione mejor.\" -W",
	SAPTREE         = "Puedes extraer savia de los árboles Sugarwood usando el Kit de Tapping, para que produzcan savia dulce cada tres días.",
	RUINEDSAPTREE   = "¡Cuidado! Los árboles Sugarwood sobreexplotados que no se cosechan pueden estropearse, produciendo Savia Arruinada.",
	PIGELDERFOODS   = "\"Escuché que ese cerdo extraño en la isla rosada quiere algún tipo de comida... Algo relacionado con caramelos o Wobsters.\" -W",
	SALTPOND        = "Puedes pescar un tipo diferente de pescado en los estanques de sal del Archipiélago Serenidad. ¡Inténtalo!",
	SALTRACK        = "El Estante de Sal puede instalarse en el estanque salado para producir cristales de sal cada cuatro días.",
	SPOTTYSHRUB     = "Los arbustos moteados se encuentran en todo el Archipiélago Serenidad. Pueden llevarse a casa con una pala.",
	SWEETFLOWER     = "La Flor Dulce puede usarse en la Crock Pot como opción de endulzante.",
	LIMPETROCK      = "El único lugar donde encontrarás Rocas de Lapa es en la Cantera de Cangrejos del Archipiélago Serenidad o en la playa de la Isla Seaside.",
	CHICKEN         = "\"Me pregunto si esas gallinas podrían darme algunos huevos. ¡Necesito semillas para estimularlas!\" -W",
	SYRUPPOT        = "El jarabe hecho en la Olla de Jarabe dará tres unidades en lugar de una, cuando se cocine en una Crock Pot normal.",
	COOKWARE        = "Las Ollas de Jarabe, Ollas de Cocina, Parrillas y Hornos cocinan la comida más rápido que una Crock Pot normal. ¡Y cada una tiene bonificaciones exclusivas!",
	COOKWARE_PIT    = "Para cocinar usando las estaciones de cocina especiales, primero debes instalarlas sobre un Fuego.",
	COOKWARE_FIRE   = "Las estaciones de cocina especiales solo cocinarán si el nivel de fuego del Fuego debajo de ellas es lo suficientemente alto.",
	COOKWARE_OLDPOT = "El Anciano Cerdo puede necesitar tu ayuda para reparar su Vieja Olla.",
	SPEED_DURATION  = "Puedes cambiar cuánto durará el Buff de velocidad de la comida en la configuración del mod.",
	WATERY_CRATE    = "\"Ayer mientras navegaba, vi una caja extraña flotando en el océano. Debo revisarla si encuentro otra.\" -W",
	SERENITYCRATE   = "Las cajas acuáticas pescadas en el Archipiélago Serenidad reaparecerán en la misma ubicación después de siete días.",
	WATERY_CRATE2   = "Las cajas acuáticas siempre darán algas y botín extra. ¡Sigue destruyéndolas para ver qué encuentras!",
	TUNACAN         = "El atún \"Ballphin Free\" nunca se estropeará, a menos que lo abras.",
	CANNED_SOURCE   = "Puedes conseguir alimentos y bebidas enlatadas de Cajas Acuáticas y Cofres Hundidos. ¡Feliz búsqueda del tesoro!",
	CRABKING_LOOT   = "¿Te quedaste sin carne de cangrejo? El Rey Cangrejo puede ser una fuente confiable.",
	REGROWTH        = "Entidades del mod como plantas, árboles, etc., volverán a crecer con el tiempo si hay pocas en el mundo.",
	BOTTLE_SOUL     = "Wortox puede almacenar almas en Botellas Vacías para comidas futuras...",
	BOTTLE_SOUL2    = "Cada sobreviviente puede llevar un Alma en una Botella en su inventario, pero solo Wortox puede liberar el Alma.",
	SOULSTEW        = "Si Wortox come el Guiso de Almas, obtendrá las estadísticas completas del alimento en lugar de la mitad, como con cualquier otra comida.",
	MYSTERYMEAT     = "\"¿Has oído? Hay algo extraño dentro de una de las Cajas Acuáticas. Deberíamos buscarlo, quizás...\" -W",
	KEGANDJAR       = "El Barril de Madera y el Tarro de Conservas pueden usarse para producir recetas especiales. Tardan más en producirse que otras recetas.",
	ANTIDOTE        = "¿Tus árboles Sugarwood se arruinaron? No te preocupes, ¡pueden curarse! Solo necesitas usar el Antídoto Musty en ellos y voilà!",
	MILKABLEANIMALS = "Algunos animales como Beefalos y Koalefantes se pueden ordeñar con un cubo. ¡Pero cuidado de no recibir una patada!",
	FORTUNECOOKIE   = "\"¿De verdad crees que esas galletas estúpidas predicen tu suerte? ¿Eh? ¿Y yo?! ¡Yo no creo en eso, lo juro!\" -W",
	PINEAPPLEBUSH   = "Los arbustos de piña tardan más en crecer en todas las estaciones excepto en verano.",
	BREWBOOK        = "Las recetas hechas en el Barril de Madera o en el Tarro de Conservas no aparecerán en el Libro de Cocina. ¡En su lugar, puedes verlas en el Libro de Elaboración!",
	PIKOS           = "¡Cuidado con los Pikos! Estas pequeñas criaturas disfrutan robando comida de presas fáciles.",
	TIDALPOOL       = "La Piscina de Marea tiene una variedad de peces que se pueden pescar durante las estaciones. ¡No olvides llevar tu caña de agua dulce!",
	GROUPER         = "Los meros morados se pueden pescar en los estanques de los pantanos.",
	MEADOWISLAND    = "\"Al navegar por el mundo, pude explorar casi todo... excepto una extraña isla llena de palmeras.\" -W",
	INFESTTREE      = "Los árboles de té pueden estar infestados de Pikos, aumentando tus fuentes para conseguir estos pequeños seres.",
	POISONBUNWICH   = "El Froggle Bunwich Nocivo puede ser difícil de cocinar, pero tiene una peculiaridad: las ranas serán pasivas contigo durante todo un día.",
	TWISTEDTEQUILE  = "\"Anoche en la fiesta, cuando bebí esa bebida, creo que se llamaba Tequila, ¿verdad? ¡Me mareó tanto que al día siguiente me encontré en otro lugar!\" -W",
	WATERCUP        = "¿Quieres deshacerte de tus debuffs? ¡Bebe una taza de agua y mantente hidratado!",
	NUKACOLA        = "\"Mira esa botella... 'Nuka-Cola', ese es el nombre, ¿verdad? Creo que Wortox trajo eso de otra dimensión en uno de sus viajes.\" -W",
	NUKACOLA2       = "El sabor único de Nuka-Cola es el resultado de la combinación de diecisiete esencias de frutas, equilibradas para realzar el sabor clásico de la cola. ¡Apaga la sed!",
	SUGARBOMBS      = "Un paquete de cereales azucarados que contiene el 100% de la ingesta diaria recomendada de azúcar. Los Sugar Bombs se han conservado durante 25 años después de la Gran Guerra. Sin embargo, esto también hizo que la mayoría tuviera algo de radiación.",
	LUNARSOUP       = "\"¡No temo a nada cuando esa Sopa Lunar llega a mi estómago!\" -W",
	SPRINKLER       = "¿Cansado de regar manualmente tus cultivos? ¡Construye un Rociador de Jardín y despídete del trabajo manual!",
	NUKASHINE       = "Lewis creó originalmente Nukashine para poder pagar un almacén para su colección de Nuka-Cola, pero su popularidad hizo que la presidenta del capítulo Judy Lowell y los miembros de la fraternidad Eta Psi se involucraran.",
	ITEMSLICER      = "Se pueden cortar trozos de carne y algunas frutas duras usando un cuchillo de carnicero.",
	SAMMY1          = "Se puede encontrar a Sammy en la Isla Seaside vendiendo una variedad de objetos raros e ingredientes que no se encuentran fácilmente en otros lugares.",
	SAMMY2          = "Los productos de Sammy cambian a lo largo de las estaciones y durante ocasiones especiales del mundo. Asegúrate de revisar su inventario de vez en cuando para ver lo que ofrece.",
	JAWSBREAKER     = "Jawsbreaker puede usarse para atraer Rockjaws y Gnarwails, matándolos al instante. Pero no lo uses demasiado cerca de ti.",
	METALBUCKET     = "¿Qué es mejor que un Cubo? ¡Un cubo de metal resistente que no se romperá al ordeñar animales!",
	LUNARTEQUILA    = "¿Te sientes un poco en tu lado lunar? ¿Por qué no beber un Tequila Iluminado para abrir tu mente a la verdad?",
	MIMICMONSA      = "Si quieres escabullirte de enemigos peligrosos, prepara un Sneakmosa y nadie ni nada te notará jamás.",
	RUMMAGEWAGON    = "\"Vi a Sammy el otro día revisando su Carro en busca de algo. Creo que estaba comerciando con alguien. Tal vez debería revisar lo que guarda allí...\" -W",
	RUMMAGEWAGON2   = "\"¡No es un robo, lo juro! ¡Sammy está tirando un montón de cosas útiles que podríamos usar! ¡Mira todo lo que saqué de su Carro!\" -W",
	SLAUGHTERHEAT   = "¡Cuidado! Algunos animales atacarán si matas a uno de su especie cuando hay más alrededor.",
	SLAUGHTERFLEE   = "Algunos animales pueden asustarse si te ven matando a uno de su especie con las Herramientas de Matanza.",
}

for k, v in pairs(LOADINGTIPS) do
	AddLoadingTip(TIPS_HOF, "TIPS_HOF_"..k, v)
end

SetLoadingTipCategoryIcon("OTHER", "images/hof_loadingtips_icon.xml", "hof_loadingtips_icon.tex")

SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})