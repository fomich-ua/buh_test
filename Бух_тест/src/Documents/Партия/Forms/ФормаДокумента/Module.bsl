////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		УстановитьДоговорКонтрагента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	УстановитьДоговорКонтрагента();

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры  

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоговорКонтрагента()

	ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	УстановитьДоговорКонтрагентаНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьДоговорКонтрагентаНаСервере(ДанныеОбъекта)

	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(ДанныеОбъекта.ДоговорКонтрагента, ДанныеОбъекта.Контрагент, ДанныеОбъекта.Организация);
	
	ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДоговорКонтрагентаПриИзмененииНаСервере(ДанныеОбъекта)

	Если ЗначениеЗаполнено(ДанныеОбъекта.ДоговорКонтрагента) Тогда
		СвойстваДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОбъекта.ДоговорКонтрагента, "ВалютаВзаиморасчетов");
		ДанныеОбъекта.ВалютаДокумента = СвойстваДоговора.ВалютаВзаиморасчетов;
	Иначе
		ДанныеОбъекта.ВалютаДокумента       = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
