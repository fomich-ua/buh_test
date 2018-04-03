////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	КадровыйУчет.ПроверитьТекущуюТарифнуюСтавку(ЭтотОбъект, Отказ, Замещение);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	КадровыйУчет.УстановитьТекущуюТарифнуюСтавку(ЭтотОбъект, Отказ, Замещение);
	
КонецПроцедуры

#КонецЕсли
