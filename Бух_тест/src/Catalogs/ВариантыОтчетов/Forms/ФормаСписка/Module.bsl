
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВключаяПодчиненные = Истина;
	
	ДеревоЗначений = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоПодсистем");
	
	ДеревоПодсистемТекущаяСтрока = -1;
	Элементы.ДеревоПодсистем.ТекущаяСтрока = 0;
	Если Параметры.РежимВыбора = Истина Тогда
		РежимРаботыФормы = "Выбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ИначеЕсли Параметры.Свойство("РазделСсылка") Или Параметры.Свойство("РазделСсылка") Тогда
		РежимРаботыФормы = "ВсеОтчетыРаздела";
		МассивОбхода = Новый Массив;
		МассивОбхода.Добавить(ДеревоПодсистем.ПолучитьЭлементы()[0]);
		Пока МассивОбхода.Количество() > 0 Цикл
			СтрокиРодителя = МассивОбхода[0].ПолучитьЭлементы();
			МассивОбхода.Удалить(0);
			Для Каждого СтрокаДерева Из СтрокиРодителя Цикл
				Если СтрокаДерева.Ссылка = Параметры.РазделСсылка Тогда
					Элементы.ДеревоПодсистем.ТекущаяСтрока = СтрокаДерева.ПолучитьИдентификатор();
					МассивОбхода.Очистить();
					Прервать;
				Иначе
					МассивОбхода.Добавить(СтрокаДерева);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		РежимРаботыФормы = "Список";
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Изменить",
			"Отображение",
			ОтображениеКнопки.КартинкаИТекст);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"РазместитьВРазделах",
			"ТолькоВоВсехДействиях",
			Ложь);
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = РежимРаботыФормы;
	КлючНазначенияИспользования = РежимРаботыФормы;
	
	УстановитьСвойствоСпискаПоПараметруФормы("РежимВыбора");
	УстановитьСвойствоСпискаПоПараметруФормы("ВыборГруппИЭлементов");
	УстановитьСвойствоСпискаПоПараметруФормы("МножественныйВыбор");
	УстановитьСвойствоСпискаПоПараметруФормы("ТекущаяСтрока");
	
	Если Параметры.РежимВыбора Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Выбрать",
			"КнопкаПоУмолчанию",
			Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Выбрать",
			"Видимость",
			Ложь);
	КонецЕсли;
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	Если Не ПолныеПраваНаВарианты Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОтборТипОтчета",
			"Видимость",
			Ложь);
	КонецЕсли;
	
	СписокВыбора = Элементы.ОтборТипОтчета.СписокВыбора;
	СписокВыбора.Добавить(1, НСтр("ru='Внутренние и Дополнительные';uk='Внутрішні й Додаткові'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Внутренний, НСтр("ru='Внутренние';uk='Внутрішні'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Дополнительный, НСтр("ru='Дополнительные';uk='Додаткові'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Внешний, НСтр("ru='Внешние';uk='Зовнішні'"));
	
	Параметры.Свойство("СтрокаПоиска", СтрокаПоиска);
	Если Параметры.Отбор.Свойство("ТипОтчета", ОтборТипОтчета) Тогда
		Параметры.Отбор.Удалить("ТипОтчета");
	КонецЕсли;
	Если Параметры.Свойство("ТолькоВарианты") Тогда
		Если Параметры.ТолькоВарианты Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"КлючВарианта",
				"",
				ВидСравненияКомпоновкиДанных.НеРавно,
				,
				,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
		КонецЕсли;
	КонецЕсли;
	
	ПерсональныеНастройкиСписка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"Справочник.ВариантыОтчетов.ФормаСписка");
	Если ПерсональныеНастройкиСписка <> Неопределено Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ПерсональныеНастройкиСписка.СтрокаПоискаСписокВыбора);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТипВнутренний",     Перечисления.ТипыОтчетов.Внутренний);
	Список.Параметры.УстановитьЗначениеПараметра("ТипДополнительный", Перечисления.ТипыОтчетов.Дополнительный);
	Список.Параметры.УстановитьЗначениеПараметра("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	
	ТекущийЭлемент = Элементы.Список;
	
	// Пользовательский отбор по пометке удаления.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбновитьСодержимоеСписка("ПриСозданииНаСервере");
	
	ОбщегоНазначенияКлиентСервер.ПеренестиОтборыВДинамическийСписок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если РежимРаботыФормы = "ВсеОтчетыРаздела" ИЛИ РежимРаботыФормы = "Выбор" Тогда
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистемТекущаяСтрока, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта() Тогда
		ДеревоПодсистемТекущаяСтрока = -1;
		ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборТипОтчетаПриИзменении(Элемент)
	ОбновитьСодержимоеСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипОтчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОтборТипОтчета = Неопределено;
	ОбновитьСодержимоеСписка();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	ОбновитьСодержимоеСписка("СтрокаПоискаПриИзменении");
КонецПроцедуры

&НаКлиенте
Процедура ВключаяПодчиненныеПриИзменении(Элемент)
	ДеревоПодсистемТекущаяСтрока = -1;
	ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	ОбновитьСодержимоеСписка();
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРазмещения = Новый Структура("Варианты, Действие, Приемник, Источник"); //МассивВариантов, Всего, Представление
	ПараметрыРазмещения.Варианты = Новый Структура("Массив, Всего, Представление");
	ПараметрыРазмещения.Варианты.Массив = ПараметрыПеретаскивания.Значение;
	ПараметрыРазмещения.Варианты.Всего  = ПараметрыПеретаскивания.Значение.Количество();
	
	Если ПараметрыРазмещения.Варианты.Всего = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПриемник = ДеревоПодсистем.НайтиПоИдентификатору(Строка);
	Если СтрокаПриемник = Неопределено ИЛИ СтрокаПриемник.Приоритет = "" Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРазмещения.Приемник = Новый Структура("Ссылка, ПолноеПредставление");
	ЗаполнитьЗначенияСвойств(ПараметрыРазмещения.Приемник, СтрокаПриемник);
	
	СтрокаИсточник = Элементы.ДеревоПодсистем.ТекущиеДанные;
	ПараметрыРазмещения.Источник = Новый Структура("Ссылка, ПолноеПредставление");
	Если СтрокаИсточник = Неопределено ИЛИ СтрокаИсточник.Приоритет = "" Тогда
		ПараметрыРазмещения.Действие = "Копирование";
	Иначе
		ЗаполнитьЗначенияСвойств(ПараметрыРазмещения.Источник, СтрокаИсточник);
		Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
			ПараметрыРазмещения.Действие = "Копирование";
		Иначе
			ПараметрыРазмещения.Действие = "Перемещение";
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыРазмещения.Источник.Ссылка = ПараметрыРазмещения.Приемник.Ссылка Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выбранные варианты отчетов уже в данном разделе.';uk='Обрані варіанти звітів уже в даному розділі.'"));
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРазмещения.Варианты.Всего = 1 Тогда
		Если ПараметрыРазмещения.Действие = "Копирование" Тогда
			ШаблонВопроса = НСтр("ru='Разместить ""%1"" в ""%4""?';uk='Розмістити ""%1"" в ""%4""?'");
		Иначе
			ШаблонВопроса = НСтр("ru='Переместить ""%1"" из ""%3"" в ""%4""?';uk='Перемістити ""%1"" з ""%3"" в ""%4""?'");
		КонецЕсли;
		ПараметрыРазмещения.Варианты.Представление = Строка(ПараметрыРазмещения.Варианты.Массив[0]);
	Иначе
		ПараметрыРазмещения.Варианты.Представление = "";
		Для Каждого ВариантСсылка Из ПараметрыРазмещения.Варианты.Массив Цикл
			ПараметрыРазмещения.Варианты.Представление = ПараметрыРазмещения.Варианты.Представление
			+ ?(ПараметрыРазмещения.Варианты.Представление = "", "", ", ")
			+ Строка(ВариантСсылка);
			Если СтрДлина(ПараметрыРазмещения.Варианты.Представление) > 23 Тогда
				ПараметрыРазмещения.Варианты.Представление = Лев(ПараметрыРазмещения.Варианты.Представление, 20) + "...";
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПараметрыРазмещения.Действие = "Копирование" Тогда
			ШаблонВопроса = НСтр("ru='Разместить варианты отчетов ""%1"" (%2 шт.) в ""%4""?';uk='Розмістити варіанти звітів ""%1"" (%2 шт.) в ""%4""?'");
		Иначе
			ШаблонВопроса = НСтр("ru='Переместить варианты отчетов ""%1"" (%2 шт.) из ""%3"" в ""%4""?';uk='Перемістити варіанти звітів ""%1"" (%2 шт.) з ""%3"" в ""%4""?'");
		КонецЕсли;
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонВопроса,
		ПараметрыРазмещения.Варианты.Представление,
		Формат(ПараметрыРазмещения.Варианты.Всего, "ЧГ=0"),
		ПараметрыРазмещения.Источник.ПолноеПредставление,
		ПараметрыРазмещения.Приемник.ПолноеПредставление
	);
	
	Обработчик = Новый ОписаниеОповещения("ДеревоПодсистемПеретаскиваниеЗавершение", ЭтотОбъект, ПараметрыРазмещения);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимРаботыФормы = "ВсеОтчетыРаздела" Тогда
		СтандартнаяОбработка = Ложь;
		ВариантыОтчетовКлиент.ОткрытьВариантОтчета(ЭтотОбъект);
	ИначеЕсли РежимРаботыФормы = "Список" Тогда
		СтандартнаяОбработка = Ложь;
		ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	Инструкция = ВариантыОтчетов.ИнструкцияУсловногоОформления();
	Инструкция.Поля = "Описание";
	Инструкция.Отборы.Вставить("Список.Описание", ВидСравненияКомпоновкиДанных.Заполнено);
	Инструкция.Оформление.Вставить("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	ВариантыОтчетов.ДобавитьЭлементУсловногоОформления(ЭтотОбъект, Инструкция);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПеретаскиваниеЗавершение(Ответ, ПараметрыРазмещения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполнения = РазместитьВариантыВПодсистеме(ПараметрыРазмещения);
	
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойствоСпискаПоПараметруФормы(Ключ)
	
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСодержимоеСписка(Знач Событие = "")
	ИзменилисьПерсональныеНастройки = Ложь;
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		СписокВыбора = Элементы.СтрокаПоиска.СписокВыбора;
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
		Если ЭлементСписка = Неопределено Тогда
			СписокВыбора.Вставить(0, СтрокаПоиска);
			ИзменилисьПерсональныеНастройки = Истина;
			Если СписокВыбора.Количество() > 10 Тогда
				СписокВыбора.Удалить(10);
			КонецЕсли;
		Иначе
			Индекс = СписокВыбора.Индекс(ЭлементСписка);
			Если Индекс <> 0 Тогда
				СписокВыбора.Сдвинуть(Индекс, -Индекс);
				ИзменилисьПерсональныеНастройки = Истина;
			КонецЕсли;
		КонецЕсли;
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
	Если Событие = "СтрокаПоискаПриИзменении" И ИзменилисьПерсональныеНастройки Тогда
		ПерсональныеНастройкиСписка = Новый Структура("СтрокаПоискаСписокВыбора");
		ПерсональныеНастройкиСписка.СтрокаПоискаСписокВыбора = Элементы.СтрокаПоиска.СписокВыбора.ВыгрузитьЗначения();
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
			"Справочник.ВариантыОтчетов.ФормаСписка",
			ПерсональныеНастройкиСписка);
	КонецЕсли;
	
	ДеревоПодсистемТекущаяСтрока = Элементы.ДеревоПодсистем.ТекущаяСтрока;
	
	СтрокаДерева = ДеревоПодсистем.НайтиПоИдентификатору(ДеревоПодсистемТекущаяСтрока);
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсеПодсистемы = НЕ ЗначениеЗаполнено(СтрокаДерева.ПолноеИмя);
	
	ПараметрыПоиска = Новый Структура;
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		ПараметрыПоиска.Вставить("СтрокаПоиска", СтрокаПоиска);
	КонецЕсли;
	Если Не ВсеПодсистемы Тогда
		МассивПодсистем = Новый Массив;
		МассивПодсистем.Добавить(СтрокаДерева.Ссылка);
		Если ВключаяПодчиненные Тогда
			ДобавитьРекурсивно(МассивПодсистем, СтрокаДерева.ПолучитьЭлементы());
		КонецЕсли;
		ПараметрыПоиска.Вставить("Подсистемы", МассивПодсистем);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборТипОтчета) Тогда
		МассивТиповОтчетов = Новый Массив;
		Если ОтборТипОтчета = 1 Тогда
			МассивТиповОтчетов.Добавить(Перечисления.ТипыОтчетов.Внутренний);
			МассивТиповОтчетов.Добавить(Перечисления.ТипыОтчетов.Дополнительный);
		Иначе
			МассивТиповОтчетов.Добавить(ОтборТипОтчета);
		КонецЕсли;
		ПараметрыПоиска.Вставить("ТипыОтчетов", МассивТиповОтчетов);
	КонецЕсли;
	
	РезультатПоиска = ВариантыОтчетов.НайтиСсылки(ПараметрыПоиска);
	ВариантыПользователя = ?(РезультатПоиска = Неопределено, Null, РезультатПоиска.Ссылки);
	Список.Параметры.УстановитьЗначениеПараметра("ВариантыПользователя", ВариантыПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемОбработчикАктивизацииСтроки()
	Если ДеревоПодсистемТекущаяСтрока <> Элементы.ДеревоПодсистем.ТекущаяСтрока Тогда
		ОбновитьСодержимоеСписка();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьРекурсивно(МассивПодсистем, КоллекцияСтрокДерева)
	Для Каждого СтрокаДерева Из КоллекцияСтрокДерева Цикл
		МассивПодсистем.Добавить(СтрокаДерева.Ссылка);
		ДобавитьРекурсивно(МассивПодсистем, СтрокаДерева.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция РазместитьВариантыВПодсистеме(ПараметрыРазмещения)
	Размещено = 0;
	ТекстОшибок = "";
	НачатьТранзакцию();
	Для Каждого ВариантСсылка Из ПараметрыРазмещения.Варианты.Массив Цикл
		Если ВариантСсылка.ТипОтчета = Перечисления.ТипыОтчетов.Внешний Тогда
			ТекстОшибок = ТекстОшибок + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='""%1"" внешний.';uk='""%1"" зовнішній.'"),
				Строка(ВариантСсылка)
			) + Символы.ПС;
			Продолжить;
		ИначеЕсли ВариантСсылка.ПометкаУдаления Тогда
			ТекстОшибок = ТекстОшибок + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='""%1"" помечен на удаление.';uk='""%1"" відмічений для вилучення.'"),
				Строка(ВариантСсылка)
			) + Символы.ПС;
			Продолжить;
		КонецЕсли;
		
		ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
		
		СтрокаПриемник = ВариантОбъект.Размещение.Найти(ПараметрыРазмещения.Приемник.Ссылка, "Подсистема");
		
		Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
			СтрокаИсточник = ВариантОбъект.Размещение.Найти(ПараметрыРазмещения.Источник.Ссылка, "Подсистема");
			Если СтрокаИсточник = Неопределено Тогда
				// Действие не требуется
			ИначеЕсли СтрокаПриемник = Неопределено Тогда
				// Замена подсистемы
				СтрокаИсточник.Подсистема = ПараметрыРазмещения.Приемник.Ссылка;
				СтрокаПриемник = СтрокаИсточник;
			Иначе
				// Удаление строки
				ВариантОбъект.Размещение.Удалить(СтрокаИсточник);
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаПриемник = Неопределено Тогда
			СтрокаПриемник = ВариантОбъект.Размещение.Добавить();
			СтрокаПриемник.Подсистема = ПараметрыРазмещения.Приемник.Ссылка;
		КонецЕсли;
		
		СтрокаПриемник.Использование = Истина;
		
		Размещено = Размещено + 1;
		ВариантОбъект.Записать();
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	РезультатВыполнения = Новый Структура;
	Если ПараметрыРазмещения.Варианты.Всего = Размещено Тогда
		РезультатВыполнения.Вставить("ВыводОповещения", Новый Структура("Использование, Заголовок, Текст, Ссылка, Картинка"));
		ВыводОповещения = РезультатВыполнения.ВыводОповещения;
		ВыводОповещения.Использование = Истина;
		Если ПараметрыРазмещения.Варианты.Всего = 1 Тогда
			ВыводОповещения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Вариант отчета ""%1"" размещен в ""%2"".';uk='Варіант звіту ""%1"" розміщено в ""%2"".'"),
				ПараметрыРазмещения.Варианты.Представление,
				ПараметрыРазмещения.Приемник.ПолноеПредставление);
			ВыводОповещения.Текст = ПараметрыРазмещения.Варианты.Представление;
			ВыводОповещения.Ссылка = ПолучитьНавигационнуюСсылку(ПараметрыРазмещения.Варианты.Массив[0]);
		Иначе
			ВыводОповещения.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Варианты отчетов ""%1"" (%2 шт.) размещены в ""%3"".';uk='Варіанти звітів ""%1"" (%2 шт.) розміщено в ""%3"".'"),
				ПараметрыРазмещения.Варианты.Представление,
				Формат(ПараметрыРазмещения.Варианты.Всего, "ЧН=0; ЧГ=0"),
				ПараметрыРазмещения.Приемник.ПолноеПредставление);
		КонецЕсли;
	Иначе
		РезультатВыполнения.Вставить("ВыводПредупреждения", Новый Структура("Использование, Текст, ТекстОшибок"));
		ВыводПредупреждения = РезультатВыполнения.ВыводПредупреждения;
		ВыводПредупреждения.Использование = Ложь;
		ВыводПредупреждения.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Размещено вариантов отчетов: %1 из %2';uk='Розміщено варіантів звітів: %1 з %2'"), 
			Формат(Размещено, "ЧН=0; ЧГ=0"),
			Формат(ПараметрыРазмещения.Варианты.Всего, "ЧН=0; ЧГ=0"));
		ВыводПредупреждения.ТекстОшибок = НСтр("ru='Варианты отчетов, которые не могут размещаться в командном интерфейсе:';uk='Варіанти звітів, які не можуть розміщатися в командному інтерфейсі:'")
		+ Символы.ПС
		+ ТекстОшибок;
	КонецЕсли;
	
	Если ПараметрыРазмещения.Действие = "Перемещение" И Размещено > 0 Тогда
		ОбновитьСодержимоеСписка();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

#КонецОбласти
