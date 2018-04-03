#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Комментарий");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка данных из файла

// Запрещает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла" 
// Пакетная загрузка данных в этот справочник небезопасна
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Процедура ДобавитьЗапросыНаИспользованиеВнешнихРесурсовВсехТомов(Запросы) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТомаХраненияФайлов.Ссылка КАК Ссылка,
	|	ТомаХраненияФайлов.ПолныйПутьLinux,
	|	ТомаХраненияФайлов.ПолныйПутьWindows,
	|	ТомаХраненияФайлов.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
	|ГДЕ
	|	ТомаХраненияФайлов.ПометкаУдаления = ЛОЖЬ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запросы.Добавить(ЗапросНаИспользованиеВнешнихРесурсовДляТома(
			Выборка.Ссылка, Выборка.ПолныйПутьWindows, Выборка.ПолныйПутьLinux));
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ДобавитьЗапросыНаОтменуИспользованияВнешнихРесурсовВсехТомов(Запросы) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТомаХраненияФайлов.Ссылка КАК Ссылка,
	|	ТомаХраненияФайлов.ПолныйПутьLinux,
	|	ТомаХраненияФайлов.ПолныйПутьWindows,
	|	ТомаХраненияФайлов.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запросы.Добавить(РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(
			Выборка.Ссылка));
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ЗапросНаИспользованиеВнешнихРесурсовДляТома(Том, ПолныйПутьWindows, ПолныйПутьLinux) Экспорт
	
	Разрешения = Новый Массив;
	
	Если ЗначениеЗаполнено(ПолныйПутьWindows) Тогда
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
			ПолныйПутьWindows, Истина, Истина));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПолныйПутьLinux) Тогда
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
			ПолныйПутьLinux, Истина, Истина));
	КонецЕсли;
	
	Возврат РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, Том);
	
КонецФункции

#КонецОбласти

#КонецЕсли
