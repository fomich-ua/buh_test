////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Свойство("Документ")) Тогда
		Объект.Документ = Параметры.Документ;	
	КонецЕсли;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МетаданныеОбработка = ОбработкаОбъект.Метаданные();	
	Для Каждого МетаданныеРеквизит Из МетаданныеОбработка.Реквизиты Цикл
		РеквизитыОбработки.Добавить(МетаданныеРеквизит.Имя);
	КонецЦикла;
	
	УстановитьНомер();
	УстановитьТипЦен();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	
	УстановитьНомер();
	УстановитьТипЦен();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Печать(Команда)
	
	Если Не ЭтаФорма.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(Объект.Документ);
	
	ПараметрыПечати = УправлениеПечатьюБПКлиент.ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды);
	Для каждого Реквизит Из РеквизитыОбработки Цикл
		ИмяРеквизита = Реквизит.Значение;
		ПараметрыПечати.Вставить(ИмяРеквизита, Объект[ИмяРеквизита]);
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьТТН",
		"ТТН",
		ПараметрКоманды,
		ЭтаФорма,
		ПараметрыПечати
	);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

&НаСервере
Процедура УстановитьНомер()
	
	Объект.НомерТТН = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Объект.Документ.Номер);
	Если ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.РеализацияТоваровУслуг") И Объект.НомерТТН <> "" Тогда
		
		Объект.НомерТТН = "Р" + Объект.НомерТТН;
		
	ИначеЕсли ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.ПеремещениеТоваров") И Объект.НомерТТН <> "" Тогда
		
		Объект.НомерТТН = "П" + Объект.НомерТТН;
		
	Иначе
		
		Объект.НомерТТН = "";
	
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает тип цен.
//
&НаСервере
Процедура УстановитьТипЦен()

	Если ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда

	Иначе
		ТипЦен = Неопределено;
	КонецЕсли;

КонецПроцедуры // УстановитьТипЦен()

// Процедура устанавливает видимость и доступность реквизитов.
//
&НаСервере
Процедура УстановитьВидимостьДоступность()

	Если ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		ДоступностьТипаЦен = Истина;
	Иначе
		ДоступностьТипаЦен = Ложь;
	КонецЕсли;

	Элементы.ТипЦен.Доступность = ДоступностьТипаЦен;

КонецПроцедуры // УстановитьВидимостьДоступность()
