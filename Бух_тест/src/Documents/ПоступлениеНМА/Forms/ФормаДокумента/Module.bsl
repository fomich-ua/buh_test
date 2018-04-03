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
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНематериальныхАктивов.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьДобавленныеКолонкиТаблиц();

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если Год(Объект.Дата) <> Год(ТекущаяДатаДокумента) Тогда
		КоэффициентПропорциональногоНДС = Неопределено;
		РассчитатьПропорциональныйНДС(ЭтотОбъект);
	КонецЕсли;
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Дата"                 , Объект.Дата);
	ПараметрыОбъекта.Вставить("ДоговорКонтрагента"   , Объект.ДоговорКонтрагента);
	ПараметрыОбъекта.Вставить("Контрагент"           , Объект.Контрагент);
	ПараметрыОбъекта.Вставить("СчетУчета"            , Объект.СчетУчетаРасчетовПоАвансам);
	ПараметрыОбъекта.Вставить("Организация"          , Объект.Организация);
	ПараметрыОбъекта.Вставить("ОстаткиОбороты"       , "Кт");
	ПараметрыОбъекта.Вставить("ТипыДокументов"       , "Метаданные.Документы.ПоступлениеНМА.Реквизиты.Сделка.Тип");

	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВалютаДоИзменения    = Объект.ВалютаДокумента;
	КурсДоИзменения    	 = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения = Объект.КратностьВзаиморасчетов;
	СтруктураЦеныИВалюта = Неопределено;

	ОбработатьИзмененияПоКнопкеЦеныИВалюты(Новый ОписаниеОповещения("ЦеныИВалютаНажатиеЗавершение", ЭтотОбъект, Новый Структура("ВалютаДоИзменения, КратностьДоИзменения, КурсДоИзменения", ВалютаДоИзменения, КратностьДоИзменения, КурсДоИзменения)), ВалютаДоИзменения);

КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВалютаДоИзменения = ДополнительныеПараметры.ВалютаДоИзменения;
    КратностьДоИзменения = ДополнительныеПараметры.КратностьДоИзменения;
    КурсДоИзменения = ДополнительныеПараметры.КурсДоИзменения;
    
    
    СтруктураЦеныИВалюта = Результат;
    
    Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда
        Объект.ВалютаДокумента         = СтруктураЦеныИВалюта.ВалютаДокумента;
        Объект.КурсВзаиморасчетов      = СтруктураЦеныИВалюта.Курс;
        Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.Кратность;
        Объект.СуммаВключаетНДС        = СтруктураЦеныИВалюта.СуммаВключаетНДС;
        
        Модифицированность = Истина;
        
        ПересчитатьНДС = СтруктураЦеныИВалюта.СуммаВключаетНДС <> СтруктураЦеныИВалюта.ПредСуммаВключаетНДС;
        Если СтруктураЦеныИВалюта.ПересчитатьЦены ИЛИ ПересчитатьНДС Тогда
            ЗаполнитьРассчитатьСуммы(
            ВалютаДоИзменения, 
            КурсДоИзменения,
            КратностьДоИзменения,
            СтруктураЦеныИВалюта.ПересчитатьЦены, 
            ПересчитатьНДС);
        КонецЕсли;
        
        СформироватьНадписьЦеныИВалюта(ЭтаФорма);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НематериальныеАктивы

&НаКлиенте
Процедура НематериальныеАктивыПриИзменении(Элемент)
	
	ОбновитьИтоги(ЭтаФорма);
	РассчитатьПропорциональныйНДС(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И ОтменаРедактирования Тогда
		ОбновитьИтоги(ЭтаФорма);
		РассчитатьПропорциональныйНДС(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыНематериальныйАктивПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НематериальныеАктивы.ТекущиеДанные;
	ДанныеСтроки = Новый Структура("НематериальныйАктив, СчетУчетаБУ, НалоговоеНазначение");
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);

	НематериальныйАктивПриИзмененииНаСервере(ДанныеСтроки);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);

КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыСуммаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.НематериальныеАктивы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Объект.СуммаВключаетНДС);
	ТекущиеДанные.Всего = ТекущиеДанные.Сумма + ?(Объект.СуммаВключаетНДС, 0, ТекущиеДанные.СуммаНДС);

КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыСтавкаНДСПриИзменении(Элемент)

	ТекущиеДанные = Элементы.НематериальныеАктивы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Объект.СуммаВключаетНДС);
	ТекущиеДанные.Всего = ТекущиеДанные.Сумма + ?(Объект.СуммаВключаетНДС, 0, ТекущиеДанные.СуммаНДС);

КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыСуммаНДСПриИзменении(Элемент)

	ТекущиеДанные = Элементы.НематериальныеАктивы.ТекущиеДанные;
	ТекущиеДанные.Всего = ТекущиеДанные.Сумма + ?(Объект.СуммаВключаетНДС, 0, ТекущиеДанные.СуммаНДС);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Подбор(Команда)

	СтруктураПараметров = Новый Структура;
	Если Объект.НМА.Количество() > 0 Тогда
		СтруктураПараметров.Вставить("АдресВХранилище", ПоместитьНМАВХранилище());
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборНематериальныхАктивов.Форма.Форма", СтруктураПараметров, ЭтаФорма);

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

	УстановитьФункциональныеОпцииФормы();

	ТекущаяДатаДокумента = Объект.Дата;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДоговорУказан = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	
	ВедениеВзаиморасчетовПоРасчетнымДокументам = ДоговорУказан И Объект.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам;
	
	ПоказыватьВДокументахСчетаУчета = Истина;

	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьЗаголовкиКолонок();
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьВидимостьНУ();
	
	УстановитьВидимостьАвансДо01042011();

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ПлательщикНалогаНаПрибыль 	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНДС				= УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	КоэффициентПропорциональногоНДС = НалоговыйУчет.ПолучитьКоэффициентПропорциональногоНДС(Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	// Доступность взаимосвязанных полей
	Элементы.ДоговорКонтрагента.Доступность = ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент);
	
	Элементы.Сделка.Доступность = Форма.ВедениеВзаиморасчетовПоРасчетнымДокументам;
	
	ОбновитьИтоги(Форма);
	СформироватьНадписьЦеныИВалюта(Форма);

КонецПроцедуры

// Облуживание типа цен - валюты - НДС:

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты(Знач Оповещение, Знач ВалютаДоИзменения, ПересчитатьЦены = Ложь, КурсВзаиморасчетов = Неопределено, КратностьВзаиморасчетов = Неопределено)

	// Формирование структуры параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента"     , Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс"                , ?(КурсВзаиморасчетов = Неопределено, Объект.КурсВзаиморасчетов, КурсВзаиморасчетов));
	СтруктураПараметров.Вставить("Кратность"           , ?(КратностьВзаиморасчетов = Неопределено, Объект.КратностьВзаиморасчетов, КратностьВзаиморасчетов));
	СтруктураПараметров.Вставить("Контрагент"          , Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор"             , Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация"         , Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента"       , Объект.Дата);
	СтруктураПараметров.Вставить("ПересчитатьЦены"     , ПересчитатьЦены);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения", Ложь);
	СтруктураПараметров.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);

	СтруктураЦеныИВалюта = Неопределено;
	
	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,, Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    СтруктураЦеныИВалюта = Результат;
    
    ВыполнитьОбработкуОповещения(Оповещение, СтруктураЦеныИВалюта);
    Возврат;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммы(Знач ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьЦены = Ложь, ПересчитатьНДС = Ложь)

	Если ПересчитатьЦены Тогда
		Если КурсДоИзменения <> 0 И КратностьДоИзменения <> 0 Тогда
			СтруктураКурса = Новый Структура("Курс, Кратность", КурсДоИзменения, КратностьДоИзменения);
		Иначе
			СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДоИзменения, Объект.Дата);
		КонецЕсли;
	КонецЕсли;

	Для каждого СтрокаТаблицы Из Объект.НМА Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы, ВалютаДоИзменения,
			СтруктураКурса, ПересчитатьЦены, ПересчитатьНДС, Истина);
	КонецЦикла;

	ОбновитьИтоги(ЭтаФорма);

	Если ПересчитатьНДС Тогда
		УстановитьЗаголовкиКолонок();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы, ВалютаПередИзменением, СтруктураКурса, ПересчитатьСумму, ПересчитатьНДС, ЕстьНДС)

	Если ПересчитатьСумму Тогда
		СтрокаТаблицы.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
			СтрокаТаблицы.Сумма, 
			ВалютаПередИзменением, Объект.ВалютаДокумента, 
			СтруктураКурса.Курс, Объект.КурсВзаиморасчетов, 
			СтруктураКурса.Кратность, Объект.КратностьВзаиморасчетов);
	КонецЕсли;

	СуммаВключаетНДС = ?(ПересчитатьНДС, НЕ Объект.СуммаВключаетНДС, Объект.СуммаВключаетНДС);

	Если ЕстьНДС Тогда
		СтрокаТаблицы.Сумма = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
			СтрокаТаблицы.Сумма, СуммаВключаетНДС, Объект.СуммаВключаетНДС, 
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));

		СтрокаТаблицы.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
			СтрокаТаблицы.Сумма, Объект.СуммаВключаетНДС, 
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
		СтрокаТаблицы.Всего    = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

// Серверная обработка изменения реквизитов:

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ДатаОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ДатаОбработатьИзменение()

	УстановитьФункциональныеОпцииФормы();
	
	Если (Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОрганизацияОбработатьИзменение();
	
	КоэффициентПропорциональногоНДС = Неопределено;
	РассчитатьПропорциональныйНДС(ЭтотОбъект);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОбработатьИзменение()
	
	УстановитьФункциональныеОпцииФормы();

	Объект.Сделка = Неопределено;
	
	ПодразделениеПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	Если БухгалтерскийУчетПереопределяемый.ПодразделениеПринадлежитОрганизации(ПодразделениеПоУмолчанию, Объект.Организация) Тогда
		Объект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентОбработатьИзменение();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	КонтрагентОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменение()

	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация, 
		БухгалтерскийУчетПереопределяемый.ПолучитьМассивВидовДоговоров(Истина));

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()
	
	ДоговорКонтрагентаОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаОбработатьИзменение()
	
	ВалютаДоИзменения = Объект.ВалютаДокумента;
	КурсДоИзменения   = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения        = Объект.КратностьВзаиморасчетов;
	СуммаВключаетНДСДоИзменения = Объект.СуммаВключаетНДС;

	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.ДоговорКонтрагента, "ВалютаВзаиморасчетов, ВедениеВзаиморасчетов");
		
	ДоговорУказан = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
		
	Объект.ВалютаДокумента         = РеквизитыДоговора.ВалютаВзаиморасчетов;
	СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
	Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
	Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;

	ПересчитатьСуммы = Объект.ВалютаДокумента <> ВалютаДоИзменения
		ИЛИ Объект.КурсВзаиморасчетов <> КурсДоИзменения;
	ПересчитатьНДС = Объект.СуммаВключаетНДС <> СуммаВключаетНДСДоИзменения;
	
	Если ПересчитатьСуммы ИЛИ ПересчитатьНДС Тогда
		ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьСуммы, ПересчитатьНДС);
	ИначеЕсли ПересчитатьНДС Тогда
		УстановитьЗаголовкиКолонок();
	КонецЕсли;
	
	ВедениеВзаиморасчетовПоРасчетнымДокументам = ДоговорУказан И РеквизитыДоговора.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам;
	
	Если Не ВедениеВзаиморасчетовПоРасчетнымДокументам Тогда
		Если ЗначениеЗаполнено(Объект.Сделка) Тогда
			Объект.Сделка = Неопределено;
		КонецЕсли;	
	КонецЕсли;
	
	Документы.ПоступлениеНМА.ЗаполнитьСчетаУчетаРасчетов(Объект);
	
	Если НЕ ВалютаДоИзменения = Объект.ВалютаДокумента Тогда
		РассчитатьПропорциональныйНДС(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НематериальныйАктивПриИзмененииНаСервере(СтрокаТаблицы)

	Документы.ПоступлениеНМА.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(СтрокаТаблицы);
	СтрокаТаблицы.НалоговоеНазначение = СтрокаТаблицы.НематериальныйАктив.НалоговоеНазначение;
	
КонецПроцедуры

// Обслуживание подбора:

&НаСервере
Функция ПоместитьНМАВХранилище()

	ТаблицаНМА = Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаНМА);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	ДобавленныеСтроки = УправлениеНеоборотнымиАктивами.ОбработатьПодборНематериальныхАктивов(Объект.НМА, ВыбранноеЗначение);

	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры

// Внешний вид, содержание надписей и т.п.

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)

	Объект              = Форма.Объект;
	Форма.ИтогиВсего    = Объект.НМА.Итог("Всего");

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиКолонок()
	
	ЗаголовокСумма = ?(Объект.СуммаВключаетНДС, НСтр("ru='Сумма с НДС';uk='Сума з ПДВ'"), НСтр("ru='Сумма без НДС';uk='Сума без ПДВ'"));
	
	Элементы.НематериальныеАктивыСумма.Заголовок = ЗаголовокСумма;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНадписьЦеныИВалюта(Форма)
	
	// Сформируем надпись цены и валюты.
	Объект = Форма.Объект;
	СтруктураНадписи = Новый Структура(
		"ВалютаДокумента, Курс, Кратность, СуммаВключаетНДС, ВалютаРегламентированногоУчета",
		Объект.ВалютаДокумента,
		Объект.КурсВзаиморасчетов,
		Объект.КратностьВзаиморасчетов,
		Объект.СуммаВключаетНДС,
		Форма.ВалютаРегламентированногоУчета);
	Форма.ЦеныИВалюта = ОбщегоНазначенияБПКлиентСервер.СформироватьНадписьЦеныИВалюта(СтруктураНадписи);

КонецПроцедуры 

// Прочий функционал:

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для каждого СтрокаТаблицы Из Объект.НМА Цикл
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
		СтрокаТаблицы.НалоговоеНазначение = СтрокаТаблицы.НематериальныйАктив.НалоговоеНазначение;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНУ()
	
	СложныйНалоговыйУчет = Объект.ДоговорКонтрагента.СложныйНалоговыйУчет;
	Элементы.СчетУчетаНДС.Видимость 				= ПоказыватьВДокументахСчетаУчета И ПлательщикНДС;
	Элементы.СчетУчетаНДСПодтвержденный.Видимость 	= ПоказыватьВДокументахСчетаУчета И ПлательщикНДС;
	
	Элементы.НематериальныеАктивыНалоговоеНазначение.Видимость = ПлательщикНДС;
	
	Элементы.ГруппаСуммаНДС.Видимость 		 = ПлательщикНДС;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьАвансДо01042011()

	Элементы.ЕстьАвансДо01042011.Видимость 				= ПлательщикНалогаНаПрибыль;
	Элементы.СуммаВДВРПоАвансуДо01042011.Видимость 		= ПлательщикНалогаНаПрибыль И Объект.ЕстьАвансДо01042011;
	Элементы.ВалютаРегламентированногоУчета.Видимость 	= ПлательщикНалогаНаПрибыль И Объект.ЕстьАвансДо01042011;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьПропорциональныйНДС(Форма) Экспорт
	
	Объект = Форма.Объект;
	//Если НЕ Форма.ПлательщикНДС Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если Форма.КоэффициентПропорциональногоНДС = Неопределено Тогда
		
		Форма.КоэффициентПропорциональногоНДС = НалоговыйУчет.ПолучитьКоэффициентПропорциональногоНДС(Объект.Организация, Объект.Дата);
	
	КонецЕсли;
	
	МассивИменТабличныхЧастей = Новый Массив();
	МассивИменТабличныхЧастей.Добавить("НМА");
	
	УчетНДСКлиентСервер.РассчитатьПропорциональныйНДС(Объект,МассивИменТабличныхЧастей,Форма.ПлательщикНДС,Форма.КоэффициентПропорциональногоНДС);
	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПропорциональныйНДСНаКлиенте() Экспорт
	                       
	РассчитатьПропорциональныйНДС(ЭтотОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьПропорциональныйНДСНаСервере() Экспорт
	
	РассчитатьПропорциональныйНДС(ЭтотОбъект);		
	
КонецПроцедуры

&НаКлиенте
Процедура ЕстьАвансДо01042011ПриИзменении(Элемент)
	
	УстановитьВидимостьАвансДо01042011();
	
	Если НЕ Объект.ЕстьАвансДо01042011 Тогда
		
		Объект.СуммаВДВРПоАвансуДо01042011 = 0;	
		
	КонецЕсли;
	
КонецПроцедуры
