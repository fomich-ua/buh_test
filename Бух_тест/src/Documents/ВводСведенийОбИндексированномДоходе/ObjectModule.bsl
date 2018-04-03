#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Работники.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();

	Если ДанныеДляПроведения.Количество() > 0 Тогда
		Движения.ИндексированныйДоходСовместителей.Записывать = Истина;
	КонецЕсли; 
		
	Движения.ИндексированныйДоходСовместителей.Загрузить(ДанныеДляПроведения);

	Если ДополнительныеСвойства.Свойство("ОтключитьПроверкуДатыЗапретаИзменения")
		И ДополнительныеСвойства.ОтключитьПроверкуДатыЗапретаИзменения Тогда
		
		Движения.ИндексированныйДоходСовместителей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		
	КонецЕсли;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Работники.Выгрузить();
	
	ДанныеДляПроведения.Колонки.Добавить("Организация");
	ДанныеДляПроведения.ЗаполнитьЗначения(Организация, "Организация"); 
	
	ДанныеДляПроведения.Колонки.Добавить("Период");
	Для Каждого СтрокаТаблицы Из ДанныеДляПроведения Цикл
		СтрокаТаблицы.Период = СтрокаТаблицы.ДатаДействия;		       	
	КонецЦикла;
	
	Возврат ДанныеДляПроведения
	
КонецФункции

#КонецЕсли


