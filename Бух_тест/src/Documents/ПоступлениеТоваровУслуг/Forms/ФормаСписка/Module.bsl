////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаКоманднаяПанель);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);

	// Уведомим о появлении нового функционала.
	НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("БыстроеОсвоениеПоступлениеТоваровУслуг");

	// Заполнение группы информационных ссылок
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПоказатьБыстроеОсвоение", 0.5, Истина); 
	
КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <Список>

#Область ОбработчикиСобытийТаблицыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

#КонецОбласти  

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВидОперации(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", СтрокаТаблицы.Ссылка);
	ПараметрыФормы.Вставить("ИзменитьВидОперации", Истина);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПокупкаКомиссия(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВПереработку(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОбъектыСтроительства(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ОбъектыСтроительства"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБланкиСтрогогоУчета(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.БланкиСтрогогоУчета"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОборудование(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Оборудование"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры


#КонецОбласти  

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ПоказатьБыстроеОсвоение()
	
	ОбщегоНазначенияБПКлиент.ПоказатьПредупреждениеОбИзменениях("БыстроеОсвоениеПоступлениеТоваровУслуг", , НастройкиПредупреждений);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ЗагрузкаВходящихНалоговыхДокументовИЗЗвит1С(Команда)
	
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуЗагрузкиВходящихПервичныхДокументов("Накладна");	
	
КонецПроцедуры
