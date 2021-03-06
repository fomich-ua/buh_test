#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// В указанном списке операций Расшифровка платежа используется явно       (отображается на форме)
// в остальных Видах операций добавляется 1 "пустая" строка в данную ТЧ (не отображается на форме)
Функция ПолучитьСписокВидовОперацийСРасшифровкойПлатежа() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ВозвратДенежныхСредствПоставщиком);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПрочиеРасчетыСКонтрагентами);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам);
	
	Возврат(СписокОпераций);
	
КонецФункции

Функция ЕстьРасшифровкаПлатежа(ВидОперации) Экспорт
	
	СписокВидовСРасшифровкойПлатежа = ПолучитьСписокВидовОперацийСРасшифровкойПлатежа();
	
	Возврат СписокВидовСРасшифровкойПлатежа.НайтиПоЗначению(ВидОперации) <> Неопределено;
	
КонецФункции


Функция ТекстСодержанияПроводокДокумента(Реквизиты)

	Содержание = Реквизиты.Содержание
		+ " по вх.д." + Реквизиты.НомерВходящегоДокумента 
		+ " от " + Формат(Реквизиты.ДатаВходящегоДокумента, "ДЛФ=Д");
	Возврат Содержание;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Поступление на банковский счет""';uk='Реєстр документів ""Надходження на банківський рахунок""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация, НомерВходящегоДокумента, ДатаВходящегоДокумента",
			"Контрагент", "НомерВходящегоДокумента", "ДатаВходящегоДокумента");
			
	Возврат Результат;
	
КонецФункции


#КонецЕсли