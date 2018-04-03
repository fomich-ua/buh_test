

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	
	Если ВерсионированиеОбъектов.НомерПоследнейВерсии(Ссылка) = 0 Тогда
		Элементы.ОсновнаяСтраница.ТекущаяСтраница = Элементы.ВерсииДляСравненияОтсутствуют;
		Элементы.НетВерсий.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	       НСтр("ru='Предыдущие версии отсутствуют: ""%1"".';uk='Попередні версії відсутні: ""%1"".'"),
	       Строка(Ссылка));
	КонецЕсли;
	
	ОбновитьСписокВерсий();
	
	ПереходНаВерсиюРазрешен = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ПерейтиНаВерсию.Видимость = ПереходНаВерсиюРазрешен;
	Элементы.СписокВерсийПерейтиНаВерсию.Видимость = ПереходНаВерсиюРазрешен;
	
	Реквизиты = НСтр("ru='Все';uk='Всі'")
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореРеквизитов", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборРеквизитовОбъекта", Новый Структура(
		"Ссылка,Отбор", Ссылка, Отбор.ВыгрузитьЗначения()), , , , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЖурналРегистрацииНажатие(Элемент)
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВерсий

&НаКлиенте
Процедура СписокВерсийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВерсийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьОтчетПоВерсииОбъекта();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВерсиюОбъекта(Команда)
	
	ОткрытьОтчетПоВерсииОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаВерсию(Команда)
	
	ВыполнитьПереходНаВыбраннуюВерсию();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоИзменениям(Команда)
	
	ВыделенныеСтроки = Элементы.СписокВерсий.ВыделенныеСтроки;
	СравниваемыеВерсии = СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки);
	
	Если СравниваемыеВерсии.Количество() < 2 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для формирования отчета по изменениям необходимо выбрать хотя бы две версии.';uk=' Для формування звіту по змінах необхідно вибрати хоча б дві версії.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьТаблицуВерсий()
	
	Если ВерсионированиеОбъектов.ЕстьПравоНаЧтениеВерсийОбъектов() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	НомераВерсий = Новый Массив;
	Если Отбор.Количество() > 0 Тогда
		НомераВерсий = НомераВерсийСИзменениямиВВыбранныхРеквизитах();
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии,
	|	ВерсииОбъектов.АвторВерсии КАК АвторВерсии,
	|	ВерсииОбъектов.ДатаВерсии КАК ДатаВерсии,
	|	ВерсииОбъектов.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
	|ГДЕ
	|	ВерсииОбъектов.Объект = &Ссылка
	|	И (&БезОтбора
	|			ИЛИ ВерсииОбъектов.НомерВерсии В (&НомераВерсий))
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерВерсии УБЫВ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БезОтбора", Отбор.Количество() = 0);
	Запрос.УстановитьПараметр("НомераВерсий", НомераВерсий);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсию(ОтменятьПроведение = Ложь)
	
	Если Элементы.СписокВерсий.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПерейтиНаВерсиюСервер(Ссылка, Элементы.СписокВерсий.ТекущиеДанные.НомерВерсии, ОтменятьПроведение);
	
	Если Результат = "ОшибкаВосстановления" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
	ИначеЕсли Результат = "ОшибкаПроведения" Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Переход на версию не был выполнен по причине:"
"%1"
"Перейти на выбранную версию с отменой проведения?';uk='Перехід на версію не був виконаний через:"
" %1"
"Перейти на обрану версію зі скасуванням проведення?'"),
			ТекстСообщенияОбОшибке);
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Перейти", НСтр("ru='Перейти';uk='Перейти'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе //Результат = "ВосстановлениеВыполнено"
		ОповеститьОбИзменении(Ссылка);
		Если ВладелецФормы <> Неопределено Тогда
			Попытка
				ВладелецФормы.Прочитать();
			Исключение
				// ничего не делаем, если у формы нет метода Прочитать()
			КонецПопытки;
		КонецЕсли;
		ПоказатьПредупреждение(, НСтр("ru='Переход к старой версий выполнен успешно.';uk='Перехід до старого версій виконаний успішно.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> "Перейти" Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПереходНаВыбраннуюВерсию(Истина);
КонецПроцедуры

&НаСервере
Функция ПерейтиНаВерсиюСервер(Ссылка, НомерВерсии, ОтменаПроведения = Ложь)
	
	Информация = ВерсионированиеОбъектов.СведенияОВерсииОбъекта(Ссылка, НомерВерсии);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Информация.ВерсияОбъекта);
	
	ТекстСообщенияОбОшибке = "";
	Объект = ВерсионированиеОбъектов.ВосстановитьОбъектПоXML(АдресВоВременномХранилище, ТекстСообщенияОбОшибке);
	
	Если Не ПустаяСтрока(ТекстСообщенияОбОшибке) Тогда
		Возврат "ОшибкаВосстановления";
	КонецЕсли;
	
	Объект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Выполнен переход к версии №%1 от %2';uk='Виконано перехід до версії №%1 від %2'"),
			Строка(НомерВерсии),
			Формат(Информация.ДатаВерсии, "ДЛФ=DT")) );
			
	РежимЗаписи = РежимЗаписиДокумента.Запись;
	Если ОбщегоНазначения.ЭтоДокумент(Объект.Метаданные()) Тогда
		Если Объект.Проведен И Не ОтменаПроведения Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Иначе
			РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
		КонецЕсли;
		
		Попытка
			Объект.Записать(РежимЗаписи);
		Исключение
			ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат "ОшибкаПроведения"
		КонецПопытки;
	Иначе
		Попытка
			Объект.Записать();
		Исключение
			ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат "ОшибкаВосстановления"
		КонецПопытки;
	КонецЕсли;
	
	
	ОбновитьСписокВерсий();
	
	Возврат "ВосстановлениеВыполнено";
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОтчетПоВерсииОбъекта()
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Элементы.СписокВерсий.ТекущиеДанные.НомерВерсии);
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(СравниваемыеВерсии)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка", Ссылка);
	ПараметрыОтчета.Вставить("СравниваемыеВерсии", СравниваемыеВерсии);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта",
		ПараметрыОтчета,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки)
	
	СравниваемыеВерсии = Новый СписокЗначений;
	
	Для Каждого НомерВыделеннойСтроки Из ВыделенныеСтроки Цикл
		СравниваемыеВерсии.Добавить(Элементы.СписокВерсий.ДанныеСтроки(НомерВыделеннойСтроки).НомерВерсии);
	КонецЦикла;
	
	СравниваемыеВерсии.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Возврат СравниваемыеВерсии.ВыгрузитьЗначения();
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступность()
	Элементы.ОткрытьВерсиюОбъекта.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() > 0;
	Элементы.ОтчетПоИзменениям.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() > 1;
	Элементы.ПерейтиНаВерсию.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() = 1;
	Элементы.СписокВерсийПерейтиНаВерсию.Доступность = Элементы.ПерейтиНаВерсию.Доступность;
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореРеквизитов(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = РезультатВыбора.ПредставлениеВыбранных;
	Отбор.ЗагрузитьЗначения(РезультатВыбора.ВыбранныеРеквизиты);
	ОбновитьСписокВерсий();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВерсий()
	ЗначениеВРеквизитФормы(СформироватьТаблицуВерсий(), "СписокВерсий");
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Реквизиты = НСтр("ru='Все';uk='Всі'");
	Отбор.Очистить();
	ОбновитьСписокВерсий();
КонецПроцедуры

&НаСервере
Функция НомераВерсийСИзменениямиВВыбранныхРеквизитах()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии,
	|	ВерсииОбъектов.ВерсияОбъекта КАК Данные
	|ИЗ
	|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
	|ГДЕ
	|	ВерсииОбъектов.ТипВерсииОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыВерсийОбъекта.ИзмененоПользователем)
	|	И ВерсииОбъектов.Объект = &Ссылка
	|	И ВерсииОбъектов.ЕстьДанныеВерсии
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерВерсии";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ХранимыеВерсии = Запрос.Выполнить().Выгрузить();
	
	ТекущаяВерсия = ХранимыеВерсии.Добавить();
	ТекущаяВерсия.Данные = Новый ХранилищеЗначения(ВерсионированиеОбъектов.СериализоватьОбъект(Ссылка.ПолучитьОбъект()), Новый СжатиеДанных(9));
	ТекущаяВерсия.НомерВерсии = ВерсионированиеОбъектов.НомерПоследнейВерсии(Ссылка);
	
	ПредыдущаяВерсия = ВерсионированиеОбъектов.РазборПредставленияОбъектаXML(ХранимыеВерсии[0].Данные.Получить(), Ссылка);
	
	Результат = Новый Массив;
	Результат.Добавить(ХранимыеВерсии[0].НомерВерсии);
	
	Для НомерВерсии = 1 По ХранимыеВерсии.Количество() - 1 Цикл
		Версия = ХранимыеВерсии[НомерВерсии];
		ТекущаяВерсия = ВерсионированиеОбъектов.РазборПредставленияОбъектаXML(Версия.Данные.Получить(), Ссылка);
		Если ЕстьИзменениеРеквизитов(ТекущаяВерсия, ПредыдущаяВерсия, Отбор.ВыгрузитьЗначения()) Тогда
			Результат.Добавить(Версия.НомерВерсии);
		КонецЕсли;
		ПредыдущаяВерсия = ТекущаяВерсия;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ЕстьИзменениеРеквизитов(ТекущаяВерсия, ПредыдущаяВерсия, СписокРеквизитов)
	Для Каждого Реквизит Из СписокРеквизитов Цикл
		ИмяТабличнойЧасти = Неопределено;
		ИмяРеквизита = Реквизит;
		Если Найти(ИмяРеквизита, ".") > 0 Тогда
			ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяРеквизита, ".", Истина);
			Если ЧастиИмени.Количество() > 1 Тогда
				ИмяТабличнойЧасти = ЧастиИмени[0];
				ИмяРеквизита = ЧастиИмени[1];
			КонецЕсли;
		КонецЕсли;
		
		// проверка изменения реквизита табличной части
		Если ИмяТабличнойЧасти <> Неопределено Тогда
			ТекущаяТабличнаяЧасть = ТекущаяВерсия.ТабличныеЧасти[ИмяТабличнойЧасти];
			ПредыдущаяТабличнаяЧасть = ПредыдущаяВерсия.ТабличныеЧасти[ИмяТабличнойЧасти];
			
			// табличная часть отсутствует
			Если ТекущаяТабличнаяЧасть = Неопределено Или ПредыдущаяТабличнаяЧасть = Неопределено Тогда
				Возврат Не ТекущаяТабличнаяЧасть = Неопределено И ПредыдущаяТабличнаяЧасть = Неопределено;
			КонецЕсли;
			
			// если изменилось количество строк ТЧ
			Если ТекущаяТабличнаяЧасть.Количество() <> ПредыдущаяТабличнаяЧасть.Количество() Тогда
				Возврат Истина;
			КонецЕсли;
			
			// реквизит отсутствует
			ТекущийРеквизитСуществует = ТекущаяТабличнаяЧасть.Колонки.Найти(ИмяРеквизита) <> Неопределено;
			ПредыдущийРеквизитСуществует = ПредыдущаяТабличнаяЧасть.Колонки.Найти(ИмяРеквизита) <> Неопределено;
			Если ТекущийРеквизитСуществует <> ПредыдущийРеквизитСуществует Тогда
				Возврат Истина;
			КонецЕсли;
			Если Не ТекущийРеквизитСуществует Тогда
				Возврат Ложь;
			КонецЕсли;
			
			// сравнение по строкам
			Для НомерСтроки = 0 По ТекущаяТабличнаяЧасть.Количество() - 1 Цикл
				Если ТекущаяТабличнаяЧасть[НомерСтроки][ИмяРеквизита] <> ПредыдущаяТабличнаяЧасть[НомерСтроки][ИмяРеквизита] Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
			
			Возврат Ложь;
		КонецЕсли;
		
		// проверка реквизита шапки
		
		ТекущийРеквизит = ТекущаяВерсия.Реквизиты.Найти(ИмяРеквизита, "НаименованиеРеквизита");
		ТекущийРеквизитСуществует = ТекущийРеквизит <> Неопределено;
		ЗначениеТекущегоРеквизита = Неопределено;
		Если ТекущийРеквизитСуществует Тогда
			ЗначениеТекущегоРеквизита = ТекущийРеквизит.ЗначениеРеквизита;
		КонецЕсли;
		
		ПредыдущийРеквизит = ПредыдущаяВерсия.Реквизиты.Найти(ИмяРеквизита, "НаименованиеРеквизита");
		ПредыдущийРеквизитСуществует = ПредыдущийРеквизит <> Неопределено;
		ЗначениеПредыдущегоРеквизита = Неопределено;
		Если ПредыдущийРеквизитСуществует Тогда
			ЗначениеПредыдущегоРеквизита = ПредыдущийРеквизит.ЗначениеРеквизита;
		КонецЕсли;
		
		Если ТекущийРеквизитСуществует <> ПредыдущийРеквизитСуществует
			Или ЗначениеТекущегоРеквизита <> ЗначениеПредыдущегоРеквизита Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура СписокВерсийКомментарийПриИзменении(Элемент)
	ТекущиеДанные = Элементы.СписокВерсий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДобавитьКомментарийКВерсии(Ссылка, ТекущиеДанные.НомерВерсии, ТекущиеДанные.Комментарий);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьКомментарийКВерсии(СсылкаНаОбъект, НомерВерсии, Комментарий);
	ВерсионированиеОбъектов.ДобавитьКомментарийКВерсии(СсылкаНаОбъект, НомерВерсии, Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура СписокВерсийПередНачаломИзменения(Элемент, Отказ)
	Если Не РедактированиеКомментарияРазрешено(Элемент.ТекущиеДанные.АвторВерсии) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
////

&НаСервере
Функция РедактированиеКомментарияРазрешено(АвторВерсии)
	Возврат Пользователи.ЭтоПолноправныйПользователь()
		Или АвторВерсии = Пользователи.ТекущийПользователь();
КонецФункции

#КонецОбласти
