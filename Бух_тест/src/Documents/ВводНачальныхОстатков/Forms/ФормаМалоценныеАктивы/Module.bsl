////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ 

&НаКлиенте
Процедура МалоценныеАктивыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.МалоценныеАктивы.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МалоценныеАктивыСтоимостьПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.МалоценныеАктивы.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СтоимостьНУ = ?(СтрокаТабличнойЧасти.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность"), 0, СтрокаТабличнойЧасти.Стоимость);
КонецПроцедуры

&НаКлиенте
Процедура МалоценныеАктивыНалоговоеНазначениеПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.МалоценныеАктивы.ТекущиеДанные;
	
 	СтрокаТабличнойЧасти.СтоимостьНУ = ?(СтрокаТабличнойЧасти.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность"), 0, СтрокаТабличнойЧасти.СтоимостьНУ);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки

	ТекущаяДатаДокумента = Объект.Дата;

	// Ограничение выбора счета учета:
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.БиблиотечныеФондыКоличественно);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.МалоценныеНеоборотныеМатериальныеАктивыКоличественно);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.МалоценныеАктивыВЭксплуатации);

	СчетаДляОтбора = БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(МассивСчетов);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.МалоценныеАктивыСчетУчета, СчетаДляОтбора);
	
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
	
	ЕстьНДС = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, НачалоМесяца(ТекущаяДатаДокумента));	

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

&НаКлиенте
Процедура МалоценныеАктивыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		СтрокаТабличнойЧасти = Элементы.МалоценныеАктивы.ТекущиеДанные;		
		СтрокаТабличнойЧасти.ДатаПриобретения = Объект.Дата;
		Если Не ЕстьНДС Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность");
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

