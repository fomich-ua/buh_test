// Описываеть функциональные возможности приложения, 
// в которое внедрена библиотека Зарплата/Кадры
// 
// Параметры:
//	ОписаниеВозможностейОкружения - структура со свойствами:
//		ЕстьОплатаВедомостей - булево; Истина, если окружение умеет оплачивать ведомости на выплату зарплаты
// 
Процедура УстановитьОписаниеВозможностейОкружения(ОписаниеВозможностейОкружения) Экспорт
	
КонецПроцедуры

// Получает "заказанные" значения по умолчанию
// Параметры: 
//		ПолучаемыеЗначения - структура элементы которой имеют 
//			имена, идентифицирующие получаемые значения
//			Могут быть переданы имена значений:
//				Организация - организация по умолчанию
//				Руководитель - руководитель организации
//				ГлавныйБухгалтер - главбух организации
//				ДолжностьРуководителя - должность руководителя организации
//				Подразделение - подразделение по умолчанию
//
// В процедуре значения элементов структуры ПолучаемыеЗначения должны быть заполнены 
// значениями, если это возможно. Если не возможно, то остается то значение, которое 
// было передано в структуре
Процедура ПолучитьЗначенияПоУмолчанию(ПолучаемыеЗначения) Экспорт
	
	Если ПолучаемыеЗначения.Свойство("Организация") Тогда
		Если НЕ ЗначениеЗаполнено(ПолучаемыеЗначения.Организация) Тогда
			ПолучаемыеЗначения.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
		
	Подразделение = Неопределено;
	Если ПолучаемыеЗначения.Свойство("Подразделение") Тогда
		ПолучаемыеЗначения.Подразделение = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");		
		
		Если ЗначениеЗаполнено(ПолучаемыеЗначения.Организация) 
			И ЗначениеЗаполнено(ПолучаемыеЗначения.Подразделение) Тогда
			Если ПолучаемыеЗначения.Подразделение.Владелец <> ПолучаемыеЗначения.Организация Тогда
				ПолучаемыеЗначения.Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();				
			КонецЕсли;
		КонецЕсли;
		
		Подразделение = ПолучаемыеЗначения.Подразделение;
		
	КонецЕсли;
	
	ОтветственныеЛицаОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(ПолучаемыеЗначения.Организация, ТекущаяДата(), Подразделение);
	
	Если ПолучаемыеЗначения.Свойство("Руководитель") Тогда
		ПолучаемыеЗначения.Руководитель = ОтветственныеЛицаОрганизации.Руководитель;
	КонецЕсли;
	
	Если ПолучаемыеЗначения.Свойство("ДолжностьРуководителя") Тогда
		ПолучаемыеЗначения.ДолжностьРуководителя = ОтветственныеЛицаОрганизации.РуководительДолжность;
	КонецЕсли;
	
	Если ПолучаемыеЗначения.Свойство("ГлавныйБухгалтер") Тогда
		ПолучаемыеЗначения.ГлавныйБухгалтер = ОтветственныеЛицаОрганизации.ГлавныйБухгалтер;
	КонецЕсли;

	Если ПолучаемыеЗначения.Свойство("Кассир") Тогда
		ПолучаемыеЗначения.Кассир = ОтветственныеЛицаОрганизации.Кассир;
	КонецЕсли;
	
	Если ПолучаемыеЗначения.Свойство("ДолжностьКассира") Тогда
		ПолучаемыеЗначения.ДолжностьКассира = ОтветственныеЛицаОрганизации.КассирДолжность;
	КонецЕсли;

КонецПроцедуры
