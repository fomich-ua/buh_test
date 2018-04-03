
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	// Заполнение формы необходимыми параметрами.
	ЗаполнитьФорму();
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовкаРегНомера.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКонтентаРегНомер.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Если МестоЗапуска <> "systemStart" И МестоЗапуска <> "systemStartNew" Тогда
		Возврат;
	КонецЕсли;
	
	НеНапоминатьОбАвторизацииДоДата = ИнтернетПоддержкаПользователейВызовСервера.ЗначениеНастройкиНеНапоминатьОбАвторизацииДо();
	Если НеНапоминатьОбАвторизацииДоДата <> '00010101'
		И ТекущаяДатаСеанса() > НеНапоминатьОбАвторизацииДоДата Тогда
			ИнтернетПоддержкаПользователейВызовСервера.УстановитьНастройкуНеНапоминатьОбАвторизацииДо(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если НЕ ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходаПользователяРегНомерНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗарегистрированныхПродуктовРегНомерНажатие(Элемент)
	
	АдресСсылки       = "https://portal.1c.eu/software";
	ДополнениеКАдресу = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
		КонтекстВзаимодействия.КСКонтекст,
		"authUrlPassword");
	ДополнениеКАдресу = Строка(ДополнениеКАдресу);
	АдресСсылки       = ДополнениеКАдресу + АдресСсылки;
	
	ЗаголовокСтраницы = Нстр("ru='Список зарегистрированных продуктов';uk='Список зареєстрованих продуктів'");
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ЗапуститьИнтернетСтраницуВОбозревателе(АдресСсылки,
		ЗаголовокСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьПродуктРегНомерНажатие(Элемент)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "registerProduct", "true"));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКЗаголовкуРегНомерОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыСообщения = Новый Структура("ТипСообщения", 2);
		ИнтернетПоддержкаПользователейКлиент.ОткрытьДиалогОтправкиЭлектронногоПисьма(
			КонтекстВзаимодействия,
			ПараметрыСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеНапоминатьОбАвторизацииДо1ПриИзменении(Элемент)
	
	УстановитьНастройкуНеНапоминатьОбАвторизацииДоСервер(НеНапоминатьОбАвторизацииДо);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКРегНомер(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"regnumber",
		РегистрационныйНомерРегНомер);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "regnumber", РегистрационныйНомерРегНомер));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет начальное заполнение полей фомры
&НаСервере
Процедура ЗаполнитьФорму()
	
	ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо();
	
	ЗаголовокПользователя = НСтр("ru='Логин: ';uk='Логін: '") + Параметры.login;
	
	Элементы.НадписьЛогинаПользователяРегНомер.Заголовок = ЗаголовокПользователя;
	РегистрационныйНомерРегНомер = Параметры.regNumber;
	
	СохранятьПароль = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо()
	
	ОбщийЗаголовокФлажка = НСтр("ru='Не напоминать о подключении семь дней';uk='Не нагадувати про підключення сім днів'");
	
	ЗначениеНастройки = ИнтернетПоддержкаПользователейВызовСервера.ЗначениеНастройкиНеНапоминатьОбАвторизацииДо();
	НеНапоминатьОбАвторизацииДо = ?(ЗначениеНастройки = '00010101', Ложь, Истина);
	
	СтрокаФлажка = ОбщийЗаголовокФлажка
		+ ?(ЗначениеНастройки = '00010101',
			"",
			НСтр("ru=' (до ';uk=' (до '") + Формат(ЗначениеНастройки, "ДФ=dd.MM.yyyy") + ")");
	
	Элементы.НеНапоминатьОбАвторизацииДо.Заголовок = СтрокаФлажка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкуНеНапоминатьОбАвторизацииДоСервер(Значение)
	
	ИнтернетПоддержкаПользователейВызовСервера.УстановитьНастройкуНеНапоминатьОбАвторизацииДо(Значение);
	ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо();
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Результат = Истина;
	
	Если ПустаяСтрока(РегистрационныйНомерРегНомер) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не заполнено поле ""Регистрационный номер""';uk='Не заповнено поле ""Реєстраційний номер""'");
		Сообщение.Поле  = "РегистрационныйНомерРегНомер";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
