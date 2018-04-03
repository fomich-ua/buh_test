#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВнутреннееСостояние

Перем ТекущийКонтейнер;
Перем ТекущиеЗагружаемыеТипы;
Перем ТекущиеИсключаемыеТипы;
Перем ТекущиеОбработчики;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ЗагружаемыеТипы, ИсключаемыеТипы, Обработчики) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущиеЗагружаемыеТипы = ЗагружаемыеТипы;
	ТекущиеЗагружаемыеТипы = СортироватьЗагружаемыеТипы(ТекущиеЗагружаемыеТипы);
	ТекущиеИсключаемыеТипы = ИсключаемыеТипы;
	ТекущиеОбработчики = Обработчики;
	
КонецПроцедуры

Процедура ЗагрузитьДанные() Экспорт
	
	ВыполнитьЗаменуСсылок();
	ВыполнитьЗагрузкуДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Типы сортируются по убыванию приоритета, сериализаторы выбирают их из массива с конца.
//
// Параметры:
//	ЗагружаемыеТипы - Массив - массив метаданных.
//
// Возвращаемое значение:
//	Массив - отсортированный массив метаданных по приоритету.
//
Функция СортироватьЗагружаемыеТипы(Знач ЗагружаемыеТипы)
	
	Сортировка = Новый ТаблицаЗначений();
	Сортировка.Колонки.Добавить("ОбъектМетаданных");
	Сортировка.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число"));
	
	Для каждого ОбъектМетаданных Из ЗагружаемыеТипы Цикл
		
		Строка = Сортировка.Добавить();
		Строка.ОбъектМетаданных = ОбъектМетаданных;
		
		Если ВыгрузкаЗагрузкаДанныхСлужебный.ЭтоКонстанта(ОбъектМетаданных) Тогда
			Строка.Приоритет = 0;
		ИначеЕсли ВыгрузкаЗагрузкаДанныхСлужебный.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
			Строка.Приоритет = 1;
		ИначеЕсли ВыгрузкаЗагрузкаДанныхСлужебный.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
			Строка.Приоритет = 2;
		ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных.Родитель()) Тогда // Перерасчеты
			Строка.Приоритет = 3;
		ИначеЕсли Метаданные.Последовательности.Содержит(ОбъектМетаданных) Тогда
			Строка.Приоритет = 4;
		Иначе
			ШаблонТекста = НСтр("ru='Выгрузка объекта метаданных не поддерживается %1';uk=""Вивантаження об'єкта метаданих не підтримується %1""");
			ТекстСообщения = ТехнологияСервисаИнтеграцияСБСП.ПодставитьПараметрыВСтроку(ШаблонТекста, ОбъектМетаданных.ПолноеИмя());
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
	Сортировка.Сортировать("Приоритет");
	
	Возврат Сортировка.ВыгрузитьКолонку("ОбъектМетаданных");
	
КонецФункции

Процедура ВыполнитьЗаменуСсылок()
	
	ПотокЗаменыСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаменыСсылок.Создать();
	ПотокЗаменыСсылок.Инициализировать(ТекущийКонтейнер, ТекущиеОбработчики);
	
	МенеджерПересозданияСсылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерПересозданияСсылок.Создать();
	МенеджерПересозданияСсылок.Инициализировать(ТекущийКонтейнер, ПотокЗаменыСсылок);
	МенеджерПересозданияСсылок.ВыполнитьПересозданиеСсылок();
	
	МенеджерСопоставленияСслылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерСопоставленияСсылок.Создать();
	МенеджерСопоставленияСслылок.Инициализировать(ТекущийКонтейнер, ПотокЗаменыСсылок, ТекущиеОбработчики);
	МенеджерСопоставленияСслылок.ВыполнитьСопоставлениеСсылок();
	
	ПотокЗаменыСсылок.Закрыть();
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанных()
	
	Для Каждого ОбъектМетаданных Из ТекущиеЗагружаемыеТипы Цикл
		
		Если ТекущиеИсключаемыеТипы.Найти(ОбъектМетаданных) = Неопределено Тогда
			
			Отказ = Ложь;
			ТекущиеОбработчики.ПередЗагрузкойТипа(ТекущийКонтейнер, ОбъектМетаданных, Отказ);
			
			Если Не Отказ Тогда
				ЗагрузитьДанныеОбъектаИнформационнойБазы(ОбъектМетаданных);
			КонецЕсли;
			
			ТекущиеОбработчики.ПослеЗагрузкиТипа(ТекущийКонтейнер, ОбъектМетаданных);
			
		Иначе
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru='ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаПропущена';uk='ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаПропущена'", Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Информация,
				ОбъектМетаданных,
				,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Загрузка данных объекта метаданных %1 пропущена, т.к. он включен в"
"список объектов метаданных, исключаемых из выгрузки и загрузки данных';uk=""Завантаження даних об'єкта метаданих %1 пропущене, тому що він включений в"
"список об'єктів метаданих, що виключаються з вивантаження і завантаження даних""", Метаданные.ОсновнойЯзык.КодЯзыка),
					ОбъектМетаданных.ПолноеИмя()
				)
			);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Загружает все необходимые данные для объета информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ОбъектМетаданных - загружаемый объект метаданных.
//	Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ЗагрузитьДанныеОбъектаИнформационнойБазы(Знач ОбъектМетаданных)
	
	ИмяФайла = ТекущийКонтейнер.ПолучитьФайлИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.InfobaseData(), ОбъектМетаданных.ПолноеИмя());
	Если ИмяФайла = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПотокЧтения = Обработки.ВыгрузкаЗагрузкаДанныхПотокЧтенияДанныхИнформационнойБазы.Создать();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	
	Пока ПотокЧтения.ПрочитатьОбъектДанныхИнформационнойБазы() Цикл
		
		Объект = ПотокЧтения.ТекущийОбъект();
		Артефакты = ПотокЧтения.АртефактыТекущегоОбъекта();
		
		ЗаписатьОбъектВИнформационнуюБазу(Объект, Артефакты);
		
	КонецЦикла;
	
КонецПроцедуры

// Записывает объект в информационную базу.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - загружаемый объект метаданных.
//	АртефактыОбъекта - Массив - массив объекотов XDTO.
//	Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗаписатьОбъектВИнформационнуюБазу(Объект, АртефактыОбъекта)
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередЗагрузкойОбъекта(ТекущийКонтейнер, Объект, АртефактыОбъекта, Отказ);
	
	Если Не Отказ Тогда
		
		Если ВыгрузкаЗагрузкаДанныхСлужебный.ЭтоКонстанта(Объект.Метаданные()) Тогда
			
			Если Не ЗначениеЗаполнено(Объект.Значение) Тогда
				// Поскольку константы предварительно очищались - повторная перезапись пустых
				// значений не требуется
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Объект.ОбменДанными.Загрузка = Истина;
		
		Если ВыгрузкаЗагрузкаДанныхСлужебный.ЭтоНезависимыйНаборЗаписей(Объект.Метаданные()) Тогда
			
			// Т.к. независмые наборы записей выгружаются курсорными запросами - запись
			// выполняется без замещения
			Объект.Записать(Истина);
			
		Иначе
			
			Объект.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеЗагрузкиОбъекта(ТекущийКонтейнер, Объект, АртефактыОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
