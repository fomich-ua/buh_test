#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Ведомость";
	КомандаПечати.Представление = НСтр("ru='Накладная на оприходование товаров';uk='Накладна на оприбуткування товарів'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокументаОбщая";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Оприходование товаров""';uk='Реєстр документів ""Оприбуткування товарів""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры // ДобавитьКомандыПечати

// Функция формирует табличный документ с печатной формой, разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма 
//
Функция ПечатьОприходованиеТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;

	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	КонецЕсли;
	
	ЗапросДокумент = Новый Запрос;
	
	ЗапросДокумент.Текст = "
	|ВЫБРАТЬ
	|	ОприходованиеТоваров.Номер,
	|	ОприходованиеТоваров.Дата,
	|	ОприходованиеТоваров.Организация,
	|	ОприходованиеТоваров.СуммаДокумента,
	|	Константы.ВалютаРегламентированногоУчета КАК ВалютаДокумента,
	|	ОприходованиеТоваров.Склад,
	|	1 КАК ID,
	|	ОприходованиеТоваров.Товары.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура,
	|		Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Цена,
	|		Сумма
	|	),
	|	ОприходованиеТоваров.БланкиСтрогогоУчета.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Цена,
	|		Сумма)
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров,
	|	Константы КАК Константы
	|ГДЕ
	|	ОприходованиеТоваров.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	  
	  
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеТоваров_Ведомость";

	Макет = УправлениеПечатью.ПолучитьМакет("Документ.ОприходованиеТоваров.ПФ_MXL_Накладная");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗапросДокумент.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Шапка = ЗапросДокумент.Выполнить().Выбрать();

		Шапка.Следующий();

		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
	    ВыборкаСтрокБланки = Шапка.БланкиСтрогогоУчета.Выбрать();
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Оприходование товаров';uk='Оприбуткування товарів'",КодЯзыкаПечать),КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата,,,КодЯзыкаПечать);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеОрганизации;
		ОбластьМакета.Параметры.Получатель = Шапка.Организация;
		ТабДокумент.Вывести(ОбластьМакета);

		СписокДополнительныхПараметров = "Склад,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка, СписокДополнительныхПараметров, КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
		
		Для Каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = ТекстКодАртикул;
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		КоличествоТоваров = 0;

		Пока ВыборкаСтрокТовары.Следующий() Цикл

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда

				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 не заполнено значение номенклатуры - строка при печати пропущена.';uk='У рядку %1 не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), ВыборкаСтрокТовары.НомерСтроки), СтатусСообщения.Важное);

				Продолжить;

			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Вывести(ОбластьМакета);
			
			КоличествоТоваров = КоличествоТоваров + 1;

		КонецЦикла;
		
		Пока ВыборкаСтрокБланки.Следующий() Цикл

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокБланки.Номенклатура) Тогда

				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 не заполнено значение номенклатуры - строка при печати пропущена.';uk='У рядку %1 не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), ВыборкаСтрокТовары.НомерСтроки), СтатусСообщения.Важное);

				Продолжить;

			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокБланки);
			ОбластьМакета.Параметры.НомерСтроки 	 = ОбластьМакета.Параметры.НомерСтроки + КоличествоТоваров;
			ТабДокумент.Вывести(ОбластьМакета);

		КонецЦикла;

		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.СуммаДокумента);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '", КодЯзыкаПечать) 
												 + ВыборкаСтрокТовары.Количество() + ВыборкаСтрокБланки.Количество() 
		                                         + НСтр("ru=', на сумму ';uk=', на суму '", КодЯзыкаПечать) 
												 + ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.СуммаДокумента, Шапка.ВалютаДокумента);
												 
		ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента, КодЯзыкаПечать);
												 
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");

		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		ОбластьМакета.Параметры.Заполнить(ВыборкаПоКомиссии);
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
	
	Возврат ТабДокумент;

КонецФункции // ПечатьОприходованиеТоваров()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Ведомость") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Ведомость", НСтр("ru='Накладная на оприходование товаров';uk='Накладна на оприбуткування товарів'"), 
			ПечатьОприходованиеТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ОприходованиеТоваров.ПФ_MXL_Накладная", , Истина);
	КонецЕсли;
 	
КонецПроцедуры // Печать

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Склад");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область ПрограммныйИнтерфейс

// Заполняет счета учета номенклатуры в табличной части документа
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСчетаУчетаВТабличнойЧасти

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти = "", СведенияОНоменклатуре, ЗаполнятьБУ = Истина, ЗаполнятьНУ = Истина) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчетаБУ") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗаполнятьБУ Тогда
		ЗаполнитьСчетаБУ(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЕсли; 
	Если ЗаполнятьНУ Тогда
		ЗаполнитьСчетаНУ(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЕсли; 

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти

// Заполняет счета БУ в строке табличной части.
Процедура ЗаполнитьСчетаБУ(Объект, СтрокаТЧ, ИмяТабЧасти, СчетаУчета)

	Если ВРег(ИмяТабЧасти) = ВРег("БланкиСтрогогоУчета") Тогда
		
		СтрокаТЧ.СчетУчетаБУ             = СчетаУчета.СчетУчетаБУ;
		СтрокаТЧ.СчетУчетаЗабалансовыйБУ = СчетаУчета.СчетУчетаДоп;
	
	Иначе
		
		СтрокаТЧ.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;
			
	КонецЕсли;


КонецПроцедуры // ЗаполнитьСчетаБУ()

// Заполняет счета НУ в строке табличной части.
Процедура ЗаполнитьСчетаНУ(Объект, СтрокаТЧ, ИмяТабЧасти, СчетаУчета)
	
	СтрокаТЧ.НалоговоеНазначение 		= СчетаУчета.НалоговоеНазначение;

КонецПроцедуры // ЗаполнитьСчетаНУ()

Функция БланкиСтрогогоУчетаПолучитьЦенуНоминальную(Номенклатура, Дата) Экспорт

	ЦенаНоминальная = 0;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата",         Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЦеныНоменклатуры.Цена	
	|ИЗ
	|	РегистрСведений.НоминальнаяСтоимостьБланковСтрогогоУчета.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК ЦеныНоменклатуры";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЦенаНоминальная = Выборка.Цена;		
	КонецЕсли;

	Возврат ЦенаНоминальная;

КонецФункции // БланкиСтрогогоУчетаПолучитьЦенуНоминальную

Функция ПолучитьСоответствиеВидовОперацийФормам() Экспорт

	ФормыОприходованиеТоваров = Новый Соответствие;
	
	ФормыОприходованиеТоваров.Вставить(Перечисления.ВидыОперацийОприходованиеТоваров.ТоварыПродукция, 	    "ФормаДокументаОбщая");
	ФормыОприходованиеТоваров.Вставить(Перечисления.ВидыОперацийОприходованиеТоваров.Оборудование, 			"ФормаДокументаОбщая");
	ФормыОприходованиеТоваров.Вставить(Перечисления.ВидыОперацийОприходованиеТоваров.БланкиСтрогогоУчета, 	"ФормаДокументаОбщая");
	
	Возврат ФормыОприходованиеТоваров;

КонецФункции 

Функция ОпределитьВидОперацииПоДокументуОснованию(Основание) Экспорт

	Результат = Перечисления.ВидыОперацийОприходованиеТоваров.ТоварыПродукция;

	Возврат Результат;

КонецФункции

Функция ПолучитьФиксированныйМассивВидовОпераций() Экспорт

	МассивВидовОпераций = Новый Массив;
	СписокВидовОпераций = Новый СписокЗначений;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ВидыОперацийОприходованиеТоваров.ЗначенияПеречисления;
	Для Каждого ЗначениеПеречисления Из ЗначенияПеречисления Цикл
		ТекущийВидОперации = Перечисления.ВидыОперацийОприходованиеТоваров[ЗначениеПеречисления.Имя];
		МассивВидовОпераций.Добавить(ТекущийВидОперации);
	КонецЦикла;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьБланкиСтрогогоУчета") Тогда
		ИндексНайденныйЭлемент = МассивВидовОпераций.Найти(Перечисления.ВидыОперацийОприходованиеТоваров.БланкиСтрогогоУчета);
		Если ИндексНайденныйЭлемент <> Неопределено Тогда
    		МассивВидовОпераций.Удалить(ИндексНайденныйЭлемент);
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(МассивВидовОпераций);

КонецФункции // ПолучитьФиксированныйМассивВидовОпераций

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаДокумента"
		И ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	ВидОперации = Неопределено; 

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВидОперации");
	КонецЕсли;

	// Если документ копируется, то вид формы получаем из копируемого документа.
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначениеКопирования")
			И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Параметры.ЗначениеКопирования, "ВидОперации");
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") 
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда
			Если Параметры.ЗначенияЗаполнения.Свойство("ВидОперации") Тогда
				ВидОперации = Параметры.ЗначенияЗаполнения.ВидОперации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("Основание")
			И ЗначениеЗаполнено(Параметры.Основание) Тогда
			ВидОперации = ОпределитьВидОперацииПоДокументуОснованию(Параметры.Основание);
		КонецЕсли;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ФормыОприходованиеТоваров = ПолучитьСоответствиеВидовОперацийФормам();
	ВыбраннаяФорма = ФормыОприходованиеТоваров[ВидОперации];
	Если ВыбраннаяФорма = Неопределено Тогда
		ВыбраннаяФорма = "ФормаДокумента";
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПолученияФормы

#КонецОбласти 

#КонецЕсли