&НаКлиенте
Перем мПрограммноеЗакрытие;

&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапретНаПродолжение 							= Параметры.ЗапретНаПродолжение;
	БлокируемаяФункция 								= Параметры.БлокируемаяФункция;
	ТекстПодробнее 									= Параметры.ТекстПодробнее;
	ТекстЗаголовок 									= Параметры.ТекстЗаголовок;
	ПродолжитьДействие								= Параметры.ПродолжитьДействие;
	ТекстИспользуйте 								= Параметры.ТекстИспользуйте;
	БлокировкаФормы 								= Параметры.БлокировкаФормы;
	БлокировкаФормыИЛИФормата 						= Параметры.БлокировкаФормыИЛИФормата;
	ВерсияМодуляДокументооборотаСИсправлениемОшибки = Параметры.ВерсияМодуляДокументооборотаСИсправлениемОшибки;
	
	Если ЗапретНаПродолжение Тогда
		Элементы.ГруппаКнопок.ТекущаяСтраница = Элементы.ГруппаЗапрет;// текущая страница
		Элементы.ФлагПродолжитьДействие.Видимость = Ложь;// флажок
		ЭтаФорма.ТекущийЭлемент = Элементы.ПроверитьОбновленияЗапрет;// кнопка
	Иначе
		Элементы.ГруппаКнопок.ТекущаяСтраница = Элементы.ГруппаРекомендация;// текущая страница
		Элементы.КнопкаПродолжитьРекомендация.Доступность = ПродолжитьДействие;// доступность кнопки Продолжить
		ЭтаФорма.ТекущийЭлемент = Элементы.ПроверитьОбновленияРекомендация;// кнопка
	КонецЕсли;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Если БлокировкаФормыИЛИФормата Тогда
		ТекстHTML = ОбработкаОбъект.ПолучитьМакет("УведомлениеОБлокировкеФормыИЛИФормата").ПолучитьТекст();
	Иначе
		ТекстHTML = ОбработкаОбъект.ПолучитьМакет("УведомлениеОБлокировкеОбъекта").ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьHTML();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаДействие(Команда)
	
	мПрограммноеЗакрытие = Истина;
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновления(Команда)
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ОткрытьФормуДоступныхОбновленийРО();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПерезапуститьПрограммуПриОткрытииЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если ВладелецФормы <> Неопределено И ВладелецФормы.Модифицированность Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеРаботыПослеСохраненияОтчета", ЭтотОбъект, ДополнительныеПараметры);
			ВладелецФормы.СохранитьНаКлиенте(, ОписаниеОповещения);
		Иначе
			ЗавершениеРаботыПослеСохраненияОтчета();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеРаботыПослеСохраненияОтчета(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	// Если сохранения не произошло ( то есть отчет не сохранился), то перезагрузка не произойдет
	ОтчетСохранился = НЕ (ВладелецФормы <> Неопределено И ВладелецФормы.Модифицированность);
	
	Если ОтчетСохранился Тогда
		ЗавершитьРаботуСистемы(Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	ОткрытьСправку("Обработка.ОнлайнСервисыРегламентированнойОтчетности");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьДействиеПриИзменении(Элемент)
	
	Элементы.КнопкаПродолжитьРекомендация.Доступность = ПродолжитьДействие;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ мПрограммноеЗакрытие Тогда
		мПрограммноеЗакрытие = Истина;
		Отказ = Истина;
		Закрыть(Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция АдресКартинки(ЗапретНаПродолжение)
	
	Картинка = Неопределено;
	Если ЗапретНаПродолжение Тогда
		//БиблиотекаКартинок.Стоп48;
		Картинка = "../../mdpicture/idd9859dd1-911d-4c5b-8ab4-868b1b1640f7/00000000-0000-0000-0000-000000000000";
	Иначе
		//БиблиотекаКартинок.Внимание48;
		Картинка = "../../mdpicture/id5e4a21d9-e796-40fa-9832-fbc2c352020b/00000000-0000-0000-0000-000000000000";
	КонецЕсли;
	
	Возврат Картинка;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьHTML()
	
	Если БлокировкаФормыИЛИФормата Тогда
	
		// устанавливаем в HTML тексты и ссылку на картинку
		ТекстHTML = СтрЗаменить(ТекстHTML, "ПутьККартинке",		АдресКартинки(ЗапретНаПродолжение));
		ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстЗаголовок",	СтрЗаменить(ТекстЗаголовок, Символы.ПС, "<BR>"));
		
		Если ЗначениеЗаполнено(ТекстИспользуйте) Тогда
			ЗаголовокИспользуйте = ?(БлокировкаФормы, "Используйте форму в редакции:", "Используйте формат:");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокИспользуйте",	ЗаголовокИспользуйте);
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИспользуйте",	СтрЗаменить(ТекстИспользуйте, Символы.ПС, "<BR>"));
		Иначе
			ТекстHTML = СтрЗаменить(ТекстHTML, "<STRONG>ЗаголовокИспользуйте</STRONG><BR>",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИспользуйте<BR>",	"");
			// обход особенностей платформы 8.2
			ТекстHTML = СтрЗаменить(ТекстHTML, "<strong>ЗаголовокИспользуйте</strong><br>",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИспользуйте<br>",	"");
			
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокИспользуйте",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИспользуйте",	"");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстПодробнее) Тогда
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокПодробнее", "Дополнительная информация:");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее", СтрЗаменить(ТекстПодробнее, Символы.ПС, "<BR>"));
		Иначе
			ТекстHTML = СтрЗаменить(ТекстHTML, "<STRONG>ЗаголовокПодробнее</STRONG><BR>",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее<BR>",	"");
			// обход особенностей платформы 8.2
			ТекстHTML = СтрЗаменить(ТекстHTML, "<strong>ЗаголовокПодробнее</strong><br>",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее<br>",	"");
			
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокПодробнее",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее",	"");
		КонецЕсли;
		
	Иначе
		// заполняем	
		ТекстШапка = СформироватьТекстШапки();
		
		// устанавливаем в HTML тексты и ссылку на картинку
		ТекстHTML = СтрЗаменить(ТекстHTML, "ПутьККартинке",		АдресКартинки(ЗапретНаПродолжение));
		ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстЗаголовок",	ТекстЗаголовок);
		ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстШапка",		ТекстШапка);
		
		Если ЗначениеЗаполнено(ТекстПодробнее) Тогда
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокПодробнее",	"Дополнительная информация:");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее",		ТекстПодробнее);
		Иначе
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокПодробнее",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстПодробнее",		"");
		КонецЕсли;
		
		Если ОбновлениеМодуляДокументооборотаНаИсправительныйДоступно Тогда
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокИсправление",	НСтр("ru='Информация по обновлению:';uk='Інформація щодо оновлення:'"));
			
			ТекстИсправление = "В Интернете доступно обновление модуля документооборота, позволяющего снять ограничение на отправку отчета. <br>
				|Новый модуль: версия " + ВерсияАктуальногоМодуляДокументооборота;
			Если ЗначениеЗаполнено(ДатаВыпускаАктуальногоМодуляДокументооборота) Тогда
				ТекстИсправление = ТекстИсправление + " от " + Формат(ДатаВыпускаАктуальногоМодуляДокументооборота, "ДЛФ=DD");
			Иначе
				ТекстИсправление = ТекстИсправление + ".";
			КонецЕсли;
			ТекстИсправление = ТекстИсправление + "
				|<br>Рекомендуется обновить модуль документооборота сейчас";

			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИсправление",		ТекстИсправление);
		Иначе
			ТекстHTML = СтрЗаменить(ТекстHTML, "ЗаголовокИсправление",	"");
			ТекстHTML = СтрЗаменить(ТекстHTML, "ТекстИсправление",		"");
		КонецЕсли;
		
	КонецЕсли;
		
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстШапки()
	
	Если БлокируемаяФункция = "И" Тогда // блокировка использования
		Если ТипЗнч(Объект) = Тип("УправляемаяФорма") Тогда
			Если ЗапретНаПродолжение Тогда
				ТекстШапка = "Использование данной формы регламентированной отчетности запрещено!";
			Иначе
				ТекстШапка = "Использование данной формы регламентированной отчетности не рекомендуется!";
			КонецЕсли;
		Иначе
			Если ЗапретНаПродолжение Тогда
				ТекстШапка = "Использование данного регламентированного отчета запрещено!";
			Иначе
				ТекстШапка = "Использование данного регламентированного отчета не рекомендуется!";
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли БлокируемаяФункция = "П" Тогда // блокировка печати
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Для данной формы регламентированной отчетности заблокирована функция печати.";
		Иначе
			ТекстШапка = "Для данной формы регламентированной отчетности не рекомендуется использовать функцию печати.";
		КонецЕсли;
	ИначеЕсли БлокируемаяФункция = "ПВ" Тогда // блокировка печати МЧБ
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Для данной формы регламентированной отчетности заблокирована функция формирования машиночитаемого бланка.";
		Иначе
			ТекстШапка = "Для данной формы регламентированной отчетности не рекомендуется использовать функцию формирования машиночитаемого бланка.";
		КонецЕсли;
	ИначеЕсли БлокируемаяФункция = "В" Тогда // блокировка выгрузки
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Для данной формы регламентированной отчетности заблокирована функция выгрузки.";
		Иначе
			ТекстШапка = "Для данной формы регламентированной отчетности не рекомендуется использовать функцию выгрузки.";
		КонецЕсли;
	ИначеЕсли БлокируемаяФункция = "О" Тогда // блокировка отправки
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Для данной формы регламентированной отчетности заблокирована функция отправки.";
		Иначе
			ТекстШапка = "Для данной формы регламентированной отчетности не рекомендуется использовать функцию отправки.";
		КонецЕсли;
	ИначеЕсли БлокируемаяФункция = "З" Тогда // блокировка заполнения
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Для данной формы регламентированной отчетности заблокирована функция автоматического заполнения по данным информационной базы.";
		Иначе
			ТекстШапка = "Для данной формы регламентированной отчетности не рекомендуется использовать функцию автоматического заполнения по данным информационной базы.";
		КонецЕсли;
	Иначе
		Если ЗапретНаПродолжение Тогда
			ТекстШапка = "Функция заблокирована!";
		Иначе
			ТекстШапка = "Использование функции не рекомендуется!";
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстШапка;
	
КонецФункции


мПрограммноеЗакрытие = Ложь;
