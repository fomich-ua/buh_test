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
		УстановитьСчетУчетаВнеоборотногоАктива(ЭтаФорма);
	КонецЕсли;
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ТекущийОбъект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование Тогда
		ТекущийОбъект.ОбъектСтроительства = Неопределено;
	ИначеЕсли ТекущийОбъект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства Тогда
		ТекущийОбъект.Номенклатура = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма")
			И ВладелецФормы.ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаЭлемента" Тогда
		Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
			Оповестить("ИзмененаИнформацияОС", ВладелецФормы.Параметры.Ключ);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборОсновныхСредств.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		УстановитьВидимостьПоВидуОперации(ЭтаФорма);
		УстановитьСчетУчетаВнеоборотногоАктива(ЭтаФорма);
		
		УстановитьНалоговоеНазначениеОбъектаСтроительства();
		
		УстановитьВидимостьНУ();
		
	КонецЕсли;

КонецПроцедуры

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

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииСервер();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

&НаСервере
// Устанавливает СчетНачисленияАмортизацииБУ 
// по значению СчетУчетаБУ 
// или по значению СчетУчетаБУВнеоборотногоАктива
//
Процедура УстановитьСчетАмортизации() Экспорт
	
	ПланХозрасчетный = ПланыСчетов.Хозрасчетный;
	
	Счет10   = ПланХозрасчетный.ОсновныеСредства;
	Счет11   = ПланХозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа;
	Счет13   = ПланХозрасчетный.ИзносАмортизацияНеоборотныхАктивов;
	Счет131  = ПланХозрасчетный.ИзносОсновныхСредств;
	Счет132  = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивов;
	Счет1321 = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовИндивидуально;
	Счет1322 = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовКоличественно;
	Счет151  = ПланХозрасчетный.КапитальноеСтроительство;
	Счет152  = ПланХозрасчетный.ПриобретениеИзготовлениеОсновныхСредств;
	Счет153  = ПланХозрасчетный.ПриобретениеИзготовлениеДругихНеоборотныхМатериальныхАктивов;
	
	СчетУчетаБУ = Объект.СчетУчетаБУ;
	
	Если ЗначениеЗаполнено(СчетУчетаБУ) Тогда
		
		Если СчетУчетаБУ.ПринадлежитЭлементу(Счет10) Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.СчетНачисленияАмортизацииБУ)
				ИЛИ (НЕ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет13))
				ИЛИ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет132) Тогда
				
				Объект.СчетНачисленияАмортизацииБУ = Счет131;
				
			КонецЕсли;
			
		ИначеЕсли СчетУчетаБУ.ПринадлежитЭлементу(Счет11) Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.СчетНачисленияАмортизацииБУ)
				ИЛИ (НЕ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет132))
				ИЛИ Объект.СчетНачисленияАмортизацииБУ = (Счет1322) Тогда
				
				Объект.СчетНачисленияАмортизацииБУ = Счет1321;
				
			КонецЕсли;                                                   
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.СчетУчетаБУВнеоборотногоАктива) Тогда
		
		Если Объект.СчетУчетаБУВнеоборотногоАктива.ПринадлежитЭлементу(Счет152)
			ИЛИ Объект.СчетУчетаБУВнеоборотногоАктива = Счет151 Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.СчетНачисленияАмортизацииБУ)
				ИЛИ (НЕ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет13))
				ИЛИ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет132) Тогда
				
				Объект.СчетНачисленияАмортизацииБУ = Счет131;
				
			КонецЕсли;
			
		ИначеЕсли Объект.СчетУчетаБУВнеоборотногоАктива.ПринадлежитЭлементу(Счет153) Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.СчетНачисленияАмортизацииБУ)
				ИЛИ (НЕ Объект.СчетНачисленияАмортизацииБУ.ПринадлежитЭлементу(Счет132))
				ИЛИ Объект.СчетНачисленияАмортизацииБУ = (Счет1322) Тогда
				
				Объект.СчетНачисленияАмортизацииБУ = Счет1321;
				
			КонецЕсли;                                                   
			
		КонецЕсли;
		
	КонецЕсли;
		

КонецПроцедуры // УстановитьСчетАмортизации()

&НаСервере
// Процедура заполняет счета учета оборудования из регистра сведений
// "Счета учета номенклатуры".
//
Процедура ЗаполнитьСчетаУчетаОборудования()
	
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		
		Объект.СчетУчетаБУВнеоборотногоАктива 	= ПланыСчетов.Хозрасчетный.ПриобретениеОсновныхСредств;
		Объект.НалоговоеНазначение            	= Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая;   
		Объект.НалоговоеНазначениеОборудования 	= Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая;   
		
	Иначе
		
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(Объект.Организация, Объект.Номенклатура, Объект.Склад);
		Объект.СчетУчетаБУВнеоборотногоАктива 	= СчетаУчета.СчетУчетаБУ;
		Объект.НалоговоеНазначение            	= СчетаУчета.НалоговоеНазначение;
		Объект.НалоговоеНазначениеОборудования 	= СчетаУчета.НалоговоеНазначение;
		
	КонецЕсли;
	
 	УстановитьСчетАмортизации();
	
	
КонецПроцедуры // ЗаполнитьСчетаУчетаОборудования()

&НаСервере
// Процедура заполняет счета учета объекта строительства из регистра сведений
// "Объекты строительства организаций".
//
Процедура ЗаполнитьСчетаУчетаОбъектаСтроительства()
	
	СчетаУчета = УправлениеНеоборотнымиАктивами.ПолучитьСчетаУчетаОбъектовСтроительства(Объект.Организация, Объект.ОбъектСтроительства);
	Объект.СчетУчетаБУВнеоборотногоАктива = СчетаУчета.СчетУчетаБУ;
	Объект.НалоговоеНазначение            = СчетаУчета.НалоговоеНазначение;
	УстановитьСчетАмортизации();
	
	УстановитьНалоговоеНазначениеОбъектаСтроительства();
			
КонецПроцедуры // ЗаполнитьСчетаУчетаОборудования()

&НаСервере
// Функция возвращает список значений доступных способов амортизации для бух. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокСпособовАмортизацииБУ() 
                                                                                                        
	СписокПеречисления = Новый СписокЗначений;
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Производственный);
	
	Если ЗначениеЗаполнено(Объект.СчетУчетаБУ) 
		  И Объект.СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа) Тогда
		  
		Если Объект.СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.БиблиотечныеФонды)
		 ИЛИ Объект.СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.МалоценныеНеоборотныеМатериальныеАктивы) Тогда
			
			СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._50_50);
			СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._100);
			
		КонецЕсли;
		  
	Иначе
	
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка);
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка);
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный);
		
	КонецЕсли;
	
	Возврат СписокПеречисления;

КонецФункции // ПолучитьСписокСпособовАмортизацииБУ()

&НаСервере
// Функция возвращает список значений доступных способов амортизации для бух. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокСпособовАмортизацииНУ()
                                                                                                        
	СписокПеречисления = Новый СписокЗначений;
	
	Если Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС._50_50 ИЛИ Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС._100 Тогда
		СписокПеречисления.Добавить(Объект.СпособНачисленияАмортизацииБУ);
		Возврат СписокПеречисления;
	КонецЕсли;	
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный);
	
	Если ЗначениеЗаполнено(Объект.СчетУчетаБУ) 
		  И Объект.СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа) Тогда
		  
	Иначе
	
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка);
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка);
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный);
		
	КонецЕсли;
	
	Возврат СписокПеречисления;

КонецФункции // ПолучитьСписокСпособовАмортизацииБУ()

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)

    ЗаполнитьСчетаУчетаОборудования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСтроительстваПриИзменении(Элемент)
	
    ЗаполнитьСчетаУчетаОбъектаСтроительства();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаВнеоборотногоАктиваПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьСчетАмортизации();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаВнеоборотногоАктиваСтроительствоПриИзменении(Элемент)
	
	УстановитьСчетАмортизации();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)

	СпособНачисленияАмортизацииБУ = Объект.СпособНачисленияАмортизацииБУ;
	
	Если (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._50_50"))
	 ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._100")) Тогда
		 
		 Объект.НачислятьАмортизациюБУ = Истина;
		
	КонецЕсли;
	
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокСпособовАмортизацииНУ().ВыгрузитьЗначения());
	
	Если СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Производственный") Тогда
		Объект.СпособНачисленияАмортизацииНУ = СпособНачисленияАмортизацииБУ;
	Иначе	
		Объект.СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный");
	КонецЕсли;	
	
	УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииНУПриИзменении(Элемент)

	УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияБУПриИзменении(Элемент)

	РасшифровкаСрокаПолезногоИспользованияБУ =
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Объект.СрокПолезногоИспользованияБУ);

	Объект.СрокПолезногоИспользованияНУ = Объект.СрокПолезногоИспользованияБУ;
	
	РасшифровкаСрокаПолезногоИспользованияНУ =
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Объект.СрокПолезногоИспользованияНУ);
		
КонецПроцедуры

&НаКлиенте
Процедура УказатьПервоначальнуюСтоимостьПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияНУПриИзменении(Элемент)

	РасшифровкаСрокаПолезногоИспользованияНУ =
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Объект.СрокПолезногоИспользованияНУ);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОС

&НаКлиенте
Процедура ОСПриИзменении(Элемент)

	СписокОСИзменен = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)

	ЭлементКоллекции = Элементы.ОС.ТекущиеДанные;
	Если ЗначениеЗаполнено(ЭлементКоллекции.ОсновноеСредство) Тогда
		ЭлементКоллекции.ИнвентарныйНомер = ПолучитьКод(ЭлементКоллекции.ОсновноеСредство);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)

	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));

	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы = Новый Структура;
	Если Объект.ОС.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("АдресОСВХранилище", ПоместитьОСВХранилище());
	КонецЕсли;

	ОткрытьФорму("Обработка.ПодборОсновныхСредств.Форма.Форма", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммыПоОбъектуСтроительства(Команда)

	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();

	Отказ = Ложь;

	Если НЕ ЗначениеЗаполнено(Объект.ОбъектСтроительства) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Объект строительства';uk=""Об'єкт будівництва"""));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОбъектСтроительства", , Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация", Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаБУВнеоборотногоАктива) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Счет учета внеоборотного актива';uk='Рахунок обліку внеоборотного активу'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СчетУчетаБУВнеоборотногоАктива", , Отказ);
	КонецЕсли;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	СтруктураСтоимости = УправлениеНеоборотнымиАктивами.РасчитатьСтоимостьОбъектаСтроительства(Объект.СчетУчетаБУВнеоборотногоАктива, 
																Объект.ОбъектСтроительства, 
																Объект.Организация, 
																КонецМесяца(Объект.Дата));

	ЗаполнитьЗначенияСвойств(Объект, СтруктураСтоимости);

	ДатаНКУ2015 = '2015 01 01';
	Если Объект.Дата >= ДатаНКУ2015 Тогда
		// для документов 2015 года СтоимостьНУ = СтоимостьБУ  
		Объект.СтоимостьНУ = СтруктураСтоимости.СтоимостьБУ;
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

	УстановитьФункциональныеОпцииФормы();

	ТекущаяДатаДокумента = Объект.Дата;
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	РасшифровкаСрокаПолезногоИспользованияБУ =
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Объект.СрокПолезногоИспользованияБУ);
	РасшифровкаСрокаПолезногоИспользованияНУ =
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Объект.СрокПолезногоИспользованияНУ);

	УправлениеФормой(ЭтаФорма);

	УстановитьСписокСпособовНачисленияАмортизацииБУ();

	УстановитьНалоговоеНазначениеОбъектаСтроительства();
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетУчетаБУВнеоборотногоАктива);
	
	УстановитьВидимостьНУ();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);

КонецПроцедуры        

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	УстановитьВидимостьПоВидуОперации(Форма);
	УстановитьВидимостьПараметровАмортизацииБУ(Форма);
	
	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)

	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	Результат.Вставить("ИмяТабличнойЧасти", "ОС");
	Результат.Вставить("ПолучатьИнвентарныйНомерИзКода", Истина);

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)

	УчетОС.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3, Подразделение",
		"СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3", "ПодразделениеОрганизации");

	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3, Подразделение",
		"ЗаголовокСубконто1", "ЗаголовокСубконто2", "ЗаголовокСубконто3", "ЗаголовокПодразделение");

	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПоВидуОперации(Форма)

	ВидОперации = Форма.Объект.ВидОперации;
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование") Тогда
		Форма.Элементы.ГруппаСтраницыВнеоборотныеАктивы.ТекущаяСтраница = Форма.Элементы.ГруппаОсновныеСредстваСоСклада;
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") Тогда
		Форма.Элементы.ГруппаСтраницыВнеоборотныеАктивы.ТекущаяСтраница = Форма.Элементы.ГруппаОбъектыСтроительства;
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ПоРезультатамИнвентаризации") Тогда
		Форма.Элементы.ГруппаСтраницыВнеоборотныеАктивы.ТекущаяСтраница = Форма.Элементы.ГруппаПоРезультатамИнвентаризации;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПараметровАмортизацииБУ(Форма)

	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	СпособНачисленияАмортизацииБУ = Объект.СпособНачисленияАмортизацииБУ;
	СпособНачисленияАмортизацииНУ = Объект.СпособНачисленияАмортизацииНУ;
	
	Элементы.НачислятьАмортизациюБУ.Видимость = (СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._100"))
	                                                  И (СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._50_50"));
	
	Если СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Производственный") Тогда
		Элементы.ГруппаПроизводственный.Видимость 	= Истина;
		Элементы.ГруппаСрокИспользования.Видимость 	= Ложь;
	ИначеЕсли (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УменьшенияОстатка"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Кумулятивный"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка")) Тогда
		Элементы.ГруппаПроизводственный.Видимость 	= Ложь;
		Элементы.ГруппаСрокИспользования.Видимость 	= Истина;
	Иначе
		Элементы.ГруппаПроизводственный.Видимость 	= Ложь;
		Элементы.ГруппаСрокИспользования.Видимость 	= Ложь;
	КонецЕсли;

	ДатаНКУ2015 = '2015 01 01';
	ЭтоДокументДо2015 = (Объект.Дата < ДатаНКУ2015);
	
	ВидимостьСрокПолезногоИспользованияНУ = Ложь;
	Если ЭтоДокументДо2015 Тогда
		Если 	(СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УменьшенияОстатка"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Кумулятивный"))
		  ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка")) Тогда
      	ВидимостьСрокПолезногоИспользованияНУ = Истина;
		КонецЕсли;
	Иначе	
		Если 	(СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный"))
		  ИЛИ (СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УменьшенияОстатка"))
		  ИЛИ (СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Кумулятивный"))
		  ИЛИ (СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка")) Тогда
      	ВидимостьСрокПолезногоИспользованияНУ = Истина;
		КонецЕсли;
	КонецЕсли;	
	
	НепроизводственноеНУ = (Объект.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность"));
	ВидимостьСрокПолезногоИспользованияНУ = Форма.ПлательщикНалогаНаПрибыль И ВидимостьСрокПолезногоИспользованияНУ И НЕ НепроизводственноеНУ; 
	
	Элементы.ГруппаСрокИспользованияНУ.Видимость = ВидимостьСрокПолезногоИспользованияНУ;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСчетУчетаВнеоборотногоАктива(Форма)
	
	ВидОперации = Форма.Объект.ВидОперации;
	
	СчетПриобретениеОбъектовОсновныхСредств = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПриобретениеОсновныхСредств");
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование") Тогда 
		
		СвойстваСчетаПриобретения = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетПриобретениеОбъектовОсновныхСредств);
		
		СчетУчетаВнеоборотногоАктива = ?(СвойстваСчетаПриобретения.ЗапретитьИспользоватьВПроводках,
										 Неопределено,
										 СчетПриобретениеОбъектовОсновныхСредств);
		Форма.Объект.СчетУчетаБУВнеоборотногоАктива = СчетУчетаВнеоборотногоАктива;
		
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") Тогда
		
		СчетСтроительствоОбъектовОсновныхСредств = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПриобретениеОсновныхСредств");
   		СвойстваСчетаСтроительства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетСтроительствоОбъектовОсновныхСредств);
		
		СчетУчетаВнеоборотногоАктива = ?(СвойстваСчетаСтроительства.ЗапретитьИспользоватьВПроводках,
										 Неопределено,
										 СчетСтроительствоОбъектовОсновныхСредств);
		Форма.Объект.СчетУчетаБУВнеоборотногоАктива = СчетУчетаВнеоборотногоАктива;
		
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ПоРезультатамИнвентаризации") Тогда
		
		СчетУчетаВнеоборотногоАктива = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ДругиеДоходыОтОбычнойДеятельности");
   		СвойстваСчетаСтроительства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчетаВнеоборотногоАктива);
		
		СчетУчетаВнеоборотногоАктива = ?(СвойстваСчетаСтроительства.ЗапретитьИспользоватьВПроводках,
										 Неопределено,
										 СчетУчетаВнеоборотногоАктива);
		Форма.Объект.СчетУчетаБУВнеоборотногоАктива = СчетУчетаВнеоборотногоАктива;
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Форма.Объект.СчетУчетаБУВнеоборотногоАктива);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.Объект.СчетУчетаДооценокОС) Тогда

		Форма.Объект.СчетУчетаДооценокОС = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ДооценкаОсновныхСредств");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПоместитьОСВХранилище()

	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОС);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(Знач ВыбранноеЗначение)

	ДобавленныеСтроки = УчетОС.ОбработатьПодборОсновныхСредств(Объект.ОС, ВыбранноеЗначение);
	
	МассивОсновныхСредств = Объект.ОС.Выгрузить(ДобавленныеСтроки, "ОсновноеСредство").ВыгрузитьКолонку("ОсновноеСредство");	
	ОсновныеСредстваКоды = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОсновныхСредств, "Код");
	
	Для каждого Строка Из ДобавленныеСтроки Цикл
		
		Если ЗначениеЗаполнено(Строка.ИнвентарныйНомер) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураКоды = ОсновныеСредстваКоды.Получить(Строка.ОсновноеСредство);
		Если СтруктураКоды <> Неопределено Тогда 
			Строка.ИнвентарныйНомер = СтруктураКоды.Код;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСчетУчетаНоменклатуры(Знач Организация, Знач Номенклатура, Знач Склад)

	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(Организация, Номенклатура, Склад);
	Возврат СчетаУчета.СчетУчета;

КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьВидимостьНУ();
	
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, "СубконтоБУ%Индекс%"); 
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		ЭтаФорма,
		Объект,
		"СубконтоБУ%Индекс%",
		"СубконтоБУ%Индекс%",
		ПараметрыДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);
	УстановитьВидимостьНУ();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКод(Знач ОС)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОС, "Код");
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);

КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаБУВнеоборотногоАктиваПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетУчетаБУВнеоборотногоАктива);
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетУчетаБУВнеоборотногоАктива, Объект, ПоляОбъекта);
	
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, "СубконтоБУ%Индекс%"); 
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		ЭтаФорма,
		Объект,
		"СубконтоБУ%Индекс%",
		"СубконтоБУ%Индекс%",
		ПараметрыДокумента);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУПриИзменении(Элемент)
	
	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, "СубконтоБУ%Индекс%"); 
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		ЭтаФорма,
		Объект,
		"СубконтоБУ%Индекс%",
		"СубконтоБУ%Индекс%",
		ПараметрыДокумента);

КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметров(Форма, ШаблонИмяПоляОбъекта)
	
	Объект = Форма.Объект;
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", Объект[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("Организация", Объект.Организация);

	Возврат СписокПараметров;

КонецФункции


&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	УстановитьСписокСпособовНачисленияАмортизацииБУ();
	УстановитьСчетАмортизации();
	УправлениеНеоборотнымиАктивами.УстановитьНалоговуюГруппуОС(Объект.СчетУчетаБУ, Объект.НалоговаяГруппаОС);
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокСпособовНачисленияАмортизацииБУ()
	Список = ПолучитьСписокСпособовАмортизацииБУ();
	Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора.ЗагрузитьЗначения(Список.ВыгрузитьЗначения());
	
	Если НЕ ЗначениеЗаполнено(Объект.СпособНачисленияАмортизацииБУ)
	 ИЛИ Список.НайтиПоЗначению(Объект.СпособНачисленияАмортизацииБУ) = Неопределено Тогда
	 
		Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный;
		УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);
		
	КонецЕсли;                                                                                    
	
	СписокНУ = ПолучитьСписокСпособовАмортизацииНУ();
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(СписокНУ.ВыгрузитьЗначения());
	
	Если НЕ ЗначениеЗаполнено(Объект.СпособНачисленияАмортизацииНУ)
	 ИЛИ Список.НайтиПоЗначению(Объект.СпособНачисленияАмортизацииНУ) = Неопределено Тогда
	 
		Объект.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный;
		УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);
		
	КонецЕсли;                                                                                    
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНалоговоеНазначениеОбъектаСтроительства()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства Тогда
		Если НЕ ЭтаФорма.ПлательщикНалогаНаПрибыль Тогда
			ЭтаФорма.НалоговоеНазначениеОбъектаСтроительства = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		Иначе	
			ЭтаФорма.НалоговоеНазначениеОбъектаСтроительства = Объект.ОбъектСтроительства.НалоговоеНазначение;
		КонецЕсли;
	Иначе	
		ЭтаФорма.НалоговоеНазначениеОбъектаСтроительства = "";
	КонецЕсли;	
	
	УстановитьПараметрыВыбораНалоговогоНазначенияОС();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНУ()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование Тогда
		Элементы.НалоговоеНазначениеОборудования.Доступность = ПлательщикНДС;
	КонецЕсли;	
	
	ДатаНКУ2015 = '2015 01 01';
	ЭтоДокументДо2015 = (Объект.Дата < ДатаНКУ2015);
	
	Элементы.ГруппаСтоимостьНУ.Видимость 				= ПлательщикНалогаНаПрибыль И ЭтоДокументДо2015;
	Элементы.ГруппаСтоимостьНУИнвентаризация.Видимость 	= ПлательщикНалогаНаПрибыль И ЭтоДокументДо2015;
	
	НепроизводственноеНУ = (Объект.НалоговоеНазначение.ВидНалоговойДеятельности = Справочники.ВидыНалоговойДеятельности.НеОблагаемая);
	
	Элементы.СпособНачисленияАмортизацииНУ.Видимость = НЕ ЭтоДокументДо2015 И ПлательщикНалогаНаПрибыль И НЕ НепроизводственноеНУ;
	
	Элементы.ДекорацияНадписьИнформацияНалоговоеНазначениеЗатрат.Видимость 	= ЭтоДокументДо2015;
	
	Если ЭтоДокументДо2015 Тогда
		Элементы.СтоимостьБУ.Заголовок 	= НСтр("ru='Стоимость (бух. учет)';uk='Вартість (бух. облік)'");
		Элементы.СтоимостьБУИнвентаризация.Заголовок = НСтр("ru='Стоимость (бух. учет)';uk='Вартість (бух. облік)'");
	Иначе
		Элементы.СтоимостьБУ.Заголовок 	= НСтр("ru='Стоимость';uk='Вартість'");
		Элементы.СтоимостьБУИнвентаризация.Заголовок = НСтр("ru='Стоимость';uk='Вартість'");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НалоговоеНазначениеПриИзменении(Элемент)
	УстановитьВидимостьПараметровАмортизацииБУ(ЭтаФорма);
	УстановитьВидимостьНУ();
КонецПроцедуры

&НаКлиенте
Процедура НалоговоеНазначениеОборудованияПриИзменении(Элемент)
	УстановитьПараметрыВыбораНалоговогоНазначенияОС();
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораНалоговогоНазначенияОС()
	
	
	НалоговоеНазначениеОборудования = Объект.НалоговоеНазначениеОборудования;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства Тогда
		НалоговоеНазначениеОборудования = Объект.ОбъектСтроительства.НалоговоеНазначение;
		Если НЕ ПлательщикНДС Тогда
			НалоговоеНазначениеОборудования = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		КонецЕсли;	
	КонецЕсли;	
	
	НовыйМассивПараметров = Новый Массив();
	
	// Добавим старые параметры
	Для Каждого ТекущийПараметрВыбора Из Элементы.НалоговоеНазначение.ПараметрыВыбора Цикл
		Если ТекущийПараметрВыбора.Имя = "Отбор.Ссылка" Тогда
			Продолжить;
		КонецЕсли;	
		НовыйМассивПараметров.Добавить(ТекущийПараметрВыбора);
	КонецЦикла;	
	
	СписокНалоговыхНазначенийОС = Справочники.НалоговыеНазначенияАктивовИЗатрат.ПолучитьСписокНалоговыхНазначенийОС(НалоговоеНазначениеОборудования);
	
	Если ЗначениеЗаполнено(НалоговоеНазначениеОборудования) И СписокНалоговыхНазначенийОС.Количество() > 0 Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СписокНалоговыхНазначенийОС.ВыгрузитьЗначения()));
		НовыйМассивПараметров.Добавить(НовыйПараметр);
	КонецЕсли;	
	
	НовыеПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	Элементы.НалоговоеНазначение.ПараметрыВыбора = НовыеПараметрыВыбора;
	
	Если ЗначениеЗаполнено(НалоговоеНазначениеОборудования) И ЗначениеЗаполнено(Объект.НалоговоеНазначение) 
	 	И СписокНалоговыхНазначенийОС.Количество() > 0 И СписокНалоговыхНазначенийОС.НайтиПоЗначению(Объект.НалоговоеНазначение) = Неопределено Тогда
		// обновим недоступное значение
		Объект.НалоговоеНазначение = НалоговоеНазначениеОборудования;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры



