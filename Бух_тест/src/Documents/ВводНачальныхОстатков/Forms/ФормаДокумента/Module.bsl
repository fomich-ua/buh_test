////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьСписокРазделовУчета()

	СписокРазделов = Новый СписокЗначений;
	
	Для Каждого ЭлементМетаданных Из Метаданные.Перечисления.РазделыУчетаДляВводаОстатков.ЗначенияПеречисления Цикл
		
		Раздел = Перечисления.РазделыУчетаДляВводаОстатков[ЭлементМетаданных.Имя];
		СписокРазделов.Добавить(Раздел);
	
	КонецЦикла; 
	
	Возврат СписокРазделов;

КонецФункции

&НаКлиенте
Процедура СписокРазделовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокРазделов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ЗначенияЗаполнения.Вставить("РазделУчета",              СтрокаТаблицы.Значение);
	ЗначенияЗаполнения.Вставить("Организация",              Объект.Организация);
	
	Модифицированность = Ложь;
	Закрыть();
	ОткрытьФорму("Документ.ВводНачальныхОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы, КлючИзПараметров);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ВыбратьРаздел(Команда)

	СтрокаТаблицы = Элементы.СписокРазделов.ТекущиеДанные;
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ЗначенияЗаполнения.Вставить("РазделУчета",              СтрокаТаблицы.Значение);
		ЗначенияЗаполнения.Вставить("Организация",              Объект.Организация);
		
		Модифицированность = Ложь;
		Закрыть();
		ОткрытьФорму("Документ.ВводНачальныхОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы, КлючИзПараметров);
		
	КонецЕсли; 

КонецПроцедуры
 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	КлючИзПараметров   = Параметры.Ключ;
	ИсключатьУСН       = Ложь;
	
	СписокРазделов.ЗагрузитьЗначения(ПолучитьСписокРазделовУчета().ВыгрузитьЗначения());
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Модифицированность = Ложь;
	
КонецПроцедуры
