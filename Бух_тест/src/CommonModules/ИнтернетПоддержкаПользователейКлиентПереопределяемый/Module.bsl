
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с механизмом обновления конфигурации

// Переопределяет имя обработки для выполнения обновления конфигурации.
//
// Параметры:
// Имя - Строка - имя обработки обновления конфигурации. Значение по умолчанию
//	"ОбновлениеКонфигурации". Если обновление конфигурации не
//		предусмотрено, то требуется вставить строку: Имя = "";
//
Процедура ОпределитьИмяОбработкиОбновленияКонфигурации(Имя) Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервисные процедуры и функции

// Открывает интернет-старницу в обозревателе конфигурации.
//
// Параметры:
// АдресСтраницы - Строка - URL-адрес открываемой интернет-страницы;
// ЗаголовокОкна - Строка - заголовок окна, в котором отображается
//		интернет-страница;
//
// Пример:
// Если в конфигурации для открытия интернет-страниц используется
// собственная форма, то в теле процедуры необходимо описать вызов
// формы обозревателя, передав ей необходимые параметры.
//
// Если конфигурация, не имеет собственной формы для отображения
// интернет-страниц, необходимо описать вызов обозревателя,
// установленного в системе:
//
//	Попытка
//		ПерейтиПоНавигационнойСсылке(АдресСтраницы);
//	Исключение
//		
//		// Обработка исключения
//		
//	КонецПопытки;
//
Процедура ЗапуститьИнтернетСтраницуВОбозревателе(АдресСтраницы, ЗаголовокОкна) Экспорт
	
	Попытка
		ЗапуститьПриложение(АдресСтраницы);
	Исключение
		//обработка исключения
	КонецПопытки;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с интернет

// Определяет настройки прокси-сервера на стороне клиента 1С:Предприятия;
//
// Параметры:
// НастройкиПрокси - Соответствие - параметры прокси-сервера - в параметре
//		возвращаются настройки прокси-сервера на стороне клиента 1С:Предприятия:
//	* ИспользоватьПрокси - Булево - Истина, если использовать прокси-сервер;
//	* Пользователь - Строка, Неопределено - имя пользователя прокси-сервера;
//	* Пароль - Строка, Неопределено - пароль пользователя прокси-сервера;
//	* Сервер - Строка - сетевое имя прокси-сервера;
//	* Порт - Число - порт прокси-сервера;
//	* НеИспользоватьПроксиДляЛокальныхАдресов - Булево - Истина, если необходимо
//		отключить использование прокси-сервера для локальных адресов;
//	* ИспользоватьСистемныеНастройки - Булево - Истина, если необходимо
//		использовать системные настройки прокси-сервера;
//	* ДополнительныеНастройки - Соответствие - дополнительные прокси для
//		различных протоколов - ключ - имя протокола ("http", "https", "ftp"),
//		значение - структура со свойствами "Адрес" (Строка) и "Порт" (Число);
//
//
// Пример:
// Получение настроек прокси-сервера для конфигураций
// со встроенной подсистемой БСП "ПолучениеФайловИзИнтернета"
//
// НастройкиПрокси = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
//
////////////////////////////////////////////////////////////////////////////////
//
// Если в конфигурации не используется подсистема ПолучениеФайловИзИнтернета
// или не используется функционал подсистемы ПолучениеФайловИзИнтернета
// для настройки параметров прокси-сервера, то рекомендуется использовать
// автоматические настройки параметров прокси-сервера.
// В этом случае код должен иметь вид:
//
//	НастройкиПрокси = Новый Соответствие;
//	НастройкиПрокси["ИспользоватьПрокси"]             = Истина;
//	НастройкиПрокси["ИспользоватьСистемныеНастройки"] = Истина;
//
Процедура НастройкиПроксиСервера(НастройкиПрокси) Экспорт
	
	НастройкиПрокси = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
	
КонецПроцедуры

#КонецОбласти
