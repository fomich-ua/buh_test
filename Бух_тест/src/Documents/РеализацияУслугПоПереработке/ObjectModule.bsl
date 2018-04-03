#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВалютаРегламентированногоУчета;

Перем КурсЗачетаАвансаРегл;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

//// Процедура заполняет структуры именами реквизитов, которые имеют смысл
//// только для определенного вида учета
////

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуУслуг(РезультатЗапросаПоУслугам, СтруктураШапкиДокумента)

	ТаблицаУслуг = РезультатЗапросаПоУслугам.Выгрузить();
	
	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		// для регламентного учета считаем НДС
		ТаблицаУслуг.ЗаполнитьЗначения(Перечисления.СтавкиНДС.БезНДС, "СтавкаНДС");
		ТаблицаУслуг.ЗаполнитьЗначения(0                            , "НДС");
	КонецЕсли;
	
	ПогрешностиОкругления = Новый Соответствие();
	НалоговыйУчет.ДобавитьКолонкиТоваровРегл(ТаблицаУслуг, СтруктураШапкиДокумента, ПогрешностиОкругления, Ложь);
	
	Возврат ТаблицаУслуг;

КонецФункции // ПодготовитьТаблицуУслуг()

Функция ПодготовитьТаблицуМатериалов(РезультатЗапросаПоМатериалам, СтруктураШапкиДокумента)

	ТаблицаМатериалов = РезультатЗапросаПоМатериалам.Выгрузить();

	ТаблицаМатериалов.Колонки.Добавить("ДокументОприходования");
	ТаблицаМатериалов.Колонки.Добавить("Регистратор");
	ТаблицаМатериалов.Колонки.Добавить("Склад");
	ТаблицаМатериалов.Колонки.Добавить("Контрагент");
	ТаблицаМатериалов.Колонки.Добавить("Организация");
	ТаблицаМатериалов.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаМатериалов.Колонки.Добавить("ОтражениеВНУ");
	ТаблицаМатериалов.Колонки.Добавить("Валюта");
	ТаблицаМатериалов.Колонки.Добавить("ВходящийНДС");
	ТаблицаМатериалов.Колонки.Добавить("КоэффОплаты");

	ТаблицаМатериалов.Колонки.Добавить("КорСчетСписанияБУ");
	ТаблицаМатериалов.Колонки.Добавить("КорСчетСписанияНУ");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияБУ1");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияБУ2");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияБУ3");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияНУ1");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияНУ2");
	ТаблицаМатериалов.Колонки.Добавить("КорСубконтоСписанияНУ3");
	
	КоэффОплаты      = 1;
	ТаблицаМатериалов.ЗаполнитьЗначения(КоэффОплаты,   "КоэффОплаты");
	ТаблицаМатериалов.ЗаполнитьЗначения(ЭтотОбъект,    "Регистратор");
	ТаблицаМатериалов.ЗаполнитьЗначения(СтруктураШапкиДокумента.Контрагент,         "Контрагент");
	ТаблицаМатериалов.ЗаполнитьЗначения(СтруктураШапкиДокумента.ДоговорКонтрагента, "ДоговорКонтрагента");
	ТаблицаМатериалов.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,        "Организация");
	ТаблицаМатериалов.ЗаполнитьЗначения(ПланыСчетов.Хозрасчетный.ПустаяСсылка(),    "КорСчетСписанияБУ");
	Возврат ТаблицаМатериалов;

КонецФункции // ПодготовитьТаблицуТоваров()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА
//

Функция ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ)
	
	ТаблицаПоВторомуСобытиюНал = НалоговыйУчет.СоздатьСтруктуруТаблицыНалоговыхСумм();

	Если Не СтруктураШапкиДокумента.ЕстьНДС Тогда
		// Если не нужно отражать в налоговом учете, тогда не отражаем и в подсистеме учета НДС
		Возврат ТаблицаПоВторомуСобытиюНал;
		
	КонецЕсли;
	
	// ПродажиНалоговыйУчет
	
	//Отразим Продажи в регистре ПродажиНалоговыйУчет
	НаборДвижений = Движения.ПродажиНалоговыйУчет;
	
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	// УСЛУГИ
	ТаблицаКопия = ТаблицаПоУслугам.Скопировать();
	ТаблицаКопия.Свернуть("СтавкаНДС", "СуммаСНДСВал, СуммаНДСВал");
	
	ТаблицаКопия.Колонки.СуммаСНДСВал.Имя = "СуммаВзаиморасчетов";
	ТаблицаКопия.Колонки.СуммаНДСВал.Имя  = "СуммаНДС";
	
	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаКопия, ТаблицаДвижений);
	ТаблицаДвижений.ЗаполнитьЗначения(Организация       , "Организация");
	ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента, "ДоговорКонтрагента");
	ТаблицаДвижений.ЗаполнитьЗначения(НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента,
																	СтруктураШапкиДокумента.Ссылка, 
																	СтруктураШапкиДокумента.Сделка),
									  "Сделка");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СобытияПродажиНалоговыйУчет.РеализацияПокупателю, "Событие");
	
	Если СтруктураШапкиДокумента.СложныйНалоговыйУчет Тогда
		
		// очистим налоговые реквизиты
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтавкиНДС.ПустаяСсылка(), 			"СтавкаНДС");
		ТаблицаДвижений.ЗаполнитьЗначения(0, 												"СуммаНДС");
		
	Иначе		
		// упрощенный налоговый учет
		Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
			ТаблицаДвижений.ЗаполнитьЗначения(0, 												"СуммаНДС");	
			ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтавкиНДС.ПустаяСсылка(), 			"СтавкаНДС");
		КонецЕсли;
		
		Если СтруктураШапкиДокумента.ВедениеВзаиморасчетовНУ = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда
			// взаиморасчеты по договору по расчетным документам - необходимо заполнить в регистре реквизит РасчетныйДокумент
			ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Сделка, "РасчетныйДокумент");
		КонецЕсли;			
		
	КонецЕсли;	
	
	Если НЕ Отказ И ТаблицаДвижений.Количество() > 0 Тогда
			
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
			
		Движения.ПродажиНалоговыйУчет.ВыполнитьПриход();
		Движения.ПродажиНалоговыйУчет.Записать();
			
	КонецЕсли;
	
		// ОжидаемыйИПодтвержденныйНДСПродаж
	Если НЕ СтруктураШапкиДокумента.СложныйНалоговыйУчет Тогда
		
		// Движения формируются по данным рассчета "первого события" 
	   НалоговыйУчет.ДвиженияПоРегистрамНалоговогоУчетаУпрощенныйНалоговыйУчет(ЭтотОбъект, ТаблицаПоВторомуСобытиюНал);
	
	Иначе//Если  СтруктураШапкиДокумента.ЕстьНДС Тогда

		НаборДвижений = Движения.ОжидаемыйИПодтвержденныйНДСПродаж;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
			
		// УСЛУГИ
		ТаблицаКопия = ТаблицаПоУслугам.Скопировать();
			
		ТаблицаКопия.Свернуть("СтавкаНДС","СуммаБезНДСВал,СуммаНДСВал");
		ТаблицаКопия.Колонки.СуммаБезНДСВал.Имя = "БазаНДС";
		ТаблицаКопия.Колонки.СуммаНДСВал   .Имя = "СуммаНДС";
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаКопия, ТаблицаДвижений);
		ТаблицаДвижений.ЗаполнитьЗначения(Организация       , "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента, "ДоговорКонтрагента");
		ТаблицаДвижений.ЗаполнитьЗначения(НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента,
																		СтруктураШапкиДокумента.Ссылка, 
																		СтруктураШапкиДокумента.Сделка),
											  "Сделка");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация, "СобытиеНДС");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийОжидаемыйИПодтвержденныйНДСПродаж.ОжидаемыйНДС, "КодОперации");
			
			
		Если НЕ Отказ И ТаблицаДвижений.Количество() > 0 Тогда
			
			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
		
			Движения.ОжидаемыйИПодтвержденныйНДСПродаж.ВыполнитьПриход();
			Движения.ОжидаемыйИПодтвержденныйНДСПродаж.Записать();
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат ТаблицаПоВторомуСобытиюНал;

КонецФункции

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоМатериалам, Отказ, Заголовок)

	ТаблицыДокумента = новый структура("ТаблицаПоУслугам",ТаблицаПоУслугам);
	
	//Возможны корректировки таблиц при расчетах в валюте
	ТаблицаАвансов = БухгалтерскийУчетРасчетовСКонтрагентами.ЗачетАванса(ЭтотОбъект,СтруктураШапкиДокумента, мВалютаРегламентированногоУчета, ТаблицыДокумента, Отказ,Заголовок);
	КурсЗачетаАвансаРегл = ?(ТаблицаАвансов.Итог("СуммаВал") = 0, Неопределено, ТаблицаАвансов.Итог("Сумма") / ТаблицаАвансов.Итог("СуммаВал"));
	
	// Формирование движений регистров
	ДвиженияПоТабличнойЧастиУслуги(СтруктураШапкиДокумента, ТаблицаПоУслугам, Заголовок, Отказ,РежимПроведения);
	
	УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаПоМатериалам, Отказ);
	
	// Продажи (нал. учет)
	ТаблицаПоВторомуСобытиюНал = ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ);
	
	ПроводкиПоНДС(СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоВторомуСобытиюНал, Отказ);
	
	//Учет курсовых разниц
	Если (ВалютаДокумента <> мВалютаРегламентированногоУчета) тогда
		БухгалтерскийУчетРед12.ПереоценкаСчетовДокументаРегл(ЭтотОбъект,СтруктураШапкиДокумента, мВалютаРегламентированногоУчета,Отказ,Заголовок);
	КонецЕсли; // Учет курсовых разниц
	
КонецПроцедуры // ДвиженияПоРегистрамРегл()

Процедура ПроводкиПоНДС(СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоВторомуСобытиюНал, Отказ)
	
	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		// Учет НДС не ведется
		Возврат;
	КОнецЕсли;

	ТаблицаКопия = ТаблицаПоУслугам.Скопировать();                                                                                                                                
	ТаблицаКопия.Свернуть("СтавкаНДС, СчетДоходовБУ, СубконтоДоходовБУ1, СубконтоДоходовБУ2, СубконтоДоходовБУ3, НоменклатурнаяГруппа, СчетУчетаНДС, НалоговоеНазначениеДоходовИЗатрат","ПроводкиСуммаНДСРегл,ПроводкиСуммаНДСВал,ПроводкиСуммаНДСКурсНБУ");
	
	ПроводкиБУ = Движения.Хозрасчетный;
	
	Для Каждого СтрокаТаблицы Из ТаблицаКопия Цикл
		
		Если    СтрокаТаблицы.ПроводкиСуммаНДСРегл <> 0 
			ИЛИ СтрокаТаблицы.ПроводкиСуммаНДСВал  <> 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период                     = СтруктураШапкиДокумента.Дата;
			Проводка.Активность                 = Истина;
			Проводка.Организация                = СтруктураШапкиДокумента.Организация;
			Проводка.Сумма                      = СтрокаТаблицы.ПроводкиСуммаНДСРегл;
			Проводка.Содержание                 = НСтр("ru='НДС: налоговые обязательства: отгрузка';uk=""ПДВ: податкові зобов'язання: відвантаження""",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала               = "";

			Проводка.СчетДт                     = СтрокаТаблицы.СчетДоходовБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппа);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
				
				Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
				Проводка.СуммаНУДт = СтрокаТаблицы.ПроводкиСуммаНДСРегл;
				
			КонецЕсли;
			
			Проводка.СчетКт                     = СтрокаТаблицы.СчетУчетаНДС;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", СтруктураШапкиДокумента.Контрагент);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Договоры"   , СтруктураШапкиДокумента.ДоговорКонтрагента);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ДокументыРасчетовСКонтрагентами", НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка));
			
			НалоговыйУчет.РазбитьПроводкуПоНДСНаПервоеВтороеСобытие(ТаблицаПоВторомуСобытиюНал, ПроводкиБУ, Проводка, 
													  "Кт", СтруктураШапкиДокумента.СчетУчетаНДСПодтвержденный, 
													  СтруктураШапкиДокумента.ДоговорКонтрагента, 
													  НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка), Сделка,
													  Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация,
													  СтрокаТаблицы.СтавкаНДС,
													  ,,,СтрокаТаблицы.ПроводкиСуммаНДСВал, СтрокаТаблицы.ПроводкиСуммаНДСКурсНБУ, КурсЗачетаАвансаРегл);
			
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

// Процедура формирует движения регистров по табличной части Услуги
//
Процедура ДвиженияПоТабличнойЧастиУслуги(СтруктураШапкиДокумента, ТаблицаПоУслугам, Заголовок, Отказ, РежимПроведения)

	Если ТаблицаПоУслугам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПроводкиБУ  = Движения.Хозрасчетный;
	
	Для каждого СтрокаТаблицы Из ТаблицаПоУслугам Цикл

		// Выручка
		Если СтрокаТаблицы.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;

		Проводка = ПроводкиБУ.Добавить();

		Проводка.Период          = Дата;
		Проводка.Активность      = Истина;
		Проводка.Организация     = СтруктураШапкиДокумента.Организация;
		Проводка.Сумма           = СтрокаТаблицы.ПроводкиСуммаСНДСРегл;
		Проводка.Содержание      = НСтр("ru='Оказание услуг';uk='Надання послуг'",Локализация.КодЯзыкаИнформационнойБазы());
		Проводка.НомерЖурнала    = "";

		Проводка.СчетДт          = СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", СтруктураШапкиДокумента.Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры"   , СтруктураШапкиДокумента.ДоговорКонтрагента);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,  "ДокументыРасчетовСКонтрагентами", УправлениеВзаиморасчетами.ОпределитьДокументРасчетовСКонтрагентом(Ссылка, Сделка));
		
		Проводка.ВалютаДт        = СтруктураШапкиДокумента.ВалютаДокумента;
		Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.ПроводкиСуммаСНДСВал;
		
		Проводка.СчетКт         = СтрокаТаблицы.СчетДоходовБУ;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппа);
		
		Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
			
			Проводка.НалоговоеНазначениеКт  = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
		    Проводка.СуммаНУКт 				= НалоговыйУчет.УчестьСуммуАвансаДо01042011(СтруктураШапкиДокумента, СтрокаТаблицы.ПроводкиСуммаБезНДСРегл) + СтрокаТаблицы.ПроводкиСуммаНДСРегл;
			
		КонецЕсли;

	КонецЦикла;
	
	ДвиженияРегистровВыпускаПродукцииУслуг(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ);
	
КонецПроцедуры // ДвиженияПоТабличнойЧастиУслуги()

Процедура ДвиженияРегистровВыпускаПродукцииУслуг(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ)

	ПроводкиБУ  = Движения.Хозрасчетный;
	
	Для каждого СтрокаУслуги Из ТаблицаПоУслугам Цикл

		Проводка = ПроводкиБУ.Добавить();

		Проводка.Период       = СтруктураШапкиДокумента.Дата;
		Проводка.Организация  = СтруктураШапкиДокумента.Организация;
		Проводка.Сумма        = СтрокаУслуги.СуммаПлановая;
		Проводка.Содержание   = НСтр("ru='Затраты от реализации услуг перераб.дав.сырья в план.ценах';uk='Витрати від реалізації послуг перероб.дав.сировини в план.цінах'",Локализация.КодЯзыкаИнформационнойБазы());
		Проводка.НомерЖурнала = "";

		Проводка.СчетКт      = СтрокаУслуги.СчетУчетаБУ;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаУслуги.Номенклатура);
		Проводка.КоличествоКт = СтрокаУслуги.Количество;
		
		Проводка.СчетДт = СтрокаУслуги.СчетРасходовБУ;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаУслуги.СубконтоРасходовБУ1);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаУслуги.СубконтоРасходовБУ2);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаУслуги.СубконтоРасходовБУ3);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НоменклатурныеГруппы", СтрокаУслуги.НоменклатурнаяГруппа);
		
		Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
			
			Если СтруктураШапкиДокумента.НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ Тогда
				Проводка.НалоговоеНазначениеДт  = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность;
				Проводка.СуммаНУДт 				= 0;
			Иначе	
				Проводка.НалоговоеНазначениеДт  = СтрокаУслуги.НалоговоеНазначениеДоходовИЗатрат;
			    Проводка.СуммаНУДт 				= Проводка.Сумма;
			КонецЕсли;
			
			Проводка.СуммаНУКт 				= Проводка.Сумма;
			
		КонецЕсли;
	
		Проводка.НалоговоеНазначениеКт  = СтрокаУслуги.НалоговоеНазначение;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация"          , "ДоговорОрганизация");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Контрагент" , "Организация"          			, "ДоговорОрганизация");
  	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов",   "ВедениеВзаиморасчетов");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов" , 	"ВалютаВзаиморасчетов");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетовНУ", "ВедениеВзаиморасчетовНУ");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "СложныйНалоговыйУчет", 	"СложныйНалоговыйУчет");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора",			 	"ВидДоговора");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоМатериалам, Отказ, Заголовок) Экспорт
	
	// Подготовим таблицу услуг для проведения.
	СтруктураПолей = Новый Структура();
	СтруктураПростыхПолей = Новый Структура;
	СтруктураСложныхПолей = Новый Структура;
	
	СтруктураПолей.Вставить("Номенклатура"        , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"              , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("БланкСтрогогоУчета"  , "Номенклатура.БланкСтрогогоУчета");
	СтруктураПолей.Вставить("Количество"          , "Количество * Коэффициент");
	СтруктураПолей.Вставить("Сумма"               , "Сумма");
	СтруктураПолей.Вставить("СуммаПлановая"       , "СуммаПлановая");
	СтруктураПолей.Вставить("Цена"                , "Цена");
	СтруктураПолей.Вставить("СтавкаНДС"           , "СтавкаНДС");
	СтруктураПолей.Вставить("НДС"                 , "СуммаНДС");
	СтруктураПолей.Вставить("НомерСтроки"         , "НомерСтроки");
	СтруктураПолей.Вставить("СхемаРеализации"     , "СхемаРеализации");
	СтруктураПолей.Вставить("СчетДоходовБУ"       , "СхемаРеализации.СчетДоходов");
	СтруктураПолей.Вставить("СубконтоДоходовБУ1"  , "СхемаРеализации.СубконтоДоходов1");
	СтруктураПолей.Вставить("СубконтоДоходовБУ2"  , "СхемаРеализации.СубконтоДоходов2");
	СтруктураПолей.Вставить("СубконтоДоходовБУ3"  , "СхемаРеализации.СубконтоДоходов3");
	СтруктураПолей.Вставить("СчетРасходовБУ"      , "СхемаРеализации.СчетСебестоимости");
	СтруктураПолей.Вставить("СубконтоРасходовБУ1" , "СхемаРеализации.СубконтоСебестоимости1");
	СтруктураПолей.Вставить("СубконтоРасходовБУ2" , "СхемаРеализации.СубконтоСебестоимости2");
	СтруктураПолей.Вставить("СубконтоРасходовБУ3" , "СхемаРеализации.СубконтоСебестоимости3");
	СтруктураПолей.Вставить("СчетУчетаБУ"         , "СчетУчетаБУ");
	
	СтруктураПолей.Вставить("ВидНалоговойДеятельности", "НалоговоеНазначение.ВидНалоговойДеятельности");
	СтруктураПолей.Вставить("НоменклатурнаяГруппа", 	"Номенклатура.НоменклатурнаяГруппа");
	СтруктураПолей.Вставить("НалоговоеНазначение", 		"НалоговоеНазначение");
	СтруктураПолей.Вставить("ВидДеятельностиНДС" , 		"НалоговоеНазначение.ВидДеятельностиНДС");
	СтруктураПолей.Вставить("НалоговоеНазначениеДоходовИЗатрат", "НалоговоеНазначениеДоходовИЗатрат");
	СтруктураПолей.Вставить("СчетУчетаНДС"    	, 		"Ссылка.СчетУчетаНДС");
	
	РезультатЗапросаПоУслугам = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Услуги", СтруктураПолей, СтруктураПростыхПолей, СтруктураСложныхПолей);
	
	// Подготовим таблицу услуг для проведения.
	ТаблицаПоУслугам = ПодготовитьТаблицуУслуг(РезультатЗапросаПоУслугам, СтруктураШапкиДокумента);
	
	// Подготовим таблицу материалам для проведения.
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("НомерСтроки" , "НомерСтроки");
	СтруктураПолей.Вставить("Номенклатура", "Номенклатура");
	
	СтруктураПолей.Вставить("Услуга"              , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("БланкСтрогогоУчета"  , "Номенклатура.БланкСтрогогоУчета");
	СтруктураПолей.Вставить("Количество"  , "Количество * Коэффициент");
	СтруктураПолей.Вставить("СчетУчетаБУ" , "СчетУчетаБУ");
	

	РезультатЗапросаПоМатериалам = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "МатериалыЗаказчика", СтруктураПолей);
	
	// Подготовим таблицу услуг для проведения.
	ТаблицаПоМатериалам = ПодготовитьТаблицуМатериалов(РезультатЗапросаПоМатериалам, СтруктураШапкиДокумента);
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ТребованиеНакладная") Тогда
			Если Основание.МатериалыЗаказчика.Количество() = 0  Тогда
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Требование накладная №%1 не отражает перемещение давальческого сырья в производство';uk='Вимога накладна №%1 не відображає переміщення давальницької сировини у виробництво'"), основание.Номер));
				Отказ = Истина;
			КонецЕсли;
			
			
			// Заполним реквизиты шапки по документу основанию.
			Организация     = Основание.Организация;
			Контрагент      = Основание.Контрагент;
			
			Для Каждого СтрокаОснование Из Основание.МатериалыЗаказчика Цикл
				
				Строка = МатериалыЗаказчика.Добавить();	
				Строка.Номенклатура  =  СтрокаОснование.Номенклатура;
				Строка.СчетУчетаБУ   =  СтрокаОснование.Счет;
				Строка.Количество	 =  СтрокаОснование.Количество;
				Строка.ЕдиницаИзмерения	 =  СтрокаОснование.ЕдиницаИзмерения;
				Строка.Коэффициент	 =  СтрокаОснование.Коэффициент;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда
			
			// Заполним реквизиты шапки по документу основанию.
			Организация     = Основание.Организация;
			ВалютаДокумента = мВалютаРегламентированногоУчета;
			СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента, Дата); 
			КурсВзаиморасчетов = СтруктураКурсаДокумента.Курс;
			КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
			
			МетаданныеДокумента = ЭтотОбъект.Ссылка.Метаданные();
			Для Каждого СтрокаОснование Из Основание.Продукция Цикл
				
				Строка = Услуги.Добавить();	
				Строка.Номенклатура  =  СтрокаОснование.Номенклатура;
				Строка.Содержание	 = СтрокаОснование.Номенклатура.НаименованиеПолное;
				Строка.Количество	 =  СтрокаОснование.Количество;
				Строка.ЕдиницаИзмерения	 =  СтрокаОснование.ЕдиницаИзмерения;
				Строка.Коэффициент	 =  СтрокаОснование.Коэффициент;
				
				ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ЭтотОбъект, "Услуги", МетаданныеДокумента);
				
				ТипЦенПлановойСебестоимости   = Константы.ТипЦенПлановойСебестоимостиНоменклатуры.Получить();
				ВалютаРеглментированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
				
				Строка.Цена = Строка.Коэффициент * Ценообразование.ПолучитьЦенуНоменклатуры(Строка.Номенклатура,
							ТипЦен, Дата, ВалютаРеглментированногоУчета, 1);
							
				Строка.Спецификация     = СтрокаОснование.Спецификация;
				
				// Рассчитываем реквизиты табличной части.
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(Строка);
				ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(Строка, СуммаВключаетНДС);
				
				СчетаУчета     = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(Организация, Строка.Номенклатура, Основание.Склад);
				
				Строка.СчетУчетаБУ  = ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья;
				Строка.СхемаРеализации = СчетаУчета.СхемаРеализации;
				Строка.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
								
				Строка.ПлановаяСтоимость = Ценообразование.ПолучитьЦенуНоменклатуры(Строка.Номенклатура,
							ТипЦенПлановойСебестоимости, Дата,
							ВалютаРеглментированногоУчета, 1);
				ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьПлановуюСумму(Строка);
				
			КонецЦикла;
			
		КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов, ЭтоКомиссия)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭтоКомиссия",   ЭтоКомиссия);
	
	Запрос.Текст = "";
	
	Если Услуги.Количество() > 0 Тогда
		Запрос.УстановитьПараметр("ТаблицаУслуги", Услуги.Выгрузить());

		СтруктураРезультатов.Вставить("ТаблицаУслуги", СтруктураРезультатов.Количество());
		СтруктураРезультатов.Вставить("Услуги", СтруктураРезультатов.Количество());

		Запрос.Текст = Запрос.Текст + ?(ПустаяСтрока(Запрос.Текст), "", Символы.ПС + ";" + Символы.ПС) +
		"ВЫБРАТЬ
		|	ВремТаблица.НомерСтроки,
		|	ВремТаблица.Номенклатура,
		|	ВремТаблица.Сумма,
		|	ВремТаблица.СтавкаНДС,
		|	ВремТаблица.СуммаНДС,
		|	ВремТаблица.СхемаРеализации,
		|	ВремТаблица.НалоговоеНазначение,
		|	ВремТаблица.НалоговоеНазначениеДоходовИЗатрат
		|ПОМЕСТИТЬ ТаблицаУслуги
		|ИЗ &ТаблицаУслуги КАК ВремТаблица
		|;
		|ВЫБРАТЬ
		|	ТабицаДокумента.НомерСтроки,
		|	ТабицаДокумента.Номенклатура,
		|	ТабицаДокумента.Сумма,
		|	ТабицаДокумента.СтавкаНДС,
		|	ТабицаДокумента.СуммаНДС,
		|	ТабицаДокумента.СхемаРеализации,
		|	ТабицаДокумента.НалоговоеНазначение,
		|	ТабицаДокумента.НалоговоеНазначениеДоходовИЗатрат
		|ИЗ
		|	ТаблицаУслуги КАК ТабицаДокумента
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТабицаДокумента.НомерСтроки";
	КонецЕсли;

	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Возврат Запрос.ВыполнитьПакет();
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если АвторасчетНДС Тогда
		// соответствие для хранения погрешностей округлений
		ПогрешностиОкругления = Новый Соответствие();
		// пересчет сумм НДС с учетом ошибок округления
		УчетНДСКлиентСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(Услуги, ЭтотОбъект, СуммаВключаетНДС, ПогрешностиОкругления, "Услуги");
	КонецЕсли;

	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);
	
	Если НЕ ПлательщикНДС Тогда
		// организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС
		НеОБлНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		Для каждого СтрокаТЧ  Из Услуги Цикл
		    СтрокаТЧ.НалоговоеНазначение = НеОБлНДСДеятельность;
		КонецЦикла; 
	КонецЕсли; 
	
	Если НЕ ПлательщикНалогаНаПрибыльДо2015 Тогда
		
		Для каждого СтрокаТЧ  Из Услуги Цикл
		    СтрокаТЧ.НалоговоеНазначениеДоходовИЗатрат = Неопределено;
		КонецЦикла; 
		
	КонецЕсли; 
	
	Если ЕстьАвансДо01042011 Тогда
		Если НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ Тогда
			СуммаВДВРПоАвансуДо01042011	= СуммаДокумента;
		КонецЕсли;
	Иначе	
		НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ = Ложь;
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры // ПередЗаписью

Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"        , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                         , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Процедура - обработчик события "ОбработкаПроведения"
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоУслугам, ТаблицаПоМатериалам;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

    мВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Заголовок = НСтр("ru='Проведение документа ""';uk='Проведення документа ""'") + СокрЛП(Ссылка) + """: ";
	
    ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоМатериалам, Отказ, Заголовок);

	
	
	
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоМатериалам, Отказ, Заголовок);
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);

КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);

	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, 
		|СложныйНалоговыйУчет, СхемаНалоговогоУчета");
	СложныйНалоговыйУчет = ЗначениеЗаполнено(ДоговорКонтрагента) И (РеквизитыДоговора.СложныйНалоговыйУчет);
	// Исключаем из проверки реквизиты, заполнение которых стало необязательным:
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовПоАвансам"); // Не обязателен всегда
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДС(ПлательщикНДС, Ложь, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДС");		
	КонецЕсли;
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДСПодтвержденный(ПлательщикНДС, Ложь, Дата, СложныйНалоговыйУчет) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДСПодтвержденный");		
	КонецЕсли;
	
	Если (Не ЕстьАвансДо01042011) ИЛИ (ЕстьАвансДо01042011 И НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СуммаВДВРПоАвансуДо01042011");		
	КонецЕсли;
	
	// Проверяем корректность заполнения реквизитов шапки:
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстСообщения = "";
		Если НЕ УчетВзаиморасчетов.ПроверитьВозможностьПроведенияВРеглУчете(
			ЭтотОбъект, ДоговорКонтрагента, ТекстСообщения) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, "Корректность",
				НСтр("ru='Договор';uk='Договір'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;

	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначениеДоходовИЗатрат");

// Получаем содержимое табличных частей объекта с вспомогательными реквизитами:
	СтруктураРезультатов = Новый Структура;
	ТаблицыДокумента =  ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов, Ложь);
	
	НехозВНД_НДС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность;
	НехозВНД_НП  = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность;

	// Проверка заполнения табличной части "Услуги"
	Если Не ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	КонецЕсли;
	
	// Исключаем из проверки те реквизиты табличных частей, обязательность которых
	//  зависит от значений других рекивизитов в строках табличных частей:
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначениеДоходовИЗатрат");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.СхемаРеализации");
	
	Если Услуги.Количество() > 0 Тогда

		ВыборкаУслуг = ТаблицыДокумента[СтруктураРезультатов.Услуги].Выбрать();
		ИмяСписка = НСтр("ru='Услуги';uk='Послуги'");

		Пока ВыборкаУслуг.Следующий() Цикл
			Префикс = "Услуги[" + Формат(ВыборкаУслуг.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";

			Если ПлательщикНалогаНаПрибыльДо2015 Тогда   
				
				Если НЕ ЗначениеЗаполнено(ВыборкаУслуг.НалоговоеНазначениеДоходовИЗатрат) Тогда
					
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка",, 
						НСтр("ru='Налоговое назначение (доходов и затрат)';uk='Податкове призначення (доходів і витрат)'"),
						ВыборкаУслуг.НомерСтроки, ИмяСписка
					);
					Поле = Префикс + "НалоговоеНазначениеДоходовИЗатрат";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					
				ИначеЕсли ВыборкаУслуг.НалоговоеНазначениеДоходовИЗатрат = НехозВНД_НП Тогда 
					
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", 
						НСтр("ru='Налоговое назначение (доходов и затрат)';uk='Податкове призначення (доходів і витрат)'"),
						ВыборкаУслуг.НомерСтроки, ИмяСписка, 
						НСтр("ru='Вид налоговой деятельности при реализации не может быть ""Не хозяйственной деятельностью"".';uk='Вид податкової діяльності при реалізації не може бути ""Не господарською діяльністю"".'")
					);
					Поле = Префикс + "НалоговоеНазначениеДоходовИЗатрат";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		// Схемы реализации должны быть заполнены правильно
		МассивРеквизитовДляПроверки = Новый Массив;
		МассивРеквизитовДляПроверки.Добавить("СчетДоходов");
		МассивРеквизитовДляПроверки.Добавить("СчетСебестоимости");
															 
		БухгалтерскийУчет.ПроверитьСхемыРеализацииТабличнойЧастиНаЗаполненость(
			ЭтотОбъект, 
			"Услуги", ИмяСписка, 
			"СхемаРеализации", НСтр("ru='Схема реализации';uk='Схема реалізації'") , 
			МассивРеквизитовДляПроверки, 
			Отказ
		);

	КонецЕсли;

	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
#КонецЕсли

