
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru='В веб-клиенте параметры прокси-сервера необходимо задавать в настройках браузера.';uk='У веб-клієнтові параметри проксі-сервера необхідно задавати в настройках браузера.'"));
	Возврат;
#КонецЕсли
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

#КонецОбласти
