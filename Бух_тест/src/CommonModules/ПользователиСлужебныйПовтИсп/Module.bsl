////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Содержит сохраненные параметры, используемые подсистемой.
Функция Параметры() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыРаботыПользователей");
	УстановитьПривилегированныйРежим(Ложь);
	
	СтандартныеПодсистемыСервер.ПроверитьОбновлениеПараметровРаботыПрограммы(
		"ПараметрыРаботыПользователей",
		"НедоступныеРолиПоТипамПользователей,
		|ВсеРоли");
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("НедоступныеРолиПоТипамПользователей") Тогда
		ПредставлениеПараметра = НСтр("ru='Недоступные роли';uk='Недоступні ролі'");
		
	ИначеЕсли НЕ СохраненныеПараметры.Свойство("ВсеРоли") Тогда
		ПредставлениеПараметра = НСтр("ru='Все роли';uk='Всі ролі'");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка обновления информационной базы."
"Не заполнен параметр работы пользователей:"
"""%1"".';uk='Помилка оновлення інформаційної бази."
"Не заповнений параметр роботи користувачів:"
"""%1"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Возвращает дерево ролей с подсистемами или без них.
//  Если роль не принадлежит ни одной подсистеме она добавляется "в корень".
// 
// Параметры:
//  ПоПодсистемам - Булево, если Ложь, все роли добавляются в "корень".
// 
// Возвращаемое значение:
//  ДеревоЗначений с колонками:
//    ЭтоРоль - Булево
//    Имя     - Строка - имя     роли или подсистемы
//    Синоним - Строка - синоним роли или подсистемы
//
Функция ДеревоРолей(ПоПодсистемам = Истина, Знач ТипПользователей = Неопределено) Экспорт
	
	Если ТипПользователей = Неопределено Тогда
		ТипПользователей = ?(ОбщегоНазначенияПовтИсп.РазделениеВключено(), 
			Перечисления.ТипыПользователей.ПользовательОбластиДанных, 
			Перечисления.ТипыПользователей.ПользовательЛокальногоРешения);
	КонецЕсли;
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки, , ТипПользователей);
	КонецЕсли;
	
	НедоступныеРоли = ПользователиСлужебный.НедоступныеРолиПоТипуПользователей(ТипПользователей);
	
	// Добавление ненайденных ролей
	Для каждого Роль Из Метаданные.Роли Цикл
		
		Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
			ИЛИ ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя), Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Дерево;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева,
                                   Подсистемы = Неопределено,
                                   ТипПользователей)
	
	НедоступныеРоли = ПользователиСлужебный.НедоступныеРолиПоТипуПользователей(ТипПользователей);
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Для каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя           = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним       = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, ТипПользователей);
		
		Для каждого Роль Из Метаданные.Роли Цикл
			Если НедоступныеРоли.Получить(Роль) <> Неопределено
				ИЛИ ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
				
				Продолжить;
			КонецЕсли;
			
			Если Подсистема.Состав.Содержит(Роль) Тогда
				ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
				ОписаниеРоли.ЭтоРоль       = Истина;
				ОписаниеРоли.Имя           = Роль.Имя;
				ОписаниеРоли.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
			КонецЕсли;
		КонецЦикла;
		
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Новый Структура("ЭтоРоль", Истина), Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
