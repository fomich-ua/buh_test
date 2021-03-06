#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Предотвращает недопустимое изменение идентификаторов объектов метаданных.
// Выполняет обработку дублей подчиненного узла распределенной информационной базы.
//
Процедура ПередЗаписью(Отказ)
	
	СтандартныеПодсистемыПовтИсп.СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// Регистрация объекта на всех узлах РИБ.
	Для Каждого ПланОбмена Из СтандартныеПодсистемыПовтИсп.ПланыОбменаРИБ() Цикл
		СтандартныеПодсистемыСервер.ЗарегистрироватьОбъектНаВсехУзлах(ЭтотОбъект, ПланОбмена);
	КонецЦикла;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ВыполняетсяАвтоматическоеОбновлениеДанныхСправочника") Тогда
		
		Если ЭтоНовый() Тогда
		
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Создание нового идентификатора объекта метаданных"
"возможно только автоматически при обновлении данных справочника.';uk=""Створення нового ідентифікатора об'єкта метаданних"
"можливо тільки автоматично при оновленні даних довідника."""),
				ПолноеИмя));
				
		ИначеЕсли Справочники.ИдентификаторыОбъектовМетаданных.ЗапрещеноИзменятьПолноеИмя(ЭтотОбъект) Тогда
			
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При изменении идентификатора объекта метаданных указано"
"полное имя ""%1"", которое может быть"
"установлено только автоматически при обновлении данных справочника.';uk='При зміні ідентифікатора об''єкта метаданних зазначено"
"повне ім''я ""%1"", що може бути"
"установлено тільки автоматично при оновленні даних довідника.'"),
				ПолноеИмя));
		
		ИначеЕсли Справочники.ИдентификаторыОбъектовМетаданных.ПолноеИмяИспользуется(ПолноеИмя, Ссылка) Тогда
			
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При изменении идентификатора объекта метаданных указано"
"полное имя ""%1"","
"которое уже используется в справочнике.';uk='При зміні ідентифікатора об''єкта метаданних зазначено"
"повне ім''я ""%1"","
"яке вже використається в довіднику.'"),
				ПолноеИмя));
		
		КонецЕсли;
		
		Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьСвойстваИдентификатора(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		
		Если ЭтоНовый()
		   И Не Справочники.ИдентификаторыОбъектовМетаданных.ЭтоКоллекция(ПолучитьСсылкуНового()) Тогда
			
			ВызватьИсключениеПоОшибке(
				НСтр("ru='Добавление новых элементов может быть выполнено"
"только в главном узле распределенной информационной базы.';uk='Додавання нових елементів може бути виконане"
"тільки в головному вузлі розподіленої інформаційної бази.'"));
		КонецЕсли;
		
		Если Не ПометкаУдаления
		   И Не Справочники.ИдентификаторыОбъектовМетаданных.ЭтоКоллекция(Ссылка) Тогда
			
			Если ВРег(ПолноеИмя) <> ВРег(ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПолноеИмя")) Тогда
				ВызватьИсключениеПоОшибке(
					НСтр("ru='Изменение реквизита ""Полное имя"" может быть выполнено"
"только в главном узле распределенной информационной базы.';uk='Зміна реквізиту ""Повне ім''я"" може бути виконане"
"тільки в головному вузлі розподіленої інформаційної бази.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Предотвращает удаление идентификаторов объектов метаданных не помеченных на удаление.
Процедура ПередУдалением(Отказ)
	
	СтандартныеПодсистемыПовтИсп.СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	// Ссылки идентификаторов удаляются независимо во всех узлах
	// через механизм пометки удаления и удаления помеченных объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		ВызватьИсключениеПоОшибке(
			НСтр("ru='Удаление идентификаторов объектов метаданных, у которых значение"
"реквизита ""Пометка удаления"" установлено Ложь недопустимо.';uk='Вилучення ідентифікаторів об''єктів метаданних, у яких значення"
"реквізиту ""Позначка вилучення"" установлено Хибність неприпустимо.'"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ВызватьИсключениеПоОшибке(ТекстОшибки);
	
	ВызватьИсключение
		НСтр("ru='Ошибка при работе со справочником ""Идентификаторы объектов метаданных"".';uk='Помилка при роботі з довідником ""Ідентифікатори об''єктів метаданних"".'") + "
		           |
		           |" + ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
