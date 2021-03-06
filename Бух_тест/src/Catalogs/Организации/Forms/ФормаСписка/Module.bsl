////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаКоманднаяПанель);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	ОсновнаяОрганизация	= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ОсновнаяОрганизация", ОсновнаяОрганизация);
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеЮридическогоЛица", НСтр("ru='Юридическое лицо';uk='Юридична особа'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеИндивидуальногоПредпринимателя", НСтр("ru='Физ. лицо - предприниматель';uk='Фіз. особа - підприємець'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеОбособленногоПодразделения", НСтр("ru='Обособленное подразделение';uk='Відокремлений підрозділ'"));
		
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтаФорма Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		ОсновнаяОрганизация	= Параметр;
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнаяОрганизация", ОсновнаяОрганизация);
		
		УправлениеФормойКлиент();
		
	ИначеЕсли ИмяСобытия = "ИзменениеОсновногоПодразделенияОрганизации" Тогда
		
		ОсновноеПодразделение	= Параметр;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <Список>

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеФормойКлиент();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.Ссылка = ОсновнаяОрганизация Тогда
		ОсновнаяОрганизация	= Неопределено;
	Иначе
		ОсновнаяОрганизация	= Элементы.Список.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(ОсновнаяОрганизация);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УправлениеФормойКлиент()
 
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаИспользоватьОсновным.Пометка	= 
	    Элементы.Список.ТекущиеДанные.Свойство("Ссылка")
		И Элементы.Список.ТекущиеДанные.Ссылка = ОсновнаяОрганизация;
		
	Элементы.ФормаИспользоватьОсновным.Доступность	= 
	    Элементы.Список.ТекущиеДанные.Свойство("Ссылка");

КонецПроцедуры


&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать
