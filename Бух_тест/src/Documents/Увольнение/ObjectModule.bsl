#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	КадровыйУчет.СформироватьКадровыеДвижения(ЭтотОбъект, Движения, ДанныеДляПроведения.КадровыеДвижения);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	СтруктураПлановыхУдержаний = Новый Структура;
	СтруктураПлановыхУдержаний.Вставить("ДанныеОПлановыхУдержаниях", ДанныеДляПроведения.ПлановыеУдержания);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхУдержаний(ЭтотОбъект, Движения, СтруктураПлановыхУдержаний);
	
	СтруктураЕСВСотрудников = Новый Структура;
	СтруктураЕСВСотрудников.Вставить("ДанныеОЕСВСотрудников", ДанныеДляПроведения.ЕСВСотрудников);
	
	РасчетЗарплаты.СформироватьДвиженияЕСВСотрудников(ЭтотОбъект, Движения, СтруктураЕСВСотрудников);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(
		ЭтотОбъект.ДатаУвольнения,
		ЭтотОбъект.Сотрудник,
		ЭтотОбъект.Ссылка,
		Отказ,
		Перечисления.ВидыКадровыхСобытий.Увольнение);
		
	Если НЕ ДокументЗаполненПравильно() Тогда
		Отказ = Истина;
	КонецЕсли; 

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УсловияОтбора = Новый Массив;
	УсловияОтбора.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение", "Регистратор", "<>", Ссылка));
	
	ПоляОтбораПериодическихДанных = Новый Структура;
	ПоляОтбораПериодическихДанных.Вставить("КадроваяИсторияСотрудников", УсловияОтбора);
	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		Ложь,
		ЭтотОбъект.Сотрудник,
		"ГоловнаяОрганизация,Организация,Подразделение,Должность,ВидЗанятости,ФизическоеЛицо",
		ЭтотОбъект.ДатаУвольнения,
		ПоляОтбораПериодическихДанных);
		
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("ДатаСобытия", ЭтотОбъект.ДатаУвольнения);
	Запрос.УстановитьПараметр("Сотрудник", ЭтотОбъект.Сотрудник);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КадровыеДанныеСотрудников.Период КАК ДатаСобытия,
	|	КадровыеДанныеСотрудников.Сотрудник,
	|	КадровыеДанныеСотрудников.ГоловнаяОрганизация,
	|	КадровыеДанныеСотрудников.Организация,
	|	КадровыеДанныеСотрудников.Подразделение,
	|	КадровыеДанныеСотрудников.Должность,
	|	КадровыеДанныеСотрудников.ВидЗанятости,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение) КАК ВидСобытия,
	|	КадровыеДанныеСотрудников.ФизическоеЛицо
	|ИЗ
	|	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДатаСобытия КАК ДатаСобытия,
	|	ПлановыеНачисленияСрезПоследних.Сотрудник,
	|	ПлановыеНачисленияСрезПоследних.Начисление,
	|	0 КАК Размер,
	|	ПлановыеНачисленияСрезПоследних.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ПлановыеНачисления.СрезПоследних(
	|			&ДатаСобытия,
	|			Сотрудник = &Сотрудник
	|				И Регистратор <> &Регистратор) КАК ПлановыеНачисленияСрезПоследних
	|ГДЕ
	|	ПлановыеНачисленияСрезПоследних.Размер <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДатаСобытия КАК ДатаСобытия,
	|	ПлановыеУдержанияСрезПоследних.Сотрудник,
	|	ПлановыеУдержанияСрезПоследних.Удержание,
	|	0 КАК Размер,
	|	ПлановыеУдержанияСрезПоследних.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ПлановыеУдержания.СрезПоследних(
	|			&ДатаСобытия,
	|			Сотрудник = &Сотрудник
	|				И Регистратор <> &Регистратор) КАК ПлановыеУдержанияСрезПоследних
	|ГДЕ
	|	ПлановыеУдержанияСрезПоследних.Размер <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДатаСобытия КАК ДатаСобытия,
	|	ЕСВСотрудниковСрезПоследних.Сотрудник,
	|	ЗНАЧЕНИЕ(Справочник.КатегорииЗастрахованныхЛицЕСВ.ПустаяСсылка) КАК КатегорияЕСВ,
	|	ЕСВСотрудниковСрезПоследних.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ЕСВСотрудников.СрезПоследних(
	|			&ДатаСобытия,
	|			Сотрудник = &Сотрудник
	|				И Регистратор <> &Регистратор) КАК ЕСВСотрудниковСрезПоследних
	|ГДЕ
	|	ЕСВСотрудниковСрезПоследних.КатегорияЕСВ <> ЗНАЧЕНИЕ(Справочник.КатегорииЗастрахованныхЛицЕСВ.ПустаяСсылка)";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура; 
	
	// Первый набор данных для проведения - таблица для формирования кадровых движений, истрии графиков, авансов
	ДанныеДляПроведения.Вставить("КадровыеДвижения", РезультатыЗапроса[0].Выгрузить());
	
	// Второй набор данных для проведения - таблица для формирования плановых начислений
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", РезультатыЗапроса[1].Выгрузить());
	
	// Третий набор данных для проведения - таблица для формирования плановых удержаний
	ДанныеДляПроведения.Вставить("ПлановыеУдержания", РезультатыЗапроса[2].Выгрузить());
	
	// Четвертый набор данных для проведения - таблица для формирования ЕСВ
	ДанныеДляПроведения.Вставить("ЕСВСотрудников", РезультатыЗапроса[3].Выгрузить());
	
	Возврат ДанныеДляПроведения;

КонецФункции

Функция ДокументЗаполненПравильно(ТихийРежим = Ложь) Экспорт
	
	ТекстСообщения = "";
	СтруктураСообщений  = Новый Соответствие;
	ДокументЗаполненПравильно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru='Поле ""Организация"" обязательно к заполнению.';uk='Поле ""Організація"" обов''язкове до заповнення.'");
		СтруктураСообщений.Вставить("Организация",ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru='Поле ""Сотрудник"" обязательно к заполнению.';uk='Поле ""Співробітник"" обов''язкове до заповнення.'");
		СтруктураСообщений.Вставить("Сотрудник",ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаУвольнения) Тогда
		ТекстСообщения = НСтр("ru='Поле ""Дата увольнения"" обязательно к заполнению.';uk='Поле ""Дата звільнення"" обов''язкове до заповнення.'");
		СтруктураСообщений.Вставить("ДатаУвольнения",ТекстСообщения);
	КонецЕсли;
	
	ДокументЗаполненПравильно = СтруктураСообщений.Количество() = 0;
	
	Если НЕ ТихийРежим И НЕ ДокументЗаполненПравильно Тогда
		Для каждого Сообщение Из СтруктураСообщений Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение.Значение,,"Объект" + ?(Сообщение.Ключ = "","",".") + Сообщение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДокументЗаполненПравильно;	
	
КонецФункции

#КонецЕсли
