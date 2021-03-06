#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьПередВыводомЭлементаРезультата",
							Истина, Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Оборотно-сальдовая ведомость';uk='Оборотно-сальдова відомість'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
		
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = НСтр("ru='Показатели';uk='Показники'");
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
		
	ГруппаСальдоНаНачало = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = НСтр("ru='Сальдо на начало периода';uk='Сальдо на початок періоду'");
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаОбороты = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = НСтр("ru='Обороты за период';uk='Обороти за період'");
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСальдоНаКонец = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = НСтр("ru='Сальдо на конец периода';uk='Сальдо на кінець періоду'");
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	  
	ВидОстатков = "";
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатков + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатков + "ОборотКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатков + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("Разница");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "КонечныйОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "КонечныйОстатокКт");
		КонецЕсли;
	КонецЦикла;
  	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Доработка схемы - развернутое сальдо
	НаборДанных = Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконтоРазвернутое; // Набор "ПоСубконтоРазвернутое"
	ТекстЗапроса = НаборДанных.Запрос;
	НаборДанных.Запрос = "";
	
	ТекстЗапросПоСубконтоРазвернутое       = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало ЗапросПоСубконто РазвернутоеСальдо", "//Конец ЗапросПоСубконто РазвернутоеСальдо");
	ТекстУсловиеСчетаПоСубконтоРазвернутое = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало УсловиеСчета РазвернутоеСальдо"    , "//Конец УсловиеСчета РазвернутоеСальдо");
	ТекстСубконтоПоСубконтоРазвернутое     = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало Субконто РазвернутоеСальдо"        , "//Конец Субконто РазвернутоеСальдо");
		
	ВыводитьРазвернутоеСальдо = Ложь;
	
	ТекстУсловие = "Ложь ИЛИ ";
	
	СписокВсехСчетовРазвернутоеСальдо = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.РазвернутоеСальдо Цикл
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда
			СписокВсехСчетовРазвернутоеСальдо.Добавить(СтрокаТаблицы.Счет);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.РазвернутоеСальдо Цикл
		СубконтоРазвернутоеСальдо = Новый СписокЗначений;
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда
			ВыводитьРазвернутоеСальдо = Истина;
			
			ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.Счет);
			СписокВидовСубконто = Новый СписокЗначений;
			КоличествоСубконто = СтрДлина(СтрокаТаблицы.ПоСубконто) / 2;
			Для Индекс = 1 По КоличествоСубконто Цикл
				СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаТаблицы.ПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
			КонецЦикла;
			
			Для Каждого СтрокаТаблицыСубконто Из СписокВидовСубконто Цикл
				Если СтрокаТаблицыСубконто.Пометка Тогда
					СубконтоРазвернутоеСальдо.Добавить(СтрокаТаблицыСубконто.Значение);            
				КонецЕсли;
			КонецЦикла;		
			
			//СписокСчетовРазвернутоеСальдо.Добавить(Строка.Счет, , Истина);
			
			Индекс = ПараметрыОтчета.РазвернутоеСальдо.Индекс(СтрокаТаблицы) + 1;
			
			ТекстУсловие = ТекстУсловие + "Счет = &СчетРазвернутоеСальдо" + Индекс + " ИЛИ "; 
			
			// Формируем текст параметра УсловиеСчета запроса детализации по субконто
			ТекстДляПодстановкиУсловиеСчетаПоСубконтоРазвернутое = "Счет В ИЕРАРХИИ (&СчетРазвернутоеСальдо" + Индекс + ")
																	| И Счет НЕ В (&СчетаИсключенныеИзЗапросаПоСчетамРазвернутое" + Индекс + ")
																	| И ((НЕ Счет.Забалансовый)
																	| ИЛИ &ВыводитьЗабалансовыеСчета)";
			
			// Формируем текст параметра Субконто запроса по субконто развернутое
			ТекстДляПодстановкиСубконтоПоСубконтоРазвернутое = "&СубконтоРазвернутый" + Индекс;
			
			// Установка параметра СчетРазвернутоеСальдо
			БухгалтерскиеОтчетыВызовСервера.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетРазвернутоеСальдо" + Индекс, "СчетРазвернутоеСальдо", СтрокаТаблицы.Счет);
			
			СчетаИсключенныеИзЗапросаПоСчетамРазвернутое = СписокВсехСчетовРазвернутоеСальдо.Скопировать();
			СчетаИсключенныеИзЗапросаПоСчетамРазвернутое.Удалить(СчетаИсключенныеИзЗапросаПоСчетамРазвернутое.НайтиПоЗначению(СтрокаТаблицы.Счет));
			// Установка параметра СчетаИсключенныеИзЗапросаПоСчетамРазвернутое
			БухгалтерскиеОтчетыВызовСервера.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетаИсключенныеИзЗапросаПоСчетамРазвернутое" + Индекс, "СчетаИсключенныеИзЗапросаПоСчетамРазвернутое", СчетаИсключенныеИзЗапросаПоСчетамРазвернутое);
			
			// Установка параметра "СубконтоДетализацииРазвернутый
			БухгалтерскиеОтчетыВызовСервера.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СубконтоРазвернутый" + Индекс, "СубконтоРазвернутый", СубконтоРазвернутоеСальдо);
			
			// Формируем текст запроса для счета детализации
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = ТекстЗапросПоСубконтоРазвернутое;//СтрЗаменить(ТекстЗапросПоСубконтоРазвернутое, ТекстПолеСчетПоСубконтоРазвернутое, ТекстДляПодстановкиПолеСчетПоСубконтоРазвернутое);
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, ТекстУсловиеСчетаПоСубконтоРазвернутое, ТекстДляПодстановкиУсловиеСчетаПоСубконтоРазвернутое);
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, ТекстСубконтоПоСубконтоРазвернутое, ТекстДляПодстановкиСубконтоПоСубконтоРазвернутое);
			
			Для Индекс = 1 По СубконтоРазвернутоеСальдо.Количество() Цикл
				ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, "//Null КАК Субконто" + Индекс, "ОстаткиИОбороты.Субконто" + Индекс + " КАК Субконто" + Индекс);
			КонецЦикла;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + ТекстДляПодстановкиЗапросПоСубконтоРазвернутое;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + " ОБЪЕДИНИТЬ ВСЕ ";
		КонецЕсли;	
	КонецЦикла;
	НаборДанных.Запрос = Лев(НаборДанных.Запрос, СтрДлина(НаборДанных.Запрос) - 16);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	
	Если ВыводитьРазвернутоеСальдо Тогда
		ТекстУсловие = Лев(ТекстУсловие, СтрДлина(ТекстУсловие) - 4);
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокДт) Иначе Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокКт) Иначе Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокДт) Иначе Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокКт) Иначе Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт) Конец";
		КонецЦикла;
	КонецЕсли;
	
	НаборДанных = Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконто; // Набор "ПоСубконто"
	ТекстЗапроса = НаборДанных.Запрос;
	НаборДанных.Запрос = "";
	
	ТекстЗапросДетализацииПоСубконто       = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало ЗапросПоСубконто Детализация", "//Конец ЗапросПоСубконто Детализация");
	ТекстУсловиеСчетаДетализацииПоСубконто = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало УсловиеСчета Детализация", "//Конец УсловиеСчета Детализация");
	ТекстСубконтоДетализацииПоСубконто     = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало Субконто Детализация", "//Конец Субконто Детализация");
	
	СчетаИсключенныеИзЗапросаПоСчетам = Новый СписокЗначений;
	
	// Доработка для детализации
	ЕстьДетализацияПоСубконто = Ложь;
	НужноКорректироватьзапросСКД = Ложь;
	
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл	
		СубконтоДетализации = Новый СписокЗначений;
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда	
			ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.Счет);
			СписокВидовСубконто = Новый СписокЗначений;
			КоличествоСубконто = СтрДлина(СтрокаТаблицы.ПоСубконто) / 2;
			Для Индекс = 1 По КоличествоСубконто Цикл
				СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаТаблицы.ПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
			КонецЦикла;
			
			Для Каждого СтрокаТаблицыСубконто Из СписокВидовСубконто Цикл
				Если СтрокаТаблицыСубконто.Пометка Тогда
					СубконтоДетализации.Добавить(СтрокаТаблицыСубконто.Значение);            
				КонецЕсли;
			КонецЦикла;		
		КонецЕсли;
		
		Если СубконтоДетализации.Количество() > 0 Тогда
			ЕстьДетализацияПоСубконто = Истина;
			
			СчетаИсключенныеИзЗапросаПоСчетам.Добавить(СтрокаТаблицы.Счет);
			Индекс = ПараметрыОтчета.Группировка.Индекс(СтрокаТаблицы) + 1;
			
			// Формируем текст параметра УсловиеСчета запроса детализации по субконто
			ТекстДляПодстановкиУсловиеСчетаДетализацииПоСубконто = "Счет В ИЕРАРХИИ (&СчетДетализации" + Индекс + ")
																   | И ((НЕ Счет.Забалансовый)
																   | ИЛИ &ВыводитьЗабалансовыеСчета)";
											  
			// Формируем текст параметра Субконто запроса детализации по субконто
			ТекстДляПодстановкиСубконтоДетализацииПоСубконто = "&СубконтоДетализации" + Индекс;
			
			// Формируем текст запроса для счета детализации
			ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстЗапросДетализацииПоСубконто, ТекстУсловиеСчетаДетализацииПоСубконто, ТекстДляПодстановкиУсловиеСчетаДетализацииПоСубконто);
			ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, ТекстСубконтоДетализацииПоСубконто, ТекстДляПодстановкиСубконтоДетализацииПоСубконто);
			
			// Доработка текста запроса СКД
			// Для первого запроса секция "{Выбрать..." должна быть 
			Если НужноКорректироватьзапросСКД Тогда
				ТекстЗапросаСКД = "{ВЫБРАТЬ Субконто1Представление, Субконто2Представление, Субконто3Представление, НалоговоеНазначениеПредставление}";
				ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, ТекстЗапросаСКД, "");
			Иначе
				// для последующих запросов секцию "{Выбрать..." нужно убирать
				НужноКорректироватьзапросСКД = Истина;
			КонецЕсли;
			
			// Корректировка текста запроса в зависимости от количества указанных видов субконто
			Если Индекс > 1 Тогда
				Для ИндексПсевдонима = 1 По 3 Цикл
					ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, " КАК Субконто" + ИндексПсевдонима + "Представление", "");
					ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, " КАК Субконто" + ИндексПсевдонима, "");
				КонецЦикла;
			КонецЕсли;
			
			Для ИндексСубконто = СубконтоДетализации.Количество() + 1 По 3 Цикл
				ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, "ОстаткиИОбороты.Субконто" + ИндексСубконто , "Null");
			КонецЦикла;
			
			ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, "ПРЕДСТАВЛЕНИЕССЫЛКИ(Null)" , """""");
			
			// Добавление и установка значения параметра СчетДетализации{Индекс}
			
			БухгалтерскиеОтчетыВызовСервера.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетДетализации" + Индекс, "СчетДетализации", СтрокаТаблицы.Счет);
			
			// Добавление и установка значения параметра СубконтоДетализации{Индекс}
			БухгалтерскиеОтчетыВызовСервера.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СубконтоДетализации" + Индекс, "СубконтоДетализации", СубконтоДетализации);
							
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + ТекстДляПодстановкиЗапросДетализацииПоСубконто;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + " ОБЪЕДИНИТЬ ВСЕ ";
			
		КонецЕсли;
	КонецЦикла;
	
	НаборДанных.Запрос = Лев(НаборДанных.Запрос, СтрДлина(НаборДанных.Запрос) - 16);
	
	Схема.Параметры.ВыводитьЗабалансовыеСчета.Значение = Истина;
	
	Схема.Параметры.СчетаИсключенныеИзЗапросаПоСчетам.Значение = СчетаИсключенныеИзЗапросаПоСчетам;
	
	Если Не ЕстьДетализацияПоСубконто Тогда
		Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.Удалить(Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконто);
	КонецЕсли;
	Если Не ВыводитьРазвернутоеСальдо Тогда
		Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.Удалить(Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконтоРазвернутое);
	КонецЕсли;
		
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	
	Для Каждого Параметр Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		Параметр.Использование = Истина;
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаИсключенныеИзЗапросаПоСчетам", СчетаИсключенныеИзЗапросаПоСчетам);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВыводитьЗабалансовыеСчета", ПараметрыОтчета.ВыводитьЗабалансовыеСчета);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru='Уменьшенный автоотступ';uk='Зменшений автовідступ'") Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru='Уменьшенный автоотступ';uk='Зменшений автовідступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	// Формирование структуры отчета
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
	ПолеОформления.Поле = ПолеГруппировки.Поле;
	
	// Установка отбора на выводимый уровень иерархии счета
	ГруппаЭлементовОтбора = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
	ГруппаЭлементовОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "ПараметрыДанных.ПоСубсчетам", Истина);
	
	ИспользоватьКлассыСчетовВКачествеГрупп = БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп();
	КоличествоУровнейСчет = ?(ИспользоватьКлассыСчетовВКачествеГрупп, 2, 1);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "СистемныеПоля.УровеньВГруппировке", КоличествоУровнейСчет, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	
	СписокСчетовПоСубсчетам = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовПоСубсчетам(ПараметрыОтчета.Группировка);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "Счет", СписокСчетовПоСубсчетам, ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии, СписокСчетовПоСубсчетам.Количество() > 0);

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПоСубсчетам", ПараметрыОтчета.ПоСубсчетам);
	
	// Отключим вывод отборов
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));		
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
	КонецЕсли;
	
	Если ЕстьДетализацияПоСубконто Тогда
		Для Индекс = 1 По 3 Цикл 
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Субконто" + Индекс);
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
			
			Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));		
				ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Использование  = Истина;
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				
				Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
				
				ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
				ПолеОформления.Поле = ПолеГруппировки.Поле;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборДляПоказателяРазница(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.НУНачальныйОстатокДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.РазницаНачальныйОстатокДт");
	
	// Отключим использование этого элемента условного оформления в общих итогах
	УсловноеОформление.ИспользоватьВОбщемИтоге = ИспользованиеУсловногоОформленияКомпоновкиДанных.НеИспользовать;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "Счет.НалоговыйУчет", Ложь);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КоличествоГруппировок = 0;
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			КоличествоСубконто = СтрЧислоВхождений(СтрокаТаблицы.ПоСубконто, "+");
			КоличествоГруппировок = Макс(КоличествоГруппировок, КоличествоСубконто);
		КонецЕсли;
	КонецЦикла;
	КоличествоГруппировок = КоличествоГруппировок + 1;

	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = 0 По КоличествоКолонок - 1 Цикл
			
			Если ИндексКолонки < КоличествоКолонок - 6 Тогда
				Продолжить;	
			КонецЕсли;	
			
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
			СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
			
			КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
			
			Если КоличествоКолонок < 7 Тогда
				Продолжить;
			КонецЕсли;	
			
			Ячейка = СтрокаМакета.Ячейки[КоличествоКолонок - 7];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЕсли;	
	
	МакетПодвалаОтчета            = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчет          = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
	МакетГруппировкиПодразделение = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение");
	МакетГруппировкиВалюта        = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе
			Индекс = -1;
			МассивПоказателей = Новый Массив;
			МассивПоказателей.Добавить("БУ");
			МассивПоказателей.Добавить("НУ");
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			Если ПараметрыОтчета.ПоказательРазница Тогда 
				Индекс = Индекс + 1;					
			КонецЕсли;
			
			Если ПараметрыОтчета.ПоказательВалютнаяСумма И КоличествоПоказателей = 1 Тогда 
				
			ИначеЕсли ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
				Индекс = Индекс + 1;				
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено Тогда
					
				Иначе
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
					Индекс = Индекс - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоПоказателей = КоличествоПоказателей;
	Если КоличествоПоказателей > 0 Тогда
		ЗначенияПоказателей = Новый Массив(6, КоличествоПоказателей);
		Для Каждого Массив Из ЗначенияПоказателей Цикл
			Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
				Массив[Индекс] = 0;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	МассивИменМакетовСчет = Новый Массив;
	Для Каждого МакетСчет Из МакетГруппировкиСчет Цикл
		МассивИменМакетовСчет.Добавить(МакетСчет.Имя);
	КонецЦикла;
	
	МассивИменМакетовВалюта = Новый Массив;
	Для Каждого МакетВалюта Из МакетГруппировкиВалюта Цикл
		МассивИменМакетовВалюта.Добавить(МакетВалюта.Имя);
	КонецЦикла;
	
	ВременныеДанныеОтчета = Новый Структура;
	ВременныеДанныеОтчета.Вставить("МакетВалюта"          , МассивИменМакетовВалюта);
	ВременныеДанныеОтчета.Вставить("МакетШапкиОтчета"     , МакетШапкиОтчета.Имя);
	ВременныеДанныеОтчета.Вставить("МакетСчет"            , МассивИменМакетовСчет);
	Если МакетПодвалаОтчета = Неопределено Тогда
		ВременныеДанныеОтчета.Вставить("МакетПодвал"          , Неопределено);
	Иначе	
		ВременныеДанныеОтчета.Вставить("МакетПодвал"          , МакетПодвалаОтчета.Имя);
	КонецЕсли;
	ВременныеДанныеОтчета.Вставить("КоличествоПоказателей", КоличествоПоказателей);
	ВременныеДанныеОтчета.Вставить("ЗначенияПоказателей"  , ЗначенияПоказателей);
	
	СмещениеПоСтроке = МакетШапкиОтчета.Макет[0].Ячейки.Количество() - 7;
	ВременныеДанныеОтчета.Вставить("СмещениеПоСтроке", СмещениеПоСтроке);
	
	ПараметрыОтчета.Вставить("ВременныеДанныеОтчета", ВременныеДанныеОтчета);
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(ПараметрыОтчета, МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	
	// Отсекаем валютные группировки на счетах, по которым не ведется
	// валютный учет
	Если ЭлементРезультата.ЗначенияПараметров.Количество() > 0
		И ЭлементРезультата.ЗначенияПараметров.Найти("П1") <> Неопределено
		И ЗначениеЗаполнено(ЭлементРезультата.Макет)
		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетВалюта.Найти(ЭлементРезультата.Макет) <> Неопределено
		И ЭлементРезультата.ЗначенияПараметров.П1.Значение = Null Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма
		И ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей > 1 Тогда
		КоличествоПоказателей = ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей - 1;
	Иначе
		КоличествоПоказателей = ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей;
	КонецЕсли;
	
	// Обрабатываем элементы, содержащие корневые счета
	Если ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
		И ЭлементРезультата.ЗначенияПараметров.Найти("П1") <> Неопределено
		И ЗначениеЗаполнено(ЭлементРезультата.Макет)
		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетШапкиОтчета <> ЭлементРезультата.Макет
		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетПодвал <> ЭлементРезультата.Макет Тогда
		
		//Накапливаем суммы по корневым счетам
		Если ПараметрыОтчета.ВременныеДанныеОтчета.МакетСчет.Найти(ЭлементРезультата.Макет) <> Неопределено Тогда
			ИдентификаторРасшифровки = ЭлементРезультата.ЗначенияПараметров.П2.Значение;
			ЗначениеСчет = ДанныеРасшифровки.Элементы[ИдентификаторРасшифровки].ПолучитьПоля()[0].Значение;
			Если Не ЗначениеЗаполнено(ЗначениеСчет.Родитель) И Не ЗначениеСчет.Забалансовый Тогда
				Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
					Для ПодИндекс = 1 По 6 Цикл
						
						ИндексЯчейки = ПодИндекс + ПараметрыОтчета.ВременныеДанныеОтчета.СмещениеПоСтроке;
						
						Если ИндексЯчейки < 0 Тогда
							Продолжить;
						КонецЕсли;
					
						СтрокаМакета = МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет[Индекс];
						Ячейка = СтрокаМакета.Ячейки[ИндексЯчейки];
						
						Если Ячейка.Элементы.Количество() = 0 Тогда
							Продолжить;
						КонецЕсли;
						
						ИмяПараметра = Строка(Ячейка.Элементы[0].Значение);
						ПараметрРезультата = ЭлементРезультата.ЗначенияПараметров.Найти(ИмяПараметра);
						
						Если (Не ЗначениеСчет.НалоговыйУчет И Индекс = (КоличествоПоказателей - 1)
							И ПараметрыОтчета.ПоказательРазница) ИЛИ ПараметрРезультата = Неопределено Тогда
							Значение = 0;
						Иначе
							Значение = ПараметрРезультата.Значение;
							Если Значение = Null Тогда 
								Значение = 0;
							КонецЕсли;
						КонецЕсли;
						
						ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс] = ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс] + Значение;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли; 
		
		// Проставляем накопленные суммы в подвал отчета
	ИначеЕсли ЭлементРезультата.Макет = ПараметрыОтчета.ВременныеДанныеОтчета.МакетПодвал Тогда
		Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
			Для ПодИндекс = 1 По 6 Цикл
				СтрокаМакета = МакетКомпоновки.Макеты[ПараметрыОтчета.ВременныеДанныеОтчета.МакетПодвал].Макет[Индекс];
				
				ИндексЯчейки = ПодИндекс + ПараметрыОтчета.ВременныеДанныеОтчета.СмещениеПоСтроке;
				
				Если ИндексЯчейки < 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Ячейка = СтрокаМакета.Ячейки[ИндексЯчейки];
				
				Если Ячейка.Элементы.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				ИмяПараметра = Строка(Ячейка.Элементы[0].Значение);
				
				ПараметрРезультата = ЭлементРезультата.ЗначенияПараметров.Найти(ИмяПараметра);
				
				Если ПараметрРезультата <> Неопределено Тогда
					
					ПараметрРезультата.Значение = ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс];
			
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = 0;	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("Разница");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли