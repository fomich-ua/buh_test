////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса\ПриСозданииАвтономногоРабочегоМеста"].Добавить(
		"ОбменДаннымиВМоделиСервисаСлужебныйБТС");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий

Процедура ПриСозданииАвтономногоРабочегоМеста() Экспорт
	
	Если ПользователиСлужебныйВМоделиСервисаБТС.ПользовательЗарегистрированКакНеразделенный(
			ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор) Тогда
		
		ВызватьИсключение НСтр("ru='Создать автономное рабочее место можно только от имени разделенного пользователя."
"Текущий пользователь является неразделенным.';uk='Створити автономне робоче місце можна тільки від імені розділеного користувача."
"Поточний користувач є нерозділеним.'");
		
	КонецЕсли;
	
КонецПроцедуры