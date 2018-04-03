#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект) Экспорт

	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
		Объект.Организация,
		Объект.Контрагент,
		Объект.ДоговорКонтрагента);

	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателяПриБартере;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
	КонецЕсли;
	Объект.СчетУчетаРасчетовПоАвансам     = Объект.СчетУчетаРасчетовСКонтрагентом;
	Объект.СчетУчетаРасчетовПоТаре        = СчетаУчета.СчетУчетаТарыПокупателя;
	Объект.СчетУчетаРасчетовПоТареПоАвансам = Объект.СчетУчетаРасчетовПоТаре;
	
	Объект.СчетУчетаНДС                   = СчетаУчета.СчетУчетаНДСПродаж;
	Объект.СчетУчетаНДСПодтвержденный     = СчетаУчета.СчетУчетаНДСПродажПодтвержденный;

КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, Реализация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Реализация = Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// ЗАПОЛНЕНИЕ ДОКУМЕНТА

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

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
	
	Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
		СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "Товары" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетПередачиБУ) Тогда
			СтрокаТабличнойЧасти.ПереданныеСчетУчетаБУ = СчетаУчета.СчетПередачиБУ;
		КонецЕсли;
		
	КонецЕсли;

	Если ЗначениеЗаполнено(СчетаУчета.СхемаРеализации) Тогда
		СтрокаТабличнойЧасти.СхемаРеализации = СчетаУчета.СхемаРеализации;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
		СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначениеДоходовИЗатрат) Тогда
		СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
	КонецЕсли;

КонецПроцедуры

// Функция возвращает таблицу значений для заполнение табличной части Товары по документу основанию.
// При заполнении копируется состав документа.
//
// Параметры:
//  ДанныеОбъекта     - данные текущего объекта.
//  ДокументОснование - ссылка на документ основание.
//
Функция ТоварыПоДаннымОснования(ДанныеОбъекта, ДокументОснование) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ОснованиеРеализацияТоваров      = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг");
	ДокументОснованиеИмя            = ДокументОснование.Метаданные().Имя;
	
	ТаблицаЗначенийТовары = ДанныеОбъекта.Товары.Выгрузить().СкопироватьКолонки();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование",  ДокументОснование);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДанныеОбъекта.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Сделка",             ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка.ВалютаДокумента,";
	
	Если ОснованиеРеализацияТоваров Тогда
		Запрос.Текст = Запрос.Текст + "
		|	ВЫБОР КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
		|		Док.Ссылка.КурсВзаиморасчетов
		|	ИНАЧЕ
		|		1
		|	КОНЕЦ КАК КурсДокумента,
		|	ВЫБОР КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
		|		Док.Ссылка.КратностьВзаиморасчетов
		|	ИНАЧЕ
		|		1
		|	КОНЕЦ КАК КратностьДокумента,";
	Иначе
		Запрос.Текст = Запрос.Текст + "
		|	1 КАК КратностьДокумента,
		|	1 КАК КурсДокумента,";
	КонецЕсли;
	
	
	Запрос.Текст = Запрос.Текст + "
	|	Док.Ссылка.СуммаВключаетНДС,
	|	Док.Номенклатура,
	|	Док.Количество,
	|	Док.ЕдиницаИзмерения,
	|	Док.Коэффициент,
	|	Док.СтавкаНДС,
	|	Док.Цена,
	|	Док.СуммаБезСкидки,
	|	Док.СуммаСкидки,
	|	Док.СчетУчетаБУ,
	|	Док.СхемаРеализации,
	|	Док.НалоговоеНазначение,
	|	Док.НалоговоеНазначениеДоходовИЗатрат";

	
	ДополнительныеПоляЗапросаРегл = ",
	|	Док.ПереданныеСчетУчетаБУ";
	
	Если ОснованиеРеализацияТоваров Тогда
		Запрос.Текст = Запрос.Текст + ДополнительныеПоляЗапросаРегл + "
		|";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|ИЗ
	|	Документ." + ДокументОснованиеИмя + ".Товары КАК Док
	|
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование И НЕ Док.Номенклатура.Услуга";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	КурсДокумента      = ЗаполнениеДокументов.КурсДокумента(ДанныеОбъекта.Ссылка,      ВалютаРегламентированногоУчета);
	КратностьДокумента = ЗаполнениеДокументов.КратностьДокумента(ДанныеОбъекта.Ссылка, ВалютаРегламентированногоУчета);
	
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗначенийТовары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
		
		
		// Пересчитаем цену в валюту документа (может отличаться от валюты основания).
		Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(СтрокаТабличнойЧасти.Цена,
			Выборка.ВалютаДокумента,    ДанныеОбъекта.ВалютаДокумента,
			Выборка.КурсДокумента,      КурсДокумента,
			Выборка.КратностьДокумента, КратностьДокумента);
		
		СтрокаТабличнойЧасти.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена,
			Выборка.СуммаВключаетНДС,
			ДанныеОбъекта.СуммаВключаетНДС,
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
		
		СуммаСкидки = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Выборка.СуммаСкидки, 
			Выборка.ВалютаДокумента, ДанныеОбъекта.ВалютаДокумента, 
			Выборка.КурсДокумента, КурсДокумента,
			Выборка.КратностьДокумента, КратностьДокумента);
		
		СтрокаТабличнойЧасти.СуммаСкидки = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(СуммаСкидки,
			Выборка.СуммаВключаетНДС,
			ДанныеОбъекта.СуммаВключаетНДС,
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));

		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ДанныеОбъекта.СуммаВключаетНДС);
		
	КонецЦикла;
	
	Возврат ТаблицаЗначенийТовары;
	
КонецФункции

// Функция возвращает таблицу значений для заполнение табличной части Возвратной тары по документу основанию.
// При заполнении копируется состав документа.
//
// Параметры:
//  ДанныеОбъекта     - данные текущего объекта.
//  ДокументОснование - ссылка на документ основание.
//
Функция ВозратнаяТараПоДаннымРеализации(ДанныеОбъекта, ДокументОснование) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ВозвратнаяТараДокумента = ДанныеОбъекта.ВозвратнаяТара.Выгрузить().СкопироватьКолонки();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Док.Ссылка.ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов
	|			ТОГДА Док.Ссылка.КурсВзаиморасчетов
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КурсДокумента,
	|	ВЫБОР
	|		КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов
	|			ТОГДА Док.Ссылка.КратностьВзаиморасчетов
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КратностьДокумента,
	|	Док.СчетУчетаБУ,
	|	Док.СхемаРеализации,
	|	Док.НалоговоеНазначение,
	|	Док.НалоговоеНазначениеДоходовИЗатрат,
	|	Док.Номенклатура,
	|	Док.Количество,
	|	Док.Цена
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.ВозвратнаяТара КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаВозвратнойТары = ВозвратнаяТараДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВозвратнойТары, Выборка);
		
		
		// Пересчитаем цену в валюту взаиморасчетов (в документах договоры могут отличаться).
		СтрокаВозвратнойТары.Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Выборка.Цена,
			Выборка.ВалютаДокумента, ДанныеОбъекта.ВалютаДокумента,
			Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ДанныеОбъекта, ВалютаРегламентированногоУчета),
			Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ДанныеОбъекта, ВалютаРегламентированногоУчета));
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаВозвратнойТары);
		
	КонецЦикла;
	
	Возврат ВозвратнаяТараДокумента;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Возврат от покупателя
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Возврат от покупателя';uk='Повернення від покупця'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Реестр документов ""Возврат товаров от покупателя""';uk='Реєстр документів ""Повернення товарів від покупця""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;

КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
																"Накладная",
																НСтр("ru='Возврат от покупателя';uk='Повернення від покупця'"),
																ПечатьВозвратаОтПокупателя(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),
																,
																"Документ.ВозвратТоваровОтПокупателя.ПФ_MXL_Накладная",
																, Истина);
	КонецЕсли;

КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьВозвратаОтПокупателя(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросШапка = Новый Запрос;
	ЗапросШапка.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	ДоговорКонтрагента.ВидДоговора  КАК ВидДоговораКонтрагента,
	|	Ответственный.ФизЛицо.Наименование КАК Получил,
	|	Склад,
	|	Организация,
	|	Контрагент  КАК Покупатель,
	|	Организация КАК Поставщик,
	|	Сделка,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	|
	|ГДЕ
	|	ВозвратТоваровОтПокупателя.Ссылка = &ТекущийДокумент";
	ЗапросТЧТовары = Новый Запрос;
	ЗапросТЧТовары.Текст =
	"ВЫБРАТЬ
	|	Номенклатура,
	|	Номенклатура.НаименованиеПолное КАК Товар,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.Артикул КАК Артикул,
	|	Количество,
	|	ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Цена,
	|	СуммаБезСкидки,
	|	СуммаСкидки,
	|	Сумма,
	|	СуммаНДС,
	|   НомерСтроки
	|ИЗ 
	|	(ВЫБРАТЬ
	|		Номенклатура         КАК Номенклатура,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Цена                 КАК Цена,
	|		СтавкаНДС            КАК СтавкаНДС,
	|		СУММА(Количество)    КАК Количество,
	|		СУММА(Сумма)         КАК Сумма,
	|		СУММА(СуммаБезСкидки) КАК СуммаБезСкидки,
	|		СУММА(СуммаСкидки)    КАК СуммаСкидки,
	|		СУММА(СуммаНДС)      КАК СуммаНДС,
	|		МИНИМУМ(НомерСтроки) КАК НомерСтроки
	|	ИЗ
	|		Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателя
	|	ГДЕ
	|		ВозвратТоваровОтПокупателя.Ссылка = &ТекущийДокумент
	|	СГРУППИРОВАТЬ ПО
	|		Номенклатура,
	|		ЕдиницаИзмерения,
	|		Цена,
	|		СтавкаНДС
	|	) КАК ВложенныйЗапросПоТоварам
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	ЗапросТЧТара = Новый Запрос;
	ЗапросТЧТара.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Товар,
				   |	ВложенныйЗапрос.Номенклатура.Код                КАК Код,
				   |	ВложенныйЗапрос.Номенклатура.Артикул            КАК Артикул,
				   |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.Цена,
	               |	ВложенныйЗапрос.Сумма,
	               |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		Реализация.Номенклатура КАК Номенклатура,
				   |		Реализация.Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
				   |		Реализация.Цена КАК Цена,
				   |		СУММА(Реализация.Количество) КАК Количество,
	               |		СУММА(Реализация.Сумма) КАК Сумма,
	               |		МИНИМУМ(Реализация.НомерСтроки) КАК НомерСтроки
	               |	ИЗ
	               |		Документ.ВозвратТоваровОтПокупателя.ВозвратнаяТара КАК Реализация
	               |	
	               |	ГДЕ
	               |		Реализация.Ссылка = &ТекущийДокумент
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		Реализация.Номенклатура,
	               |		Реализация.Цена) КАК ВложенныйЗапрос
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВозвратТоваровОтПокупателя_Накладная";

	Макет = УправлениеПечатью.ПолучитьМакет("Документ.ВозвратТоваровОтПокупателя.ПФ_MXL_Накладная");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды = Истина;
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды = Истина;
		Колонка = "Код";
	Иначе
		ВыводитьКоды = Ложь;
	КонецЕсли;
	
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар = Макет.Область("Товар");
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
											Макет.Область("КолонкаКодов").ШиринаКолонки;
											
		ОбластьКолонкаТоварБезСкидок = Макет.Область("ТоварБезСкидок");
		ОбластьКолонкаТоварБезСкидок.ШиринаКолонки = ОбластьКолонкаТоварБезСкидок.ШиринаКолонки + 
											Макет.Область("КолонкаКодовБезСкидок").ШиринаКолонки;
	КонецЕсли;

	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗапросШапка.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Шапка = ЗапросШапка.Выполнить().Выбрать();
		Шапка.Следующий();

		ЗапросТЧТовары.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ЗапросТовары = ЗапросТЧТовары.Выполнить().Выгрузить();
		
		ЗапросТЧТара.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ЗапросТара = ЗапросТЧТара.Выполнить().Выгрузить();	
		
		УчитыватьНДС = УчетнаяПолитика.ПлательщикНДС(Шапка.Организация, Шапка.Дата);
	
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Возвратная накладная от покупателя';uk='Зворотна накладна від покупця'",КодЯзыкаПечать),КодЯзыкаПечать);

		ТабДокумент.Вывести(ОбластьМакета);

		СведенияОПокупателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "НомерСчета,Банк,МФО,/,ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
	    ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПокупателя		= ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПокупателе,"Телефоны,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,Сделка,Склад,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		
		ЕстьСкидки = (ЗапросТовары.Итог("СуммаСкидки") <> 0);
		
		СуффиксОбластиТаблицы = ?(ЕстьСкидки, "", "БезСкидок");
		
		ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы"+СуффиксОбластиТаблицы+"|НомерСтроки"+СуффиксОбластиТаблицы);
		ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы"+СуффиксОбластиТаблицы+"|КолонкаКодов"+СуффиксОбластиТаблицы);
		ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы"+СуффиксОбластиТаблицы+"|Данные"+СуффиксОбластиТаблицы);
		Если ЕстьСкидки Тогда
			ОбластьСкидка = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
		КонецЕсли;
		ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы"+СуффиксОбластиТаблицы+"|Сумма"+СуффиксОбластиТаблицы);
	    
		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		
		// Вывести табличную часть
		Суффикс = "";
		Если УчитыватьНДС Тогда
			Если Шапка.СуммаВключаетНДС Тогда
				Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
			Иначе	
				Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
			КонецЕсли;
			Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
		КонецЕсли;
		ОбластьДанных.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
		ТабДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ТабДокумент.Присоединить(ОбластьСкидка);
		КонецЕсли;
		ОбластьСуммы.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
		ТабДокумент.Присоединить(ОбластьСуммы);

		ОбластьНомера = Макет.ПолучитьОбласть("Строка"+СуффиксОбластиТаблицы+"|НомерСтроки"+СуффиксОбластиТаблицы);
		ОбластьКодов  = Макет.ПолучитьОбласть("Строка"+СуффиксОбластиТаблицы+"|КолонкаКодов"+СуффиксОбластиТаблицы);
		ОбластьДанных = Макет.ПолучитьОбласть("Строка"+СуффиксОбластиТаблицы+"|Данные"+СуффиксОбластиТаблицы);
		Если ЕстьСкидки Тогда
			ОбластьСкидки = Макет.ПолучитьОбласть("Строка|Скидка");
  		КонецЕсли;
		ОбластьСуммы  = Макет.ПолучитьОбласть("Строка"+СуффиксОбластиТаблицы+"|Сумма"+СуффиксОбластиТаблицы);
		
		Сумма    = 0;
		СуммаНДС = 0;
		СуммаБезСкидки	= 0;
		СуммаСкидки 	= 0;
		
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;

			ОбластьНомера.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьКоды Тогда
				Если Колонка = "Артикул" Тогда
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Артикул;
				Иначе
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Код;
				КонецЕсли;
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьДанных);
			
			Если ЕстьСкидки Тогда
				ОбластьСкидки.Параметры.Заполнить(ВыборкаСтрокТовары);
				ТабДокумент.Присоединить(ОбластьСкидки);
			КонецЕсли;

			ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьСуммы);
			
			СуммаБезСкидки = СуммаБезСкидки + ВыборкаСтрокТовары.СуммаБезСкидки;
			СуммаСкидки    = СуммаСкидки    + ВыборкаСтрокТовары.СуммаСкидки;
			Сумма          = Сумма       	+ ВыборкаСтрокТовары.Сумма;
			СуммаНДС       = СуммаНДС    	+ ВыборкаСтрокТовары.СуммаНДС;

		КонецЦикла;

		// Вывести Итого
		ОбластьНомера = Макет.ПолучитьОбласть("Итого"+СуффиксОбластиТаблицы+"|НомерСтроки"+СуффиксОбластиТаблицы);
		ОбластьКодов  = Макет.ПолучитьОбласть("Итого"+СуффиксОбластиТаблицы+"|КолонкаКодов"+СуффиксОбластиТаблицы);
		ОбластьДанных = Макет.ПолучитьОбласть("Итого"+СуффиксОбластиТаблицы+"|Данные"+СуффиксОбластиТаблицы);
		Если ЕстьСкидки Тогда
			ОбластьСкидки = Макет.ПолучитьОбласть("Итого|Скидка");
		КонецЕсли;
		ОбластьСуммы  = Макет.ПолучитьОбласть("Итого"+СуффиксОбластиТаблицы+"|Сумма"+СуффиксОбластиТаблицы);
		
		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
			
		ТабДокумент.Присоединить(ОбластьДанных);
		
		Если ЕстьСкидки Тогда
			ОбластьСкидки.Параметры.ВсегоСуммаБезСкидки = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаБезСкидки);		
			ОбластьСкидки.Параметры.ВсегоСуммаСкидки    = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаСкидки);
			ТабДокумент.Присоединить(ОбластьСкидки);
		КонецЕсли;
		
		ОбластьСуммы.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма);

	    ТабДокумент.Присоединить(ОбластьСуммы);
		// Вывести ИтогоНДС
		Если УчитыватьНДС Тогда
			// НДС
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
				
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС,,"""");
			ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
			ТабДокумент.Вывести(ОбластьМакета);
			
			// всего с НДС (если сумма не включает НДС)
			Если НЕ Шапка.СуммаВключаетНДС Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
				
				ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма + СуммаНДС);
				ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Всього із ПДВ:'",КодЯзыкаПечать);
				ТабДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЕсли;

		// выведем таблицу с возвратной тарой
		Если ЗапросТара.Количество() > 0 Тогда
			// сделаем отступ от основной таблицы
			ОбластьПробел = Макет.ПолучитьОбласть("Пробел");
			ТабДокумент.Вывести(ОбластьПробел);
			
			ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицыТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицыТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицыТара|ДанныеТара");
		
			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьДанных);
			
			ОбластьКолонкаТара = Макет.Область("Тара");
			
			Если Не ВыводитьКоды Тогда
				ОбластьКолонкаТара.ШиринаКолонки = ОбластьКолонкаТара.ШиринаКолонки + 
													Макет.Область("КолонкаКодовТара").ШиринаКолонки;
			КонецЕсли;
		
			ОбластьНомера = Макет.ПолучитьОбласть("СтрокаТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("СтрокаТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("СтрокаТара|ДанныеТара");
			
			СуммаТара    = 0;
			
			Для каждого ВыборкаСтрокТара Из ЗапросТара Цикл 
				
				Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТара.Номенклатура) Тогда
					Сообщить(НСтр("ru='В одной из строк не заполнено значение тары - строка при печати пропущена.';uk='В одному з рядків не заповнене значення тари - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
					Продолжить;
				КонецЕсли;
				
				ОбластьНомера.Параметры.НомерСтроки = ЗапросТара.Индекс(ВыборкаСтрокТара) + 1;
				ТабДокумент.Вывести(ОбластьНомера);
				
				Если ВыводитьКоды Тогда
					Если Колонка = "Артикул" Тогда
						ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТара.Артикул;
					Иначе
						ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТара.Код;
					КонецЕсли;
					ТабДокумент.Присоединить(ОбластьКодов);
				КонецЕсли;
				
				ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТара);
				ОбластьДанных.Параметры.Товар = СокрП(ВыборкаСтрокТара.Товар);
				ТабДокумент.Присоединить(ОбластьДанных);
				
				СуммаТара = СуммаТара + ВыборкаСтрокТара.Сумма;
				
			КонецЦикла;
			
			// Вывести Итого
			ОбластьНомера = Макет.ПолучитьОбласть("ИтогоТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("ИтогоТара|ДанныеТара");
			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
		
			ОбластьДанных.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаТара);
			ТабДокумент.Присоединить(ОбластьДанных);
			
			// сделаем отступ 
			ТабДокумент.Вывести(ОбластьПробел);
		КонецЕсли;
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + ЗапросТовары.Количество() + "," +
												 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента)
												 + ?(ЗапросТара.Количество() = 0, "",  НСтр("ru='; возвратная тара ';uk='; зворотна тара '",КодЯзыкаПечать) + ЗапросТара.Количество() + НСтр("ru=', на сумму ';uk=', на суму '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаТара, Шапка.ВалютаДокумента)) + ".";
												 
		ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
		 										 + ?(НЕ УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));

		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;

	Возврат ТабДокумент;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции


#КонецЕсли