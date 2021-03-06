////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\ПриОпределенииОбработчиковКаналовСообщений"].Добавить(
			"ИнформационныйЦентрСлужебный");
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные\ПриОпределенииОбработчиковПоставляемыхДанных"].Добавить(
			"ИнформационныйЦентрСлужебный");
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
				"ИнформационныйЦентрСлужебный");
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\РегистрацияИнтерфейсовПринимаемыхСообщений"].Добавить(
			"ИнформационныйЦентрСлужебный");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"].Добавить(
				"ИнформационныйЦентрСлужебный");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений
//
// Параметры:
//  МассивОбработчиков - массив
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияИнформационногоЦентраИнтерфейс);
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "АдресУправленияКонференцией");
	МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ИмяПользователяКонференцииИнформационногоЦентра");
	МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ПарольПользователяКонференцииИнформационногоЦентра");
	
КонецПроцедуры

// Получает список обработчиков сообщений, которые обрабатывают подсистемы библиотеки.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
	
	СообщенияИнформационногоЦентраОбработчикСообщения.ПолучитьОбработчикиКаналовСообщений(Обработчики);
	
КонецПроцедуры

// Зарегистрировать обработчики поставляемых данных
//
// При получении уведомления о доступности новых общих данных, вызывается процедуры
// ДоступныНовыеДанные модулей, зарегистрированных через ПолучитьОбработчикиПоставляемыхДанных.
// В процедуру передается Дескриптор - ОбъектXDTO Descriptor.
// 
// В случае, если ДоступныНовыеДанные устанавливает аргумент Загружать в значение Истина, 
// данные загружаются, дескриптор и путь к файлу с данными передаются в процедуру 
// ОбработатьНовыеДанные. Файл будет автоматически удален после завершения процедуры.
// Если в менеджере сервиса не был указан файл - значение аргумента равно Неопределено.
//
// Параметры: 
//   Обработчики, ТаблицаЗначений - таблица для добавления обработчиков. 
//       Колонки:
//        ВидДанных, строка - код вида данных, обрабатываемый обработчиком
//        КодОбработчика, строка(20) - будет использоваться при восстановлении обработки данных после сбоя
//        Обработчик,  ОбщийМодуль - модуль, содержащий следующие процедуры:
//          ДоступныНовыеДанные(Дескриптор, Загружать) Экспорт  
//          ОбработатьНовыеДанные(Дескриптор, ПутьКФайлу) Экспорт
//          ОбработкаДанныхОтменена(Дескриптор) Экспорт
//
Процедура ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
	
	ИнформационныйЦентрСлужебный.ЗарегистрироватьОбработчикиПоставляемыхДанных(Обработчики);
	
КонецПроцедуры

// Заполняет массив типов, исключаемых из выгрузки и загрузки данных.
//
// Параметры:
//  Типы - Массив(Типы).
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ПросмотренныеДанныеИнформационногоЦентра);
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	ИнформационныйЦентрСлужебный.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	
КонецПроцедуры

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик                  = Обработчики.Добавить();
	Обработчик.Версия           = "*";
	Обработчик.МонопольныйРежим = Ложь;
	Обработчик.ОбщиеДанные      = Истина;
	Обработчик.Процедура        = "ИнформационныйЦентрСлужебный.СформироватьСловарьПолныхПутейКФормам";
	
	Обработчик                  = Обработчики.Добавить();
	Обработчик.Версия           = "1.0.3.35";
	Обработчик.МонопольныйРежим = Ложь;
	Обработчик.ОбщиеДанные      = Истина;
	Обработчик.Процедура        = "ИнформационныйЦентрСлужебный.ЗаполнитьДатуОкончанияАктуальностиИнформационныхСсылок";
	
	Если ТехнологияСервисаИнтеграцияСБСП.РазделениеВключено() Тогда
		Обработчик                  = Обработчики.Добавить();
		Обработчик.Версия           = "*";
		Обработчик.МонопольныйРежим = Ложь;
		Обработчик.ОбщиеДанные      = Истина;
		Обработчик.Процедура        = "ИнформационныйЦентрСлужебный.ОбновитьИнформационныеСсылкиДляФормВМоделиСервиса";
	Иначе
		Обработчик                  = Обработчики.Добавить();
		Обработчик.Версия           = "*";
		Обработчик.МонопольныйРежим = Ложь;
		Обработчик.Процедура        = "ИнформационныйЦентрСлужебный.ОбновитьИнформационныеСсылкиДляФормВЛокальномРежиме";
	КонецЕсли;
	
КонецПроцедуры

// Заполяет справочник "ПолныеПутиКформам" полными путями к формам.
//
Процедура СформироватьСловарьПолныхПутейКФормам() Экспорт
	
	// Формирование таблицы со списком полных форм конфигурации
	ТаблицаФорм = Новый ТаблицаЗначений;
	ТаблицаФорм.Колонки.Добавить("ПолныйПутьКФорме", Новый ОписаниеТипов("Строка"));
	
	ДобавитьФормыВСправочник(ТаблицаФорм, "ОбщиеФормы");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ПланыОбмена");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Справочники");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Документы");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ЖурналыДокументов");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Перечисления");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Отчеты");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Обработки");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ПланыВидовХарактеристик");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ПланыСчетов");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ПланыВидовРасчета");
	ДобавитьФормыВСправочник(ТаблицаФорм, "РегистрыСведений");
	ДобавитьФормыВСправочник(ТаблицаФорм, "РегистрыНакопления");
	ДобавитьФормыВСправочник(ТаблицаФорм, "РегистрыБухгалтерии");
	ДобавитьФормыВСправочник(ТаблицаФорм, "РегистрыРасчета");
	ДобавитьФормыВСправочник(ТаблицаФорм, "БизнесПроцессы");
	ДобавитьФормыВСправочник(ТаблицаФорм, "Задачи");
	ДобавитьФормыВСправочник(ТаблицаФорм, "ХранилищаНастроек");
	ДобавитьФормыВСправочник(ТаблицаФорм, "КритерииОтбора");
	
	// Заполнение справочника "ПолныеПутиКФормам"
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаФорм", ТаблицаФорм);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПОДСТРОКА(ТаблицаФорм.ПолныйПутьКФорме, 1, 1000) КАК ПолныйПутьКФорме
	|ПОМЕСТИТЬ ТаблицаФорм
	|ИЗ
	|	&ТаблицаФорм КАК ТаблицаФорм
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПолныйПутьКФорме
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПолныеПутиКФормам.Ссылка КАК Ссылка,
	|	ПОДСТРОКА(ПолныеПутиКФормам.ПолныйПутьКФорме, 1, 1000) КАК ПолныйПутьКФорме
	|ПОМЕСТИТЬ СуществующиеПолныеПутиКФормам
	|ИЗ
	|	Справочник.ПолныеПутиКФормам КАК ПолныеПутиКФормам
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПолныйПутьКФорме
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаФорм.ПолныйПутьКФорме КАК ПолныйПутьКФорме
	|ИЗ
	|	ТаблицаФорм КАК ТаблицаФорм
	|		ЛЕВОЕ СОЕДИНЕНИЕ СуществующиеПолныеПутиКФормам КАК СуществующиеПолныеПутиКФормам
	|		ПО (ТаблицаФорм.ПолныйПутьКФорме = СуществующиеПолныеПутиКФормам.ПолныйПутьКФорме)
	|ГДЕ
	|	СуществующиеПолныеПутиКФормам.Ссылка ЕСТЬ NULL ";
	ВыборкаФорм = Запрос.Выполнить().Выбрать();
	Пока ВыборкаФорм.Следующий() Цикл 
		ДобавитьПолноеИмяВСправочник(ВыборкаФорм.ПолныйПутьКФорме);
	КонецЦикла;
	
КонецПроцедуры

// При обновлении конфигурации необходимо обновить список Информационных ссылок для форм.
// Это происходит через Менеджер сервиса.
//
Процедура ОбновитьИнформационныеСсылкиДляФормВМоделиСервиса() Экспорт
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		ИмяКонфигурации = Метаданные.Имя;
		УстановитьПривилегированныйРежим(Ложь);
		ПроксиВебСервиса = ИнформационныйЦентрСервер.ПолучитьПроксиИнформационногоЦентра_1_0_1_1();
		Результат = ПроксиВебСервиса.UpdateInfoReference(ИмяКонфигурации);
		Если Результат Тогда 
			Возврат;
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru='Не удалось обновить Информационные ссылки';uk='Не вдалося оновити Інформаційні посилання'");
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// При обновлении конфигурации необходимо обновить список Информационных ссылок для форм.
// Это происходит через Менеджер сервиса.
//
Процедура ОбновитьИнформационныеСсылкиДляФормВЛокальномРежиме() Экспорт
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xml");
	Если ПустаяСтрока(ПутьКФайлу) Тогда 
		Возврат;
	КонецЕсли;
	
	ИмяМакета = ?(ТекущийЯзык().КодЯзыка = "ru", "ИнформационныеСсылки", "ИнформационныеСсылки_uk");
	ТекстовыйДокумент = ПолучитьОбщийМакет(ИмяМакета);
	ТекстовыйДокумент.Записать(ПутьКФайлу);
	Попытка
		ЗагрузитьИнформационныеСсылки(ПутьКФайлу);
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Возвращает строковое представление версии в числовом диапазоне.
//
// Параметры:
//	Версия - Строка - версия.
//
// Возвращаемое значение:
//	Число - представление версии числом.
//
Функция ПолучитьВерсиюЧислом(Версия) Экспорт
	
	МассивЧисел = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Версия, ".");
	
	Итерация           = 1;
	ВерсияЧислом       = 0;
	КоличествоВМассиве = МассивЧисел.Количество();
	
	Если КоличествоВМассиве = 0 Тогда 
		Возврат 0;
	КонецЕсли;
	
	Для Каждого ЧислоВерсии Из МассивЧисел Цикл 
		
		Попытка
			ТекущееЧисло = Число(ЧислоВерсии);
			ВерсияЧислом = ВерсияЧислом + ТекущееЧисло * ВозвестиЧислоВПоложительнуюСтепень(1000, КоличествоВМассиве - Итерация);
		Исключение
			Возврат 0;
		КонецПопытки;
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
	Возврат ВерсияЧислом;
	
КонецФункции

Процедура ЗаполнитьДатуОкончанияАктуальностиИнформационныхСсылок() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОкончанияАктуальности", '00010101000000');
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Ссылка КАК ИнформационнаяСсылка
	|ИЗ
	|	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.ДатаОкончанияАктуальности = &ДатаОкончанияАктуальности
	|	И НЕ ИнформационныеСсылкиДляФорм.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		
		ИнформационнаяСсылка = Выборка.ИнформационнаяСсылка.ПолучитьОбъект();
		ИнформационнаяСсылка.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПОЛУЧЕНИЯ ПОСТАВЛЯЕМЫХ ДАННЫХ

// Регистрирует обработчики поставляемых данных за день и за все время
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик                = Обработчики.Добавить();
	Обработчик.ВидДанных      = "ИнформационныеСсылки";
	Обработчик.КодОбработчика = "ИнформационныеСсылки";
	Обработчик.Обработчик     = ИнформационныйЦентрСлужебный;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "ИнформационныеСсылки" Тогда
		
		ИмяКонфигурации = ПолучитьИмяКонфигурацииПоДескриптору(Дескриптор);
		Если ИмяКонфигурации = Неопределено Тогда 
			Загружать = Ложь;
			Возврат;
		КонецЕсли;
		
		Загружать = ?(ВРег(Метаданные.Имя) = ВРег(ИмяКонфигурации), Истина, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - Строка или Неопределено. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры. Если в менеджере сервиса не был
//                  указан файл - значение аргумента равно Неопределено.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	Если Дескриптор.DataType = "ИнформационныеСсылки" Тогда
		ОбработатьИнформационныеСсылки(Дескриптор, ПутьКФайлу);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОбработатьИнформационныеСсылки(Дескриптор, ПутьКФайлу)
	
	ЗагрузитьИнформационныеСсылки(ПутьКФайлу);
	
КонецПроцедуры

Функция ПолучитьИмяКонфигурацииПоДескриптору(Дескриптор)
	
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "ОбъектРазмещения" Тогда
			Попытка
				Возврат Характеристика.Value;
			Исключение
				ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
				ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Возврат Неопределено;
			КонецПопытки;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ЗагрузитьИнформационныеСсылки(ПутьКФайлу)
	
	// Формирование дерева тэгов
	ДеревоТэгов = ПолучитьДеревоТэгов();
	
	ДатаОбновления = ТекущаяДата(); // Проектное решение БСП
	
	ТипИнформационнойСсылки    = ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/InformationReferences", "reference"); 
	ЧтениеИнформационныхСсылок = Новый ЧтениеXML; 
	ЧтениеИнформационныхСсылок.ОткрытьФайл(ПутьКФайлу); 
	
	ЧтениеИнформационныхСсылок.ПерейтиКСодержимому();
	ЧтениеИнформационныхСсылок.Прочитать();
	
	Пока ЧтениеИнформационныхСсылок.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл 
		
		ИнформационнаяСсылка = ФабрикаXDTO.ПрочитатьXML(ЧтениеИнформационныхСсылок, ТипИнформационнойСсылки);
		
		// Предопределенный элемент
		Если Не ПустаяСтрока(ИнформационнаяСсылка.namePredifined) Тогда 
			Попытка
				ЗаписатьПредопределеннуюИнформационнуюСсылку(ИнформационнаяСсылка);
			Исключение
				ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
				ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			Продолжить;
		КонецЕсли;
		
		// Обыкновенный элемент
		Если ТипЗнч(ИнформационнаяСсылка.context) = Тип("СписокXDTO") Тогда 
			Для Каждого Контекст из ИнформационнаяСсылка.context Цикл 
				Попытка
					ЗаписатьСсылкуПоКонтекстам(ДеревоТэгов, ИнформационнаяСсылка, Контекст, ДатаОбновления);
				Исключение
					ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
					ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
			КонецЦикла;
		Иначе
			ЗаписатьСсылкуПоКонтекстам(ДеревоТэгов, ИнформационнаяСсылка, ИнформационнаяСсылка.context, ДатаОбновления);
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеИнформационныхСсылок.Закрыть();
	
	ОчиститьНеОбновленныеСсылки(ДатаОбновления);
	
КонецПроцедуры

Процедура ЗаписатьПредопределеннуюИнформационнуюСсылку(ОбъектСсылки)
	
	Попытка
		ЭлементСправочника = Справочники.ИнформационныеСсылкиДляФорм[ОбъектСсылки.namePredifined].ПолучитьОбъект();
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	ЭлементСправочника.Адрес                     = ОбъектСсылки.address;
	ЭлементСправочника.ДатаНачалаАктуальности    = ОбъектСсылки.dateFrom;
	ЭлементСправочника.ДатаОкончанияАктуальности = ОбъектСсылки.dateTo;
	ЭлементСправочника.Наименование              = ОбъектСсылки.name;
	ЭлементСправочника.Подсказка                 = ОбъектСсылки.helpText;
	ЭлементСправочника.Записать();
	
КонецПроцедуры

Процедура ОчиститьНеОбновленныеСсылки(ДатаОбновления)
	
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаСправочника = Справочники.ИнформационныеСсылкиДляФорм.Выбрать();
	Пока ВыборкаСправочника.Следующий() Цикл 
		
		Если ВыборкаСправочника.Предопределенный Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаСправочника.ДатаОбновления = ДатаОбновления Тогда 
			Продолжить;
		КонецЕсли;
		
		Объект = ВыборкаСправочника.ПолучитьОбъект();
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьСсылкуПоКонтекстам(ДеревоТэгов, ОбъектСсылки, Контекст, ДатаОбновления)
	
	Результат = ПроверитьНаличиеИмениФормыПоТэгу(Контекст.tag);
	Если Результат.ЭтоПутьКФорме Тогда 
		ЗаписатьСсылкуПоКонтексту(ОбъектСсылки, Контекст, Результат.ПутьКФорме, ДатаОбновления);
		Возврат;
	КонецЕсли;
	
	Тэг             = Контекст.tag;
	НайденнаяСтрока = ДеревоТэгов.Строки.Найти(Тэг, "Имя");
	Если НайденнаяСтрока = Неопределено Тогда 
		ЗаписатьСсылкуПоИдентификатору(ОбъектСсылки, Контекст, ДатаОбновления);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДерева из НайденнаяСтрока.Строки Цикл 
		
		ИмяФормы = СтрокаДерева.Имя;
		СсылкаНаПутьКФорме = СсылкаПутиКФормеВСправочнике(ИмяФормы);
		Если СсылкаНаПутьКФорме.Пустая() Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗаписатьСсылкуПоКонтексту(ОбъектСсылки, Контекст, СсылкаНаПутьКФорме, ДатаОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьСсылкуПоИдентификатору(ОбъектСсылки, Контекст, ДатаОбновления)
	
	ЭлементСправочника = Справочники.ИнформационныеСсылкиДляФорм.СоздатьЭлемент();
	ЭлементСправочника.Адрес                     = ОбъектСсылки.address;
	ЭлементСправочника.Идентификатор             = Контекст.tag;
	ЭлементСправочника.Вес                       = Контекст.weight;
	ЭлементСправочника.ДатаНачалаАктуальности    = ОбъектСсылки.dateFrom;
	ЭлементСправочника.ДатаОкончанияАктуальности = ОбъектСсылки.dateTo;
	ЭлементСправочника.Наименование              = ОбъектСсылки.name;
	ЭлементСправочника.Подсказка                 = ОбъектСсылки.helpText;
	ЭлементСправочника.ВерсияКонфигурацииОт      = ПолучитьВерсиюЧислом(Контекст.versionFrom);
	ЭлементСправочника.ВерсияКонфигурацииДо      = ПолучитьВерсиюЧислом(Контекст.versionTo);
	ЭлементСправочника.ДатаОбновления            = ДатаОбновления;
	ЭлементСправочника.Записать();
	
КонецПроцедуры

Процедура ЗаписатьСсылкуПоКонтексту(ОбъектСсылки, Контекст, СсылкаНаПутьКФорме, ДатаОбновления)
	
	Ссылка = ИмеетсяИнформационнаяСсылкаДляДаннойФормы(ОбъектСсылки.address, СсылкаНаПутьКФорме);
	
	Если Ссылка = Неопределено Тогда 
		ЭлементСправочника = Справочники.ИнформационныеСсылкиДляФорм.СоздатьЭлемент();
	Иначе
		ЭлементСправочника = Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЭлементСправочника.Адрес                     = ОбъектСсылки.address;
	ЭлементСправочника.Вес                       = Контекст.weight;
	ЭлементСправочника.ДатаНачалаАктуальности    = ОбъектСсылки.dateFrom;
	ЭлементСправочника.ДатаОкончанияАктуальности = ОбъектСсылки.dateTo;
	ЭлементСправочника.Наименование              = ОбъектСсылки.name;
	ЭлементСправочника.Подсказка                 = ОбъектСсылки.helpText;
	ЭлементСправочника.ПолныйПутьКФорме          = СсылкаНаПутьКФорме;
	ЭлементСправочника.ВерсияКонфигурацииОт      = ПолучитьВерсиюЧислом(Контекст.versionFrom);
	ЭлементСправочника.ВерсияКонфигурацииДо      = ПолучитьВерсиюЧислом(Контекст.versionTo);
	ЭлементСправочника.ДатаОбновления            = ДатаОбновления;
	ЭлементСправочника.Записать();
	
КонецПроцедуры

Функция ИмеетсяИнформационнаяСсылкаДляДаннойФормы(Адрес, СсылкаНаПутьКФорме)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолныйПутьКФорме", СсылкаНаПутьКФорме);
	Запрос.УстановитьПараметр("Адрес",            Адрес);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИнформационныеСсылкиДляФорм.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	               |ГДЕ
	               |	ИнформационныеСсылкиДляФорм.ПолныйПутьКФорме = &ПолныйПутьКФорме
	               |	И ИнформационныеСсылкиДляФорм.Адрес ПОДОБНО &Адрес";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПроверитьНаличиеИмениФормыПоТэгу(Тэг)
	
	Результат = Новый Структура("ЭтоПутьКФорме", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолныйПутьКФорме", Тэг);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолныеПутиКФормам.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПолныеПутиКФормам КАК ПолныеПутиКФормам
	|ГДЕ
	|	ПолныеПутиКФормам.ПолныйПутьКФорме ПОДОБНО &ПолныйПутьКФорме";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат Результат;
	КонецЕсли;
	
	Результат.ЭтоПутьКФорме = Истина;
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл 
		Результат.Вставить("ПутьКФорме", ВыборкаЗапроса.Ссылка);
		Возврат Результат;
	КонецЦикла;
	
КонецФункции

Функция ПолучитьДеревоТэгов()
	
	ДеревоТэгов = Новый ДеревоЗначений;
	ДеревоТэгов.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	
	// Чтение общего макета
	ИмяФайлаМакета = ПолучитьИмяВременногоФайла("xml");
	ПолучитьОбщийМакет("СоответствиеТэговОбщимФормам").Записать(ИмяФайлаМакета);
	
	ЗаписиСоответствияТэговИФорм = Новый ЧтениеXML;
	ЗаписиСоответствияТэговИФорм.ОткрытьФайл(ИмяФайлаМакета);
	
	ТекущийТэгВДереве = Неопределено;
	Пока ЗаписиСоответствияТэговИФорм.Прочитать() Цикл
		// Чтение текущего тэга
		ЭтоТэг = ЗаписиСоответствияТэговИФорм.ТипУзла = ТипУзлаXML.НачалоЭлемента и ВРег(СокрЛП(ЗаписиСоответствияТэговИФорм.Имя)) = ВРег("tag");
		Если ЭтоТэг Тогда 
			Пока ЗаписиСоответствияТэговИФорм.ПрочитатьАтрибут() Цикл 
				Если ВРег(ЗаписиСоответствияТэговИФорм.Имя) = ВРег("name") тогда
					ТекущийТэгВДереве     = ДеревоТэгов.Строки.Добавить();
					ТекущийТэгВДереве.Имя = ЗаписиСоответствияТэговИФорм.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		// Чтение формы
		ЭтоФорма = ЗаписиСоответствияТэговИФорм.ТипУзла = ТипУзлаXML.НачалоЭлемента и ВРег(СокрЛП(ЗаписиСоответствияТэговИФорм.Имя)) = ВРег("form");
		Если ЭтоФорма Тогда 
			Пока ЗаписиСоответствияТэговИФорм.ПрочитатьАтрибут() Цикл 
				Если ВРег(ЗаписиСоответствияТэговИФорм.Имя) = ВРег("path") тогда
					Если ТекущийТэгВДереве = Неопределено Тогда 
						Прервать;
					КонецЕсли;
					ТекущийЭлементДерева     = ТекущийТэгВДереве.Строки.Добавить();
					ТекущийЭлементДерева.Имя = ЗаписиСоответствияТэговИФорм.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДеревоТэгов;
	
КонецФункции

Процедура ДобавитьФормыВСправочник(ТаблицаФорм, ИмяКлассаМетаданного)
	
	КлассМетаданных     = Метаданные[ИмяКлассаМетаданного];
	КоличествоЭлементов = КлассМетаданных.Количество();
	Если ИмяКлассаМетаданного = "ОбщиеФормы" Тогда 
		Для ИтерацияЭлементов = 0 По КоличествоЭлементов - 1 Цикл 
			
			ПолныйПутьКФорме = КлассМетаданных.Получить(ИтерацияЭлементов).ПолноеИмя();
			
			ЭлементТаблицы                  = ТаблицаФорм.Добавить();
			ЭлементТаблицы.ПолныйПутьКФорме = ПолныйПутьКФорме;
			
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Для ИтерацияЭлементов = 0 По КоличествоЭлементов - 1 Цикл 
		ФормыКлассаМетаданных = КлассМетаданных.Получить(ИтерацияЭлементов).Формы;
		КоличествоФорм        = ФормыКлассаМетаданных.Количество();
		Для ИтерацияФорм = 0 По КоличествоФорм - 1 Цикл 
			
			ПолныйПутьКФорме = ФормыКлассаМетаданных.Получить(ИтерацияФорм).ПолноеИмя();
			
			ЭлементТаблицы                  = ТаблицаФорм.Добавить();
			ЭлементТаблицы.ПолныйПутьКФорме = ПолныйПутьКФорме;
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПолноеИмяВСправочник(ПолноеИмяФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	ЭлементСправочника = Справочники.ПолныеПутиКФормам.СоздатьЭлемент();
	ЭлементСправочника.Наименование     = ПолноеИмяФормы;
	ЭлементСправочника.ПолныйПутьКФорме = ПолноеИмяФормы;
	ЭлементСправочника.Записать();
	
КонецПроцедуры

Функция СсылкаПутиКФормеВСправочнике(ПолноеИмяФормы)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолныйПутьКФорме", ПолноеИмяФормы);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолныеПутиКФормам.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПолныеПутиКФормам КАК ПолныеПутиКФормам
	|ГДЕ
	|	ПолныеПутиКФормам.ПолныйПутьКФорме ПОДОБНО &ПолныйПутьКФорме";
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Справочники.ПолныеПутиКФормам.ПустаяСсылка();
	
КонецФункции

// Возводит число в степень.
//
// Параметры:
//	Число - Число - число, возводимое в степень.
//	Степень - Число - степень, в которую необходимо возвести число.
//
// Возвращаемое значение:
//	Число - возведенное в степень число.
//
Функция ВозвестиЧислоВПоложительнуюСтепень(Число, Степень)
	
	Если Степень = 0 Тогда 
		Возврат 1;
	КонецЕсли;
	
	Если Степень = 1 Тогда 
		Возврат Число;
	КонецЕсли;
	
	ВозвращаемоеЧисло = Число;
	
	Для Итерация = 2 по Степень Цикл 
		ВозвращаемоеЧисло = ВозвращаемоеЧисло * Число;
	КонецЦикла;
	
	Возврат ВозвращаемоеЧисло;
	
КонецФункции

