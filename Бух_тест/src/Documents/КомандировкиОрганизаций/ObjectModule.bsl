#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
 
 	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "РаботникиОрганизации.ФизЛицо");
 
КонецПроцедуры
	
	
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ДокументЗаполненПравильно() Тогда
		Отказ = Истина;
	КонецЕсли; 

КонецПроцедуры


Функция ДокументЗаполненПравильно(ТихийРежим = Ложь) Экспорт
	
	ТекстСообщения = "";
	СтруктураСообщений  = Новый Соответствие;
	ДокументЗаполненПравильно = Истина;
	
	КоличествоСтрок = ЭтотОбъект.РаботникиОрганизации.Количество();
	Если КоличествоСтрок > 0 Тогда
		Для Инд = 0 По КоличествоСтрок - 1 Цикл
			
			ТекущаяСтрока = ЭтотОбъект.РаботникиОрганизации[Инд];
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.ДатаНачала) Тогда
					ТекстСообщения = НСтр("ru = '""В строке " + (Инд + 1) + " не указана дата начала командировки.'");
					СтруктураСообщений.Вставить("ДатаНачала",ТекстСообщения);
			КонецЕсли;	
				
			Если ЗначениеЗаполнено(ТекущаяСтрока.ДатаОкончания) Тогда
				Если ТекущаяСтрока.ДатаНачала > ТекущаяСтрока.ДатаОкончания Тогда
					ТекстСообщения = НСтр("ru = '""В строке " + (Инд + 1) + " дата начала больше даты окончания.'");
					СтруктураСообщений.Вставить("ДатаНачала",ТекстСообщения);
				КонецЕсли;
			КонецЕсли;
			ДокументЗаполненПравильно = СтруктураСообщений.Количество() = 0;
			
			Если НЕ ТихийРежим И НЕ ДокументЗаполненПравильно Тогда
				Для каждого Сообщение Из СтруктураСообщений Цикл
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение.Значение,,"Объект" + ?(Сообщение.Ключ = "","",".") + Сообщение.Ключ);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат ДокументЗаполненПравильно;	
	
КонецФункции


#КонецЕсли

