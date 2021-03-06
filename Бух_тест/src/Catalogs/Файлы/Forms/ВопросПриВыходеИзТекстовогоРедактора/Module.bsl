
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТекстВопроса", ТекстВопроса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вернуться(Команда)
	ОповеститьОВыборе("Вернуться");
КонецПроцедуры

&НаКлиенте
Процедура НеСохранять(Команда)
	ОповеститьОВыборе("НеСохранять");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакончитьРедактирование(Команда)
	ОповеститьОВыборе("СохранитьИЗакончитьРедактирование");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	ОповеститьОВыборе("СохранитьИзменения");
КонецПроцедуры

#КонецОбласти
