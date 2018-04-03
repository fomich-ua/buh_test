////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Выводит информационные ссылки на форме
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура ВывестиКонтекстныеСсылки(Форма, ГруппаФормы, КоличествоГрупп = 3, КоличествоСсылокВГруппе = 1, ВыводитьСсылкуВсе = Истина, ПутьКФорме = "") Экспорт
	
	Попытка
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ТаблицаСсылокФормы = ИнформационныйЦентрСерверПовтИсп.ПолучитьТаблицуИнформационныхСсылокДляФормы(ПутьКФорме);
		Если ТаблицаСсылокФормы.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		// Добавление списка Информационных ссылок
		ИмяРеквизита = "ИнформационныеСсылки";
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		СформироватьГруппыВывода(Форма, ТаблицаСсылокФормы, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе);
	Исключение
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Возвращает информационную ссылку по идентификатору.
//
// Параметры:
//	Идентификатор - Строка - идентификатор ссылки.
//
// Возвращаемое значение:
//	Структура с полями:
//		Ключ - "Адрес", значение - Строка - адрес ссылки.
//		Ключ - "Наименование", значение - Строка - наименование ссылки.
//
Функция КонтекстнаяСсылкаПоИдентификатору(Идентификатор) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("Адрес", "");
	ВозвращаемаяСтруктура.Вставить("Наименование", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Адрес КАК Адрес,
	|	ИнформационныеСсылкиДляФорм.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.Идентификатор = &Идентификатор
	|	И НЕ ИнформационныеСсылкиДляФорм.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВозвращаемаяСтруктура.Адрес = Выборка.Адрес;
		ВозвращаемаяСтруктура.Наименование = Выборка.Наименование;
		Прервать;
		
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры

// Возвращает имя события журнала регистрации.
//
// Возвращаемое значение:
//	Строка - имя события журнала регистрации.
//
Функция ПолучитьИмяСобытияДляЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Информационный центр';uk='Інформаційний центр'");
	
КонецФункции

// Получить прокси управления конференцией.
//
// Возвращаемое значение:
//  WSПрокси - прокси управления конференцией.
//
Функция ПолучитьПроксиУправленияКонференцией() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Адрес              = Константы.АдресУправленияКонференцией.Получить() + "/ForumService?wsdl";
	ИмяПользователя    = Константы.ИмяПользователяКонференцииИнформационногоЦентра.Получить();
	ПарольПользователя = Константы.ПарольПользователяКонференцииИнформационногоЦентра.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Прокси = ТехнологияСервисаИнтеграцияСБСП.WSПрокси(Адрес,
		"http://ws.forum.saas.onec.ru/",
		"ForumIntegrationWSImplService",
		"ForumIntegrationWSImplPort",
		ИмяПользователя,
		ПарольПользователя);
	
	Возврат Прокси;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра() Экспорт
	
	Если Не ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		ВызватьИсключение(НСтр("ru='Не возможно подключиться к Менеджеру сервиса.';uk='Не можливо підключитися до Менеджера сервісу.'"));
	КонецЕсли;
	
	МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = МодульРаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru='Не установлены параметры связи с менеджером сервиса.';uk=""Не встановлені параметри зв'язку з менеджером сервісу."""));
	КонецЕсли;
	
	АдресСервиса       = АдресМенеджераСервиса + "/ws/ManageInfoCenter?wsdl";
	ИмяПользователя    = МодульРаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = МодульРаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроксиИнформационногоЦентра = ТехнологияСервисаИнтеграцияСБСП.WSПрокси(АдресСервиса,
															"http://www.1c.ru/SaaS/1.0/WS",
															"ManageInfoCenter", 
															, 
															ИмяПользователя, 
															ПарольПользователя, 
															7);
	
	Возврат ПроксиИнформационногоЦентра;
	
КонецФункции

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_1() Экспорт
	
	Если Не ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		ВызватьИсключение(НСтр("ru='Не возможно подключиться к Менеджеру сервиса.';uk='Не можливо підключитися до Менеджера сервісу.'"));
	КонецЕсли;
	
	МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = МодульРаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru='Не установлены параметры связи с менеджером сервиса.';uk=""Не встановлені параметри зв'язку з менеджером сервісу."""));
	КонецЕсли;
	
	АдресСервиса       = АдресМенеджераСервиса + "/ws/ManageInfoCenter_1_0_1_1?wsdl";
	ИмяПользователя    = МодульРаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = МодульРаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроксиИнформационногоЦентра = ТехнологияСервисаИнтеграцияСБСП.WSПрокси(АдресСервиса,
															"http://www.1c.ru/SaaS/1.0/WS",
															"ManageInfoCenter_1_0_1_1", 
															, 
															ИмяПользователя, 
															ПарольПользователя, 
															7);
	
	Возврат ПроксиИнформационногоЦентра;
	
КонецФункции

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_2() Экспорт
	
	Если Не ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		ВызватьИсключение(НСтр("ru='Не возможно подключиться к Менеджеру сервиса.';uk='Не можливо підключитися до Менеджера сервісу.'"));
	КонецЕсли;
	
	МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = МодульРаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru='Не установлены параметры связи с менеджером сервиса.';uk=""Не встановлені параметри зв'язку з менеджером сервісу."""));
	КонецЕсли;
	
	АдресСервиса       = АдресМенеджераСервиса + "/ws/ManageInfoCenter_1_0_1_2?wsdl";
	ИмяПользователя    = МодульРаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = МодульРаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроксиИнформационногоЦентра = ТехнологияСервисаИнтеграцияСБСП.WSПрокси(АдресСервиса,
															"http://www.1c.ru/SaaS/1.0/WS",
															"ManageInfoCenter_1_0_1_2", 
															, 
															ИмяПользователя, 
															ПарольПользователя, 
															7);
	
	Возврат ПроксиИнформационногоЦентра;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Оповещения пользователей в форме Информационного центра

// Возвращает ссылку на элемент справочника "ТипыИнформацииИнформационногоЦентра" по Наименованию
//
// Параметры:
//	Наименование - Строка - наименования типа новости.
//
// Возвращаемое значение:
//	СправочникСсылка.ТипыИнформацииИнформационногоЦентра - тип информации.
//
Функция ОпределитьСсылкуТипаИнформации(знач Наименование) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Наименование = СокрЛП(Наименование);
	
	НайденнаяСсылка = Справочники.ТипыИнформацииИнформационногоЦентра.НайтиПоНаименованию(Наименование);
	
	Если НайденнаяСсылка.Пустая() Тогда 
		ТипИнформации = Справочники.ТипыИнформацииИнформационногоЦентра.СоздатьЭлемент();
		ТипИнформации.Наименование = Наименование;
		ТипИнформации.Записать();
		
		Возврат ТипИнформации.Ссылка;
	Иначе
		Возврат НайденнаяСсылка;
	КонецЕсли;
	
КонецФункции

// Определяет список всех новостей.
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//
Функция СформироватьСписокВсехНовостей() Экспорт
	
	ЗапросВсехНовостей = Новый Запрос;
	
	ЗапросВсехНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Наименование КАК Наименование,
	|	ОбщиеДанныеИнформационногоЦентра.Критичность КАК Критичность,
	|	ОбщиеДанныеИнформационногоЦентра.Идентификатор КАК Идентификатор,
	|	ОбщиеДанныеИнформационногоЦентра.ВнешняяСсылка КАК ВнешняяСсылка,
	|	ОбщиеДанныеИнформационногоЦентра.ТипИнформации КАК ТипИнформации
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросВсехНовостей.Выполнить().Выгрузить();
	
КонецФункции

// Формирует список новостей.
//
// Параметры:
//	ТаблицаНовостей - ТаблицаЗначений с колонками:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//	КоличествоВыводимыхНовостей - Число - Количество выводимых новостей на рабочем столе.
//
Процедура СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей, Знач КоличествоВыводимыхНовостей = 3) Экспорт
	
	КритичныеНовости = СформироватьАктуальныеКритичныеНовости();
	
	КоличествоКритичныхНовостей = ?(КритичныеНовости.Количество() >= КоличествоВыводимыхНовостей, КоличествоВыводимыхНовостей, КритичныеНовости.Количество());
	
	// Добавление новостей в общую таблицу.
	Если КоличествоКритичныхНовостей > 0 Тогда 
		Для Итерация = 0 по КоличествоКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, КритичныеНовости.Получить(Итерация));
		КонецЦикла;	
	КонецЕсли;
	
	Если КоличествоКритичныхНовостей = КоличествоВыводимыхНовостей Тогда 
		Возврат;
	КонецЕсли;
	
	НеКритичныеНовости = СформироватьАктуальныеНеКритичныеНовости();
	
	КоличествоВыводимыхНеКритичныхНовостей = КоличествоВыводимыхНовостей - КоличествоКритичныхНовостей;
	
	КоличествоВыводимыхНеКритичныхНовостей = ?(НеКритичныеНовости.Количество() < КоличествоВыводимыхНеКритичныхНовостей, НеКритичныеНовости.Количество(), КоличествоВыводимыхНеКритичныхНовостей);
	
	Если НеКритичныеНовости.Количество() > 0 Тогда 
		Для Итерация = 0 по КоличествоВыводимыхНеКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, НеКритичныеНовости.Получить(Итерация));
		КонецЦикла;
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка сообщений в поддержку сервиса

// Возвращает адрес электронной почты текущего пользователя.
//
// Возвращаемое значение:
//	Строка - адрес электронной почты текущего пользователя.
//
Функция ОпределитьАдресЭлектроннойПочтыПользователя() Экспорт 
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда 
		
		Модуль = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		Если Модуль = Неопределено Тогда 
			Возврат "";
		КонецЕсли;
		
		Возврат Модуль.КонтактнаяИнформацияОбъекта(ТекущийПользователь, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает шаблон текста в техподдержку.
//
// Возвращаемое значение:
//	Строка - шаблон текста в техподдержку.
//
Функция СформироватьШаблонТекстаВТехПоддержку() Экспорт
	
	Шаблон = НСтр("ru='Здравствуйте!"
"<p/>"
"<p/>ПозицияКурсора"
"<p/>"
"С уважением, %1.';uk='Доброго дня!"
"<p/>"
"<p/>ПозицияКурсора"
"<p/>"
"З повагою, %1.'");
	Шаблон = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
			Пользователи.ТекущийПользователь().ПолноеНаименование());
	
	Возврат Шаблон;
	
КонецФункции

// Возвращает имя файла, в котором находятся технические параметры
// для службы техподдержки.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция ПолучитьИмяФайлаТехническихПараметровДляСообщенияВТехПоддержку() Экспорт
	
	Возврат "TechnicalParameters.xml";
	
КонецФункции

// Возвращает текст технических параметров.
//
// Возвращаемое значение:
//	Соответствие:
//		Ключ - строка - наименование вложения.
//		Значение - ДвоичныеДанные - файл вложения.
//
Функция СформироватьXMLСТехническимиПараметрами(ДополнительныеПараметры = Неопределено) Экспорт
	
	МассивПараметров = ОпределитьМассивТехническихПараметров(ДополнительныеПараметры);
	
	ФайлXML = ПолучитьИмяВременногоФайла("xml");
	
	ТекстXML = Новый ЗаписьXML;
	ТекстXML.ОткрытьФайл(ФайлXML);
	ТекстXML.ЗаписатьОбъявлениеXML();
	ЗаписатьПараметрыВXML(ТекстXML, МассивПараметров);
	ТекстXML.Закрыть();
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ФайлXML);
	
	Попытка
		УдалитьФайлы(ФайлXML);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru='Информационный центр. Отправка сообщения в техподдержку. Не удалось удалить временный файл технических параметров.';uk='Інформаційний центр. Відправлення повідомлення в техпідтримку. Не вдалося вилучити тимчасовий файл технічних параметрів.'"), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Вложение = Новый СписокЗначений;
	Вложение.Добавить(ДвоичныеДанныеФайла, ПолучитьИмяФайлаТехническихПараметровДляСообщенияВТехПоддержку(), Истина);
	
	Возврат Вложение;
	
КонецФункции

// Возвращает строку с внешней ссылкой.
//
// Параметры:
//	Идентификатор - УникальныйИдентификатор - уникальный идентификатор новости.
//
// Возвращаемое значение:
//	Строка - адрес внешнего ресурса.
//
Функция ПолучитьВнешнююСсылкуПоИдентификаторуНовости(Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СсылкаНаДанные	= Справочники.ОбщиеДанныеИнформационногоЦентра.НайтиПоРеквизиту("Идентификатор", Идентификатор);
	Если СсылкаНаДанные.Пустая() Тогда 
		Возврат "";
	КонецЕсли;
	
	Возврат СсылкаНаДанные.ВнешняяСсылка;
	
КонецФункции
 
////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Отправляет сообщение пользователя в техподдержку.
//
// Параметры:
//	ПараметрыСообщения - Структура - параметры сообщения.
//	Результат - Булево - Истина, если сообщение отправлено, Ложь - Иначе.
//
Процедура ПриОтправкеСообщенияПользователяВТехподдержку(ПараметрыСообщения, Результат) Экспорт
	
	Если Не ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		
		Результат = Истина;
		Возврат;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		ТехнологияСервисаИнтеграцияСБСП.ОтправитьСообщение("ИнформационныйЦентр\ОтправкаСообщения\Техподдержка",
						ПараметрыСообщения,
						ТехнологияСервисаИнтеграцияСБСП.КонечнаяТочкаМенеджераСервиса());
		ЗафиксироватьТранзакцию();
		Результат = Истина;
		Возврат;
	Исключение
		ОтменитьТранзакцию();
		Результат = Ложь;
		Возврат;
	КонецПопытки;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Оповещения пользователей в форме Информационного центра

// Возвращает список актуальных критичных новостей (критичность > 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеКритичныеНовости()
	
	ЗапросКритичныхНовостей = Новый Запрос;
	
	ЗапросКритичныхНовостей.УстановитьПараметр("ТекущаяДата",                ТекущаяДатаСеанса());
	ЗапросКритичныхНовостей.УстановитьПараметр("КритичностьПять",            5);
	ЗапросКритичныхНовостей.УстановитьПараметр("ПустаяДата",                '00010101');
	
	ЗапросКритичныхНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК СсылкаНаДанные
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность > &КритичностьПять
	|	И (ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|			ИЛИ ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности = &ПустаяДата)
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбщиеДанныеИнформационногоЦентра.Критичность УБЫВ,
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает список актуальных некритичных новостей (критичность <= 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеНеКритичныеНовости()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросНеКритичныхНовостей = Новый Запрос;
	
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ТекущаяДата",     ТекущаяДата()); // Проектное решение БСП
	ЗапросНеКритичныхНовостей.УстановитьПараметр("КритичностьПять", 5);
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ПустаяДата",      '00010101');
	ЗапросНеКритичныхНовостей.УстановитьПараметр("Просмотрены",     Ложь);
	ЗапросНеКритичныхНовостей.УстановитьПараметр("Пользователь",    Пользователи.ТекущийПользователь().Ссылка);
	
	ЗапросНеКритичныхНовостей.Текст =
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК СсылкаНаДанные
	|ПОМЕСТИТЬ ДанныеИЦ
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность <= &КритичностьПять
	|	И (ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|			ИЛИ ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности = &ПустаяДата)
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПросмотренныеДанныеИнформационногоЦентра.ДанныеИнформационногоЦентра,
	|	ПросмотренныеДанныеИнформационногоЦентра.Просмотрены
	|ПОМЕСТИТЬ ПросмотренныеПользователем
	|ИЗ
	|	РегистрСведений.ПросмотренныеДанныеИнформационногоЦентра КАК ПросмотренныеДанныеИнформационногоЦентра
	|ГДЕ
	|	ПросмотренныеДанныеИнформационногоЦентра.Пользователь = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеИЦ.СсылкаНаДанные,
	|	ЕСТЬNULL(ПросмотренныеПользователем.Просмотрены, &Просмотрены) КАК Просмотрены
	|ПОМЕСТИТЬ Готовый
	|ИЗ
	|	ДанныеИЦ КАК ДанныеИЦ
	|		ПОЛНОЕ СОЕДИНЕНИЕ ПросмотренныеПользователем КАК ПросмотренныеПользователем
	|		ПО ДанныеИЦ.СсылкаНаДанные = ПросмотренныеПользователем.ДанныеИнформационногоЦентра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Готовый.СсылкаНаДанные
	|ИЗ
	|	Готовый КАК Готовый
	|ГДЕ
	|	Готовый.Просмотрены = &Просмотрены";
	
	Возврат ЗапросНеКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Отправка сообщений в поддержку сервиса

// Возвращает массив технических параметров.
//
// Возвращаемое значение:
//	Массив  - массив структуры технических параметров с полями:
//		Имя - Строка - имя параметра.
//		Значение - Строка - значение параметра.
//
Функция ОпределитьМассивТехническихПараметров(ДополнительныеПараметры)
	
	ИнформацияСистемная = Новый СистемнаяИнформация;
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ИмяКонфигурации",    Метаданные.Имя));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ВерсияКонфигурации", Метаданные.Версия));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ВерсияПлатформы",    ИнформацияСистемная.ВерсияПриложения));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ОбластьДанных",      Строка(Формат(ТехнологияСервисаИнтеграцияСБСП.ЗначениеРазделителяСеанса(), "ЧГ=0"))));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "Логин",              ИмяПользователя()));
	
	Если ДополнительныеПараметры <> Неопределено Тогда 
		Для Каждого Параметр Из ДополнительныеПараметры Цикл
			МассивПараметров.Добавить(Новый Структура("Имя, Значение", Параметр.Ключ, Строка(Параметр.Значение)));
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивПараметров;
	
КонецФункции	

// Записывает параметры в XML.
//
// Параметры:
//	ТекстXML - ЗаписьXML - запись XML.
//	МассивПараметров - массив параметров.
//
Процедура ЗаписатьПараметрыВXML(ТекстXML, МассивПараметров)
	
	ТекстXML.ЗаписатьНачалоЭлемента("parameters");
	Для Итерация = 0 по МассивПараметров.Количество() - 1 Цикл 
		ТекстXML.ЗаписатьНачалоЭлемента("parameter");
		Элемент = МассивПараметров.Получить(Итерация);
		ТекстXML.ЗаписатьАтрибут(Элемент.Имя, Элемент.Значение);
		ТекстXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ТекстXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Формирует элементы формы информационных ссылок в группе.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура СформироватьГруппыВывода(Форма, ТаблицаСсылок, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе)
	
	КоличествоСсылок = ?(ТаблицаСсылок.Количество() > КоличествоГрупп * КоличествоСсылокВГруппе, КоличествоГрупп * КоличествоСсылокВГруппе, ТаблицаСсылок.Количество());
	
	КоличествоГрупп = ?(КоличествоСсылок < КоличествоГрупп, КоличествоСсылок, КоличествоГрупп);
	
	НеполноеНаименованиеГруппы = "ГруппаИнформационныхСсылок";
	
	Для Итерация = 1 По КоличествоГрупп Цикл 
		
		ИмяЭлементаФормы                            = НеполноеНаименованиеГруппы + Строка(Итерация);
		РодительскаяГруппа                          = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
		РодительскаяГруппа.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
		РодительскаяГруппа.ОтображатьЗаголовок      = Ложь;
		РодительскаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительскаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
		
	КонецЦикла;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ГруппаСсылки = ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, Итерация);
		
		ИмяСсылки      = ТаблицаСсылок.Получить(Итерация - 1).Наименование;
		Адрес          = ТаблицаСсылок.Получить(Итерация - 1).Адрес;
		Подсказка      = ТаблицаСсылок.Получить(Итерация - 1).Подсказка;
		
		ЭлементСсылки                          = Форма.Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаСсылки);
		ЭлементСсылки.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок                = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.Высота                   = 1;
		ЭлементСсылки.Гиперссылка              = Истина;
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
	Если ВыводитьСсылкуВсе Тогда 
		Элемент                         = Форма.Элементы.Добавить("СсылкаВсеИнформационныеСсылки", Тип("ДекорацияФормы"), ГруппаФормы);
		Элемент.Вид                     = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок               = НСтр("ru='Все';uk='Всі'");
		Элемент.Гиперссылка             = Истина;
		Элемент.ЦветТекста              = WebЦвета.Черный;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки")
	КонецЕсли;
	
КонецПроцедуры

// Возвращает группу, в которой необходимо выводить информационные ссылки.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	КоличествоГрупп - Число - количество групп с информационными ссылками на форме.
//	НеполноеНаименованиеГруппы - Строка - неполное наименование группы.
//	ТекущаяИтерация - Число - текущая итерация.
//
// Возвращаемое значение:
//	ЭлементФормы - группа информационных ссылок или неопределенно.
//
Функция ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, ТекущаяИтерация)
	
	ИмяГруппы = "";
	
	Для ИтерацияГрупп = 1 По КоличествоГрупп Цикл
		
		Если ТекущаяИтерация % ИтерацияГрупп  = 0 Тогда 
			ИмяГруппы = НеполноеНаименованиеГруппы + Строка(ИтерацияГрупп);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Форма.Элементы.Найти(ИмяГруппы);
	
КонецФункции

// Процедуры и функции для удаления

// Описывает ссылку сайта для для публикации приложений через Интернет.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают ссылку сайта. 
//	
Функция НовоеОписаниеСсылкиСайтаДляПубликацииПриложенийЧерезИнтернет() Экспорт 
	
	Возврат Новый Структура("Имя, Адрес");
	
КонецФункции

// Описывает структуру полезной ссылки.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают полезную ссылку:
//		Имя - Строка - наименование полезной ссылки.
//		Адрес - Строка - адрес полезной ссылки.
//		Пояснение - Строка - пояснение полезной ссылки.
//		ДействиеПоНажатию - Строка - процедура-обработчик для полезной ссылки.
//	
// Примечание:
//	Поле "ДействиеПоНажатию" можно не устанавливать, если подразумевается переход по ссылке.
//
Функция НовоеОписаниеПолезнойСсылки() Экспорт
	
	Возврат Новый Структура("Имя, Адрес, Пояснение, ДействиеПоНажатию");
	
КонецФункции

// Описывает структуру статьи.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают статью. 
//	
Функция НовоеОписаниеСтатьи() Экспорт
	
	Возврат Новый Структура("Имя, Адрес");
	
КонецФункции	
