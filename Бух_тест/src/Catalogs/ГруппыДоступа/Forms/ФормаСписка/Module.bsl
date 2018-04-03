
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	РодительПерсональныхГруппДоступа = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина);
	
	УпрощенныйИнтерфейсНастройкиПравДоступа = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
		Элементы.ФормаСоздать.Видимость = Ложь;
		Элементы.ФормаСкопировать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Профиль", Параметры.Профиль);
	Если ЗначениеЗаполнено(Параметры.Профиль) Тогда
		Элементы.Профиль.Видимость = Ложь;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Автозаголовок = Ложь;
		
		Заголовок = НСтр("ru='Группы доступа';uk='Групи доступу'");
		
		Элементы.ФормаСоздатьГруппу.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСоздатьГруппу.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.ПрофилиГруппДоступа) Тогда
		Элементы.Профиль.Видимость = Ложь;
	КонецЕсли;
	
	Если ПравоДоступа("Просмотр", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Список.ТекстЗапроса = СтрЗаменить(
			Список.ТекстЗапроса,
			"&ОшибкаОбъектНеНайден",
			"ЕстьNULL(ВЫРАЗИТЬ(ГруппыДоступа.Пользователь КАК Справочник.ВнешниеПользователи).Наименование, &ОшибкаОбъектНеНайден)");
	КонецЕсли;
	
	СписокНедоступныхГрупп = Новый СписокЗначений;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Скрытие группы доступа Администраторы.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ГруппыДоступа.Администраторы,
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ОшибкаОбъектНеНайден",
		НСтр("ru='<Объект не найден>';uk='<Об`єкт не знайдено>'"));
	
	Если Параметры.РежимВыбора Тогда
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru='Подбор групп доступа';uk='Підбір груп доступу'");
		Иначе
			Заголовок = НСтр("ru='Выбор группы доступа';uk='Вибір групи доступу'");
			Элементы.ФормаВыбрать.КнопкаПоУмолчанию = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПеренестиОтборыВДинамическийСписок(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено
		И Элементы.Список.ТекущиеДанные.Свойство("Пользователь")
		И Элементы.Список.ТекущиеДанные.Свойство("Ссылка") Тогда
		
		ПереносДопустим = НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Пользователь)
		                  И Элементы.Список.ТекущиеДанные.Ссылка <> РодительПерсональныхГруппДоступа;
		
		Если Элементы.Найти("ФормаПеренестиЭлемент") <> Неопределено Тогда
			Элементы.ФормаПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
		
		Если Элементы.Найти("СписокКонтекстноеМенюПеренестиЭлемент") <> Неопределено Тогда
			Элементы.СписокКонтекстноеМенюПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
		
		Если Элементы.Найти("СписокПеренестиЭлемент") <> Неопределено Тогда
			Элементы.СписокПеренестиЭлемент.Доступность = ПереносДопустим;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru='Эта группа только для персональных групп доступа.';uk='Дана група тільки для персональних груп доступу.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Родитель = РодительПерсональныхГруппДоступа Тогда
		
		Отказ = Истина;
		
		Если Группа Тогда
			ПоказатьПредупреждение(, НСтр("ru='В этой группе не используются подгруппы.';uk='У цій групі не використовуються підгрупи.'"));
			
		ИначеЕсли УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
			ПоказатьПредупреждение(,
				НСтр("ru='Персональные группы доступа"
"создаются только в форме ""Права доступа"".';uk='Персональні групи доступу"
"створюються тільки у формі ""Права доступу"".'"));
		Иначе
			ПоказатьПредупреждение(, НСтр("ru='Персональные группы доступа не используются.';uk='Персональні групи доступу не використовуються.'"));
		КонецЕсли;
		
	ИначеЕсли НЕ Группа
	        И УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
		
		Отказ = Истина;
		
		ПоказатьПредупреждение(,
			НСтр("ru='Используются только персональные группы доступа,"
"которые создаются только в форме ""Права доступа"".';uk='Використовуються тільки персональні групи доступу,"
"які створюються тільки у формі ""Права доступу"".'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru='Эта папка только для персональных групп доступа.';uk='Дана папка тільки для персональних груп доступу.'"));
		
	ИначеЕсли ПараметрыПеретаскивания.Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru='Папка персональных групп доступа не переносится.';uk='Папка персональних груп доступу не переноситься.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
