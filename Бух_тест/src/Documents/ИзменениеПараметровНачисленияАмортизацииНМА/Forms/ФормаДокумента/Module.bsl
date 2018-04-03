////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента			= Объект.Дата;

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляСпискаНМАСервер()
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВнешнийИсточник", Объект.НМА.Выгрузить());
	Запрос.УстановитьПараметр("Организация"	, Объект.Организация);
	Запрос.УстановитьПараметр("Период"		, Объект.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	НематериальныйАктив
	|ПОМЕСТИТЬ НематериальныеАктивы
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|";
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НематериальныеАктивы.НематериальныйАктив КАК НематериальныйАктив,
				   |	ПервоначальныеСведенияБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизацииБУ,
				   |	ПервоначальныеСведенияБУ.СрокПолезногоИспользования КАК СрокПолезногоИспользованияБУ,
				   |	ПервоначальныеСведенияНУ.СрокПолезногоИспользования КАК СрокПолезногоИспользованияНУ,
				   |	ПервоначальныеСведенияНУ.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииНУ,
				   |	ПервоначальныеСведенияБУ.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимостьБУ,
				   |	ПервоначальныеСведенияБУ.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииБУ
	               |ИЗ
	               |	НематериальныеАктивы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(&Период, Организация = &Организация И НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы)) КАК ПервоначальныеСведенияБУ
	               |		ПО НематериальныеАктивы.НематериальныйАктив = ПервоначальныеСведенияБУ.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАНалоговыйУчет.СрезПоследних(&Период, Организация = &Организация И НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы)) КАК ПервоначальныеСведенияНУ
	               |		ПО НематериальныеАктивы.НематериальныйАктив = ПервоначальныеСведенияНУ.НематериальныйАктив
				   |";
		
	ТЗ = Запрос.Выполнить().Выгрузить();

	Для каждого СтрокаТЧ Из Объект.НМА Цикл

		СтрокаТЗ = ТЗ.Найти(СтрокаТЧ.НематериальныйАктив,"НематериальныйАктив");

		Если СтрокаТЗ = Неопределено Тогда
			
			СтрокаТЧ.СрокПолезногоИспользованияБУ                  	= 0;
			СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ 	= 0;
			СтрокаТЧ.ЛиквидационнаяСтоимостьБУ                     	= 0;
			
			СтрокаТЧ.СрокПолезногоИспользованияНУ                  	= 0;
			
		Иначе

			СтрокаТЧ.СрокПолезногоИспользованияБУ                  	= СтрокаТЗ.СрокПолезногоИспользованияБУ;
			СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ 	= СтрокаТЗ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ;
			СтрокаТЧ.ЛиквидационнаяСтоимостьБУ                     	= СтрокаТЗ.ЛиквидационнаяСтоимостьБУ;
			СтрокаТЧ.СпособНачисленияАмортизацииБУ                 	= СтрокаТЗ.СпособНачисленияАмортизацииБУ;
			
			СтрокаТЧ.СрокПолезногоИспользованияНУ                  	= СтрокаТЗ.СрокПолезногоИспользованияНУ;
			
			СтрокаТЧ.СпособНачисленияАмортизацииНУ                 	= СтрокаТЗ.СпособНачисленияАмортизацииНУ;
			
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьНМАВХранилище()

	ТаблицаНМА = Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаНМА);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(Знач ВыбранноеЗначение)
	
	ДобавленныеСтроки = УправлениеНеоборотнымиАктивами.ОбработатьПодборНематериальныхАктивов(Объект.НМА, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Подбор(Команда)
	
	СтруктураПараметров = Новый Структура;
	Если Объект.НМА.Количество() > 0 Тогда
		СтруктураПараметров.Вставить("АдресВХранилище", ПоместитьНМАВХранилище());
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборНематериальныхАктивов.Форма.Форма", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМА(Команда)
	
	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!"
"Продолжить?';uk='При заповненні існуючі дані будуть перераховані!"
"Продовжити?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьДляСпискаНМАЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМАЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДляСпискаНМАСервер();

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНематериальныхАктивов.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать
