////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// Заполнение группы информационных ссылок
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ОбновитьФорму", ВладелецФормы, Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
		
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	УстановитьКурсДокумента();
	
	ОбновитьИнформациюОКурсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьКурсДокумента();
	
	ОбновитьИнформациюОКурсе();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетВалютныйПриИзменении(Элемент)
	
	СчетВалютныйПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетГривневыйПриИзменении(Элемент)
	
	СчетГривневыйПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетВозвратаПриИзменении(Элемент)
	
	СчетВозвратаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВалютнаяПриИзменении(Элемент)
	
	Объект.СуммаГривневая = Объект.СуммаВалютная * Объект.Курс;
	
	Если ЗначениеЗаполнено(Объект.Валюта) Тогда
		Если КратностьДокумента <> 0 И КратностьДокумента <> 1 Тогда
			Объект.СуммаГривневая = Объект.СуммаГривневая / КратностьДокумента;
		КонецЕсли; 
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КурсПриИзменении(Элемент)
	
	Объект.СуммаГривневая = Объект.СуммаВалютная * Объект.Курс;
	
	Если ЗначениеЗаполнено(Объект.Валюта) Тогда
		Если КратностьДокумента <> 0 И КратностьДокумента <> 1 Тогда
			Объект.СуммаГривневая = Объект.СуммаГривневая / КратностьДокумента;
		КонецЕсли; 
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

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
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьКурсДокумента();
	ОбновитьИнформациюОКурсе();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты") Тогда
		Форма.НадписьКурс		 = НСтр("ru='Максимальный курс:';uk='Максимальний курс:'");
		Элементы.Основание.Видимость 		 = Истина;
	Иначе	
		Форма.НадписьКурс		 = НСтр("ru='Минимальный курс:';uk='Мінімальний курс:'");
		Элементы.Основание.Видимость 		 = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОКурсе()

	Если НЕ ЗначениеЗаполнено(Объект.Валюта) Тогда
		ИнфНадписьКурса = "";
		Возврат;
	КонецЕсли;
	
	ИнфНадписьКурса = НСтр("ru='Курс НБУ';uk='Курс НБУ'") + ОбщегоНазначенияБПКлиентСервер.ПолучитьИнформациюКурсаВалютыСтрокой(Объект.Валюта, КурсДокумента, КратностьДокумента, ВалютаРегламентированногоУчета, Истина);

КонецПроцедуры

&НаСервере
Процедура УстановитьКурсДокумента()

	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
	
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры

&НаСервере
Процедура СчетВалютныйПриИзмененииСервер()
	
	Если Объект.СчетВалютный.ВалютаДенежныхСредств <> Объект.Валюта Тогда
		Если ЗначениеЗаполнено(Объект.Валюта) Тогда
			ТекстСообщения = НСтр("ru='Валюта валютного счета организации не соответствует валюте документа';uk='Валюта валютного рахунку організації не відповідає валюті документа'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПродажаВалюты") Тогда
		Если ЗначениеЗаполнено(Объект.СчетВозврата) Тогда
			Объект.СчетВозврата = Объект.СчетВалютный;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СчетГривневыйПриИзмененииСервер()
	
	Если Объект.СчетГривневый.ВалютаДенежныхСредств <> ВалютаРегламентированногоУчета Тогда
		ТекстСообщения = НСтр("ru='Валюта гривневого счета организации не соответствует валюте регламентированного учета';uk='Валюта гривневого рахунку організації не відповідає валюті регламентованого обліку'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
	КонецЕсли;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты") Тогда
		Если ЗначениеЗаполнено(Объект.СчетВозврата) Тогда
			Объект.СчетВозврата = Объект.СчетГривневый;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СчетВозвратаПриИзмененииСервер()
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты") Тогда
		Если Объект.СчетВозврата.ВалютаДенежныхСредств <> ВалютаРегламентированногоУчета Тогда
			ТекстСообщения = НСтр("ru='Валюта счета возврата не соответствует валюте регламентированного учета';uk='Валюта рахунку повернення не відповідає валюті регламентованого обліку'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
		КонецЕсли;	
	Иначе
		Если Объект.СчетВозврата.ВалютаДенежныхСредств <> Объект.Валюта Тогда
			Если ЗначениеЗаполнено(Объект.Валюта) Тогда
				ТекстСообщения = НСтр("ru='Валюта счета возврата не соответствует валюте документа';uk='Валюта рахунку повернення не відповідає валюті документа'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
				Возврат;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры
