
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		Элементы.Владелец.Вид = ВидПоляФормы.ПолеВвода;
	КонецЕсли;
	
КонецПроцедуры
