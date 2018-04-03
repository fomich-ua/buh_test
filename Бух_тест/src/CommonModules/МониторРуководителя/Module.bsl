
#Область ПрограммныйИнтерфейс

// Вызывает обновление записей регистра сведений "ДанныеМонитораРуководителя" вызывается фоновым заданием
// при обновалении учитывается актуальность данных регистра сведений
// Параметры:
//   Параметры - Структура - Структура с параметрами переданная в фоновое задание
//		*Организация - СправочникСсылка.Организации - организация по которой нужно обновить ланные монитора
//									Если не заполнено данные будут обновлены по всем доступным организациям
//	ВременноеХранилищеРезультата - Строка - путь к временному хранилищу (не используется в рамках данной процедуры)	
Процедура ОбновитьДанныеМонитораВФоне(Параметры, ВременноеХранилищеРезультата) Экспорт
	
	ОбновитьДанныеМонитора(Параметры, Истина);

КонецПроцедуры	

// Вызывает перезапись данных регистра сведений "ДанныеМонитораРуководителя" вызывается фоновым заданием
// данные регистра сведений перезаписываются без учета актуальности
// Параметры:
//   Параметры - Структура - Структура с параметрами переданная в фоновое задание
//		*Организация - СправочникСсылка.Организации - организация по которой нужно обновить ланные монитора
//									Если не заполнено данные будут обновлены по всем доступным организациям
//	ВременноеХранилищеРезультата - Строка - путь к временному хранилищу (не используется в рамках данной процедуры)	
Процедура ПерезаписатьДанныеМонитораВФоне(Параметры, ВременноеХранилищеРезультата) Экспорт
	
	ОбновитьДанныеМонитора(Параметры, Ложь);

КонецПроцедуры	

// Вызывает обновление данных регистра сведений "ДанныеМонитораРуководителя" по всем организациям
// Запускается регламентным заданием
Процедура ОбновитьДанныеРегламентнымЗаданием() Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	ОбновитьДанныеМонитораПоВсемОрганизациям(ТекущаяДатаСеанса(), 600);

КонецПроцедуры

// Вызывает первоначальное заполнение регистра сведений "ДанныеМонитораРуководителя" по всем организациям
// Запускается при обновлении версии конфиурации и при переходе с предыдущей версии
Процедура ЗаполнитьДанныеМонитораРуководителя() Экспорт
	
	ОбновитьДанныеМонитораПоВсемОрганизациям(ТекущаяДатаСеанса(), 0);
	
КонецПроцедуры

// Возвращает настройку списка разделов монитора руководителя по умолчанию
// Возвращаемое значение:
// СписокЗначений - Список разделов монитора руководителя с пометками и упорядочиванием по умолчанию
Функция СтандартныйСписокРазделовМонитораРуководителя() Экспорт
	
	СписокРазделов = Новый СписокЗначений();	
	Для Каждого Раздел из Перечисления.РазделыМонитораРуководителя Цикл
		СписокРазделов.Добавить(Раздел, Раздел, Истина);
	КонецЦикла;
	
	Возврат СписокРазделов;
	
КонецФункции	

// Создает пустую таблицу контейнер для данных монитора руководителя
// Возвращаемое значение:
//	ТаблицаЗначений - Пустая таблица данных монитора руководителя
//
Функция ТаблицаДанных() Экспорт
	
	ОписаниеТиповЧисло15_2 = ОбщегоНазначения.ОписаниеТипаЧисло(15, 2);
	
	НоваяТаблицаДанных = Новый ТаблицаЗначений;
	
	НоваяТаблицаДанных.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	НоваяТаблицаДанных.Колонки.Добавить("Сумма", ОписаниеТиповЧисло15_2);
	НоваяТаблицаДанных.Колонки.Добавить("СуммаВВалюте", ОписаниеТиповЧисло15_2);
	НоваяТаблицаДанных.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(1)));
	НоваяТаблицаДанных.Колонки.Добавить("ДанныеРасшифровки", Новый ОписаниеТипов("СправочникСсылка.Валюты, СправочникСсылка.НоменклатурныеГруппы, СправочникСсылка.Контрагенты"));
	
	Возврат НоваяТаблицаДанных;
	
КонецФункции

Функция ШаблонЗапросаПоПросроченнойЗадолженнсти() Экспорт
	
	Возврат "ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
		|	ХозрасчетныйОстатки.Субконто2 КАК Договор,
		|	ХозрасчетныйОстатки.Счет КАК Счет,
		|	ХозрасчетныйОстатки.[СуммаОстаток] КАК Сумма
		|ПОМЕСТИТЬ [Остатки]
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&[Период],
		|			Счет В
		|				(&СписокСчетов),
		|			&СубконтоКонтрагентДоговор,
		|			Организация В (&Организация)
		|				И [ТекстУсловия]
		|				И ВЫБОР
		|					КОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
		|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
		|					ИНАЧЕ &СтандартныйСрокОплаты
		|				КОНЕЦ = &[СрокОплаты]) КАК ХозрасчетныйОстатки
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиДолга.Контрагент КАК Контрагент,
		|	ОстаткиДолга.Договор КАК Договор,
		|	СУММА(ОстаткиДолга.Сумма) КАК Сумма
		|ПОМЕСТИТЬ [ОстаткиНаНачалоСрока]
		|ИЗ
		|	[Остатки] КАК ОстаткиДолга
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиДолга.Контрагент,
		|	ОстаткиДолга.Договор
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент,
		|	Договор
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОбороты.Субконто1 КАК Контрагент,
		|	ХозрасчетныйОбороты.Субконто2 КАК Договор,
		|	ХозрасчетныйОбороты.[СуммаОборот] КАК УменьшениеЗадолженности
		|ПОМЕСТИТЬ [ОборотыЗаПериод]
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&[НачалоПериода],
		|			&Период,
		|			,
		|			Счет В
		|				(&СписокСчетов),
		|			&СубконтоКонтрагентДоговор,
		|			Организация В (&Организация)
		|				И [ТекстУсловия]
		|				И ВЫБОР
		|					КОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
		|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
		|					ИНАЧЕ &СтандартныйСрокОплаты
		|				КОНЕЦ = &[СрокОплаты],
		|			,
		|			) КАК ХозрасчетныйОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйОбороты.Субконто1,
		|	ХозрасчетныйОбороты.Субконто2,
		|	-ХозрасчетныйОбороты.[СуммаОборот]
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&[НачалоПериода],
		|			&Период,
		|			,
		|			Счет В
		|				(&СписокСчетов),
		|			&СубконтоКонтрагентДоговор,
		|			Организация В (&Организация)
		|				И [ТекстУсловия]
		|				И ВЫБОР
		|					КОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
		|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
		|					ИНАЧЕ &СтандартныйСрокОплаты
		|				КОНЕЦ = &[СрокОплаты]
		|				И Субконто1 = КорСубконто1
		|				И Субконто2 = КорСубконто2,
		|			КорСчет В
		|				(&СписокСчетов),
		|			&СубконтоКонтрагентДоговор) КАК ХозрасчетныйОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент,
		|	Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиНаНачалоСрока.Контрагент КАК Контрагент,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(ОборотыЗаПериод.УменьшениеЗадолженности, 0) >= ЕСТЬNULL(ОстаткиНаНачалоСрока.Сумма, 0)
		|				ТОГДА 0
		|			ИНАЧЕ ВЫБОР
		|					КОГДА ЕСТЬNULL(ОстаткиНаНачалоСрока.Сумма, 0) - ЕСТЬNULL(ОборотыЗаПериод.УменьшениеЗадолженности, 0) > ОстаткиДолга.ОстатокДолга
		|						ТОГДА ОстаткиДолга.ОстатокДолга
		|					ИНАЧЕ ЕСТЬNULL(ОстаткиНаНачалоСрока.Сумма, 0) - ЕСТЬNULL(ОборотыЗаПериод.УменьшениеЗадолженности, 0)
		|				КОНЕЦ
		|		КОНЕЦ) КАК Сумма
		|ПОМЕСТИТЬ [ПросроченнаяЗадолженность]
		|ИЗ
		|	ОстаткиДолга КАК ОстаткиДолга
		|		ЛЕВОЕ СОЕДИНЕНИЕ [ОстаткиНаНачалоСрока] КАК ОстаткиНаНачалоСрока
		|			ЛЕВОЕ СОЕДИНЕНИЕ [ОборотыЗаПериод] КАК ОборотыЗаПериод
		|			ПО ОстаткиНаНачалоСрока.Контрагент = ОборотыЗаПериод.Контрагент
		|				И ОстаткиНаНачалоСрока.Договор = ОборотыЗаПериод.Договор
		|		ПО ОстаткиДолга.Контрагент = ОстаткиНаНачалоСрока.Контрагент
		|			И ОстаткиДолга.Договор = ОстаткиНаНачалоСрока.Договор
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиНаНачалоСрока.Контрагент
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
	
КонецФункции

Функция ШаблонЗапросаОбъединениеПросроченнойЗадолженнсти() Экспорт
	
	Возврат "ВЫБРАТЬ
		|	ПросроченнаяЗадолженность.Контрагент,
		|	ПросроченнаяЗадолженность.Сумма
		|ИЗ
		|	[ПросроченнаяЗадолженность] КАК ПросроченнаяЗадолженность
		|";
	
КонецФункции	

// Получает список счетов расчтеов с контрагентами
//  Параметры:
// 	Тип - Число - определяет для кого надо получить настройку: 1 - покупатель, 2 - поставщик,
// 
// Возвращаемое значение:
// 	Массив - Массив счетов
//		* СчетСсылка
//
Функция СчетаРасчетовСКонтрагентами(Тип) Экспорт
	
	// Получим настройку счетов которые учитывать не нужно
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(Тип);
	Если ИсключенныеСчета = Неопределено Тогда
		ИсключенныеСчета = Новый Массив;
	КонецЕсли;	
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ИсключенныеСчета", ИсключенныеСчета);	
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВидыСубконтоКонтрагенты.Ссылка КАК Счет
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконтоКонтрагенты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконтоДоговоры
	               |		ПО ВидыСубконтоКонтрагенты.Ссылка = ВидыСубконтоДоговоры.Ссылка
	               |ГДЕ
	               |	ВидыСубконтоКонтрагенты.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
	               |	И НЕ ВидыСубконтоКонтрагенты.Ссылка.Забалансовый
	               |	И НЕ ВидыСубконтоКонтрагенты.Ссылка В ИЕРАРХИИ (&ИсключенныеСчета)
				   |    И НЕ ВидыСубконтоКонтрагенты.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогамИПлатежам))
	               |	И ВидыСубконтоДоговоры.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)";

Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");
	
КонецФункции	

// Получает дату последнего оновления данных монитора руководителя по организации
// Если в рганизации указана мустая ссылка или неопределено то вернет наибольшую дату по всем организациям
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужно получить дату обновления
//					если не указана то по всем
// Возвращаемое значение:
// Дата, Неопределено - Если не удалось получить данные
//
Функция ПолучитьДатуПоследнегоОбновленияМонитора(Организация) Экспорт

	ДатаПоследнегоОбновленияМонитора = '00010101';
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		СписокОрганизаций = СписокДоступныхОрганизаций;
		
	ИначеЕсли СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(Организация);
		
	Иначе
		СписокОрганизаций = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МАКСИМУМ(ДанныеМонитораРуководителя.ДатаОбновления) КАК ДатаОбновления
	|ИЗ
	|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
	|ГДЕ
	|	ДанныеМонитораРуководителя.Организация В(&Организация)";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Следующий() Тогда
		ДатаПоследнегоОбновленияМонитора = Результат.ДатаОбновления;
	КонецЕсли;
	
	Возврат ДатаПоследнегоОбновленияМонитора;
	
КонецФункции

// Получает данные из регистра сведений ДанныеМонитораРуководителя
// Параметры
// Организация - СправочникСсылка.Организации - Организация по которой нужно получить данные
// если не указана то по всем
// СписокРазделов - Массив - массив разделов монитора руководителя
// ВариантОкругления - Число - 1 - округлять до целых рублей, 1000 - до тысяч
// Возвращаемое значение:
// Массив - Массив результатов запроса, результаты в массиве соответствуют разделам монитора
// и располагаются в том же порядке что и в СпискеРазделов
//
Функция ПолучитьДанныеРазделовМонитора(Организация, СписокРазделов, ВариантОкругления = 1) Экспорт
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		СписокОрганизаций = СписокДоступныхОрганизаций;
		
	ИначеЕсли СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(Организация);
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ВариантОкругления", ВариантОкругления);
	
	Разделитель = "";
	ТекстЗапроса = "";
	Для ИндексРаздела = 0 По СписокРазделов.ВГраница() Цикл
		
		Запрос.УстановитьПараметр("РазделМонитора" + ИндексРаздела, СписокРазделов[ИндексРаздела]);
		
		ТекстЗапроса = ТекстЗапроса + Разделитель + СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонЗапросаКДаннымразделаМонитора(), Новый Структура("РазделМонитора", "РазделМонитора" + ИндексРаздела));
		
		Разделитель = "
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|
			|";
		
	КонецЦикла;
	Запрос.Текст = ТекстЗапроса;
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	
	Возврат Результат;
	
КонецФункции 

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ШаблонЗапросаКДаннымРазделаМонитора()
	
	Возврат "ВЫБРАТЬ
		|	ДанныеМонитораРуководителя.Представление,
		|	СУММА(ДанныеМонитораРуководителя.Сумма / &ВариантОкругления) КАК Сумма,
		|	ДанныеМонитораРуководителя.ДанныеРасшифровки,
		|	СУММА(ДанныеМонитораРуководителя.СуммаВВалюте) КАК СуммаВВалюте
		|ИЗ
		|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
		|ГДЕ
		|	ДанныеМонитораРуководителя.Организация В(&Организация)
		|	И ДанныеМонитораРуководителя.РазделМонитора = &[РазделМонитора]
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеМонитораРуководителя.Представление,
		|	ДанныеМонитораРуководителя.ДанныеРасшифровки,
		|	ДанныеМонитораРуководителя.Порядок
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДанныеМонитораРуководителя.Порядок,
		|	Сумма УБЫВ";
		
КонецФункции

// Обновляет данные регистра сведений "ДанныеМонитораРуководителя"
// Параметры:
//   Параметры - Структура - Структура с параметрами
//		*Организация - СправочникСсылка.Организации - организация по которой нужно обновить ланные монитора
//									Если не заполнено данные будут обновлены по всем доступным организациям
//	УчитыватьАктуальностьДанных - булево - Истина - перед обновлением проверить что данные неактуальны, Ложь - не проверять
Процедура ОбновитьДанныеМонитора(Параметры, УчитыватьАктуальностьДанных)
	
	Если Параметры = Неопределено Тогда
		Организация 		= Неопределено;
	Иначе
		Организация 		= Параметры.Организация;
	КонецЕсли;
	
	// Обновляем всегда на текущий момент
	Дата = ТекущаяДатаСеанса();
	
	// Учесть актуальность данных означает следующее
	// Если данные монитора были записаны менее чем 10 минут назад то обновлять их не нужно
	// Если актуальность учитывать не нужно, например когда пользователь нажал кнопку обновить
	// Перезаписываем данные в любом случае
	ИнтервалОбновления = 0;
	Если УчитыватьАктуальностьДанных Тогда
		ИнтервалОбновления 	= 600;
	КонецЕсли;
	
	// Если организация не заполнена то данные нужно обновить по всем
	Если ЗначениеЗаполнено(Организация) Тогда
		РегистрыСведений.ДанныеМонитораРуководителя.ОбновитьДанныеМонитора(Организация, Дата, ИнтервалОбновления);
	Иначе
		ОбновитьДанныеМонитораПоВсемОрганизациям(Дата, ИнтервалОбновления);
	КонецЕсли;
	
КонецПроцедуры	

// Обновляет данные регистра сведений "ДанныеМонитораРуководителя" по всем организациям
// Параметры:
//  Дата - Дата - Дата на которую нужно получить данные для записи в регистр
//	ИнтервалОбновления - Число - Период в секундах в течении которого данные считаются актуальными
Процедура ОбновитьДанныеМонитораПоВсемОрганизациям(Дата, ИнтервалОбновления)
	
	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Для Каждого Организация Из ДоступныеОрганизации Цикл
		
		РегистрыСведений.ДанныеМонитораРуководителя.ОбновитьДанныеМонитора(Организация, Дата, ИнтервалОбновления);
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти
