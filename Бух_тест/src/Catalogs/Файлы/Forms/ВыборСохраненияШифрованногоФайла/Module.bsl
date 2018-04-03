
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СохранятьСРасшифровкой = 1;
	Заголовок = Параметры.Заголовок;
	
	Если Параметры.Свойство("ПредставленияСертификатов") Тогда
		ПредставленияСертификатов = Параметры.ПредставленияСертификатов;
	Иначе
		Элементы.ПредставленияСертификатов.Видимость = Ложь;
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки().РасширениеДляЗашифрованныхФайлов;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СохранятьСРасшифровкойПриИзменении(Элемент)
	Элементы.Пароль.Доступность = (СохранятьСРасшифровкой = 1);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	ВозвратПароль = Пароль;
	
	Если ПустаяСтрока(Пароль) И НЕ ПустаяСтрока(Элементы.Пароль.ТекстРедактирования) Тогда
		ВозвратПароль = Элементы.Пароль.ТекстРедактирования;
	КонецЕсли;	
	
	СтруктураВозврата = Новый Структура("Пароль, СохранятьСРасшифровкой, РасширениеДляЗашифрованныхФайлов", 
		ВозвратПароль, СохранятьСРасшифровкой, РасширениеДляЗашифрованныхФайлов);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

#КонецОбласти
