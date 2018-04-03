////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	//ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта());
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УправлениеФормойСервер();
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

#Область ОбрабоитчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ 

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ЗатратыНоменклатурнаяГруппаПриИзменении(Элемент)
	
	Если Объект.РазделУчета = ПредопределенноеЗначение("Перечисление.РазделыУчетаДляВводаОстатков.НезавершенноеПроизводство") Тогда
		ДанныеТекущейСтроки = Элементы.Затраты.ТекущиеДанные;
		ДанныеТекущейСтроки.НалоговоеНазначение = ОпределитьНалоговоеНазначениеВПроизводстве(ДанныеТекущейСтроки.НоменклатурнаяГруппа);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСчетУчетаПриИзменении(Элемент)
	
	
	Если Объект.РазделУчета = ПредопределенноеЗначение("Перечисление.РазделыУчетаДляВводаОстатков.ТранспортноЗаготовительныеРасходыНаОтдельныхСубсчетах") Тогда
		
		ТекущиеДанные = Элементы.Затраты.ТекущиеДанные;
		ТекущиеДанные.НетСубконтоНоменклатурнаяГруппа = НетСубконтоНоменклатурнаяГруппаСервер(ТекущиеДанные.СчетУчета);
		
		Если ТекущиеДанные.НетСубконтоНоменклатурнаяГруппа И НЕ ТекущиеДанные.НоменклатурнаяГруппа.Пустая() Тогда
			ТекущиеДанные.НоменклатурнаяГруппа = Неопределено;
		КонецЕсли;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСуммаПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.Затраты.ТекущиеДанные;
	ДанныеТекущейСтроки.СуммаНУ = ДанныеТекущейСтроки.Сумма;

КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежима(Команда)

	ПараметрыНастройкиРежима	= Новый Структура;
	ПараметрыНастройкиРежима.Вставить("ВводитьОстаткиЗапасовВРазрезеДатОприходования",	Объект.ВводитьОстаткиЗапасовВРазрезеДатОприходования);
	ПараметрыНастройкиРежима.Вставить("ВводитьОстаткиЗапасовВРазрезеПоставщиков",		Объект.ВводитьОстаткиЗапасовВРазрезеПоставщиков);
	ПараметрыНастройкиРежима.Вставить("ВводитьСуммыУлучшенияВключенныеВБалансовуюСтоимостьОС",	Объект.ВводитьСуммыУлучшенияВключенныеВБалансовуюСтоимостьОС);
	ПараметрыНастройкиРежима.Вставить("Организация", Объект.Организация);
	ПараметрыНастройкиРежима.Вставить("РазделУчета", Объект.РазделУчета);
	ПараметрыНастройкиРежима.Вставить("Дата",		 Объект.Дата);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОткрытьФормуНастройкиРежимаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаНастройкиРежима",
		ПараметрыНастройкиРежима,,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежимаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	РезультатНастройкиРежима = РезультатЗакрытия;
	
	Если ТипЗнч(РезультатНастройкиРежима) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		
		ЗаполнитьЗначенияСвойств(Объект, РезультатНастройкиРежима);
		
		Объект.Дата	= РезультатНастройкиРежима.ДатаВводаОстатков;
		ДатаПриИзмененииСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОписаниеРаздела(Команда)

	ДанныеЗаполнения	= Новый Структура;
	ДанныеЗаполнения.Вставить("Дата",		 Объект.Дата);
	ДанныеЗаполнения.Вставить("Организация", Объект.Организация);
	ДанныеЗаполнения.Вставить("РазделУчета", Объект.РазделУчета);

	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаСправки", Новый Структура("ДанныеЗаполнения", ДанныеЗаполнения), ЭтаФорма, ВариантОткрытияОкна.ОтдельноеОкно);

КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

#Область СлужебныеПроцедурыФункцииБСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать
	
#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыФункции 

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки

	
	//Установить значения реквизитов
	ТекущаяДатаДокумента		   = Объект.Дата;
	ЕстьНДС                        = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, НачалоМесяца(ТекущаяДатаДокумента));	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	Если ТипЗнч(Параметры) = Тип("ДанныеФормыСтруктура") Тогда
		Параметры.Свойство("ОткрытиеИзОбработкиВводаНачальныхОстатков", ОткрытиеИзОбработкиВводаНачальныхОстатков);
	КонецЕсли;

	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УправлениеФормойСервер();
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаСервере
Процедура УправлениеФормойСервер()

	// Установка режима "Только просмотр" для поля "Дата"
	Элементы.Дата.ТолькоПросмотр =
		ЗначениеЗаполнено(Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация));

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

	// Ограничение выбора счета учета:
	МассивСчетов = Новый Массив;
	МассивИсключений = Новый Массив;
	Если Объект.РазделУчета = Перечисления.РазделыУчетаДляВводаОстатков.НезавершенноеПроизводство Тогда
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.Производство); //23
		МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья); //234
		МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.ОбслуживаниеИРемонт); //235
	ИначеЕсли Объект.РазделУчета = Перечисления.РазделыУчетаДляВводаОстатков.ТранспортноЗаготовительныеРасходыНаОтдельныхСубсчетах Тогда
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТранспортноЗаготовительныеРасходыМатериалы);  //200
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ТранспортноЗаготовительныеРасходы);  //280
	Иначе 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неверно указан раздел ("+Объект.РазделУчета+")!");
	КонецЕсли;   

	//Видимость колонок
	Если Объект.РазделУчета = Перечисления.РазделыУчетаДляВводаОстатков.ТранспортноЗаготовительныеРасходыНаОтдельныхСубсчетах Тогда
		
		Элементы.ЗатратыПодразделение.Видимость			= Ложь;
		Элементы.ЗатратыНалоговоеНазначение.Видимость	= ЕстьНДС;
		
	ИначеЕсли Объект.РазделУчета = Перечисления.РазделыУчетаДляВводаОстатков.НезавершенноеПроизводство Тогда
		
		Элементы.ЗатратыПодразделение.Видимость			   = Истина;
		Элементы.ЗатратыНалоговоеНазначение.Видимость	   = ЕстьНДС;
		Элементы.ЗатратыНалоговоеНазначение.ТолькоПросмотр = Истина;
		
	КонецЕсли;	
	
	СчетаДляОтбора = БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(МассивСчетов, Ложь, , , МассивИсключений);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.ЗатратыСчетУчета, СчетаДляОтбора);

	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	УправлениеФормойСервер();

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ДатаВводаОстатков	= Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация);
	
	Если ЗначениеЗаполнено(ДатаВводаОстатков) Тогда
		Объект.Дата	= ДатаВводаОстатков;
	КонецЕсли;

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	УправлениеФормойСервер();

КонецПроцедуры

&НаСервереБезКонтекста
Функция НетСубконтоНоменклатурнаяГруппаСервер(СчетУчета)

		ТекВидыСубконто = СчетУчета.ВидыСубконто;
		НетСубконтоНоменклатурнаяГруппа = (ТекВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы,"ВидСубконто") = Неопределено);
		
		Возврат НетСубконтоНоменклатурнаяГруппа;
		
КонецФункции // НетСубконтоНоменклатурнаяГруппаСервер()

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	ПараметрыДокумента	= Новый Структура("РазделУчета, Организация",
		Объект.РазделУчета, Объект.Организация);

	Для каждого СтрокаТаблицы Из Объект.Затраты Цикл

		ЗаполнитьДобавленныеКолонкиСтрокиТаблицы_Затраты(СтрокаТаблицы, ПараметрыДокумента);

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицы_Затраты(СтрокаТаблицы, ПараметрыДокумента)

	Если ПараметрыДокумента.РазделУчета = Перечисления.РазделыУчетаДляВводаОстатков.ТранспортноЗаготовительныеРасходыНаОтдельныхСубсчетах Тогда
		Если ЗначениеЗаполнено(СтрокаТаблицы.СчетУчета) Тогда
			СтрокаТаблицы.НетСубконтоНоменклатурнаяГруппа = НетСубконтоНоменклатурнаяГруппаСервер(СтрокаТаблицы.СчетУчета);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ОпределитьНалоговоеНазначениеВПроизводстве(НоменклатурнаяГруппа)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатурнаяГруппа,"НалоговоеНазначениеВПроизводстве");

КонецФункции // ОпределитьНалоговоеНазначениеВПроизводстве()

&НаКлиенте
Процедура ЗатратыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.Затраты.ТекущиеДанные;
		Если Не ЕстьНДС Тогда
			ТекущиеДанные.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность");
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры


#КонецОбласти 


