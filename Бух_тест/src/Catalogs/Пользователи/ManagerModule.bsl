#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Служебный");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
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

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
