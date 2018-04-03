
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// заполнение списка форматов
	Для Каждого ФорматСохранения Из УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		ВыбранныеФорматыСохранения.Добавить(ФорматСохранения.ТипФайлаТабличногоДокумента, Строка(ФорматСохранения.Ссылка), Ложь, ФорматСохранения.Картинка);
	КонецЦикла;
	ВыбранныеФорматыСохранения[0].Пометка = Истина; // по умолчанию выбран только первый формат из списка
	
	// заполнение списка выбора для присоединения файлов к объекту
	Для Каждого ОбъектПечати Из Параметры.ОбъектыПечати Цикл
		Если КОбъектуМожноПрисоединятьФайлы(ОбъектПечати.Значение) Тогда
			Элементы.ВыбранныйОбъект.СписокВыбора.Добавить(ОбъектПечати.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// место сохранения по умолчанию
	ВариантСохранения = "СохранитьВПапку";
	
	// объект для присоединения по умолчанию
	Если Элементы.ВыбранныйОбъект.СписокВыбора.Количество() > 0 Тогда
		ВыбранныйОбъект = Элементы.ВыбранныйОбъект.СписокВыбора[0].Значение;
	Иначе
		Элементы.ВариантСохранения.Видимость = Ложь;
		Элементы.ПапкаДляСохраненияФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
	Элементы.ВыбранныйОбъект.ТолькоПросмотр = Элементы.ВыбранныйОбъект.СписокВыбора.Количество() = 1;
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			Если ФорматИзНастроек <> Неопределено Тогда
				ВыбранныйФормат.Пометка = ФорматИзНастроек.Пометка;
			КонецЕсли;
		КонецЦикла;
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
	
	Если Элементы.ВыбранныйОбъект.СписокВыбора.Количество() = 0 Тогда
		НастройкаВариантСохранения = Настройки["ВариантСохранения"];
		Если НастройкаВариантСохранения <> Неопределено Тогда
			Настройки.Удалить("ВариантСохранения");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьСтраницуМестаСохранения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантСохраненияПриИзменении(Элемент)
	УстановитьСтраницуМестаСохранения();
	ОчиститьСообщения();
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляСохраненияФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораПапки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(ВыбраннаяПапка) Тогда
		ДиалогВыбораПапки.Каталог = ВыбраннаяПапка;
	КонецЕсли;
	Если ДиалогВыбораПапки.Выбрать() Тогда
		ВыбраннаяПапка = ДиалогВыбораПапки.Каталог;
		ОчиститьСообщения();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйОбъектОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	#Если Не ВебКлиент Тогда
	Если ВариантСохранения = "СохранитьВПапку" И ПустаяСтрока(ВыбраннаяПапка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо указать папку.';uk='Необхідно вказати папку.'"),,"ВыбраннаяПапка");
		Возврат;
	КонецЕсли;
	#КонецЕсли
		
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ФорматыСохранения.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='Необходимо указать как минимум один из предложенных форматов.';uk='Необхідно вказати як мінімум один із запропонованих форматів.'"));
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	РезультатВыбора.Вставить("ФорматыСохранения", ФорматыСохранения);
	РезультатВыбора.Вставить("ВариантСохранения", ВариантСохранения);
	РезультатВыбора.Вставить("ПапкаДляСохранения", ВыбраннаяПапка);
	РезультатВыбора.Вставить("ОбъектДляПрикрепления", ВыбранныйОбъект);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтраницуМестаСохранения()
	
	#Если ВебКлиент Тогда
	Элементы.ГруппаМестаСохранения.ТекущаяСтраница = Элементы.СтраницаПрисоединениеКОбъекту;
	Элементы.ВыбранныйОбъект.Доступность = ВариантСохранения = "Присоединить";
	#Иначе
	Если ВариантСохранения = "Присоединить" Тогда
		Элементы.ГруппаМестаСохранения.ТекущаяСтраница = Элементы.СтраницаПрисоединениеКОбъекту;
	Иначе
		Элементы.ГруппаМестаСохранения.ТекущаяСтраница = Элементы.СтраницаСохранениеВПапку;
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция КОбъектуМожноПрисоединятьФайлы(СсылкаНаОбъект)
	Результат = Неопределено;
	
	УправлениеПечатью.ПриПроверкеВозможностиПрисоединенияФайловКОбъекту(СсылкаНаОбъект, Результат);
	
	Если Результат = Неопределено Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
