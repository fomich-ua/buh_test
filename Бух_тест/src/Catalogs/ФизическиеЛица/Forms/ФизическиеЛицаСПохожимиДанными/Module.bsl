////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.ЗаголовокФормы;
	
	ТекстИнформационнойНадписи = Параметры.ТекстИнформационнойНадписи;
	
	Для каждого ДанныеФизическогоЛица Из Параметры.ДанныеФизическихЛиц Цикл
		
		НоваяСтрокаДанных = ДанныеФизическихЛиц.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДанных, ДанныеФизическогоЛица);
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.ДатаРождения) Тогда
			НоваяСтрокаДанных.ДатаРождения = "<Не заполнена>";
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.КодПоДРФО) Тогда
			НоваяСтрокаДанных.КодПоДРФО = "<Не заполнен>";
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.ДокументПредставление) Тогда
			НоваяСтрокаДанных.ДокументПредставление = "<Не заполнен>";
		КонецЕсли; 
		
	КонецЦикла;
	
	Элементы.ДанныеФизическихЛиц.ТекущаяСтрока = ДанныеФизическихЛиц[0].ПолучитьИдентификатор();
	
	Если ДанныеФизическихЛиц.Количество() = 1 Тогда
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОдногоЧеловека;
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаНесколькихЧеловек;
		
		Элементы.ДаЭтоТотКтоМнеНужен.Заголовок = НСтр("ru='Отмеченный человек тот, кто мне нужен';uk='Зазначена людина та, хто мені потрібен'");
		
	КонецЕсли;
	
	Если Параметры.СкрытьКомандуДругойЧеловек Тогда
		
		Элементы.НетЭтоДругойЧеловек.Видимость = Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГиперСсылкаОткрытьЛичныеДанныеНажатие(Элемент)
	
	ОткрытьЛичныеДанные(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДанныеФизическихЛиц

&НаКлиенте
Процедура ДанныеФизическихЛицПометкаПриИзменении(Элемент)
	
	ТекущиеДанныеСотрудника = Элементы.ДанныеФизическихЛиц.ТекущиеДанные;
	
	Если ТекущиеДанныеСотрудника.Пометка Тогда
		
		ПомеченныеСтроки = ДанныеФизическихЛиц.НайтиСтроки(Новый Структура("Пометка", Истина));
		Для Каждого СтрокаПомеченныеСтроки Из ПомеченныеСтроки Цикл
			
			Если СтрокаПомеченныеСтроки <> ТекущиеДанныеСотрудника Тогда
				СтрокаПомеченныеСтроки.Пометка = Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФизическихЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЛичныеДанные(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДанныеФизическогоЛица(Команда)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЛичныеДанные(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФизическоеЛицоКонткстноеМеню(Команда)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		Закрыть(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДаЭтоТотКтоМнеНужен(Команда)
	
	ВыбратьФизическоеЛицоИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура НетЭтоДругойЧеловек(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьЛичныеДанные(ФизическоеЛицоСсылка)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Ключ", ФизическоеЛицоСсылка);
	ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", Истина);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Ключ", ФизическоеЛицоСсылка);
	ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", Истина);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФизическоеЛицоИЗакрытьФорму()
	
	Если ДанныеФизическихЛиц.Количество() > 1 Тогда
		
		ПомеченныеСтроки = ДанныеФизическихЛиц.НайтиСтроки(Новый Структура("Пометка", Истина));
		Если ПомеченныеСтроки.Количество() > 0 Тогда
			Закрыть(ПомеченныеСтроки[0].ФизическоеЛицо);
		Иначе
			ПоказатьПредупреждение(,НСтр("ru='Необходимо установить отметку напротив нужного человека';uk='Необхідно встановити позначку навпроти потрібної людини'"));
		КонецЕсли;
		
	Иначе
		Закрыть(ДанныеФизическихЛиц[0].ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры


