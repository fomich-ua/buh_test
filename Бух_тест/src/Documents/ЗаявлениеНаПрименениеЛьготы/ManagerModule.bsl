
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//////////////////////////////////////////////////////////////////
/// Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Список перечислений
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗаявлениеНаПрименениеЛьготы";
	КомандаПечати.Представление = НСтр("ru='Заявление на применение льготы';uk='Заява на застосування пільги'");
	
	// Список перечислений в Microsoft Word
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗаявлениеНаПрименениеЛьготы";
	КомандаПечати.Представление = НСтр("ru='Заявление на применение льготы в Microsoft Word';uk='Заява на застосування пільги у Microsoft Word'");
	КомандаПечати.ФорматСохранения = ТипФайлаТабличногоДокумента.DOCX;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Реестр документов ""Заявление на применение льготы НДФЛ""';uk='Реєстр документів ""Заява на застосування пільги ПДФО""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеНаПрименениеЛьготы") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаявлениеНаПрименениеЛьготы", НСтр("ru='Заявление на применение льготы';uk='Заява на застосування пільги'"), ПечатьЗаявление(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПечатьЗаявление(МассивОбъектов, ОбъектыПечати)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявлениеНаПрименениеЛьготы_ЗаявлениеНаПрименениеЛьготы";
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.ЗаявлениеНаПрименениеЛьготы.ПФ_MXL_ЗаявлениеНаПрименениеЛьготы");
	
	// получаем данные для печати
	Для Каждого Ссылка Из МассивОбъектов Цикл
		Выборка = ВыборкаДляПечати(Ссылка);
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		Пока Выборка.Следующий() Цикл
			
			ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Выборка.Организация, Выборка.Работник, Выборка.ДатаДок);

			ОбластьШапка1 = Макет.ПолучитьОбласть("Шапка1");
			ОбластьШапка1.Параметры.Организация = Выборка.Организация.НаименованиеПолное;
			ОбластьШапка1.Параметры.ФИО = Выборка.ФИО;
			ТабличныйДокумент.Присоединить(ОбластьШапка1);
			
			ОбластьШапка2 = Макет.ПолучитьОбласть("Шапка2");
			ОбластьШапка2.Параметры.Должность = ДанныеФизЛица.Должность;
			ТабличныйДокумент.Присоединить(ОбластьШапка2);
			
			ОбластьДРФО = Макет.ПолучитьОбласть("ДРФО");
			ТабличныйДокумент.Присоединить(ОбластьДРФО);
			
			Счетчик = 1; 
			Пока Счетчик < 11 Цикл
				ОбластьДРФО = Макет.ПолучитьОбласть("КодПоДРФО" + Строка(Счетчик));	
				КодПоДРФО = Сред(Выборка.Работник.КодПоДРФО, Счетчик, 1);
				Если Ссылка.Номер <> Неопределено Тогда
					ОбластьДРФО.Параметры.Номер = КодПоДРФО;
				КонецЕсли;
				ТабличныйДокумент.Присоединить(ОбластьДРФО);
				Счетчик = Счетчик + 1;
			КонецЦикла;
			
			
			Если Выборка.Актуальность Тогда
				ОбластьЗаявление = Макет.ПолучитьОбласть("ПрименениеЛьготы");
				КодЛьготы = СтрЗаменить(Выборка.Льгота.Код,"ВР","");
				ОбластьЗаявление.Параметры.Норма = КодЛьготы;
				
				ОбластьЗаявление.Параметры.Дата = Формат(Ссылка.Дата,"Л=uk; ДФ='дд ММММ гггг'");
				ТабличныйДокумент.Присоединить(ОбластьЗаявление);
			Иначе
				ОбластьЗаявление = Макет.ПолучитьОбласть("ОтказОтЛьготы");
				ОбластьЗаявление.Параметры.Месяц =  Формат(Выборка.ДатаИзменения,"Л=uk; ДФ=ММММ");
				ОбластьЗаявление.Параметры.Год2 = Прав(Формат(Выборка.ДатаИзменения,"ДФ=гггг"), 1);
				ОбластьЗаявление.Параметры.Год1 = Сред(Формат(Выборка.ДатаИзменения,"ДФ=гггг"), 3,1);
				ОбластьЗаявление.Параметры.Дата = Формат(Ссылка.Дата,"Л=uk; ДФ='дд ММММ гггг'");
				ТабличныйДокумент.Присоединить(ОбластьЗаявление);
			КонецЕсли;
		
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЦикла;
	КонецЦикла;
	

	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует запрос по документу
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ЗаявлениеНаПрименениеЛьготы
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечати(Ссылка)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	
	Запрос.УстановитьПараметр("МоментВремени", Ссылка.МоментВремени());
	Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Ссылка.Организация КАК Организация,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Ссылка,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Ссылка.Дата КАК ДатаДок,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.НомерСтроки,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Льгота,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.ДатаИзменения,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Актуальность,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.ФизическоеЛицо КАК Работник,
	|	ЗаявлениеНаПрименениеЛьготыРаботники.ФизическоеЛицо.Наименование КАК ФИО
	|ИЗ
	|	Документ.ЗаявлениеНаПрименениеЛьготы.Работники КАК ЗаявлениеНаПрименениеЛьготыРаботники
	|ГДЕ
	|	ЗаявлениеНаПрименениеЛьготыРаботники.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить().Выбрать();
	
	
КонецФункции

#КонецЕсли