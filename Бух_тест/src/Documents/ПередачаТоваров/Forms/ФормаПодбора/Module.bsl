
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
 // Процедура вызывает сервисный механизм для подбора номенклатуры в табличную часть.
//
// Параметры:
//  ТабличнаяЧасть - табличная часть, в которую осуществляется подбор.
//
Процедура ДействиеПодбор(ИмяТаблицы)

	СписокЗапросов = Новый СписокЗначений;
	СписокЗапросов.Добавить(,"По справочнику");

	ЗаголовокПодбора = НСтр("ru='Подбор готовой продукции';uk='Підбір готової продукції'");

	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов"       , Неопределено);
	СтруктураПараметровПодбора.Вставить("ТипЦен"             , Неопределено);
	СтруктураПараметровПодбора.Вставить("Валюта"             , Неопределено);
	СтруктураПараметровПодбора.Вставить("ДоговорКонтрагента" , Неопределено);
	СтруктураПараметровПодбора.Вставить("Контрагент"         , Неопределено);
	СтруктураПараметровПодбора.Вставить("Организация"        , Неопределено);
	СтруктураПараметровПодбора.Вставить("Склад"              , Неопределено);
	СтруктураПараметровПодбора.Вставить("Подразделение"      , Неопределено);
	СтруктураПараметровПодбора.Вставить("ЕстьКоличество"     , Истина);
	СтруктураПараметровПодбора.Вставить("ЕстьЦена"           , Ложь);
	СтруктураПараметровПодбора.Вставить("Заголовок"          , ЗаголовокПодбора);
	СтруктураПараметровПодбора.Вставить("СписокПодборов"     , СписокЗапросов);
	СтруктураПараметровПодбора.Вставить("ИмяТаблицы"         , ИмяТаблицы);
	СтруктураПараметровПодбора.Вставить("Услуги"             , Ложь);

	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", СтруктураПараметровПодбора, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры 

&НаСервере
// Выпполняет необходимые действия после подбора
//
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	ТаблицаМатериалов = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	Для каждого СтрокаМатериала Из ТаблицаМатериалов Цикл
		НоваяСтрока = ЭтаФорма[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаМатериала);
		
		Если ЗначениеЗаполнено(СтрокаМатериала.Номенклатура.ОсновнаяСпецификацияНоменклатуры) Тогда
			НоваяСтрока.Спецификация = СтрокаМатериала.Номенклатура.ОсновнаяСпецификацияНоменклатуры;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
// Выполняет расчет количества материалов и заполняет ТЗ "Материалы" для передачи в форму документа
//
Процедура Рассчитать()
	
    Материалы.Очистить();
	
	Для Каждого Строка Из Продукция Цикл
		Если  Строка.Спецификация = Справочники.СпецификацииНоменклатуры.ПустаяСсылка() Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Комплектующие Из Строка.Спецификация.ИсходныеКомплектующие Цикл
			
			Всего = Строка.Спецификация.Количество * Строка.Спецификация.Коэффициент;
			Если Всего = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаМатериалы = Материалы.Добавить();
			СтрокаМатериалы.Номенклатура = Комплектующие.Номенклатура;
			СтрокаМатериалы.Количество   = Строка.Количество * (Комплектующие.Количество/Всего);
			СтрокаМатериалы.ЕдиницаИзмерения = Комплектующие.ЕдиницаИзмерения;
			СтрокаМатериалы.Коэффициент 	 = Комплектующие.Коэффициент;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПродукцияПодбор(Команда)
	
	ДействиеПодбор("Продукция");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьРассчитать(Команда)
	
	Рассчитать();
	ПеренестиВДокумент = Истина;
	ЭтаФорма.Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяТаблицы = Параметры.ИмяТаблицы;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ПеренестиВДокумент Тогда
		АдресМатериаловВХранилище = ПоместитьМатериалыВХранилище();
		Структура = Новый Структура("АдресМатериаловВХранилище", АдресМатериаловВХранилище);
		ПеренестиВДокумент = Истина;
		ОповеститьОВыборе(Структура);
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ПЕРЕНОС В ДОКУМЕНТ

&НаСервере
Функция ПоместитьМатериалыВХранилище()
	
	АдресМатериаловВХранилище = ПоместитьВоВременноеХранилище(Материалы.Выгрузить(), УникальныйИдентификатор);
	
	Возврат АдресМатериаловВХранилище;
	
КонецФункции

