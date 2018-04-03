////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (клиент)
// 
// Выполняется на клиенте.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает панель отчетов. Используется в модуле общей команды.
//
// Параметры:
//   ПутьКПодсистеме - Строка - Имя раздела или путь к подсистеме, для которой открывается панель отчетов.
//       Задается в формате: "ИмяРаздела[.ИмяВложеннойПодсистемы1][.ИмяВложеннойПодсистемы2][...]".
//       NB! Раздел должен быть описан в ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//   ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - Передается "как есть" из параметров обработчика команды.
//
Процедура ПоказатьПанельОтчетов(ПутьКПодсистеме, ПараметрыВыполненияКоманды, Удалить_Заголовок = "") Экспорт
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно);
КонецПроцедуры

// Открывает диалог настройки размещения нескольких вариантов в разделах.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   ДополнительныеПараметры (*) Необязательный.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования формы, из которой выполняется размещение вариантов отчетов.
//
Процедура ОткрытьДиалогРазмещенияВариантовВРазделах(МассивВариантов, ДополнительныеПараметры = Неопределено, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выберите варианты отчетов, которые необходимо разместить в разделах.';uk='Виберіть варіанти звітів, які необхідно розмістити в розділах.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("МассивВариантов, ДополнительныеПараметры", МассивВариантов, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.РазмещениеВРазделах", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса пользовательских настроек выбранных вариантов отчетов.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования формы, из которой выполняется вызов.
//
Процедура ОткрытьДиалогСбросаНастроекПользователей(МассивВариантов, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выберите варианты отчетов, для которых необходимо сбросить пользовательские настройки.';uk='Виберіть варіанти звітів, для яких необхідно скинути користувацькі настройки.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивВариантов", МассивВариантов);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросПользовательскихНастроек", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса настроек размещения выбранных вариантов отчетов программы.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования формы, из которой выполняется вызов.
//
Процедура ОткрытьДиалогСбросаНастроекРазмещения(МассивВариантов, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выберите варианты отчетов программы, для которых необходимо сбросить настройки размещения.';uk='Виберіть варіанти звітів програми, для яких необхідно скинути настройки розміщення.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивВариантов", МассивВариантов);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросНастроекРазмещения", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Оповещает открытые панели отчетов, формы списков и элементов о изменениях.
//
// Параметры:
//   Параметр - Произвольный - Необязательный. Могут быть переданы любые необходимые данные.
//   Источник - Произвольный - Необязательный. Источник события. Например, в качестве источника может быть указана другая форма.
//
Процедура ОбновитьОткрытыеФормы(Параметр = Неопределено, Источник = Неопределено) Экспорт
	
	Оповестить(ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта(), Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму отчета.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, из которой открывается отчет.
//
Процедура ОткрытьВариантОтчета(Форма) Экспорт
	Если Форма.ИмяФормы = "Справочник.ВариантыОтчетов.Форма.ФормаСписка" Тогда
		Вариант = Форма.Элементы.Список.ТекущиеДанные;
	ИначеЕсли Форма.ИмяФормы = "Справочник.ВариантыОтчетов.Форма.ФормаЭлемента" Тогда
		Вариант = Форма.Объект;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Вариант = Неопределено ИЛИ Вариант.Ссылка.Пустая() Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='Выберите вариант отчета.';uk='Виберіть варіант звіту.'"));
		
	ИначеЕсли Вариант.ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Внешний") Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='Вариант внешнего отчета можно открыть только из формы отчета.';uk='Варіант зовнішнього звіту можна відкрити тільки з форми звіту.'"));
		
	ИначеЕсли Вариант.ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Дополнительный") Тогда
		
		ПараметрыОткрытия = Новый Структура("Ссылка, Отчет, КлючВарианта");
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Вариант);
		ОткрытьВариантДополнительногоОтчета(ПараметрыОткрытия);
		
	Иначе
		
		Если Форма.ИмяФормы = "Справочник.ВариантыОтчетов.Форма.ФормаСписка" Тогда
			ИмяОтчета = Вариант.ИмяОтчета;
		Иначе
			ИмяОтчета = Форма.ИмяОтчета;
		КонецЕсли;
		
		Уникальность = "Отчет." + ИмяОтчета;
		Если ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
			Уникальность = Уникальность + "/КлючВарианта." + Вариант.КлючВарианта;
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("КлючВарианта", Вариант.КлючВарианта);
		ПараметрыОткрытия.Вставить("КлючПараметровПечати", Уникальность);
		ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", Уникальность);
		
		ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Уникальность);
		
	КонецЕсли;
КонецПроцедуры

// Открывает форму настроек (в частности размещения) варианта отчета.
Процедура ПоказатьНастройкиОтчета(ВариантСсылка) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкаРазмещения", Истина);
	ПараметрыФормы.Вставить("Ключ", ВариантСсылка);
	ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемИспользованиеПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Использование = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Использование = 2 Тогда
		СтрокаДерева.Использование = 0;
	КонецЕсли;
	
	//Если Не СтрокаДерева.Модифицированность
	//	И СтрокаДерева.Использование = 1
	//	И СтрокаДерева.ПользователиПредставление = "" Тогда
	//	Если Форма.Доступен = "2" Тогда // Всем пользователям.
	//		Пользователь = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ГруппыПользователей.ВсеПользователи");
	//	Иначе
	//		Если Форма.ИмяФормы = "Справочник.ВариантыОтчетов.Форма.ФормаЭлемента" Тогда
	//			Пользователь = Форма.Объект.Автор;
	//		Иначе
	//			Пользователь = Форма.ВариантАвтор;
	//		КонецЕсли;
	//	КонецЕсли;
	//	ВариантыОтчетовКлиентСервер.ДеревоПодсистемЗарегистрироватьПользователя(СтрокаДерева, Пользователь);
	//КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемВажностьПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Важность = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Важность <> "" Тогда
		СтрокаДерева.Использование = 1;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Аналог ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста, работающий за 1 вызов.
//   В отличие от ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария позволяет устанавливать свой заголовок
//   и работает с реквизитами таблиц.
//
Процедура РедактироватьМногострочныйТекст(ФормаИлиОбработчик, ТекстРедактирования, ВладелецРеквизита, ИмяРеквизита, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru='Комментарий';uk='Коментар'");
	КонецЕсли;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ФормаИлиОбработчик", ФормаИлиОбработчик);
	ПараметрыИсточника.Вставить("ВладелецРеквизита",  ВладелецРеквизита);
	ПараметрыИсточника.Вставить("ИмяРеквизита",       ИмяРеквизита);
	Обработчик = Новый ОписаниеОповещения("РедактироватьМногострочныйТекстЗавершение", ЭтотОбъект, ПараметрыИсточника);
	
	ПоказатьВводСтроки(Обработчик, ТекстРедактирования, Заголовок, , Истина);
	
КонецПроцедуры

// Обработчик результата работы процедуры РедактироватьМногострочныйТекст.
Процедура РедактироватьМногострочныйТекстЗавершение(Текст, ПараметрыИсточника) Экспорт
	
	Если ТипЗнч(ПараметрыИсточника.ФормаИлиОбработчик) = Тип("УправляемаяФорма") Тогда
		Форма      = ПараметрыИсточника.ФормаИлиОбработчик;
		Обработчик = Неопределено;
	Иначе
		Форма      = Неопределено;
		Обработчик = ПараметрыИсточника.ФормаИлиОбработчик;
	КонецЕсли;
	
	Если Текст <> Неопределено Тогда
		
		Если ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементДерева")
			Или ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементКоллекции") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыИсточника.ВладелецРеквизита, Новый Структура(ПараметрыИсточника.ИмяРеквизита, Текст));
		Иначе
			ПараметрыИсточника.ВладелецРеквизита[ПараметрыИсточника.ИмяРеквизита] = Текст;
		КонецЕсли;
		
		Если Форма <> Неопределено Тогда
			Если Не Форма.Модифицированность Тогда
				Форма.Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчик <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик, Текст);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры
//   Вариант - Структура - Информация о варианте отчета:
//       * Ссылка - СправочникСсылка.ВариантыОтчетов - Ссылка варианта отчета.
//       * Отчет - <см. Справочники.ВариантыОтчетов.Реквизиты.Отчет> - Ссылка или имя отчета.
//       * КлючВарианта - Строка - Имя варианта отчета.
//
Процедура ОткрытьВариантДополнительногоОтчета(Вариант) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиент");
		МодульДополнительныеОтчетыИОбработкиКлиент.ОткрытьВариантДополнительногоОтчета(Вариант.Отчет, Вариант.КлючВарианта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
