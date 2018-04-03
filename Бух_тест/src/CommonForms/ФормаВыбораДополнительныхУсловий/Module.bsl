////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Заголовок = Параметры.ЗаголовокФормыВыбора;
	СтруктураЗаполняемыхЗначений = Новый Структура("ИмяТаблицыДляЗаполнения, ИмяКолонкиДляЗаполнения", Параметры.ИмяЭлементаФормыДляЗаполнения, Параметры.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Если Параметры.ПараметрыВнешнегоСоединения = Неопределено Тогда
		
		Если ЗначениеЗаполнено(Параметры.МассивВыбранныхЗначений) Тогда
			МассивПереданныхЗначений = Параметры.МассивВыбранныхЗначений;
		Иначе
			МассивПереданныхЗначений = Новый Массив();
		КонецЕсли;
		
		ЗаполнитьСписокДоступныхЗначений(МассивПереданныхЗначений, Параметры.ИмяТаблицыВыбора, Параметры.КоллекцияФильтров);
	Иначе
		Если Параметры.ПараметрыВнешнегоСоединения.ТипСоединения = "ВнешнееСоединение" Тогда
			СтрокаСообщенияОбОшибке = "";
			ВнешнееСоединение = ОбменДаннымиПовтИсп.УстановитьВнешнееСоединение(Параметры.ПараметрыВнешнегоСоединения, СтрокаСообщенияОбОшибке);
		
			Если ВнешнееСоединение = Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщенияОбОшибке,,,, Отказ);
				Возврат;
			КонецЕсли;
			
			СвойстваОбъектаМетаданных = ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.СвойстваОбъектаМетаданных(Параметры.ИмяТаблицыВыбора);
			
			Если ЗначениеЗаполнено(Параметры.МассивВыбранныхЗначений) Тогда
				МассивПереданныхЗначений = Параметры.МассивВыбранныхЗначений;
			Иначе
				МассивПереданныхЗначений = Новый Массив();
			КонецЕсли;
			
			Если Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_1_1_7
				Или Параметры.ПараметрыВнешнегоСоединения.ВерсияКорреспондента_2_0_1_6 Тогда
				ТаблицаБазыКорреспондента = ОбщегоНазначения.ЗначениеИзСтрокиXML(ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.ПолучитьОбъектыТаблицы_2_0_1_6(Параметры.ИмяТаблицыВыбора));
			Иначе
				ТаблицаБазыКорреспондента = ЗначениеИзСтрокиВнутр(ВнешнееСоединение.ОбменДаннымиВнешнееСоединение.ПолучитьОбъектыТаблицы(Параметры.ИмяТаблицыВыбора));
			КонецЕсли;

			ЗаполнитьСписокДоступныхЗначенийВнешнееСоединение(СписокВыбираемыхЗначений, МассивПереданныхЗначений, ТаблицаБазыКорреспондента);
			Если ЗначениеЗаполнено(Параметры.КоллекцияФильтров) Тогда
				ПроверитьПрохождениеФильтраВнешнееСоединение(Параметры.КоллекцияФильтров);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения",          СтруктураЗаполняемыхЗначений.ИмяТаблицыДляЗаполнения);
	ПараметрыЗакрытияФормы.Вставить("ИмяКолонкиДляЗаполнения",          СтруктураЗаполняемыхЗначений.ИмяКолонкиДляЗаполнения);
	
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	ЗаполнитьОтметки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ЗаполнитьОтметки(Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьСписокДоступныхЗначений(МассивПереданыхЗначений, ВидСправочника, ДополнительныеУсловия = Неопределено)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	СправочникДляВыбораОтоборов.Ссылка КАК Представление,
	                      |	ВЫБОР
	                      |		КОГДА СправочникДляВыбораОтоборов.Ссылка В (&МассивПереданыхЗначений)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК Пометка
	                      |ИЗ
	                      |	%ВидСправочника% КАК СправочникДляВыбораОтоборов
	                      |ГДЕ
	                      |	СправочникДляВыбораОтоборов.ПометкаУдаления = ЛОЖЬ");
	
	Если ЗначениеЗаполнено(ДополнительныеУсловия) Тогда
		Для Каждого Фильтр Из ДополнительныеУсловия Цикл
			Запрос.Текст = ДобавитьТекстУсловия(Запрос.Текст, " СправочникДляВыбораОтоборов.", "И", Фильтр);
			Запрос.УстановитьПараметр(Фильтр.ИмяПараметра, Фильтр.ЗначениеПараметра);
		КонецЦикла; 
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ВидСправочника%", ВидСправочника);
	Запрос.УстановитьПараметр("МассивПереданыхЗначений", МассивПереданыхЗначений);
	СписокВыбираемыхЗначений.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхЗначенийВнешнееСоединение(ТаблицаЗначенийБазыКорреспондента, МассивПереданныхЗначений, ДеревоЗначений)
	Для Каждого Строка Из ДеревоЗначений.Строки Цикл
		Если Строка.Строки.Количество() > 0 Тогда
			ЗаполнитьСписокДоступныхЗначенийВнешнееСоединение(ТаблицаЗначенийБазыКорреспондента, МассивПереданныхЗначений, Строка);
		Иначе
			НоваяСтрока = ТаблицаЗначенийБазыКорреспондента.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			Если МассивПереданныхЗначений.Найти(НоваяСтрока.Идентификатор) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()
	Возврат ПоместитьВоВременноеХранилище(СписокВыбираемыхЗначений.Выгрузить(Новый Структура("Пометка", Истина), "Представление, Идентификатор"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки)
	
	ТаблицаЗаполняемыхЗначений = СписокВыбираемыхЗначений.Выгрузить();
	ТаблицаЗаполняемыхЗначений.ЗаполнитьЗначения(ЗначениеОтметки, "Пометка");
	СписокВыбираемыхЗначений.Загрузить(ТаблицаЗаполняемыхЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПрохождениеФильтраВнешнееСоединение(КоллекцияФильтров)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаЗначений.Представление,
	                      |	ТаблицаЗначений.Пометка,
	                      |	ТаблицаЗначений.Ключ,
	                      |	ТаблицаЗначений.Идентификатор
	                      |ПОМЕСТИТЬ СписокОтфильтрованныхЭлементов
	                      |ИЗ
	                      |	&СписокОтобранныхЗначений КАК ТаблицаЗначений
	                      |ГДЕ");
	
	Запрос.УстановитьПараметр("СписокОтобранныхЗначений", СписокВыбираемыхЗначений.Выгрузить());
	
	Для Каждого Фильтр Из КоллекцияФильтров Цикл
		Если Прав(Запрос.Текст, 3) = "ГДЕ" Тогда
			СоединительУсловий = "";
		Иначе
			СоединительУсловий = "И";
		КонецЕсли;
		Запрос.Текст = ДобавитьТекстУсловия(Запрос.Текст, " ТаблицаЗначений.", СоединительУсловий, Фильтр);
		Запрос.УстановитьПараметр(Фильтр.ИмяПараметра, Фильтр.ЗначениеПараметра);
	КонецЦикла; 
	
	Запрос.Текст = Запрос.Текст + "
	                      |;
	                      |ВЫБРАТЬ
	                      |	СписокОтфильтрованныхЭлементов.Представление,
	                      |	СписокОтфильтрованныхЭлементов.Пометка,
	                      |	СписокОтфильтрованныхЭлементов.Ключ,
	                      |	СписокОтфильтрованныхЭлементов.Идентификатор
	                      |ИЗ
	                      |	СписокОтфильтрованныхЭлементов КАК СписокОтфильтрованныхЭлементов";
	
	СписокВыбираемыхЗначений.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ДобавитьТекстУсловия(ТекстЗапроса, ИмяТаблицы, СоединительУсловий, Фильтр)
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + " " + СоединительУсловий 
		+ ИмяТаблицы
		+ Фильтр.РеквизитОтбора
		+ " " + Фильтр.Условие
		+ ?(Фильтр.Условие = "В", " (","")
		+ " &"
		+ Фильтр.ИмяПараметра
		+ ?(Фильтр.Условие = "В", ") ","");

		
	Возврат ТекстЗапроса;
КонецФункции