
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ЗАПОЛНЕНИЯ ТАБЛИЧНЫХ ЧАСТЕЙ

// Процедура формирует таблицу остатков малоценных активов в незавершенном производстве.
//
Процедура ЗаполнитьМалоценныеАктивыПоОстаткамВЭксплуатации(ДокОбъект, ТаблицаМалоценныеАктивы, СИстекшимСрокомПолезногоИспользования = Ложь, ФизЛицо = Неопределено) Экспорт

	ЭтоДокПеремещение = (ТипЗнч(ДокОбъект.Ссылка) = Тип("ДокументСсылка.ПеремещениеМалоценныхАктивовВЭксплуатации"));
	УказыватьПартию = ДокОбъект.УказыватьПартию;
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("Дата",          ДокОбъект.Дата);
	Запрос.УстановитьПараметр("Организация",   ДокОбъект.Организация);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации", ДокОбъект.ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("СИстекшимСрокомПолезногоИспользования", СИстекшимСрокомПолезногоИспользования);
	
	Запрос.УстановитьПараметр("СФильтромПоФизЛицо", ЗначениеЗаполнено(ФизЛицо));
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	// Если передается ДанныеФормыСтруктура
	Если ДокОбъект.Ссылка.Пустая() Тогда
		Запрос.УстановитьПараметр("Период", Новый Граница(ДокОбъект.Дата, ВидГраницы.Исключая));
	Иначе
		Запрос.УстановитьПараметр("Период",
			Новый Граница(Новый МоментВремени(ДокОбъект.Дата, ДокОбъект.Ссылка), ВидГраницы.Исключая));
	КонецЕсли;
		
	МассивСубконто = Новый Массив(3);
	МассивСубконто[0] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций;
	МассивСубконто[1] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НазначенияИспользования;
	МассивСубконто[2] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПартииМалоценныхАктивовВЭксплуатации;
	Запрос.УстановитьПараметр("СубконтоМЦ", МассивСубконто);
	
	Запрос.УстановитьПараметр("ЭтоДокПеремещение", ЭтоДокПеремещение);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Субконто1                             								КАК ФизЛицо,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.НазначенияИспользования).Владелец КАК Номенклатура,
	|	ХозрасчетныйОстатки.Субконто2                             								КАК НазначениеИспользования,
	|	ВЫБОР КОГДА &ЭтоДокПеремещение = Истина ТОГДА
	|		ХозрасчетныйОстатки.Субконто2
	|	ИНАЧЕ
	|		Неопределено	
	|	КОНЕЦ                                                                                   КАК НазначениеИспользованияНовое,
	|	ХозрасчетныйОстатки.Субконто3                             								КАК ПартияМалоценныхАктивовВЭксплуатации,
	|	ХозрасчетныйОстатки.НалоговоеНазначение 				  								КАК НалоговоеНазначение,
	|	ХозрасчетныйОстатки.КоличествоОстатокДт                   								КАК Количество,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.НазначенияИспользования).Владелец.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	1                   									  								КАК Коэффициент
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|		               &Период,
	|		               Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МалоценныеАктивыВЭксплуатации),
	|		               &СубконтоМЦ,
	|		               Организация = &Организация
	|		               И ((&СФильтромПоФизЛицо И Субконто1 = &ФизЛицо) ИЛИ (&СФильтромПоФизЛицо = ЛОЖЬ))
	|		               И Субконто3.ПодразделениеОрганизации = &ПодразделениеОрганизации
	|		               ) КАК ХозрасчетныйОстатки
	|
	|ГДЕ
	|	// С истекшим сроком хранения
	|	((&СИстекшимСрокомПолезногоИспользования
	|		И ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(Субконто3.Дата, ДЕНЬ), МЕСЯЦ, Субконто2.СрокПолезногоИспользования) < НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ))
	|	ИЛИ (&СИстекшимСрокомПолезногоИспользования = ЛОЖЬ))
	|";
	
	ОстаткиМЦ = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаМЦ Из ОстаткиМЦ Цикл
		
		Если СтрокаМЦ.Количество < 0 Тогда
			
			СтрокаМЦ.Количество 	   = 0;
			ТекстСообщения = НСтр("ru='Строка номер ';uk='Рядок номер '") + СтрокаМЦ.НомерСтроки  
			            + Символы.ПС + СтрокаМЦ.ФизЛицо + ", "
						+ СтрокаМЦ.Номенклатура + ", " 
						+ СтрокаМЦ.НазначениеИспользования + ":"
						+ Символы.ПС + Символы.Таб + НСтр("ru='Отрицательные остатки <';uk=""Від'ємні залишки <""") 
						+ СтрокаМЦ.Количество + " " + СтрокаМЦ.ЕдиницаИзмерения +">!";
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
		КонецЕсли;
		
		Если НЕ УказыватьПартию Тогда
			
			СтрокаМЦ.ПартияМалоценныхАктивовВЭксплуатации = Неопределено;
			
		КонецЕсли;
		
	КонецЦикла; 

	ТаблицаМалоценныеАктивы.Загрузить(ОстаткиМЦ);

КонецПроцедуры
