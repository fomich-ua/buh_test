#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВалютаРегламентированногоУчета;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьНДС =  УчетнаяПолитика.ПлательщикНДС(Организация, Дата) И (мВалютаРегламентированногоУчета = ВалютаДокумента ИЛИ НЕ ЗначениеЗаполнено(ВалютаДокумента));
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ВидДоговораКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВидДоговора");
	ЭтоКомиссия = ЗначениеЗаполнено(ДоговорКонтрагента)
		И ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом;
	
	// Не проверяем заполненность табличных частей (включая реквизиты), 
	// которые не используются при определенных видах операции и будут очищены в ПередЗаписью
	НеИспользуемыеТабличныеЧасти = Документы.СчетНаОплатуПоставщика.НеИспользуемыеТабличныеЧасти(ВидОперации, ЭтоКомиссия);
	
	ОбщегоНазначенияБП.ИсключитьИзПроверкиНеиспользуемыеТабличныеЧасти(
		ПроверяемыеРеквизиты,
		НеИспользуемыеТабличныеЧасти);
	
	// Документ без данных о поступивших ценностях, соответствующих виду операции,
	// считаем заполненным некорректно.
	
	// Оставим в проверяемых реквизитах только основные табличные части  
	// выбранного вида операции
	
	Если ВидОперации <> Перечисления.ВидыОперацийСчетНаОплатуПоставщика.ПокупкаКомиссия Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийСчетНаОплатуПоставщика.ПокупкаКомиссия Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийСчетНаОплатуПоставщика.ПокупкаКомиссия Тогда
		// Если заполнен любой из "основных" списков, то проверять оставшиеся не следует
		ОсновныеСписки = Новый Массив();
		ОсновныеСписки.Добавить("Товары");
		ОсновныеСписки.Добавить("Услуги");
		ОсновныеСписки.Добавить("ВозвратнаяТара");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ОсновныеСписки, НеИспользуемыеТабличныеЧасти);
		
		ОбщегоНазначенияБП.ИсключитьИзПроверкиОсновныеТабличныеЧасти(
			ЭтотОбъект, 
			ОсновныеСписки, 
			ПроверяемыеРеквизиты);
		
	КонецЕсли;
	
	// Установка значений переменных для дальнейшей проверки
	
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
	
	// Табличная часть "Оборудование".
	
	Если НЕ ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Оборудование.СтавкаНДС");
	КонецЕсли;
	
	// Табличная часть "Объекты строительства".
	
	Если НЕ ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОбъектыСтроительства.СтавкаНДС");
	КонецЕсли;
	
	// Табличная часть "Товары".
	
	Если НЕ ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
	КонецЕсли;
	
	// Табличная часть "Услуги"
	
	Если НЕ ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	КонецЕсли;
	
	// Табличная часть "НематериальныеАктивы"
	
	Если НЕ ЕстьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НематериальныеАктивы.СтавкаНДС");
	КонецЕсли;
	
	// Проверка табличной части "Возвратная тара"
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВозвратнуюТару") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Сумма");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
	Звит1С_DOC_ID = "";

КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	Если ВидОперации <> Перечисления.ВидыОперацийСчетНаОплатуПоставщика.Оборудование Тогда
		Оборудование.Очистить();
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийСчетНаОплатуПоставщика.ОбъектыСтроительства Тогда
		ОбъектыСтроительства.Очистить();
	Иначе
		Товары.Очистить();
		ВозвратнаяТара.Очистить();
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

#КонецЕсли
