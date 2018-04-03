#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	Если ЗначениеЗаполнено(Склад) Тогда
		ОтветственноеЛицо = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(Склад, Дата);
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата 		  = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры // ПриКопировании

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
	Если ТипСклада <> Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ЦенаВРознице");
	
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУчет");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	Для каждого Строка Из Товары Цикл
		
		Префикс = "Товары[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru='Товары';uk='Товари'");
		
		Если Строка.Количество = 0 И Строка.КоличествоУчет = 0 Тогда
			
			ИмяПоля = НСтр("ru='Количество';uk='Кількість'");
			Поле = Префикс + "Количество";
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
			ИмяПоля = НСтр("ru='Количество учетное';uk='Кількість облікова'");
			Поле = Префикс + "КоличествоУчет";
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения

#КонецОбласти 
	
#Область СлужебныеПроцедурыИФункции	

// Заполняет документ по остаткам на складе
Процедура ЗаполнитьПоОстаткамНаСкладе() Экспорт

	СписокСкладов = Новый Массив();
	Если ЗначениеЗаполнено(Склад) Тогда
		СписокСкладов.Добавить(Склад);
	Иначе
		ЗапросПоСкладам = Новый Запрос();
		ЗапросПоСкладам.УстановитьПараметр("МОЛ", ОтветственноеЛицо);
		ЗапросПоСкладам.УстановитьПараметр("КонецПериода",    Дата);
		ЗапросПоСкладам.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаСрезПоследних.СтруктурнаяЕдиница
		|ИЗ
		|	РегистрСведений.ОтветственныеЛица.СрезПоследних(&КонецПериода, ФизическоеЛицо = &МОЛ) КАК ОтветственныеЛицаСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтветственныеЛицаСрезПоследних.СтруктурнаяЕдиница";
		
		Выборка   = ЗапросПоСкладам.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.СтруктурнаяЕдиница = NULL Тогда
				Продолжить;
			КонецЕсли;
			СписокСкладов.Добавить(Выборка.СтруктурнаяЕдиница);
		КонецЦикла;
	КонецЕсли;
	
	ДанныеСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ТипСклада, ТипЦенРозничнойТорговли");
	
	ВестиСкладскойУчетБУ         = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетПоСкладам(ПланыСчетов.Хозрасчетный.ТоварыНаСкладе);
	ВестиСуммовойУчетПоСкладамБУ = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяСуммовойУчетПоСкладам(ПланыСчетов.Хозрасчетный.ТоварыНаСкладе);
	
	ТекстУсловияКоличество = ?(ВестиСкладскойУчетБУ, "И Субконто2 В (&Склад)", "");
	ТекстУсловияСумма      = ?(ВестиСуммовойУчетПоСкладамБУ, "И Субконто2 В (&Склад)", "");
	
	ПорядокСубконтоКоличество = Новый Массив();
	ПорядокСубконтоКоличество.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ВестиСкладскойУчетБУ Тогда
		ПорядокСубконтоКоличество.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	
	ПорядокСубконтоСумма = Новый Массив();
	ПорядокСубконтоСумма.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ВестиСуммовойУчетПоСкладамБУ Тогда
		ПорядокСубконтоСумма.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	
	ПорядокСубконтоМОЛ = Новый Массив();
	ПорядокСубконтоМОЛ.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ПорядокСубконтоМОЛ.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций);
	
	МассивИсклСчетов = Новый Массив();
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ);
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТорговаяНаценкаАТТ);
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТорговаяНаценкаНТТ);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Склад",          	 		СписокСкладов);
	Запрос.УстановитьПараметр("МОЛ",	 			 		ОтветственноеЛицо);
	Запрос.УстановитьПараметр("КонецПериода",  		 		Дата);
	Запрос.УстановитьПараметр("Организация",   		 		Организация);
	Запрос.УстановитьПараметр("ПорядокСубконтоКоличество",	ПорядокСубконтоКоличество);
	Запрос.УстановитьПараметр("ПорядокСубконтоСумма",	   	ПорядокСубконтоСумма);
	Запрос.УстановитьПараметр("ПорядокСубконтоМОЛ",	 		ПорядокСубконтоМОЛ);
	Запрос.УстановитьПараметр("ИсклСчета",	 		 		МассивИсклСчетов);
	
	ТекстЗапросаИнвентаризация = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ПОМЕСТИТЬ ВТ_ИсклСчета
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ИсклСчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиКоличество.Счет,
	|	ХозрасчетныйОстаткиКоличество.Субконто1,
	|	ХозрасчетныйОстаткиКоличество.КоличествоОстаток
	|ПОМЕСТИТЬ ХозрасчетныйОстаткиКоличество
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериода, , &ПорядокСубконтоКоличество, Организация В (&Организация) " 
		+ ТекстУсловияКоличество + ") КАК ХозрасчетныйОстаткиКоличество
	|;									
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиСумма.Счет,
	|	ХозрасчетныйОстаткиСумма.Субконто1,
	|	ХозрасчетныйОстаткиСумма.СуммаОстаток,
	|	ХозрасчетныйОстаткиСумма.КоличествоОстаток
	|ПОМЕСТИТЬ ХозрасчетныйОстаткиСумма
	|ИЗ
	|РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериода, , &ПорядокСубконтоСумма, Организация В (&Организация) " 
		+ ТекстУсловияСумма + ") КАК ХозрасчетныйОстаткиСумма
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиКоличество.Счет КАК Счет,
	|	ХозрасчетныйОстаткиКоличество.Счет.Порядок КАК Порядок,
	|	ХозрасчетныйОстаткиКоличество.Субконто1 КАК Номенклатура,
	|	ХозрасчетныйОстаткиКоличество.Субконто1.БланкСтрогогоУчета КАК БланкСтрогогоУчета,
	|	ХозрасчетныйОстаткиКоличество.Субконто1.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
	|
	|	ЕСТЬNULL(ХозрасчетныйОстаткиСумма.СуммаОстаток, 0) КАК СуммаВсего,
	|	ЕСТЬNULL(ХозрасчетныйОстаткиСумма.КоличествоОстаток, 0) КАК КоличествоВсего,
	|	ЕСТЬNULL(ХозрасчетныйОстаткиКоличество.КоличествоОстаток, 0) КАК Количество
	|ИЗ
	|	ХозрасчетныйОстаткиКоличество КАК ХозрасчетныйОстаткиКоличество
	|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиСумма КАК ХозрасчетныйОстаткиСумма
	|		ПО ХозрасчетныйОстаткиКоличество.Счет = ХозрасчетныйОстаткиСумма.Счет
	|			И ХозрасчетныйОстаткиКоличество.Субконто1 = ХозрасчетныйОстаткиСумма.Субконто1
	|ГДЕ
	|	НЕ ХозрасчетныйОстаткиКоличество.Счет В
	|				(ВЫБРАТЬ
	|					ВТ_ИсклСчета.Счет
	|				ИЗ
	|					ВТ_ИсклСчета)";
	
	Если НЕ ЗначениеЗаполнено(Склад) И ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
		
		ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиМОЛ.Счет,
		|	ХозрасчетныйОстаткиМОЛ.Счет.Порядок,
		|	ХозрасчетныйОстаткиМОЛ.Субконто1,
		|	ХозрасчетныйОстаткиМОЛ.Субконто1.БланкСтрогогоУчета КАК БланкСтрогогоУчета,
		|	ХозрасчетныйОстаткиМОЛ.Субконто1.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
		|
		|	ЕСТЬNULL(ХозрасчетныйОстаткиМОЛ.СуммаОстаток, 0),
		|	ЕСТЬNULL(ХозрасчетныйОстаткиМОЛ.КоличествоОстаток, 0),
		|	ЕСТЬNULL(ХозрасчетныйОстаткиМОЛ.КоличествоОстаток, 0)
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериода, , &ПорядокСубконтоМОЛ, Организация В (&Организация) И Субконто2 В (&МОЛ)) КАК ХозрасчетныйОстаткиМОЛ
		|
		|ГДЕ
		|  НЕ (ХозрасчетныйОстаткиМОЛ.Счет В (ВЫБРАТЬ
		|					ВТ_ИсклСчета.Счет
		|				ИЗ
		|					ВТ_ИсклСчета))
		|";
		
	КонецЕсли;
	
	ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Запрос.Текст = ТекстЗапросаИнвентаризация;
	
	Выборка   = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Выборка.БланкСтрогогоУчета Тогда
			Продолжить;
		КонецЕсли;

		СтрокаТабличнойЧасти = Товары.Добавить();

		СтрокаТабличнойЧасти.Номенклатура   = Выборка.Номенклатура;
		СтрокаТабличнойЧасти.Количество     = Выборка.Количество;
		СтрокаТабличнойЧасти.СчетУчетаБУ	= Выборка.Счет;
		СтрокаТабличнойЧасти.КоличествоУчет = СтрокаТабличнойЧасти.Количество;
		
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = Выборка.БазоваяЕдиницаИзмерения;
		СтрокаТабличнойЧасти.Коэффициент      = 1;

		Цена = ?(Выборка.КоличествоВсего = 0, 0, Выборка.СуммаВсего / Выборка.КоличествоВсего);
		
		СтрокаТабличнойЧасти.СуммаУчет = Цена * Выборка.Количество;
		СтрокаТабличнойЧасти.Сумма     = СтрокаТабличнойЧасти.СуммаУчет;
		СтрокаТабличнойЧасти.Цена      = Цена;

		Если ДанныеСклада.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
			СтрокаТабличнойЧасти.ЦенаВРознице = Ценообразование.ПолучитьЦенуНоменклатуры(СтрокаТабличнойЧасти.Номенклатура,
				ДанныеСклада.ТипЦенРозничнойТорговли, Дата, ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), 1, 1);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоОстаткамНаСкладе()

// Процедура перезаполняет учетные количества в документе
Процедура ПерезаполнитьУчетныеКоличества() Экспорт

    СписокСкладов = Новый Массив();
	Если ЗначениеЗаполнено(Склад) Тогда
		СписокСкладов.Добавить(Склад);
	Иначе
		ЗапросПоСкладам = Новый Запрос();
		ЗапросПоСкладам.УстановитьПараметр("МОЛ", ОтветственноеЛицо);
		ЗапросПоСкладам.УстановитьПараметр("КонецПериода",    Дата);
		ЗапросПоСкладам.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаСрезПоследних.СтруктурнаяЕдиница
		|ИЗ
		|	РегистрСведений.ОтветственныеЛица.СрезПоследних(&КонецПериода, ФизическоеЛицо = &МОЛ) КАК ОтветственныеЛицаСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтветственныеЛицаСрезПоследних.СтруктурнаяЕдиница";
		
		Выборка   = ЗапросПоСкладам.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.СтруктурнаяЕдиница = NULL Тогда
				Продолжить;
			КонецЕсли;
			СписокСкладов.Добавить(Выборка.СтруктурнаяЕдиница);
		КонецЦикла;
	КонецЕсли;
	
	
	ДанныеСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ТипСклада, ТипЦенРозничнойТорговли");
	
	ВестиСкладскойУчетБУ         = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетПоСкладам(ПланыСчетов.Хозрасчетный.ТоварыНаСкладе);
	ВестиСуммовойУчетПоСкладамБУ = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяСуммовойУчетПоСкладам(ПланыСчетов.Хозрасчетный.ТоварыНаСкладе);
	
	ТекстУсловияКоличество = ?(ВестиСкладскойУчетБУ, "И Субконто2 В (&Склад)", "");
	ТекстУсловияСумма      = ?(ВестиСуммовойУчетПоСкладамБУ, "И Субконто2 В (&Склад)", "");
	
	ПорядокСубконтоКоличество = Новый Массив();
	ПорядокСубконтоКоличество.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ВестиСкладскойУчетБУ Тогда
		ПорядокСубконтоКоличество.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	
	ПорядокСубконтоСумма = Новый Массив();
	ПорядокСубконтоСумма.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ВестиСуммовойУчетПоСкладамБУ Тогда
		ПорядокСубконтоСумма.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	
	ПорядокСубконтоМОЛ = Новый Массив();
	ПорядокСубконтоМОЛ.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ПорядокСубконтоМОЛ.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций);

	МассивИсклСчетов = Новый Массив();
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ);
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТорговаяНаценкаАТТ);
	МассивИсклСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТорговаяНаценкаНТТ);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Склад",		         		СписокСкладов);
	Запрос.УстановитьПараметр("МОЛ",	 			 		ОтветственноеЛицо);
	Запрос.УстановитьПараметр("КонецПериода",   	 		Дата);
	Запрос.УстановитьПараметр("Организация",     	 		Организация);
	Запрос.УстановитьПараметр("ПорядокСубконтоКоличество",	ПорядокСубконтоКоличество);
	Запрос.УстановитьПараметр("ПорядокСубконтоСумма",	   	ПорядокСубконтоСумма);
	Запрос.УстановитьПараметр("ПорядокСубконтоМОЛ",	 		ПорядокСубконтоМОЛ);
	Запрос.УстановитьПараметр("ИсклСчета",	 		 		МассивИсклСчетов);
	Запрос.УстановитьПараметр("ДокументСсылка", 	 		Ссылка);
	
	ТекстЗапросаИнвентаризация = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ПОМЕСТИТЬ ВТ_ИсклСчета
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ИсклСчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнвентаризацияТоваровНаСкладеТовары.Номенклатура КАК Номенклатура,
	|	ИнвентаризацияТоваровНаСкладеТовары.СчетУчетаБУ  КАК СчетУчетаБУ,
	|	ИнвентаризацияТоваровНаСкладеТовары.НомерСтроки  КАК НомерСтроки
	|ПОМЕСТИТЬ ВложенныйЗапрос
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК ИнвентаризацияТоваровНаСкладеТовары
	|ГДЕ
	|	ИнвентаризацияТоваровНаСкладеТовары.Ссылка = &ДокументСсылка
	|	И НЕ ИнвентаризацияТоваровНаСкладеТовары.СчетУчетаБУ В
	|				(ВЫБРАТЬ
	|					ВТ_ИсклСчета.Счет
	|				ИЗ
	|					ВТ_ИсклСчета)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнвентаризацияТоваровНаСкладеТовары.Номенклатура КАК Номенклатура,
	|	ИнвентаризацияТоваровНаСкладеТовары.СчетУчетаБУ  КАК СчетУчетаБУ,
	|	ИнвентаризацияТоваровНаСкладеТовары.НомерСтроки  КАК НомерСтроки
	|ПОМЕСТИТЬ ВложенныйЗапрос2
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК ИнвентаризацияТоваровНаСкладеТовары
	|ГДЕ
	|	ИнвентаризацияТоваровНаСкладеТовары.Ссылка = &ДокументСсылка
	|	И НЕ ИнвентаризацияТоваровНаСкладеТовары.СчетУчетаБУ В
	|				(ВЫБРАТЬ
	|					ВТ_ИсклСчета.Счет
	|				ИЗ
	|					ВТ_ИсклСчета)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиКоличество.Счет,
	|	ХозрасчетныйОстаткиКоличество.Субконто1,
	|	ХозрасчетныйОстаткиКоличество.КоличествоОстаток
	|ПОМЕСТИТЬ ХозрасчетныйОстаткиКоличество
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериода, , &ПорядокСубконтоКоличество, Организация В (&Организация) " 
		+ ТекстУсловияКоличество + ") КАК ХозрасчетныйОстаткиКоличество
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиСумма.Счет,
	|	ХозрасчетныйОстаткиСумма.Субконто1,
	|	ХозрасчетныйОстаткиСумма.СуммаОстаток,
	|	ХозрасчетныйОстаткиСумма.КоличествоОстаток
	|ПОМЕСТИТЬ ХозрасчетныйОстаткиСумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериода, , &ПорядокСубконтоСумма, Организация В (&Организация) " 
		+ ТекстУсловияСумма + ") КАК ХозрасчетныйОстаткиСумма
	|;
	|";
	
	Если НЕ ЗначениеЗаполнено(Склад) И ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
		
		ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиМОЛ.Счет,
		|	ХозрасчетныйОстаткиМОЛ.Субконто1,
		|	ХозрасчетныйОстаткиМОЛ.СуммаОстаток,
		|	ХозрасчетныйОстаткиМОЛ.КоличествоОстаток
		|ПОМЕСТИТЬ ХозрасчетныйОстаткиМОЛ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&КонецПериода,
		|				,
		|				&ПорядокСубконтоМОЛ,
		|				Организация В (&Организация)
		|					И Субконто2 В (&МОЛ)) КАК ХозрасчетныйОстаткиМОЛ
		|;
		|";
	КонецЕсли;
	
	ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиСумма.СуммаОстаток), 0) КАК СуммаВсего,
	|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиСумма.КоличествоОстаток), 0) КАК КоличествоВсего,
	|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиКоличество.КоличествоОстаток), 0) КАК Количество,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
    |	ВложенныйЗапрос.Номенклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
	|	ВложенныйЗапрос.СчетУчетаБУ КАК СчетУчетаБУ
	|ИЗ
	|	ВложенныйЗапрос КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиКоличество КАК ХозрасчетныйОстаткиКоличество
	|		ПО (ХозрасчетныйОстаткиКоличество.Субконто1 = ВложенныйЗапрос.Номенклатура)
	|			И (ХозрасчетныйОстаткиКоличество.Счет = ВложенныйЗапрос.СчетУчетаБУ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиСумма КАК ХозрасчетныйОстаткиСумма
	|		ПО (ХозрасчетныйОстаткиСумма.Субконто1 = ВложенныйЗапрос.Номенклатура)
	|			И (ХозрасчетныйОстаткиСумма.Счет = ВложенныйЗапрос.СчетУчетаБУ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.НомерСтроки,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.СчетУчетаБУ
	|";
	
	Если НЕ ЗначениеЗаполнено(Склад) И ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
		ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиМОЛ.СуммаОстаток), 0) КАК СуммаВсего,
		|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиМОЛ.КоличествоОстаток), 0) КАК КоличествоВсего,
		|	ЕСТЬNULL(СУММА(ХозрасчетныйОстаткиМОЛ.КоличествоОстаток), 0) КАК Количество,
		|	ВложенныйЗапрос2.НомерСтроки,
		|	ВложенныйЗапрос2.Номенклатура,
    	|	ВложенныйЗапрос2.Номенклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
		|	ВложенныйЗапрос2.СчетУчетаБУ
		|ИЗ
		|	ВложенныйЗапрос2 КАК ВложенныйЗапрос2
		|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиМОЛ КАК ХозрасчетныйОстаткиМОЛ
		|		ПО (ХозрасчетныйОстаткиМОЛ.Субконто1 = ВложенныйЗапрос2.Номенклатура)
		|			И (ХозрасчетныйОстаткиМОЛ.Счет = ВложенныйЗапрос2.СчетУчетаБУ)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос2.НомерСтроки,
		|	ВложенныйЗапрос2.Номенклатура,
		|	ВложенныйЗапрос2.СчетУчетаБУ
		|";
	КонецЕсли;
	
	ТекстЗапросаИнвентаризация = ТекстЗапросаИнвентаризация + "
	|
	|УПОРЯДОЧИТЬ ПО
	|   НомерСтроки";
	
	Запрос.Текст = ТекстЗапросаИнвентаризация;
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();	
	ТаблицаЗапроса.Свернуть("НомерСтроки", "СуммаВсего, КоличествоВсего, Количество");
	
	Для Каждого СтрокаТабличнойЧасти ИЗ Товары Цикл

		СтрокаЗапроса = ТаблицаЗапроса.Найти(СтрокаТабличнойЧасти.НомерСтроки, "НомерСтроки");
		
		Если НЕ ЗначениеЗаполнено(СтрокаЗапроса) Тогда
			СтрокаТабличнойЧасти.КоличествоУчет = 0;
			СтрокаТабличнойЧасти.СуммаУчет      = 0;
			Продолжить;
		КонецЕсли;
		
		Если СтрокаЗапроса.Количество <= 0 Тогда
			СтрокаТабличнойЧасти.КоличествоУчет = 0;
			СтрокаТабличнойЧасти.СуммаУчет      = 0;
			Продолжить;
		КонецЕсли;

		СтрокаТабличнойЧасти.КоличествоУчет = СтрокаЗапроса.Количество / СтрокаТабличнойЧасти.Коэффициент;
		
		Цена = ?(СтрокаЗапроса.КоличествоВсего = 0, 0, СтрокаЗапроса.СуммаВсего / СтрокаЗапроса.КоличествоВсего);
		
		СтрокаТабличнойЧасти.СуммаУчет = Цена * СтрокаЗапроса.Количество;
		СтрокаТабличнойЧасти.Цена      = Цена;
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);

	КонецЦикла;
	
КонецПроцедуры // ПерезаполнитьУчетныеКоличества()

#КонецОбласти 



#КонецЕсли