&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьПараметрыВыбораСчета();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗаданияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Отчет.НачалоПериода = Отчет.КонецПериода;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
		СтрокаТаблицы.ИспользованиеВДиаграмме = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
		СтрокаТаблицы.ИспользованиеВДиаграмме = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЛевоеЗначение = ЭтаФорма.Элементы.Отборы.ТекущиеДанные.ЛевоеЗначение;
	ТекущийВидСравнения = ЭтаФорма.Элементы.Отборы.ТекущиеДанные.ВидСравнения;
	
	ПолеКомпоновкиДанныхСчет = Новый ПолеКомпоновкиДанных("Счет");
	
	Если ЛевоеЗначение = ПолеКомпоновкиДанныхСчет 
		И (ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.ВСписке 
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.НеВСписке) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ФормаВыбораСчета = ПолучитьФорму("ПланСчетов.Хозрасчетный.ФормаВыбора",,Элемент);
		ФормаВыбораСчета.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ФормаВыбораСчета.Список.Отбор,"Ссылка", СписокСчетов, ВидСравненияКомпоновкиДанных.ВСписке);
		
		ФормаВыбораСчета.Открыть();
		
	Иначе
		
		СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
		БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
		
	КонецЕсли;
	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьПараметрыВыбораСчета()

	СписокСчетов.ЗагрузитьЗначения(Отчеты.ОстаткиПоСкладу.СчетаУчетаТоваров());

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗаданияНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта), Форма.ПредставлениеТекущегоВарианта, НСтр("ru='Остатки по складу на';uk='Залишки по складу на'"));
	
	ЗаголовокОтчета = Название + " " + Формат(Отчет.КонецПериода, "ДЛФ=DD");
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

