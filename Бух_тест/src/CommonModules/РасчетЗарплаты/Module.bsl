////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает ссылку на заполненный документ начисления зарплаты 
// Если для заданного месяца, организации и подразделения существует несколько 
// документов, возвращается хронологически первый.
// Если необходимого документа нет, он создается и записывается
// В любом случае выполняется заполнение документа
//
// Параметры:
//	МесяцНачисления
//	Организация
//	Подразделение (необязательный)
//
// Возвращаемое значение - ссылка на документ
//
Функция ДокументНачисленияЗарплаты(МесяцНачисления, Организация, Подразделение = НеОпределено) Экспорт
	Запрос = Новый Запрос();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НачислениеЗарплаты.Ссылка КАК Документ
	|ИЗ
	|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.МесяцНачисления = &МесяцНачисления
	|	И НачислениеЗарплаты.Организация = &Организация
	|	И НачислениеЗарплаты.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачислениеЗарплаты.Дата,
	|	НачислениеЗарплаты.Ссылка";
	
	Запрос.УстановитьПараметр("МесяцНачисления", МесяцНачисления);
	Запрос.УстановитьПараметр("Организация", Организация);
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И НачислениеЗарплаты.Подразделение = &Подразделение", "");
	КонецЕсли;
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ДокументОбъект = Выборка.Документ.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы.НачислениеЗарплаты.СоздатьДокумент();
		ДокументОбъект.Дата = ТекущаяДатаСеанса();
		ДокументОбъект.МесяцНачисления = МесяцНачисления;
		ДокументОбъект.Организация = Организация;
		Если ЗначениеЗаполнено(Подразделение) Тогда
			ДокументОбъект.Подразделение = Подразделение;
		КонецЕсли;
		
	КонецЕсли;
	ЗаполнитьДокументНачисленияЗарплаты(ДокументОбъект);
	ДокументОбъект.Записать();
	
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает таблицу значений с данными для распределения удержаний физлица 
// пропорционально начислениям по всем местам работы
//
// Параметры:
//	ФизическиеЛица
//	МесяцНачисления
//	Организация
//
// Возвращаемое значение:
//	Таблица значений с колонками
//		ФизическоеЛицо
//		Сотрудник
//		Подразделение
//		Сумма
//
// В настоящее время учет начисленной зарплаты ведется в разрезе сотрудников и подразделений
// поэтому возвращается таблица с полями Сотрудник, Подразделение
//
Функция ПолучитьБазуУдержанийПоУмолчанию(ФизическиеЛица, МесяцНачисления, Организация) Экспорт
	Возврат РасчетЗарплатыВнутренний.ПолучитьБазуУдержанийПоУмолчанию(ФизическиеЛица, МесяцНачисления, Организация); 
КонецФункции

// Конструирует объект для хранения данных для проведения
// Структура может содержать
//		НачисленияПоСотрудникам - таблица значений
//			ФизическоеЛицо
//			Сотрудник
//			Подразделение
//			Начисление
//			Сумма
//			ОтработаноДней
//			ОтработаноЧасов
//
//		УдержанияПоСотрудникам - таблица значений
//			ФизическоеЛицо
//			Удержание
//			Сумма
//
//		ИсчисленныйНДФЛ - таблица значений
//
//		ИсчисленныеВзносы - таблица значений
//
//		МенеджерВременныхТаблиц - менеджер временных таблиц на котором могут 
//		удерживаться таблицы
//			ВТНачисления (данные о начисленных суммах)
//				Сотрудник
//				ПериодДействия
//				ДатаНачала
//				Начисление
//				СуммаДохода
//				СуммаВычетаНДФЛ
//				СуммаВычетаВзносы
//				КодВычетаНДФЛ
//				Подразделение
//			ВТФизическиеЛица (список людей по которым выполняется расчет)
//				ФизическоеЛицо
//
Функция СоздатьДанныеДляПроведенияНачисленияЗарплаты() Экспорт
	
	Возврат РасчетЗарплатыВнутренний.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
КонецФункции

// Заполняет движения плановыми начислениями
//		ПлановыеНачисления
//		ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников
//
// Параметры:
//  РегистраторОбъект
//	Движения - коллекция движений, в которой необходимо заполнить движения
//	СтруктураДанных - Структура
//		Ключи:
//			ДанныеОПлановыхНачислениях (необязательный) - таблица значений с полями:
//				ДатаСобытия
//				Сотрудник
//				Начисление
//				Размер
//
Процедура СформироватьДвиженияПлановыхНачислений(РегистраторОбъект, Движения, СтруктураДанных) Экспорт	

	РасчетЗарплатыВнутренний.СформироватьДвиженияПлановыхНачислений(РегистраторОбъект, Движения, СтруктураДанных);
	
КонецПроцедуры

Процедура СформироватьДвиженияПлановыхУдержаний(РегистраторОбъект, Движения, СтруктураДанных) Экспорт	

	РасчетЗарплатыВнутренний.СформироватьДвиженияПлановыхУдержаний(РегистраторОбъект, Движения, СтруктураДанных);
	
КонецПроцедуры

Процедура СформироватьДвиженияЕСВСотрудников(РегистраторОбъект, Движения, СтруктураДанных) Экспорт	

	РасчетЗарплатыВнутренний.СформироватьДвиженияЕСВСотрудников(РегистраторОбъект, Движения, СтруктураДанных);
	
КонецПроцедуры

Процедура СформироватьДвиженияПараметровРасчетаИндексации(РегистраторОбъект, Движения, СтруктураДанных) Экспорт	

	РасчетЗарплатыВнутренний.СформироватьДвиженияПараметровРасчетаИндексации(РегистраторОбъект, Движения, СтруктураДанных);
	
КонецПроцедуры

// Заполняет данные для проведения начислениями и 
// временной таблицей ВТНачисления
//	
// Параметры:	
// 		ДанныеДляПроведенияНачисленияЗарплаты
//		Документ
//		ТаблицаНачислений - имя (имена через запятую) табличной части с начислениями, не обязательно, по умолчанию - "Начисления"
//		ПолеДатыДействия - поле запроса для получения даты действия, по умолчанию дата действия - месяц 
// 				начисления первичного документа, т.е. "Ссылка.МесяцНачисления"
//
Процедура ЗаполнитьНачисления(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаНачислений = "Начисления", ПолеДатыДействия = "ДатаНачала", ПолеДатыДействияКонец = "ДатаОкончания", ПолеВидаНачисления = Неопределено) Экспорт
	РасчетЗарплатыВнутренний.ЗаполнитьНачисления(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаНачислений, ПолеДатыДействия, ПолеДатыДействияКонец);
КонецПроцедуры

// Дополняет структуру данных для проведения таблицей НДФЛ
//
Процедура ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, ДокументСсылка) Экспорт
	РасчетЗарплатыВнутренний.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, ДокументСсылка);
КонецПроцедуры

// Дополняет структуру данных для проведения таблицей страховых взносов
//
Процедура ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, ДокументСсылка) Экспорт
	РасчетЗарплатыВнутренний.ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, ДокументСсылка);
КонецПроцедуры

// Заполняет данные для проведения удержаниями
//	
// Параметры:	
// 		ДанныеДляПроведенияНачисленияЗарплаты
//		Документ
//		ТаблицаУдержаний - имя табличной части с удержаниями, не обязательно, по умолчанию - "Удержания"
//
Процедура ЗаполнитьУдержания(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаУдержаний = "Удержания") Экспорт
	
	РасчетЗарплатыВнутренний.ЗаполнитьУдержания(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаУдержаний);
	
КонецПроцедуры

// Формирует временную таблицу со списком сотрудников ВТСотрудники, которые рассчитываются при 
// проведении документа
//
// Параметры:
// 		ДанныеДляПроведенияНачисленияЗарплаты
//		Документ
//		ТаблицаНачислений - имя табличной части с начислениями, не обязательно, по умолчанию - "Начисления"
//
Процедура ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаНачислений = "Начисления") Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Документ);
	Запрос.МенеджерВременныхТаблиц = ДанныеДляПроведенияНачисленияЗарплаты.МенеджерВременныхТаблиц;
	
	МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(Документ));
	ИмяТаблицыНачислений = МетаданныеДокумента.ПолноеИмя() + "." + ТаблицаНачислений;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Начисления.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	#ТаблицаНачислений КАК Начисления
	|ГДЕ
	|	Начисления.Ссылка = &Ссылка";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТаблицаНачислений", ИмяТаблицыНачислений);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Проверяет наличие в системе начислений с указанной категорией, 
// если такие начисления уже существуют, пользователю сообщается об ошибке
// 
Процедура ПроверитьУникальностьНачисленияПоКатегории(Начисление, Категория, Отказ) Экспорт
	
	Начисления = НачисленияПоКатегории(Категория);
	Если Начисления.Количество() > 0 И Начисления.Найти(Начисление) = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Начисление с назначением ""%1"" уже существует';uk='Нарахування з призначенням ""%1"" вже існує'"),
				Категория);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, , "Объект.КатегорияНачисленияИлиНеоплаченногоВремени", , Отказ);
	КонецЕсли;
		
КонецПроцедуры

// Возвращает массив начислений, соответствующие параметрам
//
// Параметры:
//		КатегорияНачисления - Перечисление.КатегорииНачисленийИНеоплаченногоВремени
// 		Отбор - Структура, содержащая в качестве ключа наименование одного из реквизитов ПланаВидовРасчета.Начисления. 
//
// Возвращаемое значение - массив начислений, соответствующих категории и отборам 
//
Функция НачисленияПоКатегории(КатегорияНачисления, Отбор = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = &КатегорияНачисления
	|	&УСЛОВИЕ
	|УПОРЯДОЧИТЬ ПО
	|	Начисления.РеквизитДопУпорядочивания";
	
	Запрос = Новый Запрос;
	
	Условие = "";
	СтрокаЗамены = "&УСЛОВИЕ";
	Если Отбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Отбор Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			Условие = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 И Начисления.%2 = &%2", Условие, КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
	Условие = ?(ЗначениеЗаполнено(Условие), Условие, "И Истина");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, СтрокаЗамены, Условие);
	
	Если ТипЗнч(КатегорияНачисления) = Тип("Массив") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "= &КатегорияНачисления", "В (&КатегорияНачисления)");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("КатегорияНачисления", КатегорияНачисления);
	
	Начисления = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Начисления.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Начисления;
	
КонецФункции

// Возвращает массив удержаний, соответствующие параметрам
//
// Параметры:
//		КатегорияУдержания - Перечисление.КатегорииУдержаний
// 		Отбор - Структура, содержащая в качестве ключа наименование одного из реквизитов ПланаВидовРасчета.Удержания. 
//				Если в качестве ключа передано "КатегорияУдержания" и значение отбора отличается от значения первого параметра, то вернется пустой массив
//
// Возвращаемое значение:
//		Удержания - массив удержаний, соответствующих роли и отборам 
//
Функция УдержанияПоКатегории(КатегорияУдержания, Отбор = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Удержания.Ссылка
	|ИЗ
	|	ПланВидовРасчета.Удержания КАК Удержания
	|ГДЕ
	|	Удержания.КатегорияУдержания = &КатегорияУдержания
	|	И &УСЛОВИЕ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("КатегорияУдержания", КатегорияУдержания);
	
	Условие = "";
	СтрокаЗамены = "&УСЛОВИЕ";
	Если НЕ Отбор = Неопределено Тогда
		Для каждого ЭлементОтбора Из Отбор Цикл
			
			Если НЕ ПустаяСтрока(Условие) Тогда
				Условие = Условие + Символы.ПС + "И ";
			КонецЕсли;
			
			Запрос.УстановитьПараметр(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
			
			Условие = Условие
			+ "Удержания." + ЭлементОтбора.Ключ + " = &" + ЭлементОтбора.Ключ;
		КонецЦикла;
	КонецЕсли;
	Условие = ?(ЗначениеЗаполнено(Условие), Условие, "Истина");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, СтрокаЗамены, Условие);
	
	Удержания = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Удержания.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Удержания;
	
КонецФункции

// Возвращает массив способов расчета зависимых от времени
//
//
Функция СпособыРасчетаЗависимыеОтВремени() Экспорт
	
	СпособыРасчета = Новый Массив;
	
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоДневнойТарифнойСтавке);
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоЧасовойТарифнойСтавке);
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоМесячнойТарифнойСтавкеПоДням);
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоМесячнойТарифнойСтавкеПоЧасам);
	
	Возврат СпособыРасчета;
	
КонецФункции

// Возвращает массив способов расчета зависимых от базы
//
//
Функция СпособыРасчетаЗависимыеОтБазы() Экспорт
	
	СпособыРасчета = Новый Массив;
	
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.Процентом);
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаУдержаний.Процентом);
	
	Возврат СпособыРасчета;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет данные начисления зарплаты за месяц
// Параметры:
//	ДанныеНачисленияЗарплаты - объект, описывающий документ начисления зарплаты и 
//  содержащий следующий минимальный набор полей
//		Ссылка
//		МесяцНачисления
//		Организация
//		Подразделение
//		Начисления - коллекция со списком начисления, со следующим 
//		минимальным набором полей:
//			Сотрудник
//			Подразделение
//			Начисление
//			Результат
//			ОтработаноДней
//			ОтработаноЧасов
//		Удержания и иные коллекции, содержащие данные начисления зарплаты, 
//		которые могут быть разными в зависимости от реализации документа начисления
//		
Процедура ЗаполнитьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты) Экспорт
	РасчетЗарплатыВнутренний.ЗаполнитьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты);
КонецПроцедуры

Функция ДоЗаполнитьДокументНачисленияЗарплаты(Объект, СписокФизическихЛиц) Экспорт
	Возврат РасчетЗарплатыВнутренний.ДоЗаполнитьДокументНачисленияЗарплаты(Объект, СписокФизическихЛиц);
КонецФункции

// Заполняет данные начисления зарплаты за месяц
// Параметры:
//	ДанныеНачисленияЗарплаты - объект, описывающий документ начисления зарплаты и 
//  содержащий следующий минимальный набор полей
//		Ссылка
//		МесяцНачисления
//		Организация
//		Подразделение
//		Начисления - коллекция со списком начисления, со следующим 
//		минимальным набором полей:
//			Сотрудник
//			Подразделение
//			Начисление
//			Результат
//			ОтработаноДней
//			ОтработаноЧасов
//		Удержания и иные коллекции, содержащие данные начисления зарплаты, 
//		которые могут быть разными в зависимости от реализации документа начисления
//		
Процедура ПересчитатьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты) Экспорт
	РасчетЗарплатыВнутренний.ПересчитатьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты);
КонецПроцедуры

// Возвращает таблицу значений, содержащую данные начисления и расчета зарплаты
//
// Параметры:
//	Организация
//	ДатаНачала, 
//	ДатаОкончания,
//	МесяцНачисления,
//	Документ - документ, для которого получаются данные для начисления
//	Подразделение - не обязательный
//	Сотрудники - не обязательный
//
// Возвращаемое значение:
//	Таблица значений, которая содержит, как минимум, колонки
//		Сотрудник
//		Подразделение
//		Начисление
//		Результат
Функция РезультатНачисленияРасчетаЗарплаты(Организация, ПредварительныйРасчет, ДатаНачала, ДатаОкончания, МесяцНачисления, Документ, Подразделение = НеОпределено, Сотрудники = НеОпределено) Экспорт
	Возврат РасчетЗарплатыВнутренний.РезультатНачисленияРасчетаЗарплаты(Организация, ПредварительныйРасчет, ДатаНачала, ДатаОкончания, МесяцНачисления, Документ, Подразделение, Сотрудники);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Важные даты

//Функция определения даты ввода фиксированной индексации
//
Функция ДатаВвводаФиксированнойИндексации() Экспорт
	
	Возврат Дата(2012,6,1);
	
КонецФункции

//Функция определения даты ввода индексации по должностям
//
Функция ДатаВвводаИндексацииПоДожностям() Экспорт
	
	Возврат Дата(2015,12,1);
	
КонецФункции

//Функция определения даты зменения порога индексации
//
Функция ДатаИзмененияПорогаИндексации() Экспорт
	
	Возврат Дата(2016,1,1);
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Блок функций первоначального заполнения и обновления ИБ
//

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.2.2";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьИндексыИнфляции";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.2.2";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьБюджетныеВеличины";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.2.2";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьДополнительныеГарантииВСодействииТрудоустройству";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.3.1";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьИндексыИнфляции";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.3.1";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьДоплатуДоМинЗП";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.3.1";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьИндексацию";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.8.1";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьИндексыИнфляции";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.8.1";
	Обработчик.Процедура = "РасчетЗарплаты.ОбновитьБюджетныеВеличины";

КонецПроцедуры

Процедура ОбновитьИндексыИнфляции() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ИндексИнфляции");	
	
КонецПроцедуры

Процедура ОбновитьБюджетныеВеличины() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "МинимальнаяОплатаТруда");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПрожиточныеМинимумы");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПределыСтраховыхВзносов");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "РазмерыЛьготНДФЛ");
	
КонецПроцедуры

Процедура ОбновитьДополнительныеГарантииВСодействииТрудоустройству() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("Справочник", "ДополнительныеГарантииВСодействииТрудоустройству");	
	
КонецПроцедуры

Процедура ОбновитьДоплатуДоМинЗП() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьПланВидовРасчета("Начисления",,"ДоплатаДоМЗП");
	
КонецПроцедуры	

Процедура ОбновитьИндексацию() Экспорт
	
	ВРОбъект = ПланыВидовРасчета.Начисления.ИндексацияЗарплаты.ПолучитьОбъект();
	ВРОбъект.ВидПропорцииВремени = Перечисления.ВидыПропорцииВремени.ПоДням;
	ВРОбъект.Записать();
	
КонецПроцедуры	


