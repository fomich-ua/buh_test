
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОтборСтрокНоменклатуры = Новый Структура;
	Для каждого ЭлементСтруктуры Из Параметры.ОтборСтрокНоменклатуры Цикл
		мОтборСтрокНоменклатуры.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);	
	КонецЦикла;
	
	Контрагент 			= Параметры.Контрагент;
	ДоговорКонтрагента 	= Параметры.ДоговорКонтрагента;
	Сделка 				= Параметры.Сделка;
	ВалютаДокумента 	= Параметры.ВалютаДокумента;
	Дата	 			= Параметры.Дата;
	
	СуммаВключаетНДС 	= Параметры.СуммаВключаетНДС;
	
	ТипЦен = Параметры.ДоговорКонтрагента.ТипЦен;
	
	мВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Элементы.ДекорацияИнфНадписьРеквизитыДокумента.Заголовок = 
			НСтр("ru='Контрагент: ';uk='Контрагент: '") + СокрЛП(Контрагент)
			+НСтр("ru=', "
"Договор: ';uk=', "
"Договір: '") 	+ СокрЛП(ДоговорКонтрагента) 	
			+НСтр("ru=', "
"Документ расчетов: ';uk=', "
"Документ розрахунків: '") 	+ СокрЛП(Сделка)
			+".";
			
	Элементы.ДекорацияИнфНадписьДокумент.Заголовок = Параметры.Документ;
	
	Элементы.Комментарий.Заголовок 		  = Параметры.Комментарий;
			
	ВременнаяСтрока = "";
	Если (ЗначениеЗаполнено(ВалютаДокумента))
	   И (ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда

	    Данные = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		ВременнаяСтрока = ВременнаяСтрока + Данные.Кратность
						+ " " +  ВалютаДокумента
		                + " = " + Данные.Курс
		                + мВалютаРегламентированногоУчета + ", ";

	КонецЕсли;

	Элементы.ДекорацияИнфНадписьТоварыИтоги.Заголовок = ВременнаяСтрока;

	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Элементы.ИтогиВсего.Заголовок = НСтр("ru='Всего (<>):';uk='Всього (<>):'");
	Иначе
		Элементы.ИтогиВсего.Заголовок = НСтр("ru='Всего (';uk='Всього ('") + СокрЛП(ВалютаДокумента) +"):";
	КонецЕсли;

	Если СуммаВключаетНДС Тогда
		Элементы.ИтогиНДС.Заголовок = НСтр("ru='НДС (в т.ч.):';uk='ПДВ (у т.ч.):'");
	Иначе
		Элементы.ИтогиНДС.Заголовок = НСтр("ru='НДС (сверху):';uk='ПДВ (зверху):'");
	КонецЕсли;
	
	
	///////////////////////////////////////////////////////
	//управление колонками скидок
	
	ПоказыватьСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьСкидки");
	
	Элементы.ТоварыСуммаСкидки.Видимость    = ПоказыватьСкидки;
	Элементы.ТоварыСуммаБезСкидки.Видимость = ПоказыватьСкидки;
	
	Элементы.УслугиСуммаСкидки.Видимость    = ПоказыватьСкидки;
	Элементы.УслугиСуммаБезСкидки.Видимость = ПоказыватьСкидки;

	УстановитьОтборФормыНоменклатурногоСостава("Товары");
	УстановитьОтборФормыНоменклатурногоСостава("ВозвратнаяТара");
	УстановитьОтборФормыНоменклатурногоСостава("Услуги");
	УстановитьОтборФормыНоменклатурногоСостава("ОС");
	УстановитьОтборФормыНоменклатурногоСостава("НМА");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	КопироватьДанныеФормы(ВладелецФормы.Объект, Объект);
	Объект.СуммаВключаетНДС = СуммаВключаетНДС;
	
	//////
	СуммаНДС = 0;
	Сумма = 0;
	СуммаТара = 0;
	НайденныеСтроки = Объект.Товары.НайтиСтроки(мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДС;
		Сумма = 	Сумма 	+ Строка.Сумма;
	КонецЦикла; 
	КоличествоСтрокТовары =  НайденныеСтроки.Количество();
	
	НайденныеСтроки = Объект.ВозвратнаяТара.НайтиСтроки(мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаТара = СуммаТара + Строка.Сумма;
	КонецЦикла; 
	КоличествоСтрокВозвратнаяТара = НайденныеСтроки.Количество();
	
	НайденныеСтроки = Объект.Услуги.НайтиСтроки(мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДС;
		Сумма = 	Сумма 	+ Строка.Сумма;
	КонецЦикла; 
	КоличествоСтрокУслуги = НайденныеСтроки.Количество();
	
	НайденныеСтроки = Объект.ОС.НайтиСтроки(мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДС;
		Сумма = 	Сумма 	+ Строка.Сумма;
	КонецЦикла; 
	КоличествоСтрокОС = НайденныеСтроки.Количество();
	
	НайденныеСтроки = Объект.НМА.НайтиСтроки(мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДС;
		Сумма = 	Сумма 	+ Строка.Сумма;
	КонецЦикла; 
	КоличествоСтрокНМА = НайденныеСтроки.Количество();

	ИтогиВсего   = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма + ?(СуммаВключаетНДС, 0, СуммаНДС));
	ИтогиНДС	 = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС);
    ИтогиТара	 = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаТара);	
	//////
	
	// установим видимость колонок счетов учета НДС...
	Элементы.ТоварыСчетУчетаНДС.Видимость 				= ЕстьЗаполненныйСчетУчетаНДСВТабличнойЧасти(Объект.Товары);
	Элементы.УслугиСчетУчетаНДС.Видимость 				= ЕстьЗаполненныйСчетУчетаНДСВТабличнойЧасти(Объект.Услуги);
	Элементы.ОССчетУчетаНДС.Видимость 					= ЕстьЗаполненныйСчетУчетаНДСВТабличнойЧасти(Объект.ОС);
	Элементы.НМАСчетУчетаНДС.Видимость	 				= ЕстьЗаполненныйСчетУчетаНДСВТабличнойЧасти(Объект.НМА);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	КопироватьДанныеФормы(Объект, ВладелецФормы.Объект);
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыКодУКТВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораНоменклатурыГТД(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНомерГТДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораНоменклатурыГТД(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНомерГТДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.НоменклатураГТД") Тогда
	
		ТекущаяСтрокаТоваров = Элементы.Товары.ТекущиеДанные;
		Если НЕ ТекущаяСтрокаТоваров = Неопределено Тогда
			ТекущаяСтрокаТоваров.КодУКТВЭД = ПолучитьРеквизитНоменклатурыГТДНаСервере(ВыбранноеЗначение, "КодУКТВЭД");
		КонецЕсли;

		ВыбранноеЗначение = ПолучитьРеквизитНоменклатурыГТДНаСервере(ВыбранноеЗначение, "НомерГТД");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКодУКТВЭДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.НоменклатураГТД") Тогда
	
		ТекущаяСтрокаТоваров = Элементы.Товары.ТекущиеДанные;
		Если НЕ ТекущаяСтрокаТоваров = Неопределено Тогда
			ТекущаяСтрокаТоваров.НомерГТД = ПолучитьРеквизитНоменклатурыГТДНаСервере(ВыбранноеЗначение, "НомерГТД");
		КонецЕсли;

		ВыбранноеЗначение = ПолучитьРеквизитНоменклатурыГТДНаСервере(ВыбранноеЗначение, "КодУКТВЭД");	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитНоменклатурыГТДНаСервере(Ссылка, ИмяРекзвизита)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРекзвизита);	

КонецФункции 

&НаКлиенте
Процедура НачалоВыбораНоменклатурыГТД(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрокаТоваров = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрокаТоваров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыВыбора = Новый СписокЗначений();
	ВариантыВыбора.Добавить(Ложь,   НСтр("ru='Выбрать по данным номенклатуры';uk='Вибрати по даним номенклатури'"));
	ВариантыВыбора.Добавить(Истина, НСтр("ru='Произвольный выбор';uk='Довільний вибір'"));
	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("НачалоВыбораНоменклатурыГТДЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), ВариантыВыбора, Элемент, 0);

КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораНоменклатурыГТДЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Элемент = ДополнительныеПараметры.Элемент;
	
	РезультатВыбора = ВыбранныйЭлемент;
    
    Если РезультатВыбора = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
	ТекущаяСтрокаТоваров = Элементы.Товары.ТекущиеДанные;
	
	Если РезультатВыбора.Значение = Истина Тогда
		ПараметрыВыбора = Новый Структура("ТекущаяСтрока");
		Если ТекущаяСтрокаТоваров <> Неопределено И ЗначениеЗаполнено(ТекущаяСтрокаТоваров.КодУКТВЭД) Тогда
			ПараметрыВыбора.Вставить("ТекущаяСтрока", ТекущаяСтрокаТоваров.КодУКТВЭД);	
		КонецЕсли;  
		ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ФормаВыбора", ПараметрыВыбора, Элемент);
	Иначе
	    ДанныеСтроки = Новый Структура("КодУКТВЭД, НомерГТД, Номенклатура");
	    ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущаяСтрокаТоваров); 
	    ПараметрыВыбора = ЗаполнитьПараметрыВыбораНоменклатурыГТД(ДанныеСтроки);
		
		ОткрытьФорму("Справочник.НоменклатураГТД.Форма.ФормаВыбора", ПараметрыВыбора, Элемент);
	КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораНоменклатурыГТДУслуги(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрокаУслуг = Элементы.Услуги.ТекущиеДанные;
	Если ТекущаяСтрокаУслуг = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыВыбора = Новый СписокЗначений();
	ВариантыВыбора.Добавить(Ложь,   НСтр("ru='Выбрать по данным номенклатуры';uk='Вибрати по даним номенклатури'"));
	ВариантыВыбора.Добавить(Истина, НСтр("ru='Произвольный выбор';uk='Довільний вибір'"));
	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("НачалоВыбораНоменклатурыГТДУслугиЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), ВариантыВыбора, Элемент, 0);

КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораНоменклатурыГТДУслугиЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Элемент = ДополнительныеПараметры.Элемент;
	
	РезультатВыбора = ВыбранныйЭлемент;
    
    Если РезультатВыбора = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    ТекущаяСтрокаУслуг = Элементы.Услуги.ТекущиеДанные;
	
    Если РезультатВыбора.Значение = Истина Тогда
		ПараметрыВыбора = Новый Структура("ТекущаяСтрока");
		Если ТекущаяСтрокаУслуг <> Неопределено И ЗначениеЗаполнено(ТекущаяСтрокаУслуг.КодУКТВЭД) Тогда
			ПараметрыВыбора.Вставить("ТекущаяСтрока", ТекущаяСтрокаУслуг.КодУКТВЭД);	
		КонецЕсли;
		ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ФормаВыбора", ПараметрыВыбора, Элемент);
	Иначе
	    ДанныеСтроки = Новый Структура("КодУКТВЭД, Номенклатура");
	    ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущаяСтрокаУслуг); 
	    ПараметрыВыбора = ЗаполнитьПараметрыВыбораНоменклатурыГТДУслуги(ДанныеСтроки);
		
		ОткрытьФорму("Справочник.НоменклатураГТД.Форма.ФормаВыбора", ПараметрыВыбора, Элемент);
	КонецЕсли;
    
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьПараметрыВыбораНоменклатурыГТД(ТекущаяСтрокаТоваров)
	
	Параметры = Новый Структура("Отбор, ТекущаяСтрока");
	
	Параметры.Отбор = Новый Структура("Владелец", ТекущаяСтрокаТоваров.Номенклатура); 
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("КодУКТВЭД", ТекущаяСтрокаТоваров.КодУКТВЭД);
	Запрос.УстановитьПараметр("НомерГТД",  ТекущаяСтрокаТоваров.НомерГТД);
	Запрос.УстановитьПараметр("Владелец",  ТекущаяСтрокаТоваров.Номенклатура);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	НоменклатураГТД.Ссылка
	               |ИЗ
	               |	Справочник.НоменклатураГТД КАК НоменклатураГТД
	               |ГДЕ
	               |	НоменклатураГТД.КодУКТВЭД  = &КодУКТВЭД
	               |	И НоменклатураГТД.НомерГТД = &НомерГТД
	               |	И НоменклатураГТД.Владелец = &Владелец";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Параметры.ТекущаяСтрока = Выборка.Ссылка;	
	КонецЕсли;
	
	Возврат Параметры; 
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьПараметрыВыбораНоменклатурыГТДУслуги(ТекущаяСтрокаТоваров)
	
	Параметры = Новый Структура("Отбор, ТекущаяСтрока");
	
	Параметры.Отбор = Новый Структура("Владелец", ТекущаяСтрокаТоваров.Номенклатура); 
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("КодУКТВЭД", ТекущаяСтрокаТоваров.КодУКТВЭД);
	Запрос.УстановитьПараметр("Владелец",  ТекущаяСтрокаТоваров.Номенклатура);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	НоменклатураГТД.Ссылка
	               |ИЗ
	               |	Справочник.НоменклатураГТД КАК НоменклатураГТД
	               |ГДЕ
	               |	НоменклатураГТД.КодУКТВЭД  = &КодУКТВЭД
	               |	И НоменклатураГТД.Владелец = &Владелец";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Параметры.ТекущаяСтрока = Выборка.Ссылка;	
	КонецЕсли;
	
	Возврат Параметры; 
	
КонецФункции

&НаКлиенте
Процедура ТабличнаяЧастьПриИзменении(Элемент)
	
	ТекущиеДанные 				 = Элемент.ТекущиеДанные;
	Если Элемент.Имя <> "ВозвратнаяТара" Тогда
		ТекущиеДанные.ВсегоВДокумент = ТекущиеДанные.СуммаВДокумент + ?(СуммаВключаетНДС, 0, ТекущиеДанные.СуммаНДСВДокумент);
	КонецЕсли;
	
	ТекущиеДанные.Флаг  = ?(ТекущиеДанные.КоличествоВДокумент = 0, 0, ?(ТекущиеДанные.КоличествоВДокумент = ТекущиеДанные.Количество, 1, 2));
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьФлагПриИзменении(Элемент)
	
	ИмяТаблицы = СтрЗаменить(Элемент.Имя, "Флаг", "");
	
	ДанныеСтроки = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеСтроки.КоличествоВДокумент = 0 Тогда
		
		ДанныеСтроки.КоличествоВДокумент 	= ДанныеСтроки.Количество;
		ДанныеСтроки.СуммаВДокумент 		= ДанныеСтроки.Сумма;
		
		Если ИмяТаблицы <> "ВозвратнаяТара"Тогда
			ДанныеСтроки.СуммаНДСВДокумент 		= ДанныеСтроки.СуммаНДС;
		КонецЕсли;
		
		Если  ИмяТаблицы <> "ОС" 
			И ИмяТаблицы <> "НМА" 
			И ИмяТаблицы <> "ВозвратнаяТара" Тогда
			ДанныеСтроки.СуммаБезСкидкиВДокумент = ДанныеСтроки.СуммаБезСкидки;
			ДанныеСтроки.СуммаСкидкиВДокумент    = ДанныеСтроки.СуммаСкидки;
		КонецЕсли;
		
		ДанныеСтроки.Флаг  = 1;

	Иначе
		
		ДанныеСтроки.КоличествоВДокумент 	= 0;
		ДанныеСтроки.СуммаВДокумент 		= 0;
		
		Если ИмяТаблицы <> "ВозвратнаяТара" Тогда
			ДанныеСтроки.СуммаНДСВДокумент 		= 0;
		КонецЕсли;
		
		Если  ИмяТаблицы <> "ОС" 
			И ИмяТаблицы <> "НМА" 
			И ИмяТаблицы <> "ВозвратнаяТара" Тогда
			ДанныеСтроки.СуммаБезСкидкиВДокумент = 0;
			ДанныеСтроки.СуммаСкидкиВДокумент    = 0;
		КонецЕсли;
		
		ДанныеСтроки.Флаг  = 0;
		
	КонецЕсли;		
	
	Если ИмяТаблицы <> "ВозвратнаяТара" Тогда
			
		ДанныеСтроки.ВсегоВДокумент = ДанныеСтроки.СуммаВДокумент + ?(СуммаВключаетНДС, 0, ДанныеСтроки.СуммаНДСВДокумент);
		
	КонецЕсли;	
	
	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры


&НаКлиенте
Процедура ТоварыКоличествоВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СуммаБезСкидки = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоВДокумент;
	СуммаСкидки	   = ?(СтрокаТабличнойЧасти.Количество = 0, 0, СтрокаТабличнойЧасти.СуммаСкидки / СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.КоличествоВДокумент);
	
	СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент = СуммаБезСкидки;
	СтрокаТабличнойЧасти.СуммаСкидкиВДокумент    = СуммаСкидки;
	
	СтрокаТабличнойЧасти.СуммаВДокумент 		 = СуммаБезСкидки - СуммаСкидки;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаБезСкидкиВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;

	// пересчитаем количествоВДокумент либо оставим как есть
	ПоказатьВопрос(Новый ОписаниеОповещения("СуммаБезСкидкиВДокументПриИзмененииЗавершение", ЭтаФорма, СтрокаТабличнойЧасти), НСтр("ru='Пересчитать значение реквизита ""Количество в документ""?';uk='Перерахувати значення реквізиту ""Кількість у документ""?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаБезСкидкиВДокументПриИзмененииЗавершение(РезультатВыбора, СтрокаТабличнойЧасти) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда	
		СуммаБезСкидок  = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент;
									  
		Если СтрокаТабличнойЧасти.Цена = 0 Тогда
			СтрокаТабличнойЧасти.КоличествоВДокумент = 0;
		Иначе
			СтрокаТабличнойЧасти.КоличествоВДокумент = СуммаБезСкидок / СтрокаТабличнойЧасти.Цена;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СуммаВДокумент = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент - СтрокаТабличнойЧасти.СуммаСкидкиВДокумент;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
	СтрокаТабличнойЧасти.ВсегоВДокумент = СтрокаТабличнойЧасти.СуммаВДокумент + ?(СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДСВДокумент);
	СтрокаТабличнойЧасти.Флаг  = ?(СтрокаТабличнойЧасти.КоличествоВДокумент = 0, 0, ?(СтрокаТабличнойЧасти.КоличествоВДокумент = СтрокаТабличнойЧасти.Количество, 1, 2));
																
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбратьВсе(Команда)
	
	НайденныеСтроки = Объект.Товары.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= Строка.Количество;
		Строка.СуммаВДокумент 			= Строка.Сумма;
		Строка.СуммаСкидкиВДокумент 	= Строка.СуммаСкидки;
		Строка.СуммаБезСкидкиВДокумент 	= Строка.СуммаБезСкидки;
		Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС;
		Строка.Флаг 					= 1;
		Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыИнвертироватьКоличество(Команда)
	
	НайденныеСтроки = Объект.Товары.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Если Строка.КоличествоВДокумент > Строка.Количество Тогда
			Строка.КоличествоВДокумент 	= 0;
			Строка.СуммаВДокумент 		= 0;
			Строка.СуммаНДСВДокумент 	= 0;
			Строка.СуммаСкидкиВДокумент 	= 0;
			Строка.СуммаБезСкидкиВДокумент 	= 0;
			Строка.Флаг 					= 0;
			Строка.ВсегоВДокумент			= 0;
		Иначе
			Строка.КоличествоВДокумент 		= Строка.Количество 	- Строка.КоличествоВДокумент;
			Строка.СуммаВДокумент 			= Строка.Сумма 			- Строка.СуммаВДокумент;
			Строка.СуммаСкидкиВДокумент 	= Строка.СуммаСкидки 	- Строка.СуммаСкидкиВДокумент;
			Строка.СуммаБезСкидкиВДокумент 	= Строка.СуммаБезСкидки - Строка.СуммаБезСкидкиВДокумент;
			Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС 		- Строка.СуммаНДСВДокумент;
			Строка.Флаг 					= ?(Строка.КоличествоВДокумент = 0, 0, ?(Строка.КоличествоВДокумент = Строка.Количество, 1, 2));
			Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
		КонецЕсли;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОтказатьсяОтВсех(Команда)
	
	НайденныеСтроки = Объект.Товары.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= 0;
		Строка.СуммаВДокумент 			= 0;
		Строка.СуммаСкидкиВДокумент 	= 0;
		Строка.СуммаБезСкидкиВДокумент 	= 0;
		Строка.СуммаНДСВДокумент 		= 0;
		Строка.Флаг 					= 0;
		Строка.ВсегоВДокумент 			= 0;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаСкидкиВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаВДокумент = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент - СтрокаТабличнойЧасти.СуммаСкидкиВДокумент;
	
	
	// Рассчитать реквизиты табличной части.
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаСкидкиВДокумент = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент - СтрокаТабличнойЧасти.СуммаВДокумент;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры



&НаКлиенте
Процедура ВозвратнаяТараКоличествоВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВозвратнаяТара.ТекущиеДанные;
	
	// Рассчитать реквизиты табличной части.
	СтрокаТабличнойЧасти.СуммаВДокумент = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоВДокумент;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараСуммаВДокументПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ВозвратнаяТара.ТекущиеДанные;
	
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВозвратнаяТараСуммаВДокументПриИзмененииЗавершение", ЭтаФорма,СтрокаТабличнойЧасти), НСтр("ru='Пересчитать значение реквизита ""Количество в документ""?';uk='Перерахувати значення реквізиту ""Кількість у документ""?'"), РежимДиалогаВопрос.ДаНет)
	

КонецПроцедуры

&НаКлиенте	
Процедура ВозвратнаяТараСуммаВДокументПриИзмененииЗавершение(РезультатОтвета, СтрокаТабличнойЧасти) Экспорт

	// пересчитаем КоличествоВДокумент либо оставим как есть
	Если  РезультатОтвета = КодВозвратаДиалога.Да Тогда
		Если СтрокаТабличнойЧасти.Цена = 0 Тогда
			СтрокаТабличнойЧасти.КоличествоВДокумент = 0;
		Иначе
			СтрокаТабличнойЧасти.КоличествоВДокумент = СтрокаТабличнойЧасти.СуммаВДокумент / СтрокаТабличнойЧасти.Цена;
		КонецЕсли;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Флаг  = ?(СтрокаТабличнойЧасти.КоличествоВДокумент = 0, 0, ?(СтрокаТабличнойЧасти.КоличествоВДокумент = СтрокаТабличнойЧасти.Количество, 1, 2));
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараВыбратьВсе(Команда)
	
	НайденныеСтроки = Объект.ВозвратнаяТара.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= Строка.Количество;
		Строка.СуммаВДокумент 			= Строка.Сумма;
		Строка.Флаг 					= 1;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараИнвертироватьКоличество(Команда)
	
	НайденныеСтроки = Объект.Возвратнаятара.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Если Строка.КоличествоВДокумент > Строка.Количество Тогда
			Строка.КоличествоВДокумент 	= 0;
			Строка.СуммаВДокумент 		= 0;
			Строка.Флаг 				= 0;
		Иначе
			Строка.КоличествоВДокумент 		= Строка.Количество 	- Строка.КоличествоВДокумент;
			Строка.СуммаВДокумент 			= Строка.Сумма 			- Строка.СуммаВДокумент;
			Строка.Флаг 					= ?(Строка.КоличествоВДокумент = 0, 0, ?(Строка.КоличествоВДокумент = Строка.Количество, 1, 2));
		КонецЕсли;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараОтказатьсяОтВсех(Команда)
	
	НайденныеСтроки = Объект.ВозвратнаяТара.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= 0;
		Строка.СуммаВДокумент 			= 0;
		Строка.Флаг 					= 0;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура УслугиКоличествоВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СуммаБезСкидки = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоВДокумент;
	СуммаСкидки	   = ?(СтрокаТабличнойЧасти.Количество = 0, 0, СтрокаТабличнойЧасти.СуммаСкидки / СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.КоличествоВДокумент);
	
	СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент = СуммаБезСкидки;
	СтрокаТабличнойЧасти.СуммаСкидкиВДокумент    = СуммаСкидки;
	
	СтрокаТабличнойЧасти.СуммаВДокумент 		 = СуммаБезСкидки - СуммаСкидки;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаБезСкидкиВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;

	// пересчитаем количествоВДокумент либо оставим как есть
	ПоказатьВопрос(Новый ОписаниеОповещения("СуммаБезСкидкиВДокументПриИзмененииЗавершение", ЭтаФорма, СтрокаТабличнойЧасти), НСтр("ru='Пересчитать значение реквизита ""Количество в документ""?';uk='Перерахувати значення реквізиту ""Кількість у документ""?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаСкидкиВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаВДокумент = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент - СтрокаТабличнойЧасти.СуммаСкидкиВДокумент;
	
	
	// Рассчитать реквизиты табличной части.
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаСкидкиВДокумент = СтрокаТабличнойЧасти.СуммаБезСкидкиВДокумент - СтрокаТабличнойЧасти.СуммаВДокумент;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
КонецПроцедуры

&НаКлиенте
Процедура УслугиВыбратьВсе(Команда)
	
	НайденныеСтроки = Объект.Услуги.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= Строка.Количество;
		Строка.СуммаВДокумент 			= Строка.Сумма;
		Строка.СуммаСкидкиВДокумент 	= Строка.СуммаСкидки;
		Строка.СуммаБезСкидкиВДокумент 	= Строка.СуммаБезСкидки;
		Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС;
		Строка.Флаг 					= 1;
		Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиИнвертироватьКоличество(Команда)
	
	НайденныеСтроки = Объект.Услуги.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Если Строка.КоличествоВДокумент > Строка.Количество Тогда
			Строка.КоличествоВДокумент 	= 0;
			Строка.СуммаВДокумент 		= 0;
			Строка.СуммаНДСВДокумент 	= 0;
			Строка.СуммаСкидкиВДокумент 	= 0;
			Строка.СуммаБезСкидкиВДокумент 	= 0;
			Строка.Флаг 					= 0;
			Строка.ВсегоВДокумент			= 0;
		Иначе
			Строка.КоличествоВДокумент 		= Строка.Количество 	- Строка.КоличествоВДокумент;
			Строка.СуммаВДокумент 			= Строка.Сумма 			- Строка.СуммаВДокумент;
			Строка.СуммаСкидкиВДокумент 	= Строка.СуммаСкидки 	- Строка.СуммаСкидкиВДокумент;
			Строка.СуммаБезСкидкиВДокумент 	= Строка.СуммаБезСкидки - Строка.СуммаБезСкидкиВДокумент;
			Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС 		- Строка.СуммаНДСВДокумент;
			Строка.Флаг 					= ?(Строка.КоличествоВДокумент = 0, 0, ?(Строка.КоличествоВДокумент = Строка.Количество, 1, 2));
			Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
		КонецЕсли;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиОтказатьсяОтВсех(Команда)
	
	НайденныеСтроки = Объект.Услуги.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= 0;
		Строка.СуммаВДокумент 			= 0;
		Строка.СуммаСкидкиВДокумент 	= 0;
		Строка.СуммаБезСкидкиВДокумент 	= 0;
		Строка.СуммаНДСВДокумент 		= 0;
		Строка.Флаг 					= 0;
		Строка.ВсегоВДокумент 			= 0;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиКодУКТВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораНоменклатурыГТДУслуги(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиКодУКТВЭДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.НоменклатураГТД") Тогда
				
		ВыбранноеЗначение = ПолучитьРеквизитНоменклатурыГТДНаСервере(ВыбранноеЗначение, "КодУКТВЭД");	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОСКоличествоВДокументПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаВДокумент 		 = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоВДокумент;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаВДокументПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
КонецПроцедуры

&НаКлиенте
Процедура ОСВыбратьВсе(Команда)
	
	НайденныеСтроки = Объект.ОС.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= Строка.Количество;
		Строка.СуммаВДокумент 			= Строка.Сумма;
		Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС;
		Строка.Флаг 					= 1;
		Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСИнвертироватьКоличество(Команда)
	
	НайденныеСтроки = Объект.ОС.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Если Строка.КоличествоВДокумент > Строка.Количество Тогда
			Строка.КоличествоВДокумент 	= 0;
			Строка.СуммаВДокумент 		= 0;
			Строка.СуммаНДСВДокумент 	= 0;
			Строка.Флаг 					= 0;
			Строка.ВсегоВДокумент			= 0;
		Иначе
			Строка.КоличествоВДокумент 		= Строка.Количество 	- Строка.КоличествоВДокумент;
			Строка.СуммаВДокумент 			= Строка.Сумма 			- Строка.СуммаВДокумент;
			Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС 		- Строка.СуммаНДСВДокумент;
			Строка.Флаг 					= ?(Строка.КоличествоВДокумент = 0, 0, ?(Строка.КоличествоВДокумент = Строка.Количество, 1, 2));
			Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
		КонецЕсли;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОтказатьсяОтВсех(Команда)
	
	НайденныеСтроки = Объект.ОС.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= 0;
		Строка.СуммаВДокумент 			= 0;
		Строка.СуммаНДСВДокумент 		= 0;
		Строка.Флаг 					= 0;
		Строка.ВсегоВДокумент 			= 0;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры



&НаКлиенте
Процедура НМАКоличествоВДокументПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.НМА.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаВДокумент 		 = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоВДокумент;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
																
КонецПроцедуры

&НаКлиенте
Процедура НМАСуммаВДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.НМА.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СуммаНДСВДокумент = УчетНДС.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.СуммаВДокумент,
	                                                   			Истина, СуммаВключаетНДС,
	                                                   			УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));

КонецПроцедуры

&НаКлиенте
Процедура НМАВыбратьВсе(Команда)
	
	НайденныеСтроки = Объект.НМА.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= Строка.Количество;
		Строка.СуммаВДокумент 			= Строка.Сумма;
		Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС;
		Строка.Флаг 					= 1;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НМАИнвертироватьКоличество(Команда)
	
	НайденныеСтроки = Объект.НМА.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Если Строка.КоличествоВДокумент > Строка.Количество Тогда
			Строка.КоличествоВДокумент 	= 0;
			Строка.СуммаВДокумент 		= 0;
			Строка.СуммаНДСВДокумент 	= 0;
			Строка.Флаг 					= 0;
			Строка.ВсегоВДокумент			= 0;
		Иначе
			Строка.КоличествоВДокумент 		= Строка.Количество 	- Строка.КоличествоВДокумент;
			Строка.СуммаВДокумент 			= Строка.Сумма 			- Строка.СуммаВДокумент;
			Строка.СуммаНДСВДокумент 		= Строка.СуммаНДС 		- Строка.СуммаНДСВДокумент;
			Строка.Флаг 					= ?(Строка.КоличествоВДокумент = 0, 0, ?(Строка.КоличествоВДокумент = Строка.Количество, 1, 2));
			Строка.ВсегоВДокумент 			= Строка.СуммаВДокумент + ?(СуммаВключаетНДС, 0, Строка.СуммаНДСВДокумент);
		КонецЕсли;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НМАОтказатьсяОтВсех(Команда)
	
	НайденныеСтроки = Объект.НМА.НайтиСтроки(мОтборСтрокНоменклатуры);
	
	Для каждого Строка  Из НайденныеСтроки Цикл
		Строка.КоличествоВДокумент 		= 0;
		Строка.СуммаВДокумент 			= 0;
		Строка.СуммаНДСВДокумент 		= 0;
		Строка.Флаг 					= 0;
		Строка.ВсегоВДокумент 			= 0;
	КонецЦикла; 
	
	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Функция ЕстьЗаполненныйСчетУчетаНДСВТабличнойЧасти(ТабличнаяЧасть)

	КоличествоСтрок 		= ТабличнаяЧасть.Количество();
	КоличествоНепустыхСтрок = ТабличнаяЧасть.НайтиСтроки(Новый Структура("СчетУчетаНДС", ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПустаяСсылка"))).Количество();
		
	Возврат КоличествоСтрок > 0 И НЕ (КоличествоНепустыхСтрок = КоличествоСтрок);

КонецФункции 

&НаКлиенте
Процедура ЗаполнитьДобавленныеКолонкиТаблиц(ИмяТаблицы = "") Экспорт
	
	ПараметрыОбъекта = Новый Структура("СуммаВключаетНДС", СуммаВключаетНДС);

	Если ПустаяСтрока(ИмяТаблицы) ИЛИ ИмяТаблицы = "Товары" Тогда
		Для каждого СтрокаТаблицы Из Объект.Товары Цикл
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта);
		КонецЦикла;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТаблицы) ИЛИ ИмяТаблицы = "ВозвратнаяТара" Тогда
		Для каждого СтрокаТаблицы Из Объект.Возвратнаятара Цикл
			СтрокаТаблицы.Флаг  = ?(СтрокаТаблицы.КоличествоВДокумент = 0, 0, ?(СтрокаТаблицы.КоличествоВДокумент = СтрокаТаблицы.Количество, 1, 2));
		КонецЦикла;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТаблицы) ИЛИ ИмяТаблицы = "Услуги" Тогда
		Для каждого СтрокаТаблицы Из Объект.Услуги Цикл
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта);
		КонецЦикла;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТаблицы) ИЛИ ИмяТаблицы = "ОС" Тогда
		Для каждого СтрокаТаблицы Из Объект.ОС Цикл
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта);
		КонецЦикла;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТаблицы) ИЛИ ИмяТаблицы = "НМА" Тогда
		Для каждого СтрокаТаблицы Из Объект.НМА Цикл
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, Знач ПараметрыОбъекта)

	СтрокаТаблицы.Всего 		 = СтрокаТаблицы.Сумма 			+ ?(ПараметрыОбъекта.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	СтрокаТаблицы.ВсегоВДокумент = СтрокаТаблицы.СуммаВДокумент + ?(ПараметрыОбъекта.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДСВДокумент);
	СтрокаТаблицы.Флаг  = ?(СтрокаТаблицы.КоличествоВДокумент = 0, 0, ?(СтрокаТаблицы.КоличествоВДокумент = СтрокаТаблицы.Количество, 1, 2));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Объект = Форма.Объект;
	
	СуммаНДС = 0;
	Сумма = 0;
	СуммаТара = 0;
	НайденныеСтроки = Объект.Товары.НайтиСтроки(Форма.мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДСВДокумент;
		Сумма = 	Сумма 	+ Строка.СуммаВДокумент;
	КонецЦикла; 
	КоличествоСтрокТовары =  НайденныеСтроки.Количество();
	
	НайденныеСтроки = Объект.ВозвратнаяТара.НайтиСтроки(Форма.мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаТара = СуммаТара + Строка.СуммаВДокумент;
	КонецЦикла; 
	
	НайденныеСтроки = Объект.Услуги.НайтиСтроки(Форма.мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДСВДокумент;
		Сумма = 	Сумма 	+ Строка.СуммаВДокумент;
	КонецЦикла; 
	
	НайденныеСтроки = Объект.ОС.НайтиСтроки(Форма.мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДСВДокумент;
		Сумма = 	Сумма 	+ Строка.СуммаВДокумент;
	КонецЦикла; 
	
	НайденныеСтроки = Объект.НМА.НайтиСтроки(Форма.мОтборСтрокНоменклатуры);
	Для каждого Строка  Из НайденныеСтроки Цикл
		СуммаНДС = 	СуммаНДС+ Строка.СуммаНДСВДокумент;
		Сумма = 	Сумма 	+ Строка.СуммаВДокумент;
	КонецЦикла; 

	Форма.ИтогиВсегоВДокумент = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма + ?(Форма.СуммаВключаетНДС, 0, СуммаНДС));
	Форма.ИтогиНДСВДокумент   = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС);
    Форма.ИтогиТараВДокумент  = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаТара);	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборФормыНоменклатурногоСостава(ИмяТабличнойЧасти)

	Элементы[ИмяТабличнойЧасти].ОтборСтрок = Новый ФиксированнаяСтруктура(мОтборСтрокНоменклатуры);		
	
КонецПроцедуры
