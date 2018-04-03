///////////////////////////////////////////////////////////////////////////////////
// РаботаВМоделиСервисаПереопределяемый.
//
///////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при удалении области данных.
// В процедуре необходимо удалить данные области данных, которые не
// могут быть удалены стандартным механизмом
//
// Параметры:
// ОбластьДанных - Тип значения разделителя - значение разделителя
// удаляемой области данных.
// 
Процедура ПриУдаленииОбластиДанных(Знач ОбластьДанных) Экспорт
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПолучитьТаблицуПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	
КонецПроцедуры

// Вызывается перед попыткой получения значений параметров ИБ из одноименных
// констант.
//
// Параметры:
// ИменаПараметров - Массив строк - имена параметров, значения которых необходимо получить.
// В случае если значение параметра получается в данной процедуре, необходимо удалить
// имя обработанного параметра из массива.
// ЗначенияПараметров - Структура - значения параметров.
//
Процедура ПриПолученииЗначенийПараметровИБ(Знач ИменаПараметров, Знач ЗначенияПараметров) Экспорт
	
КонецПроцедуры

// Вызывается перед попыткой записи значений параметров ИБ в одноименные
// константы.
//
// Параметры:
// ЗначенияПараметров - Структура - значения параметров которые требуется установить.
// В случае если значение параметра устанавливается в данной процедуре из структуры
// необходимо удалить соответствую пару КлючИЗначение
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
	
КонецПроцедуры

// Вызывается при включении разделения данных по областям данных,
// при первом запуске конфигурации с параметром "ИнициализироватьРазделеннуюИБ" ("InitializeSeparatedIB").
// 
// В частности, здесь следует размещать код по включению регламентных заданий, 
// используемых только при включенном разделении данных, 
// и соответственно, по выключению заданий, используемых только при выключенном разделении данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
КонецПроцедуры

// Устанавливает пользователю права по умолчанию.
// Вызывается при работе в модели сервиса, в случае обновления в менеджере
// сервиса прав пользователя без прав администрирования.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - пользователь, которому
//   требуется установить права по умолчанию
//
Процедура УстановитьПраваПоУмолчанию(Пользователь) Экспорт
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Пользователь);
	
	ПрофильБухгалтер = Справочники.ПрофилиГруппДоступа.НайтиПоНаименованию("Бухгалтер");
	Если ПрофильБухгалтер = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеПрофилиГруппДоступа = Метаданные.Справочники.ПрофилиГруппДоступа;
	
	Профили = Новый ТаблицаЗначений();
	Профили.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Булево"));
	Профили.Колонки.Добавить("Профиль", Новый ОписаниеТипов("СправочникСсылка.ПрофилиГруппДоступа"));
	
	Профиль = Профили.Добавить();
	Профиль.Пометка = Истина;
	Профиль.Профиль = ПрофильБухгалтер;
	
	ВидыДоступа = Новый ТаблицаЗначений();
	ВидыДоступа.Колонки.Добавить("ГруппаДоступа", Новый ОписаниеТипов("СправочникСсылка.ПрофилиГруппДоступа"));
	ВидыДоступа.Колонки.Добавить("ВидДоступа", МетаданныеПрофилиГруппДоступа.ТабличныеЧасти.ВидыДоступа.Реквизиты.ВидДоступа.Тип);
	ВидыДоступа.Колонки.Добавить("ВсеРазрешены", МетаданныеПрофилиГруппДоступа.ТабличныеЧасти.ВидыДоступа.Реквизиты.ВсеРазрешены.Тип);
	
	ВидДоступа = ВидыДоступа.Добавить();
	ВидДоступа.ГруппаДоступа = ПрофильБухгалтер;
	ВидДоступа.ВидДоступа = Справочники.Организации.ПустаяСсылка();
	ВидДоступа.ВсеРазрешены = Истина;
	
	ЗначенияДоступа = Новый ТаблицаЗначений();
	ЗначенияДоступа.Колонки.Добавить("ГруппаДоступа", Новый ОписаниеТипов("СправочникСсылка.ПрофилиГруппДоступа"));
	ЗначенияДоступа.Колонки.Добавить("ВидДоступа", МетаданныеПрофилиГруппДоступа.ТабличныеЧасти.ЗначенияДоступа.Реквизиты.ВидДоступа.Тип);
	ЗначенияДоступа.Колонки.Добавить("ЗначениеДоступа", МетаданныеПрофилиГруппДоступа.ТабличныеЧасти.ЗначенияДоступа.Реквизиты.ЗначениеДоступа.Тип);
	
	// Получение списка изменений.
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Запрос.УстановитьПараметр(
		"Профили", Профили);
	
	Запрос.УстановитьПараметр(
		"ВидыДоступа", ВидыДоступа);
	
	Запрос.УстановитьПараметр(
		"ЗначенияДоступа", ЗначенияДоступа);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Профили.Профиль КАК Ссылка,
	|	Профили.Пометка
	|ПОМЕСТИТЬ Профили
	|ИЗ
	|	&Профили КАК Профили
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыДоступа.ГруппаДоступа КАК Профиль,
	|	ВидыДоступа.ВидДоступа,
	|	ВидыДоступа.ВсеРазрешены
	|ПОМЕСТИТЬ ВидыДоступа
	|ИЗ
	|	&ВидыДоступа КАК ВидыДоступа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗначенияДоступа.ГруппаДоступа КАК Профиль,
	|	ЗначенияДоступа.ВидДоступа,
	|	ЗначенияДоступа.ЗначениеДоступа
	|ПОМЕСТИТЬ ЗначенияДоступа
	|ИЗ
	|	&ЗначенияДоступа КАК ЗначенияДоступа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Профили.Ссылка,
	|	ЕСТЬNULL(ГруппыДоступа.Ссылка, НЕОПРЕДЕЛЕНО) КАК ПерсональнаяГруппаДоступа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ПОМЕСТИТЬ ТекущиеПрофили
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК Профили
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО Профили.Ссылка = ГруппыДоступа.Профиль
	|			И (ГруппыДоступа.Пользователь = &Пользователь
	|				ИЛИ Профили.Ссылка В (ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО (ГруппыДоступа.Ссылка = ГруппыДоступаПользователи.Ссылка)
	|			И (ГруппыДоступаПользователи.Пользователь = &Пользователь)
	|ГДЕ
	|	НЕ Профили.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	ГруппыДоступаВидыДоступа.ВидДоступа,
	|	ГруппыДоступаВидыДоступа.ВсеРазрешены
	|ПОМЕСТИТЬ ТекущиеВидыДоступа
	|ИЗ
	|	ТекущиеПрофили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ВидыДоступа КАК ГруппыДоступаВидыДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаВидыДоступа.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	ГруппыДоступаЗначенияДоступа.ВидДоступа,
	|	ГруппыДоступаЗначенияДоступа.ЗначениеДоступа
	|ПОМЕСТИТЬ ТекущиеЗначенияДоступа
	|ИЗ
	|	ТекущиеПрофили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ЗначенияДоступа КАК ГруппыДоступаЗначенияДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаЗначенияДоступа.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиИзмененыхГрупп.Профиль
	|ПОМЕСТИТЬ ПрофилиИзмененыхГрупп
	|ИЗ
	|	(ВЫБРАТЬ
	|		Профили.Ссылка КАК Профиль
	|	ИЗ
	|		Профили КАК Профили
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|			ПО Профили.Ссылка = ТекущиеПрофили.Ссылка
	|	ГДЕ
	|		Профили.Пометка <> ТекущиеПрофили.Пометка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВидыДоступа.Профиль
	|	ИЗ
	|		ВидыДоступа КАК ВидыДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеВидыДоступа КАК ТекущиеВидыДоступа
	|			ПО ВидыДоступа.Профиль = ТекущиеВидыДоступа.Профиль
	|				И ВидыДоступа.ВидДоступа = ТекущиеВидыДоступа.ВидДоступа
	|				И ВидыДоступа.ВсеРазрешены = ТекущиеВидыДоступа.ВсеРазрешены
	|	ГДЕ
	|		ТекущиеВидыДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТекущиеВидыДоступа.Профиль
	|	ИЗ
	|		ТекущиеВидыДоступа КАК ТекущиеВидыДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВидыДоступа КАК ВидыДоступа
	|			ПО (ВидыДоступа.Профиль = ТекущиеВидыДоступа.Профиль)
	|				И (ВидыДоступа.ВидДоступа = ТекущиеВидыДоступа.ВидДоступа)
	|				И (ВидыДоступа.ВсеРазрешены = ТекущиеВидыДоступа.ВсеРазрешены)
	|	ГДЕ
	|		ВидыДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗначенияДоступа.Профиль
	|	ИЗ
	|		ЗначенияДоступа КАК ЗначенияДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеЗначенияДоступа КАК ТекущиеЗначенияДоступа
	|			ПО ЗначенияДоступа.Профиль = ТекущиеЗначенияДоступа.Профиль
	|				И ЗначенияДоступа.ВидДоступа = ТекущиеЗначенияДоступа.ВидДоступа
	|				И ЗначенияДоступа.ЗначениеДоступа = ТекущиеЗначенияДоступа.ЗначениеДоступа
	|	ГДЕ
	|		ТекущиеЗначенияДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТекущиеЗначенияДоступа.Профиль
	|	ИЗ
	|		ТекущиеЗначенияДоступа КАК ТекущиеЗначенияДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ЗначенияДоступа КАК ЗначенияДоступа
	|			ПО (ЗначенияДоступа.Профиль = ТекущиеЗначенияДоступа.Профиль)
	|				И (ЗначенияДоступа.ВидДоступа = ТекущиеЗначенияДоступа.ВидДоступа)
	|				И (ЗначенияДоступа.ЗначениеДоступа = ТекущиеЗначенияДоступа.ЗначениеДоступа)
	|	ГДЕ
	|		ЗначенияДоступа.ВидДоступа ЕСТЬ NULL ) КАК ПрофилиИзмененыхГрупп
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	СправочникПрофили.Наименование КАК ПрофильНаименование,
	|	Профили.Пометка,
	|	ТекущиеПрофили.ПерсональнаяГруппаДоступа
	|ИЗ
	|	ПрофилиИзмененыхГрупп КАК ПрофилиИзмененыхГрупп
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Профили КАК Профили
	|		ПО ПрофилиИзмененыхГрупп.Профиль = Профили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|		ПО ПрофилиИзмененыхГрупп.Профиль = ТекущиеПрофили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа КАК СправочникПрофили
	|		ПО (СправочникПрофили.Ссылка = ПрофилиИзмененыхГрупп.Профиль)";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
			ЗаблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
			ГруппаДоступаОбъект = Выборка.ПерсональнаяГруппаДоступа.ПолучитьОбъект();
		Иначе
			// Создание персональной группы доступа.
			ГруппаДоступаОбъект = Справочники.ГруппыДоступа.СоздатьЭлемент();
			ГруппаДоступаОбъект.Родитель     = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
			ГруппаДоступаОбъект.Наименование = Выборка.ПрофильНаименование;
			ГруппаДоступаОбъект.Пользователь = Пользователь;
			ГруппаДоступаОбъект.Профиль      = Выборка.Профиль;
		КонецЕсли;
		
		Если Выборка.Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
			
			Если Выборка.Пометка Тогда
				Если ГруппаДоступаОбъект.Пользователи.Найти(
						Пользователь, "Пользователь") = Неопределено Тогда
					
					ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Пользователь;
				КонецЕсли;
			Иначе
				ОписаниеПользователя =  ГруппаДоступаОбъект.Пользователи.Найти(
					Пользователь, "Пользователь");
				
				Если ОписаниеПользователя <> Неопределено Тогда
					ГруппаДоступаОбъект.Пользователи.Удалить(ОписаниеПользователя);
					
					Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
						// Проверка пустого списка пользователей ИБ в группе доступа Администраторы.
						ОписаниеОшибки = "";
						УправлениеДоступомСлужебный.ПроверитьНаличиеПользователяИБВГруппеДоступаАдминистраторы(
							ГруппаДоступаОбъект.Пользователи, ОписаниеОшибки);
						
						Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
							ВызватьИсключение
								НСтр("ru='Профиль Администратор должен быть хотя бы у одного пользователя,"
"которому разрешен вход в программу.';uk='Профіль Адміністратор повинен бути хоча б у одного користувача,"
"якому дозволений вхід в програму.'");
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ГруппаДоступаОбъект.Пользователи.Очистить();
			Если Выборка.Пометка Тогда
				ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Пользователь;
			КонецЕсли;
			
			Отбор = Новый Структура("ГруппаДоступа", Выборка.Профиль);
			СтрокиВидыДоступа = ВидыДоступа.НайтиСтроки(Отбор);
			СтрокиЗначенияДоступа = ЗначенияДоступа.НайтиСтроки(Отбор);
			
			ГруппаДоступаОбъект.ВидыДоступа.Загрузить(
				ВидыДоступа.Скопировать(СтрокиВидыДоступа, "ВидДоступа, ВсеРазрешены"));
			
			ГруппаДоступаОбъект.ЗначенияДоступа.Загрузить(
				ЗначенияДоступа.Скопировать(СтрокиЗначенияДоступа, "ВидДоступа, ЗначениеДоступа"));
		КонецЕсли;
		
		Попытка
			ГруппаДоступаОбъект.Записать();
		Исключение
			ПарольПользователяСервиса = Неопределено;
			ВызватьИсключение;
		КонецПопытки;
		
		Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
			РазблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
