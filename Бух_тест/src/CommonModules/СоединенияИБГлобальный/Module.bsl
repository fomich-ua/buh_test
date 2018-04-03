////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполнить завершение текущего сеанса, если установлена блокировка соединений 
// с информационной базой.
//
Процедура КонтрольРежимаЗавершенияРаботыПользователей() Экспорт

	// Получим текущее значение параметров блокировки
	ТекущийРежим = СоединенияИБВызовСервера.ПараметрыБлокировкиСеансов();
	БлокировкаУстановлена = ТекущийРежим.Установлена;
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если НЕ БлокировкаУстановлена Тогда
		Возврат;
	КонецЕсли;
		
	ВремяНачалаБлокировки = ТекущийРежим.Начало;
	ВремяОкончанияБлокировки = ТекущийРежим.Конец;
	
	// ИнтервалЗакрытьСЗапросом и ИнтервалПрекратить имеют отрицательное значение,
	// поэтому, когда идет сравнение этих параметров с разницей (ВремяНачалаБлокировки - ТекущийМомент),
	// то используется "<=", так как данная разница постоянно уменьшается.
	ИнтервалПредупреждения    = ТекущийРежим.ИнтервалОжиданияЗавершенияРаботыПользователей;
	ИнтервалЗакрытьСЗапросом = ИнтервалПредупреждения / 3;
	ИнтервалПрекратитьВМоделиСервиса = 60; // за минуту до начала блокировки.
	ИнтервалПрекратить        = 0; // в момент установки блокировки.
	ТекущийМомент             = ТекущийРежим.ТекущаяДатаСеанса;
	
	Если ВремяОкончанияБлокировки <> '00010101' И ТекущийМомент > ВремяОкончанияБлокировки Тогда
		Возврат;
	КонецЕсли;
	
	ДатаВремениНачалаБлокировки  = Формат(ВремяНачалаБлокировки, "ДЛФ=DD");
	ВремяВремениНачалаБлокировки = Формат(ВремяНачалаБлокировки, "ДЛФ=T");
	
	ТекстСообщения = СоединенияИБКлиентСервер.ИзвлечьСообщениеБлокировки(ТекущийРежим.Сообщение);
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Рекомендуется завершить текущую работу и сохранить все свои данные. Работа программы будет завершена %1 в %2. "
"%3';uk='Рекомендується завершити поточну роботу й зберегти всі свої дані. Робота програми буде завершена %1 в %2. "
"%3'"),
		ДатаВремениНачалаБлокировки, ВремяВремениНачалаБлокировки, ТекстСообщения);
	
	Если Не ПараметрыРаботы.РазделениеВключено
		И (Не ЗначениеЗаполнено(ВремяНачалаБлокировки) Или ВремяНачалаБлокировки - ТекущийМомент < ИнтервалПрекратить) Тогда
		
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Ложь, Истина);
		
	ИначеЕсли ПараметрыРаботы.РазделениеВключено
		И (Не ЗначениеЗаполнено(ВремяНачалаБлокировки) Или ВремяНачалаБлокировки - ТекущийМомент < ИнтервалПрекратитьВМоделиСервиса) Тогда
		
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Ложь, Ложь);
		
	ИначеЕсли ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалЗакрытьСЗапросом Тогда
		
		СоединенияИБКлиент.ЗадатьВопросПриЗавершенииРаботы(ТекстСообщения);
		
	ИначеЕсли ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалПредупреждения Тогда
		
		ПоказатьПредупреждение(, ТекстСообщения, 30);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполнить завершение активных сеансов, если превышено время ожидания, а затем
// завершить текущий сеанс.
//
Процедура ЗавершитьРаботуПользователей() Экспорт

	// Получим текущее значение параметров блокировки
	ТекущийРежим = СоединенияИБВызовСервера.ПараметрыБлокировкиСеансов(Истина);
	
	ВремяНачалаБлокировки = ТекущийРежим.Начало;
	ВремяОкончанияБлокировки = ТекущийРежим.Конец;
	ТекущийМомент = ТекущийРежим.ТекущаяДатаСеанса;
	
	Если ТекущийМомент < ВремяНачалаБлокировки Тогда
		ТекстСообщения = НСтр("ru='Блокировка работы пользователей запланирована на %1.';uk='Блокування роботи користувачів заплановано на %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, ВремяНачалаБлокировки);
		ПоказатьОповещениеПользователя(НСтр("ru='Завершение работы пользователей';uk='Завершення роботи користувачів'"), 
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			ТекстСообщения, БиблиотекаКартинок.Информация32);
		Возврат;
	КонецЕсли;
		
	КоличествоСеансов = ТекущийРежим.КоличествоСеансов;
	Если КоличествоСеансов <= 1 Тогда
		// Отключены все пользователи, кроме текущего сеанса
		// В последнюю очередь предлагаем завершить сеанс, запущенный с параметром "ЗавершитьРаботуПользователей".
		// Такой порядок отключений необходим для обновления конфигурации с помощью пакетного файла
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус, КоличествоСеансов", "Готово", КоличествоСеансов));
		СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса();
		Возврат;
	КонецЕсли; 
	
	БлокировкаУстановлена = ТекущийРежим.Установлена;
	Если НЕ БлокировкаУстановлена Тогда
		Возврат;
	КонецЕсли;
	
	ИнтервалОтключения = - ТекущийРежим.ИнтервалОжиданияЗавершенияРаботыПользователей;
	ПринудительноеЗавершение = НЕ ЗначениеЗаполнено(ВремяНачалаБлокировки)
		ИЛИ ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалОтключения;
		
	Если НЕ ПринудительноеЗавершение Тогда
		
		ТекстСообщения = НСтр("ru='Активных сеансов: %1."
"Следующая проверка сеансов будет выполнена через минуту.';uk='Активних сеансів: %1."
"Наступна перевірка сеансів буде виконана через хвилину.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, КоличествоСеансов);
		ПоказатьОповещениеПользователя(НСтр("ru='Завершение работы пользователей';uk='Завершення роботи користувачів'"), 
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			ТекстСообщения, БиблиотекаКартинок.Информация32);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус,КоличествоСеансов", "Выполняется", КоличествоСеансов));
		Возврат;
	КонецЕсли;
	
	// после начала блокировки сеансы всех пользователей должны быть отключены
	// если этого не произошло пробуем принудительно прервать соединения
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
	
	Результат = Истина;
	Попытка
		
		ПараметрыАдминистрирования = СоединенияИБКлиент.СохраненныеПараметрыАдминистрирования();
		СоединенияИБКлиентСервер.УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования);
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(Неопределено);
		
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Если Результат Тогда
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
		ПоказатьОповещениеПользователя(НСтр("ru='Завершение работы пользователей';uk='Завершення роботи користувачів'"), 
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			НСтр("ru='Завершение сеансов выполнено успешно';uk='Завершення сеансів виконане успішно'"), БиблиотекаКартинок.Информация32);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус,КоличествоСеансов", "Готово", КоличествоСеансов));
		СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса();
	Иначе
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
		ПоказатьОповещениеПользователя(НСтр("ru='Завершение работы пользователей';uk='Завершення роботи користувачів'"), 
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			НСтр("ru='Завершение сеансов не выполнено! Подробности см. в Журнале регистрации.';uk='Завершення сеансів не виконане! Подробиці див. у Журналі реєстрації.'"), БиблиотекаКартинок.Предупреждение32);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус,КоличествоСеансов", "Ошибка", КоличествоСеансов));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
