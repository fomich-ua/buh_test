
////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОБЕСПЕЧЕНИЯ РАБОТЫ ФОРМ ДОКУМЕНТОВ С ИМУЩЕСТВОМ В ЭКСПЛУАТАЦИИ

// Функция возвращает расшифровку срока полезного использования в годах и 
// месяцах.
//
// Параметры:
//  СрокПолезногоИспользования - срок полезного использования (в месяцах),
//                 подлежащий расшифровке
//
// Возвращаемое значение:
//  Строка       - расшифровка срока полезного использования в годах и 
//                 месяцах
//
Функция РасшифровкаСрокаПолезногоИспользования(СрокПолезногоИспользования) Экспорт
	
	РасшифровкаСрокаПолезногоИспользования = "";
	
	Если ЗначениеЗаполнено(СрокПолезногоИспользования) Тогда
	
		ЧислоЛет     = Цел(СрокПолезногоИспользования / 12);
		ЧислоМесяцев = (СрокПолезногоИспользования % 12);
		
		Если НЕ (ЧислоЛет = 0) Тогда
			
			// Построим строку с числом лет
			Если (СтрДлина(ЧислоЛет) > 1) И (Число(Сред(ЧислоЛет, СтрДлина(ЧислоЛет) - 1, 1)) = 1) Тогда
				СтрокаГод = НСтр("ru=' лет';uk=' років'");
			ИначеЕсли Число(Прав(ЧислоЛет, 1)) = 1 Тогда
				СтрокаГод = НСтр("ru=' год';uk=' рік'");
			ИначеЕсли (Число(Прав(ЧислоЛет, 1)) > 1) И (Число(Прав(ЧислоЛет, 1)) < 5) Тогда
				СтрокаГод = НСтр("ru=' года';uk=' року'");
			Иначе
				СтрокаГод = НСтр("ru=' лет';uk=' років'");
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + Строка(ЧислоЛет) + СтрокаГод;
			
		КонецЕсли;
		
		Если НЕ (ЧислоМесяцев = 0) Тогда
			
			// Построим строку с числом месяцев
			Если (СтрДлина(ЧислоМесяцев) > 1) И (Число(Сред(ЧислоМесяцев, СтрДлина(ЧислоМесяцев) - 1, 1)) = 1) Тогда
				СтрокаМесяц = НСтр("ru=' месяцев';uk=' місяців'");
			ИначеЕсли Число(Прав(ЧислоМесяцев, 1)) = 1 Тогда
				СтрокаМесяц = НСтр("ru=' месяц';uk=' місяць'");
			ИначеЕсли (Число(Прав(ЧислоМесяцев, 1)) > 1) И (Число(Прав(ЧислоМесяцев, 1)) < 5) Тогда
				СтрокаМесяц = НСтр("ru=' месяца';uk=' місяця'");
			Иначе
				СтрокаМесяц = НСтр("ru=' месяцев';uk=' місяців'");
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + ?(НЕ ЗначениеЗаполнено(РасшифровкаСрокаПолезногоИспользования), "", " ") + Строка(ЧислоМесяцев) + СтрокаМесяц;
		
		КонецЕсли;
		
		РасшифровкаСрокаПолезногоИспользования = "(" + РасшифровкаСрокаПолезногоИспользования + ")";
		
	КонецЕсли;
	
	Возврат РасшифровкаСрокаПолезногоИспользования;
	
КонецФункции // РасшифровкаСрокаПолезногоИспользования()

