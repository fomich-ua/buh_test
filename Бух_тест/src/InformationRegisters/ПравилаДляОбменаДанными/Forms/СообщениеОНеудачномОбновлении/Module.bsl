
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = Параметры.ИмяПланаОбмена;
	СинонимПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Синоним;
	
	ПравилаКонвертацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
	ПравилаРегистрацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
	
	ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
		Параметры.ПодробноеСообщениеОбОшибке);
		
	СообщениеОбОшибке = Элементы.ТекстСообщенияОбОшибке.Заголовок;
	СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%2", Параметры.КраткоеСообщениеОбОшибке);
	СообщениеОбОшибке = СтрЗаменитьСВыделением(СообщениеОбОшибке, "%1", СинонимПланаОбмена);
	Элементы.ТекстСообщенияОбОшибке.Заголовок = СообщениеОбОшибке;
	
	ПравилаИзФайла = РегистрыСведений.ПравилаДляОбменаДанными.ИспользуютсяПравилаИзФайла(ИмяПланаОбмена, Истина);
	
	Если ПравилаИзФайла.ПравилаКонвертации И ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = Нстр("ru='конвертации и регистрации';uk='конвертації і реєстрації'");
	ИначеЕсли ПравилаИзФайла.ПравилаКонвертации Тогда
		ТипПравил = Нстр("ru='конвертации';uk='конвертації'");
	ИначеЕсли ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = Нстр("ru='регистрации';uk='реєстрації'");
	КонецЕсли;
	
	Элементы.ТекстПравилаИзФайла.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.ТекстПравилаИзФайла.Заголовок, СинонимПланаОбмена, ТипПравил);
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	Если Параметры.ВремяОкончанияОбновления = Неопределено Тогда
		ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	Иначе
		ВремяОкончанияОбновления = Параметры.ВремяОкончанияОбновления;
	КонецЕсли;
	
	Элементы.ЗагрузитьПравилаКонвертации.Видимость = ПравилаИзФайла.ПравилаКонвертации;
	Элементы.ЗагрузитьПравилаРегистрации.Видимость = ПравилаИзФайла.ПравилаРегистрации;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплектПравил(Команда)
	
	ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(ИмяПланаОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтрЗаменитьСВыделением(Строка, ПодстрокаПоиска, ПодстрокаЗамены)
	
	ПозицияНачала = Найти(Строка, ПодстрокаПоиска);
	
	МассивСтроки = Новый Массив;
	
	МассивСтроки.Добавить(Лев(Строка, ПозицияНачала - 1));
	МассивСтроки.Добавить(Новый ФорматированнаяСтрока(ПодстрокаЗамены, Новый Шрифт(,,Истина)));
	МассивСтроки.Добавить(Сред(Строка, ПозицияНачала + СтрДлина(ПодстрокаПоиска)));
	
	Возврат Новый ФорматированнаяСтрока(МассивСтроки);
	
КонецФункции

#КонецОбласти