#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик обновления БРО.
//
// Вызывается при первом заполнении либо в случае необходимости обновления справочника регламентированных отчетов.
//
Процедура СкрытьВосстановитьОтчеты() Экспорт
	
	ОбработкаОбновлениеОтчетов = Обработки.ОбновлениеРегламентированнойОтчетности.Создать();

	ДеревоОтчетов = ОбработкаОбновлениеОтчетов.ПолучитьСписокОтчетов();

	Если ДеревоОтчетов.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ОбработкаОбновлениеОтчетов.СкрытьВосстановитьОтчеты(ДеревоОтчетов);
	
КонецПроцедуры

// Обработчик обновления БРО 0.0.0.1, 1.0.1.41
//
Процедура ДобавитьСкрытыеОтчетыВРегистрСведений() Экспорт
	
	НачатьТранзакцию();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	УдалитьРегламентированныеОтчеты.Ссылка КАК Ссылка
						  |ИЗ
						  |	Справочник.УдалитьРегламентированныеОтчеты КАК УдалитьРегламентированныеОтчеты
						  |ГДЕ
						  | УдалитьРегламентированныеОтчеты.ЭтоГруппа = Ложь И
						  |	УдалитьРегламентированныеОтчеты.УдалитьНеПоказыватьВСписке = Истина");
						  
	ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрТаблЗнач Из ТаблицаРезультатов Цикл
		
		РеглОтчет = Справочники.РегламентированныеОтчеты.НайтиПоРеквизиту("ИсточникОтчета", СтрТаблЗнач.Ссылка.ИсточникОтчета);
		
		Если НЕ РеглОтчет.Пустая() Тогда
			
			СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
			СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = РеглОтчет.Ссылка;
			СкрытыеРегламентированныеОтчеты.УдалитьРегламентированныйОтчет = СтрТаблЗнач.Ссылка;
			СкрытыеРегламентированныеОтчеты.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
						
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Обработчик обновления БРО 1.0.1.60
//
Процедура УдалитьСкрытыеОтчетыИзРегистраСведений() Экспорт
	
	НачатьТранзакцию();
	
	СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьНаборЗаписей();
	
	СкрытыеРегламентированныеОтчеты.Прочитать();
	
	Колво = СкрытыеРегламентированныеОтчеты.Количество() - 1;
	
	Для Индекс = 0 По Колво Цикл
		
		Запись = СкрытыеРегламентированныеОтчеты.Получить(Колво - Индекс);
		
		Если Запись.РегламентированныйОтчет.Пустая() Тогда
			СкрытыеРегламентированныеОтчеты.Удалить(Запись);
		КонецЕсли;
				
	КонецЦикла;
	
	СкрытыеРегламентированныеОтчеты.Записать();
						
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецЕсли