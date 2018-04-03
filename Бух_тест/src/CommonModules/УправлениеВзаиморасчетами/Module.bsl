////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Преобразует значение системного перечисления ВидСравнения в текст для запроса
//
// Параметры
//  СтруктураОтбора		–	<Структура>
//							Структура параметров отбора. Если есть элемент структуры с ключом "ВидСравненияОтбора",
//							значение этого элемента преобразуется в текст для запроса.
//							Необязательный элемент, по умолчанию ВидСравнения.Равно
//
// Возвращаемое значение:
//   <Строка> – текст сравнения для запроса
//
Функция ПолучитьВидСравненияДляЗапроса(СтруктураОтбора)

	Если НЕ СтруктураОтбора.Свойство("ВидСравненияОтбора") Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Равно Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеРавно Тогда
		Возврат "<>";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСписке Тогда
		Возврат "В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСписке Тогда
		Возврат "НЕ В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСпискеПоИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСпискеПоИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Больше Тогда
		Возврат ">";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.БольшеИлиРавно Тогда
		Возврат ">=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Меньше Тогда
		Возврат "<";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.МеньшеИлиРавно Тогда
		Возврат "<=";
	Иначе // другие варианты 
		Возврат "=";
	КонецЕсли;

КонецФункции // ПолучитьВидСравненияДляЗапроса()

// Получает договор контрагента по умолчанию с учетом условий отбора. Возвращается основной договор или единственный или пустая ссылка
//
// Параметры
//  ВладелецДоговора	–	<СправочникСсылка.Контрагенты> 
//							Контрагент, договор которого нужно получить
//  ОрганизацияДоговора	–	<СправочникСсылка.Организации> 
//							Организация, договор которой нужно получить
//  СписокВидовДоговора	–	<Массив> или <СписокЗначений>, состоящий из значений типа <ПеречислениеСсылка.ВидыДоговоровКонтрагентов> 
//							Нужные виды договора
//  СтруктураПараметров	–	<Структура>
//							Структура дополнительных параметров отбора договоров по реквизитам.
//							Элементы структуры СтруктураПараметров:
//							Ключ - имя реквизита договора, Значение - еще одна структура
//							
//							Элементы структуры, которая находится в Значение:
//							Ключ - "ЗначениеОтбора", Значение - значение реквизита договора для отбора. Обязательный элемент.
//							Ключ - "ВидСравненияОтбора", Значение - <ВидСравнения>. Необязательный элемент, по умолчанию ВидСравнения.Равно
//
// Возвращаемое значение:
//   <СправочникСсылка.ДоговорыКонтрагентов> – найденный счет или пустая ссылка
//
Функция УстановитьДоговорКонтрагента(ДоговорКонтрагента,ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора=неопределено, СтруктураПараметров = Неопределено) Экспорт

	НовыйДоговор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДоговорыКонтрагентов.Ссылка,
	|	ВЫБОР
	|		КОГДА СправочникВладелец.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК СправочникВладелец
	|		ПО ДоговорыКонтрагентов.Владелец = СправочникВладелец.Ссылка
	|			И ДоговорыКонтрагентов.Ссылка = СправочникВладелец.ОсновнойДоговорКонтрагента
	|ГДЕ
	|	&ТекстФильтра
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("ВладелецДоговора", ВладелецДоговора);
	Запрос.УстановитьПараметр("ОрганизацияДоговора", ОрганизацияДоговора);
	Запрос.УстановитьПараметр("СписокВидовДоговора", СписокВидовДоговора);
	
	ТекстФильтра = "
	|	ДоговорыКонтрагентов.Владелец = &ВладелецДоговора
	|	И ДоговорыКонтрагентов.Организация = &ОрганизацияДоговора
	|	И ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ"
	+?(СписокВидовДоговора<>неопределено,"
	|	И ДоговорыКонтрагентов.ВидДоговора В (&СписокВидовДоговора)","");
	
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		Для каждого Параметр Из СтруктураПараметров Цикл
			ИмяРеквизита = Параметр.Ключ;
			СтруктураОтбора = Параметр.Значение;
			ВидСравненияЗапроса = ПолучитьВидСравненияДляЗапроса(СтруктураОтбора);
			ТекстФильтра = ТекстФильтра + "
			|	И ДоговорыКонтрагентов." + ИмяРеквизита + " " + ВидСравненияЗапроса + " (&" + ИмяРеквизита + ")";
			Запрос.УстановитьПараметр(ИмяРеквизита, СтруктураОтбора.ЗначениеОтбора);
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстФильтра", ТекстФильтра);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
	
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НайденОсновнойДоговор = Выборка.Приоритет = 1;
		НайденОдинДоговор     = Выборка.Количество() = 1;
		
		Если НайденОсновнойДоговор ИЛИ НайденОдинДоговор Тогда
			НовыйДоговор = Выборка.Ссылка;
		КонецЕсли;
	
	КонецЕсли;
	
	Если (ДоговорКонтрагента.Владелец<>ВладелецДоговора ИЛИ ДоговорКонтрагента.Организация<>ОрганизацияДоговора) ИЛИ (не ЗначениеЗаполнено(ДоговорКонтрагента)) Тогда	
		ДоговорКонтрагента = НовыйДоговор;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ПолучитьДоговорКонтрагента()

// Проверяет возможность проведения в БУ и НУ в зависимости от договора взаиморасчетов.
//
Функция ПроверкаВозможностиПроведенияВ_БУ_НУ(СтруктураШапкиДокумента, ДоговорКонтрагента,
	                                         Отказ = Ложь, Заголовок,ДополнениеКСообщению = "") Экспорт
    Если СтруктураШапкиДокумента.ВидДокумента = "ВозвратТоваровПоставщику" Тогда
		ЭтоДокументОплаты = Ложь;
	иначе
		ЭтоДокументОплаты = Не(БухгалтерскийУчетРасчетовСКонтрагентами.ОпределениеНаправленияДвиженияДляДокументаДвиженияДенежныхСредств(СтруктураШапкиДокумента.ВидДокумента).Направление = Неопределено);
	КонецЕсли; 

	Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) тогда
		Возврат Истина;
	КонецЕсли;

	ВалютаВзаиморасчетов     = ДоговорКонтрагента.ВалютаВзаиморасчетов;
	
	Если ВалютаВзаиморасчетов <> СтруктураШапкиДокумента.ВалютаДокумента и СтруктураШапкиДокумента.ВалютаРегламентированногоУчета <> СтруктураШапкиДокумента.ВалютаДокумента тогда

		//Документ выписан в валюте отличной от валюты регламентированного учета и валюты расчетов.
		СтрокаСообщения = ДополнениеКСообщению + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' Валюта документа (%1) "
"отличается от валюты расчетов по договору ""%2"" (%3)."
""
"Документ не может быть проведен по бухгалтерскому или налоговому учету.';uk=' Валюта документа (%1) "
"відрізняється від валюти розрахунків за договором ""%2"" (%3)."
""
"Документ не може бути проведений по бухгалтерському або податковому обліку.'"), СтруктураШапкиДокумента.ВалютаДокумента, ДоговорКонтрагента, ВалютаВзаиморасчетов);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, , , , Отказ);

		Возврат Ложь;

	ИначеЕсли СтруктураШапкиДокумента.ВалютаДокумента = СтруктураШапкиДокумента.ВалютаРегламентированногоУчета тогда

		Если (НЕ ВалютаВзаиморасчетов = СтруктураШапкиДокумента.ВалютаРегламентированногоУчета) тогда

			//Документ выписан в валюте регламентированного учета. Валюта расчетов иная. Договор не в у.е. 
			//Не отражается в б.у.
			СтрокаСообщения = ДополнениеКСообщению+СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' Валюта расчетов по договору ""%1"" (%2) отличается от валюты регламентированного учета (%3)."
""
"Документы при расчетах по валютным договорам могут быть выписаны только в валюте взаиморасчетов.%4"
"Документ не может быть проведен по бухгалтерскому или налоговому учету.';uk=' Валюта розрахунків за договором ""%1"" (%2) відрізняється від валюти регламентованого обліку (%3)."
""
"Документи при розрахунках по валютних договорах можуть бути виписані тільки у валюті взаєморозрахунків.%4"
"Документ не може бути проведений по бухгалтерському або податковому обліку.'"), ДоговорКонтрагента, ВалютаВзаиморасчетов, СтруктураШапкиДокумента.ВалютаРегламентированногоУчета, Символы.ПС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, , , , Отказ);

			Возврат Ложь;

		КонецЕсли;

	Иначе





	КонецЕсли;

	Возврат Истина;

КонецФункции // ПроверкаВозможностиПроведенияВ_БУ_НУ()

// Функция возвращает ссылку на сам документ, кроме случая, когда Сделка (т. е. расчетный документ, указаный в нем) является
// Счетом (покупателю или поставщика). В этом случае возвращается Счет.
// 
// Параметры:
//  Ссылка - ДокументСсылка. Ссылка на документ взаиморасчетов.
//  Сделка - ДокументСсылка. Сделка, указанная в документе взаиморасчетов.
//
// Возвращаемое значение:
//  ДокументСсылка - документ взаиморасчетов.
// 
Функция ОпределитьДокументРасчетовСКонтрагентом(Ссылка, Сделка = Неопределено) Экспорт

	ТипСделки = ТипЗнч(Сделка);
	
	Если   Сделка = Неопределено
	  ИЛИ (ТипСделки <> Тип("ДокументСсылка.СчетНаОплатуПокупателю") И ТипСделки <> Тип("ДокументСсылка.СчетНаОплатуПоставщика")) 
	  ИЛИ  Сделка.Пустая() Тогда
		   
	   Возврат Ссылка;
		   
   Иначе
		   
	   Возврат Сделка;
		   
   КонецЕсли; 

КонецФункции // ОпределитьДокументРасчетовСКонтрагентом()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПРОВЕРКИ ПРИ ПРОВЕДЕНИИ ПРАВИЛЬНОСТИ ЗАПОЛНЕНИЯ ДОКУМЕНТОВ
//

// Для документов, у которых договор контрагента находится в табличной части
// что организация в документе совпадает с организацией, указанной в договоре взаиморасчетов.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - табличная часть документа,
//  ТаблицаЗначений   - таблица значений, содержащая данные табличной части,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьОрганизациюДоговораВзаиморасчетовВТабличнойЧасти(ДокументОбъект, ИмяТабличнойЧасти, ТаблицаЗначений, 
													Отказ, Заголовок) Экспорт

	ПредставлениеТабличнойЧасти = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();

	// Цикл по строкам таблицы значений.
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл

		СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"" табличной части ""%2"": ';uk='У рядку номер ""%1"" табличної частини ""%2"": '"), СокрЛП(СтрокаТаблицы.НомерСтроки), ПредставлениеТабличнойЧасти);

		// Если не заполнен договор или организация, то не ругаемся.
		Если ЗначениеЗаполнено(ДокументОбъект.Организация) 
		   И ЗначениеЗаполнено(СтрокаТаблицы.ДоговорКонтрагента)
		   И ДокументОбъект.Организация <> СтрокаТаблицы.ДоговорОрганизация Тогда
		   СтрокаСообщения = СтрокаНачалаСообщенияОбОшибке 
							 + НСтр("ru=' выбран договор контрагента, не соответстветствующий организации, указанной в документе!';uk=' обрано договір контрагента, що не відповідає організації, вибраній в документі!'");
		   ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, , , , Отказ);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьОрганизациюДоговораВзаиморасчетовВТабличнойЧасти()

// Возаращает вид договора с контрагентом по виду операции
//
Функция ОпределитьВидДоговораСКонтрагентом(ВидОперации = Неопределено) Экспорт

	СПоставщиком = Новый СписокЗначений;
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);

	СПокупателем = Новый СписокЗначений;
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);

	Прочее = Новый СписокЗначений;
	Прочее.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);

	Если ЗначениеЗаполнено(ВидОперации) тогда

		//Определение вида операции

		ВидДоговораПоВидуОпераций = Новый Соответствие();

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ОплатаПоставщику,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю,СПокупателем);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ОплатаПокупателя,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком,СПоставщиком);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами,Прочее);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ВозвратДенежныхСредствПоставщиком,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПрочиеРасчетыСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам,Прочее);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймамСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПрочиеРасчетыСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратДенежныхСредствПокупателю,СПокупателем);

		ВидДоговора = ВидДоговораПоВидуОпераций[ВидОперации];

		Если НЕ ВидДоговора = Неопределено Тогда
			Возврат ВидДоговора;
		Иначе
			Возврат Новый СписокЗначений;

		КонецЕсли;

	Иначе

		Возврат Новый СписокЗначений;

	Конецесли;

КонецФункции // ОпределитьВидДоговораСКонтрагентом()

//Дополнить записи регистра бухгалтерии или регистра накопления записями таблицы
Функция ДополнитьНабораЗаписейРегистраЗаписямиТаблицы(НаборЗаписей,ТаблицаДополнений)Экспорт

	ОтрабатыватьСубконто =  Метаданные.РегистрыБухгалтерии.Содержит(НаборЗаписей.Метаданные());
	Если Метаданные.РегистрыБухгалтерии.Содержит(НаборЗаписей.Метаданные()) тогда
		//Это регистр бухгалтерии
		ТаблицаНабораЗаписей = РегистрыБухгалтерии[НаборЗаписей.Метаданные().Имя].СоздатьНаборЗаписей().Выгрузить();
	ИначеЕсли Метаданные.РегистрыНакопления.Содержит(НаборЗаписей.Метаданные()) тогда
		ТаблицаНабораЗаписей = РегистрыНакопления[НаборЗаписей.Метаданные().Имя].СоздатьНаборЗаписей().Выгрузить();
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(НаборЗаписей.Метаданные()) тогда
		ТаблицаНабораЗаписей = РегистрыСведений[НаборЗаписей.Метаданные().Имя].СоздатьНаборЗаписей().Выгрузить();
	Иначе
		ТаблицаНабораЗаписей = Неопределено;
	КонецЕсли;

	Для каждого Строка из ТаблицаДополнений Цикл

		НоваяЗапись = НаборЗаписей.Добавить();

		Для каждого Колонка из ТаблицаДополнений.Колонки Цикл

			Если Колонка.Имя = "МоментВремени" или Колонка.Имя = "НомерСтроки" тогда
				Продолжить;
			КонецЕсли;

			Если ОтрабатыватьСубконто и Найти(Колонка.Имя,"Субконто")>0 тогда

				Если Найти(Колонка.Имя,"ВидСубконто") > 0 тогда
					//ВидСубконто - вспомогательная колонка. Обрабатывается вместе с Субконто
					Продолжить;
				Иначе

					НомерСубконто = Прав(Колонка.Имя,1);

					Если Найти(Колонка.Имя, "Дт") + Найти(Колонка.Имя, "Кт")>0 тогда
						СторонаСчета = Лев(Прав(Колонка.Имя,3),2);
					Иначе
						СторонаСчета = "";
					КонецЕсли;

					ЕстьКолонкаСВидомСубконто = Не(ТаблицаДополнений.Колонки.Найти("Вид"+Колонка.Имя) = Неопределено);

					Если ЕстьКолонкаСВидомСубконто тогда
						БухгалтерскийУчетРед12.УстановитьСубконтоПоВидуСубконто(Строка["Счет" + СторонаСчета], НоваяЗапись["Субконто"+СторонаСчета], Строка["Вид"+Колонка.Имя], Строка[Колонка.Имя]);

					Иначе
						БухгалтерскийУчет.УстановитьСубконто(Строка["Счет" + СторонаСчета], НоваяЗапись["Субконто"+СторонаСчета], Число(НомерСубконто), Строка[Колонка.Имя]);

					КонецЕсли;

				КонецЕсли;

			Иначе

				Если ТаблицаНабораЗаписей = Неопределено тогда
					Попытка
						НоваяЗапись[Колонка.Имя] =  Строка[Колонка.Имя];
					Исключение
						//Не смогли заполнить реквизит... Видно его нет.
					КонецПопытки;
				Иначе
					Если ТаблицаНабораЗаписей.Колонки.Найти(Колонка.Имя) = Неопределено тогда
						//Нет такой колонки!
					Иначе
						НоваяЗапись[Колонка.Имя] =  Строка[Колонка.Имя];
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Возврат НаборЗаписей;

КонецФункции

Функция ФИФОПоРасчетам(ТаблицаИтогов, ТаблицаКРаспределению,ТаблицаОстатков,СтруктураШапкиДокумента,КолонкаСчетаФильтра, ТаблицаСуммовыхРазниц=Неопределено, НаправлениеДвижения ,Заголовок, РазрешитьСторнирующиеПроводки = Истина) Экспорт
	
	//Разделение каждой строки на оплату задолженности и аванс
	Для каждого ТекущийПлатеж из ТаблицаКРаспределению Цикл

		СчетФильтра  = ТекущийПлатеж[КолонкаСчетаФильтра];

		НомерСубконтоРасчетныеДокументы = 0;
		Если не СчетФильтра.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами,"ВидСубконто")=Неопределено тогда
			НомерСубконтоРасчетныеДокументы = СчетФильтра.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами,"ВидСубконто").НомерСтроки;
		КонецЕсли;

		СчетОстатков = ТекущийПлатеж[?(КолонкаСчетаФильтра="СчетОплаты","СчетАванса","СчетОплаты")];
		Контрагент = ТекущийПлатеж.Контрагент;
		ДоговорКонтрагента = ТекущийПлатеж.ДоговорКонтрагента;

		КлючЗадолженности = Новый Структура();
		КлючЗадолженности.Вставить("Контрагент"         ,ТекущийПлатеж.Контрагент);
		КлючЗадолженности.Вставить("ДоговорКонтрагента" ,ТекущийПлатеж.ДоговорКонтрагента);
		КлючЗадолженности.Вставить(КолонкаСчетаФильтра  ,СчетФильтра);
		СтрокаИндекса = "Контрагент, ДоговорКонтрагента,"+КолонкаСчетаФильтра;
		Если СтруктураШапкиДокумента.ВидДокумента = "КорректировкаДолга"  Тогда
			Если не НомерСубконтоРасчетныеДокументы = 0 и ЗначениеЗаполнено(ТекущийПлатеж.Сделка) Тогда
				КлючЗадолженности.Вставить("Сделка", ТекущийПлатеж.Сделка);
				СтрокаИндекса = СтрокаИндекса+",Сделка";
			КонецЕсли; 
		ИначеЕсли ТекущийПлатеж.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам тогда
			КлючЗадолженности.Вставить("Сделка", ТекущийПлатеж.Сделка);
			СтрокаИндекса = СтрокаИндекса+",Сделка";
		КонецЕсли; 

		СуммаКРаспределению = ТекущийПлатеж.СуммаВзаиморасчетов;
		
		Если СуммаКРаспределению<0 Тогда
			Если ТаблицаИтогов.Колонки.Найти("НомерПоПорядку") = неопределено Тогда
				ТаблицаИтогов.Колонки.Добавить("НомерПоПорядку");
			КонецЕсли; 
			
			Для НПП = 1 по ТаблицаИтогов.Количество() Цикл
				ТаблицаИтогов[НПП-1].НомерПоПорядку = НПП;
				
				
			КонецЦикла; 
			
			Построитель = новый ПостроительЗапроса();
			ОписаниеИсточника = новый ОписаниеИсточникаДанных(ТаблицаИтогов.Скопировать());
			
			Построитель.ИсточникДанных = ОписаниеИсточника;
			Построитель.Порядок.Добавить("НомерПоПорядку",,,НаправлениеСортировки.Убыв);
			
			ОтборПостроитель = Построитель.Отбор;
			Для каждого КлючОтбора Из КлючЗадолженности Цикл
				ОтборПостроитель.Добавить(КлючОтбора.Ключ);
				ОтборПостроитель[КлючОтбора.Ключ].Значение= КлючОтбора.Значение;
				ОтборПостроитель[КлючОтбора.Ключ].Использование = Истина;
			КонецЦикла; 
			
			Построитель.Выполнить();

			ЗадолженностьПоСтрокеПлатежа = Построитель.Результат.Выгрузить();
			ЗадолженностьПоСтрокеПлатежа.Колонки.Удалить(ЗадолженностьПоСтрокеПлатежа.Колонки["СуммаОстаток"]);
			ЗадолженностьПоСтрокеПлатежа.Колонки.Удалить(ЗадолженностьПоСтрокеПлатежа.Колонки["ВалютнаяСуммаОстаток"]);
			ЗадолженностьПоСтрокеПлатежа.Колонки.ГривневаяСумма.Имя = "СуммаОстаток";
			ЗадолженностьПоСтрокеПлатежа.Колонки.ВалютнаяСумма.Имя = "ВалютнаяСуммаОстаток";
			РаспределениеОтрицательнойСтроки = Истина;
		Иначе
			ТаблицаОстатков.Индексы.Добавить(СтрокаИндекса);
			ЗадолженностьПоСтрокеПлатежа = ТаблицаОстатков.НайтиСтроки(КлючЗадолженности);
			РаспределениеОтрицательнойСтроки = Ложь;
		КонецЕсли; 

		ОстаткиВВалюте = НЕ (ТекущийПлатеж.ВалютаВзаиморасчетов = СтруктураШапкиДокумента.ВалютаРегламентированногоУчета) 
			             И СчетФильтра.Валютный;

		
		// Учет закрытия задолженности
		Для каждого ЗадолженностьСтрока из ЗадолженностьПоСтрокеПлатежа Цикл
			СуммоваяРазница=0;
			
			Задолженность = ЗадолженностьСтрока[?(ОстаткиВВалюте,"ВалютнаяСуммаОстаток","СуммаОстаток")];
			Если не РаспределениеОтрицательнойСтроки Тогда
				Если СуммаКРаспределению >= Задолженность Тогда
					НужноЗаплатить = Задолженность;
				Иначе
					НужноЗаплатить = СуммаКРаспределению;
				КонецЕсли;
			Иначе
				Если -СуммаКРаспределению >= Задолженность Тогда
					НужноЗаплатить = Задолженность;
				Иначе
					НужноЗаплатить = -СуммаКРаспределению;
				КонецЕсли;
			КонецЕсли; 
			
			Если НужноЗаплатить=0 тогда 
				Продолжить;
			КонецЕсли;
			
			Если ОстаткиВВалюте тогда
				СуммоваяРазница = -Окр(НужноЗаплатить*ЗадолженностьСтрока.СуммаОстаток/ЗадолженностьСтрока.ВалютнаяСуммаОстаток,2);
				ЗадолженностьСтрока.СуммаОстаток = ЗадолженностьСтрока.СуммаОстаток - Окр(НужноЗаплатить*ЗадолженностьСтрока.СуммаОстаток/ЗадолженностьСтрока.ВалютнаяСуммаОстаток,2);
				ЗадолженностьСтрока.ВалютнаяСуммаОстаток = ЗадолженностьСтрока.ВалютнаяСуммаОстаток - НужноЗаплатить;
			Иначе
				ЗадолженностьСтрока.СуммаОстаток = ЗадолженностьСтрока.СуммаОстаток - НужноЗаплатить;
			КонецЕсли;
			
			СтрокаТаблицыИтогов = ТаблицаИтогов.Добавить();
			//Заполнить строчку по текущим данным
			Для каждого Колонка из ТаблицаИтогов.Колонки Цикл
				Если Колонка.Имя = "ГривневаяСумма" или Колонка.Имя = "ВалютнаяСумма" или Колонка.Имя = "СуммаВзаиморасчетов" тогда
					Продолжить;
				КонецЕсли;
				
				Если Не(ТаблицаОстатков.Колонки.Найти(Колонка.Имя)=Неопределено) тогда
					СтрокаТаблицыИтогов[Колонка.Имя] = ЗадолженностьСтрока[Колонка.Имя];
				ИначеЕсли Не(ТаблицаКРаспределению.Колонки.Найти(Колонка.Имя)=Неопределено) тогда
					 СтрокаТаблицыИтогов[Колонка.Имя] = ТекущийПлатеж[Колонка.Имя];                                      
				КонецЕслИ;
			КонецЦикла;

			СтрокаТаблицыИтогов.СуммаВзаиморасчетов	= НужноЗаплатить*?(РаспределениеОтрицательнойСтроки,-1,1);
			
			СтрокаТаблицыИтогов.ВалютнаяСумма 	= окр(НужноЗаплатить * (ТекущийПлатеж.ВалютнаяСумма/ТекущийПлатеж.СуммаВзаиморасчетов),2)*?(РаспределениеОтрицательнойСтроки,-1,1);
			СтрокаТаблицыИтогов.ГривневаяСумма	= окр(НужноЗаплатить *(ТекущийПлатеж.ГривневаяСумма/ТекущийПлатеж.СуммаВзаиморасчетов),2)*?(РаспределениеОтрицательнойСтроки,-1,1);
			
			Если РаспределениеОтрицательнойСтроки Тогда
				СтрокаТаблицыИтогов.РезультатРаспределения = ЗадолженностьСтрока.РезультатРаспределения;
			иначе
				СтрокаТаблицыИтогов.РезультатРаспределения = Истина;	
			КонецЕсли; 
			
			Если Не(НомерСубконтоРасчетныеДокументы = 0) тогда
				СтрокаТаблицыИтогов.Сделка = СтрокаТаблицыИтогов["Субконто"+НомерСубконтоРасчетныеДокументы];
			КонецЕсли;
			
			СуммаКРаспределению = СуммаКРаспределению - НужноЗаплатить*?(РаспределениеОтрицательнойСтроки,-1,1);
			
			ТекущийПлатеж.ГривневаяСумма			= ТекущийПлатеж.ГривневаяСумма - СтрокаТаблицыИтогов.ГривневаяСумма;
			ТекущийПлатеж.ВалютнаяСумма			= ТекущийПлатеж.ВалютнаяСумма - СтрокаТаблицыИтогов.ВалютнаяСумма;
			ТекущийПлатеж.СуммаВзаиморасчетов	= ТекущийПлатеж.СуммаВзаиморасчетов - СтрокаТаблицыИтогов.СуммаВзаиморасчетов;
			
			Если РаспределениеОтрицательнойСтроки Тогда
				СуммоваяРазница = 0;
			ИначеЕсли ОстаткиВВалюте тогда
				СуммоваяРазница = СуммоваяРазница + СтрокаТаблицыИтогов.ГривневаяСумма;
			КонецЕсли;
			
			ПараметрыСчета = РегистрыСведений.НемонетарныеСчета.Выбрать(новый структура("Счет",СтрокаТаблицыИтогов.Счет));
			ФлагНужноРаспределять = ПараметрыСчета.Следующий() И ((ПараметрыСчета.ТолькоДебет = Ложь И ПараметрыСчета.ТолькоКредит = Ложь) ИЛИ
									// если счет расчетов в Кт
									(НаправлениеДвижения = "Поступление" И ПараметрыСчета.ТолькоДебет) ИЛИ 
									// если счет расчетов в Дт
									((НЕ НаправлениеДвижения = "Поступление") И ПараметрыСчета.ТолькоКредит));
									
			Если не (СуммоваяРазница=0) и ФлагНужноРаспределять тогда
				Если ТаблицаСуммовыхРазниц=Неопределено тогда
					СтрокаТаблицыИтогов.ГривневаяСумма = СтрокаТаблицыИтогов.ГривневаяСумма-СуммоваяРазница;
					Если не ОстаткиВВалюте тогда
						СтрокаТаблицыИтогов.СуммаВзаиморасчетов = СтрокаТаблицыИтогов.СуммаВзаиморасчетов+СуммоваяРазница;
					КонецЕсли;				
                КонецЕслИ;
			КонецЕслИ;

			Если СуммаКРаспределению = 0 тогда 
				Прервать;
			КонецЕсли;
		КонецЦикла;

		
		Если ТекущийПлатеж.СуммаВзаиморасчетов=0 тогда
			//Распределили полностью!
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицыИтогов = ТаблицаИтогов.Добавить();
		//Заполнить строчку по текущим данным
		Для каждого Колонка из ТаблицаИтогов.Колонки Цикл
			Если Не(ТаблицаКРаспределению.Колонки.Найти(Колонка.Имя)=Неопределено) тогда
				 СтрокаТаблицыИтогов[Колонка.Имя] = ТекущийПлатеж[Колонка.Имя];                                      
			КонецЕслИ;
		КонецЦикла;
	КонецЦикла;

КонецФункции

// Проверяет, что организация в документе совпадает с организацией, указанной в договоре взаиморасчетов.
//  при несовпадении устанавливается флаг отказа в проведении.
//
// Параметры:
//  Организация           - ссылка на организацию, выбранную в документе,
//  ДоговорКонтрагента - ссылка на договор, выбранный в документе,
//  ДоговорОрганизация    - ссылка на Организацию, выбранную в договоре,
//  Отказ                 - флаг отказа в проведении.
//  Заголовок             - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, 
	                                                             ДоговорОрганизация, Отказ, Заголовок) Экспорт

	// Если не заполнен договор или организация, то не ругаемся.
	Если ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ДоговорКонтрагента)
	   И Организация <> ДоговорОрганизация Тогда
		СтрокаСообщения = НСтр("ru='Выбран договор контрагента, не соответствующий организации, указанной в документе!';uk='Обрано договір контрагента, що не відповідає організації, вибраній в документі!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, , , , Отказ);
	КонецЕсли;

КонецПроцедуры // ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов()

// Функция оставлена в этом модуле для совместимости со старыми правилами обмена.
// 
Функция ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, Договор, ВалютаРегламентированногоУчета = Неопределено) Экспорт
	Возврат БухгалтерскийУчетРасчетовСКонтрагентами.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, Договор, ВалютаРегламентированногоУчета);
КонецФункции

