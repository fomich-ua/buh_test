#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЛокальныеПеременные

Перем ТекущиеОбработчики;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// см. процедуру "ПриДобавленииСлужебныхСобытий" общего модуля "ВыгрузкаЗагрузкаДанныхСлужебныйСобытия"
//
Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	// todo Временно
	ВыгрузкаЗагрузкаДанныхСлужебный.ПередЗагрузкойДанных(Контейнер);
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий БСП
	ОбработчикиПрограммныхСобытийБСП = ОбщегоНазначенияБТС.ПолучитьОбработчикиПрограммныхСобытийБСП(
		"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПередЗагрузкойДанных");
	Для Каждого ОбработчикПрограммныхСобытийБСП Из ОбработчикиПрограммныхСобытийБСП Цикл
		ОбработчикПрограммныхСобытийБСП.Модуль.ПередЗагрузкойДанных(Контейнер);
	КонецЦикла;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПередЗагрузкойДанных(Контейнер);
	
КонецПроцедуры

Процедура ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, НестандартныйОбработчик, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередСопоставлениемСсылок", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		
		ОписаниеОбработчика.Обработчик.ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, Отказ);
		
		Если Не СтандартнаяОбработка ИЛИ Отказ Тогда
			НестандартныйОбработчик = ОписаниеОбработчика.Обработчик;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняемые действия при замене ссылок.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	СоответствиеСсылок - см. параметр "СловарьЗамен" процедуры "ОбновитьСловарьСопоставленияСсылок" общего модуля "ВыгрузкаЗагрузкаДанныхИнформационнойБазы".
//
Процедура ПриЗаменеСсылок(Контейнер, СоответствиеСсылок) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПриЗаменеСсылок", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПриЗаменеСсылок(Контейнер, СоответствиеСсылок);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обработчики перед загрузкой определенного типа данных.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//	Отказ - Булево - признак выполнения данной операции.
//
Процедура ПередЗагрузкойТипа(Контейнер, ОбъектМетаданных, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойТипа(Контейнер, ОбъектМетаданных, Отказ);
	КонецЦикла;
	
КонецПроцедуры

//Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных"
//
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обработчики после загрузки объекта.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - объект загружаемых данных.
//	Артефакты - Массив - массив артефактов (объкетов XDTO).
//
Процедура ПослеЗагрузкиОбъекта(Контейнер, Объект, Артефакты) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиОбъекта(Контейнер, Объект, Артефакты);
	КонецЦикла;
	
КонецПроцедуры

// См. описание к процедуре ПриДобавленииСлужебныхСобытий() общего модуля ВыгрузкаЗагрузкаДанныхСлужебныйСобытия
//
Процедура ПослеЗагрузкиТипа(Контейнер, ОбъектМетаданных) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиТипа(Контейнер, ОбъектМетаданных);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет ряд действий при загрузке пользователя информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий БСП
	ОбработчикиПрограммныхСобытийБСП = ОбщегоНазначенияБТС.ПолучитьОбработчикиПрограммныхСобытийБСП(
		"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПослеЗагрузкиДанных");
	Для Каждого ОбработчикПрограммныхСобытийБСП Из ОбработчикиПрограммныхСобытийБСП Цикл
		ОбработчикПрограммныхСобытийБСП.Модуль.ПослеЗагрузкиДанных(Контейнер);
	КонецЦикла;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиДанных(Контейнер);
	
	// Для обратной совместимости вызовем ПослеЗагрузкиДанныхИзДругойМодели()
	
	// Обработчики событий БСП
	ОбработчикиПрограммныхСобытийБСП = ОбщегоНазначенияБТС.ПолучитьОбработчикиПрограммныхСобытийБСП(
		"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПослеЗагрузкиДанныхИзДругойМодели");
	Для Каждого ОбработчикПрограммныхСобытийБСП Из ОбработчикиПрограммныхСобытийБСП Цикл
		ОбработчикПрограммныхСобытийБСП.Модуль.ПослеЗагрузкиДанныхИзДругойМодели();
	КонецЦикла;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиДанныхИзДругойМодели();
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущиеОбработчики = Новый ТаблицаЗначений();

ТекущиеОбработчики.Колонки.Добавить("ОбъектМетаданных");
ТекущиеОбработчики.Колонки.Добавить("Обработчик");
ТекущиеОбработчики.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));

ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойДанных", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередСопоставлениемСсылок", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПриЗаменеСсылок", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойТипа", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиТипа", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиДанных", Новый ОписаниеТипов("Булево"));

// Интегрированные обработчики
ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаДанныхХранилищЗначений.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаПредопределенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаНеразделенныхПредопределенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаНастроекПользователей.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаДанныхУправлениеИтогами.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);

// Обработчики событий БСП
ОбработчикиПрограммныхСобытийБСП = ОбщегоНазначенияБТС.ПолучитьОбработчикиПрограммныхСобытийБСП(
	"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриРегистрацииОбработчиковЗагрузкиДанных");
Для Каждого ОбработчикПрограммныхСобытийБСП Из ОбработчикиПрограммныхСобытийБСП Цикл
	ОбработчикПрограммныхСобытийБСП.Модуль.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
КонецЦикла;

// Переопределяемая процедура
ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);

// Обеспечение обратной совместимости
Для Каждого Строка Из ТекущиеОбработчики Цикл
	Если ПустаяСтрока(Строка.Версия) Тогда
		Строка.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_0();
	КонецЕсли;
КонецЦикла;

#КонецОбласти

#КонецЕсли