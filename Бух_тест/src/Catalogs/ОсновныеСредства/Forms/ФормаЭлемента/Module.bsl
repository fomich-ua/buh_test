///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;

КонецПроцедуры

&НаСервере
Процедура ВыполнитьИнициализацию()

	Если ИнициализацияВыполнена Тогда
		Возврат;
	КонецЕсли;

	ИнициализацияВыполнена = Истина;

	ДатаСведений = КонецДня(ТекущаяДатаСеанса());
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ВалютаРегламентированногоУчетаНУ = ВалютаРегламентированногоУчета;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСведения()

	ЗаполнитьОписания();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписания()

	ВидСубконтоОС = Новый Массив();
	ВидСубконтоОС.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);

	// Выборка из регистра сведений "Состояния ОС организаций"
	Запрос = Новый Запрос();
	ДатаВремяНаКонецДня = Новый Граница(КонецДня(ДатаСведений), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("ДатаСведений", 	  ДатаВремяНаКонецДня);
	Запрос.УстановитьПараметр("ОсновноеСредство", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|";
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Организация = РезультатЗапроса.Выгрузить()[0].Организация;
		ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
			ЭтаФорма,
			Организация,
			ДатаСведений);
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;

	// Данные для заполнения закладки "Бухгалтерский учет"
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаСведений",     Новый Граница(КонецДня(ДатаСведений), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("ВидСубконтоОС",    ВидСубконтоОС);

	Запрос.Текст =
	"////////////////////////////////////////////////////////////////////////////////
	|// 0 - ПервоначальныеСведенияОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимостьБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПараметрВыработки КАК ПараметрВыработкиБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПараметрВыработки.ЕдиницаИзмерения КАК ЕдиницаПараметраВыработкиБУ
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 1 - МестонахождениеОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ КАК МОЛБУ,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение КАК ПодразделениеБУ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 2 - ПараметрыАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.СрокПолезногоИспользования КАК СрокИспользованияБУ,
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ОбъемПродукцииРабот КАК ОбъемРаботБУ,
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимостьБУ
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 3 - ГрафикиАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГрафикиАмортизацииОСБухгалтерскийУчетСрезПоследних.ГрафикАмортизации КАК ГодовойГрафикБУ
	|ИЗ
	|	РегистрСведений.ГрафикиАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ГрафикиАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 4 - СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетСрезПоследних.СпособыОтраженияРасходовПоАмортизации КАК СпособОтраженияРасходовПоАмортизацииБУ
	|ИЗ
	|	РегистрСведений.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|//	5 - СчетаБухгалтерскогоУчетаОС
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчетаБУ,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизацииБУ,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчетаДооценокОС КАК СчетУчетаДооценокОС
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОССрезПоследних";

    МассивРезультатов 	= Запрос.ВыполнитьПакет();
    СчетУчетаБУ 				= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
    СчетНачисленияАмортизацииБУ = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	
    Если МассивРезультатов[0].Пустой() Тогда
		НоваяТекущаяСтраница = Элементы.ГруппаОсновноеСредствоВБухгалтерскомУчетеНеОтражалось;
		Элементы.ГруппаАмортизацияБУ.Видимость = Ложь;
	Иначе
		НоваяТекущаяСтраница = Элементы.ГруппаОтражениеОСВБУ;
		Элементы.ГруппаАмортизацияБУ.Видимость = Истина;
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Стоимостные показатели
	Если ЗначениеЗаполнено(СчетУчетаБУ) Тогда
		
		Запрос.УстановитьПараметр("СчетУчетаБУ", СчетУчетаБУ);
		Запрос.УстановитьПараметр("СчетНачисленияАмортизацииБУ", СчетНачисленияАмортизацииБУ);
		
		ТекстЗапросаСтоимость = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХозрасчетныйОстаткиСтоимость.СуммаОстатокДт КАК ТекущаяСтоимостьБУ,
		|	ХозрасчетныйОстаткиСтоимость.СуммаНУОстатокДт КАК ТекущаяСтоимостьНУ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаСведений,
		|			Счет = &СчетУчетаБУ,
		|			&ВидСубконтоОС,
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстаткиСтоимость";
		
		ТекстЗапросаАмортизация = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХозрасчетныйОстаткиАмортизация.СуммаОстатокКт КАК ТекАмортизацияБУ,
		|	ХозрасчетныйОстаткиАмортизация.СуммаОстатокДт КАК ТекИзносБУ,
		|	ХозрасчетныйОстаткиАмортизация.СуммаНУОстатокКт КАК ТекАмортизацияНУ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаСведений,
		|			Счет = &СчетНачисленияАмортизацииБУ,
		|			&ВидСубконтоОС,
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстаткиАмортизация";
		
		Запрос.Текст = ТекстЗапросаСтоимость;
		Если ЗначениеЗаполнено(СчетНачисленияАмортизацииБУ) Тогда
			Запрос.Текст = Запрос.Текст 
				+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета()
				+ ТекстЗапросаАмортизация;
		КонецЕсли;
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	Элементы.ГруппаСтраницыОтражениеВБУ.ТекущаяСтраница = НоваяТекущаяСтраница;

	РасшифровкаСрокаПолезногоИспользованияБУ = УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СрокИспользованияБУ);

	// Установка видимости страниц панели ПанельПараметрыАмортизации
	Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка Тогда
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаПрочие;
	ИначеЕсли СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаПроизводственный;
	Иначе	
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаСпособНачисленияАмортизацииБУНеУказан;
	КонецЕсли;

	УчетОС.ПолучитьДокументБухСостоянияОС(Объект.Ссылка, Организация, Перечисления.СостоянияОС.ВведеноВЭксплуатацию,
		ДокументВводаВЭксплуатациюБУ, ВведеноВЭксплуатациюБУ);
	УчетОС.ПолучитьДокументБухСостоянияОС(Объект.Ссылка, Организация, Перечисления.СостоянияОС.СнятоСУчета,
		ДокументСнятияСУчетаБУ, СнятоСУчетаБУ);

	// Данные для заполнения закладки "Налоговый учет".
	// Стоимостные показатели текущей стоимости и амортизации по НУ заполнены вместе с БУ.
	Запрос.Текст =
	"////////////////////////////////////////////////////////////////////////////////
	|// 0 - ПервоначальныеСведенияОСНалоговыйУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних.ПервоначальнаяСтоимостьНУ, 0) КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних.НалоговаяГруппаОС КАК НалоговаяГруппаОС
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 1 - ПараметрыАмортизацииОСНалоговыйУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСНалоговыйУчетСрезПоследних.СрокПолезногоИспользования КАК СрокИспользованияНУ
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСНалоговыйУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСНалоговыйУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 2 - НалоговыеНазначенияОС
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалоговыеНазначенияОССрезПоследних.НалоговоеНазначение КАК НалоговоеНазначение
	|ИЗ
	|	РегистрСведений.НалоговыеНазначенияОС.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК НалоговыеНазначенияОССрезПоследних";

	МассивРезультатов = Запрос.ВыполнитьПакет();

	Если МассивРезультатов[0].Пустой() Тогда
		НоваяТекущаяСтраница = Элементы.ГруппаОсновноеСредствоВНалоговомУчетеНеОтражалось;
		Элементы.ГруппаНачислениеАмортизацииНУДекорация.Видимость = Ложь;
	Иначе
		НоваяТекущаяСтраница = Элементы.ГруппаОтражениеОСВНУ;
		Элементы.ГруппаНачислениеАмортизацииНУДекорация.Видимость = Истина;
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницыОтражениеВНУ.ТекущаяСтраница = НоваяТекущаяСтраница;

	РасшифровкаСрокаПолезногоИспользованияНУ = УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СрокИспользованияНУ);

	ВведеноВЭксплуатациюНУ = ВведеноВЭксплуатациюБУ;
	СнятоСУчетаНУ = СнятоСУчетаБУ;

	ЗаполнитьТекстПроДокументы();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекстПроДокументы()

	Если ДокументВводаВЭксплуатациюБУ = Неопределено Тогда
		ДокументВводаВЭксплуатациюБУПредставление = НСтр("ru='Ввести документ ввода в эксплуатацию';uk='Ввести документ введення в експлуатацію'");
		ВведеноВЭксплуатациюБУ = '00010101';
		ВведеноВЭксплуатациюНУ = '00010101';
	Иначе
		ДокументВводаВЭксплуатациюБУПредставление = Строка(ДокументВводаВЭксплуатациюБУ);
		ИмяТипаДокументаВводаВЭксплуатацию = ДокументВводаВЭксплуатациюБУ.Метаданные().Имя;
	КонецЕсли;

	ДокументВводаВЭксплуатациюНУПредставление = ДокументВводаВЭксплуатациюБУПредставление;
	
	Если ДокументСнятияСУчетаБУ = Неопределено Тогда
		ДокументСнятияСУчетаБУПредставление = НСтр("ru='Ввести документ списания';uk='Ввести документ списання'");
		СнятоСУчетаБУ = '00010101';
		СнятоСУчетаНУ = '00010101';
	Иначе
		ДокументСнятияСУчетаБУПредставление = Строка(ДокументСнятияСУчетаБУ);
		ИмяТипаДокументаСнятияСУчета = ДокументСнятияСУчетаБУ.Метаданные().Имя;
	КонецЕсли;
	
	ДокументСнятияСУчетаНУПредставление = ДокументСнятияСУчетаБУПредставление;

КонецПроцедуры

// Процедура проверяет, совпадало ли ранее полное наименование с наименованием,
// и присваивает соответствующее значение переменной мФормироватьНаименованиеПолноеАвтоматически.
//
// Параметры:
//  Нет.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Форма)

	Если ПустаяСтрока(Форма.Объект.НаименованиеПолное)
	 ИЛИ Форма.Объект.НаименованиеПолное = Форма.Объект.Наименование Тогда
		Форма.ФормироватьНаименованиеПолноеАвтоматически = Истина;
	Иначе
		Форма.ФормироватьНаименованиеПолноеАвтоматически = Ложь;
	КонецЕсли;

КонецПроцедуры

// Процедура проверяет, необходимо ли формировать полное наименование автоматически или нет,
// и, если необходимо, формирует его.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если ФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru='Данные еще не записаны."
"Ввод документа ввода в эксплуатацию возможен только после записи."
"Данные будут записаны.';uk='Дані ще не записані."
"Введення документа введення в експлуатацію можливе лише після запису."
"Дані будуть записані.'");
		Оповещение = Новый ОписаниеОповещения("ВопросВводВводаВЭксплуатациюПослеЗаписиЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ОткрытьФормуВводаВЭксплуатациюОС();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросВводВводаВЭксплуатациюПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если Записать() Тогда // Записать новый объект, чтобы его можно было поместить в документ
			ОткрытьФормуВводаВЭксплуатациюОС();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВводаВЭксплуатациюОС()
	
	ПараметрыОткрытия = Новый Структура;
	Если ДокументВводаВЭксплуатациюБУ = Неопределено Тогда
		ПараметрыОткрытия.Вставить("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ВводВЭксплуатациюОС.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	Иначе
		ПараметрыОткрытия.Вставить("Ключ", ДокументВводаВЭксплуатациюБУ);
		ОткрытьФорму("Документ." + ИмяТипаДокументаВводаВЭксплуатацию + ".ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	КонецЕсли;

	ОбновитьСведения();

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru='Данные еще не записаны."
"Ввод документа снятия с учета возможен только после записи."
"Данные будут записаны.';uk='Дані ще не записані."
"Введення документа зняття з обліку можливе тільки після запису."
"Дані будуть записані.'");
			
		Оповещение = Новый ОписаниеОповещения("ВопросВводСнятиеСУчетаОСПослеЗаписиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ОткрытьФормуСписаниеОС();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросВводСнятиеСУчетаОСПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если Записать() Тогда
			ОткрытьФормуСписаниеОС();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСписаниеОС()
	
	ПараметрыФормы = Новый Структура;
	Если ДокументСнятияСУчетаБУ = Неопределено Тогда
		ПараметрыФормы.Вставить("Основание", Объект.Ссылка);
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ПодразделениеОрганизации", ПодразделениеБУ);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураПараметров);
		ОткрытьФорму("Документ.СписаниеОС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы.Вставить("Ключ", ДокументСнятияСУчетаБУ);
		ОткрытьФорму("Документ." + ИмяТипаДокументаСнятияСУчета +".ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

	ОбновитьСведения();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, , СтандартнаяОбработка);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтаФорма, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтаФорма, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтаФорма, Объект, Результат);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДатаСведенийПриИзменении(Элемент)

	ОбновитьСведения();

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставлениеНажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление1Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление2Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление3Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставлениеНажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставление1Нажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставление2Нажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	СформироватьНаименованиеПолноеАвтоматически();

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)

	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)

	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ВыполнитьИнициализацию();	
		ЗаполнитьОписания();
		ФормироватьНаименованиеПолноеАвтоматически = Истина;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

	// Обработчик подсистемы "Контактная информация"
	ТаблицаРазмещенияКИ	= УправлениеКонтактнойИнформациейБП.ПолучитьПустуюТаблицуРазмещенияКонтактнойИнформации();
	
	УправлениеКонтактнойИнформациейБП.ДобавитьОписаниеРазмещенияКонтактнойИнформации(ТаблицаРазмещенияКИ,
			Справочники.ВидыКонтактнойИнформации.АдресМестонахожденияОсновныеСредства, Элементы.АдресМестонахождения.ПутьКДанным);
			
	УправлениеКонтактнойИнформациейБП.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаАдресМестонахождения", "", ТаблицаРазмещенияКИ);

	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаДополнительныеРеквизиты");

	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ВыполнитьИнициализацию();

	ЗаполнитьОписания();

	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);

	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененаИнформацияОС" И Параметр = Параметры.Ключ Тогда
		
		ОбновитьСведения();
		
	КонецЕсли;

	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка", Объект.Ссылка);
	
	Оповестить("ИзмененОбъектОС", ПараметрОповещения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);

КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);

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
	
	ОписаниеКоманды = УправлениеПечатьюКлиентПовтИсп.ОписаниеКомандыПечати(Команда.Имя, ЭтаФорма.Команды.Найти("АдресКомандПечатиВоВременномХранилище").Действие);
	ОписаниеКоманды.Вставить("ДатаСведений", ДатаСведений);
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ОписаниеКоманды, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура АдресМестонахожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры
