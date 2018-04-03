#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьВнешниеНаборыДанных,
							|ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Ложь, Ложь, Ложь);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Задолженность покупателей по срокам долга на ';uk='Заборгованість покупців по строках боргу на '") + Формат(ПараметрыОтчета.Период, "ДФ=dd.MM.yyyy; ДП=...");
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ПросроченнаяЗадолженность = ПолучитьПросроченнуюЗадолженность(ПараметрыОтчета, ПараметрыОтчета.Период);

	ВнешниеНаборыДанных = Новый Структура("ПросроченнаяЗадолженность", ПросроченнаяЗадолженность);
	
	Возврат ВнешниеНаборыДанных;
		                                
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(1);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период", КонецДня(ПараметрыОтчета.Период) + 1);
	
	ВыводитьДиаграмму = Неопределено;
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			ЭлементСтруктуры.Использование = ВыводитьДиаграмму;
		КонецЕсли;		
	КонецЦикла;
	
	КоличествоИнтервалов = ПараметрыОтчета.Интервалы.Количество();
	
	// Доработка схемы под заданные интервалы
	Схема.НаборыДанных.ОсновнойНабор.Запрос = ПолучитьТекстЗапроса(КоличествоИнтервалов);
	
	УстановитьПараметры(ПараметрыОтчета, Схема, КомпоновщикНастроек);
	
	ЗаполнитьПоляВСоответствииСоСпискомИнтервалов(ПараметрыОтчета, Схема, КомпоновщикНастроек);
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПокупателейПоСрокамДолга").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПокупателями, "");
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры


// Формирует таблицу данных для монитора руководителя по организации на дату
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаЗадолженности - Дата - дата на которую нужны остатки
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьПросроченнуюЗадолженностьПокупателейДляМонитораРуководителя(Организация, ДатаЗадолженности) Экспорт
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(Организация);
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("Период", Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	
	СубконтоКонтрагентДоговор = Новый СписокЗначений;
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговор", СубконтоКонтрагентДоговор);
	Запрос.УстановитьПараметр("СтандартныйСрокОплаты", Константы.СрокОплатыПокупателей.Получить());
	
	СписокСчетов = МониторРуководителя.СчетаРасчетовСКонтрагентами(1);
	Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	                |	ХозрасчетныйОстатки.Субконто2 КАК Договор,
	                |	ВЫБОР
	                |		КОГДА ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
	                |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
	                |		ИНАЧЕ &СтандартныйСрокОплаты
	                |	КОНЕЦ КАК СрокОплаты,
	                |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокДт КАК ОстатокДолга,
	                |	ХозрасчетныйОстатки.Счет
	                |ПОМЕСТИТЬ Остатки
	                |ИЗ
	                |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	                |			&Период,
	                |			Счет В (&СписокСчетов),
	                |			&СубконтоКонтрагентДоговор,
	                |			Организация В (&Организация)
	                |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))) КАК ХозрасчетныйОстатки
	                |ГДЕ
	                |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокДт > 0
	                |
	                |ИНДЕКСИРОВАТЬ ПО
	                |	Контрагент
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	ОстаткиДолга.Контрагент КАК Контрагент,
	                |	ОстаткиДолга.Договор КАК Договор,
	                |	СУММА(ОстаткиДолга.ОстатокДолга) КАК ОстатокДолга
	                |ПОМЕСТИТЬ ОстаткиДолга
	                |ИЗ
	                |	Остатки КАК ОстаткиДолга
	                |
	                |СГРУППИРОВАТЬ ПО
	                |	ОстаткиДолга.Контрагент,
	                |	ОстаткиДолга.Договор
	                |
	                |ИНДЕКСИРОВАТЬ ПО
	                |	Контрагент,
	                |	Договор
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                |	Остатки.СрокОплаты КАК СрокОплаты
	                |ИЗ
	                |	Остатки КАК Остатки
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	СрокОплаты УБЫВ";
	
	// Для расчета просроченной задолженности сначала получаем остатки задолженнности
	// на интересующую нас дату, в разрезе Контрагентов Договоров и Сроков оплаты
	Результат = Запрос.Выполнить();
	
	// Получаем массив сроков оплаты
	СрокиОплаты = Результат.Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("СрокОплаты");
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	Если СрокиОплаты.Количество() > 0 Тогда
		
		МаксимальныйИндекс = СрокиОплаты.ВГраница();
		
		ТекстЗапросаПоСрокамДолга = "";
		ТекстОкончанияЗапроса = "";
		
		// Условие для подстановки в шаблон запроса
		ТекстУсловия = "ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В 
			|(ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), 
			|ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))";
		
		// Добавляем в запрос временнные таблицы с расчетом задолженности на интересющую дату - СрокОплаты
		Для ИндексСрокаОплаты = 0 По МаксимальныйИндекс Цикл
			
			// Добавляем параметры в запрос
			Запрос.УстановитьПараметр("НачалоПериода" + ИндексСрокаОплаты, Новый Граница(НачалоДня(ДатаЗадолженности - 60*60*24* СрокиОплаты[ИндексСрокаОплаты]), ВидГраницы.Включая));
			Запрос.УстановитьПараметр("Период" + ИндексСрокаОплаты, Новый Граница(КонецДня(ДатаЗадолженности - 60*60*24* СрокиОплаты[ИндексСрокаОплаты]), ВидГраницы.Включая));
			Запрос.УстановитьПараметр("СрокОплаты" + ИндексСрокаОплаты, СрокиОплаты[ИндексСрокаОплаты]);
			
			// Инициализируем имена парметров будем подставлять в шаблон текста запроса
			СтруктураПараметров = Новый Структура;
			
			СтруктураПараметров.Вставить("НачалоПериода", "НачалоПериода" + ИндексСрокаОплаты);
			СтруктураПараметров.Вставить("Период", "Период" + ИндексСрокаОплаты);
			СтруктураПараметров.Вставить("СрокОплаты", "СрокОплаты" + ИндексСрокаОплаты);
			СтруктураПараметров.Вставить("Остатки", "Остатки"  + ИндексСрокаОплаты); 
			СтруктураПараметров.Вставить("ОстаткиНаНачалоСрока", "ОстаткиНаНачалоСрока"  + ИндексСрокаОплаты); 
			СтруктураПараметров.Вставить("ОборотыЗаПериод", "ОборотыЗаПериод" + ИндексСрокаОплаты); 
			СтруктураПараметров.Вставить("ПросроченнаяЗадолженность", "ПросроченнаяЗадолженность" + ИндексСрокаОплаты); 
			СтруктураПараметров.Вставить("СуммаОборот", "СуммаОборотКт"); 
			СтруктураПараметров.Вставить("СуммаОстаток", "СуммаРазвернутыйОстатокДт"); 
			СтруктураПараметров.Вставить("ТекстУсловия", ТекстУсловия); 
			
			ТекстЗапросаПоСрокамДолга = ТекстЗапросаПоСрокамДолга + СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(МониторРуководителя.ШаблонЗапросаПоПросроченнойЗадолженнсти(), СтруктураПараметров);
			
			ТекстОкончанияЗапроса = ТекстОкончанияЗапроса + СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(МониторРуководителя.ШаблонЗапросаОбъединениеПросроченнойЗадолженнсти(), СтруктураПараметров);
			
			Если  ИндексСрокаОплаты < МаксимальныйИндекс Тогда
				
				ТекстОкончанияЗапроса = ТекстОкончанияЗапроса + "ОБЪЕДИНИТЬ ВСЕ
				|";
				
			КонецЕсли;
		КонецЦикла;
		
		// Соберем полный текст запроса и добавим упорядочивание по сумме
		Запрос.Текст = ТекстЗапросаПоСрокамДолга + ТекстОкончанияЗапроса + "
			|УПОРЯДОЧИТЬ ПО
			|	Сумма Убыв";
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
		УстановитьПривилегированныйРежим(Ложь);
		
		
		Для ИндексСтроки = 0 По Мин(2, Результат.Количество() - 1) Цикл
			
			СтрокаРезультата = Результат[ИндексСтроки];
			Контрагент = СтрокаРезультата.Контрагент;
			
			СтрокаДанных = ТаблицаДанных.Добавить();
			СтрокаДанных.Представление 		= Контрагент;
			СтрокаДанных.ДанныеРасшифровки	= Контрагент;
			СтрокаДанных.Порядок 			= 1;
			СтрокаДанных.Сумма 				= СтрокаРезультата.Сумма;
			
		КонецЦикла;   
		
		// Добавляем итог по разделу
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.Представление 	= НСтр("ru='Итого';uk='Разом'");
		СтрокаДанных.Сумма 			= Результат.Итог("Сумма");
		
	КонецЕсли;
	
	Возврат ТаблицаДанных;			   
	
КонецФункции 



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоляВСоответствииСоСпискомИнтервалов(ПараметрыОтчета, Схема, КомпоновщикНастроек)
	
	КоличествоПолейПериодов = Схема.НаборыДанных.ОсновнойНабор.Поля.Количество() - 5;
	Для Индекс = 1 По КоличествоПолейПериодов Цикл
		ПолеДляУдаления = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти("ОстатокПериода" + Индекс);
		Если ПолеДляУдаления <> Неопределено Тогда
			Схема.НаборыДанных.ОсновнойНабор.Поля.Удалить(ПолеДляУдаления);
		КонецЕсли; 
	КонецЦикла;
	
	Схема.ПоляИтога.Очистить();
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = "ОстатокДолга";
	ПолеИтога.Выражение   = "Сумма(ОстатокДолга)";
	
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = "ПросроченнаяЗадолженность";
	ПолеИтога.Выражение   = "Сумма(ПросроченнаяЗадолженность)";	
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ОстатокДолга");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ПросроченнаяЗадолженность");
	                                                                            
	ПапкаСПолями = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ПапкаСПолями.Заголовок = НСтр("ru='Общая задолженность по срокам долга';uk='Загальна заборгованість по строках боргу'");
	Индекс = 1;
	ЗначениеПоследнего = 0;
	Для Каждого Интервал Из ПараметрыОтчета.Интервалы Цикл
		ИмяПоля = "ОстатокПериода" + Индекс;
		Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти(ИмяПоля);
		Если Поле = Неопределено Тогда
			Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		КонецЕсли;
		Поле.Поле        = ИмяПоля;
		Поле.ПутьКДанным = ИмяПоля;
		Поле.Заголовок   = Интервал.Представление;
		Поле.ТипЗначения = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "Формат", "ЧЦ=15; ЧДЦ=0");
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МинимальнаяШирина", 15);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МаксимальнаяШирина", 15);
		Поле.ОграничениеИспользования.Группировка = Ложь;
		Поле.ОграничениеИспользованияРеквизитов.Группировка = Ложь;
		
		ПолеИтога = Схема.ПоляИтога.Добавить();
		ПолеИтога.ПутьКДанным = ИмяПоля;
		ПолеИтога.Выражение   = "Сумма(" + ИмяПоля + ")";
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПапкаСПолями, ИмяПоля);
		Индекс = Индекс + 1;
		ЗначениеПоследнего = Интервал.Значение;
	КонецЦикла;
	
	ИмяПоля = "ОстатокПериода" + Индекс;
	Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти(ИмяПоля);
	Если Поле = Неопределено Тогда
		Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	КонецЕсли;
	Поле.Поле        = ИмяПоля;
	Поле.ПутьКДанным = ИмяПоля;	
	Поле.Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Свыше %1 дней';uk='Понад %1 днів'"), ЗначениеПоследнего);
	Поле.ТипЗначения = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "Формат", "ЧЦ=15; ЧДЦ=0");
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МинимальнаяШирина", 15);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МаксимальнаяШирина", 15);
	
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = ИмяПоля;
	ПолеИтога.Выражение   = "Сумма(" + ИмяПоля + ")";
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПапкаСПолями, ИмяПоля);
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			ЭлементСтруктуры.Выбор.Элементы.Очистить();
			Для Каждого ВыбранноеПоле Из ПапкаСПолями.Элементы Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ЭлементСтруктуры.Выбор, ВыбранноеПоле.Поле);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТекстЗапроса(КоличествоИнтервалов)
	
	ПолныйТекстЗапроса = 
	"
	|	ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СчетаКонтрагентов.Ссылка КАК Счет
	|ПОМЕСТИТЬ СчетаКД
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК СчетаКонтрагентов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ХозрасчетныйВидыСубконто.Ссылка КАК Ссылка
	|		ИЗ
	|			ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|		ГДЕ
	|			ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)) КАК СчетаДоговоров
	|		ПО СчетаКонтрагентов.Ссылка = СчетаДоговоров.Ссылка
	|ГДЕ
	|	СчетаКонтрагентов.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
	|	И НЕ СчетаКонтрагентов.Ссылка.Забалансовый
	|	И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (&ИсключенныеСчета)
	|	И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогамИПлатежам))
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВзаиморасчетыОстатки.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
	|	ВзаиморасчетыОстатки.Счет КАК Счет,
	|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК ОстатокДолга0
	|ПОМЕСТИТЬ ВзаиморасчетыОстатки
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Контрагент.*,
	|	Договор.*,
	|	Счет КАК ОстатокДолга}
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В
	|				(ВЫБРАТЬ
	|					СчетаКД.Счет
	|				ИЗ
	|					СчетаКД КАК СчетаКД),
	|			&ВидыСубконтоКД,
	|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером)) {(Организация).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор}) КАК ВзаиморасчетыОстатки

	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыОбороты.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
		|	ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|		ИНАЧЕ 0
		|	КОНЕЦ - ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК УвеличениеДолга" + Индекс + "
		|ПОМЕСТИТЬ Обороты" + Индекс + "
		|{ВЫБРАТЬ
		|	Организация.*,
		|	Контрагент.*,
		|	Договор.*}
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоИнтервала" + Индекс + ",
		|			&КонецИнтервала" + Индекс + ",
		|			,
		|			Счет В
		|				(ВЫБРАТЬ
		|					СчетаКД.Счет
		|				ИЗ
		|					СчетаКД КАК СчетаКД),
		|			&ВидыСубконтоКД,
 		|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером)) {(Организация).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор},
		|			,
		|			) КАК ВзаиморасчетыОбороты
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	Контрагент,
		|	Договор	
		|";
	КонецЦикла;
	
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|;
    |////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Счет,
	|	ВзаиморасчетыОстатки.Организация,
	|	ВзаиморасчетыОстатки.Контрагент,
	|	ВзаиморасчетыОстатки.Договор,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|	ЕСТЬNULL(Обороты" + Индекс + ".УвеличениеДолга" + Индекс + ", 0) КАК УвеличениеДолга" + Индекс + ",
		|";
	КонецЦикла;
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	ВзаиморасчетыОстатки.ОстатокДолга0
	|ПОМЕСТИТЬ ОстатокИОбороты
	|ИЗ
	|	ВзаиморасчетыОстатки КАК ВзаиморасчетыОстатки
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|		ЛЕВОЕ СОЕДИНЕНИЕ Обороты" + Индекс + " КАК Обороты" + Индекс + "
		|		ПО ВзаиморасчетыОстатки.Организация = Обороты" + Индекс + ".Организация
		|			И ВзаиморасчетыОстатки.Контрагент = Обороты" + Индекс + ".Контрагент
		|			И ВзаиморасчетыОстатки.Договор = Обороты" + Индекс + ".Договор
		|";
	КонецЦикла;
	
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстатокИОбороты.Организация,
	|	ОстатокИОбороты.Контрагент,
	|	ОстатокИОбороты.Договор,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ТекстПоля = "ОстатокИОбороты.ОстатокДолга0";
		Для ПодИндекс = 1 По Индекс Цикл
			ТекстПоля = ТекстПоля + " - ОстатокИОбороты.УвеличениеДолга" + ПодИндекс;
		КонецЦикла;
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|	ВЫБОР
		|		КОГДА " + ТекстПоля + " > 0
		|			ТОГДА " + ТекстПоля + "
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ОстатокДолга" + Индекс + ",
		|";
	КонецЦикла;

	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	
	|	ОстатокИОбороты.ОстатокДолга0
	|ПОМЕСТИТЬ ОстаткиПоПериодам
	|ИЗ
	|	ОстатокИОбороты КАК ОстатокИОбороты
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиПоПериодам.Организация КАК Организация,
	|	ОстаткиПоПериодам.Контрагент КАК Контрагент,
	|	ОстаткиПоПериодам.Договор КАК Договор,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ТекстПоля = "	ОстаткиПоПериодам.ОстатокДолга" + (Индекс - 1) + " - ОстаткиПоПериодам.ОстатокДолга" + Индекс + " КАК ОстатокПериода" + Индекс + ",";
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + Символы.ПС + ТекстПоля + Символы.ПС;
	КонецЦикла;
		
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	ОстаткиПоПериодам.ОстатокДолга" + КоличествоИнтервалов + " КАК ОстатокПериода" + (КоличествоИнтервалов + 1) + ", 
	|	ОстаткиПоПериодам.ОстатокДолга0 КАК ОстатокДолга
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Контрагент.*,
	|	Договор.*,
	|";
	Для Индекс = 1 По КоличествоИнтервалов + 1 Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + Символы.ПС + "	ОстатокПериода" + Индекс + ",";
	КонецЦикла;
	ПолныйТекстЗапроса = ПолныйТекстЗапроса +
	"
	|	ОстатокДолга}
	|ИЗ
	|	ОстаткиПоПериодам КАК ОстаткиПоПериодам
	|{ГДЕ
	|	ОстаткиПоПериодам.Организация.*,
	|	ОстаткиПоПериодам.Контрагент.*,
	|	ОстаткиПоПериодам.Договор.*}";
	
	Возврат ПолныйТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметры(ПараметрыОтчета, Схема, КомпоновщикНастроек)

	Сутки = 60 * 60 * 24;
	
	ТабИнтервалы = Новый ТаблицаЗначений;
	ТабИнтервалы.Колонки.Добавить("НомерИнтервала");
	ТабИнтервалы.Колонки.Добавить("НачалоИнтервала");
	ТабИнтервалы.Колонки.Добавить("КонецИнтервала");
	
	ДатаКон = ?(ПараметрыОтчета.Период = '00010101', ТекущаяДата(), ПараметрыОтчета.Период);
	ПараметрыОтчета.Интервалы.Сортировать("Значение Воз");
	Индекс = 1;
	Первый = Истина;
	ПредыдущееЗначение = 0;
	Для Каждого Интервал Из ПараметрыОтчета.Интервалы Цикл
		НоваяСтрока = ТабИнтервалы.Добавить();
		НоваяСтрока.НомерИнтервала = Индекс;
		Если Первый Тогда  
			НоваяСтрока.НачалоИнтервала = НачалоДня(ДатаКон) - Интервал.Значение * Сутки;
			НоваяСтрока.КонецИнтервала  = КонецДня(ДатаКон);
			ПредыдущееЗначение = Интервал.Значение;
			Первый = Ложь;
		Иначе
			НоваяСтрока.НачалоИнтервала = НачалоДня(ДатаКон) - Интервал.Значение * Сутки;
			НоваяСтрока.КонецИнтервала  = КонецДня(ДатаКон)  - (ПредыдущееЗначение + 1) * Сутки;
			ПредыдущееЗначение = Интервал.Значение;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Для каждого СтрокаИнтервала из ТабИнтервалы Цикл
		ИмяПараметра = "НачалоИнтервала" + СтрокаИнтервала.НомерИнтервала;
		Параметр = Схема.Параметры.Найти(ИмяПараметра);
		Если Параметр = Неопределено Тогда
			Параметр = Схема.Параметры.Добавить();
			Параметр.Имя = ИмяПараметра;
		КонецЕсли;
		
		ИмяПараметра = "КонецИнтервала" + СтрокаИнтервала.НомерИнтервала;
		Параметр = Схема.Параметры.Найти(ИмяПараметра);
		Если Параметр = Неопределено Тогда
			Параметр = Схема.Параметры.Добавить();
			Параметр.Имя = ИмяПараметра;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	
	Для каждого СтрокаИнтервала из ТабИнтервалы Цикл
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоИнтервала" + СтрокаИнтервала.НомерИнтервала, СтрокаИнтервала.НачалоИнтервала);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецИнтервала" + СтрокаИнтервала.НомерИнтервала, СтрокаИнтервала.КонецИнтервала);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПросроченнуюЗадолженность(ПараметрыОтчета, КонДата)
	
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыСубконтоКД", ВидыСубконтоКД);
	Запрос.УстановитьПараметр("ГраницаОстатков", Новый Граница(КонецДня(КонДата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("СтандартныйСрокОплатыПокупателей", Константы.СрокОплатыПокупателей.Получить());
	Запрос.УстановитьПараметр("КонецИнтервала", КонецДня(КонДата));
	Запрос.УстановитьПараметр("ИсключенныеСчета", БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(1));
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапросаПоОстаткам = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СчетаКонтрагентов.Ссылка КАК Счет
	|ПОМЕСТИТЬ СчетаКД
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК СчетаКонтрагентов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ХозрасчетныйВидыСубконто.Ссылка КАК Ссылка
	|		ИЗ
	|			ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|		ГДЕ
	|			ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)) КАК СчетаДоговоров
	|		ПО СчетаКонтрагентов.Ссылка = СчетаДоговоров.Ссылка
	|ГДЕ
	|	СчетаКонтрагентов.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
	|	И НЕ СчетаКонтрагентов.Ссылка.Забалансовый
	|	И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (&ИсключенныеСчета)
	|	И НЕ СчетаКонтрагентов.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогамИПлатежам))
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.Контрагент КАК Контрагент,
	|	ВложенныйЗапрос.Договор КАК Договор,
	|	ВложенныйЗапрос.СрокОплаты КАК СрокОплаты,
	|	ВложенныйЗапрос.СуммаОстаток КАК ОстатокДолга
	|ПОМЕСТИТЬ ОстаткиДолга
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыОстатки.Организация КАК Организация,
	|		ВзаиморасчетыОстатки.Субконто1 КАК Контрагент,
	|		ВзаиморасчетыОстатки.Субконто2 КАК Договор,
	|		ВЫБОР
	|			КОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
	|				ТОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
	|			ИНАЧЕ &СтандартныйСрокОплатыПокупателей
	|		КОНЕЦ КАК СрокОплаты,
	|		ВзаиморасчетыОстатки.Счет КАК Счет,
	|		ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК СуммаОстаток
	|	ИЗ
	|		РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&ГраницаОстатков,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|				&ВидыСубконтоКД,
	|				ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|					И Организация = &Организация) КАК ВзаиморасчетыОстатки) КАК ВложенныйЗапрос
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контрагент,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОстаткиДолга.СрокОплаты КАК СрокОплаты
	|ИЗ
	|	ОстаткиДолга КАК ОстаткиДолга
	|
	|УПОРЯДОЧИТЬ ПО
	|	СрокОплаты";
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстЗапросаПоОстаткам = СтрЗаменить(ТекстЗапросаПоОстаткам, "И Организация = &Организация", "");
	КонецЕсли;
	Запрос.Текст = ТекстЗапросаПоОстаткам;
	
	МассивСроковОплаты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СрокОплаты");
	
	Если МассивСроковОплаты.Количество() = 0 Тогда
		МассивСроковОплаты.Добавить(0);
	КонецЕсли;
	
	ТекстОстатки = 
	"ВЫБРАТЬ
	|	ОстаткиДолга.Организация,
	|	ОстаткиДолга.Контрагент,
	|	ОстаткиДолга.Договор,
	|	ОстаткиДолга.СрокОплаты,
	|	ОстаткиДолга.ОстатокДолга,
	|	СУММА(ЕСТЬNULL(Обороты.УвеличениеДолга, 0)) КАК УвеличениеДолга
	|ИЗ
	|	ОстаткиДолга КАК ОстаткиДолга";
	
	ТекстОборотыПоСроку = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация КАК Организация,
	|	ВзаиморасчетыОбороты.Субконто1 КАК Контрагент,
	|	ВзаиморасчетыОбороты.Субконто2 КАК Договор,
	|	ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК УвеличениеДолга
	|ПОМЕСТИТЬ Обороты1
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала1,
	|			&КонецИнтервала,
	|			,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|			&ВидыСубконтоКД,
	|			(Субконто1, Субконто2) В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОстаткиДолга.Контрагент,
	|						ОстаткиДолга.Договор
	|					ИЗ
	|						ОстаткиДолга КАК ОстаткиДолга
	|					ГДЕ
	|						ОстаткиДолга.СрокОплаты = &СрокОплаты1)
	|				И Организация = &Организация,
	|			,
	|			) КАК ВзаиморасчетыОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация,
	|	ВзаиморасчетыОбороты.Субконто1,
	|	ВзаиморасчетыОбороты.Субконто2,
	|	-(ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
	|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ)
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала1,
	|			&КонецИнтервала,
	|			,
	|				Счет В
	|					(ВЫБРАТЬ
	|						СчетаКД.Счет
	|					ИЗ
	|						СчетаКД КАК СчетаКД),
	|			&ВидыСубконтоКД,
	|			(Субконто1, Субконто2) В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОстаткиДолга.Контрагент,
	|						ОстаткиДолга.Договор
	|					ИЗ
	|						ОстаткиДолга КАК ОстаткиДолга
	|					ГДЕ
	|						ОстаткиДолга.СрокОплаты = &СрокОплаты1)
	|				И Организация = &Организация,
	|			,
	|			&ВидыСубконтоКД) КАК ВзаиморасчетыОбороты
	|ГДЕ
	|	ВзаиморасчетыОбороты.Субконто1 = ВзаиморасчетыОбороты.КорСубконто1
	|	И ВзаиморасчетыОбороты.Субконто2 = ВзаиморасчетыОбороты.КорСубконто2";
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстОборотыПоСроку = СтрЗаменить(ТекстОборотыПоСроку, "И Организация = &Организация", "");
	КонецЕсли;
	
	МаксКоличествоЧастей = 10;
	КоличествоСроковОплаты = МассивСроковОплаты.Количество();
	ОстатокОтДеления = КоличествоСроковОплаты % МаксКоличествоЧастей;
	
	КоличествоЧастей = (КоличествоСроковОплаты - ОстатокОтДеления) / МаксКоличествоЧастей + ?(ОстатокОтДеления > 0, 1, 0);
	ТекстОборотыПоВсемСрокам = "";
	ТекстВсеОбороты = "";
	Для ИндексЧасти = 1 По КоличествоЧастей Цикл
		НачальныйИндекс = МаксКоличествоЧастей * (ИндексЧасти - 1) + 1;
		КонечныйИндекс  = Мин(КоличествоСроковОплаты, МаксКоличествоЧастей * ИндексЧасти);
		ТекстОбороты = "";
		
		Для ИндексЗапроса = НачальныйИндекс По КонечныйИндекс Цикл
			СрокОплаты = МассивСроковОплаты[ИндексЗапроса - 1];
			Запрос.УстановитьПараметр("НачалоИнтервала" + ИндексЗапроса, НачалоДня(КонДата - (СрокОплаты - 1)* 60*60*24));
			Запрос.УстановитьПараметр("СрокОплаты" + ИндексЗапроса, СрокОплаты);
			
			ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСроку, "&НачалоИнтервала1", "&НачалоИнтервала" + ИндексЗапроса);
			ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "&СрокОплаты1", "&СрокОплаты" + ИндексЗапроса);
			Если ИндексЗапроса = НачальныйИндекс Тогда
				ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "ПОМЕСТИТЬ Обороты1", "ПОМЕСТИТЬ Обороты" + ИндексЧасти);
			Иначе
				ТекстОборотыПоСрокуНом = СтрЗаменить(ТекстОборотыПоСрокуНом, "ПОМЕСТИТЬ Обороты1", "");
			КонецЕсли;
			
			ТекстОбороты = ТекстОбороты
			+ ?(ПустаяСтрока(ТекстОбороты), "", "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|") 
			+ ТекстОборотыПоСрокуНом;
			
		КонецЦикла;
		
		ТекстВсеОбороты = ТекстВсеОбороты + ТекстОбороты + " 
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
 		|	Контрагент,
		|	Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		
		ТекстОборотыПоВсемСрокам = ТекстОборотыПоВсемСрокам
		+ ?(ПустаяСтрока(ТекстОборотыПоВсемСрокам), "", "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|") 
		+ "
		|ВЫБРАТЬ 
		|	Обороты" + ИндексЧасти + ".Организация,
		|	Обороты" + ИндексЧасти + ".Контрагент,
		|	Обороты" + ИндексЧасти + ".Договор,
		|	Обороты" + ИндексЧасти + ".УвеличениеДолга
		|ИЗ
		|	Обороты" + ИндексЧасти + " КАК Обороты" + ИндексЧасти;
	КонецЦикла;
	
	ТекстОстаткиИОбороты = ТекстОстатки + "
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(" + ТекстОборотыПоВсемСрокам + ") КАК Обороты
	|	ПО ОстаткиДолга.Организация = Обороты.Организация
	|		И ОстаткиДолга.Контрагент = Обороты.Контрагент
	|		И ОстаткиДолга.Договор = Обороты.Договор
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиДолга.Организация,
	|	ОстаткиДолга.Контрагент,
	|	ОстаткиДолга.Договор,
	|	ОстаткиДолга.ОстатокДолга,
	|	ОстаткиДолга.СрокОплаты";
	
	ТекстПросрочено =
	"ВЫБРАТЬ
	|	ОстаткиИОбороты.Организация,
	|	ОстаткиИОбороты.Контрагент,
	|	ОстаткиИОбороты.Договор,
	|	ОстаткиИОбороты.СрокОплаты,
	|	ОстаткиИОбороты.ОстатокДолга,
	|	ОстаткиИОбороты.ОстатокДолга - 
	|		ВЫБОР
	|			КОГДА ОстаткиИОбороты.ОстатокДолга < ОстаткиИОбороты.УвеличениеДолга
	|				ТОГДА ОстаткиИОбороты.ОстатокДолга
	|			ИНАЧЕ ОстаткиИОбороты.УвеличениеДолга
	|		КОНЕЦ КАК ПросроченнаяЗадолженность
	|ИЗ
	|	(" + ТекстОстаткиИОбороты + ") КАК ОстаткиИОбороты
	|ГДЕ
	|	ОстаткиИОбороты.ОстатокДолга - 
	|		ВЫБОР
	|			КОГДА ОстаткиИОбороты.ОстатокДолга < ОстаткиИОбороты.УвеличениеДолга
	|				ТОГДА ОстаткиИОбороты.ОстатокДолга
	|			ИНАЧЕ ОстаткиИОбороты.УвеличениеДолга
	|		КОНЕЦ > 0";
	
	Запрос.Текст = ТекстВсеОбороты + ТекстПросрочено;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
#КонецЕсли