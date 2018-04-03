#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаВажныеКоманды);
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

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.СпецификацииНоменклатуры.Форма.ФормаВыбора" Тогда
		ЗаполнитьКомплектующие(ВыбранноеЗначение);
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
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФорм

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.ВидОперации = ТекущийВидОперации Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
	ТекущийВидОперации = Объект.ВидОперации;
	
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
Процедура НоменклатураПриИзменении(Элемент)

	ДанныеОбъекта = ДанныеОбъекта();
	НоменклатураПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект,ДанныеОбъекта,"ЕдиницаИзмерения,Коэффициент,СчетУчетаБУ,НалоговоеНазначение");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НоменклатураПриИзмененииНаСервере(ДанныеОбъекта)
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		ДанныеОбъекта.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта.ЕдиницаИзмерения    = СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	ДанныеОбъекта.Коэффициент	      = СведенияОНоменклатуре.Коэффициент;
	ДанныеОбъекта.СчетУчетаБУ         = СведенияОНоменклатуре.СчетаУчета.СчетУчетаБУ;
	ДанныеОбъекта.НалоговоеНазначение = СведенияОНоменклатуре.СчетаУчета.НалоговоеНазначение;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТабличнойЧасти 

&НаКлиенте
Процедура КомплектующиеНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Комплектующие.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = ДанныеСтрокиТабличнойЧасти(ТекущиеДанные);
	ДанныеОбъекта = ДанныеОбъекта();
	
	КомплектующиеНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)

	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не указана номенклатура комплекта! Заполнение невозможно.';uk='Не зазначена номенклатура комплекту! Заповнення неможливо.'"));
		Возврат;
	ИначеЕсли Объект.Количество = 0 Тогда
		ТекстПредупреждения = НСтр("ru='Количество %Номенклатура% равно нулю! Заполнение невозможно.';uk='Кількість %Номенклатура% дорівнює нулю! Заповнення неможливе.'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Номенклатура%", СокрЛП(Объект.Номенклатура));
		ПоказатьПредупреждение( , ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Объект.Комплектующие.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
	Иначе
		ОткрытьФормуВыбораСпецификации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКомплектующие(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("Комплектующие");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти 

#Область СлужебныеПроцедурыИФункцииБСП

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

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции 

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущийВидОперации = Объект.ВидОперации;
	
	ТекущаяДатаДокумента	= Объект.Дата;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "ТипСклада");
	
	УправлениеВидимостью();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНДС			= УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.НалоговоеНазначение.Видимость = Форма.ПлательщикНДС;

КонецПроцедуры

&НаСервере
Функция ВидОперацииПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УправлениеВидимостью();
	
КонецФункции

&НаСервере
Функция ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УправлениеВидимостью();
	
	УправлениеФормой(ЭтаФорма);

КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()


КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Комплектующие" Тогда
		Документы.КомплектацияНоменклатуры.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Комплектующие");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура КомплектующиеНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Коэффициент			= СведенияОНоменклатуре.Коэффициент;
	
	Документы.КомплектацияНоменклатуры.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Комплектующие", СведенияОНоменклатуре);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;

	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'");

	ПредставлениеТаблицы = НСтр("ru='Комплектующие';uk='Комплектуючі'");

	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);

	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);

	ПараметрыФормы.Вставить("ДатаРасчетов", ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"      , ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("Организация" , Объект.Организация);
	ПараметрыФормы.Вставить("Склад"       , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"   , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"  , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"  , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"      , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ЕстьКоличество",Истина);

	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)

	ВидПодбора = "";

	Если ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		ВидПодбора = "НТТ";
	КонецЕсли;

	Возврат ВидПодбора;

КонецФункции


&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтруктураОтбора = Новый Структура("Номенклатура, ЕдиницаИзмерения", СтрокаТовара.Номенклатура, СтрокаТовара.ЕдиницаИзмерения);
		СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти("Комплектующие", СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - увеличиваем количество.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
		Иначе
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара);
			
			СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
			Если СведенияОНоменклатуре = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Документы.КомплектацияНоменклатуры.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
				ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СведенияОНоменклатуре);
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКомплектующие(Спецификация)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Спецификация",			Спецификация);
	Запрос.УстановитьПараметр("КоличествоКомплектов",	Объект.Количество);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Номенклатура,
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Количество,
	|	1 КАК ДоляСтоимости,
	|	ВЫБОР
	|		КОГДА СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ СпецификацииНоменклатурыИсходныеКомплектующие.Количество * &КоличествоКомплектов / СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка.Количество
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацииНоменклатурыИсходныеКомплектующие
	|ГДЕ
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка = &Спецификация";
	
	ТаблицаКомплектующих = Запрос.Выполнить().Выгрузить();
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре	= БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаКомплектующих, "Номенклатура", Истина), ДанныеОбъекта);

	Если Объект.Комплектующие.Количество() > 0 Тогда
		Объект.Комплектующие.Очистить();
	КонецЕсли;
	
	Для Каждого СтрокаКомплектующих Из ТаблицаКомплектующих Цикл
		
		СтрокаТабличнойЧасти = Объект.Комплектующие.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаКомплектующих);
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаКомплектующих.Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
		СтрокаТабличнойЧасти.Коэффициент			= СведенияОНоменклатуре.Коэффициент;
		
		Документы.КомплектацияНоменклатуры.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта, СтрокаТабличнойЧасти, "Комплектующие", СведенияОНоменклатуре);
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОткрытьФормуВыбораСпецификации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораСпецификации()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Владелец", Объект.Номенклатура);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Справочник.СпецификацииНоменклатуры.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти = Неопределено)

	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = Элементы.Комплектующие.ТекущиеДанные;
	КонецЕсли; 
	
	ПараметрыСтроки = Новый Структура("Номенклатура, ЕдиницаИзмерения, Количество, Коэффициент,
	|ДоляСтоимости, СчетУчетаБУ, Сумма");
	
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, СтрокаТабличнойЧасти);
	
	Возврат ПараметрыСтроки;

КонецФункции

&НаКлиенте
Функция ДанныеОбъекта()
	
	ДанныеОбъекта = Новый Структура(
		"Дата,ВидОперации,Организация,Склад,
		|Номенклатура,ЕдиницаИзмерения,Количество,Коэффициент,
		|СчетУчетаБУ,СуммаДокумента,НалоговоеНазначение");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	Возврат ДанныеОбъекта;
	
КонецФункции

&НаКлиенте
Процедура КомплектующиеЕдиницаИзмеренияПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Комплектующие.ТекущиеДанные;
	ПараметрыСтрокиТабличнойЧасти = ДанныеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);

	ЕдиницаИзмеренияПриИзмененииНаСервере(ПараметрыСтрокиТабличнойЧасти);
	
	СтрокаТабличнойЧасти.Коэффициент = ПараметрыСтрокиТабличнойЧасти.Коэффициент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЕдиницаИзмеренияПриИзмененииНаСервере(ПараметрыСтроки)
	
	ОбработкаТабличныхЧастей.ЗаполнитьКоэффициентТабЧасти(ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	ДанныеОбъекта = ДанныеОбъекта();
	ЕдиницаИзмеренияПриИзмененииНаСервере(ДанныеОбъекта);
	
	Объект.Коэффициент = ДанныеОбъекта.Коэффициент;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(ИмяТабличнойЧасти, СтруктураОтбора)

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

#КонецОбласти
