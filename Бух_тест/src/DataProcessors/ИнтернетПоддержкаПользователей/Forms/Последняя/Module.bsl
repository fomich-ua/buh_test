
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапускИПППриСтарте = Ложь;
	ИнтернетПоддержкаПользователейСерверПереопределяемый.ЗапускатьИнтернетПоддержкуПриСтартеПрограммы(
		ЗапускИПППриСтарте);
	
	Элементы.НастройкаПоказПриСтарте.Видимость = (ЗапускИПППриСтарте = Истина);
	
	ХранилищеОбщихНастроек.Сохранить(
		"ИнтернетПоддержкаПользователей",
		"ХэшОбновленияИнформационногоОкна",
		Параметры.ХешОбновленияИнформационногоОкна);
	
	ЗаголовокПользователя = НСтр("ru='Логин: ';uk='Логін: '")
		+ Параметры.login;
	
	Элементы.НадписьЛогина.Заголовок = ЗаголовокПользователя;
	
	ФормированиеФормы(Параметры);
	
	НастройкаЗапуска = ХранилищеОбщихНастроек.Загрузить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы");
	
	Если НастройкаЗапуска = Неопределено Тогда
		НастройкаПоказПриСтарте = 0;
	ИначеЕсли НастройкаЗапуска = Истина Тогда
		ПоказыватьПриОбновлении = ХранилищеОбщихНастроек.Загрузить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении");
		Если ПоказыватьПриОбновлении = Истина Тогда
			НастройкаПоказПриСтарте = 1;
		Иначе
			НастройкаПоказПриСтарте = 0;
		КонецЕсли;
	Иначе
		НастройкаПоказПриСтарте = 2;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(,
		НСтр("ru='В веб-клиенте некоторые ссылки могут работать неправильно."
"Приносим извинения за неудобства.';uk='У веб-клієнті деякі посилання можуть працювати неправильно."
"Приносимо вибачення за незручності.'"),
		,
		НСтр("ru='Интернет-поддержка пользователей';uk='Інтернет-підтримка користувачів'"));
#КонецЕсли
	
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
Процедура НадписьВыходаНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLДокументПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ДанныеАктивногоЭлемента = Элемент.Документ.activeElement;
	Если ДанныеАктивногоЭлемента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		КлассАктивногоЭлемента = ДанныеАктивногоЭлемента.HRef;
	Исключение
		Возврат;
	КонецПопытки;
	
	Попытка
		ТаргетЭлемента = ДанныеАктивногоЭлемента.target;
	Исключение
		ТаргетЭлемента = Неопределено;
	КонецПопытки;
	
	Попытка
		ЗаголовокЭлемента = ДанныеАктивногоЭлемента.innerHTML;
	Исключение
		ЗаголовокЭлемента = Неопределено;
	КонецПопытки;
	
	Если ТаргетЭлемента <> Неопределено Тогда
		
		Если НРег(СокрЛП(ТаргетЭлемента)) = "_blank" Тогда
			ИнтернетПоддержкаПользователейКлиентПереопределяемый.ЗапуститьИнтернетСтраницуВОбозревателе(
				КлассАктивногоЭлемента,
				ЗаголовокЭлемента);
			ДанныеСобытия.Event.returnValue = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Найти(НРег(СокрЛП(КлассАктивногоЭлемента)),"openupdate") <> 0 Тогда
		
		ДанныеСобытия.Event.returnValue = Ложь;
		
		Попытка
			
			ИмяОбработки = "ОбновлениеКонфигурации";
			ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОпределитьИмяОбработкиОбновленияКонфигурации(
				ИмяОбработки);
			
			Если НЕ ПустаяСтрока(ИмяОбработки) Тогда
				
				СообщениеОбОшибке = "";
				ИмяОсновнойФормыОбработкиОбновления = ИмяОсновнойФормыОбработкиОбновленияКонфигурации(ИмяОбработки,
					СообщениеОбОшибке);
				
				Если ИмяОсновнойФормыОбработкиОбновления <> Неопределено Тогда
					ОткрытьФорму(ИмяОсновнойФормыОбработкиОбновления);
				Иначе
					Если НЕ ПустаяСтрока(СообщениеОбОшибке) Тогда
						ПоказатьПредупреждение(, СообщениеОбОшибке, , НСтр("ru='Ошибка';uk='Помилка'"));
						Возврат;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		Исключение
			
			ИнфОшибка = ИнформацияОбОшибке();
			
			ШаблонСообщения = НСтр("ru='Ошибка при запуске обработки обновления конфигурации. %1';uk='Помилка при запуску обробки оновлення конфігурації. %1'");
			ТекстОшибкиВЖурналеРегистрации = СтрЗаменить(
				ШаблонСообщения,
				"%1",
				ПодробноеПредставлениеОшибки(ИнфОшибка));
			ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибкиВЖурналеРегистрации);
			
			ТекстОшибкиПользователю = СтрЗаменить(
				ШаблонСообщения,
				"%1",
				КраткоеПредставлениеОшибки(ИнфОшибка));
			
			ПоказатьПредупреждение(, ТекстОшибкиПользователю, , НСтр("ru='Ошибка';uk='Помилка'"));
			
		КонецПопытки;
		
	ИначеЕсли Найти(Нрег(СокрЛП(КлассАктивногоЭлемента)), "problemupdate") <> 0 Тогда
		
		ДанныеСобытия.Event.returnValue = Ложь;
		ПараметрыСообщения = Новый Структура("ТипСообщения", 13);
		ИнтернетПоддержкаПользователейКлиент.ОткрытьДиалогОтправкиЭлектронногоПисьма(КонтекстВзаимодействия,
			ПараметрыСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПоказПриСтартеПриИзменении(Элемент)
	
	НастройкаПоказПриСтартеПриИзмененииНаСервере(НастройкаПоказПриСтарте);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет адрес обозревателя
&НаСервере
Процедура ФормированиеФормы(ПараметрыФормы)
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УРЛ = Неопределено;
	ПараметрыФормы.Свойство("УРЛ", УРЛ);
	
	Если УРЛ <> Неопределено Тогда
		HTMLДокумент = УРЛ;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастройкаПоказПриСтартеПриИзмененииНаСервере(НастройкаПоказПриСтарте)
	
	Если НастройкаПоказПриСтарте = 0 Тогда
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Истина);
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Ложь);
	ИначеЕсли НастройкаПоказПриСтарте = 1 Тогда
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Истина);
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Истина);
	Иначе
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Ложь);
		ХранилищеОбщихНастроек.Сохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяОсновнойФормыОбработкиОбновленияКонфигурации(Знач ИмяОбработки, СообщениеОбОшибке)
	
	МетаданныеОбработка = Метаданные.Обработки.Найти(ИмяОбработки);
	Если МетаданныеОбработка = Неопределено Тогда
		
		СообщениеОбОшибке = НСтр("ru='Отсутствует обработка обновления конфигурации.';uk='Відсутній обробка оновлення конфігурації.'");
		ПодробноеОписаниеОшибки = СтрЗаменить(НСтр("ru='В метаданных не найдена обработка обновления конфигурации (%1).';uk='В метаданих не знайдена обробка оновлення конфігурації (%1).'"),
			"%1",
			ИмяОбработки);
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ПодробноеОписаниеОшибки);
		Возврат Неопределено;
		
	Иначе
		
		МетаданныеОсновнаяФорма = МетаданныеОбработка.ОсновнаяФорма;
		Если МетаданныеОсновнаяФорма <> Неопределено Тогда
			Возврат МетаданныеОсновнаяФорма.ПолноеИмя();
		Иначе
			СообщениеОбОшибке = НСтр("ru='Ошибка открытия обработки обновления конфигурации. Отсутствует основная форма.';uk='Помилка відкриття обробки оновлення конфігурації. Відсутня основна форма.'");
			ПодробноеОписаниеОшибки = СтрЗаменить(НСтр("ru='Отсутствует основная форма обработки обновления конфигурации (%1).';uk='Відсутня основна форма обробки оновлення конфігурації (%1).'"),
				"%1",
				ИмяОбработки);
			ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ПодробноеОписаниеОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
