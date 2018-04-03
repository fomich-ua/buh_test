&НаКлиенте
Перем мПрограммноеЗакрытие;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройки();
	
	ИзменениеОбщихНастроекРазрешено = (Метаданные.Роли.Найти("ПолныеПрава") <> Неопределено И РольДоступна("ПолныеПрава"));
	
	УправлениеЭУ();

	УправлениеЭУВРежимеСервиса();
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУВРежимеСервиса()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда 
		Элементы.ГруппаИндивидуальныхНастроек.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ()
	
	Элементы.ФлажокМеханизмВключен.Доступность					= ИзменениеОбщихНастроекРазрешено;
	Элементы.ФлажокУведомлятьОбОшибках.Доступность				= ИзменениеОбщихНастроекРазрешено И МеханизмВключен;
	
	Элементы.НастроитьПараметрыПроксиСервера.Доступность		= РазрешитьОбновлениеИнформацииИзИнтернет;
	Элементы.КнопкаПроверитьИнтернет.Доступность				= РазрешитьОбновлениеИнформацииИзИнтернет;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	НастройкиМеханизма = ОнлайнСервисыРегламентированнойОтчетности.ПолучитьНастройкиМеханизмаОнлайнСервисовРО();
	
	МеханизмВключен = НастройкиМеханизма.Использовать;
	УведомлятьОбОшибках = НастройкиМеханизма.УведомлятьОбОшибках;
	
	РазрешитьОбновлениеИнформацииИзИнтернет = НастройкиМеханизма.РазрешитьДоступВИнтернет;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда 
		Если РазрешитьОбновлениеИнформацииИзИнтернет = Неопределено Тогда
			ОнлайнСервисыРегламентированнойОтчетности.СохранитьИндивидуальныеНастройкиМеханизмаОнлайнСервисовРО(Истина);
			РазрешитьОбновлениеИнформацииИзИнтернет = Истина;
		КонецЕсли;
	Иначе
		Если РазрешитьОбновлениеИнформацииИзИнтернет = Неопределено Тогда
			РазрешитьОбновлениеИнформацииИзИнтернет = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажокМеханизмВключенПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажокРазрешитьОбновлениеИнформацииИзИнтернетПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если мПрограммноеЗакрытие Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	мПрограммноеЗакрытие = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки()
	
	СохранитьНастройкиСервер();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСервер()
	
	// сохраняем общие настройки
	Если ИзменениеОбщихНастроекРазрешено Тогда
		ОнлайнСервисыРегламентированнойОтчетности.СохранитьОбщиеНастройкиМеханизмаОнлайнСервисовРО(МеханизмВключен, УведомлятьОбОшибках);
	КонецЕсли;
	
	// сохраняем индивидуальные настройки
	ОнлайнСервисыРегламентированнойОтчетности.СохранитьИндивидуальныеНастройкиМеханизмаОнлайнСервисовРО(
		РазрешитьОбновлениеИнформацииИзИнтернет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИнтернет(Команда)
	
	ТекстПредупреждения = РезультатПроверкиПараметровДоступа();
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Функция РезультатПроверкиПараметровДоступа()
	
	СообщениеОбОшибке = Неопределено;
	
	Соединение = ОнлайнСервисыРегламентированнойОтчетности.УстановитьСоединениеССерверомМеханизмаОнлайнСервисовРО(СообщениеОбОшибке);
	Если Соединение = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Проверка параметров доступа в Интернет прошла неудачно:"
""
"';uk='Перевірка параметрів доступу в Інтернет пройшла невдало:"
""
"'") + Строка(СообщениеОбОшибке);
		Возврат ТекстПредупреждения;
	КонецЕсли;
	
	РезультатПолученияФайла = ОнлайнСервисыРегламентированнойОтчетности.ПолучитьРесурсССервера(Соединение, "infomap.dat", СообщениеОбОшибке);
	Если РезультатПолученияФайла = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Проверка параметров доступа в Интернет прошла неудачно:"
""
"';uk='Перевірка параметрів доступу в Інтернет пройшла невдало:"
""
"'") + Строка(СообщениеОбОшибке);
		Возврат ТекстПредупреждения;
	КонецЕсли;
	
	ТекстПредупреждения = НСтр("ru='Проверка параметров доступа в Интернет успешно пройдена!';uk='Перевірка параметрів доступу в Інтернет успішно пройдена!'");
	Возврат ТекстПредупреждения;
	
КонецФункции

&НаКлиенте
Процедура НастроитьПараметрыПроксиСервера(Команда)
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ЗапроситьПараметрыПрокси();
	
КонецПроцедуры

мПрограммноеЗакрытие = Ложь;