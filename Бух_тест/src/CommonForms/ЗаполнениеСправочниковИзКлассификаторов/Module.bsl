////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("Code", "Код");
	СоответствиеПолей.Вставить("Name", "Наименование");
	
	Параметры.Свойство("Заголовок", Заголовок);
	Параметры.Свойство("ИмяСправочника", ИмяСправочника);
	Параметры.Свойство("ИмяМакетаКлассификатора", ИмяМакетаКлассификатора);
	
	Если Параметры.Свойство("СоответствиеПолей") Тогда
		
		Для каждого ЭлементСоответствия Из Параметры.СоответствиеПолей Цикл
			СоответствиеПолей.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
		КонецЦикла;
		
	КонецЕсли; 
	
	СоответствиеПолейКлассификатораРеквизитам = Новый ФиксированноеСоответствие(СоответствиеПолей);
	
	ОтображатьЭлементыУправлениеИерархией = ИмяСправочника = "КлассификаторСпециальностейПоОбразованию";
	Элементы.КлассификаторДерево.Видимость = ОтображатьЭлементыУправлениеИерархией;
	Элементы.КлассификаторСписок.Видимость = ОтображатьЭлементыУправлениеИерархией;
	
	ЗаполнитьКлассификатор(ИмяМакетаКлассификатора, ИмяСправочника);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗагруженВесьКлассификатор() Тогда
		
		Отказ = Истина;
		СообщитьОЗагруженностиВсегоКлассификатора();
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Классификатор

// Загружает Выбранную строку классификатора
//
&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда
		Если Элементы.Классификатор.Развернут(Элемент.ТекущаяСтрока) Тогда
			Элементы.Классификатор.Свернуть(Элемент.ТекущаяСтрока);
		Иначе
			Элементы.Классификатор.Развернуть(Элемент.ТекущаяСтрока);
		КонецЕсли;
	Иначе
		ЗагрузитьСтрокуКлассификатораПоИдентификатору(Элемент.ТекущаяСтрока);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СообщитьОЗагруженностиВсегоКлассификатора()
	ТекстПредупреждения = НСтр("ru='Загружен весь классификатор';uk='Завантажений весь класифікатор'");
	ПоказатьПредупреждение(, ТекстПредупреждения);
КонецПроцедуры

// Загружает классификатор из макета в дерево значений
//
&НаСервере
Процедура ЗаполнитьКлассификатор(ИмяКлассификтаора, ИмяЗагружаемогоСправочника)
	
	МассивРанееЗагруженных  = Новый Массив;
	Запрос = Новый Запрос;
	
	ОписаниеПолейЗапроса = "";
	
	РеквизитКод = СоответствиеПолейКлассификатораРеквизитам.Получить("Code");
	ЕстьКод = НЕ ПустаяСтрока(РеквизитКод);
	Если ЕстьКод Тогда
		ОписаниеПолейЗапроса = "Классификатор." + РеквизитКод + " КАК Код";
	КонецЕсли;
	
	РеквизитРаименование = СоответствиеПолейКлассификатораРеквизитам.Получить("Name");
	ЕстьНаименование = НЕ ПустаяСтрока(РеквизитРаименование);
	Если ЕстьНаименование Тогда
		ОписаниеПолейЗапроса = ?(ПустаяСтрока(ОписаниеПолейЗапроса), "", ОписаниеПолейЗапроса + "," + Символы.ПС) +
			"Классификатор." + РеквизитРаименование + " КАК Наименование";
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ОписаниеПолейЗапроса
	|ИЗ
	|	Справочник." + ИмяЗагружаемогоСправочника + " КАК Классификатор";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОписаниеПолейЗапроса", ОписаниеПолейЗапроса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаИдентификатор = "";
		
		Если ЕстьКод Тогда
			СтрокаИдентификатор = СокрЛП(Выборка.Код);
		КонецЕсли; 
		
		Если ЕстьНаименование Тогда
			СтрокаИдентификатор = СтрокаИдентификатор + СокрЛП(Выборка.Наименование);
		КонецЕсли; 
		
		Если ПустаяСтрока(СтрокаИдентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРанееЗагруженных.Добавить(СтрокаИдентификатор);
		
	КонецЦикла;
	
	КоллекцияВерхнегоУровня = Классификатор.ПолучитьЭлементы();
	
	МенеджерСправочника = Справочники[ИмяЗагружаемогоСправочника];
	
	КлассификаторXML = МенеджерСправочника.ПолучитьМакет(ИмяКлассификтаора).ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	ЕстьПолеКод = КлассификаторТаблица.Колонки.Найти("Code") <> Неопределено;
	ЕстьПолеУровень = КлассификаторТаблица.Колонки.Найти("Level") <> Неопределено;
	ЕстьПолеНаименование = КлассификаторТаблица.Колонки.Найти("Name") <> Неопределено;
	
	МассивРодителей = Новый Массив(50);
	ТекущийУровень = 0;
	
	Для Каждого СтрокаКлассификаторТаблица Из КлассификаторТаблица Цикл
		
		Если ЕстьПолеУровень Тогда
			
			ТекущийУровень = Число(СтрокаКлассификаторТаблица.Level);
			Если ТекущийУровень = 0 Тогда
				КоллекцияРодителя = Классификатор.ПолучитьЭлементы();
			Иначе 
				
				Родитель = МассивРодителей[ТекущийУровень - 1];
				Родитель.ИндексКартинки = 0;
				КоллекцияРодителя = Родитель.ПолучитьЭлементы();
				
			КонецЕсли;
			
		Иначе
			КоллекцияРодителя = Классификатор.ПолучитьЭлементы();
		КонецЕсли; 
		
		СтрокаИдентификатор = "";
		НоваяЗаписьКлассификатора = КоллекцияРодителя.Добавить();
		
		Для каждого ЭлементСоответствия Из СоответствиеПолейКлассификатораРеквизитам Цикл
			
			Если НЕ ПустаяСтрока(ЭлементСоответствия.Значение) Тогда
				НоваяЗаписьКлассификатора.ЗначенияПолейСтрокиКлассификатора.Добавить(
					СтрокаКлассификаторТаблица[ЭлементСоответствия.Ключ],
					ЭлементСоответствия.Значение);
			КонецЕсли; 
				
		КонецЦикла;
		
		Если ЕстьПолеКод Тогда
			
			НоваяЗаписьКлассификатора.Код =	СокрЛП(СтрокаКлассификаторТаблица.Code);
			СтрокаИдентификатор = НоваяЗаписьКлассификатора.Код;
			
		КонецЕсли;
		
		Если ЕстьПолеНаименование Тогда
			
			НоваяЗаписьКлассификатора.Наименование = СокрЛП(СтрокаКлассификаторТаблица.Name);
			СтрокаИдентификатор = СтрокаИдентификатор + НоваяЗаписьКлассификатора.Наименование;
			
		КонецЕсли;
		
		НоваяЗаписьКлассификатора.ИндексКартинки = 2;
		
		Если МассивРанееЗагруженных.Найти(СтрокаИдентификатор) <> Неопределено Тогда
			НоваяЗаписьКлассификатора.Загружен = Истина;
		КонецЕсли;
		
		МассивРодителей[ТекущийУровень] = НоваяЗаписьКлассификатора;
		
	КонецЦикла;
	
КонецПроцедуры

// Загружает весь классификатор
&НаСервере
Процедура ЗагрузитьВсе()
	ЗагрузитьСтрокуКлассификатора(Классификатор);
КонецПроцедуры

// Загружает отмеченные строки классификатора
//
&НаСервере
Процедура ЗагрузитьТекущий()
	Для Каждого ВыделеннаяСтрока Из Элементы.Классификатор.ВыделенныеСтроки Цикл
		ЗагрузитьСтрокуКлассификатораПоИдентификатору(ВыделеннаяСтрока);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтрокуКлассификатораПоИдентификатору(ИдентификаторТекущейСтроки)
	НайденнаяСтрока = Классификатор.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Если НайденнаяСтрока <> Неопределено Тогда
		ЗагрузитьСтрокуКлассификатора(НайденнаяСтрока);
	КонецЕсли; 
КонецПроцедуры

// Загружает строку классификатора, если предена строка, с одержащая строки
// производит рекурсивную загрузку этих строк
&НаСервере
Процедура ЗагрузитьСтрокуКлассификатора(ЗагружаемыйЭлемент)
	
	Если ЗагружаемыйЭлемент.ПолучитьЭлементы().Количество() > 0 Тогда
		
		Для Каждого СтрокаКоллекции Из ЗагружаемыйЭлемент.ПолучитьЭлементы() Цикл
			ЗагрузитьСтрокуКлассификатора(СтрокаКоллекции);
		КонецЦикла;
		
	ИначеЕсли НЕ ЗагружаемыйЭлемент.Загружен Тогда
		
		НовыйОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
		
		Для каждого ЭлементСписка Из ЗагружаемыйЭлемент.ЗначенияПолейСтрокиКлассификатора Цикл
			НовыйОбъект[ЭлементСписка.Представление] = ЭлементСписка.Значение;
		КонецЦикла;
		
		НовыйОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
		
		Попытка
			НовыйОбъект.Записать();
			ЗагружаемыйЭлемент.Загружен = Истина;
		Исключение
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось загрузить элемент %1 (код: %2)';uk='Не вдалося завантажити елемент %1 (код: %2)'"),
				ЗагружаемыйЭлемент.Наименование,
				ЗагружаемыйЭлемент.Код);
		КонецПопытки;
			
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, на предмет загрузки всего классификатора
//
&НаКлиенте
Функция ЗагруженВесьКлассификатор()
	Возврат ЗагруженыСтроки(Классификатор.ПолучитьЭлементы());
КонецФункции

// Проверяет коллекцияю строк на предмет загруженности
//
&НаКлиенте
Функция ЗагруженыСтроки(КоллекцияСтрок)
	Для Каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		Если СтрокаКоллекции.ПолучитьЭлементы().Количество() > 0 Тогда
			РезультатПроверки = ЗагруженыСтроки(СтрокаКоллекции.ПолучитьЭлементы());
		Иначе
			РезультатПроверки = СтрокаКоллекции.Загружен;
		КонецЕсли;
		Если НЕ РезультатПроверки Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	ЗагрузитьТекущий();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьВсе(Команда)
	ЗагрузитьВсе();
	СообщитьОЗагруженностиВсегоКлассификатора();
	Закрыть();
КонецПроцедуры

