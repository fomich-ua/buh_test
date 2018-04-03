////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Организация, Ответственный", 
		"Объект.ПериодРегистрации",
		"Объект.Организация",
		"Объект.Ответственный");
		
		ПараметрыФО = Новый Структура("Организация", Объект.Организация);
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
		
	КонецЕсли;
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
	ИспользуетсяОбменСБухгалтерия3 = Ложь;
	
	Если ИспользуетсяОбменСБухгалтерия3 Тогда
		Если Не Объект.Проведен Тогда
			Элементы.ЗарплатаОтраженаВБухучете.ТолькоПросмотр	= Истина;
			Элементы.Бухгалтер.ТолькоПросмотр					= Истина;
		КонецЕсли;
		
		Если Не Пользователи.РолиДоступны("ОтражениеЗарплатыВБухгалтерскомУчете") Тогда
			ТолькоПросмотр = Объект.ЗарплатаОтраженаВБухучете;
			
			Если Параметры.Ключ.Пустая() Тогда
				Объект.ЗарплатаОтраженаВБухучете	= Ложь;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если Параметры.Ключ.Пустая() Тогда
			Объект.Бухгалтер	= Объект.Ответственный;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ЗарплатаОтраженаВБухучете.ТолькоПросмотр	= Не ТекущийОбъект.Проведен;
	Элементы.Бухгалтер.ТолькоПросмотр					= Не ТекущийОбъект.Проведен;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	ОбработатьИзменениеОрганизацииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()

	ОчиститьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаОтраженаВБухучетеПриИзменении(Элемент)
	
	Если Объект.ЗарплатаОтраженаВБухучете Тогда
		Объект.Бухгалтер = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		Объект.Бухгалтер = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////
// Редактирование месяца строкой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ОбработатьИзменениеПериодРегистрацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеВыбрано Тогда
		ОбработатьИзменениеПериодРегистрацииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПериодРегистрацииПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПериодРегистрацииНаСервере()

	Если ЕстьЗаполненныеТабличныеЧасти() Тогда
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ЗаполнитьНаСервере();
		Иначе
			ОчиститьТабличныеЧасти();
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПериодРегистрацииПриИзменении()

	ОбработатьИзменениеПериодРегистрацииНаСервере();
	
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

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.НачисленнаяЗарплатаИВзносы.Количество() > 0 
		Или Объект.УдержанныйНДФЛ.Количество() > 0
		Или Объект.УдержанныйЕСВ.Количество() > 0 
		Или Объект.УдержаннаяЗарплата.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
		ТекстВопроса = Нстр("ru='Табличные части документа будут очищены. Продолжить?';uk='Табличні частини документа будуть очищені. Продовжити?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ОчиститьТабличныеЧасти();

	// получим структуру с отражением в бухучете зарплаты, удержаний, взносов
	РезультатыОтраженияЗарплаты = ОтражениеЗарплатыВБухучете.ДанныеДляОтраженияЗарплатыВБухучете(Объект.ПериодРегистрации, Объект.Организация);
	
	// перенесем данные в табличные части документа
	
	Если ПолучитьФункциональнуюОпцию("ВедетсяУчетРасчетовПоЗарплатеПоРаботникам") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.НачисленнаяЗарплатаИВзносы, Объект.НачисленнаяЗарплатаИВзносы);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержанныйЕСВ, Объект.УдержанныйЕСВ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержанныйНДФЛ, Объект.УдержанныйНДФЛ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержаннаяЗарплата, Объект.УдержаннаяЗарплата);
	Иначе
		РезультатыОтраженияЗарплаты.НачисленнаяЗарплатаИВзносы.Свернуть("Подразделение,ВидОперации,СпособОтраженияЗарплатыВБухучете,Налог,СтатьяНалоговойДекларации,СпособОтраженияЗарплатыВБухучетеВзносы,СтатьяЗатратВзносы,СчетКт,СчетКтВзносы","Сумма,СуммаВзносы");
		РезультатыОтраженияЗарплаты.УдержанныйЕСВ.Свернуть("ВидОперации,СпособОтраженияВБухучете,Налог,СтатьяНалоговойДекларации,СчетУчета","Сумма");
		РезультатыОтраженияЗарплаты.УдержанныйНДФЛ.Свернуть("ВидОперации,СпособОтраженияВБухучете,СчетУчета","Сумма");
		РезультатыОтраженияЗарплаты.УдержаннаяЗарплата.Свернуть("ВидОперации,СпособОтраженияВБухучете,СчетУчета,Подразделение,Контрагент","Сумма");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.НачисленнаяЗарплатаИВзносы, Объект.НачисленнаяЗарплатаИВзносы);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержанныйЕСВ, Объект.УдержанныйЕСВ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержанныйНДФЛ, Объект.УдержанныйНДФЛ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержаннаяЗарплата, Объект.УдержаннаяЗарплата);
	КонецЕсли;	
	ПослеЗаполненияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаполненияНаСервере()
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры


&НаСервере
Процедура УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов()
	
	Если ЕстьЗаполненныеТабличныеЧасти() Тогда
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
	Иначе
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
	Элементы.Организация.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.ПериодРегистрации.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	
КонецПроцедуры

&НаСервере
Функция ЕстьЗаполненныеТабличныеЧасти()
	
	ДанныеВТЧЕсть = Ложь;
	
	СписокТабличныхЧастей = СписокТабличныхЧастейДокумента();
	
	Для каждого ИмяТабличнойЧасти Из СписокТабличныхЧастей Цикл
		Если Объект[ИмяТабличнойЧасти].Количество() > 0 Тогда
			ДанныеВТЧЕсть = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ДанныеВТЧЕсть;
	
КонецФункции

&НаСервере
Функция СписокТабличныхЧастейДокумента()
	
	СписокТабличныхЧастей = Новый Массив;
	
	СписокТабличныхЧастей.Добавить("НачисленнаяЗарплатаИВзносы");
	СписокТабличныхЧастей.Добавить("УдержанныйЕСВ");
	СписокТабличныхЧастей.Добавить("УдержанныйНДФЛ");
	СписокТабличныхЧастей.Добавить("УдержаннаяЗарплата");
	
	Возврат СписокТабличныхЧастей;
	
КонецФункции

&НаСервере
Процедура ОчиститьТабличныеЧасти()
	
	СписокТабличныхЧастей = СписокТабличныхЧастейДокумента();
	
	Для каждого ИмяТабличнойЧасти Из СписокТабличныхЧастей Цикл
		Объект[ИмяТабличнойЧасти].Очистить();
	КонецЦикла;
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры



