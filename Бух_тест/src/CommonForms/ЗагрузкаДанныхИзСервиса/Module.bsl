///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Элемент)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗагрузкуДанных", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, , "data_dump.zip");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗагрузкуДанных(ВыборВыполнен, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если ВыборВыполнен Тогда
		
		Состояние(
			НСтр("ru='Выполняется загрузка данных из сервиса."
"Операция может занять продолжительное время, пожалуйста, подождите...';uk='Виконується завантаження даних з сервісу."
"Операція може зайняти тривалий час, будь ласка, зачекайте...'"),);
		
		ВыполнитьЗагрузку(АдресХранилища, ЗагружатьИнформациюОПользователях);
		ПрекратитьРаботуСистемы(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ВыполнитьЗагрузку(Знач АдресФайла, Знач ЗагружатьИнформацияОПользователях)
	
	УстановитьМонопольныйРежим(Истина);
	
	Попытка
		
		ДанныеАрхива = ПолучитьИзВременногоХранилища(АдресФайла);
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ДанныеАрхива.Записать(ИмяАрхива);
		
		ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьДанныхИзАрхива(ИмяАрхива, ЗагружатьИнформацияОПользователях, Истина);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяАрхива);
		
		УстановитьМонопольныйРежим(Ложь);
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		УстановитьМонопольныйРежим(Ложь);
		
		ШаблонЗаписиЖР = НСтр("ru='При загрузке данных произошла ошибка:"
""
"-----------------------------------------"
"%1"
"-----------------------------------------';uk='При завантаженні даних відбулася помилка:"
""
"-----------------------------------------"
"%1"
"-----------------------------------------'");
		ТекстЗаписиЖР = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаписиЖР, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));

		ЗаписьЖурналаРегистрации(
			НСтр("ru='Загрузка данных';uk='Завантаження даних'"),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстЗаписиЖР);

		ШаблонИсключения = НСтр("ru='При загрузке данных произошла ошибка: %1."
""
"Расширенная информация для службы поддержки записана в журнал регистрации. Если Вам неизвестна причина ошибки - рекомендуется обратиться в службу технической поддержки, предоставив для расследования выгрузку журнала регистрации и файл, из которого предпринималась попытка ззагрузить данные.';uk='При завантаженні даних відбулася помилка: %1."
""
"Розширена інформація для служби підтримки записана в журнал реєстрації. Якщо Вам невідома причина помилки - рекомендується звернутися в службу технічної підтримки, надавши для розслідування вивантаження журналу реєстрації і файл, з якого робилася спроба завантажити дані.'");

		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИсключения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецПроцедуры





