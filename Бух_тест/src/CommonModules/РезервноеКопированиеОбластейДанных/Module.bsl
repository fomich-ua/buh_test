////////////////////////////////////////////////////////////////////////////////
// РезервноеКопированиеОбластейДанных.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обмен сообщениями

// Возвращает состояние использования резервного копирования областей данных.
//
// Возвращаемое значение: Булево.
//
Функция РезервноеКопированиеИспользуется() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ПоддержкаРезервногоКопирования.Получить();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииПсевдонимовОбработчиков"].Добавить(
				"РезервноеКопированиеОбластейДанных");
	КонецЕсли;
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
			"РезервноеКопированиеОбластейДанных");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов"].Добавить(
			"РезервноеКопированиеОбластейДанных");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"].Добавить(
				"РезервноеКопированиеОбластейДанных");
	КонецЕсли;
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
			"РезервноеКопированиеОбластейДанных");
			
	СерверныеОбработчики[
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииОбработчиковОшибок"].Добавить(
			"РезервноеКопированиеОбластейДанных");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\РегистрацияИнтерфейсовПринимаемыхСообщений"].Добавить(
			"РезервноеКопированиеОбластейДанных");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями\РегистрацияИнтерфейсовОтправляемыхСообщений"].Добавить(
			"РезервноеКопированиеОбластейДанных");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных
//    В качестве значения можно указать Неопределено, в этом случае считается что имя 
//    совпадает с псевдонимом
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("РезервноеКопированиеОбластейДанных.ВыгрузитьОбластьВХранилищеМС");
	СоответствиеИменПсевдонимам.Вставить("РезервноеКопированиеОбластейДанных.СозданиеКопий");
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию подсистем,
// используя в качестве ключей названия подсистем.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура: 
//	- Ключи = Названия подсистем. 
//	- Значения = Массивы названий поддерживаемых версий.
//
// Пример реализации:
//
//	// СервисПередачиФайлов
//	МассивВерсий = Новый Массив;
//	МассивВерсий.Добавить("1.0.1.1");	
//	МассивВерсий.Добавить("1.0.2.1"); 
//	СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//	// Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	МассивВерсий.Добавить("1.0.1.2");
	СтруктураПоддерживаемыхВерсий.Вставить("РезервноеКопированиеОбластейДанных", МассивВерсий);
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.9";
	Обработчик.Процедура = "РезервноеКопированиеОбластейДанных.ПеренестиСостояниеПланированияРезервногоКопированияВоВспомогательныеДанные";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Заполняет массив типов, исключаемых из выгрузки и загрузки данных.
//
// Параметры:
//  Типы - Массив(Типы).
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Константы.ВыполнитьРезервноеКопированиеОбластиДанных);
	Типы.Добавить(Метаданные.Константы.ДатаПоследнегоСтартаКлиентскогоСеанса);
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПриЗаполненииТаблицыПараметровИБ(ТаблицаПараметров) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СтрокаПараметра = МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ПоддержкаРезервногоКопирования");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет соответствие методов обработчиков ошибок псевдонимам методов, при возникновении
// ошибок в которых они вызываются.
//
// Параметры:
//  ОбработчикиОшибок - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода - обработчика ошибок, для вызова при возникновении ошибки. 
//    Обработчик ошибок вызывается в случае завершения выполнения исходного задания
//    с ошибкой. Обработчик ошибок вызывается в той же области данных, что и исходное
//    задание.
//    Метод обработчика ошибок считается разрешенным к вызову механизмами очереди. 
//    Параметры обработчика ошибок:
//     ПараметрыЗадания - Структура - параметры задания очереди
//      Параметры
//      НомерПопытки
//      КоличествоПовторовПриАварийномЗавершении
//      ДатаНачалаПоследнегоЗапуска
//     ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки, произошедшей при
//      выполнении задания
//
Процедура ПриОпределенииОбработчиковОшибок(ОбработчикиОшибок) Экспорт
	
	ОбработчикиОшибок.Вставить(
		"РезервноеКопированиеОбластейДанных.СозданиеКопий",
		"РезервноеКопированиеОбластейДанных.ОшибкаСозданияКопии");
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений
//
// Параметры:
//  МассивОбработчиков - массив
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУправлениеРезервнымКопированиемИнтерфейс);
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  отправляемых сообщений
//
// Параметры:
//  МассивОбработчиков - массив
//
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольРезервногоКопированияИнтерфейс);
	
КонецПроцедуры

// Активность пользователей в области данных

// Устанавливает признак активности пользователя в текущей области.
// Признаком является значение совместно разделенной константы ДатаПоследнегоСтартаКлиентскогоСеанса.
//
Процедура УстановитьФлагАктивностиПользователяВОбласти() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация()
		ИЛИ НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
		ИЛИ ТекущийРежимЗапуска() = Неопределено
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ПоддержкаРезервногоКопирования")
		ИЛИ РаботаВМоделиСервиса.ОбластьДанныхЗаблокирована(ОбщегоНазначения.ЗначениеРазделителяСеанса()) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьФлагАктивностиВОбласти(); // Для обратной совместимости
	
	ДатаСтарта = НачалоДня(ТекущаяУниверсальнаяДата());
	
	Если Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Получить() = ДатаСтарта Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Установить(ДатаСтарта);
	
КонецПроцедуры

// Устанавливает либо снимает признак активности пользователя в текущей области.
// Признаком является значение совместно разделенной константы ВыполнитьРезервноеКопированиеОбластиДанных.
// Устарело.
//
// Параметры:
// ОбластьДанных - Число; Неопределено - Значение разделителя. Неопределено означает значение разделителя текущей области данных.
// Состояние - Булево - Истина, если признак надо установить; Ложь, если снять.
//
Процедура УстановитьФлагАктивностиВОбласти(Знач ОбластьДанных = Неопределено, Знач Состояние = Истина)
	
	Если ОбластьДанных = Неопределено Тогда
		Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Иначе
			ВызватьИсключение НСтр("ru='При вызове процедуры УстановитьФлагАктивностиВОбласти из неразделенного сеанса параметр ОбластьДанных является обязательным!';uk=""При виклику процедури УстановитьФлагАктивностиВОбласти з нерозподіленого сеансу параметр ОбластьДанных є обов'язковим!""");
		КонецЕсли;
	Иначе
		Если НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
				И ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() Тогда
			
			ВызватьИсключение(НСтр("ru='Запрещено работать с данными области кроме текущей';uk='Заборонено працювати з даними області крім поточної'"));
			
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Состояние Тогда
		МенеджерЗначения = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
		МенеджерЗначения.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗначения.Прочитать();
		Если МенеджерЗначения.Значение Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ФлагАктивности = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
	ФлагАктивности.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
	ФлагАктивности.Значение = Состояние;
	ОбщегоНазначения.ЗаписатьВспомогательныеДанные(ФлагАктивности);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Выгрузка областей данных.

// Создает резервную копию области в соответствии с настройками резервного копирования
// области.
//
// Параметры:
//  ПараметрыСоздания - ФиксированнаяСтруктура - параметры создания резервной копии,
//   соответствуют настройкам резервного копирования
//  СостояниеСоздания - ФиксированнаяСтруктура - состояние процесса создания
//   резервных копий в области
//
Процедура СозданиеКопий(Знач ПараметрыСоздания, Знач СостояниеСоздания) Экспорт
	
	НачалоВыполнения = ТекущаяУниверсальнаяДата();
	
	УсловияСозданияКопий = Новый Массив;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежедневная");
	Параметры.Вставить("Включены", "СоздаватьЕжедневные");
	Параметры.Вставить("Периодичность", "День");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжедневной");
	Параметры.Вставить("День", Неопределено);
	Параметры.Вставить("Месяц", Неопределено);
	УсловияСозданияКопий.Добавить(Параметры);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежемесячная");
	Параметры.Вставить("Включены", "СоздаватьЕжемесячные");
	Параметры.Вставить("Периодичность", "Месяц");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжемесячной");
	Параметры.Вставить("День", "ДеньСозданияЕжемесячных");
	Параметры.Вставить("Месяц", Неопределено);
	УсловияСозданияКопий.Добавить(Параметры);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежегодная");
	Параметры.Вставить("Включены", "СоздаватьЕжегодные");
	Параметры.Вставить("Периодичность", "Год");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжегодной");
	Параметры.Вставить("День", "ДеньСозданияЕжегодных");
	Параметры.Вставить("Месяц", "МесяцСозданияЕжегодных");
	УсловияСозданияКопий.Добавить(Параметры);
	
	ТребуетсяСоздание = Ложь;
	ТекущаяДата = ТекущаяУниверсальнаяДата();
	
	ПоследнийСеанс = Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Получить();
	
	СоздаватьБезусловно = НЕ ПараметрыСоздания.ТолькоПриАктивностиПользователей;
	
	ФлагиПериодичности = Новый Структура;
	Для каждого ПараметрыПериодичности Из УсловияСозданияКопий Цикл
		
		ФлагиПериодичности.Вставить(ПараметрыПериодичности.Тип, Ложь);
		
		Если НЕ ПараметрыСоздания[ПараметрыПериодичности.Включены] Тогда
			// Создание копий данной периодичности выключено в настройках
			Продолжить;
		КонецЕсли;
		
		ДатаСозданияПредыдущей = СостояниеСоздания[ПараметрыПериодичности.ДатаСоздания];
		
		Если Год(ТекущаяДата) = Год(ДатаСозданияПредыдущей) Тогда
			Если ПараметрыПериодичности.Периодичность = "Год" Тогда
				// Год еще не сменился
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Месяц(ТекущаяДата) = Месяц(ДатаСозданияПредыдущей) Тогда
			Если ПараметрыПериодичности.Периодичность = "Месяц" Тогда
				// Месяц еще не сменился
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если День(ТекущаяДата) = День(ДатаСозданияПредыдущей) Тогда
			// День еще не сменился
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыПериодичности.День <> Неопределено
			И День(ТекущаяДата) < ПараметрыСоздания[ПараметрыПериодичности.День] Тогда
			
			// Нужный день еще не наступил
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыПериодичности.Месяц <> Неопределено
			И Месяц(ТекущаяДата) < ПараметрыСоздания[ПараметрыПериодичности.Месяц] Тогда
			
			// Нужный месяц еще не наступил
			Продолжить;
		КонецЕсли;
		
		Если НЕ СоздаватьБезусловно
			И ЗначениеЗаполнено(ДатаСозданияПредыдущей)
			И ПоследнийСеанс < ДатаСозданияПредыдущей Тогда
			
			// Пользователи не заходили в область после создания резервной копии
			Продолжить;
		КонецЕсли;
		
		ТребуетсяСоздание = Истина;
		ФлагиПериодичности.Вставить(ПараметрыПериодичности.Тип, Истина);
		
	КонецЦикла;
	
	Если НЕ ТребуетсяСоздание Тогда
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации() + "." 
				+ НСтр("ru='Пропуск создания';uk='Пропуск створення'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация);
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаОбластейДанных") Тогда
		
		РаботаВМоделиСервиса.ВызватьИсключениеОтсутствуетПодсистемаБТС("ТехнологияСервиса.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаОбластейДанных");
		
	КонецЕсли;
	
	МодульВыгрузкаЗагрузкаОбластейДанных = ОбщегоНазначения.ОбщийМодуль("ВыгрузкаЗагрузкаОбластейДанных");
	
	ИмяАрхива = Неопределено;
	
	ПараметрыБлокировки = СоединенияИБ.НовыеПараметрыБлокировкиСоединений();
	ПараметрыБлокировки.Начало = ТекущаяУниверсальнаяДата();
	ПараметрыБлокировки.Сообщение = НСтр("ru='Выполняется создание резервной копии приложения. Настройки резервного копирования могут быть изменены в менеджере сервиса.';uk='Виконується створення резервної копії додатку. Настройки резервного копіювання можуть бути змінені в менеджері сервісу.'");
	ПараметрыБлокировки.Установлена = Истина;
	
	СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(ПараметрыБлокировки, Ложь);
	
	ИмяАрхива = МодульВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив();
	
	ДатаСозданияКопии = ТекущаяУниверсальнаяДата();
	
	ОписаниеАрхива = Новый Файл(ИмяАрхива);
	РазмерФайла = ОписаниеАрхива.Размер();
	
	ИДФайла = РаботаВМоделиСервиса.ПоместитьФайлВХранилищеМенеджераСервиса(ОписаниеАрхива);
	
	Попытка
		УдалитьФайлы(ИмяАрхива);
	Исключение
		// При невозможности удаления файла выполнение не должно прерываться
	КонецПопытки;
	
	ИдКопии = Новый УникальныйИдентификатор;
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("ОбластьДанных", ОбщегоНазначения.ЗначениеРазделителяСеанса());
	ПараметрыСообщения.Вставить("ИДКопии", ИдКопии);
	ПараметрыСообщения.Вставить("ИДФайла", ИДФайла);
	ПараметрыСообщения.Вставить("ДатаСоздания", ДатаСозданияКопии);
	Для каждого КлючИЗначение Из ФлагиПериодичности Цикл
		ПараметрыСообщения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ОтправитьСообщениеРезервнаяКопияОбластиСоздана(ПараметрыСообщения);
	
	// Обновление состояния в параметрах
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("ИмяМетода", "РезервноеКопированиеОбластейДанных.СозданиеКопий");
	ОтборЗаданий.Вставить("Ключ", "1");
	Задания = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
	Если Задания.Количество() > 0 Тогда
		Задание = Задания[0].Идентификатор;
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(ПараметрыСоздания);
		
		ОбновленноеСостояние = Новый Структура;
		Для каждого ПараметрыПериодичности Из УсловияСозданияКопий Цикл
			Если ФлагиПериодичности[ПараметрыПериодичности.Тип] Тогда
				ДатаСостояния = ДатаСозданияКопии;
			Иначе
				ДатаСостояния = СостояниеСоздания[ПараметрыПериодичности.ДатаСоздания];
			КонецЕсли;
			
			ОбновленноеСостояние.Вставить(ПараметрыПериодичности.ДатаСоздания, ДатаСостояния);
		КонецЦикла;
		
		ПараметрыМетода.Добавить(Новый ФиксированнаяСтруктура(ОбновленноеСостояние));
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
	КонецЕсли;
	
	ПараметрыБлокировки = СоединенияИБ.НовыеПараметрыБлокировкиСоединений();
	ПараметрыБлокировки.Установлена = Ложь;
	
	СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(ПараметрыБлокировки, Ложь);
	
	ПараметрыСобытия = Новый Структура;
	Для каждого КлючИЗначение Из ФлагиПериодичности Цикл
		ПараметрыСобытия.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	ПараметрыСобытия.Вставить("ИдКопии", ИдКопии);
	ПараметрыСобытия.Вставить("ИдФайла", ИдФайла);
	ПараметрыСобытия.Вставить("Размер", РазмерФайла);
	ПараметрыСобытия.Вставить("Длительность", ТекущаяУниверсальнаяДата() - НачалоВыполнения);
	
	ЗаписатьСобытиеВЖурнал(
		НСтр("ru='Создание';uk='Створення'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		ПараметрыСобытия);
	
КонецПроцедуры

// При исчерпании количества попыток создания резервной копии, записывает в журнал
// регистрации сообщение о том, что копия не была создана.
//
// Параметры:
//  ПараметрыЗадания - Структура - описание см. описание события
//   СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииОбработчиковОшибок
//
Процедура ОшибкаСозданияКопии(Знач ПараметрыЗадания, Знач ИнформацияОбОшибке) Экспорт
	
	Если ПараметрыЗадания.НомерПопытки < ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении Тогда
		ШаблонКомментария = НСтр("ru='При создании резервной копии области %1 произошла ошибка."
"Номер попытки: %2"
"По причине:"
"%3';uk='При створенні резервної копії області %1 відбулася помилка."
"Номер спроби: %2"
"З причини:"
"%3'");
		Уровень = УровеньЖурналаРегистрации.Предупреждение;
		Событие = НСтр("ru='Ошибка итерации создания';uk='Помилка ітерації створення'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Иначе
		ШаблонКомментария = НСтр("ru='При создании резервной копии области %1 произошла невосстановимая ошибка."
"Номер попытки: %2"
"По причине:"
"%3';uk='При створенні резервної копії області %1 відбулася невідновна помилка."
"Номер спроби: %2"
"З причини:"
"%3'");
		Уровень = УровеньЖурналаРегистрации.Ошибка;
		Событие = НСтр("ru='Ошибка создания';uk='Помилка створення'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		
		ПараметрыБлокировки = СоединенияИБ.НовыеПараметрыБлокировкиСоединений();
		ПараметрыБлокировки.Установлена = Ложь;
		
		СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(ПараметрыБлокировки, Ложь);
	КонецЕсли;
	
	ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонКомментария,
		Формат(ОбщегоНазначения.ЗначениеРазделителяСеанса(), "ЧН=0; ЧГ="),
		ПараметрыЗадания.НомерПопытки,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации() + "." + Событие,
		Уровень,
		,
		,
		ТекстКомментария);
	
КонецПроцедуры

// Планирует создание резервной копии области данных.
// 
// Параметры:
//  ПараметрыВыгрузки - Структура, состав ключей см. СоздатьПустыеПараметрыВыгрузки()
//   
Процедура ЗапланироватьАрхивациюВОчереди(Знач ПараметрыВыгрузки) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru='Не достаточно прав для выполнения операции';uk='Не достатньо прав для виконання операції'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ПараметрыВыгрузки);
	ПараметрыМетода.Добавить(Неопределено);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода", РезервноеКопированиеОбластейДанныхПовтИсп.ИмяМетодаФоновогоРезервногоКопирования());
	ПараметрыЗадания.Вставить("Ключ", "" + ПараметрыВыгрузки.ИДКопии);
	ПараметрыЗадания.Вставить("ОбластьДанных", ПараметрыВыгрузки.ОбластьДанных);
	
	// Поиск активных заданий с тем же ключом.
	АктивныеЗадания = ОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
	
	Если АктивныеЗадания.Количество() = 0 Тогда
		
		// Планируем выполнение нового
		
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ПараметрыВыгрузки.МоментЗапуска);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		Если АктивныеЗадания[0].СостояниеЗадания <> Перечисления.СостоянияЗаданий.Запланировано Тогда
			// Задание уже выполнилось или выполняется
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания.Удалить("ОбластьДанных");
		
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ПараметрыВыгрузки.МоментЗапуска);
		
		ОчередьЗаданий.ИзменитьЗадание(АктивныеЗадания[0].Идентификатор, ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

// Создает файл выгрузки заданной области и помещает его в хранилище Менеджера сервиса.
//
// Параметры:
// ПараметрыВыгрузки - Структура:
// 	- ОбластьДанных - Число.
//	- ИДКопии - УникальныйИдентификатор; Неопределено.
//  - МоментЗапуска - Дата - момент запуска архивирования области.
//	- Принудительно - Булево - Флаг из МС: необходимость создавать копию вне зависимости от активности пользователей.
//	- ПоТребованию - Булево - флаг интерактивного запуска архивирования. Если из МС - всегда Ложь.
//	- ИДФайла - УникальныйИдентификатор - ИД файла выгрузки в хранилище МС.
//	- НомерПопытки - Число - Счетчик попыток. Начальное значение: 1.
//
Процедура ВыгрузитьОбластьВХранилищеМС(Знач ПараметрыВыгрузки, АдресХранилища = Неопределено) Экспорт
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru='Нарушение прав доступа';uk='Порушення прав доступу'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТребуетсяВыгрузка(ПараметрыВыгрузки) Тогда
		ОтправитьСообщениеАрхивацияОбластиПропущена(ПараметрыВыгрузки);
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаОбластейДанных") Тогда
		
		РаботаВМоделиСервиса.ВызватьИсключениеОтсутствуетПодсистемаБТС("ТехнологияСервиса.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаОбластейДанных");
		
	КонецЕсли;
	
	МодульВыгрузкаЗагрузкаОбластейДанных = ОбщегоНазначения.ОбщийМодуль("ВыгрузкаЗагрузкаОбластейДанных");
	
	ИмяАрхива = Неопределено;
	
	Попытка
		
		ИмяАрхива = МодульВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив();
		ИДФайла = РаботаВМоделиСервиса.ПоместитьФайлВХранилищеМенеджераСервиса(Новый Файл(ИмяАрхива));
		Попытка
			УдалитьФайлы(ИмяАрхива);
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться
		КонецПопытки;
		
		НачатьТранзакцию();
		
		Попытка
			
			ПараметрыВыгрузки.Вставить("ИДФайла", ИДФайла);
			ПараметрыВыгрузки.Вставить("ДатаСоздания", ТекущаяУниверсальнаяДата());
			ОтправитьСообщениеРезервнаяКопияОбластиСоздана(ПараметрыВыгрузки);
			Если ЗначениеЗаполнено(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ИДФайла, АдресХранилища);
			КонецЕсли;
			УстановитьФлагАктивностиВОбласти(ПараметрыВыгрузки.ОбластьДанных, Ложь);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ВызватьИсключение;
			
		КонецПопытки;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Создание резервной копии области данных';uk='Створення резервної копії області даних'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Попытка
			Если ИмяАрхива <> Неопределено Тогда
				УдалитьФайлы(ИмяАрхива);
			КонецЕсли;
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться
		КонецПопытки;
		Если ПараметрыВыгрузки.ПоТребованию Тогда
			ВызватьИсключение;
		Иначе	
			Если ПараметрыВыгрузки.НомерПопытки > 3 Тогда
				ОтправитьСообщениеОшибкаАрхивацииОбласти(ПараметрыВыгрузки);
			Иначе	
				// Перепланировать: текущее время области + 10 минут.
				ПараметрыВыгрузки.НомерПопытки = ПараметрыВыгрузки.НомерПопытки + 1;
				МоментПовторногоЗапуска = ТекущаяДатаОбласти(ПараметрыВыгрузки.ОбластьДанных); // Сейчас в области.
				МоментПовторногоЗапуска = МоментПовторногоЗапуска + 10 * 60; // На 10 минут позже.
				ПараметрыВыгрузки.Вставить("МоментЗапуска", МоментПовторногоЗапуска);
				ЗапланироватьАрхивациюВОчереди(ПараметрыВыгрузки);
			КонецЕсли;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Функция ТекущаяДатаОбласти(Знач ОбластьДанных)
	
	ЧасовойПояс = РаботаВМоделиСервиса.ПолучитьЧасовойПоясОбластиДанных(ОбластьДанных);
	Возврат МестноеВремя(ТекущаяУниверсальнаяДата(), ЧасовойПояс);
	
КонецФункции

Функция ТребуетсяВыгрузка(Знач ПараметрыВыгрузки)
	
	Если НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
		И ПараметрыВыгрузки.ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() Тогда
		
		ВызватьИсключение(НСтр("ru='Запрещено работать с данными области кроме текущей';uk='Заборонено працювати з даними області крім поточної'"));
	КонецЕсли;
	
	Результат = ПараметрыВыгрузки.Принудительно;
	
	Если Не Результат Тогда
		
		Менеджер = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
		Менеджер.ОбластьДанныхВспомогательныеДанные = ПараметрыВыгрузки.ОбластьДанных;
		Менеджер.Прочитать();
		Результат = Менеджер.Значение;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает незаполненную структуру нужного формата.
//
// Возвращаемое значение:
// Структура:
// 	- ОбластьДанных - Число.
//	- ИДКопии - УникальныйИдентификатор; Неопределено.
//  - МоментЗапуска - Дата - момент запуска архивирования области.
//	- Принудительно - Булево - Флаг из МС: необходимость создавать копию вне зависимости от активности пользователей.
//	- ПоТребованию - Булево - флаг интерактивного запуска архивирования. Если из МС - всегда Ложь.
//	- ИДФайла - УникальныйИдентификатор - ИД файла выгрузки в хранилище МС.
//	- НомерПопытки - Число - Счетчик попыток. Начальное значение: 1.
//
Функция СоздатьПустыеПараметрыВыгрузки() Экспорт
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ОбластьДанных");
	ПараметрыВыгрузки.Вставить("ИДКопии");
	ПараметрыВыгрузки.Вставить("МоментЗапуска");
	ПараметрыВыгрузки.Вставить("Принудительно");
	ПараметрыВыгрузки.Вставить("ПоТребованию");
	ПараметрыВыгрузки.Вставить("ИДФайла");
	ПараметрыВыгрузки.Вставить("НомерПопытки", 1);
	Возврат ПараметрыВыгрузки;
	
КонецФункции

// Отменяет запланированное ранее создание резервной копии.
//
// ПараметрыОтмены - Структура
//  ОбластьДанных - Число - область данных создание резервной копии в которой требуется отменить
//  ИДКопии - УникальныйИдентификатор - идентификатор копии, создание которой требуется отменить
//
Процедура ОтменитьСозданиеРезервнойКопииОбласти(Знач ПараметрыОтмены) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru='Не достаточно прав для выполнения операции';uk='Не достатньо прав для виконання операції'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяМетода = РезервноеКопированиеОбластейДанныхПовтИсп.ИмяМетодаФоновогоРезервногоКопирования();
	
	Отбор = Новый Структура("ИмяМетода, Ключ, ОбластьДанных", 
		ИмяМетода, "" + ПараметрыОтмены.ИДКопии, ПараметрыОтмены.ОбластьДанных);
	Задания = ОчередьЗаданий.ПолучитьЗадания(Отбор);
	
	Для Каждого Задание Из Задания Цикл
		ОчередьЗаданий.УдалитьЗадание(Задание.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

// Сообщить об успешной архивации текущей области.
//
Процедура ОтправитьСообщениеРезервнаяКопияОбластиСоздана(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеРезервнаяКопияОбластиСоздана());
		
		Тело = Сообщение.Body;
		
		Тело.Zone = ПараметрыСообщения.ОбластьДанных;
		Тело.BackupId = ПараметрыСообщения.ИДКопии;
		Тело.FileId = ПараметрыСообщения.ИДФайла;
		Тело.Date = ПараметрыСообщения.ДатаСоздания;
		Если ПараметрыСообщения.Свойство("Ежедневная") Тогда
			Тело.Daily = ПараметрыСообщения.Ежедневная;
			Тело.Monthly = ПараметрыСообщения.Ежемесячная;
			Тело.Yearly = ПараметрыСообщения.Ежегодная;
		Иначе
			Тело.Daily = Ложь;
			Тело.Monthly = Ложь;
			Тело.Yearly = Ложь;
		КонецЕсли;
		Тело.ConfigurationVersion = Метаданные.Версия;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Планировать архивацию области в прикладной базе.
//
Процедура ОтправитьСообщениеОшибкаАрхивацииОбласти(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеОшибкаАрхивацииОбласти());
		
		Сообщение.Body.Zone = ПараметрыСообщения.ОбластьДанных;
		Сообщение.Body.BackupId = ПараметрыСообщения.ИДКопии;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Планировать архивацию области в прикладной базе.
//
Процедура ОтправитьСообщениеАрхивацияОбластиПропущена(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеАрхивацияОбластиПропущена());
		
		Сообщение.Body.Zone = ПараметрыСообщения.ОбластьДанных;
		Сообщение.Body.BackupId = ПараметрыСообщения.ИДКопии;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru='Резервное копирование приложений';uk='Резервне копіювання додатків'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Процедура ЗаписатьСобытиеВЖурнал(Знач Событие, Знач Параметры)
	
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации() + "." + Событие,
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ОбщегоНазначения.ЗначениеВСтрокуXML(Параметры));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с настройками резервного копирования

// Возвращает структуру настроек резервного копирования области данных.
//
// Параметры:
// ОбластьДанных - Число; Неопределено - Если Неопределено, возвращаются системные настройки.
//
// Возвращаемое значение:
// Структура - структура настроек. 
//	См. РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским().
//
Функция ПолучитьНастройкиРезервногоКопированияОбласти(Знач ОбластьДанных = Неопределено) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
		И ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() 
		И ОбластьДанных <> Неопределено Тогда
		
		ВызватьИсключение(НСтр("ru='Запрещено работать с данными области кроме текущей';uk='Заборонено працювати з даними області крім поточної'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = РезервноеКопированиеОбластейДанныхПовтИсп.ПроксиКонтроляРезервногоКопирования();
	
	НастройкиXDTO = Неопределено;
	СообщениеОбОшибке = Неопределено;
	Если ОбластьДанных = Неопределено Тогда
		ОперацияВыполнена = Прокси.GetDefaultSettings(НастройкиXDTO, СообщениеОбОшибке);
	Иначе
		ОперацияВыполнена = Прокси.GetSettings(ОбластьДанных, НастройкиXDTO, СообщениеОбОшибке);
	КонецЕсли;
	
	Если НЕ ОперацияВыполнена Тогда
		ШаблонСообщения = НСтр("ru='Ошибка при получении настроек резервного копирования:"
"%1';uk='Помилка при отриманні настройок резервного копіювання:"
"%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СообщениеОбОшибке);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат НастройкиXDTOВСтруктуру(НастройкиXDTO);
	
КонецФункции	

// Записывает настройки резервного копирования области данных в хранилище менеджера сервиса.
//
// Параметры:
// ОбластьДанных - Число.
// НастройкиРезервногоКопирования - Структура.
//
// Возвращаемое значение:
// Булево - успешность записи. 
//
Процедура УстановитьНастройкиРезервногоКопированияОбласти(Знач ОбластьДанных, Знач НастройкиРезервногоКопирования) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
		И ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() Тогда
		
		ВызватьИсключение(НСтр("ru='Запрещено работать с данными области кроме текущей';uk='Заборонено працювати з даними області крім поточної'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = РезервноеКопированиеОбластейДанныхПовтИсп.ПроксиКонтроляРезервногоКопирования();
	
	Тип = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl", "Settings");
	НастройкиXDTO = Прокси.ФабрикаXDTO.Создать(Тип);
	
	СоответствиеИмен = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	Для Каждого ПараИменНастроек Из СоответствиеИмен Цикл
		НастройкиXDTO[ПараИменНастроек.Ключ] = НастройкиРезервногоКопирования[ПараИменНастроек.Значение];
	КонецЦикла;
	
	СообщениеОбОшибке = Неопределено;
	Если НЕ Прокси.SetSettings(ОбластьДанных, НастройкиXDTO, СообщениеОбОшибке) Тогда
		ШаблонСообщения = НСтр("ru='Ошибка при сохранении настроек резервного копирования:"
"%1';uk='Помилка при збереженні настройок резервного копіювання:"
"%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СообщениеОбОшибке);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Преобразования типов

Функция НастройкиXDTOВСтруктуру(Знач НастройкиXDTO)
	
	Если НастройкиXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Результат = Новый Структура;
	СоответствиеИмен = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	Для Каждого ПараИменНастроек Из СоответствиеИмен Цикл
		Если НастройкиXDTO.Установлено(ПараИменНастроек.Ключ) Тогда
			Результат.Вставить(ПараИменНастроек.Значение, НастройкиXDTO[ПараИменНастроек.Ключ]);
		КонецЕсли;
	КонецЦикла;
	Возврат  Результат; 
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Переносит данные из регистра УдалитьОбластиКРезервномуКопированию в значения разделенной
// константы ВыполнитьРезервноеКопированиеОбластиДанных.
//
Процедура ПеренестиСостояниеПланированияРезервногоКопированияВоВспомогательныеДанные() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	УдалитьОбластиКРезервномуКопированию.ОбластьДанных
		|ИЗ
		|	РегистрСведений.УдалитьОбластиКРезервномуКопированию КАК УдалитьОбластиКРезервномуКопированию";
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СостояниеПланирования = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
			СостояниеПланирования.ОбластьДанныхВспомогательныеДанные = Выборка.ОбластьДанных;
			СостояниеПланирования.Значение = Истина;
			СостояниеПланирования.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
