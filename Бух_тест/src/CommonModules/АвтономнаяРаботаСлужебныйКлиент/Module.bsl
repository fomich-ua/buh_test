////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными в модели сервиса".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверяет настройку автономного рабочего места и уведомляет об ошибке.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПерезапуститьПослеНастройкиАвтономногоРабочегоМеста") Тогда
		Параметры.Отказ = Истина;
		Параметры.Перезапустить = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПараметрыКлиента.Свойство("ОшибкаПриНастройкеАвтономногоРабочегоМеста") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Отказ = Истина;
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПриПроверкеНастройкиАвтономногоРабочегоМеста", ЭтотОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений.

// Предупреждает об ошибке настройки автономного рабочего места.
Процедура ИнтерактивнаяОбработкаПриПроверкеНастройкиАвтономногоРабочегоМеста(Параметры, Неопределен) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	СтандартныеПодсистемыКлиент.ПоказатьПредупреждениеИПродолжить(
		Параметры, ПараметрыКлиента.ОшибкаПриНастройкеАвтономногоРабочегоМеста);
	
КонецПроцедуры

#КонецОбласти
