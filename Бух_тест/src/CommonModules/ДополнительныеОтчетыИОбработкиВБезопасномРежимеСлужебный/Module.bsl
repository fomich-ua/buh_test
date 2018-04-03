////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", расширение безопасного режима,
// служебные процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам"].Добавить(
		"ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриРегистрацииМенеджеровВнешнихМодулей"].Добавить(
		"ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный");
	
КонецПроцедуры

// Вызывается при регистрации менеджеров внешних модулей.
//
// Параметры:
//  Менеджеры - Массив(ОбщийМодуль).
//
Процедура ПриРегистрацииМенеджеровВнешнихМодулей(Менеджеры) Экспорт
	
	Менеджеры.Добавить(ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный);
	
КонецПроцедуры

// Возвращает шаблон имени профиля безопасности для внешнего модуля.
// Функция должна возвращать одно и то же значение при многократном вызове.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка, ссылка на внешний модуль,
//
// Возвращаемое значение - Строка - шаблон имя профиля безопасности, содержащий символы
//  "%1", вместо которых в дальнейшем будет подставлен уникальный идентификатор.
//
Функция ШаблонИмениПрофиляБезопасности(Знач ВнешнийМодуль) Экспорт
	
	Возврат "Extension_%1"; // Не локализуется
	
КонецФункции

// Возвращает словарь представлений для внешних модулей контейнера.
//
// Возвращаемое значение - Структура:
//  * Именительный - Строка, представление типа внешнего модуля в именительном падеже,
//  * Родительный - Строка, представление типа внешнего модуля в родительном падеже.
//
Функция СловарьКонтейнераВнешнегоМодуля() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru='Дополнительный отчет или обработка';uk='Додатковий звіт або обробка'"));
	Результат.Вставить("Родительный", НСтр("ru='Дополнительного отчета или обработки';uk='Додаткового звіту або обробки'"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив ссылочных объектов метаданных, которые могут использоваться в
//  качестве контейнера внешних модулей.
//
// Возвращаемое значение - Массив(ОбъектМетаданных).
//
Функция КонтейнерыВнешнихМодулей() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки);
	Возврат Результат;
	
КонецФункции

// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
// при создании информационной базы или обновлении программы.
//
// Параметры:
//  ЗапросыРазрешений - Массив - список значений, возвращенных функцией
//                      РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов().
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
		|ГДЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка.Публикация <> &Публикация";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Публикация", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		НовыеЗапросы = ЗапросыРазрешенийДополнительнойОбработки(Объект, Объект.Разрешения.Выгрузить());
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗапросыРазрешений, НовыеЗапросы);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗапросыРазрешенийДополнительнойОбработки(Объект, РазрешенияВДанных) Экспорт
	
	Если Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена Тогда
		Возврат Новый Массив();
	КонецЕсли;
	
	БылиРазрешения = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Объект.Ссылка) <> Неопределено;
	ЕстьРазрешения = Объект.Разрешения.Количество() > 0;
	
	Если БылиРазрешения Или ЕстьРазрешения Тогда
		
		Если Объект.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2 Тогда
			
			ЗапрашиваемыеРазрешения = Новый Массив();
			Для Каждого РазрешениеВДанных Из РазрешенияВДанных Цикл
				Разрешение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), РазрешениеВДанных.ВидРазрешения));
				СвойстваВДанных = РазрешениеВДанных.Параметры.Получить();
				ЗаполнитьЗначенияСвойств(Разрешение, СвойстваВДанных);
				ЗапрашиваемыеРазрешения.Добавить(Разрешение);
			КонецЦикла;
			
		Иначе
			
			СтарыеРазрешения = Новый Массив();
			Для Каждого РазрешениеВДанных Из РазрешенияВДанных Цикл
				Разрешение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1", РазрешениеВДанных.ВидРазрешения));
				СвойстваВДанных = РазрешениеВДанных.Параметры.Получить();
				ЗаполнитьЗначенияСвойств(Разрешение, СвойстваВДанных);
				СтарыеРазрешения.Добавить(Разрешение);
			КонецЦикла;
			
			ЗапрашиваемыеРазрешения = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ПреобразоватьРазрешенияВерсии_2_1_3_ВРазрешенияВерсии_2_2_2(Объект, СтарыеРазрешения);
			
		КонецЕсли;
		
		Возврат РаботаВБезопасномРежимеСлужебный.ЗапросыНаИспользованиеВнешнихРесурсовДляВнешнегоМодуля(Объект.Ссылка, ЗапрашиваемыеРазрешения);
		
	Иначе
		
		Возврат Новый Массив();
		
	КонецЕсли;
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьКлючСессииРасширенияБезопасногоРежима(Знач Обработка) Экспорт
	
	Возврат Обработка.УникальныйИдентификатор();
	
КонецФункции

// Только для внутреннего использования.
Функция ПолучитьРазрешенияСессииРасширенияБезопасногоРежима(Знач КлючСессии) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтандартнаяОбработка = Истина;
	ОписанияРазрешений = Неопределено;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПолученииРазрешенийСессииБезопасногоРежима");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПолученииРазрешенийСессииБезопасногоРежима(КлючСессии, ОписанияРазрешений, СтандартнаяОбработка);
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПолучитьСсылку(КлючСессии);
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Разрешения.ВидРазрешения КАК ВидРазрешения,
			|	Разрешения.Параметры КАК Параметры
			|ИЗ
			|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК Разрешения
			|ГДЕ
			|	Разрешения.Ссылка = &Ссылка";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ОписанияРазрешений = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	Результат = Новый Соответствие();
	
	Для Каждого ОписаниеРазрешения из ОписанияРазрешений Цикл
		
		ТипРазрешения = ФабрикаXDTO.Тип(
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
			ОписаниеРазрешения.ВидРазрешения);
		
		Результат.Вставить(ТипРазрешения, ОписаниеРазрешения.Параметры.Получить());
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция ВыполнитьСценарийБезопасногоРежима(Знач КлючСессии, Знач Сценарий, Знач ИсполняемыйОбъект, ПараметрыВыполнения, СохраняемыеПараметры = Неопределено, ОбъектыНазначения = Неопределено) Экспорт
	
	Исключения = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.ПолучитьРазрешенныеМетоды();
	
	Если СохраняемыеПараметры = Неопределено Тогда
		СохраняемыеПараметры = Новый Структура();
	КонецЕсли;
	
	Для Каждого ШагСценария Из Сценарий Цикл
		
		ВыполнятьБезопасно = Истина;
		ИсполняемыйФрагмент = "";
		
		Если ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаОбработки() Тогда
			
			ИсполняемыйФрагмент = "ИсполняемыйОбъект." + ШагСценария.ИмяМетода;
			
		ИначеЕсли ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаКонфигурации() Тогда
			
			ИсполняемыйФрагмент = ШагСценария.ИмяМетода;
			
			Если Исключения.Найти(ШагСценария.ИмяМетода) <> Неопределено Тогда
				ВыполнятьБезопасно = Ложь;
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Неизвестный вид действия для этапа сценария: %1';uk='Невідомий вид дії для етапу сценарію: %1'"),
				ШагСценария.ВидДействия);
			
		КонецЕсли;
		
		НесохраняемыеПараметры = Новый Массив();
		
		ПодстрокаПараметров = "";
		
		ПараметрыМетода = ШагСценария.Параметры;
		Для Каждого ПараметрМетода Из ПараметрыМетода Цикл
			
			Если Не ПустаяСтрока(ПодстрокаПараметров) Тогда
				ПодстрокаПараметров = ПодстрокаПараметров + ", ";
			КонецЕсли;
			
			Если ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраЗначение() Тогда
				
				НесохраняемыеПараметры.Добавить(ПараметрМетода.Значение);
				ПодстрокаПараметров = ПодстрокаПараметров + "НесохраняемыеПараметры.Получить(" +
					НесохраняемыеПараметры.ВГраница() + ")";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКлючСессии() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "КлючСессии";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКоллекцияСохраняемыхЗначений() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраСохраняемоеЗначение() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры." + ПараметрМетода.Значение;
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраОбъектыНазначения() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ОбъектыНазначения";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраПараметрВыполненияКоманды() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ПараметрыВыполнения." + ПараметрМетода.Значение;
				
			Иначе
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Неизвестный параметр для этапа сценария: %1';uk='Невідомий параметр для етапу сценарію: %1'"),
					ПараметрМетода.Вид);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ИсполняемыйФрагмент = ИсполняемыйФрагмент + "(" + ПодстрокаПараметров + ")";
		
		Если ВыполнятьБезопасно <> БезопасныйРежим() Тогда
			УстановитьБезопасныйРежим(ВыполнятьБезопасно);
		КонецЕсли;
		
		Если Не ПустаяСтрока(ШагСценария.СохранениеРезультата) Тогда
			Результат = Вычислить(ИсполняемыйФрагмент);
			СохраняемыеПараметры.Вставить(ШагСценария.СохранениеРезультата, Результат);
		Иначе
			Выполнить(ИсполняемыйФрагмент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Только для внутреннего использования.
Процедура ПроверитьЛегитимностьВыполненияОперации(Знач КлючСессии, Знач Разрешение) Экспорт
	
	ТипТребуемогоРазрешения = Разрешение.Тип();
	
	РазрешенияСессии = ПолучитьРазрешенияСессииРасширенияБезопасногоРежима(КлючСессии);
	ОграниченияРазрешения = РазрешенияСессии.Получить(ТипТребуемогоРазрешения);
	
	Если ОграниченияРазрешения = Неопределено Тогда
		
		ВызватьИсключение ТекстИсключенияРазрешениеНеПредоставлено(
			КлючСессии, ТипТребуемогоРазрешения);
		
	Иначе
		
		ПроверяемыеОграничения = ТипТребуемогоРазрешения.Свойства;
		Для Каждого ПроверяемоеОграничение Из ПроверяемыеОграничения Цикл
			
			ЗначениеОграничения = Неопределено;
			Если ОграниченияРазрешения.Свойство(ПроверяемоеОграничение.ЛокальноеИмя, ЗначениеОграничения) Тогда
				
				Если ЗначениеЗаполнено(ЗначениеОграничения) Тогда
					
					Ограничитель = Разрешение.ПолучитьXDTO(ПроверяемоеОграничение);
					
					Если ЗначениеОграничения <> Ограничитель.Значение Тогда
						
						ВызватьИсключение ТекстИсключенияРазрешениеНеПредоставленоДляОграничителя(
							КлючСессии, ТипТребуемогоРазрешения, ПроверяемоеОграничение, Ограничитель.Значение);
						
					КонецЕсли;
					
				КонецЕсли;
				
			Иначе
				
				Если Не ПроверяемоеОграничение.ВозможноПустое Тогда
					
					ВызватьИсключение ТекстИсключенияНеУстановленОбязательныйОграничитель(
						КлючСессии, ТипТребуемогоРазрешения, ПроверяемоеОграничение);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
Функция ПолучитьФайлИзВременногоХранилища(Знач АдресДвоичныхДанных) Экспорт
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресДвоичныхДанных);
	ДвоичныеДанные.Записать(ВременныйФайл);
	Возврат ВременныйФайл;
	
КонецФункции

// Только для внутреннего использования.
Функция ПроверитьКорректностьВызоваПоОкружению() Экспорт
	
	Возврат БезопасныйРежим() = Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьПредставлениеРазрешений(Знач Разрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	Для Каждого Разрешение Из Разрешения Цикл
		
		ВидРазрешения = Разрешение.ВидРазрешения;
		
		ОписаниеРазрешения = ОписанияРазрешений.Получить(
			ФабрикаXDTO.Тип(
				ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
				ВидРазрешения));
		
		ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
		
		ПредставлениеПараметров = "";
		Параметры = Разрешение.Параметры.Получить();
		
		Если Параметры <> Неопределено Тогда
			
			Для Каждого Параметр Из Параметры Цикл
				
				Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
					ПредставлениеПараметров = ПредставлениеПараметров + ", ";
				КонецЕсли;
				
				ПредставлениеПараметров = ПредставлениеПараметров + Строка(Параметр.Значение);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
			ПредставлениеРазрешения = ПредставлениеРазрешения + " (" + ПредставлениеПараметров + ")";
		КонецЕсли;
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<LI><FONT size=2>%1 <A href=""%2"">%3</A></FONT>",
			ПредставлениеРазрешения,
			"internal:" + ВидРазрешения,
			НСтр("ru='Подробнее...';uk='Докладніше...'"));
		
	КонецЦикла;
	
	Результат = Результат + "</LI></BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьПодробноеОписаниеРазрешения(Знач ВидРазрешения, Знач ПараметрыРазрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	ОписаниеРазрешения = ОписанияРазрешений.Получить(
		ФабрикаXDTO.Тип(
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
			ВидРазрешения));
	
	ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
	РасшифровкаРазрешения = ОписаниеРазрешения.Описание;
	
	ОписанияПараметров = Неопределено;
	ЕстьПараметры = ОписаниеРазрешения.Свойство("Параметры", ОписанияПараметров);
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><STRONG><FONT size=4>%1</FONT></STRONG></P>",
		ПредставлениеРазрешения);
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><FONT size=2>%1%2</FONT></P>", РасшифровкаРазрешения, ?(
			ЕстьПараметры,
			НСтр("ru=' со следующими ограничениями:';uk=' з наступними обмеженнями:'"),
			"."));
	
	Если ЕстьПараметры Тогда
		
		Результат = Результат + "<UL>";
		
		Для Каждого Параметр Из ОписанияПараметров Цикл
			
			ИмяПараметра = Параметр.Имя;
			ЗначениеПараметра = ПараметрыРазрешения[ИмяПараметра];
			
			Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Параметр.Описание, ЗначениеПараметра);
				
			Иначе
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"<B>%1</B>", Параметр.ОписаниеЛюбогоЗначения);
				
			КонецЕсли;
			
			Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<LI><FONT size=2>%1</FONT>", ОписаниеПараметра);
			
		КонецЦикла;
		
		Результат = Результат + "</LI></UL>";
		
	КонецЕсли;
	
	ОписаниеПоследствий = "";
	Если ОписаниеРазрешения.Свойство("Последствия", ОписаниеПоследствий) Тогда
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<P><FONT size=2><EM>%1</EM></FONT></P>",
			ОписаниеПоследствий);
		
	КонецЕсли;
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + "</BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция ТекстИсключенияРазрешениеНеПредоставлено(Знач КлючСессии, Знач ТипТребуемогоРазрешения)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Дополнительному отчету или обработке %1 не предоставлено разрешение {%2}%3!';uk='Додатковому звіту або обробці %1 не наданий дозвіл {%2}%3!'"),
			Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя);
	
КонецФункции

// Только для внутреннего использования.
Функция ТекстИсключенияРазрешениеНеПредоставленоДляОграничителя(Знач КлючСессии, Знач ТипТребуемогоРазрешения, Знач ПроверяемоеОграничение, Знач Ограничитель)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Для дополнительного отчета или обработки %1"
"не предоставлено разрешение {%2}%3 при значении"
"ограничителя %4 равном %5!';uk='Для додаткового звіту або обробки %1"
"не наданий дозвіл {%2}%3 при значенні"
"обмежника %4 рівному %5!'"),
		Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя,
		ПроверяемоеОграничение.ЛокальноеИмя, Ограничитель);
	
КонецФункции

// Только для внутреннего использования.
Функция ТекстИсключенияНеУстановленОбязательныйОграничитель(Знач КлючСессии, Знач ТипТребуемогоРазрешения, Знач ПроверяемоеОграничение)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Для дополнительного отчета или обработки %1"
"при предоставлении разрешения {%2}%3 не был указан обязательный ограничитель %4!';uk=""Для додаткового звіту або обробки %1"
"при наданні дозволу {%2}%3 не був зазначений обов'язковий обмежник %4!"""),
		Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя,
		ПроверяемоеОграничение.ЛокальноеИмя);
	
КонецФункции

#КонецОбласти
