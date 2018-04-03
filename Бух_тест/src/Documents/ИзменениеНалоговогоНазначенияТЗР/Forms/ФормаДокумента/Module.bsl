#Область ОбработчикиСобытийФормы

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
	
	// Уведомим о появлении функционала рабочей даты
	ЭтаФорма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента = ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента
	И ЭтаФорма.Параметры.Ключ.Пустая()
	И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
	
	// Заполнение группы информационных ссылок
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, ЭтаФорма.Элементы.ИнформационныеСсылки);
	
	Элементы.ВсегоМетодКорректировкиНДС1.Заголовок = ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства");
	Элементы.ВсегоМетодКорректировкиНДС2.Заголовок = ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НаНалоговыйКредит");
	
	МетодыКорректировки_ВосстановлениеПраваНаНК.Добавить(Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства);
	МетодыКорректировки_ВосстановлениеПраваНаНК.Добавить(Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыйКредит);
	МетодыКорректировки_ВосстановлениеПраваНаНК.Добавить(Перечисления.МетодыКорректировкиНалоговогоКредита.НеКорректировать);
	
	МетодыКорректировки_ПотеряПраваНаНК.Добавить(Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства);
	МетодыКорректировки_ПотеряПраваНаНК.Добавить(Перечисления.МетодыКорректировкиНалоговогоКредита.НеКорректировать);
	
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры // ПриСозданииНаСервере

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры // ПриЧтенииНаСервере

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры // ПослеЗаписиНаСервере

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

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

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТаблицыФормыЗатраты

&НаКлиенте
Процедура ЗатратыМетодКорректировкиНалоговогоКредитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.ВидКорректировкиНДС = ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит") Тогда
		
		ДанныеВыбора = МетодыКорректировки_ВосстановлениеПраваНаНК;
		
	ИначеЕсли СтрокаТабличнойЧасти.ВидКорректировкиНДС = ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит") Тогда
		
		ДанныеВыбора = МетодыКорректировки_ПотеряПраваНаНК;
		
	Иначе
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НеКорректировать"));
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыНалоговоеНазначениеПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;
	
	//определим Допустимые методы корректировок налогового кредита
	СтрокаТабличнойЧасти.ВидКорректировкиНДС = ОпределитьВидКорректировкиНК(Новый Структура("НалоговоеНазначение,НалоговоеНазначениеНовое",СтрокаТабличнойЧасти.НалоговоеНазначение,СтрокаТабличнойЧасти.НалоговоеНазначениеНовое));
	Если СтрокаТабличнойЧасти.ВидКорректировкиНДС = ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит") Тогда
		ДопустимыеМетодыКорректировки = МетодыКорректировки_ВосстановлениеПраваНаНК;
	ИначеЕсли СтрокаТабличнойЧасти.ВидКорректировкиНДС = ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит") Тогда
		ДопустимыеМетодыКорректировки = МетодыКорректировки_ПотеряПраваНаНК;
	Иначе
		ДопустимыеМетодыКорректировки = Новый СписокЗначений();
	КонецЕсли;
	
	//Очистим метод корректировки в строке при необходимости
	Если ДопустимыеМетодыКорректировки.НайтиПоЗначению(СтрокаТабличнойЧасти.МетодКорректировкиНалоговогоКредита) = Неопределено Тогда
		Если ДопустимыеМетодыКорректировки.Количество() = 0 Тогда
			СтрокаТабличнойЧасти.МетодКорректировкиНалоговогоКредита = ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НеКорректировать");		
		Иначе
			СтрокаТабличнойЧасти.МетодКорректировкиНалоговогоКредита = ДопустимыеМетодыКорректировки[0].Значение;
		КонецЕсли;
	КонецЕсли; 
	
	РассчитатьСуммуНДСВСтроке(СтрокаТабличнойЧасти);
	
	ОбновитьИтоги(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыНалоговоеНазначениеНовоеПриИзменении(Элемент)
	ЗатратыНалоговоеНазначениеПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСуммаНДСПриИзменении(Элемент)
	ПересчитатьСуммыПоСтрокеЗатрат()
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСтавкаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;

	РассчитатьСуммуНДСВСтроке(СтрокаТабличнойЧасти);
	ОбновитьИтоги(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыМетодКорректировкиНалоговогоКредитаПриИзменении(Элемент)
	ОбновитьИтоги(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;

	РассчитатьСуммуНДСВСтроке(СтрокаТабличнойЧасти);
	ОбновитьИтоги(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыНалоговоеНазначениеДоходовИЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;
	
	ГруппаНН = ПолучитьГруппуНалоговогоНазначенияПоСчетуЗатрат(СтрокаТабличнойЧасти.СчетЗатрат,Объект.Дата);
	
	НовыйМассивПараметров = Новый Массив();
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ГруппаНалоговогоНазначения", ГруппаНН));
	НовыеПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	Элемент.ПараметрыВыбора = НовыеПараметрыВыбора;

КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСчетЗатратПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;
	
	ЗаполнитьДобавленныеКолонкиСтрокиТаблицыЗатраты(СтрокаТабличнойЧасти);
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТабличнойЧасти.СчетЗатрат, "", Истина, Истина);

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1", "Субконто2", "Субконто3");
	ПоляОбъекта.Вставить("Организация"  , Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(СтрокаТабличнойЧасти.СчетЗатрат, СтрокаТабличнойЧасти, ПоляОбъекта, Истина);

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
	ПроверитьННВСтроке(СтрокаТабличнойЧасти);															
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;

	ПараметрыДокумента = ПолучитьСписокПараметров(ЭтаФорма, СтрокаТабличнойЧасти, "Субконто%Индекс%");
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТабличнойЧасти.СчетЗатрат);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);

КонецПроцедуры

&НаКлиенте
Процедура ЗатратыСубконтоПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЗатратыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТабличнойЧасти.СчетЗатрат, "", Истина, Истина);

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение( , НСтр("ru='Документ может быть заполнен только после записи в базу! ';uk='Документ може бути заповнений тільки після запису в базу! '"), 60);
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли;
	
	Если Объект.Затраты.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='При заполнении существующие данные будут очищены.!"
"Продолжить?';uk='При заповненні існуючі дані будуть очищені.!"
"Продовжити?'");
			
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьДляСпискаЗатратЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ЗаполнитьДляСпискаЗатратСервер();
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

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента	= Объект.Дата;
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	ОбновитьИтоги(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры // ПодготовитьФормуНаСервере

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ЕстьНалогНаПрибыльДо2015    = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);
	
КонецПроцедуры // УстановитьФункциональныеОпцииФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы     = Форма.Элементы;
	ОбъектФормы  = Форма.Объект;
	
	//НастроитьСубконтоПриПодготовкеФормыНаСервере(Форма);
	
КонецПроцедуры // УправлениеФормой

&НаКлиенте
Процедура ПересчитатьСуммыПоСтрокеЗатрат()

	СтрокаТабличнойЧасти = Элементы.Затраты.ТекущиеДанные;
	
	РассчитатьСуммуНДСВСтроке(СтрокаТабличнойЧасти);
	ЗаполнитьДобавленныеКолонкиСтрокиТаблицыЗатраты(СтрокаТабличнойЧасти);
	
	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры
 
// Процедура определяет возможный вид корректировки налогового кредита, по переданным данным
//
// Параметры
//  Данные  – Строка табличной части, структура, строка таблицы. Должна содержать реквизиты (колонки):
//  			НалоговоеНазначение, НалоговоеНазначениеНовое
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыКорректировокНалоговогоКредита  - вид корректировки. Если неопределен - пустая ссылка.
//
&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьВидКорректировкиНК(Данные) Экспорт
	
	Если    НЕ ЗначениеЗаполнено(Данные.НалоговоеНазначение)
		ИЛИ НЕ ЗначениеЗаполнено(Данные.НалоговоеНазначениеНовое) Тогда 
		
		Возврат  ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ПустаяСсылка");
		
	КонецЕсли; 
	
	НалоговыйКредитВход  = Данные.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально") ИЛИ УчетНДСВызовСервераПовтИсп.ЕстьПравоНаНалоговыйКредит(Данные.НалоговоеНазначение);
	НалоговыйКредитВыход = Данные.НалоговоеНазначениеНовое = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально") ИЛИ УчетНДСВызовСервераПовтИсп.ЕстьПравоНаНалоговыйКредит(Данные.НалоговоеНазначениеНовое);
	
	Если НалоговыйКредитВход = НалоговыйКредитВыход Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.НетКорректировок");
		
	ИначеЕсли НалоговыйКредитВход И НЕ НалоговыйКредитВыход Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит");
		
	Иначе
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит");
		
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	// При изменении данных обновим суммы в подвале.
	Форма.ВсегоМетодКорректировкиНДС1 = 0;
	Форма.ВсегоМетодКорректировкиНДС2 = 0;
	Для  каждого СтрокаТЧ Из Форма.Объект.Затраты Цикл
		Если СтрокаТЧ.МетодКорректировкиНалоговогоКредита = ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства") Тогда
			Форма.ВсегоМетодКорректировкиНДС1 = Форма.ВсегоМетодКорректировкиНДС1 + СтрокаТЧ.СуммаНДС;	
		ИначеЕсли СтрокаТЧ.МетодКорректировкиНалоговогоКредита = ПредопределенноеЗначение("Перечисление.МетодыКорректировкиНалоговогоКредита.НаНалоговыйКредит") Тогда
			Форма.ВсегоМетодКорректировкиНДС2 = Форма.ВсегоМетодКорректировкиНДС2 + СтрокаТЧ.СуммаНДС;	
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры // ОбновитьИтоги

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДанныеОбъекта(Форма)
	
	ДанныеОбъекта	= Новый Структура(
	"Дата, Организация, Ответственный,  
	|СчетУчетаНДС_НО, СчетУчетаКорректировкиНДСКредит,
	|ВалютаРегламентированногоУчета, ЕстьНалогНаПрибыльДо2015");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Форма.Объект);
	ДанныеОбъекта.ВалютаРегламентированногоУчета = Форма.ВалютаРегламентированногоУчета;
	ДанныеОбъекта.ЕстьНалогНаПрибыльДо2015       = Форма.ЕстьНалогНаПрибыльДо2015;
	
	Возврат ДанныеОбъекта;
	
КонецФункции // ПолучитьДанныеОбъекта()

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДанныеСтрокиТаблицы(СтрокаТабличнойЧасти)
	
	ДанныеСтрокиТаблицы	= Новый Структура(
	"СчетТЗР, НоменклатурнаяГруппа,
	|НалоговоеНазначение, НалоговоеНазначениеНовое, МетодКорректировкиНалоговогоКредита, 
	|СчетЗатрат, Субконто1, Субконто2, Субконто3,
	|СуммаНДС,СтавкаНДС,Сумма,
	|ВидКорректировкиНДС, НалоговоеНазначениеДоходовИЗатрат,
	|Субконто1Доступность,Субконто2Доступность,Субконто3Доступность");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	Возврат ДанныеСтрокиТаблицы;
	
КонецФункции // ПолучитьДанныеСтрокиТаблицы()

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммуНДСВСтроке(СтрокаТЧ)
	
	СтрокаТЧ.СтавкаНДС = ?(СтрокаТЧ.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС7"),СтрокаТЧ.СтавкаНДС,ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20"));
	
	Если УчетНДСВызовСервераПовтИсп.ЕстьПравоНаНалоговыйКредит(СтрокаТЧ.НалоговоеНазначение) Тогда
		//сумма не включет НДС                                                                         
		СтрокаТЧ.СуммаНДС = СтрокаТЧ.Сумма* УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТЧ.СтавкаНДС) / 100;	
	Иначе
		//сумма включет НДС                                                                             
		СтрокаТЧ.СуммаНДС = СтрокаТЧ.Сумма * УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТЧ.СтавкаНДС) /(УчетНДС.ПолучитьСтавкуНДС(СтрокаТЧ.СтавкаНДС) + 100);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьННВСтроке(СтрокаТабличнойЧасти)
	СтрокаТЧ = Элементы.Затраты.ТекущиеДанные;
	ДанныеСтрокиТаблицы	= ПолучитьДанныеСтрокиТаблицы(СтрокаТЧ);
	
	ПроверитьННВСтрокеНаСервере(ДанныеСтрокиТаблицы,Объект.Дата);
	
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, ДанныеСтрокиТаблицы);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьННВСтрокеНаСервере(СтрокаТабличнойЧасти,ДатаДокумента)
	
	ГруппаНН = ПолучитьГруппуНалоговогоНазначенияПоСчетуЗатрат(СтрокаТабличнойЧасти.СчетЗатрат,ДатаДокумента);
	
	Если СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат.ГруппаНалоговогоНазначения <>  ГруппаНН Тогда
		СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Получить группу налогового назначения по счету
//
// Параметры:
//  СчетЗатрат  - ПланСчетовСсылка.Хозрасчетный - счет, для которого определить группу затрат
//  Дата  - Дата - дата, на которую определить группу
//
// Возвращаемое значение:
//   Перечисление.ГруппыНалоговыхНазначений
//
&НаСервереБезКонтекста
Функция ПолучитьГруппуНалоговогоНазначенияПоСчетуЗатрат(СчетЗатрат,Дата)

	Если УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(СчетЗатрат, ,Дата) = "ОПЗ" Тогда
		ГруппаНН = ПредопределенноеЗначение("Перечисление.ГруппыНалоговыхНазначений.НалоговыеНазначенияАктивовИВзаиморасчетовПоНДС");
	Иначе
		ГруппаНН = ПредопределенноеЗначение("Перечисление.ГруппыНалоговыхНазначений.НалоговыеНазначенияДоходовИЗатрат");
	КонецЕсли;

	Возврат ГруппаНН;
	
КонецФункции // ПолучитьГруппуНалоговогоНазначеняПоСчетуЗатрат()

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет, Постфикс = "", ЕстьПодразделение, ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
								"ЗатратыСубконто" + Постфикс + "1",
								"ЗатратыСубконто" + Постфикс + "2",
								"ЗатратыСубконто" + Постфикс + "3");

	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, Неопределено, ЭтоТаблица);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма)

	СтрокаТабличнойЧасти = Форма.Объект.Затраты.НайтиПоИдентификатору(Форма.Элементы.Затраты.ТекущаяСтрока);
	ПараметрыДокумента = ПолучитьСписокПараметров(Форма, СтрокаТабличнойЧасти, "Субконто%Индекс%");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, СтрокаТабличнойЧасти, "Субконто%Индекс%", "ЗатратыСубконто%Индекс%", ПараметрыДокумента);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметров(Форма, Объект, ШаблонИмяПоляОбъекта)
	
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
	СписокПараметров.Вставить("Организация",    Форма.Объект.Организация);
	СписокПараметров.Вставить("СчетУчета",      Объект.СчетЗатрат);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура ВопросЗаполнитьДляСпискаЗатратЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Затраты.Очистить();
		ЗаполнитьДляСпискаЗатратСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляСпискаЗатратСервер()

	Если НЕ УчетнаяПолитика.Существует(Объект.Организация, Объект.Дата) Тогда
		ТекстСообщения = НСтр("ru='Не задана учетная политика организации %1 на %2.';uk='Не задана облікова політика організації %1 на %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, Объект.Организация, Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(Корректировки.СуммаОборот) КАК Сумма,
	               |	Корректировки.СчетТЗР,
	               |	Корректировки.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	               |	Корректировки.НалоговоеНазначение КАК НалоговоеНазначение,
	               |	Корректировки.НалоговоеНазначениеНовое КАК НалоговоеНазначениеНовое,
	               |	Корректировки.СчетЗатрат КАК СчетЗатрат,
	               |	Корректировки.Субконто1,
	               |	Корректировки.Субконто2,
	               |	Корректировки.Субконто3,
	               |	Корректировки.НалоговоеНазначениеДоходовИЗатрат
	               |ИЗ
	               |	РегистрНакопления.КорректировкиНалоговыхНазначенийТЗР.Обороты(&НачалоМесяца, &КонецМесяца, , Организация = &Организация) КАК Корректировки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Корректировки.СчетЗатрат,
	               |	Корректировки.НоменклатурнаяГруппа,
	               |	Корректировки.НалоговоеНазначение,
	               |	Корректировки.НалоговоеНазначениеНовое,
	               |	Корректировки.Субконто1,
	               |	Корректировки.Субконто3,
	               |	Корректировки.НалоговоеНазначениеДоходовИЗатрат,
	               |	Корректировки.СчетТЗР,
	               |	Корректировки.Субконто2";
	
	Запрос.УстановитьПараметр("НачалоМесяца", 		НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 		Новый Граница(КонецМесяца(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", 		Объект.Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Строка = Объект.Затраты.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Выборка); 
		
		РассчитатьСуммуНДСВСтроке(Строка);
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицыЗатраты(Строка);
		
		ВидКорректировкиНДС = ОпределитьВидКорректировкиНК(Строка);
		Если Строка.ВидКорректировкиНДС = Перечисления.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит Тогда
			Строка.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыйКредит;
		ИначеЕсли Строка.ВидКорректировкиНДС = Перечисления.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит Тогда
			Строка.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства;
		Иначе
			Строка.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НеКорректировать;
		КонецЕсли;
		
	КонецЦикла;

	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Затраты Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицыЗатраты(СтрокаТабличнойЧасти);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицыЗатраты(СтрокаТабличнойЧасти)

	СвойстваСчетаЗатрат		= БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетЗатрат);
	
 	Для Индекс = 1 По 3 Цикл
		СтрокаТабличнойЧасти["Субконто"   + Индекс + "Доступность"] = (Индекс <= СвойстваСчетаЗатрат.КоличествоСубконто);
	КонецЦикла;
	СтрокаТабличнойЧасти.ВидКорректировкиНДС  =  ОпределитьВидКорректировкиНК(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти
