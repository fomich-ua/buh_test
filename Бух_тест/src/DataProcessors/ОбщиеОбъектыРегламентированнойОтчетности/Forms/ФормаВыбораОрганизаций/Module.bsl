
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьОрганизации();
	
	НачальноеЗначениеВыбора = Параметры.НачальноеЗначениеВыбора;
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("Структура") Тогда
		
		ВыбранныеОрганизации.ЗагрузитьЗначения(Параметры.Организация.ВыгрузитьЗначения());

	КонецЕсли;
	
	Для Каждого Элемент Из ВыбранныеОрганизации Цикл
		
		МассивСтрок = Организации.НайтиСтроки(Новый Структура("Ссылка", Элемент.Значение));	
		
		Для Каждого Строка Из МассивСтрок Цикл
			Строка.Пометка = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	
КонецПроцедуры // ПриСозданииНаСервере()

// ПолучитьОрганизации()
//
&НаСервере
Процедура ПолучитьОрганизации()
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР КОГДА Организации.ПометкаУдаления ТОГДА 2
	|	ИНАЧЕ 1 КОНЕЦ КАК ИндексКартинки,
	|	Организации.КодПоЕДРПОУ КАК Код,
	|	Организации.Наименование,
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации");
	
	
	Организации.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ПолучитьОрганизации()

// УстановитьИлиСнятьФлажки()
//
&НаКлиенте
Процедура УстановитьИлиСнятьФлажки(Пометка)
	
	Для Каждого Элемент Из Организации Цикл
		Элемент.Пометка = Пометка;
	КонецЦикла;	
	
КонецПроцедуры // УстановитьИлиСнятьФлажки()
                                            
// УстановитьФлажки()
//
&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Истина);
		
КонецПроцедуры // УстановитьФлажки()

// СнятьФлажки()
//
&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Ложь);
	
КонецПроцедуры // СнятьФлажки()

// Выбрать()
//
&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьОрганизации();
		
КонецПроцедуры // Выбрать()

// ВыбратьОрганизации()
//
&НаКлиенте
Процедура ВыбратьОрганизации()
	
	МассивСтрок = Организации.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	ВыбранныеОрганизации.Очистить();
	
	Для Каждого Строка Из МассивСтрок Цикл
		ВыбранныеОрганизации.Добавить(Строка.Ссылка);
	КонецЦикла;
		
	ВыбранныеОрганизации.СортироватьПоЗначению();
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("Структура") Тогда
		ВладелецФормы.Организация = ВыбранныеОрганизации;
		ВладелецФормы.УстановитьОтборы();
	Иначе
		ВладелецФормы.СтруктураРеквизитовФормы.ГруппаОрганизаций = ВыбранныеОрганизации;
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры // ВыбратьОрганизации()

// ОрганизацииВыбор()
//
&НаКлиенте
Процедура ОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УстановитьИлиСнятьФлажки(Ложь);
	
	Организации[ВыбраннаяСтрока].Пометка = Истина;
	
	ВыбратьОрганизации();
	
КонецПроцедуры // ОрганизацииВыбор()

// ОрганизацииПередНачаломДобавления()
//
&НаКлиенте
Процедура ОрганизацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры // ОрганизацииПередНачаломДобавления()

// ОрганизацииПередУдалением()
//
&НаКлиенте
Процедура ОрганизацииПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры // ОрганизацииПередУдалением()
