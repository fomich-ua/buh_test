//Используется в БСП/КД, дергается из макета

Функция ПолучитьВладельцаОбъектаИзБазы(Ссылка, Метаданные) Экспорт 
	
	Возврат ПолучитьРеквизитОбъектаИзБазы(Ссылка, Метаданные, "Владелец");
	
КонецФункции

Функция ПолучитьРеквизитОбъектаИзБазы(Ссылка, Метаданные, Реквизит) Экспорт 
	
	ЗапросВладельца = Новый Запрос;
	ЗапросВладельца.Текст = "
	| ВЫБРАТЬ
	| Объект." + Реквизит + "
	| ИЗ
	| " + Метаданные + " КАК Объект
	| ГДЕ
	| Объект.Ссылка = &Ссылка";
	
	ЗапросВладельца.УстановитьПараметр("Ссылка",Ссылка);
	Выборка = ЗапросВладельца.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка[Реквизит];
	
КонецФункции

Функция ПолучитьВсеПодчиненныеОрганизацииИДанную(ГоловнаяОрганизация) Экспорт
	
	Если ГоловнаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда 
		Возврат Новый Массив;
	Иначе 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
		Запрос.Текст = "ВЫБРАТЬ
			|	Организации.Ссылка КАК Организация
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	(Организации.Ссылка = &ГоловнаяОрганизация
			|	ИЛИ Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация)
			|	И НЕ Организации.ПометкаУдаления";
			
		Массив = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
		Возврат Массив;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСписокОрганизацийАссоциированныйСДанной(Организация) Экспорт
	
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда 
		Возврат Новый Массив;
	Иначе 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ГоловнаяОрганизация", Организация.ГоловнаяОрганизация);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.Текст = "ВЫБРАТЬ
			|	Организации.Ссылка КАК Организация
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	(Организации.Ссылка = &ГоловнаяОрганизация
			|	ИЛИ Организации.Ссылка = &Организация
			|	ИЛИ Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация
			|	ИЛИ Организации.ГоловнаяОрганизация = &Организация)
			|	И НЕ Организации.ПометкаУдаления";
			
		Массив = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
		Возврат Массив;

	КонецЕсли;
	
КонецФункции

Процедура ВыполнитьРегистрациюСвязанныхПрисоединенныхФайлов(Документ,Получатели,ИмяСправочника) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	| ВЫБРАТЬ РАЗЛИЧНЫЕ Спр.Ссылка
	| ИЗ
	| Справочник." + ИмяСправочника + " КАК Спр
	| ГДЕ
	| Спр.ВладелецФайла = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка",Документ);
	МассивИзСправочника = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

	Для Каждого Элемент Из МассивИзСправочника Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(Получатели,Элемент.ПолучитьОбъект())
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьОрганизациюСотрудника(Сотрудники, ДатаСведений) Экспорт
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, Сотрудники, "Организация", ДатаСведений);
	
	Если ЗначениеЗаполнено(КадровыеДанныеСотрудников) Тогда
		Возврат КадровыеДанныеСотрудников.ВыгрузитьКолонку("Организация");
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции
