local function ChooseTranslationTable(tbl)
    return tbl[locale] or tbl[1]
end

local STRINGS = 
{
	NAME = 
	{
		"Heap of Foods",
		zh  = "更多料理 (Heap of Foods)",
		zht = "食物堆積 (Heap of Foods)",
		pt  = "Amontoado de Comidas (Heap of Foods)",
		pl  = "Stos jedzenia (Heap of Foods)",
		es  = "Montón de Alimentos (Heap of Foods)",
		vi  = "Kho thực phẩm (Heap of Foods)",
	},
	
	DESCRIPTION =
	{
[[
󰀄 Adds over 200 brand-new Crock Pot dishes alongside new ingredients to use. Happy Cooking!

󰀠 Also features brand-new Biomes somewhere in the Ocean!
󰀦 Learn how to cook every recipe at: https://heap-of-foods.com

󰀏 Featuring the Recipe of the Day Update:
Daily Recipes are featured dishes selected everyday from the recipe pool. All players share the same recipe regardless of the world.

Each day, one recipe will be randomly selected. Eating the daily recipe grants bonus Health, Hunger and Sanity, alongside the dish’s original stats. It also increases Luck for a certain period.

󰀌 Mod Version: 5.3-B
󰀧 Update: Recipe of the Day
]],
		zh  =
[[
󰀄 新增 200+ 道全新烹饪锅料理，以及一些新的食材。烹饪愉快！

󰀠 还新增了海洋中的全新生物群系！
󰀦 学习如何制作所有食谱：https://heap-of-foods.com

󰀏 每日食谱更新：
每日食谱是从食谱库中每天随机挑选的特色菜肴。所有玩家无论身处哪个世界，都共享相同的食谱。

每天都会随机选择一道食谱。食用每日食谱除了菜肴本身的属性外，还能额外提升生命值、饥饿值和理智值。此外，食用后一段时间内还能提升幸运值。

󰀌 Mod 版本： 5.3-B
󰀧 更新内容： 今日食谱
]],	
		zht =
[[
󰀄 新增超過 +200 道全新慢燉鍋菜餚，以及可使用的新食材。快樂烹飪！

󰀠 還新增了海洋中的全新生物群系！
󰀦 學習如何製作所有食譜：https://heap-of-foods.com

󰀏 每日食譜更新：
每日食譜是從食譜庫中隨機挑選的特色菜餚。所有玩家無論身處哪個世界，都將共享相同的食譜。

每天都會隨機選出一道食譜。食用每日食譜除了菜餚本身的屬性外，還能額外提升生命值、飢餓值和理智值。此外，食用後一段時間內還能提升幸運值。

󰀌 Mod 版本： 5.3-B
󰀧 更新內容： 今日食譜
]],	
		pt  = 
[[
󰀄 Adiciona mais de 200 novas comidas para a Panela, além de ingredientes novos para cozinhar!

󰀠 Também acrescenta novos biomas em algum lugar do alto mar!
󰀦 Aprenda a cozinhar todas as receitas em: https://heap-of-foods.com

󰀏 Apresentando a atualização Receita do Dia:
As Receitas Diárias são pratos em destaque selecionados diariamente do banco de receitas. Todos os jogadores compartilham a mesma receita, independentemente do mundo.

A cada dia, uma receita será selecionada aleatoriamente. Consumir a receita diária concede bônus de Saúde, Fome e Sanidade, além dos atributos originais do prato. Também aumenta a Sorte por um determinado período.

󰀌 Versão do Mod: 5.3-B
󰀧 Atualização: Receita do Dia
]],
		pl  =
[[
󰀄 Dodaje ponad +200 zupełnie nowych potraw do Crock Pota wraz z nowymi składnikami do wykorzystania. Smacznego gotowania!

󰀠 Zawiera również zupełnie nowe biomasy gdzieś na Oceanie!
󰀦 Naucz się gotować wszystkie przepisy na: https://heap-of-foods.com

󰀏 Przedstawiamy aktualizację Przepisu Dnia:
Codzienne Przepisy to wyróżnione dania wybierane codziennie z puli przepisów. Wszyscy gracze korzystają z tego samego przepisu, niezależnie od świata.

Każdego dnia losowo wybierany jest jeden przepis. Spożywanie przepisu dnia zapewnia premię do zdrowia, głodu i zdrowia psychicznego, a także do oryginalnych statystyk potrawy. Zwiększa również szczęście na określony czas.

󰀌 Wersja Moda: 5.3-B
󰀧 Aktualizacja: Przepis dnia
]],
		es  =
[[
󰀄 ¡Agrega más de +200 nuevos platos para la Olla, junto con nuevos ingredientes para cocinar!

󰀠 ¡También incluye nuevos biomas en algún lugar del mar abierto!
󰀦 Aprende a cocinar todas las recetas en: https://heap-of-foods.com

󰀏 Presentando la actualización Receta del día:
Las recetas diarias son platos destacados que se seleccionan cada día del repertorio. Todos los jugadores comparten la misma receta, independientemente del mundo.

Cada día se selecciona una receta al azar. Al consumir la receta del día, se obtienen bonificaciones de salud, hambre y cordura, además de las estadísticas originales del plato. También aumenta la suerte durante un tiempo determinado.

󰀌 Versión del Mod: 5.3-B
󰀧 Actualización: Receta del día
]],
		vi  =
[[
󰀄 Thêm hơn 200 món ăn hoàn toàn mới cho Nồi Hầm cùng với nhiều nguyên liệu mới để sử dụng. Chúc nấu ăn vui vẻ!

󰀠 Ngoài ra còn có các Quần Xã Sinh Vật hoàn toàn mới xuất hiện đâu đó ngoài Đại Dương!
󰀦 Tìm hiểu cách nấu mọi công thức tại: https://heap-of-foods.com

󰀏 Bao gồm bản cập nhật Công Thức Trong Ngày:
Công thức Trong Ngày là những món ăn đặc biệt được chọn ngẫu nhiên mỗi ngày từ danh sách công thức. Tất cả người chơi sẽ nhận cùng một công thức bất kể thế giới nào.

Mỗi ngày, một công thức sẽ được chọn ngẫu nhiên. Ăn món ăn trong ngày sẽ nhận thêm Máu, Đói và Tinh Thần ngoài chỉ số gốc của món ăn. Ngoài ra còn tăng May Mắn trong một khoảng thời gian nhất định.

󰀌 Phiên bản Mod: 5.3-B
󰀧 Cập nhật: Công Thức Trong Ngày
]],
	},

	SETTINGS = 
	{
		DISABLED =
		{
			"Disabled",
			zh  = "已禁用",
			zht = "停用",
			pt  = "Desativado",
			pl  = "Wyłączony",
			es  = "Desactivada",
			vi  = "Vô hiệu hóa",
		},
		
		ENABLED =
		{
			"Enabled",
			zh  = "已启用",
			zht = "啟用",
			pt  = "Ativado",
			pl  = "Włączony",
			es  = "Activada",
			vi  = "Đã bật",
		},

		GENERAL =
		{
			NAME =
			{
				"General Options",
				zh  = "常规选项",
				zht = "一般選項",
				pt  = "Opções Gerais",
				pl  = "Opcje ogólne",
				es  = "Opciones generales",
				vi  = "Tùy chọn chung",
			},
			
			HOVER =
			{
				"General options for the entire mod.",
				zh  = "Mod的常规选项。",
				zht = "整個模組的常規選項。",
				pt  = "Opções gerais para o Mod inteiro.",
				pl  = "Ogólne opcje dla całego moda.",
				es  = "Opciones generales para todo el mod.",
				vi  = "Các tùy chọn chung cho toàn bộ mod.",
			},
		},
		
		EXTRAS =
		{
			NAME =
			{
				"Miscellaneous Options",
				zh  = "其他选项",
				zht = "其他選項",
				pt  = "Opções de Miscelânea",
				pl  = "Różne opcje",
				es  = "Opciones varias",
				vi  = "Tùy chọn khác",
			},
			
			HOVER =
			{
				"Miscellaneous options for the mod.",
				zh  = "Mod的其他选项。",
				zht = "該模組的其他選項。",
				pt  = "Opções de miscelânea para o mod.",
				pl  = "Różne opcje dla moda.",
				es  = "Opciones varias para el mod.",
				vi  = "Các tùy chọn linh tinh cho mod.",
			},
		},
		
		EXPERIMENTAL =
		{
			NAME =
			{
				"Experimental Options",
				zh  = "实验性选项",
				zht = "實驗性選項",
				pt  = "Opções Experimentais",
				pl  = "Opcje Eksperymentalne",
				es  = "Opciones Experimentales",
				vi  = "Tùy chọn thử nghiệm",
			},
			
			HOVER =
			{
				"Experimental options for the Mod. Under testing!",
				zh  = "Mod的实验性选项，正在测试中！",
				zht = "模組的實驗性選項，正在測試中！",
				pt  = "Opções experimentais do Mod. Em fase de testes!",
				pl  = "Eksperymentalne opcje moda. W fazie testów!",
				es  = "Opciones experimentales del mod. ¡En fase de prueba!",
				vi  = "Các tùy chọn thử nghiệm cho mod. Đang được kiểm tra!",
			},
		},
		
		RETROCOMPAT =
		{
			NAME =
			{
				"Retrofit Options",
				zh  = "改造选项",
				zht = "改造選項",
				pt  = "Opções de Retrofit",
				pl  = "Opcje modernizacji",
				es  = "Opciones de Retrofit",
				vi  = "Tùy chọn cải tạo",
			},
			
			HOVER =
			{
				"Retrofitting options for old worlds.",
				zh  = "旧世界的改造。",
				zht = "為舊世界提供改造選擇。",
				pt  = "Opções de retrofitting para mundos antigos.",
				pl  = "Opcje modernizacji starych światów.",
				es  = "Opciones de retrofitting para mundos antiguos.",
				vi  = "Tùy chọn cải tạo cho thế giới cũ.",
			},
		},
		
		LANGUAGE =
		{
			NAME =
			{
				"Language",
				zh  = "语言",
				zht = "話",
				pt  = "Idioma",
				pl  = "Język",
				es  = "Idioma",
				vi  = "Ngôn ngữ",
			},

			HOVER =
			{
				"Choose the language for the mod.\nYou can submit your translation in our Discord.",
				zh  = "选择Mod的语言。 \n您可以在我们的 Discord 中提交您的翻译。",
				zht = "選擇模組的語言。 \n您可以在我們的 Discord 中提交您的翻譯。",
				pt  = "Escolha o idioma do Mod.\nVocê pode enviar sua tradução em nosso Discord.",
				pl  = "Wybierz język moda.\nMożesz przesłać swoje tłumaczenie na naszym Discordzie.",
				es  = "Elige el idioma para el mod.\nPuedes enviar tu traducción en nuestro Discord.",
				vi  = "Chọn ngôn ngữ cho mod.\nBạn có thể gửi bản dịch của mình trên Discord của chúng tôi.",
			},

			HOVER_OPTIONS =
			{
				en  = "English",
				zh  = "简体中文",
				zht = "繁體中文",
				pt  = "Português",
				pl  = "Polski",
				es  = "Español",
				vi  = "Tiếng Việt",
				
				DESCRIPTION =
				{
					en  = "Default Localization",
					zh  = "作者: 糖豆罐里好多颜色",
					zht = "作者： 匿名作者",
					pt  = "Autor: Desconhecido",
					pl  = "Autor: Dr_Brzeszczot",
					es  = "Autor: Desconocido",
					vi  = "Tác giả: Saikuno",
				},
			},
		},
		
		SEASONALFOOD =
		{
			NAME =
			{
				"Seasonal Recipes",
				zh  = "季节性食谱",
				zht = "季節性食譜",
				pt  = "Receitas Sazonais",
				pl  = "Przepisy sezonowe",
				es  = "Recetas de temporada",
				vi  = "Công thức theo mùa",
			},
			
			HOVER =
			{
				"Should Seasonal Recipes only be cooked during Special Events?",
				zh  = "季节性的料理是否在特殊活动下才能烹饪？",
				zht = "季節性食譜是否只能在特別活動期間烹飪？",
				pt  = "Permitir que as Receitas Sazonais sejam cozinhadas somente em Eventos Especiais?",
				pl  = "Czy sezonowe przepisy mogą być gotowane tylko podczas specjalnych wydarzeń?",
				es  = "¿Las recetas de temporada solo pueden cocinarse durante eventos especiales?",
				vi  = "Các công thức theo mùa chỉ nên được nấu trong các sự kiện đặc biệt?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Seasonal Recipes can be cooked without restrictions.",
					zh  = "季节性料理烹饪不受任何限制",
					zht = "季節性食譜可在任何時間無限制地烹飪。",
					pt  = "Receitas Sazonais podem ser cozinhadas sem nenhuma restrição.",
					pl  = "Sezonowe przepisy można gotować bez żadnych ograniczeń.",
					es  = "Las recetas de temporada se pueden cocinar sin restricciones.",
					vi  = "Công thức theo mùa có thể được nấu mà không có hạn chế.",
				},
				
				ENABLED =
				{
					"Seasonal Recipes can only be cooked when Special Events are active.",
					zh  = "季节性料理只能在特殊活动开启时烹制。",
					zht = "季節性食譜只能在特別活動進行時烹飪。",
					pt  = "Receitas Sazonais só podem ser cozinhadas durante Eventos Especiais.",
					pl  = "Sezonowe przepisy można gotować tylko wtedy, gdy aktywne są specjalne wydarzenia.",
					es  = "Las recetas de temporada solo se pueden cocinar cuando los eventos especiales están activos.",
					vi  = "Công thức theo mùa chỉ có thể được nấu khi sự kiện đặc biệt đang diễn ra.",
				},
			},
		},
		
		HUMANMEAT =
		{
			NAME =
			{
				"Long Pig Recipes",
				zh  = "人肉食谱",
				zht = "長豬食譜",
				pt  = "Receitas de Carne Humana",
				pl  = "Przepisy z długiego wieprza",
				es  = "Recetas de Cerdo Largo",
				vi  = "Công thức thịt người",
			},
			
			HOVER =
			{
				"Should players drop Long Pigs upon death?\nNote: If disabled, this will cause some Recipes to be uncookable.",
				zh  = "玩家死亡时是否掉落人肉？\n注意：如果禁用，可能会导致无法制作某些料理。",
				zht = "玩家死亡時是否應該掉落長豬？\n注意：如果停用，此設定將導致某些食譜無法烹飪。",
				pt  = "Permitir que Jogadores deixem cair Carne Humana quando morrem?\nNota: Se desabilitado, pode impedir certas comidas de serem feitas.",
				pl  = "Czy gracze powinni upuszczać długiego wieprza po śmierci?\nUwaga: Jeśli ta opcja jest wyłączona, niektóre przepisy staną się niemożliwe do ugotowania.",
				es  = "¿Deberían los jugadores soltar cerdo largo al morir?\nNota: Si se desactiva, algunas recetas no podrán cocinarse.",
				vi  = "Người chơi có nên rơi Thịt Người khi chết?\nLưu ý: Nếu tắt, một số công thức sẽ không thể nấu được.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Players will not drop Long Pigs upon death.",
					zh  = "玩家死亡后不会掉落人肉。",
					zht = "玩家死亡時不會掉落長豬。",
					pt  = "Jogadores não deixarão cair Carne Humana quando morrem.",
					pl  = "Gracze nie upuszczą długiego wieprza po śmierci.",
					es  = "Los jugadores no soltarán cerdo largo al morir.",
					vi  = "Người chơi sẽ không rơi Thịt Người khi chết.",
				},
				
				ENABLED =
				{
					"Players may have a chance to drop Long Pigs upon death.",
					zh  = "玩家死亡后小概率会掉落人肉。",
					zht = "玩家死亡時有機會掉落長豬。",
					pt  = "Jogadores podem ter a chance de deixar cair Carne Humana quando morrem.",
					pl  = "Gracze mogą mieć szansę upuścić długiego wieprza po śmierci.",
					es  = "Los jugadores pueden tener la posibilidad de soltar cerdo largo al morir.",
					vi  = "Người chơi có thể có cơ hội rơi Thịt Người khi chết.",
				},
			},
		},
		
		COFFEEDROP =
		{
			NAME =
			{
				"Coffee Plant Drop Rate",
				zh  = "咖啡丛掉落数量",
				zht = "咖啡植物掉落率",
				pt  = "Taxa de Drop da Planta de Café",
				pl  = "Wskaźnik wypadania roślin kawy",
				es  = "Tasa de caída de plantas de café",
				vi  = "Tỷ lệ rơi đồ của cây cà phê",
			},
			
			HOVER =
			{
				"How many Coffee Plants should Dragonfly drop?",
				zh  = "龙蝇掉落多少数量的咖啡丛？",
				zht = "龍蠅應掉落多少咖啡植物？",
				pt  = "Quantas Plantas de Café a Libélula deve deixar cair?",
				pl  = "Ile roślin kawy powinna upuścić Smocza Mucha?",
				es  = "¿Cuántas plantas de café debería soltar la Libélula?",
				vi  = "Chuồn chuồn nên thả bao nhiêu cây cà phê?",
			},
			
			HOVER_OPTIONS =
			{
				AMOUNT0 =
				{
					"Dragonfly will not drop Coffee Plants.",
					zh  = "龙蝇不会掉落咖啡丛。",
					zht = "龍蠅不會掉落咖啡植物。",
					pt  = "A Libélula não deixará cair nenhuma Planta de Café.",
					pl  = "Smocza Mucha nie upuści roślin kawy.",
					es  = "La Libélula no soltará plantas de café.",
					vi  = "Chuồn chuồn sẽ không thả cây cà phê.",
				},
				
				AMOUNT4 =
				{
					"Dragonfly will drop 4 Coffee Plants.",
					zh  = "龙蝇会掉4株落咖啡丛。",
					zht = "龍蠅會掉落 4 株咖啡植物。",
					pt  = "A Libélula deixará cair 4 Plantas de Café.",
					pl  = "Smocza Mucha upuści 4 roślin kawy.",
					es  = "La Libélula soltará 4 plantas de café.",
					vi  = "Chuồn chuồn sẽ thả 4 cây cà phê.",
				},
				
				AMOUNT8 =
				{
					"Dragonfly will drop 8 Coffee Plants.",
					zh  = "龙蝇会掉8株落咖啡丛。",
					zht = "龍蠅會掉落 8 株咖啡植物。",
					pt  = "A Libélula deixará cair 8 Plantas de Café.",
					pl  = "Smocza Mucha upuści 8 roślin kawy.",
					es  = "La Libélula soltará 8 plantas de café.",
					vi  = "Chuồn chuồn sẽ thả 8 cây cà phê.",
				},
				
				AMOUNT12 =
				{
					"Dragonfly will drop 12 Coffee Plants.",
					zh  = "龙蝇会掉12株落咖啡丛。",
					zht = "龍蠅會掉落 12 株咖啡植物。",
					pt  = "A Libélula deixará cair 12 Plantas de Café.",
					pl  = "Smocza Mucha upuści 12 roślin kawy.",
					es  = "La Libélula soltará 12 plantas de café.",
					vi  = "Chuồn chuồn sẽ thả 12 cây cà phê.",
				},
				
				AMOUNT16 =
				{
					"Dragonfly will drop 16 Coffee Plants.",
					zh  = "龙蝇会掉16株落咖啡丛。",
					zht = "龍蠅會掉落 16 株咖啡植物。",
					pt  = "A Libélula deixará cair 16 Plantas de Café.",
					pl  = "Smocza Mucha upuści 16 roślin kawy.",
					es  = "La Libélula soltará 16 plantas de café.",
					vi  = "Chuồn chuồn sẽ thả 16 cây cà phê.",
				},
			},
		},
		
		ALCOHOLICDRINKS =
		{
			NAME =
			{
				"Alcoholic Restriction",
				zh  = "酒精限制",
				zht = "酒精限制",
				pt  = "Restrição Alcoólica",
				pl  = "Ograniczenie alkoholu",
				es  = "Restricción alcohólica",
				vi  = "Hạn chế đồ uống có cồn",
			},
			
			HOVER =
			{
				"Should some characters be unable to drink Alcoholic-like drinks?",
				zh  = "是否应该禁止某些角色饮酒？",
				zht = "是否應該禁止某些角色飲酒？",
				pt  = "Permitir que alguns personagens sejam impedidos de beber bebidas alcoólicas?",
				pl  = "Czy niektórzy bohaterowie powinni być niezdolni do picia napojów alkoholowych?",
				es  = "¿Deberían algunos personajes no poder beber bebidas alcohólicas?",
				vi  = "Một số nhân vật có nên không thể uống đồ uống có cồn?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"All characters can drink Alcoholic-like drinks.",
					zh  = "所有角色都能饮酒。",
					zht = "所有角色都能飲酒。",
					pt  = "Todos os personagens podem beber bebidas alcoólicas.",
					pl  = "Wszyscy bohaterowie mogą pić napoje alkoholowe.",
					es  = "Todos los personajes pueden beber bebidas alcohólicas.",
					vi  = "Tất cả nhân vật đều có thể uống đồ uống có cồn.",
				},
				
				ENABLED =
				{
					"Some characters like Webber, Wendy, etc. can't drink Alcoholic-like drinks.",
					zh  = "一些角色，比如韦伯，温蒂等。不能饮酒。",
					zht = "一些角色，比如韋伯、溫蒂等，不能飲酒。",
					pt  = "Alguns personagens como Webber, Wendy, etc. Não poderão beber bebidas alcoólicas.",
					pl  = "Niektórzy bohaterowie, tacy jak Webber, Wendy itp. nie mogą pić napojów alkoholowych.",
					es  = "Algunos personajes como Webber, Wendy, etc. no podrán beber bebidas alcohólicas.",
					vi  = "Một số nhân vật như Webber, Wendy, v.v. không thể uống đồ uống có cồn.",
				},
			},
		},
		
		GIANTSPAWNING =
		{
			NAME =
			{
				"Giants From Foods",
				zh  = "特殊Boss料理",
				zht = "特殊Boss料理",
				pt  = "Spawn de Gigantes das Comidas",
				pl  = "Giganci z jedzenia",
				es  = "Gigantes de la comida",
				vi  = "Khổng lồ từ thức ăn",
			},
			
			HOVER =
			{
				"Should Players spawn Giants when eating their special food?",
				zh  = "如果玩家吃了含boss掉落物的特殊料理，boss是否应该出现？",
				zht = "如果玩家吃了含Boss掉落物的特殊料理，Boss是否應該出現？",
				pt  = "Permitir que Gigantes apareçam se Jogadores comerem suas comidas especiais?",
				pl  = "Czy giganci powinni się pojawiać, gdy gracze jedzą swoje specjalne potrawy?",
				es  = "¿Deberían aparecer gigantes cuando los jugadores coman sus comidas especiales?",
				vi  = "Người chơi có nên triệu hồi Khổng Lồ khi ăn món ăn đặc biệt của họ?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Players will not spawn Giants when eating their special foods.",
					zh  = "玩家在食用某些料理时不会产生Boss。",
					zht = "玩家在食用某些料理時不會產生Boss。",
					pt  = "Jogadores não irão spawnar Gigantes quando comerem suas comidas especiais.",
					pl  = "Gracze nie przywołają gigantów po zjedzeniu swoich specjalnych potraw.",
					es  = "Los jugadores no invocarán gigantes al comer sus comidas especiales.",
					vi  = "Người chơi sẽ không triệu hồi Khổng Lồ khi ăn món ăn đặc biệt.",
				},
				
				ENABLED =
				{
					"Players will spawn Giants when eating their special foods.",
					zh  = "玩家在食用某些料理时会产生Boss。",
					zht = "玩家在食用某些料理時會產生Boss。",
					pt  = "Jogadores irão spawnar Gigantes quando comerem suas comidas especiais.",
					pl  = "Gracze przywołają gigantów po zjedzeniu swoich specjalnych potraw.",
					es  = "Los jugadores invocarán gigantes al comer sus comidas especiales.",
					vi  = "Người chơi sẽ triệu hồi Khổng Lồ khi ăn món ăn đặc biệt.",
				},
			},
		},
		
		ICEBOXSTACKSIZE =
		{
			NAME =
			{
				"Elastispacer for Fridges",
				zh  = "冰箱的弹性空间",
				zht = "冰箱的彈性空間",
				pt  = "Elastipaçador para Geladeiras",
				pl  = "Elastispacer do lodówek",
				es  = "Elastiespaciador para refrigeradores",
				vi  = "Elastispacer cho tủ lạnh",
			},
			
			HOVER =
			{
				"Should Elastispacer be able to upgrade Ice Box and Salt Box?\nNote: If disabled afterwards, may cause visual glitches.",
				zh  = "弹性空间制造器是否可以升级冰箱和盐盒？\n注意: 若升级后禁用可能会导致视觉上的问题。",
				zht = "彈性空間製造器是否可以升級冰箱和鹽盒？\n注意： 若升級後停用，可能會導致視覺問題。",
				pt  = "Permitir que o Elastipaçador funcione para Geladeiras?\nNota:Pode causar erros visuais se for desabilitado posteriormente.",
				pl  = "Czy Elastispacer powinien móc ulepszać lodówki i solne skrzynie?\nUwaga: Wyłączenie później może powodować błędy wizualne.",
				es  = "¿Debería el Elastiespaciador poder mejorar las neveras y las cajas de sal?\nNota: Si se desactiva posteriormente, puede causar errores visuales.",
				vi  = "Elastispacer có nên nâng cấp Ice Box và Salt Box?\nLưu ý: Nếu tắt sau đó có thể gây lỗi hiển thị.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Elastispacer will not upgrade Ice Box and Salt Box.",
					zh  = "弹性空间制造器不可以升级冰箱和盐盒。",
					zht = "彈性空間製造器不可以升級冰箱和鹽盒。",
					pt  = "O Elastipaçador não irá funcionar para Geladeiras.",
					pl  = "Elastispacer nie będzie ulepszał lodówek ani solnych skrzyń.",
					es  = "El Elastiespaciador no mejorará las neveras ni las cajas de sal.",
					vi  = "Elastispacer sẽ không nâng cấp Ice Box và Salt Box.",
				},
				
				ENABLED =
				{
					"Elastispacer will upgrade Ice Box and Salt Box for infinite item stacks.",
					zh  = "弹性空间制造器可以升级冰箱和盐盒，食物堆叠无上限。",
					zht = "彈性空間製造器可以升級冰箱和鹽盒，食物堆疊無上限。",
					pt  = "O Elastipaçador irá funcionar para Geladeiras, permitindo pilhas infinitas de itens.",
					pl  = "Elastispacer ulepszy lodówki i solne skrzynie, umożliwiając nieskończone stosy przedmiotów.",
					es  = "El Elastiespaciador mejorará las neveras y las cajas de sal, permitiendo pilas infinitas de objetos.",
					vi  = "Elastispacer sẽ nâng cấp Ice Box và Salt Box để xếp chồng vật phẩm vô hạn.",
				},
			},
		},
		
		COFFEESPEED =
		{
			NAME =
			{
				"Speed Effect From Foods",
				zh  = "移速Buff",
				zht = "移速Buff",
				pt  = "Efeito de Velocidade",
				pl  = "Efekt prędkości",
				es  = "Efecto de velocidad",
				vi  = "Hiệu ứng tốc độ từ thức ăn",
			},
			
			HOVER =
			{
				"Should the foods give the Speed Effect when eaten?\n\This option only applies to certain foods.",
				zh  = "料理是否提供移速Buff？\n该项仅作用于特定料理",
				zht = "料理是否提供移速Buff？\n該項僅作用於特定料理",
				pt  = "Permitir que as comidas proporcionem Efeito de Velocidade?\n\Isto só se aplica à certas comidas.",
				pl  = "Czy jedzenie powinno dawać efekt prędkości po spożyciu?\nTa opcja dotyczy tylko niektórych potraw.",
				es  = "¿Deberían los alimentos otorgar el efecto de velocidad al consumirse?\nEsta opción solo se aplica a ciertos alimentos.",
				vi  = "Thức ăn có nên cho Hiệu ứng Tốc độ khi ăn?\n\Tùy chọn này chỉ áp dụng cho một số món ăn.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Foods will not give the Speed Effect when eaten.",
					zh  = "料理食用后不会提高移速Buff。",
					zht = "料理食用後不會提高移速Buff。",
					pt  = "As comidas não irão proporcionar o Efeito de Velocidade quando ingeridas.",
					pl  = "Jedzenie nie będzie dawało efektu prędkości po spożyciu.",
					es  = "Los alimentos no otorgarán el efecto de velocidad al consumirse.",
					vi  = "Thức ăn sẽ không cho Hiệu ứng Tốc độ khi ăn.",
				},
				
				ENABLED =
				{
					"Foods will give the Speed Effect when eaten.",
					zh  = "料理食用后会提高移速Buff。",
					zht = "料理食用後會提高移速Buff。",
					pt  = "As comidas irão proporcionar o Efeito de Velocidade quando ingeridas.",
					pl  = "Jedzenie będzie dawało efekt prędkości po spożyciu.",
					es  = "Los alimentos otorgarán el efecto de velocidad al consumirse.",
					vi  = "Thức ăn sẽ cho Hiệu ứng Tốc độ khi ăn.",
				},
			},
		},
		
		COFFEEDURATION =
		{
			NAME =
			{
				"Speed Effect Duration",
				zh  = "移速Buff持续时间",
				zht = "移速Buff持續時間",
				pt  = "Duração do Efeito de Velocidade",
				pl  = "Czas trwania efektu prędkości",
				es  = "Duración del efecto de velocidad",
				vi  = "Thời gian hiệu ứng tốc độ",
			},
			
			HOVER =
			{
				"How long should the Speed Effect from foods last?",
				zh  = "料理提供的移速Buff可以持续多久？",
				zht = "料理提供的移速Buff可以持續多久？",
				pt  = "O quão longo deve ser o Efeito de Velocidade das comidas?",
				pl  = "Jak długo powinien trwać efekt prędkości z jedzenia?",
				es  = "¿Cuánto debería durar el efecto de velocidad otorgado por los alimentos?",
				vi  = "Hiệu ứng Tốc độ từ thức ăn nên kéo dài bao lâu?",
			},
			
			HOVER_OPTIONS =
			{
				SUPERSHORT =
				{
					NAME =
					{
						"Very Short",
						zh  = "超级短",
						zht = "超級短",
						pt  = "Super Curto",
						pl  = "Bardzo krótki",
						es  = "Muy corto",
						vi  = "Rất ngắn",
					},
					
					HOVER =
					{
						"Speed Effect will last for 2 Minutes.",
						zh  = "移速Buff会持续2分钟。",
						zht = "移速Buff會持續2分鐘。",
						pt  = "O Efeito de Velocidade irá durar por 2 minutos.",
						pl  = "Efekt prędkości będzie trwał 2 minuty.",
						es  = "El efecto de velocidad durará 2 minutos.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài 2 phút.",
					},
				},
				
				SHORT =
				{
					NAME =
					{
						"Short",
						zh  = "短",
						zht = "短",
						pt  = "Curto",
						pl  = "Krótki",
						es  = "Corto",
						vi  = "Ngắn",
					},
					
					HOVER =
					{
						"Speed Effect will last for a Half Day.",
						zh  = "移速Buff会持续半天。",
						zht = "移速Buff會持續半天。",
						pt  = "O Efeito de Velocidade irá durar por meio dia.",
						pl  = "Efekt prędkości będzie trwał przez pół dnia.",
						es  = "El efecto de velocidad durará medio día.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài nửa ngày.",
					},
				},
				
				NORMAL =
				{
					NAME =
					{
						"Default",
						zh  = "默认",
						zht = "默認",
						pt  = "Padrão",
						pl  = "Domyślny",
						es  = "Predeterminado",
						vi  = "Mặc định",
					},
					
					HOVER =
					{
						"Speed Effect will last for 1 Day.",
						zh  = "移速Buff会持续一天。",
						zht = "移速Buff會持續一天。",
						pt  = "O Efeito de Velocidade irá durar 1 dia.",
						pl  = "Efekt prędkości będzie trwał 1 dzień.",
						es  = "El efecto de velocidad durará 1 día.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài 1 ngày.",
					},
				},
				
				AVERAGE =
				{
					NAME =
					{
						"Average",
						zh  = "平均",
						zht = "平均",
						pt  = "Mediano",
						pl  = "Średni",
						es  = "Promedio",
						vi  = "Trung bình",
					},
					
					HOVER =
					{
						"Speed Effect will last for 1.5 Days.",
						zh  = "移速Buff会持续1.5天。",
						zht = "移速Buff會持續1.5天。",
						pt  = "O Efeito de Velocidade irá durar 1 dia e meio.",
						pl  = "Efekt prędkości będzie trwał 1.5 dnia.",
						es  = "El efecto de velocidad durará 1.5 días.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài 1.5 ngày.",
					},
				},
				
				LONG =
				{
					NAME =
					{
						"Long",
						zh  = "长",
						zht = "長",
						pt  = "Longo",
						pl  = "Długi",
						es  = "Largo",
						vi  = "Dài",
					},
					
					HOVER =
					{
						"Speed Effect will last for 2 Days.",
						zh  = "移速Buff会持续2天。",
						zht = "移速Buff會持續2天。",
						pt  = "O Efeito de Velocidade irá durar 2 dias.",
						pl  = "Efekt prędkości będzie trwał 2 dni.",
						es  = "El efecto de velocidad durará 2 días.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài 2 ngày.",
					},
				},
				
				SUPERLONG =
				{
					NAME =
					{
						"Very Long",
						zh  = "非常长",
						zht = "非常長",
						pt  = "Super Longo",
						pl  = "Bardzo długi",
						es  = "Muy largo",
						vi  = "Rất dài",
					},
					
					HOVER =
					{
						"Speed Effect will last for 4 Days.",
						zh  = "移速Buff会持续4天",
						zht = "移速Buff會持續4天",
						pt  = "O Efeito de Velocidade irá durar 4 dias.",
						pl  = "Efekt prędkości będzie trwał 4 dni.",
						es  = "El efecto de velocidad durará 4 días.",
						vi  = "Hiệu ứng Tốc độ sẽ kéo dài 4 ngày.",
					},
				},
			},
		},
		
		SCRAPBOOK =
		{
			NAME =
			{
				"Mod Scrapbook",
				zh  = "Mod图鉴",
				zht = "Mod圖鑑",
				pt  = "Scrapbook do Mod",
				pl  = "Księga modyfikacji",
				es  = "Scrapbook del Mod",
				vi  = "Sổ tay Mod",
			},
			
			HOVER =
			{
				"Should the Mod's contents be added to the Scrapbook?",
				zh  = "Mod的内容是否添加到图鉴？",
				zht = "是否應將Mod的內容添加到圖鑑？",
				pt  = "Permitir que os conteúdos do Mod sejam adicionados ao Scrapbook?",
				pl  = "Czy zawartość moda powinna być dodana do księgi?",
				es  = "¿Deberían añadirse los contenidos del mod al Scrapbook?",
				vi  = "Nội dung của mod có nên được thêm vào Sổ tay?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Default Scrapbook.",
					zh  = "默认图鉴。",
					zht = "預設圖鑑。",
					pt  = "Scrapbook Padrão.",
					pl  = "Domyślna księga.",
					es  = "Scrapbook predeterminado.",
					vi  = "Sổ tay mặc định.",
				},
				
				ENABLED =
				{
					"Mod's contents will be added to the Scrapbook.",
					zh  = "Mod的内容将添加到图鉴",
					zht = "Mod的内容将添加到图鉴",
					pt  = "Os conteúdos do Mod serão adicionados ao Scrapbook.",
					pl  = "Zawartość moda zostanie dodana do księgi.",
					es  = "Los contenidos del mod se añadirán al Scrapbook.",
					vi  = "Nội dung của mod sẽ được thêm vào Sổ tay.",
				},
			},
		},
		
		WARLYRECIPES =
		{
			NAME =
			{
				"Chef's Specials Cookbook Page",
				zh  = "沃利的特色食谱页面",
				zht = "沃利的特色食譜頁面",
				pt  = "Página Especiais do Chef",
				pl  = "Strona Kuchnia Specjalności Warly'ego",
				es  = "Página de Especialidades del Chef",
				vi  = "Trang Công thức Đặc biệt của Đầu bếp",
			},
			
			HOVER =
			{
				"Should Warly's Recipes appear on \"Chef's Specials\" instead of \"Mod Recipes\" in the Cookbook?",
				zh  = "在烹饪指南中，沃利的Mod特色料理是否应该出现在\"大厨特色菜\"分页，而不是\"模组食谱\"分页？",
				zht = "在烹飪指南中，沃利的Mod特色料理是否應該出現在\"大廚特色菜\"分頁，而不是\"模組食譜\"分頁？",
				pt  = "Permitir que as Receitas do Warly apareçam na página \"Especiais do Chefe\" ao invés de \"Receitas do Mod\" no Livro de Receitas?",
				pl  = "Czy przepisy Warly'ego powinny pojawiać się na stronie \"Specjalności Szefa\" zamiast w \"Przepisach Moda\" w książce kucharskiej?",
				es  = "¿Deberían las recetas de Warly aparecer en la página \"Especialidades del Chef\" en lugar de en \"Recetas del Mod\" en el libro de cocina?",
				vi  = "Công thức của Warly có nên xuất hiện trong \"Đặc sản Đầu bếp\" thay vì \"Công thức Mod\" trong Sách nấu ăn?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Warly's Recipes will appear on \"Mod Recipes\" page of the Cookbook.",
					zh  = "在烹饪指南中，沃利的Mod特色料理会出现在\"模组食谱\"分页。",
					zht = "在烹飪指南中，沃利的Mod特色料理會出現在\"模組食譜\"分頁。",
					pt  = "As Receitas do Warly irão aparecer na página \"Receitas do Mod\" no Livro de Receitas.",
					pl  = "Przepisy Warly'ego pojawią się na stronie \"Przepisy Moda\" w książce kucharskiej.",
					es  = "Las recetas de Warly aparecerán en la página \"Recetas del Mod\" del libro de cocina.",
					vi  = "Công thức của Warly sẽ xuất hiện trong trang \"Công thức Mod\" của Sách nấu ăn.",
				},
				
				ENABLED =
				{
					"Warly's Recipes will appear on \"Chef's Specials\" page of the Cookbook.",
					zh  = "在烹饪指南中，沃利的Mod特色料理会出现在\"大厨特色菜\"分页。",
					zht = "在烹飪指南中，沃利的Mod特色料理會出現在\"大廚特色菜\"分頁。",
					pt  = "As Receitas do Warly irão aparecer na página \"Especiais do Chefe\" no Livro de Receitas.",
					pl  = "Przepisy Warly'ego pojawią się na stronie \"Specjalności Szefa\" w książce kucharskiej.",
					es  = "Las recetas de Warly aparecerán en la página \"Especialidades del Chef\" del libro de cocina.",
					vi  = "Công thức của Warly sẽ xuất hiện trong trang \"Đặc sản Đầu bếp\" của Sách nấu ăn.",
				},
			},
		},
		
		WARLYSPICES =
		{
			NAME =
			{
				"Chef's Complementary Spices",
				zh  = "厨师的辅助香料",
				zht = "廚師的輔助香料",
				pt  = "Temperos Complementares do Chef",
				pl  = "Zonunkhira Zowonjezera za Chef",
				es  = "Especias Complementarias del Chef",
				vi  = "Gia vị bổ sung của Đầu bếp",
			},
			
			HOVER =
			{
				"Should Warly be able to craft and use an array of new Mod Spices?\nNot recommended to be disabled afterwards.",
				zh  = "Warly 是否应该能够制作并使用一系列新的模组香料？\n不建议之后将其禁用。",
				zht = "Warly 是否應該能夠製作並使用一系列新的模組香料？\n不建議之後將其停用。",
				pt  = "Permitir que Warly fabrique e use uma variedade de novos Temperos do Mod?\nNão é recomendado desativar depois.",
				pl  = "Czy Warly powinien mieć możliwość tworzenia i używania nowych przypraw z modów?\nNie zaleca się wyłączania tej opcji później.",
				es  = "¿Debería Warly poder fabricar y usar una variedad de nuevas Especias de Mods?\nNo se recomienda desactivarlo posteriormente.",
				vi  = "Warly có nên có thể chế tạo và sử dụng nhiều loại Gia vị Mod mới?\nKhông khuyến khích tắt sau đó.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Warly will only be able to craft and use Vanilla Spices.",
					zh  = "Warly 只能制作并使用原版香料。",
					zht = "Warly 只能製作並使用原版香料。",
					pt  = "Warly só poderá fabricar e usar Temperos padrões.",
					pl  = "Warly będzie mógł tworzyć i używać wyłącznie domyślnych przypraw.",
					es  = "Warly solo podrá fabricar y usar Especias Vanilla.",
					vi  = "Warly chỉ có thể chế tạo và sử dụng Gia vị mặc định.",
				},
				
				ENABLED =
				{
					"Warly will be able to craft and use Vanilla and Mod Spices.",
					zh  = "Warly 可以制作并使用原版和模组香料。",
					zht = "Warly 可以製作並使用原版與模組香料。",
					pt  = "Warly poderá fabricar e usar Temperos padrões e do Mod.",
					pl  = "Warly będzie mógł tworzyć i używać zarówno domyślnych, jak i modowanych przypraw.",
					es  = "Warly podrá fabricar y usar Especias Vanilla y del Mod.",
					vi  = "Warly sẽ có thể chế tạo và sử dụng cả Gia vị mặc định và Gia vị Mod.",
				},
			},
		},
		
		WARLYGRINDER =
		{
			NAME =
			{
				"Portable Grinding Mill Recipes",
				zh  = "便携式研磨器食谱",
				zht = "便攜式研磨器食譜",
				pt  = "Receitas do Moinho de Moagem",
				pl  = "Przepisy przenośnego młyna Warly'ego",
				es  = "Recetas del Molino Portátil",
				vi  = "Công thức Cối xay cầm tay",
			},
			
			HOVER =
			{
				"Should Warly's Portable Grinding Mill have the recipes from Mealing Stone?",
				zh  = "沃利的便携式研磨器是否可以拥有碾磨石的功能？",
				zht = "沃利的便攜式研磨器是否可以擁有碾磨石的功能？",
				pt  = "Permitir que o Moinho de Moagem do Warly tenha as receitas da Pedra de Preparação?",
				pl  = "Czy przenośny młyn Warly'ego powinien mieć przepisy z Kamienia Mielenia?",
				es  = "¿Debería el Molino Portátil de Warly tener las recetas de la Piedra de Molienda?",
				vi  = "Cối xay cầm tay của Warly có nên có công thức từ Mealing Stone?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Warly's Portable Grinding Mill will not have the recipes from Mealing Stone.",
					zh  = "沃利的便携式研磨器不会拥有碾磨石的功能。",
					zht = "沃利的便攜式研磨器不會擁有碾磨石的功能。",
					pt  = "O Moinho de Moagem do Warly não terá as receitas da Pedra de Preparação.",
					pl  = "Przenośny młyn Warly'ego nie będzie miał przepisów z Kamienia Mielenia.",
					es  = "El Molino Portátil de Warly no tendrá las recetas de la Piedra de Molienda.",
					vi  = "Cối xay cầm tay của Warly sẽ không có công thức từ Mealing Stone.",
				},
				
				ENABLED =
				{
					"Warly's Portable Grinding Mill will have the recipes from Mealing Stone.",
					zh  = "沃利的便携式研磨器会拥有碾磨石的功能。",
					zht = "沃利的便攜式研磨器會擁有碾磨石的功能。",
					pt  = "O Moinho de Moagem do Warly terá as receitas da Pedra de Preparação.",
					pl  = "Przenośny młyn Warly'ego będzie miał przepisy z Kamienia Mielenia.",
					es  = "El Molino Portátil de Warly tendrá las recetas de la Piedra de Molienda.",
					vi  = "Cối xay cầm tay của Warly sẽ có công thức từ Mealing Stone.",
				},
			},
		},
		
		KEEPFOOD =
		{
			NAME =
			{
				"Halt Food Spoilage",
				zh  = "防止食物腐败",
				zht = "防止食物腐敗",
				pt  = "Parar Deteorização da Comida",
				pl  = "Zatrzymaj psucie się jedzenia",
				es  = "Detener la descomposición de alimentos",
				vi  = "Ngăn hư hỏng thức ăn",
			},
			
			HOVER =
			{
				"Should food spoil if it's inside the Crock Pot?",
				zh  = "料理在烹饪锅中是否变质？",
				zht = "料理在烹飪鍋中是否變質？",
				pt  = "Permitir que as comidas estraguem se estiverem na Panela?",
				pl  = "Czy jedzenie powinno się psuć, jeśli jest w garnku Crock Pot?",
				es  = "¿Debería la comida echarse a perder si está dentro de la Olla?",
				vi  = "Thức ăn có nên hỏng nếu ở trong Crock Pot?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Food will spoil inside Crock Pot, Portable Crock Pot, etc.",
					zh  = "料理在烹饪锅、便携式烹饪锅等锅中会变质。",
					zht = "料理在烹飪鍋、便攜式烹飪鍋等鍋中會變質。",
					pt  = "As comidas estragarão na Panela, Panela Portátil, etc.",
					pl  = "Jedzenie będzie się psuć w garnku Crock Pot, przenośnym Crock Pot itp.",
					es  = "La comida se echará a perder dentro de la Olla, Olla portátil, etc.",
					vi  = "Thức ăn sẽ hỏng trong Crock Pot, Portable Crock Pot, v.v.",
				},
				
				ENABLED =
				{
					"Food will not spoil inside Crock Pot, Portable Crock Pot, etc.",
					zh  = "料理在烹饪锅、便携式烹饪锅等锅中不会变质。",
					zht = "料理在烹飪鍋、便攜式烹飪鍋等鍋中不會變質。",
					pt  = "As comidas não estragarão na Panela, Panela Portátil, etc.",
					pl  = "Jedzenie nie będzie się psuć w garnku Crock Pot, przenośnym Crock Pot itp.",
					es  = "La comida no se echará a perder dentro de la Olla, Olla portátil, etc.",
					vi  = "Thức ăn sẽ không hỏng trong Crock Pot, Portable Crock Pot, v.v.",
				},
			},
		},
		
		FERTILIZERTWEAK =
		{
			NAME =
			{
				"Bucket-o-Poop Recipe",
				zh  = "便便桶配方",
				zht = "便便桶配方",
				pt  = "Receita do Balde de Cocô",
				pl  = "Przepis na Wiadro Kupu",
				es  = "Receta del Cubo de Caca",
				vi  = "Công thức Bucket-o-Poop",
			},
			
			HOVER =
			{
				"Should Bucket-o-Poop use the Bucket instead of its default recipe?",
				zh  = "便便桶是否用于挤奶而不是默认功能？",
				zht = "便便桶是否用於擠奶而不是預設功能？",
				pt  = "Permitir que o Balde de Cocô use o Balde ao invés de seus ingredientes padrões?",
				pl  = "Czy Wiadro Kupu powinno używać Wiadra zamiast swojej domyślnej receptury?",
				es  = "¿Debería el Cubo de Caca usar el Cubo en lugar de su receta predeterminada?",
				vi  = "Bucket-o-Poop có nên dùng Bucket thay vì công thức mặc định?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Bucket-o-Poop will not use the Bucket. (Default crafting recipe).",
					zh  = "便便桶使用默认功能。",
					zht = "便便桶使用預設功能。",
					pt  = "O Balde de Cocô não irá usar o Balde. (Ingredientes padrão).",
					pl  = "Wiadro Kupu nie będzie używać Wiadra. (Domyślna receptura).",
					es  = "El Cubo de Caca no usará el Cubo. (Receta predeterminada).",
					vi  = "Bucket-o-Poop sẽ không dùng Bucket. (Công thức mặc định).",
				},
				
				ENABLED =
				{
					"Bucket-o-Poop will use the Bucket as its crafting ingredient.",
					zh  = "便便桶不使用默认功能，可用于挤奶。",
					zht = "便便桶不使用預設功能，可用於擠奶。",
					pt  = "O Balde de Cocô irá usar o Balde como parte de seus ingredientes.",
					pl  = "Wiadro Kupu będzie używać Wiadra jako składnika w przepisie.",
					es  = "El Cubo de Caca usará el Cubo como ingrediente de su receta.",
					vi  = "Bucket-o-Poop sẽ dùng Bucket làm nguyên liệu chế tạo.",
				},
			},
		},
		
		SCRAPBOOK2 =
		{
			NAME =
			{
				"Extra Mod Scrapbook Information",
				zh  = "额外模组剪贴簿信息",
				zht = "額外模組剪貼簿信息",
				pt  = "Informações Extras Scrapbook do Mod",
				pl  = "Scrapbook Mod Extras",
				es  = "Extras para Scrapbook del Mod",
				vi  = "Thông tin Sổ tay Mod bổ sung",
			},
			
			HOVER =
			{
				"Should additional information about Mod Contents be shown in the Scrapbook?\n\Requires Mod Scrapbook to be enabled.",
				zh  = "是否应在剪贴簿中显示模组内容的附加信息？\n\需要启用 Mod Scrapbook。",
				zht = "是否應在剪貼簿中顯示模組內容的附加資訊？\n\需要啟用 Mod Scrapbook。",
				pt  = "Permitir que informações adicionais sobre conteúdos do Mod sejam mostradas no Scrapbook?\n\Requer que o Scrapbook do Mod esteja ativado.",
				pl  = "Czy w albumie powinny być wyświetlane dodatkowe informacje dotyczące zawartości modyfikacji?\n\Wymagana jest włączona funkcja Mod Scrapbook.",
				es  = "¿Debería mostrarse información adicional sobre el contenido del Mod en el Scrapbook?\n\Requiere que Scrapbook del Mod esté habilitado.",
				vi  = "Có nên hiển thị thông tin bổ sung về Nội dung Mod trong Sổ tay?\n\Yêu cầu bật Sổ tay Mod.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Original Mod Scrapbook without additional information.",
					zh  = "原版Mod剪贴簿，不含其他信息。",
					zht = "原版Mod剪貼簿，不含其他資訊。",
					pt  = "Scrapbook do Mod original sem informações adicionais.",
					pl  = "Oryginalny Mod Scrapbook bez dodatkowych informacji.",
					es  = "Original Scrapbook del Mod sin información adicional.",
					vi  = "Sổ tay Mod gốc không có thông tin bổ sung.",
				},
				
				ENABLED =
				{
					"Mod Scrapbook with additional information.",
					zh  = "Mod Scrapbook，包含更多信息。",
					zht = "Mod Scrapbook，包含更多資訊。",
					pt  = "Scrapbook do Mod com informações adicionais.",
					pl  = "Mod Scrapbook z dodatkowymi informacjami.",
					es  = "Scrapbook del Mod con información adicional.",
					vi  = "Sổ tay Mod có thông tin bổ sung.",
				},
			},
		},
		
		SERENITY_CC =
		{
			NAME =
			{
				"Serenity Archipelago CC",
				zh  = "宁静群岛 CC",
				zht = "寧靜群島 CC",
				pt  = "CC do Arquipélago da Serenidade",
				pl  = "CC Archipelagu Spokoju",
				es  = "CC del Archipiélago de la Serenidad",
				vi  = "CC Quần đảo Serenity",
			},
			
			HOVER =
			{
				"This option is experimental and it's under testing.\n\Should the Serenity Archipelago have special Colour Cubes?", 
				zh  = "此选项为实验性功能，正在测试中。\n是否应为宁静群岛启用特殊 色块？",
				zht = "此選項為實驗性功能，正在測試中。\n是否應為寧靜群島啟用特殊 色塊？",
				pt  = "Esta opção é experimental e está em teste.\nO Arquipélago da Serenidade deve ter Colour Cubes especiais?",
				pl  = "Ta opcja jest eksperymentalna i w fazie testów.\nCzy Archipelag Spokoju powinien mieć specjalne Colour Cubes?",
				es  = "Esta opción es experimental y está en pruebas.\n¿Debería el Archipiélago de la Serenidad tener Colour Cubes especiales?",
				vi  = "Tùy chọn này là thử nghiệm và đang được kiểm tra.\n\Quần đảo Serenity có nên có Colour Cubes đặc biệt?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Default Colour Cubes for the Serenity Archipelago.",
					zh  = "宁静群岛使用默认 色块。",
					zht = "寧靜群島使用預設 色塊。",
					pt  = "Colour Cubes padrão para o Arquipélago da Serenidade.",
					pl  = "Domyślny Colour Cubes dla Archipelagu Spokoju.",
					es  = "Colour Cubes predeterminados para el Archipiélago de la Serenidad.",
					vi  = "Colour Cubes mặc định cho Quần đảo Serenity.",
				},
				
				MARKER =
				{
					NAME = 
					{
						"Marker Mode",
						zh  = "标记模式",
						zht = "標記模式",
						pt  = "Modo Marcador",
						pl  = "Tryb Marker",
						es  = "Modo Marcador",
						vi  = "Chế độ Marker",
					},
					
					HOVER =
					{
						"Marker Mode only works for New/Retrofitted Worlds.",
						zh  = "标记模式仅适用于新世界或已改造的世界。",
						zht = "標記模式僅適用於新世界或已改造的世界。",
						pt  = "Modo Marcador funciona somente em Mundos Novos/Retrofitados.",
						pl  = "Tryb Marker działa tylko w nowych lub poddanych retrofitowi światach.",
						es  = "El Modo Marcador solo funciona en Mundos Nuevos o Retroadaptados.",
						vi  = "Chế độ Marker chỉ hoạt động với Thế giới Mới/Đã cải tạo.",
					},
				},
				
				STATIC =
				{
					NAME =
					{
						"Static Mode",
						zh  = "静态模式",
						zht = "靜態模式",
						pt  = "Modo Estático",
						pl  = "Tryb Statyczny",
						es  = "Modo Estático",
						vi  = "Chế độ Tĩnh",
					},

					HOVER =
					{
						"Static Mode should work for both scenarios. Requires Server Restart.",
						zh  = "静态模式适用于所有场景。需要重启服务器。",
						zht = "靜態模式適用於所有場景。需要重新啟動伺服器。",
						pt  = "Modo Estático funciona para ambos cenários. Requer Restart do Servidor.",
						pl  = "Tryb Statyczny powinien działać w obu scenariuszach. Wymaga ponownego uruchomienia serwera.",
						es  = "El Modo Estático debería funcionar en ambos escenarios. Requiere reiniciar el servidor.",
						vi  = "Chế độ Tĩnh sẽ hoạt động cho cả hai trường hợp. Yêu cầu khởi động lại máy chủ.",
					},
				},
			},
		},
		
		MEADOW_CC =
		{
			NAME =
			{
				"Seaside Island CC",
				zh  = "海滨岛 CC",
				zht = "海濱島 CC",
				pt  = "CC da Ilha Beira-mar",
				pl  = "CC Wyspy Nadmorskiej",
				es  = "CC de la Isla Costera",
				vi  = "CC Đảo ven biển",
			},
			
			HOVER =
			{
				"This option is experimental and it's under testing.\n\Should the Seaside Island have special Colour Cubes?", 
				zh  = "此选项为实验性功能，正在测试中。\n是否应为海滨岛启用特殊 色块？",
				zht = "此選項為實驗性功能，正在測試中。\n是否應為海濱島啟用特殊 色塊？",
				pt  = "Esta opção é experimental e está em teste.\nA Ilha Beira-mar deve ter Colour Cubes especiais?",
				pl  = "Ta opcja jest eksperymentalna i w fazie testów.\nCzy Wyspa Nadmorska powinna mieć specjalny Colour Cubes?",
				es  = "Esta opción es experimental y está en pruebas.\n¿Debería la Isla Costera tener Colour Cubes especiales?",
				vi  = "Tùy chọn này là thử nghiệm và đang được kiểm tra.\n\Đảo ven biển có nên có Colour Cubes đặc biệt?",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Default Colour Cubes for the Seaside Island.",
					zh  = "海滨岛使用默认 色块。",
					zht = "海濱島使用預設 色塊。",
					pt  = "Colour Cubes padrão para a Ilha Beira-mar.",
					pl  = "Domyślny Colour Cubes dla Wyspy Nadmorskiej.",
					es  = "Colour Cubes predeterminados para la Isla Costera.",
					vi  = "Colour Cubes mặc định cho Đảo ven biển.",
				},
				
				MARKER =
				{
					NAME = 
					{
						"Marker Mode",
						zh  = "标记模式",
						zht = "標記模式",
						pt  = "Modo Marcador",
						pl  = "Tryb Marker",
						es  = "Modo Marcador",
						vi  = "Chế độ Marker",
					},
					
					HOVER =
					{
						"Marker Mode only works for New/Retrofitted Worlds.",
						zh  = "标记模式仅适用于新世界或已改造的世界。",
						zht = "標記模式僅適用於新世界或已改造的世界。",
						pt  = "Modo Marcador funciona somente em Mundos Novos/Retrofitados.",
						pl  = "Tryb Marker działa tylko w nowych lub poddanych retrofitowi światach.",
						es  = "El Modo Marcador solo funciona en Mundos Nuevos o Retroadaptados.",
						vi  = "Chế độ Marker chỉ hoạt động với Thế giới Mới/Đã cải tạo.",
					},
				},
				
				STATIC =
				{
					NAME =
					{
						"Static Mode",
						zh  = "静态模式",
						zht = "靜態模式",
						pt  = "Modo Estático",
						pl  = "Tryb Statyczny",
						es  = "Modo Estático",
						vi  = "Chế độ Tĩnh",
					},

					HOVER =
					{
						"Static Mode should work for both scenarios. Requires Server Restart.",
						zh  = "静态模式适用于所有场景。需要重启服务器。",
						zht = "靜態模式適用於所有場景。需要重新啟動伺服器。",
						pt  = "Modo Estático funciona para ambos cenários. Requer Restart do Servidor.",
						pl  = "Tryb Statyczny powinien działać w obu scenariuszach. Wymaga ponownego uruchomienia serwera.",
						es  = "El Modo Estático debería funcionar en ambos escenarios. Requiere reiniciar el servidor.",
						vi  = "Chế độ Tĩnh sẽ hoạt động cho cả hai trường hợp. Yêu cầu khởi động lại máy chủ.",
					},
				},
			},
		},
		
		FULLMOON =
		{
			NAME =
			{
				"Full Moon Transformations",
				zh  = "满月变身",
				zht = "滿月變身",
				pt  = "Transformações da Lua Cheia",
				pl  = "Transformacje Pełni Księżyca",
				es  = "Transformaciones de la Luna Llena",
				vi  = "Biến hình Trăng tròn",
			},
			
			HOVER =
			{
				"Should some things transform during Full Moon Nights?\nCurrently it affects: Mushrooms.",
				zh  = "满月之夜，有些东西会发生变化吗？\n目前受影响的是：蘑菇。",
				zht = "滿月之夜，有些東西會改變嗎？\n目前受影響的是：蘑菇。",
				pt  = "Permitir que algumas coisas se transformem na Lua Cheia?\nAtualmente afeta: Cogumelos.",
				pl  = "Czy niektóre rzeczy powinny ulegać przemianie podczas nocy pełni księżyca?\nAktualnie dotyczy to: Grzybów.",
				es  = "¿Deberían transformarse algunas cosas durante las noches de luna llena?\nActualmente afecta a: los hongos.",
				vi  = "Một số thứ có nên biến hình trong đêm Trăng Tròn?\nHiện tại ảnh hưởng đến: Nấm.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Some things will not transform during Full Moon Nights.",
					zh  = "有些事物在满月之夜不会发生变化。",
					zht = "有些事物在滿月之夜不會改變。",
					pt  = "Algumas coisas não se transformam durante as noites de lua cheia.",
					pl  = "Niektóre rzeczy nie ulegną zmianie podczas nocy pełni księżyca.",
					es  = "Algunas cosas no se transformarán durante las noches de luna llena.",
					vi  = "Một số thứ sẽ không biến hình trong đêm Trăng Tròn.",
				},
				
				ENABLED =
				{
					"Some things will transform during Full Moon Nights.",
					zh  = "满月之夜，有些事物会发生变化。",
					zht = "滿月之夜，有些事物會改變。",
					pt  = "Algumas coisas se transformarão durante as noites de lua cheia.",
					pl  = "Podczas nocy pełni księżyca pewne rzeczy ulegają zmianie.",
					es  = "Algunas cosas se transformarán durante las noches de luna llena.",
					vi  = "Một số thứ sẽ biến hình trong đêm Trăng Tròn.",
				},
			},
		},
		
		AUTORETROFIT =
		{
			NAME =
			{
				"Auto Retrofit",
				zh  = "自动改造",
				zht = "自動改造",
				pt  = "Retrofit Automático",
				pl  = "Automatyczna Modernizacja",
				es  = "Retrofit Automático",
				vi  = "Tự động cải tạo",
			},
			
			HOVER =
			{
				"Should the server check during initialization whether the world needs any retrofits? This option does not auto-disable afterwards.",
				zh  = "服务器是否应在初始化期间每次检查世界是否需要改造？ 此选项之后不会自动禁用。",
				zht = "伺服器是否應在初始化期間每次檢查世界是否需要改造？ 此選項之後不會自動禁用。",
				pt  = "Permitir que o Servidor cheque toda vez se o Mundo precisa de algum Retrofit durante a inicialização? Esta opção não é desativada automaticamente depois.",
				pl  = "Czy serwer powinien sprawdzać za każdym razem, czy świat wymaga modernizacji podczas inicjalizacji? Ta opcja nie zostanie automatycznie wyłączona później.",
				es  = "¿Debe el Servidor comprobar cada vez si el Mundo necesita algún Retrofit durante la inicialización? Esta opción no se desactivará automáticamente después.",
				vi  = "Máy chủ có nên kiểm tra trong lúc khởi tạo xem thế giới có cần cải tạo không? Tùy chọn này sẽ không tự tắt sau đó.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Server will not check for Retrofits during initialization.",
					zh  = "服务器在初始化期间不会检查改造。",
					zht = "伺服器在初始化期間不會檢查改造。",
					pt  = "O Servidor não irá checar por Retrofits durante a inicialização.",
					pl  = "Serwer nie będzie sprawdzał modernizacji podczas inicjalizacji.",
					es  = "El Servidor no comprobará los Retrofits durante la inicialización.",
					vi  = "Máy chủ sẽ không kiểm tra cải tạo trong lúc khởi tạo.",
				},
				
				ENABLED =
				{
					"Server will check for Retrofits during initialization.",
					zh  = "服务器将在初始化期间检查改造。",
					zht = "伺服器將在初始化期間檢查改造。",
					pt  = "O Servidor irá checar por Retrofits durante a inicialização.",
					pl  = "Serwer będzie sprawdzał modernizacje podczas inicjalizacji.",
					es  = "El Servidor comprobará los Retrofits durante la inicialización.",
					vi  = "Máy chủ sẽ kiểm tra cải tạo trong lúc khởi tạo.",
				},
			},
		},
		
		MODTRADES =
		{
			NAME =
			{
				"Retrofit Trades",
				zh  = "贸易转型",
				zht = "貿易轉型",
				pt  = "Retro. de Trocas",
				pl  = "Handel Retrofitowany",
				es  = "Intercambios Retrofitados",
				vi  = "Cải tạo giao dịch",
			},
			
			HOVER =
			{
				"Should Pig King be able to trade items in exchange for Mod items?\nThis also applies to Pig Elder in Lights Out worlds.",
				zh  = "猪王是否应该能够用某些物品来交换 Mod 物品？\n这也适用于熄灯世界中的猪长老。",
				zht = "豬王是否應該能夠用某些物品來交換 Mod 物品？\n這也適用於熄燈世界中的豬長老。",
				pt  = "Permitir que o Rei Porco aceite certos itens em troca de itens do Mod?\nIsso também se aplica ao Porco Ancião em mundos Lights Out.",
				pl  = "Czy Król Świń powinien móc wymieniać przedmioty na przedmioty z moda?\nDotyczy to również Starszego Świni w światach Lights Out.",
				es  = "¿Debería el Rey Cerdo poder intercambiar objetos por objetos del mod?\nEsto también se aplica al Anciano Cerdo en mundos Lights Out.",
				vi  = "Pig King có nên có thể đổi vật phẩm lấy vật phẩm Mod?\nĐiều này cũng áp dụng cho Pig Elder trong thế giới Lights Out.",
			},
			
			HOVER_OPTIONS =
			{
				DISABLED =
				{
					"Certain items can't be traded in exchange for Mod items.",
					zh  = "某些物品无法兑换为Mod物品。",
					zht = "某些物品無法用來兌換模組物品。",
					pt  = "Não será possível fazer trocas por itens do Mod.",
					pl  = "Niektóre przedmioty nie mogą być wymienione na przedmioty z moda.",
					es  = "Ciertos objetos no se pueden intercambiar por objetos del mod.",
					vi  = "Một số vật phẩm không thể đổi lấy vật phẩm Mod.",
				},
				
				ENABLED =
				{
					"Certain items can be traded in exchange for Mod items.",
					zh  = "某些物品可兑换为Mod物品。",
					zht = "某些物品可用來兌換模組物品。",
					pt  = "Será possível fazer trocas por itens do Mod.",
					pl  = "Niektóre przedmioty można wymienić na przedmioty z moda.",
					es  = "Ciertos objetos se pueden intercambiar por objetos del mod.",
					vi  = "Một số vật phẩm có thể đổi lấy vật phẩm Mod.",
				},
			},
		},
	},
}

name                         = ChooseTranslationTable(STRINGS.NAME)
version                      = "5.3-B"

description                  = ChooseTranslationTable(STRINGS.DESCRIPTION)

author                       = "Kyno 󰀃"
api_version                  = 10
priority                     = -15 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible               = true
all_clients_require_mod      = true
client_only_mod              = false

server_filter_tags           = {"Heap of Foods", "HOF", "Cooking", "Entertainment", "Kyno"}

icon                         = "ModiconHOF.tex"
icon_atlas                   = "ModiconHOF.xml"

local NONE_LABEL             = ""
local NONE_OPTIONS           = 
{
	{
		description          = "", 
		data                 = false
	}
}

local TOGGLE_OPTIONS         =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED), 
		data                 = false
	}, 
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED), 
		data                 = true
	},
}

local GENERAL_LABEL          = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.NAME)
local GENERAL_HOVER          = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.HOVER)

local EXTRAS_LABEL           = ChooseTranslationTable(STRINGS.SETTINGS.EXTRAS.NAME)
local EXTRAS_HOVER           = ChooseTranslationTable(STRINGS.SETTINGS.EXTRAS.HOVER)

local EXPERIMENTAL_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.EXPERIMENTAL.NAME)
local EXPERIMENTAL_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.EXPERIMENTAL.HOVER)

local RETROCOMPAT_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.RETROCOMPAT.NAME)
local RETROCOMPAT_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.RETROCOMPAT.HOVER)

local LANGUAGE_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.LANGUAGE.NAME)
local LANGUAGE_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.LANGUAGE.HOVER)
local LANGUAGE_OPTIONS       =
{
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.en,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.en,
		data                 = false
	},
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.zh,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.zh,
		data                 = "zh"
	},
	--[[
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.zht,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.zht,
		data                 = "zht", -- We don't have Traditional Chinese yet.
	},
	]]--
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.pt,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.pt,
		data                 = "pt"
	},
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.pl,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.pl,
		data                 = "pl"
	},
	--[[
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.es,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.es,
		data                 = "es", -- We also don't have Spanish.
	},
	]]--
	{
		description          = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.vi,
		hover                = STRINGS.SETTINGS.LANGUAGE.HOVER_OPTIONS.DESCRIPTION.vi,
		data                 = "vi"
	}
}

local SEASONALFOOD_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.SEASONALFOOD.NAME)
local SEASONALFOOD_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.SEASONALFOOD.HOVER)
local SEASONALFOOD_OPTIONS   =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SEASONALFOOD.HOVER_OPTIONS.DISABLED),
		data                 = true
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SEASONALFOOD.HOVER_OPTIONS.ENABLED),
		data                 = false
	}
}

local HUMANMEAT_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.HUMANMEAT.NAME)
local HUMANMEAT_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.HUMANMEAT.HOVER)
local HUMANMEAT_OPTIONS      =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.HUMANMEAT.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.HUMANMEAT.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local COFFEEDROP_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.NAME)
local COFFEEDROP_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER)
local COFFEEDROP_OPTIONS     =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER_OPTIONS.AMOUNT0),
		data                 = 0
	},
	{
		description          = "4",
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER_OPTIONS.AMOUNT4),
		data                 = 4
	},
	{
		description          = "8",
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER_OPTIONS.AMOUNT8),
		data                 = 8
	},
	{
		description          = "12",
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER_OPTIONS.AMOUNT12),
		data                 = 12
	},
	{
		description          = "16",
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDROP.HOVER_OPTIONS.AMOUNT16),
		data                 = 16
	}
}

local ALCOHOL_LABEL          = ChooseTranslationTable(STRINGS.SETTINGS.ALCOHOLICDRINKS.NAME)
local ALCOHOL_HOVER          = ChooseTranslationTable(STRINGS.SETTINGS.ALCOHOLICDRINKS.HOVER)
local ALCOHOL_OPTIONS        =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.ALCOHOLICDRINKS.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.ALCOHOLICDRINKS.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local GIANTSPAWN_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.GIANTSPAWNING.NAME)
local GIANTSPAWN_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.GIANTSPAWNING.HOVER)
local GIANTSPAWN_OPTIONS     =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.GIANTSPAWNING.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.GIANTSPAWNING.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local ICEBOX_LABEL           = ChooseTranslationTable(STRINGS.SETTINGS.ICEBOXSTACKSIZE.NAME)
local ICEBOX_HOVER           = ChooseTranslationTable(STRINGS.SETTINGS.ICEBOXSTACKSIZE.HOVER)
local ICEBOX_OPTIONS         =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.ICEBOXSTACKSIZE.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.ICEBOXSTACKSIZE.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local COFFEESPEED_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.COFFEESPEED.NAME)
local COFFEESPEED_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.COFFEESPEED.HOVER)
local COFFEESPEED_OPTIONS    =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEESPEED.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEESPEED.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local COFFEETIMER_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.NAME)
local COFFEETIMER_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER)
local COFFEETIMER_OPTIONS    =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SUPERSHORT.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SUPERSHORT.HOVER),
		data                 = 120
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SHORT.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SHORT.HOVER),
		data                 = 240
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.NORMAL.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.NORMAL.HOVER),
		data                 = 480
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.AVERAGE.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.AVERAGE.HOVER),
		data                 = 640
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.LONG.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.LONG.HOVER),
		data                 = 960
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SUPERLONG.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.COFFEEDURATION.HOVER_OPTIONS.SUPERLONG.HOVER),
		data                 = 1920
	}
}

local SCRAPBOOK_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.NAME)
local SCRAPBOOK_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER)
local SCRAPBOOK_OPTIONS      =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local WARLYRECIPES_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.WARLYRECIPES.NAME)
local WARLYRECIPES_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.WARLYRECIPES.HOVER)
local WARLYRECIPES_OPTIONS   =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYRECIPES.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYRECIPES.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local WARLYSPICES_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.WARLYSPICES.NAME)
local WARLYSPICES_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.WARLYSPICES.HOVER)
local WARLYSPICES_OPTIONS    =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYSPICES.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYSPICES.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local WARLYGRINDER_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.WARLYGRINDER.NAME)
local WARLYGRINDER_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.WARLYGRINDER.HOVER)
local WARLYGRINDER_OPTIONS   =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYGRINDER.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.WARLYGRINDER.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local KEEPFOOD_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.KEEPFOOD.NAME)
local KEEPFOOD_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.KEEPFOOD.HOVER)
local KEEPFOOD_OPTIONS       =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.KEEPFOOD.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.KEEPFOOD.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local FERTILIZER_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.FERTILIZERTWEAK.NAME)
local FERTILIZER_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.FERTILIZERTWEAK.HOVER)
local FERTILIZER_OPTIONS     =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.FERTILIZERTWEAK.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.FERTILIZERTWEAK.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local SCRAPBOOK2_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK2.NAME)
local SCRAPBOOK2_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK2.HOVER)
local SCRAPBOOK2_OPTIONS     =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK2.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK2.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local SERENITY_CC_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.NAME)
local SERENITY_CC_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER)
local SERENITY_CC_OPTIONS    =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER_OPTIONS.DISABLED),
		data                 = 0
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER_OPTIONS.MARKER.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER_OPTIONS.MARKER.HOVER),
		data                 = 1
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER_OPTIONS.STATIC.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.SERENITY_CC.HOVER_OPTIONS.STATIC.HOVER),
		data                 = 2
	}
}

local MEADOW_CC_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.NAME)
local MEADOW_CC_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER)
local MEADOW_CC_OPTIONS      =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER_OPTIONS.DISABLED),
		data                 = 0
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER_OPTIONS.MARKER.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER_OPTIONS.MARKER.HOVER),
		data                 = 1
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER_OPTIONS.STATIC.NAME),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.MEADOW_CC.HOVER_OPTIONS.STATIC.HOVER),
		data                 = 2
	}
}

local FULLMOON_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.FULLMOON.NAME)
local FULLMOON_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.FULLMOON.HOVER)
local FULLMOON_OPTIONS       =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.FULLMOON.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.FULLMOON.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local AUTORETROFIT_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.AUTORETROFIT.NAME)
local AUTORETROFIT_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.AUTORETROFIT.HOVER)
local AUTORETROFIT_OPTIONS   =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.AUTORETROFIT.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.AUTORETROFIT.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

local MODTRADES_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.MODTRADES.NAME)
local MODTRADES_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.MODTRADES.HOVER)
local MODTRADES_OPTIONS      =
{
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.MODTRADES.HOVER_OPTIONS.DISABLED),
		data                 = false
	},
	{
		description          = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
		hover                = ChooseTranslationTable(STRINGS.SETTINGS.MODTRADES.HOVER_OPTIONS.ENABLED),
		data                 = true
	}
}

configuration_options        =
{
	{ name                   = "LANGUAGE",         label = LANGUAGE_LABEL,      hover = LANGUAGE_HOVER,      options = LANGUAGE_OPTIONS,      default = false },
	-- General Options.
	{ name                   = "GENERAL",          label = GENERAL_LABEL,       hover = GENERAL_HOVER,       options = NONE_OPTIONS,          default = false },
	{ name                   = "SEASONALFOOD",     label = SEASONALFOOD_LABEL,  hover = SEASONALFOOD_HOVER,  options = SEASONALFOOD_OPTIONS,  default = false },
	{ name                   = "HUMANMEAT",        label = HUMANMEAT_LABEL,     hover = HUMANMEAT_HOVER,     options = HUMANMEAT_OPTIONS,     default = true  },
	{ name                   = "GIANTSPAWNING",    label = GIANTSPAWN_LABEL,    hover = GIANTSPAWN_HOVER,    options = GIANTSPAWN_OPTIONS,    default = true  },
	{ name                   = "ALCOHOLICDRINKS",  label = ALCOHOL_LABEL,       hover = ALCOHOL_HOVER,       options = ALCOHOL_OPTIONS,       default = true  },
	{ name                   = "ICEBOXSTACKSIZE",  label = ICEBOX_LABEL,        hover = ICEBOX_HOVER,        options = ICEBOX_OPTIONS,        default = false },
	{ name                   = "COFFEESPEED",      label = COFFEESPEED_LABEL,   hover = COFFEESPEED_HOVER,   options = COFFEESPEED_OPTIONS,   default = true  },
	{ name                   = "COFFEEDURATION",   label = COFFEETIMER_LABEL,   hover = COFFEETIMER_HOVER,   options = COFFEETIMER_OPTIONS,   default = 480   },
	{ name                   = "COFFEEDROPRATE",   label = COFFEEDROP_LABEL,    hover = COFFEEDROP_HOVER,    options = COFFEEDROP_OPTIONS,    default = 4     },
	-- Miscellaneous Options.
	{ name                   = "EXTRAS",           label = EXTRAS_LABEL,        hover = EXTRAS_HOVER,        options = NONE_OPTIONS,          default = false },
	{ name                   = "SCRAPBOOK",        label = SCRAPBOOK_LABEL,     hover = SCRAPBOOK_HOVER,     options = SCRAPBOOK_OPTIONS,     default = true  },
	{ name                   = "WARLYRECIPES",     label = WARLYRECIPES_LABEL,  hover = WARLYRECIPES_HOVER,  options = WARLYRECIPES_OPTIONS,  default = true  },
	{ name                   = "WARLYSPICES",      label = WARLYSPICES_LABEL,   hover = WARLYSPICES_HOVER,   options = WARLYSPICES_OPTIONS,   default = false },
	{ name                   = "WARLYMEALGRINDER", label = WARLYGRINDER_LABEL,  hover = WARLYGRINDER_HOVER,  options = WARLYGRINDER_OPTIONS,  default = false },
	{ name                   = "KEEPFOOD",         label = KEEPFOOD_LABEL,      hover = KEEPFOOD_HOVER,      options = KEEPFOOD_OPTIONS,      default = false },
	{ name                   = "FERTILIZERTWEAK",  label = FERTILIZER_LABEL,    hover = FERTILIZER_HOVER,    options = FERTILIZER_OPTIONS,    default = false },
	-- Experimental Options.
	{ name                   = "EXPERIMENTAL",     label = EXPERIMENTAL_LABEL,  hover = EXPERIMENTAL_HOVER,  options = NONE_OPTIONS,          default = false },
	{ name                   = "SCRAPBOOK2",       label = SCRAPBOOK2_LABEL,    hover = SCRAPBOOK2_HOVER,    options = SCRAPBOOK2_OPTIONS,    default = false },
	{ name                   = "SERENITY_CC",      label = SERENITY_CC_LABEL,   hover = SERENITY_CC_HOVER,   options = SERENITY_CC_OPTIONS,   default = 0     },
	{ name                   = "MEADOW_CC",        label = MEADOW_CC_LABEL,     hover = MEADOW_CC_HOVER,     options = MEADOW_CC_OPTIONS,     default = 0     },
	{ name                   = "FULLMOONTRANS",    label = FULLMOON_LABEL,      hover = FULLMOON_HOVER,      options = FULLMOON_OPTIONS,      default = false },
	
	-- Retrofitting Options.
	{ name                   = "RETROCOMPAT",      label = RETROCOMPAT_LABEL,   hover = RETROCOMPAT_HOVER,   options = NONE_OPTIONS,          default = false },
	{ name                   = "AUTORETROFIT",     label = AUTORETROFIT_LABEL,  hover = AUTORETROFIT_HOVER,  options = AUTORETROFIT_OPTIONS,  default = false },
	{ name                   = "MODTRADES",        label = MODTRADES_LABEL,     hover = MODTRADES_HOVER,     options = MODTRADES_OPTIONS,     default = true  },
}