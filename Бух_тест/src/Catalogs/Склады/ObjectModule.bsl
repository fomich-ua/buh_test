#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, существуют ли движения по складу.
// Если есть - менять реквизит "Вид склада" нельзя.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Склад", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|ГДЕ
	|	ХозрасчетныйСубконто.Вид = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
	|	И ХозрасчетныйСубконто.Значение = &Склад"; 

	СтатусВозврата = НЕ Запрос.Выполнить().Пустой();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СтатусВозврата;
	
КонецФункции // СуществуютСсылки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ЭтоНовый()
			И ТипСклада <> Ссылка.ТипСклада
			И СуществуютСсылки() Тогда
			
			ТекстСообщения = НСтр("ru='Существуют документы, в которых выбран склад %1. Реквизит ""Тид склада"" не может быть изменен.';uk='Існують документи в яких обрано склад %1. Реквізит ""Тип складу"" не може бути змінений.'"); 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(Наименование));
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, "Корректность", 
				НСтр("ru='Тип склада';uk='Тип складу'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, 
				"ТипСклада", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТипЦенРозничнойТорговли");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли