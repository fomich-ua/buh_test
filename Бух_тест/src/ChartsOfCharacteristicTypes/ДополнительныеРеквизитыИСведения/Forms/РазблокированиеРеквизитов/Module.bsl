
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если УправлениеСвойствамиСлужебный.ДополнительноеСвойствоИспользуется(Параметры.Ссылка) Тогда
		
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектИспользуется;
		Элементы.РазрешитьРедактирование.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоРеквизита;
		Иначе
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоСведения;
		КонецЕсли;
	Иначе
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектНеИспользуется;
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоРеквизита;
		Иначе
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоСведения;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	РазблокируемыеРеквизиты.Добавить("ТипЗначения");
	
	Закрыть();
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(
		ВладелецФормы, РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
