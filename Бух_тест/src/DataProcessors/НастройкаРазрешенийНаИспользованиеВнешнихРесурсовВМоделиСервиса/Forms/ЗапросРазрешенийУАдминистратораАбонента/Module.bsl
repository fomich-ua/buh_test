&НаКлиенте
Перем ИтерацияПроверки;
&НаКлиенте
Перем АдресХранилища;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаШапка.Видимость = Не Параметры.РежимПроверки;
	Элементы.ГруппаШапкаРежимПроверки.Видимость = Параметры.РежимПроверки;
	
	ХранилищеРезультатаОбработкиЗапросов = Параметры.АдресХранилища;
	РезультатОбработкиЗапросов = ПолучитьИзВременногоХранилища(ХранилищеРезультатаОбработкиЗапросов);
	АдресХранилищаНаСервере = ПоместитьВоВременноеХранилище(РезультатОбработкиЗапросов, ЭтотОбъект.УникальныйИдентификатор);
	
	ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = РезультатОбработкиЗапросов.ТребуетсяВнесениеИзмененийВПрофиляхБезопасности;
	
	Если Не ТребуетсяВнесениеИзмененийВПрофиляхБезопасности Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеРазрешений = РезультатОбработкиЗапросов.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяВнесениеИзмененийВПрофиляхБезопасности Тогда
		
		АдресХранилища = АдресХранилищаНаСервере;
		
	Иначе
		
		Закрыть(КодВозвратаДиалога.Пропустить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(Пароль) Тогда
		
		ИмяПоля = "Пароль";
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для предоставления разрешений укажите свой пароль для доступа к сервису.';uk='Для надання дозволів вкажіть свій пароль для доступу до сервісу.'"),
			,
			ИмяПоля
			,
			Отказ
		);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения Тогда
		
		ТекстОшибки = "";
		Попытка
			
			ПрименитьРазрешения(АдресХранилища, Пароль);
			ОжидатьПримененияНастроек();
			
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке()); 
			Элементы.ГруппаОшибка.Видимость = Истина;
		КонецПопытки;
		
	Иначе
		
		ВызватьИсключение НСтр("ru='Неизвестная операция!';uk='Невідома операція!'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПрименитьРазрешения(Знач АдресХранилища, Знач Пароль)
	
	ИдентификаторыЗапросов = ИдентификаторыЗапросов(АдресХранилища);
	Сериализация = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.СериализоватьЗапросыНаИспользованиеВнешнихРесурсов(ИдентификаторыЗапросов);
	УдаленноеАдминистрированиеБТССлужебный.ОтправитьЗапросыНаИспользованиеВнешнихРесурсовОбластиДанных(Сериализация, Пароль);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьПримененияНастроек()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОбработкаЗапросов;
	
	ИтерацияПроверки = 1;
	ПодключитьОбработчикОжидания("ПроверитьОбработкуЗапросовВМС", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбработкуЗапросовВМС()
	
	Попытка
		Готовность = ЗапросыОбработаныВМС(АдресХранилища);
	Исключение
		ОтключитьОбработчикОжидания("ПроверитьОбработкуЗапросовВМС");
		Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Готовность Тогда
		ОтключитьОбработчикОжидания("ПроверитьОбработкуЗапросовВМС");
		Закрыть(КодВозвратаДиалога.ОК);
	Иначе
		
		ИтерацияПроверки = ИтерацияПроверки + 1;
		
		Если ИтерацияПроверки = 2 Тогда
			ОтключитьОбработчикОжидания("ПроверитьОбработкуЗапросов");
			ПодключитьОбработчикОжидания("ПроверитьОбработкуЗапросов", 5);
		ИначеЕсли ИтерацияПроверки = 3 Тогда
			ОтключитьОбработчикОжидания("ПроверитьОбработкуЗапросов");
			ПодключитьОбработчикОжидания("ПроверитьОбработкуЗапросов", 12);
		Иначе
			ОтключитьОбработчикОжидания("ПроверитьОбработкуЗапросов");
			ПодключитьОбработчикОжидания("ПроверитьОбработкуЗапросов", 30);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросыОбработаныВМС(Знач АдресХранилища)
	
	ИдентификаторыЗапросов = ПолучитьИзВременногоХранилища(АдресХранилища);
	РезультатОбработки = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.РезультатОбработкиЗапросовВУправляющемПриложении(ИдентификаторыЗапросов);
	Если РезультатОбработки.Количество() = ИдентификаторыЗапросов.Количество() Тогда
		
		Ошибка = Ложь;
		ТекстОшибки = "";
		
		Для Каждого ЭлементРезультата Из РезультатОбработки Цикл
			
			Если ЭлементРезультата.РезультатОбработки = Перечисления.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.ЗапросОтклонен Тогда
				
				Если Не Ошибка Тогда
					Ошибка = Истина;
				КонецЕсли;
				
				Если Не ПустаяСтрока(ТекстОшибки) Тогда
					ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ВК;
				КонецЕсли;
				
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Ошибка обработки запроса %1: %2!';uk='Помилка обробки запиту %1: %2!'"),
					Строка(ЭлементРезультата.ИдентификаторЗапроса),
					ЭлементРезультата.ИнформацияОбОшибке
				);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Ошибка Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИдентификаторыЗапросов(Знач АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Возврат Результат.ИдентификаторыЗапросов;
	
КонецФункции

#КонецОбласти