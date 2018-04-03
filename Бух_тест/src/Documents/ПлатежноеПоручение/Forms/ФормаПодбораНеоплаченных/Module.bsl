////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если Параметры.Свойство("Отбор") Тогда
		
		Параметры.Отбор.Свойство("Организация",    ОтборОрганизация);
		Параметры.Отбор.Свойство("БанковскийСчет", ОтборБанковскийСчет);
		
	КонецЕсли;
	
	ОтборДата = ОбщегоНазначенияБП.ПолучитьРабочуюДату();
	
	Если НЕ ЗначениеЗаполнено(ОтборБанковскийСчет) Тогда
		УчетДенежныхСредствБП.УстановитьБанковскийСчет(
			ОтборБанковскийСчет, 
			ОтборОрганизация, 
			ВалютаРегламентированногоУчета);
	КонецЕсли; 
	
	ОбновитьСписокПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьФорму"
		И (ТипЗнч(Источник) = Тип("ДокументСсылка.ПлатежноеПоручение")
		ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.СписаниеСРасчетногоСчета")) Тогда
		
		ОбработкаОповещенияСервер(Источник);
		
		Если Параметр = ЭтаФорма Тогда
			Оповестить(, ВладелецФормы);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьСчетОрганизации(
		ОтборБанковскийСчет, 
		ОтборОрганизация, 
		ВалютаРегламентированногоУчета);
	ОбновитьСписокПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборБанковскийСчетПриИзменении(Элемент)
	
	ОбновитьСписокПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДатаВыпискиПриИзменении(Элемент)
	
	// Проверяем допустимое значение даты:
	Если ОтборДата >= '99991231' Тогда
		ОтборДата = ТекущаяДата();
	КонецЕсли; 
	
	ОбновитьСписокПодбора();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ СписокПлатежныхПоручений

&НаКлиенте
Процедура СписокПлатежныхПорученийПриИзменении(Элемент)
	
	Если Элементы.СписокПлатежныхПоручений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИДТекущейСтроки = Элементы.СписокПлатежныхПоручений.ТекущаяСтрока;
	ТекущаяОтметка = Элементы.СписокПлатежныхПоручений.ТекущиеДанные.Отметка;
	Для каждого ИДСтроки Из Элементы.СписокПлатежныхПоручений.ВыделенныеСтроки Цикл
		Если ИДСтроки <> ИДТекущейСтроки Тогда
			ВыделеннаяСтрока = СписокПлатежныхПоручений.НайтиПоИдентификатору(ИДСтроки);
			ВыделеннаяСтрока.Отметка = ТекущаяОтметка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежныхПорученийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаДокумента = СписокПлатежныхПоручений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаДокумента <> Неопределено Тогда
		ОткрытьФорму("Документ.ПлатежноеПоручение.ФормаОбъекта", Новый Структура("Ключ", СтрокаДокумента.Ссылка), ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПлатежныхПорученийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Элемент.ТекущийЭлемент.Имя <> "СписокПлатежныхПорученийОтметка";
	Если Отказ Тогда
		СтрокаДокумента = Элементы.СписокПлатежныхПоручений.ТекущиеДанные;
		Если СтрокаДокумента <> Неопределено Тогда
			ОткрытьФорму("Документ.ПлатежноеПоручение.ФормаОбъекта", Новый Структура("Ключ", СтрокаДокумента.Ссылка), ЭтаФорма);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ СписокСписанийСРС

&НаКлиенте
Процедура СписокСписанийСРСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаДокумента = СписокСписанийСРС.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаДокумента <> Неопределено Тогда
		ОткрытьФорму("Документ.СписаниеСРасчетногоСчета.ФормаОбъекта", Новый Структура("Ключ", СтрокаДокумента.Ссылка), ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ОбновитьСписокПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкиИнвертировать(Команда)
	
	УстановитьОтметки(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкиСнять(Команда)
	
	УстановитьОтметки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкиУстановить(Команда)
	
	УстановитьОтметки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСтрокиВыписки(Команда)
	
	ТекстПредупреждения = "";
	СформироватьСтрокиВыпискиСервер(ТекстПредупреждения);
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	Оповестить("ОбновитьФорму", , ПредопределенноеЗначение("Документ.СписаниеСРасчетногоСчета.ПустаяСсылка"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьСписокПодбора() 
	
	ДатаНачало = НачалоДня(ОтборДата) - 864000;
	ДатаКонец  = КонецДня(ОтборДата);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", ОтборОрганизация);
	Запрос.УстановитьПараметр("СчетОрганизации", ОтборБанковскийСчет);
	Если ЗначениеЗаполнено(ОтборДата) Тогда
		Запрос.УстановитьПараметр("ДатаНачало", ДатаНачало);
		Запрос.УстановитьПараметр("ДатаКонец", ДатаКонец);
	КонецЕсли; 
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Отметка,
	|	ПлатежноеПоручение.Ссылка КАК Ссылка,
	|	ПлатежноеПоручение.ПометкаУдаления,
	|	ПлатежноеПоручение.Номер,
	|	ПлатежноеПоручение.Дата КАК Дата,
	|	ПлатежноеПоручение.Проведен,
	|	ПлатежноеПоручение.Организация,
	|	ПлатежноеПоручение.СчетОрганизации,
	|	ПлатежноеПоручение.Контрагент,
	|	ПлатежноеПоручение.СуммаДокумента,
	|	ПлатежноеПоручение.ДокументОснование,
	|	ВЫБОР
	|		КОГДА ПлатежноеПоручение.ПометкаУдаления
	|			ТОГДА 2
	|		КОГДА ПлатежноеПоручение.Проведен
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НомерКартинки,
	|	ПлатежноеПоручение.Оплачено
	|ИЗ
	|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
	|ГДЕ
	|	ПлатежноеПоручение.Оплачено = ЛОЖЬ
	|	" + ?(ЗначениеЗаполнено(ОтборДата), "И ПлатежноеПоручение.Дата МЕЖДУ &ДатаНачало И &ДатаКонец", "") + "
	|	" + ?(ЗначениеЗаполнено(ОтборОрганизация) , "И ПлатежноеПоручение.Организация = &Организация", "") + " 
	|	" + ?(ЗначениеЗаполнено(ОтборБанковскийСчет) , "И ПлатежноеПоручение.СчетОрганизации = &СчетОрганизации", "") + " 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка";
	
	СписокПлатежныхПоручений.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если СписокПлатежныхПоручений.Количество() = 0 Тогда
		Если ЗначениеЗаполнено(ОтборБанковскийСчет) Тогда
			ТекстПодсказки = НСтр("ru='С %1 по %2 нет неоплаченных документов по организации %3 и счету в банке ""%4""';uk='З %1 з %2 немає неоплачених документів з організації %3 та рахунку в банку ""%4""'");
		Иначе
			ТекстПодсказки = НСтр("ru='С %1 по %2 нет неоплаченных документов по организации %3';uk='З %1 по %2 немає неоплачених документів з організації %3'");
		КонецЕсли;
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, 
							Формат(ДатаНачало, "ДФ=dd.MM.yyyy"),
							Формат(ДатаКонец,  "ДФ=dd.MM.yyyy"),
							ОтборОрганизация,
							ОтборБанковскийСчет);

		Элементы.СписокПлатежныхПорученийОтметкиУстановить.Доступность    = Ложь;
		Элементы.СписокПлатежныхПорученийОтметкиСнять.Доступность         = Ложь;
		Элементы.СписокПлатежныхПорученийОтметкиИнвертировать.Доступность = Ложь;		
	Иначе
		ТекстПодсказки = НСтр("ru='Отметьте флажками документы, которые нужно провести по выписке банка';uk='Позначте прапорцями документи, які потрібно провести по виписці банку'");
		
		Элементы.СписокПлатежныхПорученийОтметкиУстановить.Доступность    = Истина;
		Элементы.СписокПлатежныхПорученийОтметкиСнять.Доступность         = Истина;
		Элементы.СписокПлатежныхПорученийОтметкиИнвертировать.Доступность = Истина;		
	КонецЕсли;
	 
	Элементы.НадписьСпискаПоручений.Заголовок = ТекстПодсказки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтметки(ТипОтметки)

	Для Каждого СтрокаСписка Из СписокПлатежныхПоручений Цикл
		Если ТипОтметки = Неопределено Тогда
			СтрокаСписка.Отметка = НЕ СтрокаСписка.Отметка;
		Иначе
			СтрокаСписка.Отметка = ТипОтметки;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокиВыпискиСервер(ТекстПредупреждения)

	ОтмеченныеДокументы = СписокПлатежныхПоручений.НайтиСтроки(Новый Структура("Отметка", Истина));
	Если ОтмеченныеДокументы.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru='Нет отмеченных документов';uk='Немає відмічених документів'");
		Возврат;
	КонецЕсли;
	
	СписокСписанийСРС.Очистить();
	
	// Определяем существующие документы списаний с расчетного счета:
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокПлатежныхПоручений", СписокПлатежныхПоручений.Выгрузить(ОтмеченныеДокументы, "Отметка, Ссылка, ДокументОснование"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокПлатежныхПоручений.Отметка,
	|	СписокПлатежныхПоручений.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(СписокПлатежныхПоручений.ДокументОснование КАК Документ.СписаниеСРасчетногоСчета) КАК ДокументОснование
	|ПОМЕСТИТЬ СписокПП
	|ИЗ
	|	&СписокПлатежныхПоручений КАК СписокПлатежныхПоручений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокПП.Отметка,
	|	СписокПП.Ссылка,
	|	МАКСИМУМ(ЕСТЬNULL(СписаниеСРасчетногоСчета.Ссылка, СписокПП.ДокументОснование)) КАК ДокументСписания
	|ИЗ
	|	СписокПП КАК СписокПП
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|		ПО СписокПП.Ссылка = СписаниеСРасчетногоСчета.ДокументОснование
	|			И (СписокПП.ДокументОснование = ЗНАЧЕНИЕ(Документ.СписаниеСРасчетногоСчета.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокПП.Отметка,
	|	СписокПП.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ДокументовВсего     = 0;
	ДокументовПроведено = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ДокументовВсего = ДокументовВсего + 1;
		Если ЗначениеЗаполнено(Выборка.ДокументСписания) Тогда
			ДокументСписания = Выборка.ДокументСписания.ПолучитьОбъект();
			ДокументСписания.ПометкаУдаления = Ложь;
		Иначе
			ДокументСписания = Документы.СписаниеСРасчетногоСчета.СоздатьДокумент();
		КонецЕсли;
		 
		ДокументСписания.Дата = ОтборДата;
		ДокументСписания.НеПодтвержденоВыпискойБанка = Ложь;
		
		ДокументСписания.Заполнить(Выборка.Ссылка);
		Если ДокументСписания.ЭтоНовый() Тогда
			ДокументСписания.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
		СтрокаСписания = СписокСписанийСРС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСписания, ДокументСписания);
		
		Попытка
		
			ДокументСписания.Записать(РежимЗаписиДокумента.Проведение);
			ДокументовПроведено = ДокументовПроведено + 1;
			СтрокаСписания.НомерКартинки = 0;
			
		Исключение
			
			СтрокаСписания.ОшибкаПриПроведении = Истина;
			СтрокаСписания.НомерКартинки = 2;
			
		КонецПопытки; 
		
	КонецЦикла;
	
	Если ДокументовВсего <> ДокументовПроведено Тогда
		ТекстПредупреждения = НСтр("ru='Не удалось провести %1 документов из %2';uk='Не вдалося провести %1 документів з %2'"); 
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, ДокументовВсего - ДокументовПроведено, ДокументовВсего);
		ТекстПодсказки = НСтр("ru='Сформировано документов списания: %1, не удалось провести: %2. Непроведенные документы выделены красным цветом.';uk='Сформовано документів списання: %1 не вдалося провести: %2. Непроведені документи виділені червоним кольором.'"); 
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, ДокументовВсего, ДокументовПроведено);
	Иначе
		ТекстПодсказки = НСтр("ru='Сформировано документов списания: %1, ошибок не обнаружено.';uk='Сформовано документів списання: %1, помилок не виявлено.'"); 
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, ДокументовВсего);
	КонецЕсли;
	
	Элементы.НадписьСпискаСписаний.Заголовок = ТекстПодсказки;
	Элементы.СформироватьСтрокиВыписки.Видимость = Ложь;
	Элементы.СформироватьСтрокиВыписки.КнопкаПоУмолчанию = Ложь;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	Элементы.ПанельСписковДокументов.ТекущаяСтраница = Элементы.СтраницаСписанияСРасчетногоСчета;

КонецПроцедуры

&НаСервере
Процедура ОбработкаОповещенияСервер(Источник) 
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ПлатежноеПоручение") Тогда
		
		СтрокаДокумента = СписокПлатежныхПоручений.НайтиСтроки(Новый Структура("Ссылка", Источник));
		Если СтрокаДокумента.Количество() > 0 Тогда
			СтрокаДокумента = СтрокаДокумента[0];
			РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник, "Дата,Номер,Проведен,Ссылка,Организация,СчетОрганизации,
							|Контрагент,СуммаДокумента,ДокументОснование");
			ЗаполнитьЗначенияСвойств(СтрокаДокумента, РеквизитыДокумента);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.СписаниеСРасчетногоСчета") Тогда
		
		СтрокаДокумента = СписокСписанийСРС.НайтиСтроки(Новый Структура("Ссылка", Источник));
		Если СтрокаДокумента.Количество() > 0 Тогда
			СтрокаДокумента = СтрокаДокумента[0];
			РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник, "Дата,Номер,Проведен,Ссылка,Организация,СчетОрганизации,
							|Контрагент,СуммаДокумента,ДокументОснование");
			ЗаполнитьЗначенияСвойств(СтрокаДокумента, РеквизитыДокумента);
			СтрокаДокумента.ОшибкаПриПроведении = НЕ РеквизитыДокумента.Проведен;
		КонецЕсли;
		
		Если СписокСписанийСРС.Количество() > 0 Тогда
			ДокументовВсего     = СписокСписанийСРС.Количество();
			ДокументовСОшибкой  = СписокСписанийСРС.НайтиСтроки(Новый Структура("ОшибкаПриПроведении", Истина)).Количество();
			ДокументовПроведено = ДокументовВсего - ДокументовСОшибкой;
			ТекстПодсказки = НСтр("ru='Сформировано документов списания %1, из них проведено: %2';uk='Сформовано документів списання %1, з них проведено: %2'"); 
			ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, ДокументовВсего, ДокументовПроведено);
			Если ДокументовСОшибкой > 0 Тогда
				ТекстПодсказки = ТекстПодсказки + НСтр("ru=', не удалось провести: %1. Документы с ошибками выделены красным цветом';uk=', не вдалося провести: %1. Документи з помилками виділені червоним кольором'"); 
				ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, ДокументовСОшибкой);
			КонецЕсли;
			Элементы.НадписьСпискаСписаний.Заголовок = ТекстПодсказки;
		КонецЕсли;
		
	КонецЕсли;	 
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСчетОрганизации(СчетОрганизации, Знач Организация, Знач ВалютаРеглУчета)

	УчетДенежныхСредствБП.УстановитьБанковскийСчет(
		СчетОрганизации, 
		Организация, 
		ВалютаРеглУчета);

КонецПроцедуры

