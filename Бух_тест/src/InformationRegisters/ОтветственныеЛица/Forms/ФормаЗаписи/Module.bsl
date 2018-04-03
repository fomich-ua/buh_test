
/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
/////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
	
	Заголовок = НСтр("ru='Ответственное лицо для:';uk='Відповідальна особа:'") + " " + СокрЛП(Запись.СтруктурнаяЕдиница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму выбранной структурной единицы.
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), Запись.СтруктурнаяЕдиница);
	Если ТекущаяСтруктурнаяЕдиница <> Запись.СтруктурнаяЕдиница Тогда

		// Оповестим также форму той структурной единицы, данные которого начинали редактировать.
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), ТекущаяСтруктурнаяЕдиница);
		ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
		
	КонецЕсли;
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ КОМАНД ФОРМЫ
/////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаИстория(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СтруктурнаяЕдиница", Запись.СтруктурнаяЕдиница);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛица.ФормаСписка", СтруктураПараметров);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ РЕКВИЗИТОВ
/////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	Заголовок = НСтр("ru='Ответственное лицо для:';uk='Відповідальна особа:'") + " " + СокрЛП(Запись.СтруктурнаяЕдиница);

КонецПроцедуры
