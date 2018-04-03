////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ УПРАВЛЕНИЯ АДМИНИСТРИРОВАНИЕМ ОБМЕНА ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Manage";
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ExchangeAdministrationManage";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияАдминистрированиеОбменаДаннымиУправлениеОбработчикСообщения_2_1_2_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}ConnectCorrespondent
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодключитьКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ConnectCorrespondent");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}SetTransportParams
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьНастройкиТранспорта(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetTransportParams");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}GetSyncSettings
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПолучитьНастройкиСинхронизацииДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetSyncSettings");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}DeleteSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУдалитьНастройкуСинхронизации(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteSync");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}EnableSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеВключитьСинхронизацию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "EnableSync");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}DisableSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОтключитьСинхронизацию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DisableSync");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}PushSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПротолкнутьСинхронизацию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PushSync");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}PushTwoApplicationSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПротолкнутьСинхронизациюДвухПриложений(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PushTwoApplicationSync");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ExchangeAdministration/Manage/a.b.c.d}ExecuteSync
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеВыполнитьСинхронизацию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExecuteSync");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
